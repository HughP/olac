import sys
import os
import traceback
from StringIO import StringIO
import xml.sax.xmlreader
import xml.dom
import time
import datetime
import tempfile
import MySQLdb
import pycurl
from curl import *
from optionparser import OptionParser

XSI_SCHEMA = 'http://www.w3.org/2001/XMLSchema-instance'

LOG = sys.stderr
class Logger:
    def log(self, msg):
        t = time.strftime("[%Y-%m-%d %H:%M:%S]", time.localtime())
        joiner = "\n%s " % t
        print >>LOG, t, joiner.join(msg.split('\n'))


########################
## Database Interface ##
########################

class DBI(Logger):
    def __init__(self, conn):
        self.con = conn
        self.cur = conn.cursor()
        self.count = 0

        self.recordCount = 0
        self.newRecordCount = 0
        self.updatedRecordCount = 0
        self.repoid = None
        self.archiveid = None
        
        # OLAC schema ID table
        sql = "select Xmlns, Schema_ID from SCHEMA_VERSION"
        self.cur.execute(sql)
        self.olacschema = dict(self.cur.fetchall())

        # Metadata element tag ID table
        sql = "select TagName, Tag_ID from ELEMENT_DEFN"
        self.cur.execute(sql)
        self.tagids = dict(self.cur.fetchall())

        # Extension ID table
        sql = "select NS, Type, Extension_ID from EXTENSION"
        self.cur.execute(sql)
        self.extids = dict([((r[0],r[1]), r[2]) for r in self.cur.fetchall()])
        self.extids[None,None] = self.extids['','']

    def processIdentify(self, record):
        dbrecord = {}
        dbfields = {}
        for dbfield in ('ArchiveURL',
                        'Curator',
                        'CuratorTitle',
                        'CuratorEmail',
                        'Institution',
                        'InstitutionURL',
                        'ShortLocation',
                        'Location',
                        'Synopsis',
                        'Access',
                        'ArchivalSubmissionPolicy',
                        'RepositoryName',
                        'BaseURL',
                        'OaiVersion',
                        'AdminEmail',
                        'RepositoryIdentifier',
                        'SampleIdentifier',
                        'ArchiveType',
                        'CurrentAsOf'):
            key = dbfield[0].lower() + dbfield[1:]
            dbrecord[dbfield] = record[key]

        repoid = dbrecord['RepositoryIdentifier']
        self.log("repository id: %s" % repoid)
        sql = "select Archive_ID from OLAC_ARCHIVE where RepositoryIdentifier=%s"
        self.cur.execute(sql, repoid)
        if self.cur.rowcount > 0:
            self.log("%s already exists" % repoid)
            # just update
            archiveid = self.cur.fetchone()[0]
            L = dbrecord.items()
            fields = ','.join(["%s=%%s" % r[0] for r in L])
            values = [r[1] for r in L] + [archiveid]
            sql = 'update OLAC_ARCHIVE set %s where Archive_ID=%%s' % fields
            self.cur.execute(sql, values)
            if self.cur.rowcount > 0:
                self.log("some fields of OLAC_ARCHIVE table have been updated")
            else:
                self.log("no changes made to the OLAC_ARCHIVE table")
        else:
            self.log("%s is a new archive" % repoid)
            # new archive
            L = dbrecord.items()
            fields = '(' + ','.join([r[0] for r in L]) +')'
            values = '(' + ','.join(['%s'] * len(L)) + ')'
            sql = 'insert into OLAC_ARCHIVE %s values %s' % (fields,values)
            self.cur.execute(sql, [r[1] for r in L])
            archiveid = self.cur.lastrowid
        self.archiveid = archiveid
        self.repoid = repoid
        self.newRecordCount = 0
        self.updatedRecordCount = 0
        self.recordCount = 0
        self.con.commit()

    def processRecord(self, record):
        self.recordCount += 1
        try:
            schemaid = self.olacschema[record.olacSchema()]
        except KeyError:
            # this record uses unknown schema
            # --> do not harvest
            return

        sql = "select Item_ID from ARCHIVED_ITEM where OaiIdentifier=%s"
        oaiid = record.oaiId()
        self.cur.execute(sql, oaiid)
        flagUpdateMetadata = False
        if self.cur.rowcount > 0:
            # record with the same id exists
            # --> update
            itemid = self.cur.fetchone()[0]
            sql = "update ARCHIVED_ITEM set " \
                  "OaiIdentifier=%s,DateStamp=%s,Archive_ID=%s,Schema_ID=%s " \
                  "where Item_ID=%s"
            args = (oaiid, record.datestamp(), self.archiveid, schemaid, itemid)
            self.cur.execute(sql, args)
            if self.cur.rowcount > 0:
                self.updatedRecordCount += 1
                flagUpdateMetadata = True
                sql = "delete from METADATA_ELEM where Item_ID=%s"
                self.cur.execute(sql, itemid)
        else:
            # new record
            # --> insert
            args = (oaiid, record.datestamp(), self.archiveid, schemaid)
            sql = "insert into ARCHIVED_ITEM " \
                  "(OaiIdentifier, DateStamp, Archive_ID, Schema_ID) " \
                  "values (%s, %s, %s, %s)"
            self.cur.execute(sql, args)
            itemid = self.cur.lastrowid
            flagUpdateMetadata = True
            self.newRecordCount += 1
        
        if flagUpdateMetadata:
            for row in record.metadataElements():
                tagName, extSchema, extType, extCode, content = row

                try:
                    tagid = self.tagids[tagName]
                except KeyError:
                    # this element uses invalid tag
                    # --> skip it
                    continue

                try:
                    extid = self.extids[extSchema, extType]
                except KeyError:
                    # this is a new extension
                    # --> add it
                    sql = "insert ignore into EXTENSION (Type, NS) values (%s, %s)"
                    self.cur.execute(sql, (extType, extSchema))
                    extid = self.cur.lastrowid
                    self.extids[extSchema, extType] = extid

                sql = "insert into METADATA_ELEM " \
                      "(TagName, Content, Extension_ID, Type, Code, Item_ID, Tag_ID) " \
                      "values (%s, %s, %s, %s, %s, %s, %s)"
                args = (tagName, content, extid, extType, extCode, itemid, tagid)
                self.cur.execute(sql, args)
            
        self.count += 1
        if self.count % 100 == 0:
            self.con.commit()
            
    def counts(self):
        return self.recordCount, \
               self.newRecordCount, \
               self.updatedRecordCount

    def repositoryId(self):
        return self.repoid

    def archiveId(self):
        return self.archiveid

    def lastHarvested(self):
        if self.archiveid is not None:
            sql = "select LastHarvested from OLAC_ARCHIVE where Archive_ID=%s"
            self.cur.execute(sql, self.archiveid)
            return self.cur.fetchone()[0]
        
    def __del__(self):
        # NOTE: make sure that this gets called
        self.con.commit()

##
##
######################################################################


class Request:
    """
    Generate OAI request URLs.
    """
    
    def __init__(self, baseurl, metadataPrefix):
        """
        @param fromDate: a datetime.datetime object
        """
        self.baseurl = baseurl
        self.metadataPrefix = metadataPrefix

    def baseUrl(self):
        return self.baseurl
    
    def Identify(self):
        return "%s?verb=Identify" % self.baseurl
    
    def ListRecords(self, resumptionToken=None, fromDate=None):
        url = "%s?verb=ListRecords" % self.baseurl
        if resumptionToken:
            url += "&resumptionToken=%s" % resumptionToken
        else:
            url += "&metadataPrefix=%s" % self.metadataPrefix
            if fromDate:
                url += "&from=%s" % fromDate.strftime("%Y-%m-%dT%H:%M:%SZ")
        return url


class Identify:
    """
    This is a dictionary-like representation of an Identify response.
    Fields can be accessed by the XML element name.
    """
    def __init__(self, xmldata):
        self.data = xmldata
        self.archiveType = None
        self.currentAsOf = None
        if 'olac-archive' in self.data:
            for schema, name, vschema, v in self.data['olac-archive'][1]:
                if name == 'type':
                    self.archiveType = v
                elif name == 'currentAsOf':
                    self.currentAsOf = v
        
    def __getitem__(self, key):
        if key in self.data:
            return ''.join(self.data[key][2])
        elif key in ('type', 'archiveType'):
            return self.archiveType
        elif key == 'currentAsOf':
            return self.currentAsOf
        elif key == 'oaiVersion':
            if 'protocolVersion' in self.data:
                return ''.join(self.data['protocolVersion'][2])
            
    
class Record:
    """
    This represents an OLAC GetRecord element.
    """
    def __init__(self, header, olac):
        self.header = header    # (ns,name,attrs,body)
        self.olac = olac        # (ns,name,attrs,body)

        self.olacSchema_ = self._extract(header, 'name', 'olac', 'schema')
        self.oaiId_ = self._extract(header, 'name', 'identifier', 'body')
        self.datestamp_ = self._extract(header, 'name', 'datestamp', 'body')

    def _extract(self, L, searchField, searchValue, returnField):
        fields = ["schema", "name", "attributes", "body"]
        try:
            i = fields.index(searchField)
            j = fields.index(returnField)
        except ValueError:
            return
        for row in L:
            if row[i] == searchValue:
                return row[j]
            
    def metadataElements(self):
        for ns, tagName, attrs, content in self.olac:
            extType = None
            extSchema = None
            extCode = None
            for attns, att, xsiTypeNs, attval in attrs:
                if attns==XSI_SCHEMA and att=='type' and xsiTypeNs is not None:
                    extType = attval
                    extSchema = xsiTypeNs
                    for a,b,c,d in attrs:
                        if a==extSchema and b=='code':
                            extCode = d
            yield tagName, extSchema, extType, extCode, content

    def olacSchema(self):
        return self.olacSchema_

    def oaiId(self):
        return self.oaiId_

    def datestamp(self):
        return self.datestamp_

    
class Namespace:
    """
    Namespace object keeps track of the XML namespaces in an XML document.
    """
    def __init__(self):
        self.nsStack = []

    def push(self, tag, attrs):
        """
        Process namespace-related attributes and return unused attributes.
        """
        prefixDict = {}
        schemaLocation = {}
        schemaLocationCands = []
        rest = {}
        for att in attrs.getNames():
            if att == 'xmlns':
                prefixDict[0] = attrs.getValue(att)
            elif att.startswith('xmlns'):
                _, prefix = att.split(':')
                prefixDict[prefix] = attrs.getValue(att)
            elif att.endswith(':schemaLocation'):
                prefix = att.split(':')[0]
                schemaLocationCands.append((prefix,attrs.getValue(att)))
            else:
                rest[att] = attrs.getValue(att)
        h = self.prefixes()
        for prefix, s in schemaLocationCands:
            if (prefix in prefixDict and prefixDict[prefix] == XSI_SCHEMA) or \
               (prefix in h and h[prefix] == XSI_SCHEMA):
                L = s.strip().split()
                try:
                    for i in range(0,len(L),2):
                        schemaLocation[L[i]] = L[i+1]
                except IndexError:
                    # the value of xsi:schemaLocation is invalid
                    # there must be an even number of tokens
                    pass
                break
        self.nsStack.append((prefixDict,schemaLocation))

        atts = []
        elSchema, elName = self.resolve(tag)
        for att, v in rest.items():
            if ':' in att:
                schema, att = self.resolve(att)
            else:
                schema = elSchema
            if schema is not None and schema in XSI_SCHEMA and att=='type':
                vSchema, v = self.resolve(v)
            else:
                vSchema = None
            atts.append((schema, att, vSchema, v))
        return elSchema, elName, atts
    
    def pop(self):
        self.nsStack.pop()

    def find(self, prefix):
        for i in range(len(self.nsStack)-1,-1,-1):
            if prefix in self.nsStack[i][0]:
                return self.nsStack[i][0][prefix]

    def findSchemeLocation(self, schema):
        for i in range(len(self.nsStack)-1,-1,-1):
            if schema in self.nsStack[i][1]:
                return self.nsStack[i][1][schema]

    def prefixes(self):
        h = {}
        for i in range(len(self.nsStack)-1,-1,-1):
            for k,v in self.nsStack[i][0].items():
                if k not in h:
                    h[k] = v
        return h

    def schemaLocations(self):
        h = {}
        for i in range(len(self.nsStack)-1,-1,-1):
            for k,v in self.nsStack[i][1].items():
                if k not in h:
                    h[k] = v
        return h

    def resolve(self, qname):
        if ':' in qname:
            prefix, name = qname.split(':')
        else:
            prefix = 0
            name = qname
        schema = self.find(prefix)
        return schema, name

    def resolveAttribute(self, qname, tag):
        """
        @param qname: Here qname should come from an attribute value.
        @param tag: The tag of the element to which the qname belongs.
        """
        if ':' in qname:
            prefix, name = qname.split(':')
            schema = self.find(prefix)
        else:
            name = qname
            schema, _ = self.resolve(tag)
        return schema, name


class IdentifyHandler(Logger, xml.sax.handler.ContentHandler):
    """
    Calls identifyHandler with an Identify object (defined above)
    after parsing the Identify reponse.
    """
    def __init__(self, identifyHandler):
        xml.sax.handler.ContentHandler.__init__(self)
        self.identifyHandler = identifyHandler
        self.reset()

    def reset(self):
        self.data = {}
        self.names = []
        self.ns = Namespace()
        
    def startElement(self, tag, attrs):
        schema, name, atts = self.ns.push(tag, attrs)
        self.names.append(name)
        self.data[name] = [name, atts, []]

    def characters(self, content):
        self.data[self.names[-1]][-1].append(content)

    def endElement(self, tag):
        schema, name = self.ns.resolve(tag)
        self.names.pop()
        self.ns.pop()

    def endDocument(self):
        self.log("parsing Identify response done")
        self.log("processing Identify response")
        identify = Identify(self.data)
        self.identifyHandler(identify)

            
class ListRecordsHandler(Logger, xml.sax.handler.ContentHandler):
    """
    Calls recordHandler with a Record object as it parses through
    the ListRecords response.
    """
    def __init__(self, recordHandler, resumptionTokenHandler):
        xml.sax.handler.ContentHandler.__init__(self)
        self.recordHandler = recordHandler
        self.resumptionTokenHandler = resumptionTokenHandler
        self.reset()

    def reset(self):
        self.flag = False
        self.names = []
        self.ns = Namespace()
        
    def startElement(self, tag, attrs):
        schema, name, atts = self.ns.push(tag, attrs)

        self.names.append(name)
        if name == 'record':
            self.build = []
        elif name == 'header':
            self.build.append([[(schema,name,atts)]])
            self.flag = True
        elif name == 'olac':
            # append the opening element to the 'header' record
            # this is used to figure out the version of olac schema
            self.build[-1].append([(schema,name,atts)])
            # create a new 'olac' record
            self.build.append([])
            self.flag = True
        elif name == 'resumptionToken':
            self.resumptionToken = ''
        elif self.flag:
            self.build[-1].append([(schema,name,atts)])

    def characters(self, content):
        if self.flag:
            if self.names[-1] not in ('header','olac'):
                self.build[-1][-1].append(content)
        elif self.names[-1] == 'resumptionToken':
            self.resumptionToken += content
            
    def endElement(self, tag):
        schema, name = self.ns.resolve(tag)
        
        if name == 'record':
            record = self.createRecord()
            #self.log("processing record: %s" % record.oaiId())
            self.recordHandler(record)
        elif name in ('header','olac'):
            self.flag = False
        elif name == 'resumptionToken':
            token = self.resumptionToken.strip()
            if token:
                #self.log("resumption token found: %s" % token)
                self.resumptionTokenHandler(token)
        self.names.pop()
        self.ns.pop()

    def createRecord(self):
        result = []
        for L in self.build:
            x = []      # (na,name,attrs,body)
            for r in L:
                schema, elName, atts = r[0]
                body = ''.join(r[1:])
                x.append((schema, elName, atts, body))
            result.append(x)
        return Record(result[0], result[1])
    

class StreamParser(Logger):
    def __init__(self, handler):
        self.xmlReader = xml.sax.make_parser()
        self.xmlReader.setContentHandler(handler)

    def feed(self, data):
        try:
            self.xmlReader.feed(data)
            # it's okay to return None instead of the size consumed data
        except xml.sax.SAXParseException, e:
            msg = "parse error: %s" % e.getException()
            self.log(msg)
            return -1

    def close(self):
        try:
            self.xmlReader.close()
            return True
        except xml.sax._exceptions.SAXParseException, e:
            self.log("document closed unexpectedly: %s" % e)
            return False

        
class Harvester(Logger):
    def __init__(self, baseurl, handler, fullHarvest=False):
        self.request = Request(baseurl, 'olac')
        self.handler = handler
        self.identifyHandler = handler.processIdentify
        self.recordHandler = handler.processRecord
        self.fullHarvest = fullHarvest
        
    def _httpStatus(self, data):
        code = data.split()[1]
        if code != '200' and code !='302':
            self.log("http error: %s" % code)
            raise StopFetching()

    def _download(self, handler, url, retry):
        parser = StreamParser(handler)
        curl = MyCurl(parser.feed, self._httpStatus)
        try:
            curl.fetch(MyUrl(url))
            return parser.close()
        except pycurl.error, e:
            self.log("pycurl error: %s" % e)
            if e[0] == 28 and retry > 0:
                parser.close()
                handler.reset()
                self.log("retrying...")
                return self._download(handler, url, retry-1)
            else:
                parser.close()
                return False

    def harvest(self):
        self.log("harvester running on %s" % os.uname()[1])
        self.log("harvesting from %s" % self.request.baseUrl())
        handler = IdentifyHandler(self.identifyHandler)
        url = self.request.Identify()
        self.log("fetching and processing: %s" % url)
        if not self._download(handler, url, 2):
            self.log("harvest failed")
            return False

        if self.fullHarvest:
            fromDate = None
        else:
            fromDate = self.handler.lastHarvested()
        urls = [self.request.ListRecords(fromDate=fromDate)]
        rtHandler = lambda x: urls.append(self.request.ListRecords(x))
        while urls:
            handler = ListRecordsHandler(self.recordHandler, rtHandler)
            url = urls.pop()
            self.log("fetching and processing: %s" % url)
            if not self._download(handler, url, 3):
                self.log("harvest failed")
                return False

        self.log("harvest successful")
        return True


######################################################################
## Application code starts here
##

def make_connection():
    return MySQLdb.connect(read_default_file="~/.my.cnf",
                           host="dbm", db="olac2",
                           use_unicode=True, charset="utf8")

def update_last_harvested(con, archiveid, now):
    cur = con.cursor()
    sql = "update OLAC_ARCHIVE set LastHarvested=%s where Archive_ID=%s"
    cur.execute(sql, (archiveid, now))
    con.commit()
    cur.close()

def harvest(url, con, full=False):
    dbi = DBI(con)

    h = Harvester(url, dbi, full)

    try:
        now = datetime.datetime.now()
        if h.harvest():
            update_last_harvested(con, dbi.archiveId(), now)
    except:
        msg = traceback.format_exc()
        msg = "\nUnexpected error in the harvester code:\n\n%s\n\n" % msg
        h.log(msg)

    repoid = dbi.repositoryId()
    rc, nrc, urc = dbi.counts()
    h.log("processed %d records (this may include retries)" % rc)
    h.log("new records: %d" % nrc)
    h.log("updated records: %d" % urc)

def harvest_single(url, mycnf, host=None, db=None, full=False):
    opts = {"read_default_file":mycnf, "use_unicode":True, "charset":"utf8"}
    if host: opts["host"] = host
    if db: opts["db"] = db
    con = MySQLdb.connect(**opts)
    harvest(url, con, full)

def harvest_all(mycnf, host=None, db=None, full=False, numProc=5):
    opts = {"read_default_file":mycnf, "use_unicode":True, "charset":"utf8"}
    if host: opts["host"] = host
    if db: opts["db"] = db
    con = MySQLdb.connect(**opts)
    cur = con.cursor()
    cur.execute("select BASEURL from ARCHIVES order by rand()")
    urls = list([x[0] for x in cur.fetchall()])
    cur.close()
    con.close()
    
    logs = {}
    P = {}
    def printlog(pid):
        url = P[pid]
        log = logs[url]
        print >>sys.stderr, "**********************************************************************"
        print >>sys.stderr, url
        print >>sys.stderr, "**********************************************************************"
        print >>sys.stderr, file(log).read()
        print >>sys.stderr
        print >>sys.stderr
        os.unlink(log)
    if numProc < 1:
        N = 1
    elif numProc > 10:
        N = 10
    else:
        N = numProc
    while urls:
        url = urls.pop()
        logs[url] = tempfile.mktemp()

        pid = os.fork()
        if pid == 0:
            global LOG
            LOG = file(logs[url], "w")
            harvest_single(url, mycnf, host, db, full)
            sys.exit(0)
        else:
            P[pid] = url
            if len(P) >= N:
                pid, status = os.wait()
                printlog(pid)
                del P[pid]

    while P:
        pid, status = os.wait()
        printlog(pid)
        del P[pid]

        

if __name__ == "__main__":
    usageString = """\
Usage: %(prog)s [-h] -c <mycnf> [-H <host>] [-d <db>] [-f]

    options:

      -h          print this message and exit
      -c <mycnf>  mycnf file
      -H <host>   hostname of the mysql server
      -d <db>     name of the olac database
      -f          full harvest if this option presents

""" % {"prog":os.path.basename(sys.argv[0])}
    
    def usage(msg=None):
        print >>sys.stderr, usageString
        if msg:
            print >>sys.stderr, "ERROR:", msg
            print >>sys.stderr
        sys.exit(1)
        
    op = OptionParser(
        "*-h",
        "-c:",
        "*-H:",
        "*-d:",
        "*-f"
        )
    try:
        op.parse(sys.argv[1:])
    except OptionParser.ParseError, e:
        usage(e.message)
    if op.get('-h'): usage()
    
    mycnf = op.getOne('-c')
    host = op.getOne('-H')
    db = op.getOne('-d')
    full = bool(op.get('-f'))
    harvest_all(mycnf, host, db, full=full)
