'''Reads in training data and outputs a pickled ISO 639 classifier

Created on Jul 6, 2009

@author: Joshua S Hou

Trains an ISO 639 classifier with a datafile in the format described in
wiki:iso639_trainerDatafileFormat.  

Usage: python iso639_trainer.py datafile classifier.pickle
'''

import sys
import os
import pickle
from nltk import *

class iso639Classifier:
    '''Classifier to identify an ISO 639 language code given a language name and
    other contextual clues.
    
    classify -- Returns a list of ISO 639 language codes extracted from text.
    train -- reads in a datafile and stores the information.
    _add_item -- Method for adding country, region and language name data to the classifier's training.
    save -- Pickles the classifier to a file.
    _check_file -- Returns a writable file but asks for overwrite permission if necessary.
    '''
    def __init__(self):
        '''Initializes the four dictionaries that comprise the classifier's
        data.  
        
        country_lang is a simple dictionary that goes from iso3166
        country codes to iso639 language codes.  
        
        country_data, region_data, and lang_data are slightly more complicated,
        but all follow the same format.  They are nested dictionaries that
        essentially function as trees.  For a given country, region, or language
        name that has three tokens, the iso codes associated with that name are
        accessed as follows:
        
        xxx_data[token1][token2][token3]['<<END-OF-item_type>>'] -> [iso1, iso2]
        '''
        self.country_data = {}
        self.lang_data = {}
        self.region_data = {}
        self.country_lang = {} # iso3166 -> list of iso639 codes
        self.debug = False

    def classify(self, text):
        '''For a string of text, uses _identify to identify language, country
        and region names and creates sets of ISO 639 codes for the language,
        country and region names identified.   Returns the intersection of the
        three sets, backing off the region and country name sets if the
        intersection returns a null set.
        '''
        country_iso639s = []
        region_iso639s = []
        lang_iso639s = []
        
        tokens = wordpunct_tokenize(text)
        for i in range(len(tokens)):
            if tokens[i][0].isupper():
                iso639listlists = [self.country_lang[j] for j in\
                                    self._identify(tokens[i:], 'cc', self.country_data)]
                for iso639list in iso639listlists:
                    country_iso639s += iso639list
                region_iso639s += self._identify(tokens[i:], 'rg', self.region_data)
                lang_iso639s += self._identify(tokens[i:], 'sn', self.lang_data)
                lang_iso639s += self._identify(tokens[i:], 'wn', self.lang_data)
        
        iso_set = set(lang_iso639s)
        country_set = set(country_iso639s)
        country_intersection = iso_set.intersection(country_set)
        if country_intersection:
            iso_set = country_intersection
        region_set = set(region_iso639s)
        region_intersection = iso_set.intersection(region_set)
        if region_intersection:
            iso_set = region_intersection
        
        return iso_set

                    
    def _identify(self, tokens, datatype, datastore):
        '''Takes a list of tokens, a datatype, and a nested dictionary datastore
        and traverses the datastore token by token to find language, country, or
        region names in the list of tokens.  Returns a list of ISOs identified
        from the language, country or region names found.  Prints out the
        identified names if debug mode is on.
        '''
        iso_list = []
        data = ''
        ending = "<<END-OF-%s>>" % datatype
        for i in range(len(tokens)):
            if ending in datastore:
                iso_list += datastore[ending]
            if tokens[i] in datastore:
                datastore = datastore[tokens[i]]
                data += ' '+tokens[i]
            else:
                break
        if ending in datastore: # checks the last word
            iso_list += datastore[ending]
            if self.debug:
                print datatype, data
        return iso_list
    
    def train(self, datafile):
        '''Reads in a data file in format specified in wiki:iso639_trainerDatafileFormat
        and loads data into the classifier dictionaries.  
        '''
        data = open(datafile).readlines()
        for line in data:
            iso, item_type, item = line.split('\t')
            if item_type=="sn" or item_type=="wn":
                self._add_item(wordpunct_tokenize(item.strip()), self.lang_data, item_type, iso)
            elif item_type=="cc":
                try:
                    self.country_lang[item].append(iso)
                except KeyError:
                    self.country_lang[item] = [iso]
            elif item_type=="rg":
                self._add_item(wordpunct_tokenize(item.strip()), self.region_data, item_type, iso)
            else:
                self._add_item(wordpunct_tokenize(item.strip()), self.country_data, item_type, iso)
    
    def _add_item(self, tokens, node, item_type, iso):
        '''Recursive method for adding item_type:iso to one of the nested
        data dictionaries.  If there are more tokens left, keep descending
        into the dictionary.  Otherwise, enter <<END-OF-item_type>> -> [iso].
        '''
        if not tokens:
            ending = "<<END-OF-%s>>" % item_type
            try:
                node[ending].append(iso)
            except KeyError:
                node[ending] = [iso]
        else:
            if tokens[0] not in node:
                node[tokens[0]] = {}
            self._add_item(tokens[1:], node[tokens[0]], item_type, iso)
    
    def save(self, filename):
        '''Checks to see if the file already exists and asks for confirmation to
        overwrite if it does.  Pickles the classifier.
        '''
        file = self._check_file(filename)
        pickle.dump(self, file)
    
    def _check_file(self,filename):
        '''Checks to see if a file exists.  Asks for permission to overwrite if
        it does.  Returns the file ready for writing if permission is given, or
        or if the file does not already exist.
        '''
        if os.path.exists(os.path.join(os.getcwd(),filename)):
            a = raw_input("file %s already exists.  Overwrite? [yn]: " % filename)
            if not a.lower()=='y':
                sys.exit(2)
            else:
                print "Overwriting..."
                return open(filename,'wb')
        else:
            return open(filename,'wb')

if __name__=="__main__":
    if len(sys.argv)!=3:
        print "Usage: python iso639_trainer.py datafile classifier.pickle"
        sys.exit(1)
    
    iso639c = iso639Classifier()
    iso639c.train(sys.argv[1])
    iso639c.save(sys.argv[2])