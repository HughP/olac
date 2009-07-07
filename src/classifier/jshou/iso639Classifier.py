'''Reads OLAC records from olacdb.tab and prints out hypothesized ISO 639 language codes

Created on Jul 6, 2009

@author: jshou



iso639Classifier -- Reads olacdb2.tab data and prints possible ISO 639 language codes for each record
'''

import sys
import pickle
from tabdbreader2 import *
from iso639_trainer import *
    
if len(sys.argv)<3:
    print "Usage: python iso639Classifier.py classifier.pickle input 1 > classifier-output"
    print len(sys.argv)
    sys.exit(1)

classifier = pickle.load(open(sys.argv[1],'rb'))
if len(sys.argv)>3 and sys.argv[3]=="1":
    classifier.debug=True

reader = TabDBCorpusReader('../oai_classifier_trn', '.*db\.tab')
olac_records = reader.records(sys.argv[2])

#print>>sys.stderr, "Number of olac records:", len(olac_records)

for record in olac_records[-5000:]:
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
    
    try:
        title = record['title']
    except KeyError:
        title = ''
    
    results = classifier.classify(bag_of_words)
    print '\t'.join([record['Oai_ID'], ' '.join(results), title])