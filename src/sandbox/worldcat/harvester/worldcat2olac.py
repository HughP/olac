from optparse import OptionParser
import os
import codecs
from datetime import date
import string
import sys
import time
import urllib2
import cPickle as pickle
from worldcat.request.search import SRURequest
from worldcat.util.extract import pymarc_extract


LOG = sys.stderr
class Logger:
    def log(self, msg):
        t = time.strftime("[%Y-%m-%d %H:%M:%S]", time.localtime())
        print >>LOG, t, msg

class Harvester(Logger):
    """ An OCLC WorldCat Harvester that can generate an OLAC static repository of 'search queries' """
    
    def __init__(self):
        self.apikey = ''
        self.results = []
        self.queries = []
        self.types = self._load_olac_types()

    def reset_queries(self):
        self.queries = []

    def reset(self):
        self.__init__()

    def set_api(self, key):
        if len(key) != 80:
            self.log("Warning: API Key did not validate to 80 characters")
        else:
            self.apikey = key

    def add_query(self, qdict):
        self.queries.append(qdict)

    def has_results(self):
        if len(self.results) > 0:
            return True
        else:
            return False

    def _load_olac_types(self):
        filename = 'olac2LCsubj.txt'
        # format expected to be:
        # olactype = subject1|subject2|subject3 with spaces|subj4
        typedict = {}
        for line in open(filename):
            type,string = line.strip().split('=')
            type = type.strip()
            typedict[type] = string.strip().split('|')
        return typedict
        
    def _build_query(self, q):
        query = 'srw.su = "%s"' % q['subj']

        if q['type'] != '':
            if q['type'] in self.types:
                query += ' and (srw.su = "'
                query += '" or srw.su = "'.join(self.types[q['type']])
                query += '")'
            else:
                self.log("Warning: unknown type '%s' given in _build_query")

        return query

    def harvest(self):
        if len(self.results) > 0:
            self.log("Resuming harvest at query %d" % (len(self.results)+1))
        for q in self.queries:
            #q = self.queries.pop()
            if 'harvested' not in q: # if this query has not been harvested
                query = self._build_query(q)
                queryindex = self.queries.index(q)
                code = q['code']
                subj = q['subj']
                type = q['type']
                req = SRURequest(wskey = self.apikey)
                req.args['query'] = query
                try:
                    self.log("Executing query %s of %s '%s'" % (len(self.results)+1, len(self.queries)+1, query))
                    responsedata = req.get_response().data
                except urllib2.HTTPError:
                    responsedata = None

                if responsedata is not None:
                    self.results.append({'code':q['code'],'subj':q['subj'],'type':q['type'],'query':query,'records':pymarc_extract(responsedata)})
                    self.queries[queryindex]['harvested'] = True
                else:
                    self.log("Query limit exceeded.  Stopping at %s of %s.  Try again tomorrow" % (len(self.results)+1, len(self.queries)+1))
                    break


    def make_olac_repo(self, templatePrefix, filename):
        repofile = codecs.open(filename, 'w', 'utf-8')

        # make html directory if necessary
        htmlpath = 'html'
        if not os.path.isdir(htmlpath):
            os.makedirs(htmlpath)

        recordTemplate = string.Template(open(templatePrefix + '_record.tmpl').read())
        headerTemplate = string.Template(open(templatePrefix + '_header.tmpl').read())
        footerTemplate = string.Template(open(templatePrefix + '_footer.tmpl').read())
        htmlHeaderTemplate = string.Template(open('html_header.tmpl').read())
        htmlFooterTemplate = string.Template(open('html_footer.tmpl').read())
        htmlRecordTemplate = string.Template(open('html_record.tmpl').read())

        today = date.today().strftime('%Y-%m-%d')

        # make repo header
        repofile.write(headerTemplate.substitute(dict()))

        # make individual record templates
        ctr = 1
        for r in self.results:
            if len(r['records']) == 0: continue # skip empty results
            
            if templatePrefix == 'wcsimple':
                r['extent'] = len(r['records'])
                htmlfilename = htmlpath + '/%s.html' % ctr
                r['id'] = ctr
                r['today'] = today
                r['link'] = htmlfilename

                repofile.write(recordTemplate.substitute(r))
                
                # make html header
                htmlfile = codecs.open(htmlfilename, 'w', 'utf-8')  
                htmlfile.write(htmlHeaderTemplate.substitute(r))
                
                for rec in r['records']:
                    vars = dict()
                    vars['oclcnum'] = rec['001'].value()
                    vars['title'] = rec['245'].value()
                    htmlfile.write(htmlRecordTemplate.substitute(vars))

                htmlfile.write(htmlFooterTemplate.substitute(dict()))
                htmlfile.close()
                ctr += 1

        # make repo footer
        repofile.write(footerTemplate.substitute(dict()))
        repofile.close()


    def make_hit_report(self, filename):
        def inc(var, dict):
            if var in dict:
                dict[var] += 1
            else:
                dict[var] = 1
        report = open(filename, 'w')
        typetotals = {}
        subjtotals = {}
        subjzeros = []
        for r in self.results:
            inc(r['type'], typetotals)
            inc(r['subj'], subjtotals)
        
        report.write("Total hits by type:\n")
        for type in typetotals:
            report.write("%s %s\n" % (type, typetotals[type]))

        report.write("\n\nTotal hits by subject language:\n")
        for subj in subjtotals:
            if subjtotals[subj] == 0:
                subjzeros.append(subj)
            else:
                report.write("%s %s\n" % (subj, subjtotals[subj]))

        if len(subjzeros) > 0:
            report.write("\n\nThe following subject languages returned no results:\n")
            for subj in subjzeros:
                report.write("%s\n" % (subj))
            
        report.close()
            






### Application Code Starts Here ###
def to_pickle(obj, filename):
    pickle.dump(obj, open(filename, 'w'))

def load_pickle(filename):
    try:
        return pickle.load(open(filename))
    except:
        return False

if __name__ == "__main__":
    usage = "usage: %prog [options]"

    clparser = OptionParser(usage)
    clparser.add_option("-o", "--offline", action="store_false", default=True,
            dest="online", help="run in offline mode")
    clparser.add_option("-r", "--resume", action="store_true", default=False,
            dest="resume", help="resume harvesting from previous pickle")
    clparser.add_option("-p", "--pickle", dest="pickle",
            help="specify pickle file to save/load harvester state")
    clparser.add_option("-k", "--key", dest="apikey",
            help="WorldCat API Key (required if online)")
    clparser.add_option("-i", "--input", dest="queryFilename",
            help="Filename of list of queries to harvest (required if online)")
    clparser.add_option("-f", "--output", dest="repoFilename",
            help="Static repository filename for output")

    (options, args) = clparser.parse_args()

    # required options
    if options.online and not options.resume and not options.apikey:
        clparser.error("--key WorldCat API key is a required argument")
    elif options.online and not options.resume and not options.queryFilename:
        clparser.error("--input Query filename is a required argument")

    # output filename
    if options.repoFilename:
        outputFilename = options.repoFilename
    else:
        outputFilename = 'worldcat_static.xml'

    # default variables
    if options.pickle:
        pickleFilename = options.pickle
    else:
        pickleFilename = 'harvester.pickle'


    harvester = Harvester()

    if options.online and not options.resume:
        queryfile = codecs.open(options.queryFilename, 'r', 'latin-1')
        for line in queryfile:
            # line format: olaclanguage\tlinguistic-type\tquerystring
            line = line.strip().split('\t')
            if len(line) == 3:
                q = {'code':line[0], 'subj':line[1], 'type':line[2]}
            else:
                q = {'code':line[0], 'subj':line[1], 'type':''}
            harvester.add_query(q)
        queryfile.close()

        harvester.set_api(options.apikey)
    elif options.online and options.resume:
        harvester.log("Resuming Harvester from pickle '%s'" % pickleFilename)
        harvester = load_pickle(options.pickle)
        if not harvester:
            print "Error: Unable to run in --resume mode since no previous harvest is available.  Try running the harvester without --resume"
    else:
        harvester.log("Loading Harvester from pickle '%s'" % pickleFilename)
        harvester = load_pickle(options.pickle)
        if not harvester:
            print "Error: Unable to run in --offline mode since no previous harvest is available.  Try running the harvester without --offline"
    if options.online:
        # go online and harvest from WorldCat
        harvester.harvest()
        harvester.log("Pickling Harvester to '%s'" % pickleFilename)
        to_pickle(harvester, pickleFilename)

    if harvester and harvester.has_results():
        harvester.make_olac_repo('wcsimple', outputFilename)
        print "OLAC static repository written to '%s'" % outputFilename
        harvester.make_hit_report('hitreport.txt')
        print "Hit report written to '%s'" % 'hitreport.txt'
    else:
        print "Error: Cannot export static repository because result set is empty"
