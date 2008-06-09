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
try:
    from optionparser import OptionParser
except ImportError:
    print >>sys.stderr, """
Can't find the 'optionparser' module, which can be obtained from here:
http://olac.svn.sourceforge.net/viewvc/*checkout*/web/lib/python/optionparser.py
"""
    sys.exit(1)

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

        # ISO 639-1 table
        sql = "select Part1, Id from ISO_639_3 where Part1 is not null"
        self.cur.execute(sql)
        self.ISO_639_1 = dict([r for r in self.cur.fetchall()])

        # ISO 639-2B table
        sql = "select Part2B, Id from ISO_639_3 where Part2B is not null"
        self.cur.execute(sql)
        self.ISO_639_2B = dict([r for r in self.cur.fetchall()])

        # ISO 639-2T table
        #sql = "select Part2T, Id from ISO_639_3 where Part2T is not null"
        #self.cur.execute(sql)
        #self.ISO_639_2T = dict([r for r in self.cur.fetchall()])
        
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

        sql = "select Name,Role,Email from ARCHIVE_PARTICIPANT where Archive_ID=%s"
        self.cur.execute(sql, archiveid)
        L = sorted(self.cur.fetchall())
        M = sorted([tuple(r) for r in record['participants']])
        if L != M:
            sql = "delete from ARCHIVE_PARTICIPANT where Archive_ID=%s"
            self.cur.execute(sql, archiveid)
            sql = "insert ignore into ARCHIVE_PARTICIPANT values (%s,%s,%s,%s)"
            for name, role, email in M:
                self.cur.execute(sql, (archiveid, name, role, email))
            self.log("participant list has changed")
    
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
                    sql = "insert ignore into EXTENSION (Type, NS, NSSchema) values (%s, %s, %s)"
                    try:
                        self.cur.execute(sql, (extType, extSchema, extSchema.location()))
                    except Exception, e:
                        self.log("")
                        self.log("db error: error while executing a query")
                        self.log("db error: query:  %s" % sql)
                        self.log("db error: error:  %s" % e)
                        self.log("")
                        raise
                    extid = self.cur.lastrowid
                    self.extids[extSchema, extType] = extid

                # translate ISO 639-1/2B codes to 639-3 equivalets
                # NOTE: what about ISO 639-2T?
                if extType == 'language':
                    #if extCode in self.ISO_639_2T:
                    #    extCode = self.ISO_639_2T[extCode]
                    if extCode in self.ISO_639_2B:
                        extCode = self.ISO_639_2B[extCode]
                    elif extCode in self.ISO_639_1:
                        extCode = self.ISO_639_1[extCode]
                        
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
        archiveType = None
        currentAsOf = None
        participants = []
        self.data = {}
        for name, atts, contents in xmldata:
            if name == 'olac-archive':
                for schema, attname, vschema, v in atts:
                    if attname == 'type':
                        archiveType = v
                    elif attname == 'currentAsOf':
                        currentAsOf = v
            elif name == 'participant':
                h = dict([(f,v) for _,f,_,v in atts])
                participants.append([h['name'],h['role'],h['email']])
            else:
                self.data[name] = ''.join(contents)
        self.data['type'] = archiveType
        self.data['archiveType'] = archiveType
        self.data['currentAsOf'] = currentAsOf
        try:
            self.data['oaiVersion'] = self.data['protocolVersion']
        except KeyError:
            self.data['oaiVersion'] = None
        self.data['participants'] = participants
            
    def __getitem__(self, key):
        if key in self.data:
            return self.data[key]

    
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


class Schema:
    def __init__(self, uri, loc=None):
        self.uri_ = uri
        self.loc_ = loc

    def __str__(self):
        return self.uri_

    def __hash__(self):
        return hash(self.uri_)

    def __cmp__(self, v):
        if isinstance(v,Schema):
            return cmp(self.uri_,v.uri_)
        else:
            return cmp(self.uri_,v)

    def __eq__(self, v):
        if isinstance(v,Schema):
            return self.uri_ == v.uri_
        else:
            return self.uri_ == v
    
    def uri(self):
        return self.uri_

    def location(self):
        return self.loc_

    def setLocation(self, loc):
        self.loc_ = loc


class Environment:
    def __init__(self):
        self.stack = []

    def push(self, dic={}):
        self.stack.append(dic)

    def pop(self):
        if self.stack:
            self.stack.pop()

    def toDict(self):
        h = {}
        for h1 in self.stack:
            h.update(h1)
        return h
    
    def __setitem__(self, name, value):
        if self.stack:
            self.stack[-1][name] = value

    def __getitem__(self, name):
        for i in range(len(self.stack)-1,-1,-1):
            h = self.stack[i]
            if name in h:
                return h[name]

    def __contains__(self, name):
        for i in range(len(self.stack)-1,-1,-1):
            if name in self.stack[i]:
                return True
        return False

    
class Namespace:
    """
    Namespace object keeps track of the XML namespaces in an XML document.
    """
    def __init__(self):
        self.schemaLocs = Environment()
        self.schemas = Environment()

    def push(self, tag, attrs):
        """
        Process namespace-related attributes and return unused attributes.
        """
        prefixDict = {}
        schemaLocationCands = []
        rest = {}   # unprocessed attributes
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
        self.schemaLocs.push()
        for prefix, s in schemaLocationCands:
            if (prefix in prefixDict and prefixDict[prefix] == XSI_SCHEMA) or \
               (prefix in self.schemas and self.schemas[prefix] == XSI_SCHEMA):
                L = s.strip().split()
                # in case len(L) is an odd number
                if len(L)/2*2 != len(L): L.append(None)
                for i in range(0,len(L),2):
                    self.schemaLocs[L[i]] = L[i+1]
        self.schemas.push()
        for prefix, schema in prefixDict.items():
            schemaObj = Schema(schema, self.schemaLocs[schema])
            self.schemas[prefix] = schemaObj

        atts = []
        elSchema, elName = self.resolve(tag)
        for att, v in rest.items():
            if ':' in att:
                schema, att = self.resolve(att)
            else:
                schema = elSchema
            if schema is not None and str(schema) in XSI_SCHEMA and att=='type':
                vSchema, v = self.resolve(v)
            else:
                vSchema = None
            atts.append((schema, att, vSchema, v))
        return elSchema, elName, atts
    
    def pop(self):
        self.schemaLocs.pop()
        self.schemas.pop()

    def find(self, prefix):
        return self.schemas[prefix]

    def findSchemeLocation(self, schema):
        return self.schemaLocs[schema]

    def prefixes(self):
        return self.schemas.toDict()

    def schemaLocations(self):
        return self.schemaLocs.toDict()

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
        self.data = []
        self.stack = []
        self.ns = Namespace()
        
    def startElement(self, tag, attrs):
        schema, name, atts = self.ns.push(tag, attrs)
        self.data.append([name, atts, []])
        self.stack.append(len(self.data)-1)

    def characters(self, content):
        self.data[self.stack[-1]][-1].append(content)

    def endElement(self, tag):
        #schema, schemaLoc, name = self.ns.resolve(tag)
        self.stack.pop()
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
    sql = "update OLAC_ARCHIVE set LastHarvested=now() where Archive_ID=%s"
    cur.execute(sql, archiveid)
    con.commit()
    cur.close()

def harvest(url, con, full=False):
    dbi = DBI(con)

    h = Harvester(url, dbi, full)

    try:
        now = datetime.datetime.now()
        if h.harvest():
            update_last_harvested(con, dbi.archiveId(), now)
            rc, nrc, urc = dbi.counts()
            h.log("processed %d records (this may include retries)" % rc)
            h.log("new records: %d" % nrc)
            h.log("updated records: %d" % urc)
            con.commit()
        else:
            con.rollback()
    except:
        msg = traceback.format_exc()
        msg = "\nUnexpected error in the harvester code:\n\n%s\n\n" % msg
        h.log(msg)

def harvest_single(url, mycnf, host=None, db=None, full=False):
    opts = {"read_default_file":mycnf, "use_unicode":True, "charset":"utf8"}
    if host: opts["host"] = host
    if db: opts["db"] = db
    con = MySQLdb.connect(**opts)
    harvest(url, con, full)
    con.close()

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
