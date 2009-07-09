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
import operator
from nltk import *
from util import check_file

class iso639Classifier:
    '''Classifier to identify an ISO 639 language code given a language name and
    other contextual clues.
    
    classify -- Returns a list of ISO 639 language codes extracted from text.
    train -- reads in a datafile and stores the information.
    _add_item -- Method for adding country, region and language name data to the classifier's training.
    save -- Pickles the classifier to a file.
    '''
    def __init__(self):
        '''Initializes the four dictionaries that comprise the classifier's
        data.  
        
        country_lang is a simple dictionary that goes from iso3166
        country codes to iso639 language codes.  
        
        tree is what contains the language, country, and region name data for
        the classifier.  It is a nested dictionary that functions as a tree that
        can be traversed token by token of a language, country or region name.
        It returns a list of ISO 3166 codes for country names and ISO 639 codes
        for language and region names.  
        
        tree[token1][token2][token3]['<<END>>'] -> {'sn': [iso1, iso2], 'rg':[iso3]}
        '''
        self.tree = {} # token1 -> token2 -> token3 -> <<END-OF-item_type>> -> [iso1,iso2]
        
        self.country_lang = {} # iso3166 -> list of iso639 codes

    def classify(self, text):
        '''For a string of text, uses _identify to identify language, country
        and region names and creates sets of ISO 639 codes for the language,
        country and region names identified.   Returns the intersection of the
        three sets, backing off the region and country name sets if the
        intersection returns a null set.
        '''
        tokens = wordpunct_tokenize(text)
        NE_dict = {'sn':[], 'wn':[], 'cc':[], 'rg':[]}
        for i in range(len(tokens)):
            if tokens[i][0].isupper():
                isos, NEs = self._identify(tokens)
                if isos['cc']:
                    isos['cc'] = reduce(operator.add,([self.country_lang[j] for j in isos['cc']]))
                for item_type in NEs:
                    NE_dict[item_type] += NEs[item_type]
        
        iso_set = set(isos['sn'] + isos['wn'])
        country_set = set(isos['cc'])
        country_intersection = iso_set.intersection(country_set)
        if country_intersection:
            iso_set = country_intersection
        region_set = set(isos['rg'])
        region_intersection = iso_set.intersection(region_set)
        if region_intersection:
            iso_set = region_intersection
        
        return iso_set, NE_dict

                    
    def _identify(self, tokens):
        '''Takes a list of tokens, a datatype, and a nested dictionary datastore
        and traverses the datastore token by token to find language, country, or
        region names in the list of tokens.  Returns a list of ISOs identified
        from the language, country or region names found.
        '''
        iso_lists = {'sn':[], 'wn':[], 'cc':[], 'rg':[]}
        NE_lists = {'sn':[], 'wn':[], 'cc':[], 'rg':[]}
        NE = ''
        ending = "<<END>>"
        node = self.tree
        for i in range(len(tokens)):
            if ending in node:
                for datatype in node[ending]:
                    iso_lists[datatype] += node[ending][datatype] 
                    NE_lists[datatype].append(NE)
            if tokens[i] in node:
                node = node[tokens[i]]
                NE += ' '+tokens[i]
            else:
                break
        if ending in node: # checks the last word
            for datatype in node[ending]:
                iso_lists[datatype] += node[ending][datatype]
                NE_lists[datatype].append(NE)
        return iso_lists, NE_lists
    
    def train(self, datafile):
        '''Reads in a data file in format specified in wiki:iso639_trainerDatafileFormat
        and loads data into the classifier dictionaries.  
        '''
        data = open(datafile).readlines()
        for line in data:
            iso, item_type, item = line.split('\t')
            if item_type=="cc":
                try:
                    self.country_lang[item].append(iso)
                except KeyError:
                    self.country_lang[item] = [iso]
            else:
                self._add_item(wordpunct_tokenize(item.strip()), self.tree, item_type, iso)
    
    def _add_item(self, tokens, node, item_type, iso):
        '''Recursive method for adding item_type:iso to one of the nested data
        dictionaries.  If there are more tokens left, keep descending into the
        dictionary.  Otherwise, enter <<END>> -> { item_type:[iso] }.
        '''
        if not tokens:
            ending = "<<END>>"
            try:
                node[ending][item_type].append(iso)
            except KeyError:
                node[ending] = { item_type:[iso] }
        else:
            if tokens[0] not in node:
                node[tokens[0]] = {}
            self._add_item(tokens[1:], node[tokens[0]], item_type, iso)
    
    def save(self, filename):
        '''Checks to see if the file already exists and asks for confirmation to
        overwrite if it does.  Pickles the classifier.
        '''
        file = check_file(filename)
        pickle.dump(self, file)

if __name__=="__main__":
    if len(sys.argv)!=3:
        print "Usage: python iso639_trainer.py datafile classifier.pickle"
        sys.exit(1)
    
    iso639c = iso639Classifier()
    iso639c.train(sys.argv[1])
    iso639c.save(sys.argv[2])