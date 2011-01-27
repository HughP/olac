#!/usr/bin/env python

import sys
import MySQLdb

def main():
    try:
        inputfile = sys.argv.pop(1)
    except IndexError:
        sys.stderr.write("You must specify an input file\n")
        sys.exit()

    con = connect()
    cur = con.cursor()
    ctr = 0
    enriched = 0

    for line in open(inputfile):
        ctr += 1
        id, junk, results = line.strip().split('\t')
        type, probability = results.split()[0].split(':')
        percent = "%.3f" % (100*float(probability))
        #itemid = getItemID(cur, id)
        itemid = id
        if itemid:
            setClassifiedDate(cur, itemid)
            if type != 'NONE' and type != 'LNONE' and percent > 1:
                enriched += 1
                enrich_type(cur, itemid, type, percent)
                print "enriched %s with %s type probability %s" % (id, type, percent)
        else:
            print "Error: Cannot find item for %s" % id
    con.commit()

    print "%s lines processed" % ctr
    print "%s items enriched" % enriched
    print "%s items skipped because of NONE or LNONE" % (ctr - enriched)


def connect():
    opts = {"db":"oai", "use_unicode":True, "charset":"utf8",
    "user" : 'olac',
    'passwd' : 'OLAcProjekt' }
    return MySQLdb.connect(**opts)

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

def enrich_type(cur, itemid, type, probability):
    # find out if this item already has a type enrichment
    # Code is not null?
    sql = "select Element_ID, Code from METADATA_ELEM where Item_ID = '%s' and Type = 'linguistic-type' and Code <> 'binary'" % itemid
    #print sql
    cur.execute(sql)
    row = cur.fetchone()

    # if it already has an enrichment, and it's a different type, update it

    # TODO: instead of overwriting the enrichment, make a backup copy of it so that the element has two enrichments, but one is of a bogus type, perhaps linguistic-type2 or something like that.  It could also have an extension be different, instead of messing with the type
    if cur.rowcount > 0 and row[1] != type:
        elemid = row[0]
        sql = "update METADATA_ELEM set Code = '%s', Content = '%s' where Element_ID = %s" % (type, probability, elemid)
        #print sql
        cur.execute(sql)
    elif cur.rowcount > 0:
        # the type has not changed; do nothing
        pass
    else:
    # otherwise insert the enrichment
        sql = "insert INTO METADATA_ELEM (TagName, Extension_ID, Content, Type, Code, Item_ID, Tag_ID) VALUES ('type', 15, '%s', 'linguistic-type', '%s', %s, 1500)" % (probability, type, itemid)
        #print sql
    cur.execute(sql)



if __name__ == '__main__':
    main()
