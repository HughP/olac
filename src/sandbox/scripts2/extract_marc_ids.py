import pymarc
import sys

IDFIELD = '001'

try:
    marcfile = sys.argv.pop(1)
except:
    print "please specify a marc file name"
    sys.exit(2)

marcset = pymarc.MARCReader(open(marcfile))
for rec in marcset:
    print rec[IDFIELD].value()
