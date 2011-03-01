#!/usr/bin/env python

import sys
from utilities import database

def main():
    archive_id = 0
    try:
        archive_id = sys.argv.pop(1)
    except IndexError:
        sys.stderr.write("Usage: [Archive ID]|all")
        sys.exit()
    resource_type_extract(archive_id)
    

def resource_type_extract(archive_id):

    #OUT = open(outputfile, 'w')

    #con = database.connect()
    con = database.oursql_connect()
    #cur = con.cursor()
    cur = con.cursor(string_limit=30000, group_concat_max_len=30000)
    ctr = 0
    enriched = 0


    if archive_id == "all":
        query = "set session group_concat_max_len = 30000; select METADATA_ELEM.Item_ID,'',group_concat(replace(Content,'\\n',' ') SEPARATOR ' *** ') from ARCHIVED_ITEM inner join METADATA_ELEM on ARCHIVED_ITEM.Item_ID = METADATA_ELEM.Item_ID where (TagName = 'description' or TagName = 'title' or TagName = 'subject' or TagName = 'coverage') and (TypeClassifiedDate is NULL or TypeClassifiedDate < ARCHIVED_ITEM.DateStamp) group by METADATA_ELEM.Item_ID;"

    else:
        #query = "set session group_concat_max_len = 30000; select METADATA_ELEM.Item_ID,'',group_concat(replace(Content,'\\n',' ') SEPARATOR ' *** ') from ARCHIVED_ITEM inner join METADATA_ELEM on ARCHIVED_ITEM.Item_ID = METADATA_ELEM.Item_ID where (TagName = 'description' or TagName = 'title' or TagName = 'subject' or TagName = 'coverage') and Archive_ID = %s and (TypeClassifiedDate is NULL or TypeClassifiedDate < ARCHIVED_ITEM.DateStamp) group by METADATA_ELEM.Item_ID" % (archive_id)
        query = "select METADATA_ELEM.Item_ID,'',group_concat(replace(Content,'\\n',' ') SEPARATOR ' *** ') from ARCHIVED_ITEM inner join METADATA_ELEM on ARCHIVED_ITEM.Item_ID = METADATA_ELEM.Item_ID where (TagName = 'description' or TagName = 'title' or TagName = 'subject' or TagName = 'coverage') and Archive_ID = %s and (TypeClassifiedDate is NULL or TypeClassifiedDate < ARCHIVED_ITEM.DateStamp) group by METADATA_ELEM.Item_ID" % (archive_id)


    #print "executing: ", query
    cur.execute(query)
    # iterate over the results pulling them down from the server on each iteration
    #while 1:
    #    row = cur.fetchone()
    #    if row is None: break
    #    print row
    print cur.fetchall()
    cur.close()

if __name__ == '__main__':
    main()

