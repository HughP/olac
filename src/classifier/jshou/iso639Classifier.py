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
from iso639_trainer import *
from util import *

# Parses arguments and options
parser = OptionParser(usage='python iso639Classifier.py [options] classifier.pickle input > classifier-output')
parser.add_option('-d', '--debug', action='store_true', dest='debug', help='Prints out the '+\
                  'language, country and region names that the classifier recognizes.')
parser.add_option('-n', '--num', type='int', dest='num', default=0)
(options, args) = parser.parse_args()
    
if len(args)<2:
    parser.print_help()
    sys.exit(1)

# Loads classifier and initializes corpus reader
classifier = pickle.load(open(args[0],'rb'))

reader = TabDBCorpusReader('.', '.*db\.tab')
olac_records = reader.records(args[1])

# Classifies each record
if options.num:
    olac_records = olac_records[:options.num]
for record in olac_records:
    bag_of_words = ''
    try:
        bag_of_words += record['title']
    except KeyError:
        pass
    try:
        bag_of_words += ' '+record['subject']
    except KeyError:
        pass
    try:
        bag_of_words += ' '+record['description']
    except KeyError:
        pass
    
    
    iso_results, NE_results = classifier.classify(bag_of_words)
    print '\t'.join([record['Oai_ID'], ' '.join(iso_results), get_or_none(record,'title')])
    if options.debug:
        print '# subject: ' + get_or_none(record,'subject')
        print '# description: ' + get_or_none(record,'description')
        for item_type in NE_results:
            if NE_results[item_type]:
                for NE in NE_results[item_type]:
                    print "# " + item_type + "\t" + NE + "\t" + ' '.join(NE_results[item_type][NE]) 
        print "#--------------------------------------------------"
