'''Extracts data from LinguistList list of extinct languages and prints to file.

Created on Jul 2, 2009

@author: Joshua S Hou

Processes a LinguistList webpage List of Ancient and Extinct Languages, extracts
the ISO 639 codes and associated language names and prints the data to a file in
the format defined in wiki:iso639_trainerDatafileFormat.  Uses a regular
expression to extract ISO 639 codes and language names.  

The Description column of the table has some geographic information that I might
be able to extract, but I'm not sure how to tell which words are geographic and
which are not yet.

Old version: LinguistList data retrieved on July 2, 2009, from:
http://linguistlist.org/forms/langs/GetListOfAncientLgs.html

New version: LinguistList data retrieved on August 14, 2009, from:
http://linguistlist.org/forms/langs/GetListOfAncientLgs.html

Usage: python LinguistList_data_preprocessor.py LinguistList_data >output
'''
import sys
import re

if len(sys.argv)!=2:
    print "Usage: python LinguistList_data_preprocessor.py LinguistList_data >output"
    sys.exit(1)

iso_name_regex = re.compile(r'(?<=cfm\?code=)([a-z]{3})\s*\">(([^\s]+\s)*[^\s]+)(?=\s*</[Aa])', re.U)

linguist_list_file = open(sys.argv[1]).read()
iso_names = iso_name_regex.findall(linguist_list_file)

print "# Linguist List data"
for iso_name in iso_names:
    iso, name = iso_name[0], iso_name[1]
    print iso + "\tsn" + "\t" + name
