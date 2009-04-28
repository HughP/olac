# Conversion script for MARC record set -> OLAC repository
# Chris Hirt
# 2008-07-31
# requires Python version 2.4
# 
# this version uses the alternate strategy of chunking the MARCXML records into batches of a reasonable size that can be processed efficiently on the command-line using Saxon
# this strategy will employ two loops:
#  1) loop over the marc xml records, filter out unwanted ones based upon filter rules, and write out files containing batches of <= MAX_RECS (likely to be 10,000)
#  2) loop over each file created by step 1, run them through the XSLT transform and then re-join them together (using SAX ?)

from string import Template
import ConfigParser
import re
import sys
import os
import xml.sax
import saxsplit

# local function library
import utils
import filter

# get marc source file from command line
try:
    marcxml_filename = sys.argv.pop(1)
    olacxml_filename = sys.argv.pop(1)
except:
    print "please specify\n1) marc xml input file 2) olac xml output file"
    sys.exit(2)

# initialize the config file
config = ConfigParser.ConfigParser()
config.read("marc2olac.cfg")

# process XML file with SAX
chunksize = config.get('system','records_per_transform')
parser = xml.sax.make_parser()
generator = xml.sax.handler.ContentHandler() # null sink
splitter = saxsplit.XMLSplit(parser, generator, marcxml_filename,chunksize)

# this creates a bunch of temp files
print "Splitting MARCXML file into chunks of %s records" % chunksize
splitter.parse(marcxml_filename)
splitfiles = splitter.getChunkNames()

seen_olac_header = 0
olac_footer = ''
olac_xml_f = open(olacxml_filename,'w')

# loop over each XML chunk and apply stylesheet chain
for f in splitfiles:
    print "transforming %s" % f
    utils.apply_stylesheets(f,config)
    header,olac_recs,footer = utils.parseOLACRepository(f)
    if seen_olac_header == 0:
        olac_xml_f.write(header)
        olac_footer = footer
    # write records out to file
    olac_xml_f.write(olac_recs)
olac_xml_f.write(olac_footer)
olac_xml_f.close()

# clean up temporary files
for f in splitfiles:
    os.remove(f)
