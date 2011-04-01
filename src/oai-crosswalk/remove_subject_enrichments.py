#!/usr/bin/env python

import sys
from utilities import database

def main():
    archive_id = 0
    try:
        archive = sys.argv.pop(1)
    except IndexError:
        sys.stderr.write("Usage: [Archive ID]|all")
        sys.exit()

    con = database.connect()
    cur = con.cursor()

    remove_subject_enrichments(archive_id)

def remove_subject_enrichments(archive_id):
    if archive_id == "all":
        query = "delete from METADATA_ELEM using ARCHIVED_ITEM \
                 inner join METADATA_ELEM on METADATA_ELEM.Item_ID = ARCHIVED_ITEM.Item_ID \
                 where Code is not NULL and Extension_ID = 13; \
        cur.execute(query)
        query = "update ARCHIVED_ITEM set SubjectClassifiedDate = NULL,HasOLACLanguage = 0"
        cur.execute(query)

    else:
        query = "delete from METADATA_ELEM using ARCHIVED_ITEM \
                 inner join METADATA_ELEM on METADATA_ELEM.Item_ID = ARCHIVED_ITEM.Item_ID \
                 where Code is not NULL and Extension_ID = 13 and Archive_ID = %s;" % (archive_id)
        cur.execute(query)
        query = "update ARCHIVED_ITEM set SubjectClassifiedDate = NULL,HasOLACLanguage = 0 where Archive_ID = %s" % (archive_id)
        cur.execute(query)

    # make sure the actions stick
    con.commit()


if __name__ == '__main__':
    main()

