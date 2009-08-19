#!/usr/bin/python
# Takes as stdin a list of classified records with olac iso639 classifier, with
# debug statements or without, and takes a random sample of size n, printing to
# stdout for manual evaluation purposes.
import sys
import random

if len(sys.argv)!=2:
    print sys.argv
    sys.exit("Usage: cat set1 set2 | python random_eval_set n > output")

records = [] # list of records, where each record is a list of lines associated with that record

# Load up records from stdin
while True:
    line = sys.stdin.readline()
    if line:
        if line[0]=='#' and records:
            records[-1].append(line)
        else:
            records.append([line])
    else:
        break

# Now, print out random records
for i in xrange(int(sys.argv[1])):
    for line in records.pop(random.randint(0,len(records)-1)):
        print line.rstrip()
