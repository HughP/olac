import pymarc
import sys
import codecs

# marcanalyze.py
# Chris Hirt
# 5/15/09
#

stat = {}
def updateStat(val):
    global stat
    if stat.has_key(val):
        stat[val] += 1
    else:
        stat[val] = 1

# get marc source file from command line
try:
    marcfile = sys.argv.pop(1)
except:
    print "please specify a valid marc input file"
    sys.exit(2)

ctr = 0
marcset = pymarc.MARCReader(open(marcfile))
for rec in marcset:
    for field in rec:
        updateStat(field.tag)
        if not field.is_control_field():
            for sub,data in field:
                updateStat(field.tag + sub) 

for id in sorted(stat):
    print "%4s %6d" % (id,stat[id])
