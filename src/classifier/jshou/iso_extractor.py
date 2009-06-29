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
    def __init__(self, model_file):
        self.model = pickle.load(open(model_file,'rb'))
    
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
        
        iso_set = set()
        for lang_name in self.model.c_iso_lang:
            if lang_name in bag_of_words:
                iso_set.update(self.model.c_iso_lang[lang_name])
        
        country_iso_set = set()
        for country_name in self.model.c_iso_country:
            if country_name in bag_of_words:
                country_iso_set.update(self.model.c_iso_country[country_name])
        
        region_iso_set = set()
        for region in self.model.c_iso_region:
            if region in bag_of_words:
                region_iso_set.update(self.model.c_iso_region[region])
        
        country_intersection = iso_set.intersection(country_iso_set)
        if country_intersection:
            iso_set = country_intersection
        region_intersection = iso_set.intersection(region_iso_set)
        if region_intersection:
            iso_set = region_intersection
        # title, subject, description
        return iso_set

if __name__=="__main__":
    if len(sys.argv)!=4:
        print "Usage: python iso_extractor.py model.pkl tabfile outfile"
        sys.exit(1)
    
    ic = isoClassifier(sys.argv[1])

    reader = TabDBCorpusReader('../oai_classifier_trn', '.*db\.tab')
    olac_records = reader.records('olacdb.tab')
    
    outfile = open(sys.argv[3],'w') 
    for record in olac_records:
        results = ic.classify_record(record)
        try:
            title = record['title']
        except KeyError:
            title = 'TITLE_UNKNOWN'
        print>>outfile, '\t'.join([record['Archive_ID'], record['Item_ID'], title, ' '.join(results)])