import os
import sys
from optparse import OptionParser
from os import sep
from ConfigParser import ConfigParser
from Olac.MarcCrosswalk.pipeline import CrosswalkPipeline
from Olac.MarcCrosswalk.logger import Logger

# for temporary testing only: remove after refactor is complete
#sys.path.append('..')
#sys.path.append('../../classifier')
# the real classifier dir: sys.path.append('../classifier')
#from iso639_trainer import iso639Classifier

class CrosswalkRunner(Logger):

    def __init__(self):
        Logger.__init__(self, sys.stdout, 'Runner')
        self.projectName = 'default_project'
        self.debug = False
        self.dohtml = False
        self.inverse = False
        self.verbose = False
        self.laststage = 'olacfilter'
        self.paths = None # path dictionary


    def UpdatePaths(self):
        p = dict()
        p['base'] = os.getcwd()
        # figure out base path (i.e. are we in the lib directory or not?)
        #if os.path.exists(basepath + sep + __file__):
        #    paths.base = os.path.dirname(basepath)
        p['lib'] = p['base'] + sep + 'lib'
        p['proj'] = p['base'] + sep + self.projectName
        p['tmp'] = p['proj'] + sep + 'debug'

        # are these going to be used anymore???
        #state.set('system','sep',sep)
        #state.set('system','projpath',p.proj)
        #state.set('system','tmppath',p.tmp)
        #state.set('system','projectname',self.projectName)
        #state.set('system','libpath',p.lib)
        #state.add_section('stylesheet')
        self.paths = p


    def GetCmdParser(self):
        usage = "usage: %prog [options] [projectname]\n'projectname' is the directory name of all of your project files, including the config file 'setup.cfg'."
        clparser = OptionParser(usage)

        clparser.add_option("-d", "--debug", action="store_true",
            dest="debug", default=False,
            help="include debug information in the output XML, useful for analysis of the generated OLAC repository.  Warning: debug information will cause the OLAC repository not to validate. Leaves temporary files for inspection.")

        clparser.add_option("-v", "--verbose", action="store_true",
            dest="verbose", default=False,
            help="show verbose troubleshooting messages")

        clparser.add_option("-i", "--inverse", action="store_true",
            dest="inverse", default=False,
            help="runs the inverse filter on the filter stage specified with the --stop-after flag")

        clparser.add_option("-s", "--stop-after",
            dest="stopafter", default="olacfilter",
            help="must be used in conjuction with the --debug flag.  Specifies after which stage processing should stop.  Acceptable values are marcfilter | crosswalk | enrichment | olacfilter.  olacfilter is the default value. This option is useful for debug, and is also useful when used with the --inverse flag")

        clparser.add_option("-g", "--html", action="store_true",
            dest="do_html_output", default=False,
            help="generate a human-readable HTML version of the OLAC repository")
        return clparser


    def ProcessConfigFile(self, filename):
        # return state object, a product of the config file and the options
        state = OLACState()
        try:
            fullfilename = self.paths['proj'] + sep + filename
            state.read(fullfilename)
            if not os.path.exists(fullfilename):
                raise IOError
        except:
            self.Log("Unable to read state file %s" % (fullfilename))
            sys.exit(2)

        state['debug'] = self.debug
        state['dohtml'] = self.dohtml
        state['laststage'] = self.laststage
        state['verbose'] = self.verbose

        return state


    def ProcessCmdLine(self, clparser):
        (options, args) = clparser.parse_args()
        if len(args) == 1:
            self.projectName = args[0]
        elif len(args) > 1:
            clparser.error("more than 1 argument specified")

        if options.inverse and not options.debug:
            clparser.error("Use of --inverse requires use of --debug.  Add --debug and try again.")

        if options.stopafter != 'olacfilter' and not options.debug:
            clparser.error("Use of --stopafter requires use of --debug.  Add --debug and try again.")

        if not (options.stopafter == 'marcfilter' or 
                options.stopafter == 'crosswalk' or 
                options.stopafter == 'enrichment' or 
                options.stopafter == 'olacfilter'):
            clparser.error("Invalid --stopafter value '%s'.  Value must be one of" 
                    "marcfilter | crosswalk | enrichment | olacfilter" % options.stopafter)

        if options.do_html_output and options.stopafter == 'marcfilter':
            clparser.error("--html cannot be used with --stop-after=marcfilter.  Try removing or changing the --stop-after flag.") 
        
        if options.inverse and not (options.stopafter == 'marcfilter' or options.stopafter == 'olacfilter'):
            clparser.error("--inverse can only be used with --stop-after=marcfilter or --stop-after=olacfilter")

        self.debug = options.debug
        self.dohtml = options.do_html_output
        self.inverse = options.inverse
        self.laststage = options.stopafter
        self.verbose = options.verbose
        if self.debug:
            self.Log("\tNotice: --debug option in use; OLAC repository will NOT validate")


class OLACState(ConfigParser, dict):
    def __init__(self):
        super(OLACState, self).__init__()
