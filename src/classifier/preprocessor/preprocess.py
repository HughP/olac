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
from optparse import OptionParser

parser = OptionParser(usage='python preprocess.py output-file.tab')
parser.add_option('-f','--force',action='store_true',default=False,dest='force',help='forces overwrite')
(options, args) = parser.parse_args()
if len(args)!=1:
    parser.print_help()
    sys.exit(1)

if os.path.exists(args[0]):
    if not options.force:
        a = raw_input("File %s already exists.  Overwrite? [yn]: " % args[0])
        if not a.lower()=='y':
            sys.exit(2)
        else:
            print "Overwriting..."

header, file = os.path.split(sys.argv[0])
headout = {'header':os.path.join(header,''), 'output':args[0]}
#os.system('python %(header)sEthnologue_data_preprocessor.py %(header)sdata/Ethnologue-classifier-training-data.xml > %(output)s' % headout)
os.system('python %(header)sLinguistList_preprocessor.py %(header)sdata/GetListOfAncientLgs.html > %(output)s' % headout)
os.system('python %(header)siso-639_preprocessor.py %(header)sdata/iso-639-3_20090210.tab.dld >> %(output)s' % headout)
os.system('python %(header)sCountryCodes_preprocessor.py %(header)sdata/CountryCodes.tab >>%(output)s' % headout)
os.system('python %(header)sregion_preprocessor.py -o %(output)s %(header)sdata/region\ data.txt' % headout)
os.system('python %(header)scomplexname_preprocessor.py -o %(output)s %(header)sdata/complex\ name\ data.txt' % headout)
output = open(headout['output'],'a')
print>>output, open(headout['header']+'data/extra_data.tab').read().rstrip('\n\r')
print>>output, open(headout['header']+'data/Data for language classifier (with y subfield).txt').read().rstrip('\n\r')
print>>output, open(headout['header']+'data/LCSH_names_trainingdata.txt').read().rstrip('\n\r')
print>>output, open(headout['header']+'data/ancient_countries.tab').read().rstrip('\n\r')
print>>output, open(headout['header']+'data/ethnologue_data.txt').read().rstrip('\n\r')
