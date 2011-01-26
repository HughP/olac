#!/usr/bin/python
'''Reads OLAC records from olacdb2.tab and prints out hypothesized ISO 639 language codes

Uses trained pickled classifier created with iso639_trainer.py to classify OLAC
records from a tab delimited file of records.  Debug mode prints out the
language, country and region names that the classifier recognizes.  Prints out
OAI Identifier, hypothesized ISO 639 language codes, and titles of each record.

Created on Jul 6, 2009

@author: Joshua S Hou



iso639_classifier -- Reads olacdb2.tab data and prints possible ISO 639 language codes for each record
'''

import sys
import pickle
from optparse import OptionParser
from tabdbreader2 import *
from malletreader import *
from xmlreader import *
from iso639_classifier import iso639_classifier,iso639Classifier
from utilities.util import *

# Parses arguments and options
parser = OptionParser(usage='python classify.py [options] classifier.pickle input classifier-output')
parser.add_option('-f', '--force', action='store_true', dest='force', help='Forces overwrite')
parser.add_option('-d', '--debug', action='store_true', dest='debug', help='Prints out the '+\
                  'language, country and region names that the classifier recognizes')
parser.add_option('-n', '--num', type='int', dest='num', default=0, help="number of records out of set to classify")
parser.add_option('-g', '--goldstandard', dest='gs', help='The gold standard filename.')
parser.add_option('-t', '--threshold', dest='threshold', type='float', default=0.00, help='Threshold confidence score')
parser.add_option('-s', '--snw', dest='snw', type='float', default=1.0, help='Strong name weight')
parser.add_option('-w', '--wnw', dest='wnw', type='float', default=0.7, help='Weak name weight')
parser.add_option('-a', '--country-weight', dest='a', type='float', default=1.0, help='Country weight')
parser.add_option('-b', '--region-weight', dest='b', type='float', default=1.0, help='Region weight')
(options, args) = parser.parse_args()
    
if len(args)<3:
    parser.print_help()
    sys.exit(1)

pickleFile = args[0]
inputFile = args[1]
outputFile = args[2]

# Loads classifier and initializes corpus reader
classifier = iso639Classifier(pickleFile)
#classifier.save(pickleFile, options.force)
#sys.exit(0)

#classifier = iso639_classifier(pickleFile)

suffix =  inputFile[-4:]
if suffix == '.tmp':
    # read MALLET-type input file
    reader = MalletCorpusReader('.', '.*db\.tab')
elif suffix != '.xml':
    reader = TabDBCorpusReader('.', '.*db\.tab')
else:
    reader = XMLCorpusReader('.','.*\.xml')
olac_records = reader.records(inputFile)

# Classifies each record
if options.num:
    olac_records = olac_records[:options.num]
if options.force:
    output = codecs.open(outputFile,'w',encoding='utf-8')
else:
    output = check_file(outputFile,'w',utf=True)
if options.gs:
    classifier.gs = open(options.gs).readlines()
classifier.classify_records(options.debug, olac_records, output, options.threshold, options.snw, options.wnw, options.a, options.b)
