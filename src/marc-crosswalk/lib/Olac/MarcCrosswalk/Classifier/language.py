import sys
import codecs
import xml.etree.ElementTree as etree
from os import sep
import pickle
from Olac.MarcCrosswalk.Classifier.base import ClassifierBase

class SubjectLanguageClassifier(ClassifierBase):
    def __init__(self, state):
        ClassifierBase.__init__(self, state)

        self.Log("Loading subject language classifier...")
        filename = self._s['path']['base'] + sep + \
                '..' + sep + 'classifier' + sep + \
                'subject-language' + sep + 'SubjectLang.pickle'
        self._classifier = pickle.load(open(filename, 'rb'))
        self._etreeRegisterNamespaces()

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
        olacNS = 'http://www.language-archives.org/OLAC/1.1/'
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
                        and  elem.attrib.get('{%s}code' % olacNS) is not None:
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
                    rec.append(self._makeOLACSubject(code))

        # write out the modified XML file
        etree.ElementTree(root).write(codecs.open(output, 'w', 'utf-8'))
