# Conversion script for MARC record set -> OLAC repository
# Chris Hirt
# 2008-07-31
# requires Python version 2.4

from string import Template
import ConfigParser
import re

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

# compile regex for removing 'from_marc_field' tags
regex = re.compile(r'\s*from_marc_field="[^"]*"\s*')

# print OAI header (using variables from both oai and olac cfg)
# TODO: handle exceptions for template variable substitution
oaiheader = Template(utils.file2string(config.get('oai','header_file')))
oaivars = utils.cfglist2dict(config.items('oai'))
oaivars.update(utils.cfglist2dict(config.items('olac')))
print oaiheader.substitute(oaivars)

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
    # NOTE: we could instead get the 001 from the marc record directly, instead of the XML output
    oai_id = ''
    n = result.children.children.children
    while n is not None:
        if n.name == 'identifier' and n.prop('from_marc_field') == '001':
            oai_id = n.content
        n = n.next

    # print record header (with oai ID and datestamp)
    #TODO: how do we determine datestamp ???
    print recheader.substitute(identifier=oai_id,datestamp='')

    # get olac node as text
    olacNode = result.children.children.serialize(None,1)

    # TODO: perform second transformation here???
    # second transformation will be decision logic for which fields to keep based upon from_marc_field attribute

    # remove from_marc_field="" from node text
    #olacNode = regex.sub('',olacNode)

    print olacNode

    # print record footer
    print recfooter.template

    print '\n'
    count += 1
    #if count == 1:
    #    break


# print OAI postamble
print utils.file2string(config.get('oai','footer_file'))
