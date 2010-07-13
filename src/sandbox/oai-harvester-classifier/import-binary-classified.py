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
        key1, value1 = results.split()[0].split(':')
        key2, value2 = results.split()[1].split(':')
        key3, value3 = results.split()[2].split(':')
        
        answer = key1
        if(key1 == 'YES'):
           probability = "%.3f" % (100*float(value1))
        elif(key2 == 'YES'):
           probability = "%.3f" % (100*float(value1))
        else:
           probability = "%.3f" % (100*float(value1))

        #print "answer:", answer, "P(x):", probability
        itemid = getItemID(cur, id)
        if itemid:
            #setClassifiedDate(cur, itemid)
            if answer != 'NONE' and answer != 'LNONE':
                enriched += 1
                enrich_binary(cur, itemid, probability)
                print "enriched %s with %s answer probability %s" % (id, answer, probability)
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

def enrich_type(cur, itemid, type):
        # find out if this item already has a type enrichment
        sql = "select Element_ID, Code from METADATA_ELEM where Item_ID = '%s' and Type = 'linguistic-type' and Code is not null" % itemid
        #print sql
        cur.execute(sql)
        row = cur.fetchone()

        # if it already has an enrichment, and it's a different type, update it

        # TODO: instead of overwriting the enrichment, make a backup copy of it so that the element has two enrichments, but one is of a bogus type, perhaps linguistic-type2 or something like that.  It could also have an extension be different, instead of messing with the type
        if cur.rowcount > 0 and row[1] != type:
            elemid = row[0]
            sql = "update METADATA_ELEM set Code = '%s' where Element_ID = %s" % (type, elemid)
            #print sql
            cur.execute(sql)
        elif cur.rowcount > 0:
            # the type has not changed; do nothing
            pass
        else:
        # otherwise insert the enrichment
            sql = "insert INTO METADATA_ELEM (TagName, Extension_ID, Type, Code, Item_ID, Tag_ID) VALUES ('type', 15, 'linguistic-type', '%s', %s, 1500)" % (type, itemid)
            #print sql
            cur.execute(sql)

# add binary classifier probability type enrichment
def enrich_binary(cur, itemid, probability):
        # find out if this item already has a binary probability type enrichment
        sql = "select Element_ID, Code from METADATA_ELEM where Item_ID = '%s' and Type = 'binary' and Content is not null" % itemid
        #print sql
        cur.execute(sql)
        row = cur.fetchone()

        # if it already has an enrichment, and it's a different type, update it

        if cur.rowcount > 0 and row[1] != probability:
            elemid = row[0]
            sql = "update METADATA_ELEM set Content = '%s' where Element_ID = %s" % (probability, elemid)
            #print sql
            cur.execute(sql)
        elif cur.rowcount > 0:
            # the probability has not changed; do nothing
            pass
        else:
        # otherwise insert the enrichment
            sql = "insert INTO METADATA_ELEM (TagName, Extension_ID, Type, Content, Item_ID, Tag_ID) VALUES ('type', 15, 'binary', '%s', %s, 1500)" % (probability, itemid)
            #print sql
            cur.execute(sql)



if __name__ == '__main__':
    main()
