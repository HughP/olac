import sys
import xml.etree.ElementTree as etree
from logger import Logger

class ClassifierBase(Logger):
    def __init__(self, state):
        Logger.__init__(self, sys.stdout, state['verbose'], 'SubjLangC')
        self._s = state

    def _etreeRegisterNamespaces(self):
        etree._namespace_map['http://purl.org/dc/terms/'] = 'dcterms'
        etree._namespace_map['http://www.w3.org/2001/XMLSchema-instance'] = 'xsi'
        etree._namespace_map['http://www.openarchives.org/OAI/2.0/'] = 'oai'
        etree._namespace_map['http://www.openarchives.org/OAI/2.0/static-repository'] = 'sr'
        etree._namespace_map['http://www.language-archives.org/OLAC/1.1/'] = 'olac'
        etree._namespace_map['http://purl.org/dc/elements/1.1/'] = 'dc'
        etree._namespace_map['http://www.language-archives.org/OLAC/1.1/olac-archive'] = 'olac-archive'
        etree._namespace_map['http://www.openarchives.org/OAI/2.0/oai-identifier'] = 'oai-identifier'
