#!/usr/bin/python
# iso_extract_modeler.py
# Joshua S Hou
# June 2009
#
# This module contains a class isoLangModel that manages the counts and probabilities
# of ISOs and associated primary and alternate language names from an Ethnologue database
# dump to create a Naive Bayes model for classifying language names.  It depends on the
# classes Lang, which is a simple wrapper class for holding a language name and a boolean
# field indicating whether or not it is a primary language name, and EthnologueTrainingDataParser,
# an XML parser that reads an Ethnologue database dump in XML format and stores counts and
# probabilities in a given model file.

import sys
import pickle
from xml.parsers import expat

class EthnologueTrainingDataParser:
    """Class for parsing Ethnologue training data.  It takes as an argument the name of the XML
    file, as well as the model to be populated."""
    def __init__(self, xml_file, model):
        assert(xml_file != "")
        self.xml_file = xml_file
        self.model = model
        self.path = []
        self.Parser = expat.ParserCreate()

        self.Parser.CharacterDataHandler = self.handleCharData
        self.Parser.StartElementHandler = self.handleStartElement
        self.Parser.EndElementHandler = self.handleEndElement

        self.curr_print_name = None
        self.curr_iso = None

    def parse(self):
        try:
            self.Parser.ParseFile(open(self.xml_file))
        except:
            print "File", self.xml_file, "could not be opened."
            sys.exit(1)

    def handleCharData(self, data):
        if self.path[-1]=="print_name":
            self.curr_print_name = data
        elif self.path[-1]=="ISO_code":
            self.model.num_langs += 1
            self.curr_iso = data
            self.model.add_lang(self.curr_iso,Lang(self.curr_print_name,True))
        elif self.path[-1]=="alternate_names":
            alt_names = data.split(', ')
            for alt in alt_names:
                self.model.add_lang(self.curr_iso,Lang(alt,False))

    def handleStartElement(self, name, attrs):
        self.path.append(name)

    def handleEndElement(self, name):
        self.path.pop() # presumably, the XML is well-formed and an end element is obligatorily the closets preceding unclosed begin tag.

class Lang:
    """Simple class just to store language name and whether or not it is a primary name."""
    def __init__(self, langname, primary):
        self.langname = langname # string of language name
        self.primary = primary # boolean of whether or not the language is the primary name

class isoLangModel:
    """This class manages the counts and conditional and prior probabilities for a Naive Bayes
    model of the Ethnologue data for classifying language names to their respective ISO codes."""
    def __init__(self):
        self.num_langs = 0 # for calculating P(iso)
        self.iso_langs = {} # list of Langs for each iso; this is what we are using to calculate probabilities
        self.lang_isos = {} # list of isos per lang, so that in decode stage, we don't have to iterate over the entire iso searchspace.
        self.conditional = {} # iso -> lang -> probability
        self.prior = {} # iso -> probability

    def train(self, trg_data_filename):
        etdp = EthnologueTrainingDataParser(trg_data_filename, self)
        etdp.parse()

    def add_lang(self, iso, lang):
        try:
            self.iso_langs[iso].append(lang)
        except KeyError:
            self.iso_langs[iso] = [lang]
        try:
            self.lang_isos[lang].append(iso)
        except KeyError:
            self.lang_isos[lang] = [iso]

    def calc_prior(self): # right now, the prior P(iso) is just one over the number of isos, it will later take population and geography into effect
        prior_prob = 1.0/self.num_langs
        for iso in self.conditional:
            self.prior[iso] = prior_prob

    def calc_conditional(self):
        for iso in self.iso_langs:
            self.conditional[iso] = {}
            num_langs = len(self.iso_langs[iso]) # number of language names for a given iso
            denom = num_langs + 1 # this is so that the probabilities still add up to one, when I give primary langs a little weight push
            for lang in self.iso_langs[iso]:
                if lang.primary:
                    self.conditional[iso][lang] = 2.0/denom
                else:
                    self.conditional[iso][lang] = 1.0/denom
    
    def print_model(self, outstream):
        for iso in self.prior:
            print>>outstream, iso, self.prior[iso]
        for iso in self.conditional:
            for lang in self.conditional[iso]:
                print>>outstream, iso, lang.langname, self.conditional[iso][lang]

if __name__=="__main__":
    if len(sys.argv)!=4:
        print "Usage: ./iso_extract_modeler.py Ethnologue-classifier-training-data.xml model_format model_output"
        print "Model format: 0 for text, 1 for pickle."
        sys.exit(1)
    ilm = isoLangModel()
    ilm.train(sys.argv[1])
    ilm.calc_conditional()
    ilm.calc_prior()
    if sys.argv[2]=="0":
        ilm.print_model(open(sys.argv[3],'w'))
    else:
        pickle.dump(ilm,open(sys.argv[3],'wb'))
