# Conversion script for MARC record set -> OLAC repository
# Chris Hirt
# 2008-07-31
# requires Python version 2.4

from string import Template
import ConfigParser
import re
import sys
import os

# local function library
import utils

# modules you may need to install
from pymarc import MARCReader
from pymarc import record_to_xml
from libxml2 import parseFile

# get marc source file from command line
try:
    input = sys.argv.pop(1)
    marcfile = open(input)
except:
    print "please specify a valid marc input file"
    sys.exit(2)

# initialize the config file
config = ConfigParser.ConfigParser()
config.read("marc2olac.cfg")

# read variables from config file
olacrecheader = Template(utils.file2string(config.get('system','olacrec_header_file')))
olacrecfooter = utils.file2string(config.get('system','olacrec_footer_file'))
marcxmlheader = utils.file2string(config.get('system','marcxml_header_file'))
marcxmlfooter = utils.file2string(config.get('system','marcxml_footer_file'))
uservars = utils.cfglist2dict(config.items('user'))
outputprefix = config.get('system','output_prefix')

# open output files (some are optional)
output_marcxml_flag = config.get('system','create_marcxml_output')
#output_html_flag = config.get('system','create_html_output')
if (not 'output' in os.listdir('.')):
    os.mkdir('output')
olac_xml_f = open('output/' + outputprefix + 'repository.xml','w')
if (output_marcxml_flag == 1):
    marc_xml_f = open('output/' + outputprefix + 'marc.xml','w')
    marc_xml_f.write(marcxmlheader)

# temporary files
xml_input = 'xml_input.tmp'

# loop over each marc record in the set
marcset = MARCReader(marcfile)
count = 0
for record in marcset:

    # write OAI header
    # TODO: handle exceptions for template variable substitution
    # is this exception handling working???
    if (count == 0): # first iteration
        oaiheader = Template(utils.file2string(config.get('system','oai_header_file')))
        uservars['sample_id'] = 'oai:' + \
        uservars['repository_id'] + ':' +record['001'].value()
        try:
            olac_xml_f.write(oaiheader.substitute(uservars))
        except KeyError:
            pass


    # construct a proper marcxml document
    xmlrec = record_to_xml(record) 
    if (output_marcxml_flag == 1):
        marc_xml_f.write(xmlrec)

    xmlrec = marcxmlheader  + xmlrec + marcxmlfooter 

    # write out xml rec to a temp file
    xml_input_f = open(xml_input,'w')
    xml_input_f.write(xmlrec)
    xml_input_f.close()

    # apply stylesheets
    print "start stylesheet"
    utils.apply_stylesheets(xml_input,config)
    print "end stylesheet"

    # read in olac xml record
    olac_record = utils.getstringfromfile(xml_input,'<olac:olac','</olac:olac>')

    # datestamp is the greater of the metadata date and the record date
    rec_date = record['005'].value()[0:8] # first 8 chars
    datestamp = rec_date
    if (uservars['metadata_version_date'].replace('-','') > rec_date):
        datestamp = uservars['metadata_version_date']

    # output record header (with oai ID and datestamp)
    rec_id = record['001'].value()
    olac_xml_f.write(olacrecheader.substitute(identifier=rec_id,datestamp=datestamp))

    # output olac node
    olac_xml_f.write(olac_record)

    # print record footer
    olac_xml_f.write(olacrecfooter + '\n')

    print "record %s written" % rec_id

    count += 1
    #if count == 1:
    #    break



# output end-of-loop footers
if (output_marcxml_flag == 1):
    marc_xml_f.write(marcxmlfooter)

olac_xml_f.write(utils.file2string(config.get('system','oai_footer_file')))


