#!/usr/bin/env python

import sys
#import MySQLdb
import oursql

def resource_type_extract():
    archive = 0
    try:
        archive = sys.argv.pop(1)
    except IndexError:
        sys.stderr.write("Usage: [Archive ID]|all")
        sys.exit()

    #OUT = open(outputfile, 'w')

    con = connect()
    cur = con.cursor()
    ctr = 0
    enriched = 0


    if archive == "all":
        query = "set session group_concat_max_len = 30000; select METADATA_ELEM.Item_ID,'',group_concat(replace(Content,'\\n',' ') SEPARATOR ' *** ') from ARCHIVED_ITEM inner join METADATA_ELEM on ARCHIVED_ITEM.Item_ID = METADATA_ELEM.Item_ID where (TagName = 'description' TagName = 'title' or TagName = 'subject' or TagName = 'coverage') and (TypeClassifiedDate is NULL or TypeClassifiedDate < ARCHIVED_ITEM.DateStamp) group by METADATA_ELEM.Item_ID;"

    else:
        query = "set session group_concat_max_len = 30000; select METADATA_ELEM.Item_ID,'',group_concat(replace(Content,'\\n',' ') SEPARATOR ' *** ') from ARCHIVED_ITEM inner join METADATA_ELEM on ARCHIVED_ITEM.Item_ID = METADATA_ELEM.Item_ID where (TagName = 'description' TagName = 'title' or TagName = 'subject' or TagName = 'coverage') and Archive_ID = %s and (TypeClassifiedDate is NULL or TypeClassifiedDate < ARCHIVED_ITEM.DateStamp) group by METADATA_ELEM.Item_ID" % (archive)


    #print "executing: ", query
    cur.execute(query)
    # iterate over the results pulling them down from the server on each iteration
    while 1:
        row = cur.fetchone()
        if row is None: break
        print row
    cur.close()

def connect():
    opts = {"db":"oai", "use_unicode":True, "charset":"utf8",
    "user" : 'olac',
    'passwd' : 'OLAcProjekt' }
    return MySQLdb.connect(**opts)

if __name__ == '__main__':
    resource_type_extract()

