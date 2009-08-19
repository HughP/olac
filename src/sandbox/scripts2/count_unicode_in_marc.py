import pymarc
import sys

file = sys.argv.pop(1)
marcset = pymarc.MARCReader(open(file))
num_of_unicode = 0
num_of_marc8 = 0
ctr = 0
for rec in marcset:
    if rec.leader[9] == 'a':
        num_of_unicode += 1
    if rec.leader[9] == ' ':
        num_of_marc8 += 1
    ctr += 1
print "Of %s records, %s are unicode and %s are marc8" % (ctr,num_of_unicode,num_of_marc8)


