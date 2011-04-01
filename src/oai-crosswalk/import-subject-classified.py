#!/usr/bin/env python

import sys
from utilities import database

def main():
    try:
        inputfile = sys.argv.pop(1)
    except IndexError:
        sys.stderr.write("You must specify an input file\n")
        sys.exit()

    con = database.connect()
    cur = con.cursor()
    import_subject_classified(con,inputfile)


def import_subject_classified(con,inputfile):
    cur = con.cursor()
    ctr = 0
    enriched = 0

    for line in open(inputfile):
        ctr += 1
        columns = line.strip().split('\t')
        id = columns.pop(0)
        if len(columns):
            iso3s = columns.pop(0)
            iso3s_list = iso3s.split()[0].split(' ')
        else:
            iso3s = 'NONE'
            iso3s_list = ()
        #itemid = getItemID(cur, id)
        itemid = id
        if itemid:
            #setClassifiedDate(cur, itemid)
            if iso3s and iso3s != 'NONE' and iso3s != 'LNONE':
                enriched += 1
                enrich_subject(cur, itemid, iso3s)
                print "enriched %s with language(s) %s" % (itemid, iso3s)
        else:
            print "Error: Cannot find item for %s" % id
    con.commit()

    print "%s lines processed" % ctr
    print "%s items enriched" % enriched
    print "%s items skipped because of NONE or LNONE" % (ctr - enriched)


def getItemID(cur, id):
    sql = "select Item_ID from ARCHIVED_ITEM where OaiIdentifier = '%s';" % id
    cur.execute(sql)
    row = cur.fetchone()
    if cur.rowcount > 0:
        return row[0]
    else:
        return None

def setClassifiedDate(cur, id):
    # update this item's date-classified and schema ID
    sql = "update ARCHIVED_ITEM set Schema_ID = 2, TypeClassifiedDate = DATE(NOW()) WHERE Item_ID = '%s'" % id
    #print sql
    cur.execute(sql)

def enrich_subject(cur, itemid, iso3s):
    # find out if this item already has a subject enrichment
    # Code is not null?
    sql = "select Element_ID, Code from METADATA_ELEM where Item_ID = '%s' and Type = 'language' and Code <> 'binary'" % itemid
    #print sql
    cur.execute(sql)
    row = cur.fetchone()

    # if it already has an enrichment, and it's a different code, update it
    if cur.rowcount > 0 and row[1] != iso3s:
        elemid = row[0]
        sql = "update METADATA_ELEM set Code = '%s', Content = '%s' where Element_ID = %s" % ('qqq', iso3s, elemid)
        #print sql
        cur.execute(sql)
    elif cur.rowcount > 0:
        # the iso3s have not changed; do nothing
        pass
    else:
    # otherwise insert the enrichment
        sql = "insert INTO METADATA_ELEM (TagName, Extension_ID, Content, Type, Code, Item_ID, Tag_ID) VALUES ('subject', 13, '%s', 'language', 'qqq', %s, 1300)" % (iso3s, itemid)
        print sql
        cur.execute(sql)



if __name__ == '__main__':
    main()
