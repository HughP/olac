#!/usr/bin/python
# get_lang_names.py
# Joshua S Hou
# June 2009
#
# This script takes as input an XML format Ethnologue database dump of languages
# and its associated ISO code, primary and alternate names, and prints out a list
# of every language name mentioned, primary or alternate.
import xml.parsers.expat
import sys

class XMLParse:
    def __init__(self, xml_file, output):
        assert(xml_file != "")
        self.xml_file = xml_file
        self.output = open(output,'w')
        self.path = []
        self.Parser = xml.parsers.expat.ParserCreate()

        self.Parser.CharacterDataHandler = self.handleCharData
        self.Parser.StartElementHandler = self.handleStartElement
        self.Parser.EndElementHandler = self.handleEndElement
        
        self.primlist = ''
        self.altlist = ''
        self.lang_names = set()

    def parse(self):
            self.Parser.ParseFile(open(self.xml_file))

    def handleCharData(self, data):
        if self.path[-1]=="print_name":
            self.primlist += data.encode('utf-8')
        elif self.path[-1]=="alternate_names":
            self.altlist += data.encode('utf-8')

    def handleStartElement(self, name, attrs):
        self.path.append(name)

    def handleEndElement(self, name):
        if name=="alternate_names":
#            self.lang_names.add(self.altlist.encode('utf-8'))
            for alt in self.altlist.split(", "):
                self.lang_names.add(alt.strip('" '))
            self.altlist = ''
        elif name=="print_name":
            self.lang_names.add(self.primlist.strip('" '))
            self.primlist = ''
        self.path.pop()
    
    def print_lang_names(self):
        for lang_name in self.lang_names:
            if lang_name:
                print>>self.output, lang_name

if __name__=="__main__":
    if len(sys.argv)!=3:
        print "Usage: python get_lang_names.py Ethnologue-classifier-training-data.xml lang_names"
        sys.exit(1)
    xp = XMLParse(sys.argv[1], sys.argv[2])
    xp.parse()
    xp.print_lang_names()
