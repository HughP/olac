#!/usr/bin/python
# Throwaway script that goes through the LinguistList list of ancient and
# extinct languages, grabs each language URL and gets the country name of where
# it used to be spoken.  Totally rips off the other LinguistList preprocessor's
# regular expressions, but is not combined with the other preprocessor because I
# expect to run the other preprocessor fairly oftenish, but NOT this, because it
# scrapes the web and will take forever to access more than 200 links.
# 
# Usage: python ancient_countries.py LinguistList_file > print output
import sys
import re
import urllib
import codecs

if len(sys.argv)!=2:
    sys.exit("Usage: python ancient_countries.py LinguistList_file")

iso_name_regex = re.compile(r'(?<=cfm\?code=)([a-z]{3})\s*\">(([^\s]+\s)*[^\s]+)(?=\s*</[Aa])', re.U)
country_name = re.compile(r'''Once\s+Spoken\s+in\s+</strong>\s+:\s+</span>\s+</td>\s+<td width="300">\s+<span class="p-match">\s+(.*?)(\s+&nbsp;)?\s+</span>''')
iso_names = iso_name_regex.findall(codecs.open(sys.argv[1], 'r','utf-8').read())
country_codes = {}
for line in codecs.open('CountryCodes.tab', 'r','latin-1').readlines()[1:]:
    code, country, area = line.strip().split('\t')
    country_codes[unicode(country)] = code

print '# Ancient and extinct languages and the countries they were spoken in, from Linguist List'
for iso_name in iso_names:
    iso, name = iso_name[0], iso_name[1]
    url = 'http://linguistlist.org/forms/langs/LLDescription.cfm?code=' + iso
    site = urllib.urlopen(url).read()
    country = country_name.search(site)
#   print>>sys.stderr, country.group(1).decode('utf-8'), type(country.group(1).decode('utf-8'))
    if country.group(1)=="USA":
        country_code = "US"
    elif country.group(1)=="Russia":
        country_code = "RU"
    else:
        country_code = country_codes[country.group(1).decode('utf-8')]
    print '\t'.join([iso, 'cc', country_code])
