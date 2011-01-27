#!/usr/bin/env python

import sys
import MySQLdb

def reset_for_type_enrichment():
    archive = 0
    try:
        archive = sys.argv.pop(1)
    except IndexError:
        sys.stderr.write("Usage: [Archive ID]|all")
        sys.exit()

    con = connect()
    cur = con.cursor()

    if archive == "all":
        query = "update ARCHIVED_ITEM set TypeClassifiedDate = NULL,HasOLACType = 0;"

    else:
        query = "update ARCHIVED_ITEM set TypeClassifiedDate = NULL,HasOLACType = 0 where Archive_ID = %s;" % (archive)


    #print "executing: ", query
    cur.execute(query)

def connect():
    opts = {"db":"oai", "use_unicode":True, "charset":"utf8",
    "user" : 'olac',
    'passwd' : 'OLAcProjekt' }
    return MySQLdb.connect(**opts)

if __name__ == '__main__':
    reset_for_type_enrichment()

