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
from tabdbreader2 import *
from xmlreader import *
from iso639_trainer import *
from utilities.util import *

# Loads classifier and initializes corpus reader
print "Loading classifier..."
classifier = pickle.load(open('test_data/classifier.pickle','rb'))

#if args[1][-4:]!='.xml':
#    reader = TabDBCorpusReader('.', '.*db\.tab')
#else:
#    reader = XMLCorpusReader('.','.*\.xml')
#olac_records = reader.records(args[1])
print "Loading test data..."
reader = TabDBCorpusReader('test_data/','.*\.tab')
records = reader.records('iso639_test2.tab')
# sets parameters
thresholds = [0.4,0.6,0.8,1.0]
print "Setting parameters..."
params = []
for a in [i/100.0 for i in range(60,90,5)]:
    # only varying wnw
    params.append([1.0,a,1.0,1.0])

# Classifies each record
print "Classifying..."
classifier.gs = open('test_data/iso639_test2.gs').readlines()
classifier.classify_records_round_robin(True, records, 'experiments/wnw/wnw_experiment', params, thresholds)
