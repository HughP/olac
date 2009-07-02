#!/usr/bin/python
# get_country_names.py
# Joshua S Hou
# June 2009
#
# This script takes as input an XML format Ethnologue database dump of languages
# and its associated ISO code, primary and alternate names, and prints out a list
# of every country name mentioned.
#
# Usage: python get_field_names.py Ethnologue-classifier-training-data.xml field_name_output_file field_name
import xml.parsers.expat
import sys
import re

class XMLParse:
    def __init__(self, xml_file, output, field_name):
        assert(xml_file != "")
        self.xml_file = xml_file
        self.output = open(output,'w')
        self.path = []
        self.Parser = xml.parsers.expat.ParserCreate()

        self.Parser.CharacterDataHandler = self.handleCharData
        self.Parser.StartElementHandler = self.handleStartElement
        self.Parser.EndElementHandler = self.handleEndElement
        
        self.field_name = field_name
        self.flist = ''
        self.field_names = set()
        self.spaces = re.compile(r'\s+')

    def parse(self):
            self.Parser.ParseFile(open(self.xml_file))

    def handleCharData(self, data):
        if self.path[-1]==self.field_name:
            self.flist += data.encode('utf-8').strip('\n')

    def handleStartElement(self, name, attrs):
        self.path.append(name)

    def handleEndElement(self, name):
        if name==self.field_name:
            self.field_names.add(self.spaces.sub(' ',self.flist))
            self.flist = ''
        self.path.pop()
    
    def print_field_names(self):
        for field in self.field_names:
            if field:
                print>>self.output, field

if __name__=="__main__":
    if len(sys.argv)!=4:
        print "Usage: python get_field_names.py Ethnologue-classifier-training-data.xml field_name_output_file field_name"
        sys.exit(1)
    xp = XMLParse(sys.argv[1], sys.argv[2], sys.argv[3])
    xp.parse()
    xp.print_field_names()
