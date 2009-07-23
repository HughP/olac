#!/usr/bin/python
# Prints a gold standard from olac_display_subset.xml.  Throwaway script that is
# totally not scalable.
import sys
import re
from xmlreader import *
from util import *

reader = XMLCorpusReader('/Users/jshou/Documents/GIAL/data', '.*\.xml')
c = reader.records('olac_display_subset.xml')
newline = re.compile(r'\n')

for record in c:
    if 'iso639' in record:
        title = newline.sub(' ',get_or_none(record,'title'))
        print '\t'.join([record['Oai_ID'], record['iso639'], title])
