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
from optparse import OptionParser

# local function library
import utils
import saxsplit

# os specific path separator
sep = os.sep

# define command-line options and parse them
usage = "usage: %prog [options] [projectname]\n'projectname' is the directory name of all of your project files, including the config file 'setup.cfg'."
clparser = OptionParser(usage)
(options, args) = clparser.parse_args()

# update config dict with options from command line
# TODO Implement this

projectname = 'default_project'
if len(args) == 1:
    projectname = args[0]
elif len(args) > 1:
    clparser.error("more than 1 argument specified")

# figure out base path (i.e. are we in the lib directory or not?)
basepath = os.getcwd()
if os.path.exists(basepath + sep + 'marc2olac.py'):
    basepath = os.path.dirname(basepath)
libpath = basepath + sep + 'lib'
tmppath = basepath + sep + 'tmp'
projpath = basepath + sep + projectname

# initialize the config file
config = ConfigParser.ConfigParser()
try:
    config.read("%s%ssetup.cfg" % (projpath,sep))
    if not os.path.exists("%s%ssetup.cfg" % (projpath,sep)):
        raise IOError
except:
    print "Unable to read config file %s%ssetup.cfg" % (projpath,sep)
    sys.exit(2)

config.set('system','sep',sep)
config.set('system','projpath',projpath)
config.set('system','tmppath',tmppath)
config.set('system','projectname',projectname)
config.set('system','libpath',libpath)

# check to make sure required files exist
# TODO Implement this
# is this necessary?
utils.checkValidSystem(config)

print "Compiling filters..."
config = utils.compileFilters(config)

marcxml_filename = projpath + sep + config.get('system','input')
olacxml_filename = projpath + sep + config.get('system','output')

utils.writeImportMap(config)

splitfiles = ''
if os.path.isfile(marcxml_filename):
    # process XML file with SAX
    chunksize = config.get('system','records_per_transform')
    parser = xml.sax.make_parser()
    generator = xml.sax.handler.ContentHandler() # null sink
    splitter = saxsplit.XMLSplit(parser, generator, marcxml_filename,chunksize)
    splitter.setTempDir(tmppath)
    splitter.setVerbose(True)

    # this creates a bunch of temp files
    print "Creating %s record batches using SAX" % (chunksize)
    splitter.parse(marcxml_filename)
    splitfiles = splitter.getChunkNames()
else: # this is a directory
    print "Skipping SAX split..."

    # check if backup directory exists; if it does, previous run failed.
    # try and run from backup instead
    if os.path.isdir(marcxml_filename + '_backup'):
        if os.path.isdir(marcxml_filename): shutil.rmtree(marcxml_filename)
        os.rename(marcxml_filename + '_backup',marcxml_filename)
    # make backup of directory
    shutil.copytree(marcxml_filename,marcxml_filename + '_backup')
    splitfiles = [sep.join([marcxml_filename,p]) for p in os.listdir(marcxml_filename)]

olac_footer = ''
olac_xml_f = open(olacxml_filename,'w')

# loop over each XML chunk and apply stylesheet chain
ctr = 1
for f in splitfiles:
    print "transforming batch %d of %d" % (ctr,len(splitfiles))
    utils.applyStylesheets(f,config)
    header,olac_recs,footer = utils.parseOLACRepository(f)
    if ctr == 1:
        olac_xml_f.write(header)
        olac_footer = footer
    # write records out to file
    olac_xml_f.write(olac_recs)
    ctr += 1
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

print "Done.  OLAC Repository %s generated in %s." % (config.get('system','output'),projectname) 
