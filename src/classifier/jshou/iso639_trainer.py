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
import codecs
from nltk import *
from util import *

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
        
        tree is what contains the language, country, and region name data for
        the classifier.  It is a nested dictionary that functions as a tree that
        can be traversed token by token of a language, country or region name.
        It returns a list of ISO 3166 codes for country names and ISO 639 codes
        for language and region names.  
        
        xxx_data[token1][token2][token3]['<<END-OF-item_type>>'] -> [iso1, iso2]
        '''
        self.tree = {} # token1 -> token2 -> token3 -> <<END-OF-item_type>> -> [iso1,iso2]
        self.country_lang = {} # iso3166 -> list of iso639 codes
        self.spaces = re.compile(r'\s+')
        
    def classify_records(self, debug, records, outstream):
        '''Classifies a list of records and prints the results to outstream.'''
        for record in records:
            title = self.spaces.sub(' ',get_or_none(record, 'title')).encode('ascii','ignore')
            subject = self.spaces.sub(' ',get_or_none(record, 'subject')).encode('ascii','ignore')
            descr = self.spaces.sub(' ',get_or_none(record, 'description')).encode('ascii','ignore')
            bag_of_words = title + ' ' + subject + ' ' + descr

            iso_results, NE_results = self.classify(bag_of_words)
            print>>outstream, '\t'.join([record['Oai_ID'], ' '.join(iso_results), title])
            if debug:
                print>>outstream, '# subject: ' + subject
                print>>outstream, '# description: ' + descr
                for item_type in NE_results:
                    if NE_results[item_type]:
                        for NE in NE_results[item_type]:
                            print>>outstream, "# " + item_type + "\t" + NE + "\t[" + ' '.join(NE_results[item_type][NE])+']' 
                print>>outstream, "#--------------------------------------------------"

    def classify(self, text):
        '''For a string of text, uses _identify to identify language, country
        and region names and creates sets of ISO 639 codes for the language,
        country and region names identified.   Returns the intersection of the
        three sets, backing off the region and country name sets if the
        intersection returns a null set.
        '''
        tokens = wordpunct_tokenize(text)
        NE_dict = {'sn':{}, 'wn':{}, 'cn':{}, 'rg':{}}
        iso_dict = {'sn':set(), 'wn':set(), 'cn':set(), 'rg':set()}
        i = 0
        while i<len(tokens):
            if tokens[i][0].isupper():
                NE, iso_types = self._identify(tokens[i:])
                if NE:
                    i += len(NE.split()) - 1 # increase counter by num_words(NE) - 1 so that we don't find another NE inside this one.
                    for type in iso_types:
                        if type=='cn':
                            isos = reduce(operator.add,[self.country_lang[j] for j in iso_types[type]])
                        else:
                            isos = iso_types[type]
                        iso_dict[type].update(isos)
                        NE_dict[type][NE] = isos
            i += 1
        
        iso_set = iso_dict['sn'].union(iso_dict['wn'])
#        country_set = iso_dict['cn']
#        country_intersection = iso_set.intersection(country_set)
#        if country_intersection:
#            iso_set = country_intersection
#        region_set = iso_dict['rg']
#        region_intersection = iso_set.intersection(region_set)
#        if region_intersection:
#            iso_set = region_intersection

        # for now, don't bother looking at geography; we want to have as high recall as possible.
        return iso_set, NE_dict

                    
    def _identify(self, tokens):
        '''For a list of tokens, goes through the tree and returns the longest
        language, country or region name it can find, along the item_type, and
        the associated list of ISO 639 codes.  Normalizes case, becaues the
		data stored in the tree is all lower case.
        '''
        type_isos = {}
        final_NE = ''
        curr_NE = ''
        ending = "<<END>>"
        node = self.tree
        i = 0 # a counter
        while i<len(tokens):
            if ending in node:
                final_NE = curr_NE
                curr_NE = ''
                type_isos = node[ending]
            token_i = tokens[i].lower().encode('ascii','ignore')
            if token_i in node:
                node = node[token_i]
                curr_NE += ' '+token_i
            else:
                i += 1
                break
            i += 1
        if ending in node and i>len(tokens): # checks the last word
            final_NE = curr_NE
            curr_NE = ''
            type_isos = node[ending]
        return final_NE, type_isos
    
    def train(self, datafile):
        '''Reads in a data file in format specified in wiki:iso639_trainerDatafileFormat
        and loads data into the classifier dictionaries.  
        '''
        data = codecs.open(datafile, encoding='utf-8').readlines()
        for line in data:
            iso, item_type, item = [i.encode('ascii','ignore') for i in line.strip().split('\t')]
            if item_type=="cc":
                try:
                    self.country_lang[item].add(iso)
                except KeyError:
                    self.country_lang[item] = set([iso])
            else:
                self._add_item(wordpunct_tokenize(item.strip()), self.tree, item_type, iso)
    
    def _add_item(self, tokens, node, item_type, iso):
        '''Recursive method for adding item_type:iso to one of the nested data
        dictionaries.  If there are more tokens left, keep descending into the
        dictionary.  Otherwise, enter <<END>> -> { item_type:iso }.  Normalizes
		case.
        '''
        if not tokens:
            ending = "<<END>>"
            if ending not in node:
                node[ending] = {}
            try:
                node[ending][item_type].add(iso)
            except KeyError:
                node[ending][item_type] = set([iso])
        else:
            tokens[0] = tokens[0].lower()
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
