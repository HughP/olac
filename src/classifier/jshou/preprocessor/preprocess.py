#!/usr/bin/python
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

if '/' in sys.argv[0]:
    header = sys.argv[0].rsplit('/')[0]+'/'
else:
    header = ''
os.system('python %(header)sEthnologue_data_preprocessor.py %(header)sEthnologue-classifier-training-data.xml > %(output)s' % {'header':header, 'output':sys.argv[1]})
os.system('python %(header)sLinguistList_preprocessor.py %(header)sGetListOfAncientLgs.html >> %(output)s' % {'header':header, 'output':sys.argv[1]})
os.system('python %(header)siso-639_preprocessor.py %(header)siso-639-3_20090210.tab.dld >> %(output)s' % {'header':header, 'output':sys.argv[1]})
os.system('cat %(header)sextra_data.tab >> %(output)s' % {'header':header, 'output':sys.argv[1]})
