# Conversion script for MARC record set -> OLAC repository
# Chris Hirt
# 2008-07-31
# requires Python version 2.4
# 
# this version uses the alternate strategy of chunking the MARCXML records into batches of a reasonable size that can be processed efficiently on the command-line using Saxon
# this strategy will employ two loops:
#  1) loop over the marc records, filter out unwanted ones based upon filter rules, and write out files containing batches of <= MAX_RECS (likely to be 10,000)
#  2) loop over each file created by step 1, run them through the XSLT transform and then re-join them together (using SAX ?)

from string import Template
import ConfigParser
import re
import sys
import os

# local function library
import utils
import filter

# modules you may need to install
from pymarc import MARCReader
from pymarc import record_to_xml

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

filecount = 1

# setup temporary output file (first batch) for first iteration
batchfiles = []
batchfiles.append('batch_%05d.tmp' % filecount)
current_batch_f = open('batch_%05d.tmp' % filecount,'w')
current_batch_f.write(marcxmlheader)

# loop over each marc record in the set
recs = 0
total = 0
marcset = MARCReader(marcfile)
for record in marcset:
    # if we've reached the maximum records per transform, close this file
    # and start a new one
    if (recs != 0 and recs % int(config.get('system','max_records_per_transform')) == 0):
        current_batch_f.write(marcxmlfooter)
        current_batch_f.close()
        filecount += 1
        current_batch_f = open('batch_%05d.tmp' % filecount,'w')
        current_batch_f.write(marcxmlheader)
        batchfiles.append('batch_%05d.tmp' % filecount)

    if (filter.passStage(record) and not filter.rejectStage(record)):
        recs += 1
        current_batch_f.write(record_to_xml(record))
        if (output_marcxml_flag == 1):
            marc_xml_f.write(record_to_xml(record))
    total += 1


current_batch_f.write(marcxmlfooter)
current_batch_f.close()

# loop over batch files created, and run them through the XSLT parser
for f in batchfiles:
   print "transforming %s" % f
   utils.apply_stylesheets(f,config)
   olac_rec = utils.getstringfromfile(f,'<olac:olac','</olac:olac>')
   print 'olac_rec = ', olac_rec


print 'total records = %d\nincluded records = %d' % (total,recs)
print batchfiles
