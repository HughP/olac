from optparse import OptionParser
import os
import re
import codecs
from datetime import date
from operator import itemgetter
import string
import sys
import time
import random
import urllib2
import cPickle as pickle
from worldcat.request.search import SRURequest
from worldcat.util.extract import pymarc_extract

MAXIMUM_RECORDS = 500

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
        self.waitLowerBound = 0
        self.waitUpperBound = 0
        self._stopped = False

    def random_wait_between(self, lowerBound, upperBound):
        """function to set the lower and upper bounds of the random wait"""
        self.waitLowerBound = lowerBound
        self.waitUpperBound = upperBound

    def _wait(self):
        if self.waitUpperBound != 0:
            seconds = random.randint(self.waitLowerBound, self.waitUpperBound)
            self.log("Waiting %d seconds..." % seconds)
            time.sleep(seconds)

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
        typedict['all_types'] = []
        for line in open(filename):
            type,string = line.strip().split('=')
            type = type.strip()
            typedict[type] = string.strip().split('|')
            typedict['all_types'].extend(typedict[type])
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


    def _sru_request(self, query, startNum = 1):
        # wait a random amount of time
        self._wait()

        req = SRURequest(wskey = self.apikey)
        req.args['query'] = query
        req.args['maximumRecords'] = 50
        if startNum > 1:
            req.args['startRecord'] = startNum
        try:
            return req.get_response().data
        except (urllib2.HTTPError, urllib2.URLError), errstr:
            self._stopped = True
            self.log("Error: %s" % errstr)
            return None

    def _build_recs(self, marcrecs):
        records = {}
        for rec in marcrecs:
            records[rec['245'].value()] = {
                'title':rec['245'].value(),
                'oclcnum':rec['001'].value()
            }
        return records
        

    def _get_records(self, q):
        records = []
        query = self._build_query(q)
        subj = q['subj']

        self.log("Executing query %s of %s '%s'" % (self.queries.index(q)+1, len(self.queries), subj))

        responseData = self._sru_request(query)
        if responseData is not None:
            records.extend(self._build_recs(pymarc_extract(responseData)))
            nextPosition = self._get_next_id(responseData)
        else:
            nextPosition = None


        while nextPosition is not None and len(records) < MAXIMUM_RECORDS:
            responseData = self._sru_request(query, nextPosition)
            if responseData is not None:
                records.extend(self._build_recs(pymarc_extract(responseData)))
                nextPosition = self._get_next_id(responseData)
            else:
                nextPosition = None


        return sorted(records)
            
            
            
    def _get_next_id(self, data):
        nextId = re.search('<nextRecordPosition>(\d+)</nextRecordPosition>', data)
        if nextId is not None:
            return nextId.group(1)
        else:
            return None
        

    def harvest(self):
        if len(self.results) > 0:
            self.log("Resuming...")
        for q in self.queries:
            #q = self.queries.pop()
            if 'harvested' not in q: # if this query has not been harvested
                recs = self._get_records(q)
                query = self._build_query(q)

                if len(recs) != 0:
                    query = self._build_query(q)
                    self.results.append({'code':q['code'],'subj':q['subj'],'type':q['type'],'query':query,'records':recs})
                    self.queries[self.queries.index(q)]['harvested'] = True
                elif self._stopped:
                    self._stopped = False
                    self.log("Stopping at %s of %s.  Try again tomorrow" % (self.queries.index(q)+1, len(self.queries)))
                    break
                else: # no results for this query - still count as harvested
                    self.queries[self.queries.index(q)]['harvested'] = True


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
                if r['extent'] == MAXIMUM_RECORDS:
                    r['extent'] = str(r['extent']) + '+'
                htmlfilename = htmlpath + '/%s.html' % ctr
                r['id'] = ctr
                r['today'] = today
                r['link'] = htmlfilename

                repofile.write(recordTemplate.substitute(r))
                
                # make html header
                htmlfile = codecs.open(htmlfilename, 'w', 'utf-8')  
                htmlfile.write(htmlHeaderTemplate.substitute(r))
                

                for t in r['records']:
                    htmlfile.write(htmlRecordTemplate.substitute(r['records'][t]))

                htmlfile.write(htmlFooterTemplate.substitute(dict()))
                htmlfile.close()
                ctr += 1

        # make repo footer
        repofile.write(footerTemplate.substitute(dict()))
        repofile.close()


    def make_hit_report(self, filename):
        report = open(filename, 'w')
        typetotals = {}
        subjtotals = {}
        subjzeros = []
        for r in self.results:
            type = r['type']
            if type == '':
                type = '[no type]'
            subj = r['subj']

            if type not in typetotals:
                typetotals[type] = len(r['records'])
            else:
                typetotals[type] += len(r['records'])
                
            if subj not in subjtotals:
                subjtotals[subj] = len(r['records'])
            else:
                subjtotals[subj] += len(r['records'])

        report.write("Total hits by type:\n")
        for type in typetotals:
            report.write("%s %s\n" % (type, typetotals[type]))

        report.write("\n\nTotal hits by subject language:\n")
        for pair in sorted(subjtotals.items(), reverse=True, key=itemgetter(1)):
            if pair[1] == 0:
                subjzeros.append(pair[0])
            else:
                report.write("%s %s\n" % (pair[0], pair[1]))

        if len(subjzeros) > 0:
            report.write("\n\nThe following %s subject languages returned no results:\n" % len(subjzeros))
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
    clparser.add_option("-m", "--max-queries-per-day", dest="maxqueries",
            help="Specifies the approximate maximum queries to execute in a 24 hour period.  The harvester will be throttled accordingly")

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
        outputFilename = 'worldcat_repository.xml'

    # default variables
    if options.pickle:
        pickleFilename = options.pickle
    else:
        pickleFilename = 'harvester.pickle'

    # max queries per 24 period
    if options.maxqueries:
        secondsPerQuery = 86400 / int(options.maxqueries)
        lowerBound = 0
        upperBound = int(secondsPerQuery * 2)

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

        # sleep for a random amount of time between queries
        if options.maxqueries:
            harvester.random_wait_between(lowerBound, upperBound)

        harvester.harvest()
        harvester.log("Pickling Harvester to '%s'" % pickleFilename)
        to_pickle(harvester, pickleFilename)

    if harvester and harvester.has_results():
        harvester.make_olac_repo('wcsimple', outputFilename)
        print "OLAC static repository written to '%s'" % outputFilename
        hitreportFilename = '%s_hitreport.txt' % outputFilename
        harvester.make_hit_report(hitreportFilename)
        print "Hit report written to '%s'" % hitreportFilename
    else:
        print "Error: Cannot export static repository because result set is empty"
