'''Reads OLAC records from olacdb2.tab and prints out hypothesized ISO 639 language codes

Uses trained pickled classifier created with iso639_trainer.py to classify OLAC
records from a tab delimited file of records.  Debug mode prints out the
language, country and region names that the classifier recognizes.  Prints out
OAI Identifier, hypothesized ISO 639 language codes, and titles of each record.

Created on Jul 6, 2009

@author: jshou



iso639Classifier -- Reads olacdb2.tab data and prints possible ISO 639 language codes for each record
'''

import sys
import pickle
from optparse import OptionParser
from tabdbreader2 import *
from xmlreader import *
from iso639_trainer import *
from util import *

# Parses arguments and options
parser = OptionParser(usage='python iso639Classifier.py [options] classifier.pickle input classifier-output')
parser.add_option('-f', '--force', action='store_true', dest='force', help='Forces overwrite')
parser.add_option('-d', '--debug', action='store_true', dest='debug', help='Prints out the '+\
                  'language, country and region names that the classifier recognizes')
parser.add_option('-n', '--num', type='int', dest='num', default=0)
parser.add_option('-g', '--goldstandard', dest='gs', help='The gold standard filename.')
(options, args) = parser.parse_args()
    
if len(args)<3:
    parser.print_help()
    sys.exit(1)

# Loads classifier and initializes corpus reader
classifier = pickle.load(open(args[0],'rb'))

if args[1][-4:]!='.xml':
    reader = TabDBCorpusReader('.', '.*db\.tab')
else:
    reader = XMLCorpusReader('.','.*\.xml')
olac_records = reader.records(args[1])

# Classifies each record
if options.num:
    olac_records = olac_records[:options.num]
if options.force:
    output = codecs.open(args[2],'w',encoding='utf-8')
else:
    output = check_file(args[2],'w',utf=True)
if options.gs:
    classifier.gs = open(options.gs).readlines()
classifier.classify_records(options.debug, olac_records, output, 0.72)
