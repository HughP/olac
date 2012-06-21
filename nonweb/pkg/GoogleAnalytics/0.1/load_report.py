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
import olac

def process_options():
    usageString = """\
Usage: %(prog)s [-h] [-c <mycnf>] [-H <host>] [-d <db>] report

    options:

      -h          print this message and exit
      -c <mycnf>  mycnf file; if missing, system configuration is used
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
        "*-c:",
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

    if mycnf:
        coninfo = {"read_default_file":mycnf}
    else:
        coninfo = {
            "host": olac.olacvar('mysql/host'),
            "db": olac.olacvar('mysql/olacdb'),
            "user": olac.olacvar('mysql/user'),
            "passwd": olac.olacvar('mysql/passwd'),
        }
    if host: coninfo["host"] = host
    if db: coninfo["db"] = db
    
    con = MySQLdb.connect(**coninfo)

    return con, op.args[0]



def str2sec(s):
    """
    @param s: a string of HH:MM:SS form
    """
    a = s.split(':')
    return int(a[0]) * 3600 + int(a[1]) * 60 + int(a[2])


def process_report(con, report):
    cur = con.cursor()
    f = file(report)
    f.readline()
    f.readline()
    f.readline()
    arr = f.readline().split()[1].split('-')
    fromdate = datetime.datetime(*time.strptime(arr[0], "%Y%m%d")[:6])
    todate = datetime.datetime(*time.strptime(arr[1], "%Y%m%d")[:6])

    while not f.readline().startswith("Destination Page,"): pass
    for line in f:
        arr = line.strip().split(',')
        if arr[0] == '': continue
        typ, repoid = arr[0].split('/')[-2:]
        typ = typ.split('_')[-1]
        L = [typ, repoid, fromdate, todate]
        L.extend([int(x) for x in arr[1:3]])
        L.append(str2sec(arr[3]))
        L.extend([float(x.rstrip('%')) for x in arr[4:]])
        sql = """
        insert ignore into GoogleAnalyticsReports
        (type, repoid, start_date, end_date, pageviews, unique_pageviews,
         time_on_page, bounce_rate, percent_exit, value_index)
        values
        (%s,%s,%s,%s,%s,%s,%s,%s,%s,0)
        """
        cur.execute(sql, L)
    con.commit()
    cur.close()
        
if __name__ == "__main__":
    con, report = process_options()
    process_report(con, report)
    
    
