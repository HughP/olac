# Conversion script for MARC record set -> OLAC repository
# Chris Hirt
# 2008-07-31

from pymarc import MARCReader
from pymarc import record_to_xml
from libxml2 import parseFile, parseDoc
from libxslt import parseStylesheetDoc

# note: we should put the following in a configuration file
###########################################################
# marc file
marcfile = open('c:\olac\gial.marc')

# marcxml pre and post amble files (read into strings)
f = open('marcxmlpreamble')
marc_xml_preamble = f.readlines()
marc_xml_preamble = ''.join(marc_xml_preamble)
f.close()
f = open('marcxmlpostamble')
marc_xml_postamble = f.readlines()
marc_xml_postamble = ''.join(marc_xml_postamble)
f.close()

# stylesheet
style = parseStylesheetDoc(parseFile('MARC21slim2OAIDC.xsl'))

# OAI static repository preamble
f = open('oaipreamble')
oai_sr_preamble = f.readlines()
oai_sr_preamble = ''.join(oai_sr_preamble)
f.close()

# OAI static repository postamble
f = open('oaipostamble')
oai_sr_postamble = f.readlines()
oai_sr_postamble = ''.join(oai_sr_postamble)
f.close()

########################################################



marcset = MARCReader(marcfile)
count = 0

# print OAI preamble
print oai_sr_preamble

# loop over each marc record in the set

for record in marcset:

    # construct a proper marcxml document
    xmlrec = record_to_xml(record) 
    xmlrec = marc_xml_preamble + xmlrec + marc_xml_postamble
    xmlrec = parseDoc(xmlrec)

    # apply xsl stylesheet to marcxml document
    result = style.applyStylesheet(xmlrec,None)

    # print out transformation result
    print result.serialize()

    print '\n'
    count += 1
    if count == 2:
        break


# print OAI postamble
print oai_sr_postamble
