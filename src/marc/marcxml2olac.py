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
import shutil

# local function library
import utils
import saxsplit

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


splitfiles = ''
if os.path.isfile(marcxml_filename):
    # process XML file with SAX
    chunksize = config.get('system','records_per_transform')
    parser = xml.sax.make_parser()
    generator = xml.sax.handler.ContentHandler() # null sink
    splitter = saxsplit.XMLSplit(parser, generator, marcxml_filename,chunksize)

    # this creates a bunch of temp files
    print "Splitting %s into chunks of %s records" % (marcxml_filename,chunksize)
    splitter.parse(marcxml_filename)
    splitfiles = splitter.getChunkNames()
else: # this is a directory
    print "Skipping SAX split..."

    # make backup of directory
    shutil.copytree(marcxml_filename,marcxml_filename + '_backup')
    splitfiles = ['\\'.join([marcxml_filename,p]) for p in os.listdir(marcxml_filename)]

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
        seen_olac_header = 1
    # write records out to file
    olac_xml_f.write(olac_recs)
olac_xml_f.write(olac_footer)
olac_xml_f.close()

# clean up temporary files, if necessary
if os.path.isfile(marcxml_filename):
    for f in splitfiles:
        os.remove(f)
else:
    # remove processing directory, restore original files from backup
    shutil.rmtree(marcxml_filename)
    os.rename(marcxml_filename + '_backup',marcxml_filename)
