#!/usr/bin/python
# extract_descriptions.txt
# Joshua S Hou
# June 2009
#
# This script takes a tab delimited file like olacdb.tab or oaidb.tab and prints
# out each description on a line.  This is just for me to scan through a lot of
# descriptions at a time so I can see what features I might use for iso detection.
import sys
import os
from tabdbreader import TabDBCorpusReader

if len(sys.argv)!=2:
    print "Usage: python extract_descriptions.py output_file"
    sys.exit(1)
elif os.path.exists(os.path.join(os.getcwd(),sys.argv[1])):
    answer = raw_input("File "+sys.argv[1]+" exists.  Overwrite? [y/n] ")
    if not answer.lower()=="y":
        sys.exit(1)
    else:
        print "Overwriting..."
out = open(sys.argv[1],'w')
reader = TabDBCorpusReader('../oai_classifier_trn', '.*db\.tab')

olac_records = reader.records('olacdb.tab')

#oai_records = reader.records('oaidb.tab')
#oai_train = oai_records[:len(oai_records)*TRAIN_PERCENT/100]
#oai_test = oai_records[len(oai_records)*TRAIN_PERCENT/100:]

for record in olac_records:
    try:
        print>>out, record['description']
        print>>out, ''
    except KeyError:
        pass
