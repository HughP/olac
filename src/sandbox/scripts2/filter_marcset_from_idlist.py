import pymarc
import sys

IDFIELD = '001'

try:
    marcfile = sys.argv.pop(1)
    idlist = sys.argv.pop(1)
except:
    print "you need two params: marcfile and idlist"
    sys.exit(2)

# open idlist and read into a list
try:
    file = open(idlist)
    ids = [line[:-1] for line in file]
except:
    print "could not open file %s for reading" % idlist

marcset = pymarc.MARCReader(open(marcfile))
ctr = 0
for rec in marcset:
    recid = rec['001'].value()
    if recid in ids:
        sys.stdout.write(rec.as_marc21())
        #print rec.as_marc21()
        #print pymarc.record_to_xml(rec)
        #print "Found %s in ids" % recid
        ctr += 1
sys.stderr.write("%s records found" % ctr)
