import sys
import os
import re
import urlparse
import socket
import time
import OpenSSL
import MySQLdb
try:
    from optionparser import OptionParser
except ImportError:
    print >>sys.stderr, """
Can't find the 'optionparser' module, which can be obtained from here:
http://olac.svn.sourceforge.net/viewvc/*checkout*/web/lib/python/optionparser.py
"""
    sys.exit(1)

__all__ = [
    "check_urls",
    "check_broken_reference",
    "check_non_unique_identifier",
    "check_bad_sample_identifier",
    "check_invalid_code",
    "check_language_code"
    ]

def log(msg):
    return
    print "LOG:", msg
    
class FtpChecker:
    def __call__(self, url, debug=False):
        self.debug = debug

        # login
        o = urlparse.urlparse(url)
        if o.username:
            user = o.username
        else:
            user = 'anonymous'
        if o.password:
            password = o.password
        else:
            password = 'test'
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            self.sock.connect((o.hostname,21))
        except socket.error, e:
            log("%s" % e[1])
            return False
        data, code = self.readCcon()
        if code != '220':
            log(data.strip().split('\r\n')[-1])
            return False
        data, code = self.cconCmd('USER', user)
        if code == '331':
            self.cconCmd('PASS', password)
        elif code != '230':
            log(data.strip().split('\r\n')[-1])
            return False
        data = self.dconCmd('LIST', o.path)
        self.cconCmd('QUIT')
        return (not not data)
            
    def cconCmd(self, *args):
        command = " ".join(args)+'\n'
        if self.debug: log(">> %s" % command[:-1])
        self.sock.send(command)
        return self.readCcon()
    
    def dconCmd(self, *args):
        res, code = self.cconCmd('PASV')
        if code == '227':
            command = ' '.join(args)+'\n'
            if self.debug: log(">> %s" % command[:-1])
            self.sock.send(command)
            dcon = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            dcon.connect(self.parsePasvResponse(res))
            data = self.readDcon(dcon)
            dcon.send('\n')
            dcon.close()
            while self.readCcon()[1]!='226': time.sleep(1)
            return data
        else:
            pass    # error
    
    def parsePasvResponse(self, res):
        m = re.search(r'((?:\d+,){5}\d+)', res)
        a = m.group(1).split(',')
        addr = '.'.join(a[:4])
        port = int(a[4])*256 + int(a[5])
        return addr, port

    def readCcon(self):
        data = ''
        while True:
            tmp = self.sock.recv(1024)
            while len(tmp) >= 1024:
                data += tmp
                tmp = self.sock.recv(1024)
            data += tmp
            
            if data.endswith('\r\n'):
                i = data.rfind('\n',0,len(data)-1) + 1
                m = re.match(r"^(\d{3}) ", data[i:])
                if m: break

        if self.debug:
            for l in data.split('\r\n'):
                log(".. %s" % l)
                
        return data, m.group(1)

    def readDcon(self, sock):
        data = ''
        while True:
            newdata = ''
            tmp = sock.recv(1024)
            while len(tmp) >= 1024:
                newdata += tmp
                tmp = sock.recv(1024)
            newdata += tmp

            if newdata:
                data += newdata
                time.sleep(1)
            else:
                break

        if self.debug:
            for l in data.split('\r\n'):
                log(".. %s" % l)

        return data
    

class HttpChecker:
    def __call__(self, url, debug=False):
        self.debug = debug
        self.fragment = None
        while True:
            try:
                data = self.fetch(url)
            except socket.error, e:
                log("%s" % e[1])
                return e[0]
            L = data.split('\r\n')
            code = L[0].split()[1]
            if code in ('301','302'):
                for line in L[1:]:
                    if not line.strip():
                        return code
                    i = line.find(':')
                    k = line[:i]
                    v = line[i+1:]
                    if k.lower() == 'location':
                        url = v.strip()
                        break
                else:
                    return code
            else:
                return code

    def fetch(self, url):
        o = urlparse.urlparse(url)
        if o.port:
            port = int(o.port)
        else:
            port = 80
        if o.query:
            path = o.path + '?' + o.query
        else:
            path = o.path
        if o.fragment:
            self.fragment = o.fragment
        if self.fragment:
            path += '#' + self.fragment
        if not path:
            path = '/'
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        if o.scheme == 'http':
            self.sock.connect((o.hostname,port))
        elif o.scheme == 'https':
            ctx = OpenSSL.SSL.Context(OpenSSL.SSL.SSLv23_METHOD)
            self.sock = OpenSSL.SSL.Connection(ctx, sock)
        else:
            raise ValueError("unknown protocol: %s" % o.scheme)
        if self.debug:
            log('>> HEAD %s HTTP/1.1' % path)
            log('>> Host: %s' % o.hostname)
        self.sock.send('HEAD %s HTTP/1.1\n' % path)
        self.sock.send('Host: %s\n' % o.hostname)
        self.sock.send('\n')
        data = self.read()
        self.sock.close()
        return data
        
    def read(self):
        data = ''
        while True:
            newdata = ''
            tmp = self.sock.recv(1024)
            while len(tmp) >= 1024:
                newdata += tmp
                tmp = self.sock.recv(1024)
            newdata += tmp

            if newdata:
                data += newdata
                break
                time.sleep(0.01)
            else:
                break

        if self.debug:
            for l in data.split('\r\n'):
                log(".. %s" % l)

        return data


#
# RNF, RNA
#
def check_urls(con, archive_id=None):
    ftp_check = FtpChecker()
    http_check = HttpChecker()

    pat = re.compile(r"((?:f|ht)tps?://\S+)")
    cur = con.cursor()
    if archive_id is None:
        cur.execute("select me.Element_ID, Content from METADATA_ELEM me left join INTEGRITY_CHECK ic on me.Element_ID=ic.Object_ID where Content regexp '(f|ht)tps?://.*' and (IntegrityChecked is null or timestampdiff(day,IntegrityChecked,now())>1) order by rand()")
    else:
        cur.execute("select me.Element_ID, Content from METADATA_ELEM me left join ARCHIVED_ITEM ai on me.Item_ID=ai.Item_ID left join INTEGRITY_CHECK ic on me.Element_ID=ic.Object_ID where ai.Archive_ID=%s and Content regexp '(f|ht)tps?://.*' and (IntegrityChecked is null or timestampdiff(day,IntegrityChecked,now())>1) order by rand()", archive_id)
    for row in cur.fetchall():
        url = pat.search(row[1]).group(1)
        log('checking: %s' % url)
        sqls = [("delete from INTEGRITY_CHECK where Object_ID=%s and (Problem_Code='RNA' or Problem_Code='RNF')", (row[0],))]
        if url.startswith('ftp'):
            res = ftp_check(url)
            if not res:
                sql = "insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code) values (%s, %s, 'RNA')"
                sqls.append((sql,(row[0],url)))
        elif url.startswith('http'):
            try:
                res = http_check(url)
            except Exception, e:
                log("%s" % e)
                continue
            if res != '200':
                if res == '404':
                    sql = "insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code) values (%s, %s, 'RNF')"
                    sqls.append((sql, (row[0],url)))
                else:
                    sql = "insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code) values (%s, %s, 'RNA')"
                    sqls.append((sql, (row[0],url)))
        else:
            sql = "insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code) values (%s, %s, 'RNF')"
            sqls.append((sql, (row[0],url)))
        for sql, args in sqls:
            cur.execute(sql, args)
        con.commit()
    cur.close()

#
# NSI
#
def check_broken_reference(con, archive_id=None):
    cur = con.cursor()
    if archive_id is None:
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code='NSI'",
            """\
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, Content, 'NSI'
            from METADATA_ELEM me
              left join ARCHIVED_ITEM ai on me.Content=ai.OaiIdentifier
            where me.Content regexp '^oai:[^:]+:[^:]+$' and ai.Item_ID is null
            """,
            ]
    else:
        sqls = [
            """\
            delete ic.* from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai
            where ic.Object_ID=me.Element_ID and me.Item_ID=ai.Item_ID and ai.Archive_ID=%d and Problem_Code='NSI'
            """ % archive_id,
            """\
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, Content, 'NSI'
            from METADATA_ELEM me
              left join ARCHIVED_ITEM ai2 on me.Item_ID=ai2.Item_ID
              left join ARCHIVED_ITEM ai on me.Content=ai.OaiIdentifier
            where me.Content regexp '^oai:[^:]+:[^:]+$' and ai.Item_ID is null and ai2.Archive_ID=%s
            """ % archive_id,
            ]
    for sql in sqls:
        cur.execute(sql)
    con.commit()
    cur.close()


#
# NUI (obsolete)
#
def check_non_unique_identifier(con):
    return
    cur = con.cursor()
    sql = "update ARCHIVED_ITEM ai, (select Item_ID from ARCHIVED_ITEM group by Item_ID having count(*)>1) x set Problem_Code='NUI', IntegrityChecked=now() where ai.Item_ID=x.Item_ID"
    cur.execute(sql)
    con.commit()
    cur.close()


#
# BSI
#
def check_bad_sample_identifier(con, archive_id=None):
    cur = con.cursor()

    if archive_id is None:
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code='BSI'",
            """\
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select oa.Archive_ID, SampleIdentifier, 'BSI'
            from OLAC_ARCHIVE oa left join ARCHIVED_ITEM ai on oa.SampleIdentifier=ai.OaiIdentifier
            where oa.SampleIdentifier is not null and ai.Item_ID is null
            """,
            ]
    else:
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code='BSI' and Object_ID=%d" % archive_id,
            """\
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select oa.Archive_ID, SampleIdentifier, 'BSI'
            from OLAC_ARCHIVE oa left join ARCHIVED_ITEM ai on oa.SampleIdentifier=ai.OaiIdentifier
            where oa.SampleIdentifier is not null and ai.Item_ID is null and oa.Archive_ID=%d
            """ % archive_id,
            ]
    for sql in sqls:
        cur.execute(sql)
    con.commit()
    cur.close()


#
#
# BLT, BDT, BLC, BLF, BCR, BDI, BCC
#
def check_invalid_code(con, archive_id=None):
    cur = con.cursor()

    if archive_id is None:
        sqlt = [
            "delete from INTEGRITY_CHECK where Problem_Code='%s'",
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, me.Code, '%s'
            from METADATA_ELEM me
              left join CODE_DEFN cd on cd.Extension_ID=me.Extension_ID and cd.Code=me.Code
            where me.Type='%s' and cd.Code is null
            """,
            ]
        
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code='BCC'",
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, me.Content, 'BCC'
            from METADATA_ELEM me
              left join CountryCodes cc on me.Content=cc.CountryID
            where me.Type='ISO3166' and cc.CountryID is null
            """,

            "delete from INTEGRITY_CHECK where Problem_Code='BDT'",
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, Code, 'BDT'
            from METADATA_ELEM
            where Type='DCMIType'
              and (Content is null or Content not in
              ('Collection','Dataset','Event','Image','InteractiveResource',
               'Service','Software','Sound','Text','PhysicalObject'))
            """,
            
            "delete from INTEGRITY_CHECK where Problem_Code='BLC'",
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, me.Code, 'BLC'
            from METADATA_ELEM me
              left join ISO_639_3 lc on me.Code=lc.Id
              left join ISO_639_3 lc2 on me.Code=lc2.Part2B
              left join ISO_639_3 lc4 on me.Code=lc4.Part1
              left join ISO_639_3_Retirements lcr on me.Code=lcr.Id
            where me.Type='language'
              and me.Code is not null and me.Code != ''
              and lc.Id is null and lc2.Id is null
              and lc4.Id is null and lcr.Id is null
            """,

            ]
    else:
        sqlt = [
            """
            delete ic.*
            from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai
            where ic.Object_ID=me.Element_ID and me.Item_ID=ai.Item_ID
              and ai.Archive_ID=%d and Problem_Code='%%s'
            """ % archive_id,
            
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, me.Code, '%%s'
            from METADATA_ELEM me
              left join CODE_DEFN cd on cd.Extension_ID=me.Extension_ID and cd.Code=me.Code
              left join ARCHIVED_ITEM ai on me.Item_ID=ai.Item_ID
            where ai.Archive_ID=%d and me.Type='%%s' and cd.Code is null
            """ % archive_id,
            ]
        
        sqls = [
            """
            delete ic.*
            from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai
            where ic.Object_ID=me.Element_ID and me.Item_ID=ai.Item_ID
              and ai.Archive_ID=%d and Problem_Code='BCC'
            """ % archive_id,
            
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, me.Content, 'BCC'
            from METADATA_ELEM me
              left join CountryCodes cc on cc.CountryID=me.Content
              left join ARCHIVED_ITEM ai on me.Item_ID=ai.Item_ID
            where ai.Archive_ID=%d and me.Type='ISO3166' and cc.CountryID is null
            """ % archive_id,

            """
            delete ic.*
            from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai
            where ic.Object_ID=me.Element_ID and me.Item_ID=ai.Item_ID
              and ai.Archive_ID=%d and Problem_Code='BDT'
            """ % archive_id,
            
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, me.Code, 'BDT'
            from METADATA_ELEM me
              left join ARCHIVED_ITEM ai on me.Item_ID=ai.Item_ID
            where ai.Archive_ID=%d and me.Type='DCMIType'
              and (me.Content is null or me.Content not in
              ('Collection','Dataset','Event','Image','InteractiveResource',
               'Service','Software','Sound','Text','PhysicalObject'))
            """ % archive_id,
            
            """
            delete ic.*
            from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai
            where ic.Object_ID=me.Element_ID and me.Item_ID=ai.Item_ID
              and ai.Archive_ID=%d and Problem_Code='BLC'
            """ % archive_id,
            
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID, me.Code, 'BLC'
            from METADATA_ELEM me
              left join ARCHIVED_ITEM ai on me.Item_ID=ai.Item_ID
              left join ISO_639_3 lc on me.Code=lc.Id
              left join ISO_639_3 lc2 on me.Code=lc2.Part2B
              left join ISO_639_3 lc4 on me.Code=lc4.Part1
              left join ISO_639_3_Retirements lcr on me.Code=lcr.Id
            where ai.Archive_ID=%d and me.Type='language'
              and me.Code is not null and me.Code != ''
              and lc.Id is null and lc2.Id is null
              and lc4.Id is null and lcr.Id is null
            """ % archive_id,
            ]
    for pcode, etype in (('BLT','linguistic-type'),
                         ('BLF','linguistic-field'),
                         ('BCR','role'),
                         ('BDI','discourse-type')):
        cur.execute(sqlt[0] % pcode)
        cur.execute(sqlt[1] % (pcode,etype))
    for sql in sqls:
        cur.execute(sql)
    con.commit()
    cur.close()

#
# RLC, SIL, MLC
#
def check_language_code(con, archive_id=None):
    cur = con.cursor()
    if archive_id is None:
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code in ('RLC','SIL','MLC')",
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID,
                   concat(me.Code,
                          if(rlc.Change_To is not null,
                             concat(' - Change to ',rlc.Change_To),
                             if(Ret_Remedy is not null,
                                concat(" - ",Ret_Remedy),
                                ''
                             )
                          )
                   ),
                   'RLC'
            from METADATA_ELEM me, ISO_639_3_Retirements rlc
            where me.Type='language' and me.Code=rlc.Id
            """,
            "insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code) select distinct Element_ID, me.Code, 'SIL' from METADATA_ELEM me, ISO_639_3_Macrolanguages mlc where me.TagName='language' and me.Type='language' and me.Code=mlc.M_Id",
            "insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code) select distinct Element_ID, '', 'MLC' from METADATA_ELEM where Type='language' and (Code='' or Code is null)",
            ]
    else:
        sqls = [
            "delete ic.* from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai where ic.Object_ID=me.Element_ID and me.Item_ID=ai.Item_ID and ai.Archive_ID=%d and Problem_Code in ('RLC','SIL','MLC')" % archive_id,
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select distinct Element_ID,
                   concat(me.Code,
                          if(rlc.Change_To is not null,
                             concat(' - Change to ',rlc.Change_To),
                             if(Ret_Remedy is not null,
                                concat(" - ",Ret_Remedy),
                                ''
                             )
                          )
                   ),
                   'RLC'
            from ARCHIVED_ITEM ai, METADATA_ELEM me, ISO_639_3_Retirements rlc
            where ai.Archive_ID=%d and ai.Item_ID=me.Item_ID and me.Type='language' and me.Code=rlc.Id
            """ % archive_id,
            "insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code) select distinct Element_ID, me.Code, 'SIL' from ARCHIVED_ITEM ai, METADATA_ELEM me, ISO_639_3_Macrolanguages mlc where ai.Archive_ID=%d and ai.Item_ID=me.Item_ID and me.TagName='language' and me.Type='language' and me.Code=mlc.M_Id" % archive_id,
            "insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code) select distinct Element_ID, '', 'MLC' from ARCHIVED_ITEM ai, METADATA_ELEM me where Archive_ID=%d and ai.Item_ID=me.Item_ID and Type='language' and (Code='' or Code is null)" % archive_id,
            ]
    for sql in sqls:
        cur.execute(sql)
    con.commit()
    cur.close()


#
# RNC
#
def check_current_as_of(con, archive_id=None):
    cur = con.cursor()

    if archive_id is None:
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code='RNC'",
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select Archive_ID, '', 'RNC'
            from OLAC_ARCHIVE
            where datediff(current_date(),adddate(CurrentAsOf, interval 1 year)) > 0
            """,
            ]
    else:
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code='RNC' and Object_ID=%d" % archive_id,
            """
            insert into INTEGRITY_CHECK (Object_ID, Value, Problem_Code)
            select Archive_ID, '', 'RNC'
            from OLAC_ARCHIVE
            where Archive_ID=%d and datediff(current_date(),adddate(CurrentAsOf, interval 1 year)) > 0
            """ % archive_id,
            ]
    for sql in sqls:
        cur.execute(sql)
    con.commit()
    cur.close()


#
# ANF
#
def check_static_repository(con, archive_id=None):
    http_check = HttpChecker()

    pat = re.compile(r"((?:f|ht)tps?://\S+)")
    cur = con.cursor()
    if archive_id is None:
        cur.execute("select oa.Archive_ID, a.type, a.BASEURL from ARCHIVES a, OLAC_ARCHIVE oa where a.ID=oa.RepositoryIdentifier and a.BASEURL=oa.BaseUrl")
    else:
        cur.execute("select oa.Archive_ID, a.type, a.BASEURL from ARCHIVES a, OLAC_ARCHIVE oa where a.ID=oa.RepositoryIdentifier and a.BASEURL=oa.BaseUrl and oa.Archive_ID=%s", archive_id)
    for row in cur.fetchall():
        archive_id, repo_type, baseurl = row
        if repo_type == 'Gateway':
            baseurl = baseurl.replace('http://www.language-archives.org/sr/','http://',1)
        else:
            baseurl += "?verb=Identify"
        log('checking: %s' % baseurl)
        sql = "delete from INTEGRITY_CHECK where Object_ID=%s and Problem_Code='ANF'"
        cur.execute(sql, archive_id)
        try:
            res = http_check(baseurl)
        except Exception, e:
            log("%s" % e)
            continue  # can't determine
        if res == '404':
            sql = "insert into INTEGRITY_CHECK (Object_ID, Problem_Code) values (%s, 'ANF')"
            cur.execute(sql, archive_id)
        con.commit()
    cur.close()


if __name__ == '__main__':
    usageString = """\
Usage: %(prog)s [-h] -c <mycnf> [-H <host>] [-d <db>] [-a <repoid>] [-u]

    options:

      -h          print this message and exit
      -c <mycnf>  mycnf file
      -H <host>   hostname of the mysql server
      -d <db>     name of the olac database
      -a <repoid> check only the archive specified by the repository ID
      -u          resource-not-found/-available checks only
                  (by defaults, these checks are excluded)

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
        "*-a:",
        "*-u",
        )
    try:
        op.parse(sys.argv[1:])
    except OptionParser.ParseError, e:
        usage(e.message)
    if op.get('-h'): usage()
    
    mycnf = op.getOne('-c')
    host = op.getOne('-H')
    db = op.getOne('-d')

    opts = {"read_default_file":mycnf, "use_unicode":True, "charset":"utf8"}
    if host: opts["host"] = host
    if db: opts["db"] = db
    con = MySQLdb.connect(**opts)

    repoid = op.getOne('-a')
    if repoid:
        cur = con.cursor()
        cur.execute("select Archive_ID from OLAC_ARCHIVE " \
                    "where RepositoryIdentifier=%s", repoid)
        if cur.rowcount == 0:
            msg = "archive by the repository ID doesn't exist: %s" % repoid
            log(msg)
            sys.stderr.write(msg + "\n")
            cur.close()
            con.close()
            sys.exit(1)
        else:
            archive_id = cur.fetchone()[0]
    else:
        archive_id = None

    if op.get('-u'):
        check_urls(con, archive_id)
    else:
        check_broken_reference(con, archive_id)
        check_bad_sample_identifier(con, archive_id)
        check_invalid_code(con, archive_id)
        check_language_code(con, archive_id)
        check_current_as_of(con, archive_id)
        check_static_repository(con, archive_id)
