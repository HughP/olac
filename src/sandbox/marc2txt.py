import pymarc
import sys

file = sys.argv.pop(1)
marcset = pymarc.MARCReader(open(file))
for rec in marcset:
    try:
        print rec
    except:
        sys.stderr.write("CANNOT PRINT record %s" % rec['001'].value())

