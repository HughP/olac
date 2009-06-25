#!/usr/bin/python
# iso_extractor.py
# Joshua S Hou
# June 2009

import sys
import pickle
from tabdbreader import *
import string
from operator import itemgetter
from iso_extract_modeler import *

class isoClassifier:
    def __init__(self, model_file, lang_names_file):
        self.model = pickle.load(open(model_file,'rb'))
        self.lang_names = set([i.strip() for i in open(lang_names_file).readlines()]) # normalizing for case
        x = open('lang_name_file_for_testing','w')

    def classify(self, lang):
        """This method returns a dictionary iso codes and probabilities given a language name."""
        results = {}
        for iso in self.model.lang_isos[lang]:
            results[iso] = self.model.prior[iso] * self.model.conditional[iso][lang]
    
    def classify_record(self, record):
        """This method goes through the different fields of a record and gets the language names."""
        results = {}
        langs = []
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
        for word in bag_of_words.strip().split():
            if word in self.lang_names:
                langs.append(word)
        """title, subject, description"""
        print langs
        for lang in langs:
            try:
                results[lang] = self.classify(lang)
            except KeyError:
                pass
        return results

if __name__=="__main__":
    if len(sys.argv)!=4:
        print "Usage: python iso_extractor.py model.pkl lang_names_file tabfile"
        sys.exit(1)
    
    ic = isoClassifier(sys.argv[1], sys.argv[2])

    reader = TabDBCorpusReader('../oai_classifier_trn', '.*db\.tab')
    olac_records = reader.records('olacdb.tab')
    for record in olac_records:
        results = ic.classify_record(record)
        for lang in results:
            print "resulting"
            print record['Archive_ID'], record['Item_ID'], record['title'], lang, sorted(results[lang], key=itemgetter(1), reverse=True)