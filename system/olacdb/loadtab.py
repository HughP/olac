"""
Loads tab-delimited files into a specified MySQL table.
"""

import sys
import os
import codecs
import MySQLdb
try:
    from optionparser import OptionParser
except ImportError:
    print >>sys.stderr, """
Can't find the 'optionparser' module, which can be obtained from here:
http://olac.svn.sourceforge.net/viewvc/*checkout*/web/lib/python/optionparser.py
"""
    sys.exit(1)


usageString = """\
Usage: %(prog)s [options] -c <mycnf> -t <table> < mydata.tab

    where:

      -c <mycnf>     mycnf file
      -t <table>     name of the table to be populated with the data
    
    options:

      -h             print this message and exit
      -H <host>      hostname of the mysql server
      -d <db>        name of the olac database
      -e <encoding>  character encoding of the input data (default: UTF-8)

""" % {"prog":os.path.basename(sys.argv[0])}

op = OptionParser(
    "*-h",
    "-c:",
    "*-H:",
    "*-d:",
    "-t:",
    "*-e:",
    )

def usage(msg=None):
    print >>sys.stderr, usageString
    if msg:
        print >>sys.stderr, "ERROR:", msg
        print >>sys.stderr
    sys.exit(1)
    
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

enc = op.getOne('-e')
if enc is None: enc="utf-8"
tabnam = op.getOne('-t')

cnt = 0
cur = con.cursor()
for line in codecs.getreader(enc)(sys.stdin):
    a = []
    for v in line.rstrip('\r\n').split('\t'):
        if not v: v = None
        a.append(v)
    sql = "insert into %s values (%s);" % (tabnam, ",".join(['%s']*len(a)))
    try:
        cur.execute(sql, a)
        cnt += 1
    except MySQLdb.Error, e:
        print >>sys.stderr, "%d, %s" % e.args
        print a
print "inserted %d rows" % cnt

con.commit()
cur.close()
con.close()
