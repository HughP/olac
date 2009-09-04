#!/usr/bin/python
# Concatenates each data source for the ISO 639-3 classifier into a single file,
# running its preprocessor if necessary.
#
# The data sources it compiles are:
# Ethnologue data
# Linguist List list of ancient and extinct languages
# ISO 639-3 Code Set from sil.org
# CountryCodes country data from Ethnologue
# Manually compiled data in extra_data.tab
# LCSH mappings (Data for language classifier.tab)
# LCSH data (LCSH_names_trainingdata.tab)
# Countries for ancient and extinct languages compiled from Linguist List data
import sys
import os

if len(sys.argv)!=2:
    sys.exit("Usage: python preprocess.py output-file.tab")

if os.path.exists(sys.argv[1]):
    a = raw_input("File %s already exists.  Overwrite? [yn]: " % sys.argv[1])
    if not a.lower()=='y':
        sys.exit(2)
    else:
        print "Overwriting..."

header, file = os.path.split(sys.argv[0])
headout = {'header':os.path.join(header,''), 'output':sys.argv[1]}
os.system('python %(header)sEthnologue_data_preprocessor.py %(header)sdata/Ethnologue-classifier-training-data.xml > %(output)s' % headout)
os.system('python %(header)sLinguistList_preprocessor.py %(header)sdata/GetListOfAncientLgs.html >> %(output)s' % headout)
os.system('python %(header)siso-639_preprocessor.py %(header)sdata/iso-639-3_20090210.tab.dld >> %(output)s' % headout)
os.system('python %(header)sCountryCodes_preprocessor.py %(header)sdata/CountryCodes.tab >>%(output)s' % headout)
output = open(headout['output'],'a')
print>>output, open(headout['header']+'extra_data.tab').read().rstrip('\n\r')
print>>output, open(headout['header']+'data/Data for language classifier.tab').read().rstrip('\n\r')
print>>output, open(headout['header']+'data/LCSH_names_trainingdata.tab').read().rstrip('\n\r')
print>>output, open(headout['header']+'data/ancient_countries.tab').read().rstrip('\n\r')
