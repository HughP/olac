#!/usr/bin/python
# Prints a gold standard from olac_display_subset.xml.  Throwaway script that is
# totally not scalable.
import sys
import re
from xmlreader import *
from util import *

reader = XMLCorpusReader('.', '.*\.xml')
c = reader.records('olac_display_subset.xml')
newline = re.compile(r'\n')
gs = check_file('olac_display_subset.gs','wb',utf=True)

for record in c:
    if 'iso639' in record:
        title = newline.sub(' ',get_or_none(record,'title'))
        print>>gs, '\t'.join([record['Oai_ID'], record['iso639'], title])
