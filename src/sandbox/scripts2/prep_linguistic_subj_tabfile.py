import sys

# This script prepares a tab-delimited text file for use by the linguistic_subj_to_xml.py script

try:
    tabfile = open(sys.argv.pop(1))
except:
    print "please specify a tab-delimited file to process"
    sys.exit(2)

for line in tabfile.read().splitlines():
    subjects = line.split('\t')
    field = subjects.pop(0)
    for s in subjects:
        if s:
            s = s.replace('"','')
            print "%s\t%s" %(s,field)
