# Conversion script for MARC record set -> OLAC repository
# Chris Hirt
# 2008-07-31
# requires Python version 2.4

from string import Template
import ConfigParser

# local function library
import utils

# modules you may need to install
from pymarc import MARCReader
from pymarc import record_to_xml
from libxml2 import parseFile, parseDoc
from libxslt import parseStylesheetDoc

# initialize the config file
config = ConfigParser.ConfigParser()
config.read("marc2olac.cfg")

# read variables from config file
marcfile = open(config.get('marc','source_file'))
recheader = Template(utils.file2string(config.get('olac_record','header_file')))
recfooter = Template(utils.file2string(config.get('olac_record','footer_file')))
style = parseStylesheetDoc(parseFile(config.get('marc','stylesheet_file')))

# print OAI header
print utils.file2string(config.get('oai','header_file'))

# loop over each marc record in the set
marcset = MARCReader(marcfile)
count = 0
for record in marcset:

    # construct a proper marcxml document
    xmlrec = record_to_xml(record) 
    xmlrec = utils.file2string(config.get('marc','xml_header_file')) + \
        xmlrec + utils.file2string(config.get('marc','xml_footer_file'))
    xmlrec = parseDoc(xmlrec)

    # apply xsl stylesheet to marcxml document
    result = style.applyStylesheet(xmlrec,None)

    # find dc:identifier from 001 in xml doc
    oai_id = ''
    n = result.children.children.children
    while n is not None:
        if n.name == 'identifier' and n.prop('from_marc_field') == '001':
            oai_id = n.content
        n = n.next

    # print record header (with oai ID and datestamp)
    vars = dict(identifier=oai_id,datestamp='')
    print recheader.substitute

    #print olac_node
    print result.serialize(None,1)

    # print record footer
    print recfooter.template

    print '\n'
    count += 1
    if count == 10:
        break


# print OAI postamble
print utils.file2string(config.get('oai','footer_file'))
