'''Reads data from iso639-3 code set, normalizes and prints to file.

Created on Jul 20, 2009

@author: Joshua S Hou

Processes data in a downloaded iso639-3 code set, normalizes the data to format
defined in wiki:iso639_trainerDatafileFormat and prints to file.

Usage: python iso-639_preprocessor.py datafile >output
'''

import sys
import codecs

if len(sys.argv)!=2:
    sys.exit('Usage: python iso-639_preprocessor.py datafile >output')

datafile = open(sys.argv[1]).readlines()

print "# iso639-3 table data"
for line in datafile[1:]: # skips first line, which is just a header.
    iso, part2b, part2t, part1, scope, lang_type, ref_name, comment = line.rstrip('\n').split('\t')
    if lang_type!="S": # special, e.g. no linguistic data, multiple languages
        print iso + '\tsn\t' + ref_name