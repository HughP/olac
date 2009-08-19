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
    for tag in ('590','594'):
        if (rec[tag] and (rec[tag].value().lower().find('639-') != -1 or rec[tag].value().lower().find('ethnologue') != -1)):
            if (rec[tag]['a'] and len(rec[tag]['a']) != 3):
                sys.stdout.write('%s [%s]: ' %(rec[IDFIELD].value(),tag))
                for (sf,val) in rec[tag]:
                    sys.stdout.write('$%s%s' % (sf,val))
                print
                
