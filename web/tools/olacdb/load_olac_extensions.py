"""
Populate EXTENSION table with OLAC Extensions.
"""

import os
import sys
from xml.dom.minidom import parse
import re
import MySQLdb
import urllib2
try:
    from optionparser import OptionParser
except ImportError:
    print >>sys.stderr, """
Can't find the 'optionparser' module, which can be obtained from here:
http://olac.svn.sourceforge.net/viewvc/*checkout*/web/lib/python/optionparser.py
"""
    sys.exit(1)


if __name__ == "__main__":
    usageString = """\
Usage: %(prog)s [-h] -c <mycnf> [-H <host>] [-d <db>] -n <ver>

    options:

      -h          print this message and exit
      -c <mycnf>  mycnf file
      -H <host>   hostname of the mysql server
      -d <db>     name of the olac database
      -n <ver>    OLAC version (=1.0|1.1)

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
        "-n:",
        )
    try:
        op.parse(sys.argv[1:])
    except OptionParser.ParseError, e:
        usage(e.message)
    if op.get('-h'): usage()
    
    mycnf = op.getOne('-c')
    host = op.getOne('-H')
    db = op.getOne('-d')
    ver = op.getOne('-n')
    if ver not in ("1.0", "1.1"):
        msg = "invalid OLAC version: %s" % `ver`
        usage(msg)
        
    opts = {"read_default_file":mycnf, "use_unicode":True, "charset":"utf8"}
    if host: opts["host"] = host
    if db: opts["db"] = db
    con = MySQLdb.connect(**opts)
    cur = con.cursor()

    fields = {
        "shortName": "Label",
        "longName": "LongName",
        "versionDate": "VersionDate",
        "description": "Description",
        "appliesTo": "AppliesTo",
        "documentation": "Documentation",
        }
    
    for xsd in ('discourse-type',
                'language',
                'linguistic-field',
                'linguistic-type',
                'role'):
        url = "http://www.language-archives.org/OLAC/%s/olac-%s.xsd" % (ver,xsd)
        xml = parse(urllib2.urlopen(url))
        record = {}
        for tagName, dbFieldName in fields.items():
            for e in xml.getElementsByTagName(tagName):
                e.normalize()
                if dbFieldName in record:
                    record[dbFieldName] += ";" + e.firstChild.nodeValue.strip()
                else:
                    record[dbFieldName] = e.firstChild.nodeValue.strip()
        record['Type'] = xsd
        record['DefiningSchema'] = url
        record['NS'] = 'http://www.language-archives.org/OLAC/%s/' % ver
        record['NSPrefix'] = 'olac'
        record['NSSchema'] = 'http://www.language-archives.org/OLAC/%s/olac.xsd' % ver

        codes = []
        for e in xml.getElementsByTagName("xs:enumeration"):
            v = e.getAttribute("value")
            codes.append((v,v))

        ff = record.keys()
        vv = [record[k] for k in ff]
        sql = "insert into EXTENSION (%s) values (%s)" % \
              (",".join(ff), ",".join(["%s"]*len(ff)))
        try:
            cur.execute(sql, vv)
        except MySQLdb.IntegrityError, e:
            print "extension %s already exists" % `xsd`
            continue
        extid = cur.lastrowid

        if xsd == 'language':
            sql = "insert into CODE_DEFN select %s, Id, Ref_Name from ISO_639_3"
            cur.execute(sql, extid)
        else:
            for c,l in codes:
                sql = "insert into CODE_DEFN (Extension_ID,Code,Label) values (%s,%s,%s)"
                cur.execute(sql, (extid, c, l))

    con.commit()
    cur.close()
    con.close()
        
