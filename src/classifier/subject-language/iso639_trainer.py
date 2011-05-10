#!/usr/bin/env python
'''
iso639_trainer.py

If run from shell, main method loads data and saves classifier as a pickle.

Usage: python iso639_trainer.py datafile classifier.pickle
'''

import sys
import os
import pickle
from operator import itemgetter
import optparse
import codecs
from nltk import *
from utilities.util import *
from iso639_classifier import iso639Classifier

def main():
    '''Saves a pickled classifier.  Meant to be called from command line.'''
    parser = optparse.OptionParser(usage='python iso639_trainer.py [options] datafile classifier.pickle')
    parser.add_option('-f', '--force', action='store_true', dest='force', help='forces overwrite')
    parser.add_option('-s', '--stoplist', dest='stoplist', help='use a stoplist')
    (options,args) = parser.parse_args()

    if len(args) != 2:
        parser.print_help()
        sys.exit(1)

    iso639c = iso639Classifier()
    iso639c.train(args[0])
    if options.stoplist:
        iso639c.trim_from_file(options.stoplist)
    iso639c.save(args[1], options.force)

if __name__=="__main__":
    main()
