import sys
import os
import subprocess
import re
import codecs
import xml.etree.ElementTree as etree
from os import sep
from logger import Logger
import pickle
import shutil
import crosswalkutils as utils

try:
    sys.path.append('../classifier/subject-language')
    from iso639_classifier import iso639Classifier
except ImportError, e:
    print 'ImportError:', e, 'LanguageSubjectClassifier will be disabled.'

class CrosswalkPipeline(Logger):

    def __init__(self, state):
        Logger.__init__(self, sys.stdout, 'Pipeline')
        self._s = state # internal state of the crosswalk
        self._log = sys.stdout
        self._subjLangClassifier = None
        self._typeClassifier = None
        self._files = [] # list of input files
        self._s['tmpfiles'] = []


    def Initialize(self, mode='normal'):
        self._PrepareResources(mode)
        self._SetupInputFiles()

    def Run(self, mode='normal'):
        if self._s['laststage'] != 'olacfilter':
            self.Log("File processing will finish after the %s stage" % self._s['laststage'])
        self._ProcessLoop(mode)


    def Finish(self, mode='normal'):
        self._Cleanup()
        if self._s['dohtml']: self._GenerateHTML(mode)


    def _Cleanup(self):
        source = self._s['path']['proj'] + \
                sep + self._s.get('system', 'input')

        # clean up tmp files left around from processing input files
        if os.path.isfile(source):
            if not self._s['debug']: # debug mode leaves tmp files around
                for f in self._files:
                    os.remove(f)
        else:
            # remove processing directory, restore original files from backup
            shutil.rmtree(source)
            os.rename(source + '_backup', source)

        # clean up other tmp files
        if not self._s['debug']:
            for f in self._s['tmpfiles']:
                os.remove(f)


    def _GenerateHTML(self, mode='normal'):
        stylesheet = self._s['path']['lib'] + sep + 'repository2html.xsl'
        input = self._s['path']['proj'] + sep + self._s.get('system', 'output')
        output = self._s['path']['proj'] + sep + self._s.get('system', 'html_output')
        if mode == 'inverse':
            root, ext = os.path.splitext(output)
            output = root + '-inverse' + ext
            root, ext = os.path.splitext(input)
            input = root + '-inverse' + ext
        self.Log("Generating HTML output to %s ..." % os.path.basename(output), False, False)
        xslt = XSLTransform(self._s['path']['lib'])
        xslt.SetVerbose(self._s['verbose'])
        xslt.SetLabel('GenerateHTML')
        xslt.DoTransform(stylesheet, input, output)
        xslt.Finish()


    def _PrepareResources(self, mode='normal'):
        self._CompileMARCFilters(mode)
        if self._s['laststage'] == 'olacfilter':
            self._CompileOLACFilters(mode)
        if self._s['laststage'] != 'marcfilter':
            self._WriteImportMap()
        if self._s['laststage'] != 'marcfilter' and self._s['laststage'] != 'crosswalk':
            if 'nltk' in sys.modules:
                self._subjLangClassifier = SubjectLanguageClassifier(self._s)
            if TypeClassifier.MalletIsInstalled():
                self._typeClassifier = TypeClassifier(self._s)
            else:
                self.Log("Mallet is not installed.  Type Classifier will be skipped.")
                self._typeClassifier = None
    

    def _SetupInputFiles(self):
        input = self._s['path']['proj'] + sep + self._s.get('system', 'input')

        # if the input is a single file, split the XML file with SAX
        if os.path.isfile(input):
            import xml.sax
            import saxsplit
            chunksize = self._s.get('system','records_per_transform')
            parser = xml.sax.make_parser()
            generator = xml.sax.handler.ContentHandler() # null sink
            splitter = saxsplit.XMLSplit(parser, generator, input, chunksize)
            splitter.setTempDir(self._s['path']['tmp'])
            splitter.setVerbose(True)

            # this creates a bunch of temp files
            self.Log("Creating %s record batches using SAX" % (chunksize), False, False)
            splitter.parse(input)
            self._files = splitter.getChunkNames()

        else: # this is a directory
            self.Log("Using input files from: %s" % input, True)

            # check if backup directory exists; if it does, previous run failed.
            # restore backup directory
            if os.path.isdir(input + '_backup'):
                self.Log("Warning: Previous run may have failed. Restoring backup files...")
                if os.path.isdir(input): shutil.rmtree(input)
                os.rename(input + '_backup',input)
            # make backup of directory
            self.Log("Backing up input files...")
            shutil.copytree(input,input + '_backup')
            # only use xml files
            directory = []
            for f in os.listdir(input):
                base,ext = os.path.splitext(f)
                if ext == '.xml': directory.append(f)
            self._files = [sep.join([input,p]) for p in directory]


    def _ProcessLoop(self, mode='normal'):
        ctr = 1;
        xml_footer = ''
        tmpfile = self._s['path']['tmp'] + sep + 'xml_output.tmp'
        tmpfile2 = self._s['path']['tmp'] + sep + 'xml_output2.tmp'

        outputfilename = self._s['path']['proj'] + sep + self._s.get('system', 'output')
        if mode == 'inverse':
            root,ext = os.path.splitext(outputfilename)
            outputfilename = root + '-inverse' + ext
        output = codecs.open(outputfilename, 'w', 'utf-8')

        if len(self._files) > 1:
            self.Log("Processing %d files" % len(self._files))
        else:
            self.Log("Processing 1 file", False, False)

        for f in self._files:
        # TODO this loop would be more readable if implemented using a state machine (switch) instead of if/else
            if len(self._files) > 1: self.Log(str(ctr), False, False) 

            xslt = XSLTransform(self._s['path']['lib'])
            xslt.SetLabel('LOOP')
            xslt.SetVerbose(self._s['verbose'])

            # MARC Filter
            stylesheet = self._s['path']['tmp'] + sep + \
                self._s['projectName']
            if mode == 'inverse' and self._s['laststage'] == 'marcfilter':
                stylesheet += '-marc-filter-inverse.xsl'
            else:
                stylesheet += '-marc-filter.xsl'

            xslt.DoTransform(stylesheet, f, tmpfile)
            if (not utils.tryToMove(tmpfile, f, stylesheet)): break

            if self._s['laststage'] != 'marcfilter':

                # Crosswalk
                stylesheet = self._s['path']['lib'] + \
                        sep + 'collection2repository.xsl'
                params = ''
                if (self._s['debug']): params = 'debug=yes'
                xslt.DoTransform(stylesheet, f, tmpfile, params)
                if (not utils.tryToMove(tmpfile, f, stylesheet)): break

                # Post-Crosswalk: cleanup
                stylesheet = self._s['path']['lib'] + \
                        sep + 'cleanup.xsl'
                params = ''
                if (self._s['debug']): params = 'debug=yes'
                xslt.DoTransform(stylesheet, f, tmpfile, params)
                if (not utils.tryToMove(tmpfile, f, stylesheet)): break

                # Post-Crosswalk: remove duplicates
                stylesheet = self._s['path']['lib'] + \
                        sep + 'remove_duplicates.xsl'
                xslt.DoTransform(stylesheet, f, tmpfile)
                if (not utils.tryToMove(tmpfile, f, stylesheet)): break

                if self._s['laststage'] != 'crosswalk':

                    # Type Classifier
                    if self._typeClassifier is not None:
                        self._typeClassifier.Classify(f, tmpfile)
                        if (not utils.tryToMove(tmpfile, f)):
                            self.Log("Error: TypeClassifier did not output a file!")
                            break
                    
                        # Filter: has OLAC type (asserts all records have an OLAC type)
                        # Are we sure that we need this step???  Maybe the subject language classifier has been improved?
                        stylesheet = self._s['path']['lib'] + \
                                sep + 'olac-filter-has-olac-type.xsl'
                        xslt.DoTransform(stylesheet, f, tmpfile)
                        if (not utils.tryToMove(tmpfile, f, stylesheet)): break

                    # Subject Classifier
                    if 'nltk' in sys.modules:
                        self._subjLangClassifier.Classify(f, tmpfile)
                        if (not utils.tryToMove(tmpfile, f)):
                            self.Log("Error: SubjectLanguageClassifier did not output a file!")
                            break

                    if self._s['laststage'] != 'enrichment':

                        # OLAC Filter
                        stylesheet = self._s['path']['tmp'] + sep + \
                            self._s['projectName']
                        if mode == 'inverse':
                            stylesheet += '-olac-filter-inverse.xsl'
                        else:
                            stylesheet += '-olac-filter.xsl'

                        xslt.DoTransform(stylesheet, f, tmpfile)
                        if (not utils.tryToMove(tmpfile, f, stylesheet)): break

            if self._s['laststage'] == 'marcfilter':
                header, recs, footer = self.ParseMARCCollection(f)
            else:
                header, recs, footer = self.ParseOLACRepo(f)
            xslt.Finish()



            # write and capture XML header and footer for output file
            if ctr == 1:
                output.write(header)
                xml_footer = footer

            output.write(recs)
            ctr += 1

        output.write(xml_footer)
        output.close()


    def ParseOLACRepo(self, filename):
        """parseOLACRepo(xml_filename)
        purpose: extract three elements from an OLAC XML Repository file:
                1) olac header (text that precedes the start of the first record)
                2) olac_records, not including the <sr:ListRecords> wrapper tags
                3) olac footer (text that follows the last record)
        returns: string tuple:
            olac_header (string)
            olac_records (string)
            olac_footer (string)
            """
        s = utils.file2string(filename)
        p = re.compile("^(.*<sr:ListRecords[^>]+>)(.*)(</sr:ListRecords>.*)$",
                re.DOTALL)
        m = p.search(s)
        if m:
            return (m.group(1),m.group(2),m.group(3))
        else:
            return ('','','')


    def ParseMARCCollection(self, filename):
        """parseMARCCollection(xml_filename)
        purpose: extract three elements from a MARC XML Collection file:
                1) marc collection header (text that precedes the start of the first record)
                2) marc_records, not including the <marc:collection> wrapper tags
                3) marc collection footer (text that follows the last record)
        returns: string tuple:
            marc_header (string)
            marc_records (string)
            marc_footer (string)
            """
        s = utils.file2string(filename)
        p = re.compile("^(.*<marc:collection[^>]+>)(.*)(</marc:collection>.*)$",re.DOTALL)
        m = p.search(s)
        if m:
            return (m.group(1),m.group(2),m.group(3))
        else:
            return ('','','')


    def _CompileMARCFilters(self, mode='normal'):
        xslt = XSLTransform(self._s['path']['lib'])
        xslt.SetLabel('MARCFilter')
        xslt.Log("Compiling MARC filter", False, False)
        xslt.SetVerbose(self._s['verbose'])
        params = 'version="2.0"'

        stylesheet = self._s['path']['lib'] + sep + 'marc-filter-compile.xsl'
        input = self._s['path']['proj'] + sep + \
                self._s.get('system', 'marcfilter')
        output = self._s['path']['tmp'] + sep + \
                self._s['projectName']

        if mode == 'inverse':
            params += ' mode="reject"'
            output += '-marc-filter-inverse.xsl'
        else: # normal mode
            output += '-marc-filter.xsl'
        xslt.DoTransform(stylesheet, input, output, params)
        xslt.Finish()

    def _CompileOLACFilters(self, mode='normal'):
        params = 'version="2.0"'
        xslt = XSLTransform(self._s['path']['lib'])
        xslt.SetLabel('OLACFilter')
        xslt.SetVerbose(self._s['verbose'])
        xslt.Log("Compiling OLAC filter", False, False)
        stylesheet = self._s['path']['lib'] + sep + 'olac-filter-compile.xsl'
        input = self._s['path']['proj'] + sep + \
                self._s.get('system', 'olacfilter')
        output = self._s['path']['tmp'] + sep + \
                self._s['projectName'] 

        if mode == 'inverse':
            params += ' mode="reject"'
            output += '-olac-filter-inverse.xsl'
        else: # normal mode
            output += '-olac-filter.xsl'
        xslt.DoTransform(stylesheet, input, output, params)
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
        systemstring = 'java -jar "%s" -xsl:"%s" -s:"%s" -o:"%s" %s' % \
            (saxonfilepath, stylesheet, input, output, params)
        self.Log(systemstring, True)
        self.Log('.', False, False) # progress indicator
        os.system(systemstring)

    def Finish(self):
        self.Log(' ')

class TypeClassifier(Logger):
    def __init__(self, state):
        Logger.__init__(self, sys.stdout, 'TypeC')
        self._s = state

    @classmethod
    def MalletIsInstalled(cls):
        # if mallet on windows is installed, the mallet.bat should be in the path
        cmdout = subprocess.Popen(["mallet.bat", "--help"], stdout=subprocess.PIPE).communicate()[0]
        if cmdout.count("Mallet 2.0 commands") > 0:
            return True
        # if mallet is installed on *nix, the mallet.sh should be in the path
        #if os.system("mallet.sh --help").count("Mallet 2.0 commands") > 0:
        #    return True

        return False

    def Classify(self, input, output):
        tab1 = self._s['path']['tmp'] + sep + 'typeclassify_initialtabfile.tmp'
        tab2 = self._s['path']['tmp'] + sep + 'typeclassify_afterbinary.tmp'
        tab3 = self._s['path']['tmp'] + sep + 'typeclassify_afterprep.tmp'
        tab4 = self._s['path']['tmp'] + sep + 'typeclassify_aftermulti.tmp'
        self._s['tmpfiles'].extend([tab1, tab2, tab3, tab4])

        self._CreateTabFile(input, tab1)

        # Binary Classifier
        classifierfile = 'resourceTypeBinaryClassifier.mallet'
        self._RunMallet(tab1, tab2, classifierfile)

        self._PrepForMulti(tab2, tab3)

        # Multi Classifier
        classifierfile = 'resourceTypeMultiClassifier.mallet'
        self._RunMallet(tab3, tab4, classifierfile)

        self._MergeResults(input, tab4, output)

    def _CreateTabFile(self, xmlfile, tabfile):
        outfile = codecs.open(tabfile, 'w', 'utf-8')
        doc = etree.parse(xmlfile)
        root = doc.getroot()
        dcNS = 'http://purl.org/dc/elements/1.1/'
        xsiNS = 'http://www.w3.org/2001/XMLSchema-instance'
        olacNS = 'http://www.language-archives.org/OLAC/1.1/'
        oaiNS = 'http://www.openarchives.org/OAI/2.0/'
        for oairec in root.findall('.//{%s}record' % oaiNS):
            textstring = ''
            has_olac_type = 0
            id = oairec.find('{%s}header' % \
                    oaiNS).find('{%s}identifier' % oaiNS).text.strip()

            olacrec = oairec.find('{%s}metadata' % \
                    oaiNS).find('{%s}olac' % olacNS)
            for elem in olacrec:
                if elem.tag == '{%s}description' % dcNS and \
                        elem.text is not None:
                    textstring += elem.text.strip() + ' *** '
                elif elem.tag == '{%s}subject' % dcNS and \
                        elem.attrib.get('{%s}type' % xsiNS) == 'dcterms:LCSH' \
                        and elem.text is not None:
                    textstring += elem.text.strip() + ' *** '
                elif elem.tag == '{%s}title' % dcNS and \
                        elem.text is not None:
                    textstring += elem.text.strip() + ' *** '
                # do we need to include IsPartOf (a qdc element)?
                elif elem.tag == '{%s}type' % dcNS and \
                        elem.attrib.get('{%s}type' % xsiNS) \
                        == 'olac:linguistic-type' and \
                        elem.attrib.get('{%s}code' % oNS) is not None:
                    has_olac_type = 1

            # only write out records that don't have an olac type 
            if not has_olac_type:
                textstring = utils.scrubtext(textstring)
                outfile.write("%s\t\t%s\n" % (id, textstring))

        outfile.close()

    def _RunMallet(self, tabinfile, taboutfile, classifier):
        pass

    def _MergeResults(self, xmlIn, tabOut, xmlOut):
        pass

    def _PrepForMulti(self, tabIn, tabOut):
        # only keeps lines in the tab file that have been classified as YES
        pass


class SubjectLanguageClassifier(Logger):
    def __init__(self, state):
        Logger.__init__(self, sys.stdout, 'SubjLangC')
        self._s = state

        self.Log("Loading subject language classifier...")
        filename = self._s['path']['base'] + sep + \
                '..' + sep + 'classifier' + sep + \
                'subject-language' + sep + 'SubjectLang.pickle'
        self._classifier = pickle.load(open(filename, 'rb'))

    def _makeOLACSubject(self, code):
        e = etree.Element("{http://purl.org/dc/elements/1.1/}subject")
        e.attrib['xsi:type'] = 'olac:language'
        e.attrib['olac:code'] = code
        if self._s['debug']:
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
                codes = self._classifier.classify_record({'title': title, 'description': desc, 'subject': subj}, 0.72, 1.0, 0.7, 0.3, 0.2)
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
