#! /usr/bin/env python

"""
Load a GA report into the GoogleAnalyticsReports table of the OLAC database.
"""

import sys
import os
import datetime
import time
import MySQLdb
from optionparser import OptionParser

def process_options():
    usageString = """\
Usage: %(prog)s [-h] -c <mycnf> [-H <host>] [-d <db>] report

    options:

      -h          print this message and exit
      -c <mycnf>  mycnf file
      -H <host>   hostname of the mysql server
      -d <db>     name of the olac database

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
        )
    try:
        op.parse(sys.argv[1:])
    except OptionParser.ParseError, e:
        usage(e.message)
    if op.get('-h'): usage()

    if len(op.args) != 1:
        msg = "you must supply file name of the report"
        usage(msg)
        
    mycnf = op.getOne('-c')
    host = op.getOne('-H')
    db = op.getOne('-d')

    coninfo = {"read_default_file":mycnf}
    if host: coninfo["host"] = host
    if db: coninfo["db"] = db
    
    con = MySQLdb.connect(**coninfo)

    return con, op.args[0]


def process_report(con, report):
    cur = con.cursor()
    f = file(report)
    f.readline()
    f.readline()
    f.readline()
    arr = f.readline().split('"')
    fromdate = datetime.datetime(*time.strptime(arr[1], "%B %d, %Y")[:6])
    todate = datetime.datetime(*time.strptime(arr[3], "%B %d, %Y")[:6])

    while not f.readline().startswith("# Table"): pass
    f.readline()
    f.readline()
    for line in f:
        if line.startswith('#'): continue
        arr = line.split(',')
        typ, repoid = arr[0].split('/')[-2:]
        typ = typ.split('_')[-1]
        L = [typ, repoid, fromdate, todate]
        L.extend([int(x) for x in arr[1:3]])
        L.extend([float(x) for x in arr[3:]])
        sql = """
        insert ignore into GoogleAnalyticsReports
        (type, repoid, start_date, end_date, pageviews, unique_pageviews,
         time_on_page, bounce_rate, percent_exit, value_index)
        values
        (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """
        cur.execute(sql, L)
    con.commit()
    cur.close()
        
if __name__ == "__main__":
    con, report = process_options()
    process_report(con, report)
    
    
