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
import re

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
        self.curr_iso = ''
        self.spaces = re.compile(r'\s+')

    def parse(self):
            self.Parser.ParseFile(open(self.xml_file))

    def handleCharData(self, data):
        if self.path[-1]=="print_name":
            self.primlist += data.encode('utf-8')
        elif self.path[-1]=="alternate_names":
            self.altlist += data.encode('utf-8')
        elif self.path[-1]=="ISO_code":
            self.curr_iso = data.strip()

    def handleStartElement(self, name, attrs):
        self.path.append(name)

    def handleEndElement(self, name):
        if name=="alternate_names":
            self.altlist = self.spaces.sub(' ', self.altlist)
            for alt in self.altlist.split(", "):
                if alt:
                    self.lang_names.add(alt.strip('" '))
                    # the next two lines are looking for little letters at the beginning of a name
                    if alt[0].islower():
                        print self.curr_iso+":", alt
            self.altlist = ''
        elif name=="print_name":
            print_name = self.spaces.sub(' ',self.primlist).strip('" ')
            if "," in print_name:
                splitname = print_name.split(',')
                inverted_name = (splitname[1]+" "+splitname[0]).strip()
                self.lang_names.add(inverted_name)
                if inverted_name[0].islower():
                    print self.curr_iso+", primary uninverted:", print_name, inverted_name
            else:
                if print_name[0].islower():
                    print self.curr_iso+", primary untouched:", print_name
                self.lang_names.add(print_name)
            
            self.primlist = ''
        self.path.pop()
    
    def print_lang_names(self):
        for lang_name in self.lang_names:
            print>>self.output, lang_name

if __name__=="__main__":
    if len(sys.argv)!=3:
        print "Usage: python get_lang_names.py Ethnologue-classifier-training-data.xml lang_names"
        sys.exit(1)
    xp = XMLParse(sys.argv[1], sys.argv[2])
    xp.parse()
    xp.print_lang_names()
