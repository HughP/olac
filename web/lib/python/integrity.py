import re
import urlparse
import socket
import time
import OpenSSL
import MySQLdb
from curl import *

__all__ = [
    "check_urls",
    "check_broken_reference",
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


def connect_to_db():
    con = MySQLdb.connect(read_default_file="/home/olac/.my.cnf")
    return con


def check_urls(archive_id=None):
    ftp_check = FtpChecker()
    http_check = HttpChecker()

    pat = re.compile(r"((?:f|ht)tps?://\S+)")
    con = connect_to_db()
    cur = con.cursor()
    if archive_id is None:
        cur.execute("select me.Element_ID, Content from METADATA_ELEM me left join INTEGRITY_CHECK ic on me.Element_ID=ic.Element_ID where Content regexp '(f|ht)tps?://.*' and (IntegrityChecked is null or timestampdiff(day,IntegrityChecked,now())<1) order by rand()")
    else:
        cur.execute("select me.Element_ID, Content from METADATA_ELEM me left join ARCHIVED_ITEM ai on me.Item_ID=ai.Item_ID left join INTEGRITY_CHECK ic on me.Element_ID=ic.Element_ID where ai.Archive_ID=%s and Content regexp '(f|ht)tps?://.*' and (IntegrityChecked is null or timestampdiff(day,IntegrityChecked,now())<1) order by rand()", archive_id)
    for row in cur.fetchall():
        url = pat.search(row[1]).group(1)
        log('checking: %s' % url)
        sqls = ["delete from INTEGRITY_CHECK where Element_ID=%d and (Problem_Code='RNA' or Problem_Code='RNF')" % row[0]]
        if url.startswith('ftp'):
            res = ftp_check(url)
            if not res:
                sqls.append("insert into INTEGRITY_CHECK (Element_ID, Problem_Code) values (%d, 'RNA')" % row[0])
        elif url.startswith('http'):
            try:
                res = http_check(url)
            except ValueError, e:
                log("%s" % e)
                continue
            if res != '200':
                if res == '404':
                    sqls.append("insert into INTEGRITY_CHECK (Element_ID, Problem_Code) values (%d, 'RNF')" % row[0])
                else:
                    sqls.append("insert into INTEGRITY_CHECK (Element_ID, Problem_Code) values (%d, 'RNA')" % row[0])
        else:
            sqls.append("insert into INTEGRITY_CHECK (Element_ID, Problem_Code) values (%d, 'RNF')" % row[0])
        for sql in sqls:
            cur.execute(sql)
        con.commit()
    cur.close()
    con.close()

def check_broken_reference(archive_id=None):
    con = connect_to_db()
    cur = con.cursor()
    if archive_id is None:
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code='NSI'",
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'NSI' from METADATA_ELEM me left join ARCHIVED_ITEM ai on me.Content=ai.OaiIdentifier where me.Content regexp '^oai:[^:]+:[^:]+$' and ai.Item_ID",
            ]
    else:
        sqls = [
            "delete ic.* from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai where ic.Element_ID=me.Element_ID and me.Item_ID=ai.Item_ID and ai.Archive_ID=%d and Problem_Code='NSI'" % archive_id,
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'NSI' from METADATA_ELEM me left join ARCHIVED_ITEM ai2 on me.Item_ID=ai2.Item_ID left join ARCHIVED_ITEM ai on me.Content=ai.OaiIdentifier where me.Content regexp '^oai:[^:]+:[^:]+$' and ai.Item_ID and ai2.Archive_ID=%s" % archive_id,
            ]
    for sql in sqls:
        cur.execute(sql)
    con.commit()
    cur.close()
    con.close()

def check_not_unique_identifier():
    return
    con = connect_to_db()
    cur = con.cursor()
    sql = "update ARCHIVED_ITEM ai, (select Item_ID from ARCHIVED_ITEM group by Item_ID having count(*)>1) x set Problem_Code='NUI', IntegrityChecked=now() where ai.Item_ID=x.Item_ID"
    cur.execute(sql)
    con.commit()
    cur.close()
    con.close()

def check_invalid_code(archive_id=None):
    con = connect_to_db()
    cur = con.cursor()

    if archive_id is None:
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code='BLT'",
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'BLT' from METADATA_ELEM me left join CODE_DEFN cd on me.Code=cd.Code where me.Type='linguistic-type' and cd.Code is null",
            "delete from INTEGRITY_CHECK where Problem_Code='BDT'",
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'BDT' from METADATA_ELEM me left join CODE_DEFN cd on me.Code=cd.Code where me.Type='DCMIType' and cd.Code is null",
            "delete from INTEGRITY_CHECK where Problem_Code='BLC'",
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'BLC' from METADATA_ELEM me left join CODE_DEFN cd on me.Code=cd.Code where me.Type='language' and cd.Code is null",
            ]
    else:
        sqls = [
            "delete ic.* from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai where ic.Element_ID=me.Element_ID and me.Item_ID=ai.Item_ID and ai.Archive_ID=%d and Problem_Code='BLT'" % archive_id,
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'BLT' from METADATA_ELEM me left join CODE_DEFN cd on me.Code=cd.Code left join ARCHIVED_ITEM ai on me.Archive_ID=ai.Archive_ID where ai.Archive_ID=%d and me.Type='linguistic-type' and cd.Code is null" % archive_id,
            "delete ic.* from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai where ic.Element_ID=me.Element_ID and me.Item_ID=ai.Item_ID and ai.Archive_ID=%d and Problem_Code='BDT'" % archive_id,
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'BDT' from METADATA_ELEM me left join CODE_DEFN cd on me.Code=cd.Code left join ARCHIVED_ITEM ai on me.Archive_ID=ai.Archive_ID where ai.Archive_ID=%d and me.Type='DCMIType' and cd.Code is null" % archive_id,
            "delete ic.* from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai where ic.Element_ID=me.Element_ID and me.Item_ID=ai.Item_ID and ai.Archive_ID=%d and Problem_Code='BLC'" % archive_id,
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'BLC' from METADATA_ELEM me left join CODE_DEFN cd on me.Code=cd.Code left join ARCHIVED_ITEM ai on me.Archive_ID=ai.Archive_ID where ai.Archive_ID=%d and me.Type='language' and cd.Code is null" % archive_id,
            ]
    for sql in sqls:
        cur.execute(sql)
    con.commit()
    cur.close()
    con.close()

def check_language_code(archive_id=None):
    con = connect_to_db()
    cur = con.cursor()
    if archive_id is None:
        sqls = [
            "delete from INTEGRITY_CHECK where Problem_Code='SLC'",
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'SLC' from METADATA_ELEM me, RetiredLanguageCodes rlc where me.Type='language' and me.Code=rlc.Code"
            ]
    else:
        sqls = [
            "delete ic.* from INTEGRITY_CHECK ic, METADATA_ELEM me, ARCHIVED_ITEM ai where ic.Element_ID=me.Element_ID and me.Item_ID=ai.Item_ID and ai.Archive_ID=%d and Problem_Code='SLC'" % archive_id,
            "insert into INTEGRITY_CHECK (Element_ID, Problem_Code) select distinct Element_ID, 'SLC' from ARCHIVED_ITEM ai, METADATA_ELEM me, RetiredLanguageCodes rlc where ai.Archive_ID=%d and ai.Item_ID=me.Item_ID and me.Type='language' and me.Code=rlc.Code" % archive_id
            ]
    for sql in sqls:
        cur.execute(sql)
    con.commit()
    cur.close()
    con.close()
    
check_urls()

