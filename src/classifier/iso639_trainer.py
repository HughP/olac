# coding=utf-8
'''A classifier that processes records and returns ISO 639-3 codes.

Created on Jul 6, 2009

@author: Joshua S Hou

Contains a class definition for a classifier that process OLAC records and
returns a dictionary of ISO 639-3 codes and associated scores.  Has methods for
loading data, classifying a whole list of records and printing results to file,
and classifying a single record, returning a list of records that is above the
score threshold provided.

If run from shell, main method loads data and saves classifier as a pickle.

Usage: python iso639_trainer.py datafile classifier.pickle
'''

import sys
import os
import pickle
from operator import itemgetter
import optparse
import codecs
from nltk import *
from utilities.util import *

class iso639Classifier:
    '''Classifier to identify an ISO 639 language code given a language name and
    other contextual clues.
    
    classify_records -- classifies a list of records and prints results to a provided printstream
    classify_record -- classifies a single record and returns a list of results
    classify -- classifies a record and returns the country, region and language names found in the text with proposed ISO 639-3 codes
    _identify -- identifies country, language and region names; helper method for classify
    weighted -- returns a dictionary of ISO 639 codes and weights given the language, country and region names found
    _populate_dict -- helper method for weighted
    train -- reads in a datafile and stores the information.
    _add_item -- method for adding country, region and language name data to the classifier's training.
    save -- pickles the classifier to a file.
    trim -- removes an entry from the tree; used for stoplisting
    trim_from_file -- uses trim to remove an entire stoplist of words from file
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
        self.first_chars = u"‡!’/'"
        self.stoplist = set(['the','some','central','western','eastern','northern','southern','north','south','east','west']) # stoplist of tokens that are too common
        self.gs = None # if it exists, this is a list of lines from the gold standard
        self.ending = "<<END>>"
        
    def classify_records(self, debug, records, outstream, threshold, snw, wnw, a, b):
        '''Classifies a list of records and prints the results to outstream.'''
        i = -1
        for record in records:
            title = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'title')))
            subject = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'subject')))
            descr = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'description')))
            i += 1
            iso_dict, NE_results = self.classify(record, snw, wnw, a, b)
#           iso_results = filter(lambda x:iso_dict[x]>=threshold, iso_dict.keys())
            iso_results = [x for (x,y) in sorted(iso_dict.items(), key=itemgetter(1)) if y>=threshold and x!='high_score'] # top 5 that reach above threshold
#           if iso_dict:
#               top_choice = sorted(iso_dict.items(),key=operator.itemgetter(1),reverse=True)[0][0]
#               if top_choice not in iso_results:
#                   iso_results.append(top_choice)
            print>>outstream, '\t'.join([record['Oai_ID'], ' '.join(iso_results), title])
            if debug:
                if self.gs:
                    print>>outstream, '# gs:', self.gs[i].rstrip().decode('utf-8')
                print>>outstream, '# isos: ', iso_dict
                print>>outstream, '# subject: ' + subject
                print>>outstream, '# description: ' + descr
                for item_type in NE_results:
                    if NE_results[item_type]:
                        for NE in NE_results[item_type]:
                            print>>outstream, "# " + item_type + "\t" + NE + "\t[" + ' '.join(NE_results[item_type][NE])+']' 
                print>>outstream, "#--------------------------------------------------"

    def classify_record(self, record, threshold, snw, wnw, a, b, debug=False):
        '''For a single record, returns a list of ISO 639-3 codes that have a
        weight higher than a given threshold'''
        iso_results, NE_dict = self.classify(record, snw, wnw, a, b)
        if debug:
            return iso_results
        else:
            return [i for i in iso_results if iso_results[i]>threshold]

    def classify(self, record, snw, wnw, a, b):
        '''For a string of text, uses _identify to identify language, country
        and region names and creates sets of ISO 639 codes for the language,
        country and region names identified.   Uses weighted to determine
        weights for each iso code.
        '''
        title = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'title')))
        subject = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'subject')))
        descr = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'description')))
        bag_of_words = title + ' \\n ' + subject + ' \\n ' + descr # purposely adding a token here so that we won't get NEs recognized "over the borders"

        tokens = wordpunct_tokenize(bag_of_words)
        NE_dict = {'mn':{}, 'sn':{}, 'wn':{}, 'cn':{}, 'rg':{}}
        i = 0
        while i<len(tokens):
            first_l = tokens[i][0]
            #if first_l.isupper() or first_l in self.first_chars:
            if True:
                NE, iso_types = self._identify(tokens[i:])
                if NE:
                    i += len(NE.split()) - 1 # increase counter by num_words(NE) - 1 so that we don't find another NE inside this one.
                    for type in iso_types:
                        if type=='cn':
                            isos = reduce(set.union,[self.country_lang[j] for j in iso_types[type]])
                        else:
                            isos = iso_types[type]
                        NE_dict[type][NE] = isos
            i += 1
        
        results = self.weighted(NE_dict, snw, wnw, a, b)
        return results, NE_dict

    def classify_round_robin(self, record):
        '''For a string of text, uses _identify to identify language, country
        and region names and creates sets of ISO 639 codes for the language,
        country and region names identified.   Uses weighted to determine
        weights for each iso code.
        '''
        title = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'title')))
        subject = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'subject')))
        descr = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'description')))
        bag_of_words = title + ' \\n ' + subject + ' \\n ' + descr # purposely adding a token here so that we won't get NEs recognized "over the borders"

        tokens = wordpunct_tokenize(bag_of_words)
        NE_dict = {'mn':{}, 'sn':{}, 'wn':{}, 'cn':{}, 'rg':{}}
        i = 0
        while i<len(tokens):
            first_l = tokens[i][0]
            #if first_l.isupper() or first_l in self.first_chars:
            if True:
                NE, iso_types = self._identify(tokens[i:])
                if NE:
                    i += len(NE.split()) - 1 # increase counter by num_words(NE) - 1 so that we don't find another NE inside this one.
                    for type in iso_types:
                        if type=='cn':
                            isos = reduce(set.union,[self.country_lang[j] for j in iso_types[type]])
                        else:
                            isos = iso_types[type]
                        NE_dict[type][NE] = isos
            i += 1
        results = []
        for j in range(len(self.params)):
            results.append(self.weighted(NE_dict, self.params[j][0], self.params[j][1], self.params[j][2], self.params[j][3]))
        #results = self.weighted(NE_dict, snw, wnw, a, b)
        return results, NE_dict

    def classify_records_round_robin(self, debug, records, file_header, params, thresholds):
        '''Classifies a list of records and prints the results to outstream.'''
        self.params = params
        gs_idx = -1
        outstreams = [codecs.open(file_header+str(i)+'.txt','w',encoding='utf-8') for i in range(len(params)*len(thresholds))]
        for j in range(len(params)):
            for z in range(len(thresholds)):
                out_index = j*len(thresholds)+z
                print>>outstreams[out_index], '# threshold:', thresholds[z]
                print>>outstreams[out_index], '# params:', params[j]
        for record in records:
            title = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'title')))
            subject = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'subject')))
            descr = remove_diacritic(self.spaces.sub(' ',get_or_none(record, 'description')))
            gs_idx += 1
            #iso_dict, NE_results = self.classify(record, snw, wnw, a, b)
            iso_dicts, NE_results = self.classify_round_robin(record)
            for j in range(len(iso_dicts)):
                for z in range(len(thresholds)):
                    out_index = j*len(thresholds)+z
                    iso_results = filter(lambda x:iso_dicts[j][x]>=thresholds[z], iso_dicts[j].keys())
                    print>>outstreams[out_index], '\t'.join([record['Oai_ID'], ' '.join(iso_results), title])
                    if debug:
                        if self.gs:
                            print>>outstreams[out_index], '# gs:', self.gs[gs_idx].rstrip().decode('utf-8')
                        print>>outstreams[out_index], '# isos: ', iso_dicts[j]
                        print>>outstreams[out_index], '# subject: ' + subject
                        print>>outstreams[out_index], '# description: ' + descr
                        for item_type in NE_results:
                            if NE_results[item_type]:
                                for NE in NE_results[item_type]:
                                    print>>outstreams[out_index], "# " + item_type + "\t" + NE + "\t[" + ' '.join(NE_results[item_type][NE])+']' 
                        print>>outstreams[out_index], "#--------------------------------------------------"


    def _identify(self, tokens):
        '''For a list of tokens, goes through the tree and returns the longest
        language, country or region name it can find, along the item_type, and
        the associated list of ISO 639 codes.  Normalizes case, because the
		data stored in the tree is all lower case.
        '''
        token_0 = remove_diacritic(tokens[0].lower())
        if token_0 in self.tree:
            type_isos = {}
            curr_NE = token_0
            final_NE = ''
            node = self.tree[token_0]
            i = 1 # a counter
            while i<len(tokens):
                if self.ending in node:
                    if curr_NE not in self.stoplist:
                        type_isos = node[self.ending]
                        final_NE = curr_NE
                token_i = remove_diacritic(tokens[i].lower())
                if token_i in node:
                    node = node[token_i]
                    curr_NE += ' '+token_i
                else: # there is no more viable path in the tree
                    if token_i=="language" and ('sn' in type_isos or 'wn' in type_isos or 'mn' in type_isos):
                        # if at the end of an NE you see "language" as the next token, give sn/wn more weight
                        curr_NE += ' language'
                        final_NE = curr_NE
                        type_isos.pop('rg',None)
                        type_isos.pop('cn',None)
                        type_isos.pop('cc',None)
                    break
                i += 1
            if self.ending in node and i>=len(tokens): # checks the last word
                if curr_NE not in self.stoplist:
                    type_isos = node[self.ending]
                    final_NE = curr_NE
            return final_NE, type_isos
        else:
            return '',{}

#   def clean_dict(self,dict1,dict2):
#       for NE in dict1:
#           if NE in dict2:
#               inter = dict1[NE].intersection(dict2[NE])
#               dict2[NE].difference_update(inter)

    def weighted(self, NE_dict, snw, wnw, a, b):
        '''Returns a dictionary of ISO 639-3 codes and associated weights
        calculated from the language, region and country names found by
        classify.'''
        results = {}

        langdict = {}
        countrydict = {}
        regiondict = {}

#       self.clean_dict(NE_dict['mn'],NE_dict['sn'])
#       self.clean_dict(NE_dict['mn'],NE_dict['wn'])
#       self.clean_dict(NE_dict['sn'],NE_dict['wn'])
        self._populate_dict(NE_dict['mn'], langdict, snw*2)
        self._populate_dict(NE_dict['sn'], langdict, snw)
        self._populate_dict(NE_dict['wn'], langdict, wnw)
        self._populate_dict(NE_dict['cn'], countrydict, 1.0)
        self._populate_dict(NE_dict['rg'], regiondict, 1.0)

        if NE_dict['cn'].values():
            country = reduce(set.union, NE_dict['cn'].values())
        else:
            country = set()
        if NE_dict['rg'].values():
            region = reduce(set.union, NE_dict['rg'].values())
        else:
            region = set()

        for iso in langdict:
            l = langdict[iso]
            c = 0.0
            r = 0.0
            if iso in country:
                c = 1.0
            if iso in region:
                r = 1.0
            results[iso] = l + a*(l*c) + b*(l*r)
        if len(results.keys())==0:
            return results
        else:
            # normalize
            high_score = sorted(results.values())[-1]
            for iso in results:
                results[iso]/=high_score
            results['high_score'] = high_score # puts the high score in there for eval purposes
            return results

    def _populate_dict(self, input_dict, langdict, C):
        '''Helper function for weighted'''
        for NE in input_dict:
            NE_len = len(NE.split())
            for iso in input_dict[NE]:
                try:
                    langdict[iso] += NE_len*C
                except KeyError:
                    langdict[iso] = NE_len*C   

    def train(self, datadir):
        '''Reads in a data file in format specified in wiki:iso639_trainerDatafileFormat
        and loads data into the classifier dictionaries.  
        '''
        data = []
        for datafile in os.listdir(datadir):
            if datafile[0]!='.':
                data += codecs.open(os.path.join(datadir,datafile), encoding='utf-8').readlines()
        for line in data:
            if line.strip(u'\n\t\r﻿')[0]=='#' or not line.strip():
                continue
            try:
                iso, item_type, item = line.strip().split('\t')
            except ValueError:
                sys.exit(line.strip().split('\t'))
            if item_type==u"cc":
                try:
                    self.country_lang[item].add(iso)
                except KeyError:
                    self.country_lang[item] = set([iso])
            else:
                item = remove_diacritic(item.lower())
                if "'" in item: # also add version without apostrophe
                    self._add_item(wordpunct_tokenize(item.strip().replace("'","")), self.tree, item_type, iso)
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
            if tokens[0] not in node:
                node[tokens[0]] = {}
            self._add_item(tokens[1:], node[tokens[0]], item_type, iso)
    
    def save(self, filename, force):
        '''Checks to see if the file already exists and asks for confirmation to
        overwrite if it does.  Pickles the classifier.
        '''
        if force:
            file = open(filename,'wb')
        else:
            file = check_file(filename, 'wb')
        pickle.dump(self, file)

    def trim(self, word, type='', iso=''):
        '''Trims an entry from the tree.  If type and iso are specified, only
        removes those isos for the given type.  If only type is specified,
        removes every entry for the given type.  If neither type nor iso are
        specified, removes all instances of "word" from the tree.  Returns the
        deleted item.  Returns None if no item is deleted (if iso, type, or word
        does not exist in tree.)'''
        tokens = wordpunct_tokenize(word)
        orig_tokens = tokens
        delete_node = self.tree
        delete_key = tokens[0] 
        node = self.tree
        # traverse the tree until we get to the end
        while tokens:
            if tokens[0] in node:
                if len(node.keys())!=1:
                    delete_node = node # parent of tokens[0]
                    delete_key = tokens[0]
                node = node[tokens[0]]
                tokens.pop(0)
            else:
                return None
        # node is at the end of the tree now
        if '<<END>>' not in node or (type and type not in node['<<END>>']) or (type and iso and iso not in node['<<END>>'][type]):
            return None
        else:
            if (type and len(node['<<END>>'].keys())>1) or (type and iso and len(node['<<END>>'][type])>1):
                if not iso:
                    return node['<<END>>'].pop(type)
                else:
                    node['<<END>>'][type].remove(iso)
                    return iso
            else:
                return delete_node.pop(delete_key)

    def trim_from_file(self, stoplist_file):
        '''Uses trim to remove this stoplist of words from the tree.'''
        for line in codecs.open(stoplist_file,encoding='utf-8').readlines():
            splitlist = line.strip(u'\r\n').split(u'\t')
            iso = ''
            type = ''
            if len(splitlist)==1:
                data = splitlist[0]
            elif len(splitlist)==2:
                type, data = splitlist
            else:
                iso, type, data = splitlist
            self.trim(data,type,iso)

def main():
    '''Saves a pickled classifier.  Meant to be called from command line.'''
    parser = optparse.OptionParser(usage='python iso639_trainer.py [options] datafile classifier.pickle')
    parser.add_option('-f', '--force', action='store_true', dest='force', help='forces overwrite')
    parser.add_option('-s', '--stoplist', dest='stoplist', help='use a stoplist')
    (options,args) = parser.parse_args()

    if len(args)!=2:
        parser.print_help()
        sys.exit(1)

    iso639c = iso639Classifier()
    iso639c.train(args[0])
    if options.stoplist:
        iso639c.trim_from_file(options.stoplist)
    iso639c.save(args[1], options.force)
if __name__=="__main__":
    main()
