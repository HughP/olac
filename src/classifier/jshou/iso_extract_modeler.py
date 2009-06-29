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
import re
import pickle
import string
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
        
        self.tempalt = '' # temporarily stores a possibly partial list of alternate names, because the XML parser seems to sometimes find the CharData for alternate names in chunks instead of in one go.
        self.tempprim = ''
        self.tempiso = ''
        self.tempcountry = ''
        self.tempregion = ''
        
        self.curr_print_name = None
        self.curr_iso = None

    def parse(self):
#        try:
            self.Parser.ParseFile(open(self.xml_file))
#        except:
#            print "File", self.xml_file, "could not be opened."
#            sys.exit(1)

    def handleCharData(self, data):
        if self.path[-1]=="print_name":
            self.tempprim += data.encode('utf-8')
        elif self.path[-1]=="ISO_code":
            self.tempiso += data.encode('utf-8')
        elif self.path[-1]=="alternate_names":
            self.tempalt += data.encode('utf-8')
        elif self.path[-1]=="country_name":
            self.tempcountry += data.encode('utf-8')
        elif self.path[-1]=="region":
            self.tempregion += data.encode('utf-8')

    def handleStartElement(self, name, attrs):
        self.path.append(name)

    def handleEndElement(self, name):
        if name=="alternate_names":
            for alt in self.tempalt.split(', '):
                if alt:
                    self.model.add_iso(alt, isoLang(self.curr_iso, alt, False))
            self.altlist = ''
        elif name=="print_name":
            self.curr_print_name = self.tempprim
            self.tempprim = ''
        elif name=="ISO_code":
            self.curr_iso = self.tempiso
            self.tempiso = ''
            self.model.add_iso(self.curr_print_name, isoLang(self.curr_iso, self.curr_print_name, True))
        elif name=="country_name":
            try:
                self.model.c_iso_country[self.tempcountry].append(self.curr_iso)
            except KeyError:
                self.model.c_iso_country[self.tempcountry] = [self.curr_iso]
            self.tempcountry = ''
        elif name=="region":
            self.model.add_region(self.curr_iso, self.tempregion)
            self.tempregion = ''
        self.path.pop() # presumably, the XML is well-formed and an end element is necessarily the closest preceding unclosed begin tag.

class isoLang:
    """Class that defines an iso-language name pair.  self.primary indicates
    whether this language name is the primary name for the iso code."""
    def __init__(self, iso, lang_name, primary):
        self.iso = iso
        self.lang_name = lang_name
        self.primary = primary

class isoLangModel:
    def __init__(self):
        self.c_iso_lang = {} # Dictionary from lang to iso.  lang -> list of isos
        self.c_iso_country = {} # Dictionary from country -> list of isos
        self.c_iso_region = {} # Dictionary from region -> list of isos
        
        self.p_iso_lang = {} # Dictionary of P(iso|lang).  lang -> iso -> prob
        self.region_NE = re.compile(r'([A-Z]\w*\s?)+')
    
    def train(self, trg_data_filename):
        etdp = EthnologueTrainingDataParser(trg_data_filename, self)
        etdp.parse()
    
    def add_iso(self, lang, iso_lang):
        """iso_lang must be of type isoLang"""
        try:
            self.c_iso_lang[lang].append(iso_lang)
        except KeyError:
            self.c_iso_lang[lang] = [iso_lang]
    
    def add_region(self, iso, region_string):
        region_NEs = self.region_extract(region_string)
        for ne in region_NEs:
            try:
                self.c_iso_region[ne].append(iso)
            except KeyError:
                self.c_iso_region[ne] = [iso]
    
    def region_extract(self, region_string):
        """Returns a list of region named entities, where region NEs are defined
        as consecutive capitalized words."""
        return map(string.strip, self.region_NE.findall(region_string))
    
    def calc_probs(self):
        for lang in self.c_iso_lang:
            self.p_iso_lang[lang] = {}
            p_iso = self.p_iso_lang[lang]
            denom = 0
            for isoLang in self.c_iso_lang[lang]:
                if isoLang.primary:
                    p_iso[isoLang.iso] = 2.0
                else:
                    p_iso[isoLang.iso] = 1.0
                denom += p_iso[isoLang.iso]
            for iso in p_iso:
                p_iso[isoLang.iso] /= denom
    
    def print_model(self, outstream):
        for lang in self.p_iso_lang:
            for iso in self.p_iso_lang[lang]:
                print>>outstream, iso, lang, self.p_iso_lang[lang][iso]
   
if __name__=="__main__":
    if len(sys.argv)!=4:
        print "Usage: ./iso_extract_modeler.py Ethnologue-classifier-training-data.xml model_format model_output"
        print "Model format: 0 for text, 1 for pickle."
        sys.exit(1)
    ilm = isoLangModel()
    ilm.train(sys.argv[1])
    ilm.calc_probs()
    if sys.argv[2]=="0":
        ilm.print_model(open(sys.argv[3],'w'))
    else:
        pickle.dump(ilm,open(sys.argv[3],'wb'))
