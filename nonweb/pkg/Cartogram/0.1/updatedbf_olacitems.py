"""
Copy a dbf file and add OLAC_ITEMS and OLAC_ITEMS2 field to the new dbf file.

The dbf file should have ISO2 field containing ISO 3166 2-letter country codes.

OLAC_ITEMS field should contain the number of items for the country specified
by the ISO2 field. The olacvar('data/num_items_by_country') table provides
information on the number of OLAC items. The table is indexed by ISO 3166
2-charcter country codes.

OLAC_ITMS2 field is the same as OLAC_ITEMS except that languages with more
than 10M speakers are excluded in the computation.
"""

import sys
import os
from dbfpy import dbf
try:
    import olac
except:
    pass

# check command line arguments
if len(sys.argv) < 3 or len(sys.argv) > 4:
    print "Usage: %s <input dbf> <output dbf> [<table>]"
    print
    print "    If <table> is given, it is used. Otherwise, table found in"
    print "    $(olacvar data/num_items_by_country) is used."
    print
    print "    <table> must have 5 columns: area, country code, country name,"
    print "    number of items, and number of items without considering"
    print "    languages of more than 10M speakers."
    print
    sys.exit(1)

if len(sys.argv) == 4:
    tabfile = sys.argv[3]
elif 'olac' in globals():  # if olac module was loaded
    tabfile = olac.olacvar('data/num_items_by_country')
else:
    print "error: cannot obtain data table for number of olac items by country"
    sys.exit(1)

# make a table of number of olac items indexed by country code
f = open(tabfile)
f.readline()  # skip the header
tab = {}
for l in f:
    area, cname, ccode, n, n2 = l.rstrip('\r\n').split('\t')
    tab[ccode] = (int(n), int(n2))

# open input dbf file, and create an output dbf file
db = dbf.Dbf(sys.argv[1])  # input
db2 = dbf.Dbf(sys.argv[2], new=True)  # output
for field in db.header.fields:
    db2.addField(field.fieldInfo())
db2.addField(('OLAC_ITEMS','N',10))
db2.addField(('OLAC_ITMS2','N',10))

for rec in db:
    rec2 = db2.newRecord()
    for field in db.header.fields:
        rec2[field.name] = rec[field.name]
    ccode = rec['ISO2']
    if ccode in tab:
        rec2['OLAC_ITEMS'] = tab[ccode][0]
        rec2['OLAC_ITMS2'] = tab[ccode][1]
    else:
        rec2['OLAC_ITEMS'] = 0
        rec2['OLAC_ITMS2'] = 0
    print rec2['ISO2'], rec2['OLAC_ITEMS'], rec2['OLAC_ITMS2']
    rec2.store()
    
db2.close()

