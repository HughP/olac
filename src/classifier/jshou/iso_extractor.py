#!/usr/bin/python
# iso_extractor.py
# Joshua S Hou
# June 2009

import sys
import pickle
from iso_extract_modeler import isoLangModel

class isoExtractor:
    def __init__(self):
        pass  

class isoClassifier:
    def __init__(self, model_file, lang_names_file):
        self.model = pickle.load(open(model_file,'rb'))
        self.lang_names = open(lang_names_file).readlines()

    def classify(self, lang):
        """This method returns a dictionary iso codes and probabilities given a language name."""
        results = {}
        for iso in self.model.lang_isos[lang]:
            results[iso] = self.model.prior[iso] * self.model.conditional[iso][lang]
    
    def classify_record(self, record):
        """This method goes through the different fields of a record and gets the language names."""

if __name__=="__main__":
    if len(sys.argv)!=2:
        print "Usage: python iso_extractor.py model.pkl lang_names_file"
        sys.exit(1)