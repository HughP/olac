# based on
# http://www.ibm.com/developerworks/xml/library/x-tipsaxflex.html
# modified by: Chris Hirt
# 2011-05-04
# This version is for splitting an OAI List records response into chunks

import xml.sax
import os
import sys
from xml.sax.saxutils import XMLFilterBase, XMLGenerator

#Define constants

class XMLSplit(XMLFilterBase):
    def __init__(self, upstream, downstream, filename,chunksize = 100):
        XMLFilterBase.__init__(self, upstream)
        self.handlers = []
        self.pushHandler(downstream)
        self.filename = filename
        self.chunksize = int(chunksize)
        self.rec_count = 0
        self.chunknames = []
        self.tempdir = ''
        self.verbose = False

    def pushHandler(self, handler):
        self.handlers.append(self.getContentHandler())
        self.setContentHandler(handler)
        self.downstream = handler

    def popHandler(self):
        handler = self.handlers.pop()
        self.setContentHandler(handler)
        self.downstream = handler

    def startElement(self, name, attrs):
        if name == "record" and self.rec_count % self.chunksize == 0:
            # new chunk
            chunkname = "%ssaxsplit_%05d.xml" % (self.tempdir + os.sep, (self.rec_count / self.chunksize) + 1)
            self.chunknames.append(chunkname)
            if self.verbose:
                sys.stdout.write('.')
            self.pushHandler(XMLGenerator(open(chunkname, "w"), 'utf-8'))
            self.startDocument()
            self.downstream.startElement("OAI-PMH",
{
    'xmlns':'http://www.openarchives.org/OAI/2.0/',
    'xmlns:xsi':'http://www.w3.org/2001/XMLSchema-instance',
    'xmlns:schemaLocation':'http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd',
    'xmlns:olac':'http://www.language-archives.org/OLAC/1.1/',
    'xmlns:dc':'http://purl.org/dc/elements/1.1/',
    'xmlns:dcterms':'http://purl.org/dc/terms/'
})
            self.downstream.startElement("ListRecords", {})
            self.downstream.characters(u"\n\t") # Indentation (optional)
        if name != "OAI-PMH": # skip opening OAI-PMH
            self.downstream.startElement(name,attrs)
        if name == "record":
            self.rec_count += 1

    def endElement(self, name):
        if name == "OAI-PMH":
            # All records seen
            self.downstream.endElement("OAI-PMH")
            self.downstream.characters(u"\n") # Indentation (optional)
            self.downstream.endDocument()
            self.popHandler()
            if self.verbose:
                sys.stdout.write('\n')
        elif name == "record" and self.rec_count % self.chunksize == 0:
            # End of chunk
            self.downstream.characters(u"\n") # Indentation (optional)
            self.downstream.endElement("record")
            self.downstream.endElement("ListRecords")
            self.downstream.endElement("OAI-PMH")
            self.downstream.characters(u"\n") # Indentation (optional)
            self.downstream.endDocument()
            self.popHandler() 
        else:
            self.downstream.endElement(name)

    def getChunkNames(self):
        # returns a list of names
        return self.chunknames

    def setTempDir(self,dir):
        # chomp trailing slash
        dir = dir.rstrip(os.sep)
        self.tempdir = dir

    def setVerbose(self,flag):
        self.verbose = flag

        
if __name__ == "__main__":
    # chunk size from command line optional
    if len(sys.argv) > 2:
        chunksize = sys.argv[2]
    else:
        chunksize = 1000 # default
    print "chunksize is ",chunksize
    parser = xml.sax.make_parser()
    generator = xml.sax.handler.ContentHandler() # null sink
    splitter = XMLSplit(parser, generator, sys.argv[1],chunksize)
    splitter.parse(sys.argv[1])

