from optparse import OptionParser
import codecs
#import os
import sys
import time
import pickle


LOG = sys.stderr
class Logger:
    def log(self, msg):
        t = time.strftime("[%Y-%m-%d %H:%M:%S]", time.localtime())
        print >>LOG, t, msg

class Harvester(Logger):
    """ An OCLC WorldCat Harvester that can generate an OLAC static repository of 'search queries' """
    
    def __init__(self):
        self.apikey = ''
        self.resultset = []
        self.queries = []

    def reset_queries(self):
        self.queries = []

    def reset(self):
        self.__init__()

    def set_api(self, key):
        if len(key) != 80:
            log("Error: API Key did not validate to 80 characters")
        else:
            self.apikey = key

    def to_pickle(self, filename):
        log("Pickling Harvester to '%s'" % filename)
        pickle.dump(self, open(filename, 'w'))

    def load_pickle(self, filename):
        log("Loading Harvester from pickle '%s'" % filename)
        try:
            self = pickle.load(open(filename))
            return True
        except:
            log("Error: cannot load pickle!")
            return False

    def add_query(self, qlist):
        self.queries.append(qlist)

    def has_results(self):
        if len(self.results) > 0:
            return True
        else:
            return False
        
    def harvest(self): pass

    def make_olac_repo(self, templatePrefix, filename): pass

    def make_hit_report(self, filename): pass

        
        





### Application Code Starts Here ###
if __name__ == "__main__":
    usage = "usage: %prog [options]"

    clparser = OptionParser(usage)
    clparser.add_option("-o", "--offline", action="store_false",
            dest="online", default=True,
            help="Generate repository from previous results if available from earlier online run")
    clparser.add_option("-k", "--key", dest="apikey",
            help="WorldCat API Key (required if online)")
    clparser.add_option("-i", "--input", dest="queryFilename",
            help="Filename of list of queries to harvest (required if online)")
    clparser.add_option("-f", "--output", dest="repoFilename",
            help="Static repository filename for output")

    (options, args) = clparser.parse_args()

    # required options
    if options.online and not options.apikey:
        clparser.error("--key WorldCat API key is a required argument")
    elif options.online and not options.queryFilename:
        clparser.error("--input Query filename is a required argument")

    # output filename
    if options.repoFilename:
        outputFilename = options.repoFilename
    else:
        outputFilename = 'worldcatStaticRepository.xml'

    # default variables
    pickleFilename = 'harvester.pickle'

    harvester = Harvester()

    if options.online:
        queryfile = codecs.open(options.queryFilename, 'r', 'latin-1')
        for line in queryfile:
            line = line.strip()
            # line format: olaclanguage\tlinguistic-type\tquerystring
            harvester.add_query(line.split('\t'))
        queryfile.close()

        # go online and harvest from WorldCat
        harvester.set_api_key(options.apikey)
        harvester.harvest()
        harvester.to_pickle(pickleFilename)
    else:
        if not harvester.load_pickle(pickleFilename):
            print "Error: Unable to run in --offline mode since no previous harvest is available.  Try running the harvester without --offline"

    if harvester.has_results():
        harvester.make_olac_repo('template', outputFilename)
        print "OLAC static repository written to '%s'" % outputFilename
        harvester.make_hit_report('hitreport.txt')
        print "Hit report written to '%s'" % 'hitreport.txt'
    else:
        print "Error: Cannot export static repository because result set is empty"
