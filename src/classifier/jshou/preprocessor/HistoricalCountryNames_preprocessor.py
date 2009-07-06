'''Extracts data from Historical Country Names website and prints to file.

Created on Jul 6, 2009

@author: Joshua S Hou

Processes Historical Country Names site, identifies each historical country
name, and accesses each modern country name page to retrieve the ISO 3166
country code associated with each historical country name.  The data is then
printed to file using the format described in wiki:iso639_trainerDatafileFormat.

Historical Country Names data retrieved on July 6, 2009, from:
http://www.nationsonline.org/oneworld/hist_country_names.htm

This script has to access the web version directly, because the ISO 3166 codes
do not reside on the main page that has the list of Historical Country Names.
Instead, the list includes the modern day names, which are hyperlinks to
to separate pages on those countries.  Those pages contain the actual ISO 3166
codes, which can then be extracted.  Perhaps we can save all the pages, but then
we might as well construct the list of historical country names and associated
ISO 3166 codes manually.

HistoricalCountryNamesData -- manages the extraction of historical country names
                              and associated ISO 3166 country codes from a
                              given webpage.

Usage: python HistoricalCountryNames_preprocessor.py HistCountNames_url >output
'''

import sys
import re
import urllib

class HistoricalCountryNamesData:
    '''
    extract_iso3166(url) -- Accesses url and extracts the ISO 3166 country code from
                            the page.
    extract_hist_names(url) -- Accesses url and extracts historical country names
                               and calls extract_iso3166 to get the ISO 3166 codes
                               for each historical country name
    '''
    def __init__(self, url):
        self.hist_page = url
        self.histname_and_page = re.compile('(?<=class=\"land\">)' + 
                                                '(<a name=.*?>)?(.*?)(</a>)?' +
                                                '</span>'+
                                                '.*?<td\s+class=\"border1\">'+
                                                '(.*?)</td>', re.DOTALL)
        self.hyperlink = re.compile(r'(?<=<a href=\")(.*?\.htm)', re.DOTALL)
        self.iso_country_code = re.compile(r'<a href="countrycodes.htm">ISO Country Code</a>: <b>(.*?)</b>')
        
        self.hist_names = {} # historical_country_name -> [list of iso 3166 codes]
    
    def extract_iso3166(self, url):
        '''Accesses url and extracts the ISO 3166 country code from the page.'''
        site = urllib.urlopen(url).read()
        isolist = self.iso_country_code.findall(site)
        if isolist:
            return isolist[0]
        else:
            return ''
    
    def extract_hist_names(self):
        '''Accesses url and extracts historical country names and calls
        extract_iso3166 to get the ISO 3166 codes for each historical country name.
        '''
        site = urllib.urlopen(self.hist_page).read()
        #site = open('hist_country_names.htm').read()
        webroot, page = self.hist_page.rsplit('/',1)
        for i in self.histname_and_page.findall(site):
            hist_name = i[1]
            links = [webroot+"/"+page for page in self.hyperlink.findall(i[3])]
            print>>sys.stderr, hist_name, [self.extract_iso3166(j) for j in links]
            self.hist_names[hist_name] = filter(lambda x: x,[self.extract_iso3166(j) for j in links])
            
    def print_hist_names(self, outstream):
        '''Prints historical name data to outstream using standardized format.'''
        for hist_name in self.hist_names:
            for iso3166 in self.hist_names[hist_name]:
                print>>outstream, iso3166 + '\tcn' + hist_name

if __name__=="__main__":
    if len(sys.argv)!=2:
        print "Usage: python HistoricalCountryNames_preprocessor.py HistCountNames_data >output"
        sys.exit(1)
    
    hcnd = HistoricalCountryNamesData(sys.argv[1])
    hcnd.extract_hist_names()
    hcnd.print_hist_names(sys.stdout)