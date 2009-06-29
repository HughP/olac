#!/usr/bin/python
# iso_extract_modeler.py
# Joshua S Hou
# June 2009
#
# This module contains a class isoLangModel that manages the counts
# of ISOs and associated primary and alternate language names from an Ethnologue database
# dump to create a model for classifying language names.  It depends on the
# classes isoLang, which is a simple wrapper class for holding a language name, iso and a boolean
# field indicating whether or not it is a primary language name, and EthnologueTrainingDataParser,
# an XML parser that reads an Ethnologue database dump in XML format and stores counts 
# in a given model file.

import sys
import re
import pickle
import string
from xml.parsers import expat

class EthnologueTrainingDataParser:
    """Class for parsing Ethnologue training data.  It takes as an argument the name of the XML
    file, as well as the model to be populated.  For each tag "alternate_names", "print_name",
    "country_name" and "region", calls the model's methods for keeping track of iso codes associated
    with each tag."""
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
        
        self.spaces = re.compile(r'\s+')
        
        self.curr_print_name = None
        self.curr_iso = None

    def parse(self):
        self.Parser.ParseFile(open(self.xml_file))

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
            self.tempalt = self.spaces.sub(' ', self.tempalt)
            for alt in self.tempalt.split(', '):
                if alt:
                    self.model.add_iso(alt, isoLang(self.curr_iso, alt, False))
            self.tempalt = ''
        elif name=="print_name":
            self.curr_print_name = self.spaces.sub(' ',self.tempprim)
            self.tempprim = ''
        elif name=="ISO_code":
            self.curr_iso = self.tempiso
            self.tempiso = ''
            self.model.add_iso(self.curr_print_name, isoLang(self.curr_iso, self.curr_print_name, True))
        elif name=="country_name":
            self.tempcountry = self.spaces.sub(' ', self.tempcountry)
            self.model.add_country(self.tempcountry, self.curr_iso)
            self.tempcountry = ''
        elif name=="region":
            self.tempregion = self.spaces.sub(' ', self.tempregion)
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
    """Class that keeps track of ISO 639-3 codes associated with each country, region, and language name
    as stored in the Ethnologue."""
    def __init__(self):
        self.c_iso_lang = {} # Dictionary from lang to iso.  lang -> list of isoLangss
        self.c_iso_country = {} # Dictionary from country -> list of isos
        self.c_iso_region = {} # Dictionary from region -> list of isos
        
        self.p_iso_lang = {} # Dictionary of P(iso|lang).  lang -> iso -> prob
        self.region_NE = re.compile(r'([A-Z]\w*\s?)+')
    
    def train(self, trg_data_filename):
        """Uses the EthnologueTrainingDataParser parse method to parse the XML Ethnologue training data."""
        etdp = EthnologueTrainingDataParser(trg_data_filename, self)
        etdp.parse()
    
    def add_iso(self, lang, iso_lang):
        """Adds iso_lang to language name lang.  iso_lang must be of type isoLang."""
        lang = lang.strip('"')
        if "," in lang:
            splitname = lang.split(',')
            lang = (splitname[1]+' '+splitname[0]).strip()
        try:
            self.c_iso_lang[lang].append(iso_lang)
        except KeyError:
            self.c_iso_lang[lang] = [iso_lang]
    
    def add_region(self, iso, region_string):
        """Adds iso to region."""
        region_NEs = self.region_extract(region_string)
        for ne in region_NEs:
            try:
                self.c_iso_region[ne].append(iso)
            except KeyError:
                self.c_iso_region[ne] = [iso]
    
    def add_country(self, country, iso):
        """Adds iso to country."""
        try:
            self.c_iso_country[country].append(iso)
        except KeyError:
            self.c_iso_country[country] = [iso]
    
    def region_extract(self, region_string):
        """Returns a list of region named entities, where region NEs are defined
        as consecutive capitalized words."""
        return map(string.strip, self.region_NE.findall(region_string))
    
    def calc_probs(self):
        """Calculates probability of each iso given a language name and stores the
        results in a dictionary.  This method is currently not being used, because
        we are not calculating probabilities for now."""
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
        """Prints out the list of isos associated with each country, language name, and region stored
        in the model."""
        for country in self.c_iso_country:
            print>>outstream, "Country"+'\t'+country+'\t'+' '.join(self.c_iso_country[country])
        for lang in self.c_iso_lang:
            print>>outstream, "Language_name"+'\t'+lang+'\t'+' '.join([x.iso for x in self.c_iso_lang[lang]])
        for region in self.c_iso_region:
            print>>outstream, "Region"+'\t'+region+'\t'+' '.join(self.c_iso_region[region])
#        this code below is the function for printing part of the old model with probabilities
#        for lang in self.p_iso_lang:
#            for iso in self.p_iso_lang[lang]:
#                print>>outstream, iso, lang, self.p_iso_lang[lang][iso]
    def read_model(self, modelfilename):
        """Clears whatever is currently stored in the model and reads in a model from file."""
        self.c_iso_lang = {} # Dictionary from lang to iso.  lang -> list of isoLangss
        self.c_iso_country = {} # Dictionary from country -> list of isos
        self.c_iso_region = {} # Dictionary from region -> list of isos
        
        modelfile = open(modelfilename).readlines()
        for line in modelfile:
            model_line = line.strip().split('\t')
            if model_line[0]=="Country":
                self.c_iso_country[model_line[1]] = model_line[2].split()
            elif model_line[0]=="Language_name":
                self.c_iso_lang[model_line[1]] = model_line[2].split()
            elif model_line[0]=="Region":
                self.c_iso_region[model_line[1]] = model_line[2].split()
   
if __name__=="__main__":
    if len(sys.argv)!=4:
        print "Usage: ./iso_extract_modeler.py Ethnologue-classifier-training-data.xml model_format model_output"
        print "Model format: 0 for text, 1 for pickle."
        sys.exit(1)
    ilm = isoLangModel()
    ilm.train(sys.argv[1])
#    ilm.calc_probs()
    if sys.argv[2]=="0":
        ilm.print_model(open(sys.argv[3],'w'))
    else:
        pickle.dump(ilm,open(sys.argv[3],'wb'))
