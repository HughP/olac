#!/usr/bin/python
# get_alt_names.py
# Joshua S Hou
# June 2009
#
# This script takes as input an XML format Ethnologue database dump of languages
# and its associated ISO code, primary and alternate names, and prints out the list
# of alternate names for each ISO code in the following format:
#
# iso1: alt1, alt2, alt3, alt4
# iso2: alt5, alt6
# iso3: alt7, alt8, alt9
# iso4: alt10
# iso5: alt11, alt12
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

    def parse(self):
#       try:
            self.Parser.ParseFile(open(self.xml_file))
#       except:
#           print "File", self.xml_file, "could not be opened."
#           sys.exit(1)

    def handleCharData(self, data):
        if self.path[-1]=="ISO_code":
            self.output.write(data.encode('utf-8')+": ")
        elif self.path[-1]=="alternate_names":
            self.output.write(data.encode('utf-8'))

    def handleStartElement(self, name, attrs):
        self.path.append(name)

    def handleEndElement(self, name):
        if name=="alternate_names":
            self.output.write('\n')
        self.path.pop() # presumably, the XML is well-formed and an end element is obligatorily the closets preceding unclosed begin tag.

if __name__=="__main__":
    if len(sys.argv)!=3:
        print "Usage: python get_alt_names.py Ethnologue-classifier-training-data.xml alternate_names"
        sys.exit(1)
    xp = XMLParse(sys.argv[1], sys.argv[2])
    xp.parse()
