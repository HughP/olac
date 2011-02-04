# A simple OAI-PMH harvester class.

import sys
import os
import urllib
import re

__all__ = ["Harvester"]

class Writer:
    def __init__(self, fobj):
        self.output = fobj
        self.write = self._write1
        self.recpat = re.compile(r"<\s*record.*?>.*?<\s*/\s*record\s*>", re.S)
        self.tokpat = r'<\s*resumptionToken.*?>(.*?)<\s*/\s*resumptionToken\s*>'
        self.tokpat = re.compile(self.tokpat, re.S)
        
    def _write1(self, xml_data):
        pat = r"(.*<\s*ListRecords.*?>\s*).*(<\s*/\s*ListRecords\s*>.*)"
        pat = re.compile(pat, re.S)
        m = re.match(pat, xml_data)
        self.output.write(m.group(1))
        self.footer = m.group(2)
        self.write = self._write2
        return self.write(xml_data)
                     
    def _write2(self, xml_data):
        count = 0
        for s in self.recpat.findall(xml_data):
            self.output.write(s + "\n")
            count += 1
        m = self.tokpat.search(xml_data)
        if m:
            return count, m.group(1)
        else:
            return count, None
        
    def close(self):
        self.output.write(self.footer)
        

class Harvester:
    def __init__(self,
                 output_fobj,
                 baseurl,
                 metadata_prefix,
                 callback_about_to_download = None,
                 callback_downloaded = None
                 ):
        self.out = Writer(output_fobj)
        self.baseurl = baseurl
        self.metadata_prefix = metadata_prefix
        self.cb_before_dl = callback_about_to_download
        self.cb_after_dl = callback_downloaded

    def harvest(self, a_set=None):
        url = "%s?verb=ListRecords&metadataPrefix=%s" % \
              (self.baseurl, self.metadata_prefix)
        if a_set:
            url += '&set=' + a_set
            
        while url:
            if self.cb_before_dl:
                self.cb_before_dl(url)
                
            fobj = urllib.urlopen(url)
            data = fobj.read()
            record_count, resumption_token = self.out.write(data)
            
            if self.cb_after_dl:
                self.cb_after_dl(record_count, len(data))
            
            if resumption_token:
                url = "%s?verb=ListRecords&resumptionToken=%s" % \
                      (self.baseurl, resumption_token)
            else:
                url = None

    def close(self):
        self.out.close()

if __name__ == "__main__":
    if len(sys.argv) != 4:
        prog = os.path.basename(sys.argv[0])
        print "Usage: %s <url> <metadata prefix> <output file>" % prog
        print
        sys.exit(1)
    
    url = sys.argv[1]
    metadata_prefix = sys.argv[2]
    filename = sys.argv[3]
    try:
        out = open(filename, "w")
    except IOError, e:
        print "failed to open the file:", filename
        print "error no:", e.args[0]
        print "error message:", e.args[1]
        sys.exit(1)
    
    h = Harvester(out, url, metadata_prefix)
    h.harvest()
    h.close()
    
    