'''Reads data from Ethnologue data dump, normalizes and prints to file.

Created on Jul 2, 2009

@author: Joshua S Hou

Processes an XML Ethnologue dump and outputs the information to a normalized
format as defined in wiki:iso639_trainerDatafileFormat.  Outputs both country
codes and language codes.

EthnologueXMLParser -- Parses XML and prints language and country data to stdout

Usage: python Ethnologue_data_preprocessor.py Ethnologue-classifier-training-data.xml >output
'''

import sys
import re
import xml.parsers.expat

class EthnologueXMLParser:
    '''Wrapper for expat XML parser that parses XML Ethnologue training data
    
    Uses Python's expat XML parser to extract the XML fields we are interested
    in and prints the data in the format described in wiki:iso639_trainerDataFileFormat.
    
    Fields we extract:
        ISO_code
        print_name
        alternate_names
        country-info:
            country_name
            country_code
            region
    
    path -- stack that keeps track of where in the XML document we are
    handleStartElement(name, attrs) -- pushes name onto the stack
    handleCharData(data) -- appends data to temp[last element in path].  This is because there are sometimes >1 adjacent CharData fields detected in the parser.
    handleEndElement(name) -- stores the info in temp[name] in country_idx and/or lang_info where appropriate, clears temp[name] and then pops the path stack.
    
    country_idx -- dictionary from country name to two letter country code
    lang_info -- dictionary that stores the different information about each language
    parse() -- parses Ethnologue XML file and stores the data in country_idx and lang_info
    print_data(outstream) -- prints the information stored in country_idx and lang_info in normalized form to a given printstream  
    '''
    def __init__(self, xml_file):
        assert(xml_file != "")
        self.xml_file = xml_file
        self.path = [] # keeps track of where in the XML document tree we are
        self.Parser = xml.parsers.expat.ParserCreate()

        self.Parser.CharacterDataHandler = self.handleCharData
        self.Parser.StartElementHandler = self.handleStartElement
        self.Parser.EndElementHandler = self.handleEndElement
        
        self.spaces = re.compile(r'\s+')
        #self.region_NE = re.compile(r'(([A-Z]\w*\s?)+)')
        self.region_NE = re.compile(r'(((St\.? )|(Mt\.? ))*([A-Z][^\s,\.\\;:\'\"\(\)]*)(( of| de)? [A-Z][^\s,\.\\;:\'\"\(\)]*)*)')
        self.dialect_split = re.compile(r'\)?, | \(|\).')
        
        self.country_idx = {} # country_name -> country_code
        self.lang_info = {} # iso639 code -> { "sn":"print_name",
                            #                  "wn":["alternate_name1","alternate_name2"]
                            #                  "cc":["country_code1", "country_code2"]
                            #                  "rg":"["region1","region2","region3"]
        
        self.curr_print_name = ''
        self.curr_iso = ''
        self.curr_country_name = ''
        self.curr_country_code = ''
        self.temp = {"print_name":'', # temporarily stores the current values of the fields that we're tracking in the XML file
                     "ISO_code":'',
                     "alternate_names":'',
                     "country_name":'',
                     "country_code":'',
                     "region":'',
                     "dialects":''
                     }

        self.stoplist = set(['North','South','East','West','Northeast','Northwest','Southeast',\
            'Southwest','Central','Mt','St','The','Far','Both','Along',\
            'Border','Island','Islands','Upper','Lowlands','Several','Center',\
            'Ethnic','At','Middle','Northern','Southern','Eastern','Western',\
            'Northeastern','Northwestern','Southeastern','Southwestern','Over',\
            'Just','Refugees','Villages','L1','No','On','L2','All','Centered',\
            'Inland','Towns','River','Between','Overlaps','Small','Lakes',\
            'Used', 'Song Mao. Possibly'])
        self.abbreviations = {'St.':'Saint', 'St':'Saint', 'Mt.':'Mount', 'Mt':'Mount'}
        self.abb_re = re.compile(r'St\.?|Mt\.?')
        self.dirof = re.compile(r'((North)|(South)|(East)|(West)|(Northeast)|(Northwest)|(Southeast)|(Southwest)|([NSEW][NSEW]?)) of ')
        self.dir = re.compile(r'((North)|(South)|(East)|(West)|(Northeast)|(Northwest)|(Southeast)|(Southwest)|([NSEW][NSEW]?)) ')
        self.geog = re.compile(r'((Place)|(River)|(Hills?)|(Prefecture)|(City)|(Lake)|(Province)|(Islands?)|(Lowlands)|(Towns?)|(District)|(Middle)|(Regency)|(Valley)|(Harbor)|(Township)|(County)|(Lagoon)|(Station)|(Territory)|(Division)|(Department)|(Municipio))$')

    def parse(self):
            self.Parser.ParseFile(open(self.xml_file))

    def handleCharData(self, data):
        if self.path[-1] in self.temp:
            self.temp[self.path[-1]] += data.encode('utf-8')

    def handleStartElement(self, name, attrs):
        self.path.append(name)

    def handleEndElement(self, name):
        if name in self.temp:
            self.temp[name] = self.spaces.sub(' ',self.temp[name]).strip(' "')
        if name=="print_name":
            # inverting print_name if needed
            if ',' in self.temp[name]:
                split_name = self.temp[name].split(',')
                self.curr_print_name = split_name[1].strip() + " " + split_name[0].strip()
            else:
                self.curr_print_name = self.temp[name]
        elif name=="ISO_code":
            self.curr_iso = self.temp[name]
            # This is the first time that self.lang_info encounters this iso code so we have to initialize the dictionary here.
            self.lang_info[self.curr_iso] = {"sn":self.curr_print_name, "cc":[], "rg":[]}
        elif name=="alternate_names":
            self.lang_info[self.curr_iso]["wn"] = filter(lambda x: x,[i.strip(' "') for i in self.temp[name].split(', ')])
        elif name=="dialects":
            dialects = filter(lambda x: x,[i.strip(' ".') for i in self.dialect_split.split(self.temp[name])])
            if "wn" in self.lang_info[self.curr_iso]:
                dialects += self.lang_info[self.curr_iso]["wn"]
            self.lang_info[self.curr_iso]["wn"] = dialects
        elif name=="country_name":
            self.curr_country_name = self.temp[name]
        elif name=="country_code":
            self.country_idx[self.curr_country_name] = self.temp[name]
            self.lang_info[self.curr_iso]["cc"].append(self.temp[name])
        elif name=="region":
            region_list = []
            for region in filter(lambda x: x not in self.stoplist and len(x)>3,[i[0].strip(' "()') for i in self.region_NE.findall(self.temp[name])]):
                region_list += self.region_parse(region)
            self.lang_info[self.curr_iso]['rg'] += region_list
#           self.lang_info[self.curr_iso]["rg"] += filter(lambda x: x not in self.stoplist and len(x)>3,[i[0].strip(' "()') for i in self.region_NE.findall(self.temp[name])])
        self.temp[name] = ''
        self.path.pop()
    
    def print_data(self, outstream):
        '''Prints data that has been processed out in normalized form.'''
        print>>outstream, "# Ethnologue data"
        for iso in self.lang_info:
            for field in self.lang_info[iso]:
                if isinstance(self.lang_info[iso][field],list):
                    for item in self.lang_info[iso][field]:
                        print>>outstream, iso + "\t" + field + '\t' + item
                else:
                    print>>outstream, iso + "\t" + field + '\t' + self.lang_info[iso][field]
        for country_name in self.country_idx:
            print>>outstream, self.country_idx[country_name] + "\tcn" + '\t' + country_name

    def region_parse(self, NE):
        if NE.startswith('Near '):
            NE = NE.replace('Near ','').strip()
        if self.dirof.match(NE):
            NE = self.dirof.sub('',NE)
        NE_list = [NE]
        abb_rematch = self.abb_re.match(NE)
        if abb_rematch:
            NE_list += self.region_parse(self.abb_re.sub(self.abbreviations[abb_rematch.string[abb_rematch.start():abb_rematch.end()]],NE))
        if self.dir.match(NE):
            new_NE = self.dir.sub('',NE).strip()
            if new_NE not in self.stoplist:
                NE_list.append(new_NE)
        if self.geog.search(NE):
            new_NE = self.geog.sub('',NE).strip()
            if new_NE not in self.stoplist:
                NE_list.append(new_NE)
        return NE_list

if __name__=="__main__":
    if len(sys.argv)!=2:
        print "Usage: python Ethnologue_data_preprocessor.py Ethnologue-classifier-training-data.xml >output"
        sys.exit(1)
    exp = EthnologueXMLParser(sys.argv[1])
    exp.parse()
    exp.print_data(sys.stdout)
