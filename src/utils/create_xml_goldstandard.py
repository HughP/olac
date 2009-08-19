#!/usr/bin/python
# Prints a gold standard from olac_display_subset.xml.  Throwaway script that is
# totally not scalable.
import sys
import re
from xmlreader import *
from util import *

if len(sys.argv)!=3:
    sys.exit("Usage: python create_xml_goldstandard.py xmlfile goldstandard")

xmlfilename = sys.argv[1]
gs_filename = sys.argv[2]

reader = XMLCorpusReader('.', '.*\.xml')
c = reader.records(xmlfilename)
newline = re.compile(r'\n')
gs = check_file(gs_filename,'wb',utf=True)

for record in c:
    if 'iso639' in record:
        title = newline.sub(' ',get_or_none(record,'title'))
        print>>gs, '\t'.join([record['Oai_ID'], record['iso639'], title])
