'''Extracts data from CountryCodes.tab and prints to file.

Created on Jul 29, 2009

@author: Joshua S Hou

Processes CountryCodes.tab, extracts the relevant information and prints the
ISO 3166 codes and associated country names to a file in the format defined in
wiki:iso639_trainerDataFileFormat.  File encoding is latin-1; this script also
converts everything to utf-8.

CountryCodes.tab retrieved on July 29, 2009 from:
http://www.ethnologue.com/codes/CountryCodes.tab

Usage: python CountryCodes_preprocessor.py CountryCodes.tab >output
'''
import sys
import re

if len(sys.argv)!=2:
    sys.exit('Usage: python CountryCodes_preprocessor.py CountryCodes.tab >output')

print '# CountryCodes.tab data'

for line in open(sys.argv[1]).readlines()[1:]:
    line = line.decode('latin-1').encode('utf-8')
    iso, country_name, continent = line.rstrip('\r\n').split('\t')
    print '\t'.join([iso, 'cn', country_name])
