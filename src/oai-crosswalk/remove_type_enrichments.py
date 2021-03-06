#!/usr/bin/env python

import sys
from utilities import database

def remove_type_enrichment():
    archive = 0
    try:
        archive = sys.argv.pop(1)
    except IndexError:
        sys.stderr.write("Usage: [Archive ID]|all\n")
        sys.exit()

    con = database.connect()
    cur = con.cursor()

    if archive == "all":
        query = "delete from METADATA_ELEM using ARCHIVED_ITEM \
                 inner join METADATA_ELEM on METADATA_ELEM.Item_ID = ARCHIVED_ITEM.Item_ID \
                 where Code is not NULL and Extension_ID = 15"
        cur.execute(query)

        query = "update ARCHIVED_ITEM set TypeClassifiedDate = NULL,HasOLACType = 0"
        cur.execute(query)

    else:
        query = "delete from METADATA_ELEM using ARCHIVED_ITEM \
                 inner join METADATA_ELEM on METADATA_ELEM.Item_ID = ARCHIVED_ITEM.Item_ID \
                 where Code is not NULL and Extension_ID = 15 and Archive_ID = %s" % (archive)
        cur.execute(query)

        query = "update ARCHIVED_ITEM set TypeClassifiedDate = NULL,HasOLACType = 0 \
                 where Archive_ID = %s" % (archive)
        cur.execute(query)

    # make sure the actions stick!
    con.commit()


if __name__ == '__main__':
    remove_type_enrichment()

