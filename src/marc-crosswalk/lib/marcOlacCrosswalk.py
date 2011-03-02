import sys
import os
import re
import codecs
import xml.etree.ElementTree as etree
from os import sep
from logger import Logger
import pickle

try:
    sys.path.append('..%sclassifier' % sep)
    from iso639_trainer import iso639Classifier
except ImportError as e:
    print 'ImportError:', e
    print 'LanguageSubjectClassifier will be disabled...'

class CrosswalkPipeline(Logger):

    def __init__(self, state):
        Logger.__init__(self, sys.stdout, 'Pipeline')
        self._s = state # internal state of the crosswalk
        self._log = sys.stdout
        self._subjLangClassifier = None

    def Start(self):
        self._PrepareResources()

    def _PrepareResources(self):
        self._CompileMARCFilters()
        self._CompileOLACFilters()
        if 'nltk' in sys.modules:
            self._subjLangClassifier = SubjectLanguageClassifier()
        self._WriteImportMap()
        #marcxml_filename = projpath + sep + config.get('system','input')
        #olacxml_filename = projpath + sep + config.get('system','output')
    
    def _CompileMARCFilters(self):
        xslt = XSLTransform(self._s['path']['lib'])
        xslt.Log("Compiling MARC filters", False, False)
        params = 'version="2.0"'

        # MARC Accept Filter
        stylesheet = self._s['path']['lib'] + sep + 'marc-filter-compile1'
        input = self._s['path']['proj'] + sep + \
                self._s.get('system', 'marcfilter')
        output = self._s['path']['tmp'] + sep + \
                self._s['projectName'] + '-marc-filter-accept.xsl'
        xslt.DoTransform(stylesheet, input, output, params)

        # MARC Reject Filter
        stylesheet = self._s['path']['lib'] + sep + 'marc-filter-compile2'
        input = self._s['path']['proj'] + sep + \
                self._s.get('system', 'marcfilter')
        output = self._s['path']['tmp'] + sep + \
                self._s['projectName'] + '-marc-filter-reject.xsl'
        xslt.DoTransform(stylesheet, input, output, params)

        xslt.Finish()

    def _CompileOLACFilters(self):
        # OLAC Accept filter
        # Note: to run an OLAC reject filter, add param mode=reject
        xslt = XSLTransform(self._s['path']['lib'])
        xslt.Log("Compiling OLAC filter", False, False)
        stylesheet = self._s['path']['lib'] + sep + 'olac-filter-compile'
        input = self._s['path']['proj'] + sep + \
                self._s.get('system', 'olacfilter')
        output = self._s['path']['tmp'] + sep + \
                self._s['projectName'] + '-olac-filter.xsl'
        xslt.DoTransform(stylesheet, input, output)
        xslt.Finish()


    def _WriteImportMap(self):
        localpath = self._s['path']['proj'] + \
                sep + self._s.get('system','local_customizations')
        localpath = localpath.replace(sep,'/') # ensure / for XML use

        f = codecs.open(self._s['path']['lib'] + \
                sep + 'importmap.xsl', encoding='utf-8', mode='w')
        string = """<?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:include href="file:///%s"/>
    </xsl:stylesheet>""" % localpath
        f.write(unicode(string))
        f.close()

class XSLTransform(Logger):

    def __init__(self, libpath):
        Logger.__init__(self, sys.stdout, 'XSLT')
        self._libpath = libpath

    def DoTransform(self, stylesheet, input, output, params = ''):
        saxonfilepath = self._libpath + sep + "saxon9.jar" 
        systemstring = 'java -jar "%s" -xsl:"%s.xsl" -s:"%s" -o:"%s" %s' % \
            (saxonfilepath, stylesheet, input, output, params)
        self.Log(systemstring, True)
        self.Log('.', False, False) # progress indicator
        os.system(systemstring)

    def Finish(self):
        self.Log('.')

class SubjectLanguageClassifier(Logger):
    def __init__(self, state):
        Logger.__init__(self, sys.stdout, 'SubjLangC')
        self._s = state

        self.Log("Loading subject language classifier...")
        filename = self._s['path']['lib'] + sep + 'subjectClassifier.pickle'
        self._classifier = pickle.load(open(filename, 'rb'))

    def _makeOLACSubject(code):
        e = etree.Element("{http://purl.org/dc/elements/1.1/}subject")
        e.attrib['xsi:type'] = 'olac:language'
        e.attrib['olac:code'] = code
        e.attrib['from'] = 'GUESS'
        return e
    
    def Classify(self, input, output):
        doc = etree.parse(input)
        root = doc.getroot()

        dcNS = 'http://purl.org/dc/elements/1.1/'
        xsiNS = 'http://www.w3.org/2001/XMLSchema-instance'
        oNS = 'http://www.language-archives.org/OLAC/1.1/'
        for rec in root.findall('.//{%s}olac' % 'http://www.language-archives.org/OLAC/1.1/'):
            desc = ''
            subj = ''
            title = ''
            has_olac_subject = 0
            for elem in rec:
                if elem.tag == '{%s}description' % dcNS and \
                        elem.text is not None:
                    desc += elem.text + ' \n '
                elif elem.tag == '{%s}subject' % dcNS and \
                        elem.text is not None:
                    subj += elem.text + ' \n '
                elif elem.tag == '{%s}title' % dcNS and \
                        elem.text is not None:
                    title += elem.text + ' \n '

                if elem.tag == '{%s}subject' % dcNS and \
                        elem.attrib.get('{%s}type' % xsiNS) == 'olac:language' \
                        and  elem.attrib.get('{%s}code' % oNS) is not None:
                    has_olac_subject = 1

            # only run classifier for those records that don't have already have an olac subject 
            if not has_olac_subject:
                # get codes from classifier and add OLAC dc:subject elements
                # classify_record(dict, threshold, strongnameweight, weaknameweight, countryweight, regionweight)
                codes = classifier.classify_record({'title': title, 'description': desc, 'subject': subj}, 0.72, 1.0, 0.7, 0.3, 0.2)
            else:
                codes = []

            if len(codes) > 0:
                for code in codes:
                    #rec.insert(0, makeOLACSubject(code))
                    rec.append(self._makeOLACSubject(code))

        # register our namespaces
        etree._namespace_map['http://purl.org/dc/terms/'] = 'dcterms'
        etree._namespace_map['http://www.w3.org/2001/XMLSchema-instance'] = 'xsi'
        etree._namespace_map['http://www.openarchives.org/OAI/2.0/'] = 'oai'
        etree._namespace_map['http://www.openarchives.org/OAI/2.0/static-repository'] = 'sr'
        etree._namespace_map['http://www.language-archives.org/OLAC/1.1/'] = 'olac'
        etree._namespace_map['http://purl.org/dc/elements/1.1/'] = 'dc'
        etree._namespace_map['http://www.language-archives.org/OLAC/1.1/olac-archive'] = 'olac-archive'
        etree._namespace_map['http://www.openarchives.org/OAI/2.0/oai-identifier'] = 'oai-identifier'

        # write out the modified XML file
        etree.ElementTree(root).write(codecs.open(output, 'w', 'utf-8'))
