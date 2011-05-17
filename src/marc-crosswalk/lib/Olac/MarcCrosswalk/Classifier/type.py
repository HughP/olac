import sys
import os
import os.path
import subprocess
import codecs
import xml.etree.ElementTree as etree
from os import sep
from Olac.MarcCrosswalk.Classifier.base import ClassifierBase
from Olac.MarcCrosswalk import utils

class TypeClassifier(ClassifierBase):
    def __init__(self, state):
        ClassifierBase.__init__(self, state)
        self._etreeRegisterNamespaces()

        self._sourcetext = dict()
        self.PathToClassifier = sep.join(['..', 'classifier', 'resource-type',
            'ResourceTypeClassify.class'])
        if not os.path.exists(self.PathToClassifier):
            self._compileWithJava()


    @classmethod
    def MalletIsInstalled(cls):
        if 'MALLET_HOME' in os.environ and os.path.exists(
                os.environ['MALLET_HOME'] + sep + 'bin' + sep + 'mallet'):
            return True
        else:
            return False

#        # if mallet on windows is installed, the mallet.bat should be in the path
#        try:
#            cmdout = subprocess.Popen(["mallet.bat", "--help"], stdout=subprocess.PIPE).communicate()[0]
#        except:
#            return False
#        if cmdout.count("Mallet 2.0 commands") > 0:
#            return True
#
#        # if mallet is installed on *nix, the mallet.sh should be in the path
#        #if os.system("mallet.sh --help").count("Mallet 2.0 commands") > 0:
#        #    return True
#
#        return False


    """SetEnvironment() sets up the os environment variables for correct
    compilation of the mallet-based classifier using javac"""
    def SetEnvironment(self): 
        mallet = os.environ['MALLET_HOME'] + sep
        os.environ['PATH'] += os.pathsep + mallet + 'bin'
        classpaths = [
                '.',
                mallet + 'src',
                mallet + 'class',
                mallet + 'lib' + sep + 'trove-2.0.2.jar',
                mallet + 'lib' + sep + 'bsh.jar'
                ]

        os.environ['CLASSPATH'] = os.pathsep.join(classpaths)
        self.Log('classpath = ' + os.environ['CLASSPATH'], True)


    def _compileWithJava(self):
            origdir = os.getcwd()
            os.chdir(os.path.dirname(self.PathToClassifier))
            cmd = "javac -d . ResourceTypeClassify.java"
            os.system(cmd)
            os.chdir(origdir)


    def Classify(self, input, output):
        inputbasename = os.path.basename(input)
        tab1 = self._s['path']['tmp'] + sep + inputbasename + '-typeclassify_initialtabfile.tmp'
        tab2 = self._s['path']['tmp'] + sep + inputbasename + '-typeclassify_afterbinary.tmp'
        tab3 = self._s['path']['tmp'] + sep + inputbasename + '-typeclassify_afterprep.tmp'
        tab4 = self._s['path']['tmp'] + sep + inputbasename + '-typeclassify_aftermulti.tmp'
        #self._s['tmpfiles'].extend([tab1, tab2, tab3, tab4])
        self._s['tmpfiles'].extend([tab1, tab4])


#        self._CreateTabFile(input, tab1)
#
#        # Binary Classifier
#        classifierfile = 'resourceTypeBinaryClassifier.mallet'
#        self._RunMallet(tab1, tab2, classifierfile)
#
#        self._PrepForMulti(tab2, tab3)

        self._CreateTabFile(input, tab1)

        # Multi Classifier
        classifierfile = 'resourceTypeMultiClassifier.mallet'
        self._RunMallet(tab1, tab4, classifierfile)

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
                        elem.text is not None and \
                        elem.attrib.get('{%s}type' % xsiNS) != 'dcterms:URI':
                    textstring += elem.text.strip() + ' *** '
                elif elem.tag == '{%s}subject' % dcNS and \
                        elem.attrib.get('{%s}type' % xsiNS) == 'dcterms:LCSH' \
                        and elem.text is not None:
                    textstring += elem.text.strip() + ' *** '
                elif elem.tag == '{%s}title' % dcNS and \
                        elem.text is not None:
                    textstring += elem.text.strip() + ' *** '
                # do we need to include IsPartOf (a qdc element)?
                elif elem.tag == '{%s}type' % dcNS and (
                        elem.attrib.get('{%s}type' % xsiNS) ==
                        'olac:linguistic-type' or \
                        elem.attrib.get('{%s}type' % xsiNS) ==
                        'olac:resource-type') and \
                        elem.attrib.get('{%s}code' % olacNS) is not None:
                    has_olac_type = 1

            # only write out records that don't have an olac type 
            if not has_olac_type:
                textstring = utils.scrubtext(textstring)
                outfile.write("%s\t\t%s\n" % (id, textstring))
                self._sourcetext[id] = textstring

        outfile.close()

    def _RunMallet(self, tabinfile, taboutfile, classifier):
        origdir = os.getcwd()
        os.chdir(os.path.dirname(self.PathToClassifier))
        cmd = "java ResourceTypeClassify %s %s %s" % (
                classifier, tabinfile, taboutfile)
        self.Log(cmd, True)
        cmdout = subprocess.Popen(cmd.split(" "), 
                stdout=subprocess.PIPE).communicate()[0]
        self.Log(cmdout, True)
        os.chdir(origdir)

    def _MergeResults(self, xmlIn, tabIn, xmlOut):
        tabfile = codecs.open(tabIn, 'r', 'utf-8')
        doc = etree.parse(xmlIn)
        root = doc.getroot()
        dcNS = 'http://purl.org/dc/elements/1.1/'
        xsiNS = 'http://www.w3.org/2001/XMLSchema-instance'
        olacNS = 'http://www.language-archives.org/OLAC/1.1/'
        oaiNS = 'http://www.openarchives.org/OAI/2.0/'

        # load answers into a dictionary
        enrichedrecords = dict()
        for line in tabfile:
            id, resulttext = line.split('\t\t')
            results = resulttext.split(' ')
            result1, threshold1 = results[0].split(':')
            if float(threshold1) >= .85:
                enrichedrecords[id] = result1
        tabfile.close()

        # loop over each OLAC record node
        for oairec in root.findall('.//{%s}record' % oaiNS):
            textstring = ''
            has_olac_type = 0
            id = oairec.find('{%s}header' % \
                    oaiNS).find('{%s}identifier' % oaiNS).text.strip()

            olacrec = oairec.find('{%s}metadata' % \
                    oaiNS).find('{%s}olac' % olacNS)
            if id in enrichedrecords:
                olacrec.append(self._makeOLACType(enrichedrecords[id]))

        # write out the modified XML file
        outfile = codecs.open(xmlOut, 'w', 'utf-8')
        etree.ElementTree(root).write(outfile)
        outfile.close()


    def _PrepForMulti(self, tabIn, tabOut):
        infile = codecs.open(tabIn, 'r', 'utf-8')
        outfile = codecs.open(tabOut, 'w', 'utf-8')

        for line in infile.readlines():
            id, response = line.split('\t\t')
            if response.startswith('YES'):
                outfile.write("%s\t\t%s\n" % (id, self._sourcetext[id]))
        infile.close()
        outfile.close()


    def _makeOLACType(self, type):
        e = etree.Element("{http://purl.org/dc/elements/1.1/}type")
        #e.attrib['xsi:type'] = 'olac:linguistic-type'
        e.attrib['xsi:type'] = 'olac:resource-type'
        e.attrib['olac:code'] = type
        if self._s['debug']:
            e.attrib['from'] = 'GUESS'
        return e
