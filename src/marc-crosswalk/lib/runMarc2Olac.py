from marcOlacCrosswalk import CrosswalkPipeline
import os
import sys
from optparse import OptionParser
from os import sep
from ConfigParser import ConfigParser
from logger import Logger

# for temporary testing only: remove after refactor is complete
sys.path.append('..')
sys.path.append('../../classifier')
# the real classifier dir: sys.path.append('../classifier')
#from iso639_trainer import iso639Classifier

class Marc2OlacCrosswalkRunner(Logger):

    def __init__(self):
        Logger.__init__(self, sys.stdout, 'Runner')
        self.projectName = 'default_project'
        self.debug = False
        self.dohtml = False
        self._p = None # path dictionary

    def UpdatePaths(self):
        p = dict()
        p['base'] = os.getcwd()
        # figure out base path (i.e. are we in the lib directory or not?)
        #if os.path.exists(basepath + sep + __file__):
        #    paths.base = os.path.dirname(basepath)
        p['lib'] = p['base'] + sep + 'lib'
        p['tmp'] = p['base'] + sep + 'tmp'
        p['proj'] = p['base'] + sep + self.projectName

        # are these going to be used anymore???
        #state.set('system','sep',sep)
        #state.set('system','projpath',p.proj)
        #state.set('system','tmppath',p.tmp)
        #state.set('system','projectname',self.projectName)
        #state.set('system','libpath',p.lib)
        #state.add_section('stylesheet')
        self._p = p

    def GetPaths(self):
        return self._p

    def GetCmdParser(self):
        usage = "usage: %prog [options] [projectname]\n'projectname' is the directory name of all of your project files, including the config file 'setup.cfg'."
        clparser = OptionParser(usage)

        clparser.add_option("-d", "--debug", action="store_true",
            dest="debug", default=False,
            help="include extra debug information in the output XML, useful for analysis of the generated OLAC repository.  Warning: debug information will cause the OLAC repository not to validate.")

        clparser.add_option("-g", "--html", action="store_true",
            dest="do_html_output", default=False,
            help="generate a human-readable HTML version of the OLAC repository")
        return clparser

    def ProcessConfigFile(self, filename):
        # return state object, a product of the config file and the options
        state = OLACState()
        try:
            fullfilename = self._p['proj'] + sep + filename
            state.read(fullfilename)
            if not os.path.exists(fullfilename):
                raise IOError
        except:
            self.Log("Unable to read state file %s" % (fullfilename))
            sys.exit(2)

        state['debug'] = self.debug
        state['dohtml'] = self.dohtml

        return state

    def ProcessCmdLine(self, clparser):
        (options, args) = clparser.parse_args()
        if len(args) == 1:
            self.projectName = args[0]
        elif len(args) > 1:
            clparser.error("more than 1 argument specified")

        self.debug = options.debug
        self.dohtml = options.do_html_output
        if self.debug:
            self.Log("\tNotice: --debug option in use; OLAC repository will NOT validate")

class OLACState(ConfigParser, dict):
    def __init__(self):
        super(OLACState, self).__init__()

def main():
    runner = Marc2OlacCrosswalkRunner()
    parser = runner.GetCmdParser()
    runner.ProcessCmdLine(parser)
    runner.UpdatePaths()
    state = runner.ProcessConfigFile('setup.cfg')
    state['path'] = runner.GetPaths()
    state['projectName'] = runner.projectName
    runner.Log("Processing %s" % runner.projectName)
    pipeline = CrosswalkPipeline(state)
    pipeline.Start()
    pipeline.Log("Done.")

if __name__ == "__main__":
    main()
