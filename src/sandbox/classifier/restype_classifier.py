#!/usr/bin/python
'''Trains a maxent classifier and saves to pickle

Created on Aug 24, 2009

@author: Joshua S Hou
'''
import sys
import optparse
import pickle
import nltk
from nltk.classify import maxent
from nltk.classify import naivebayes
from nltk.probability import FreqDist
from utilities.util import *
from tabdbreader import *

def doc_features(record):
    f = FreqDist()
    label = record.pop('target','')
    words = ' '.join(record.values())
    map(f.inc, wordpunct_tokenize(words.lower()))
    if label:
        record['target'] = label
    return f

def train(args, records, force):
    # sets record['target'] as label or 'NONE' if it doesn't exist'
    train_toks = [(doc_features(record),record.pop('target','NONE')) for record in records]
#   for tok in train_toks:
#       print tok[1]
#   rtc = maxent.train_maxent_classifier_with_gis(train_toks)
    rtc = naivebayes.NaiveBayesClassifier.train(train_toks)
    if force:
        file = open(args[1],'wb')
    else:
        file = check_file(args[1],'wb')
    pickle.dump(rtc, file)

def test(args, records):
    classifier = pickle.load(open(args[1],'rb'))
    classified_toks = [(record['record_id'], record.pop('target','NONE'), classifier.classify(doc_features(record))) for record in records]
    correct = len([a for a in classified_toks if a[1]==a[2]])
    print "Accuracy:", (correct+0.0)/len(classified_toks)

def main():
    parser = optparse.OptionParser(usage='python [options] restype_classifier.py data_dir classifier.pickle')
    parser.add_option('-f','--force',action="store_true", default=False, dest='force', help="forces overwrite of classifier.pickle")
    parser.add_option('-t','--test', action="store_true", default=False, dest="test", help="Classify")
    (options, args) = parser.parse_args()
    if len(args)!= 2:
        parser.print_help()
        sys.exit(1)
    elif options.test and options.force:
        parser.print_help()
        sys.exit("Error: --force and --test cannot be used simultaneously")
 
    reader = TabDBCorpusReader(args[0], '.*\.txt')
    records = reader.records()
   
    if options.test:
        test(args, records)
    else:
        train(args, records, options.force)

if __name__=="__main__":
    main()
