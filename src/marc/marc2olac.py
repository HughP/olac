# Conversion script for MARC record set -> OLAC repository
# Chris Hirt
# 2008-07-31

from pymarc import MARCReader
from pymarc import record_to_xml
from libxml2 import parseFile, parseDoc
from libxslt import parseStylesheetDoc

def file2string(fileName):
    """file2 string reads the contents of a file into a string
    param: fileName
    returns: string (contents of file)"""
    file = open(fileName)
    str = file.readlines()
    return ''.join(str)

# note: we should put the following in a configuration file
###########################################################
# marc file
marcfile = open('c:\olac\gial.marc')
marc_xml_preamble = file2string('marcxmlpreamble')
marc_xml_postamble = file2string('marcxmlpostamble')
oai_sr_preamble = file2string('oaipreamble')
oai_sr_postamble = file2string('oaipostamble')

# stylesheet
style = parseStylesheetDoc(parseFile('MARC21slim2OLACcommented.xsl'))
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
