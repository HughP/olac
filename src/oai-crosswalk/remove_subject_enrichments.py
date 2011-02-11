#!/usr/bin/env python

import sys
import MySQLdb

def main():
    archive = 0
    try:
        archive = sys.argv.pop(1)
    except IndexError:
        sys.stderr.write("Usage: [Archive ID]|all")
        sys.exit()

    con = connect()
    cur = con.cursor()

    if archive == "all":
        query = "delete from METADATA_ELEM using ARCHIVED_ITEM \
                 inner join METADATA_ELEM on METADATA_ELEM.Item_ID = ARCHIVED_ITEM.Item_ID \
                 where Code is not NULL and Extension_ID = 13; \
        cur.execute(query)
        query = "update ARCHIVED_ITEM set SubjectClassifiedDate = NULL,HasOLACLanguage = 0"
        cur.execute(query)

    else:
        query = "delete from METADATA_ELEM using ARCHIVED_ITEM \
                 inner join METADATA_ELEM on METADATA_ELEM.Item_ID = ARCHIVED_ITEM.Item_ID \
                 where Code is not NULL and Extension_ID = 13 and Archive_ID = %s;" % (archive)
        cur.execute(query)
        query = "update ARCHIVED_ITEM set SubjectClassifiedDate = NULL,HasOLACLanguage = 0 where Archive_ID = %s" % (archive)
        cur.execute(query)

    # make sure the actions stick
    con.commit()


def connect():
    opts = {"db":"oai", "use_unicode":True, "charset":"utf8",
    "user" : 'olac',
    'passwd' : 'OLAcProjekt' }
    return MySQLdb.connect(**opts)

if __name__ == '__main__':
    main()
