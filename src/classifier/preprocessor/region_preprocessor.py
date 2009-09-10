# encoding=utf-8
'''region_preprocessor.py

Takes as input a tab-delimited file with ISO 639-3 codes in one column and
prose with information on what regions the language is spoken in another
column.  Parses the prose and outputs the data in the normalized format
specified in wiki:iso639_trainerDatafileFormat.

@author: Joshua S Hou

Created Sept 8, 2009

Usage: python region_preprocessor.py [options] inputfile
'''
import sys
import optparse
import re
import codecs

class RegionParser:
    '''Parses a string and returns a list of geographical regions found in the
    text.'''
    def __init__(self):
        '''Initializes some data variables that the parser needs.'''
        self.region_NE = re.compile(r'(((St\.? )|(Mt\.? ))*([A-Z][^\s,\.\\;:\'\"\(\)]*)(( of| de)? [A-Z][^\s,\.\\;:\'\"\(\)]*)*)')
        self.stoplist = set(['North','South','East','West','Northeast','Northwest','Southeast',\
            'Southwest','Central','Mt','St','The','Far','Both','Along',\
            'Border','Island','Islands','Upper','Lowlands','Several','Center',\
            'Ethnic','At','Middle','Northern','Southern','Eastern','Western',\
            'Northeastern','Northwestern','Southeastern','Southwestern','Over',\
            'Just','Refugees','Villages','L1','No','On','L2','All','Centered',\
            'Inland','Towns','River','Between','Overlaps','Small','Lakes',\
            'Used', 'Song Mao. Possibly','Dialect','Tone','Ritual','Another',\
            'Noun','Hunter'])
        self.abbreviations = {'St.':'Saint', 'St':'Saint', 'Mt.':'Mount', 'Mt':'Mount'}
        self.abb_re = re.compile(r'St\.?|Mt\.?')
        self.dirof = re.compile(r'((North)|(South)|(East)|(West)|(Northeast)|(Northwest)|(Southeast)|(Southwest)|([NSEW][NSEW]?)) of ')
        self.dir = re.compile(r'((North)|(South)|(East)|(West)|(Northeast)|(Northwest)|(Southeast)|(Southwest)|([NSEW][NSEW]?)) ')
        self.geog = re.compile(r'((Place)|(River)|(Hills?)|(Prefecture)|(City)|(Lake)|(Province)|(Islands?)|(Lowlands)|(Towns?)|(District)|(Middle)|(Regency)|(Valley)|(Harbor)|(Township)|(County)|(Lagoon)|(Station)|(Territory)|(Division)|(Department)|(Municipio))$')

    def parse(self, input):
        '''Parses string input and returns a list of regions.'''
        region_list = []
        for region in filter(lambda x: x not in self.stoplist and len(x)>3,[i[0].strip(' "()') for i in self.region_NE.findall(input)]):
            region_list += self.region_parse(region)
        return region_list

    def region_parse(self, NE):
        '''Processes a region named entity and returns a list of alternate spellings.'''
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
        return [i for i in NE_list if len(i)>=3]

def main():
    parser = optparse.OptionParser(usage='python region_preprocessor.py [options] inputfile')
    parser.add_option('-o', '--output', dest='output', help='appends region data to this file')
    (options,args) = parser.parse_args()

    if options.output:
        output = codecs.open(options.output,'a', encoding='utf-8')
    else:
        output = sys.stdout
    if len(args)!=1:
        parser.print_help()
        sys.exit(1)

    rp = RegionParser()
    for line in codecs.open(args[0],encoding='utf-8').readlines():
        line = line.strip(u'﻿\n\r\t ')
        if line[0]=='#':
            continue
        iso, rg_data = line.split('\t')
        for region in rp.parse(rg_data):
            output.write(iso+'\trg\t'+region+'\n')

if __name__=="__main__":
    main()
