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

# final stage number (end of the process pipeline)
final_stage = 4

# define command-line options and parse them
usage = "usage: %prog [options] [projectname]\n'projectname' is the directory name of all of your project files, including the config file 'setup.cfg'."
clparser = OptionParser(usage)
clparser.add_option("-d", "--debug", action="store_true",
        dest="debug", default=False,
        help="include extra debug information in the output XML, useful for analysis of the generated OLAC repository.  Warning: debug information will cause the OLAC repository not to validate.")
clparser.add_option("-g", "--html", action="store_true",
        dest="do_html_output", default=False,
        help="generate a human-readable HTML version of the OLAC repository")

clparser.add_option("-s", "--stage", action="store", type="int", 
        dest="stage", default=final_stage,
        help="Run the process up through the specified stage")
clparser.add_option("-i", "--inverse", action="store_true",
        dest="inverse", default=False,
        help="Output the inverse of the specified stage.  Useful for debugging, and usually used in conjunction with --stage=[num]")
clparser.add_option("-k", "--skip-marc-filter", action="store_true",
        dest="skipmarcfilter", default=False,
        help="Skip the MARC filter stages (1 and 2).  Useful for when a marc filter has previously run on the dataset, and one doesn't want to run it again redundantly")


(options, args) = clparser.parse_args()

projectname = 'default_project'
if len(args) == 1:
    projectname = args[0]
elif len(args) > 1:
    clparser.error("more than 1 argument specified")
if options.stage > 0 and options.stage <= final_stage:
    stage = options.stage
else:
    clparser.error("specified stage must be between 1 and %d" % final_stage)
if options.stage < 3 and options.skipmarcfilter == 'yes':
    clparser.error("you cannot --skip-marc-filter and set a stage < 3 !")

print "Processing %s" % projectname




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
config.set('system','stage',str(stage))
config.add_section('stylesheet')

# update config dict with options from command line
# TODO Implement the rest of this
if options.debug:
    print "\tNotice: --debug option in use; OLAC repository will NOT validate"
    config.set('system','debug','yes')
else:
    config.set('system','debug','no')

if options.inverse:
    print "\tNotice: Inverse output will be generated at stage %d" % stage
    config.set('system','inverse','yes')
else:
    config.set('system','inverse','no')

if stage < final_stage:
    print "\tNotice: Processing will finish after stage %d of %d" % (stage,final_stage)

if options.skipmarcfilter:
    print "\tNotice: MARC filter stages 1 and 2 will be skipped"
    config.set('system','skipmarcfilter','yes')
else:
    config.set('system','skipmarcfilter','no')

# check to make sure required files exist
# TODO Implement this
# is this necessary?
utils.checkValidSystem(config)

if stage >=4 or not options.skipmarcfilter:
    sys.stdout.write("Compiling filters")

if not options.skipmarcfilter:
    config = utils.compileMARCFilters(config)

if stage >= 4:
    config = utils.compileOLACFilters(config)
sys.stdout.write('\n')

marcxml_filename = projpath + sep + config.get('system','input')
olacxml_filename = projpath + sep + config.get('system','output')

if stage >= 3:
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
    # only use xml files
    directory = []
    for f in os.listdir(marcxml_filename):
        base,ext = os.path.splitext(f)
        if ext == '.xml': directory.append(f)
    splitfiles = [sep.join([marcxml_filename,p]) for p in directory]


# modify output filename
dotindex = olacxml_filename.find('.')
if stage < final_stage:
    if dotindex != -1:
        olacxml_filename = olacxml_filename[0:dotindex] + '.stage' + str(stage) + olacxml_filename[dotindex:]
    else:
        olacxml_filename += '.stage' + str(stage)
if options.inverse:
    if dotindex != -1:
        olacxml_filename = olacxml_filename[0:dotindex] + '.inverse' + olacxml_filename[dotindex:]
    else:
        olacxml_filename += '.inverse'

# loop over each XML chunk and apply stylesheet chain
ctr = 1
xml_footer = ''
output_xml_f = open(olacxml_filename,'w')
for f in splitfiles:
    print "Transforming batch %d of %d" % (ctr,len(splitfiles))
    utils.applyStylesheets(f,config)

    if stage >= 3:
        header,xml_recs,footer = utils.parseOLACRepository(f)
    else:
        header,xml_recs,footer = utils.parseMARCCollection(f)

    if ctr == 1:
        output_xml_f.write(header)
        xml_footer = footer
    # write records out to file
    output_xml_f.write(xml_recs)
    ctr += 1
output_xml_f.write(xml_footer)
output_xml_f.close()

# clean up temporary files, if necessary
if os.path.isfile(marcxml_filename):
    for f in splitfiles:
        os.remove(f)
else:
    # remove processing directory, restore original files from backup
    shutil.rmtree(marcxml_filename)
    os.rename(marcxml_filename + '_backup',marcxml_filename)

# generate an HTML file, if appropriate
if options.do_html_output and stage >= 3:
    html_out = config.get('system', 'html_output')

    # rename output file if necessary
    if options.inverse:
        dotindex = html_out.find('.')
        if dotindex != -1:
            html_out = html_out[0:dotindex] + '.inverse' + html_out[dotindex:]
        else:
            html_out += '.inverse'

    print "Generating HTML output to %s" % html_out
    utils.transform(config,libpath + sep + 'repository2html',olacxml_filename,
            projpath + sep + html_out)

if stage < final_stage:
    print "Done."
else:
    print "Done.  OLAC Repository %s generated in %s." % (olacxml_filename, projectname) 
