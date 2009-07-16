"""XMLCorpusReader
Corpus readers for the OLAC XML dumps.  The corpus reader scans through the file
and uses an XML parser to collect all of the elements for a given item together,
returning them as a single "record".  A record is a dictionary with two special
keys (Archive_ID and Item_ID) identifying the record item, along with keys for
the individual elements in the table.  E.g.:

    >>> reader = XMLCorpusReader('oai_classifier_trn', '.*\.xml')
    >>> olac_records = reader.records('olac_display.xml')
    >>> print olac_records[0]
    {'Archive_ID': '1',
     'title': "Acquiring and Exploiting the User's Knowledge in Guidance Interactions",
     'creator': 'Eyal Shifroni\nUzzi Ornan',
     'contributor': 'Uzzi Ornan',
     'Item_ID': '920998',
     'identifier': 'http://www.aclweb.org/anthology/A92-1042'}

If an element has more than one value, then the values are joined
using newlines (e.g., the 'creator' element from the above example
record has two values.)

The set of elements that are used by the OAI database are:

    'Archive_ID', 'description', 'format', 'contributor', 'creator',
    'relation', 'coverage', 'date', 'subject', 'publisher',
    'language', 'rights', 'title', 'source', 'Item_ID',
    'identifier', 'type'

The set of elements that are used by the OLAC database are:

    'Archive_ID', 'conformsTo', 'extent', 'creator', 'abstract',
    'isRequiredBy', 'relation', 'contributor', 'alternative',
    'subject', 'bibliographicCitation', 'hasVersion', 'title',
    'isFormatOf', 'source', 'spatial', 'isPartOf', 'type',
    'available', 'medium', 'description', 'format', 'hasPart',
    'tableOfContents', 'accessRights', 'Item_ID', 'coverage',
    'date', 'isVersionOf', 'publisher', 'license', 'language',
    'rights', 'created', 'modified', 'references', 'identifier',
    'requires'

"""

import re
from nltk.corpus.reader.util import *
from nltk.corpus.reader.api import *

class XMLCorpusReader(CorpusReader):
    def records(self, fileids=None):
        if fileids is None: fileids = self._fileids
        elif isinstance(fileids, basestring): fileids = [fileids]
        return concat([XMLCorpusView(fileid, encoding='utf-8')
                       for (fileid, enc) in self.abspaths(fileids, True)])

class XMLCorpusView(StreamBackedCorpusView):
    def __init__(self, fileid, block_reader=None, startpos=0, encoding=None):
        StreamBackedCorpusView.__init__(self, fileid, block_reader, startpos, encoding)
        self.re_elt = re.compile(r'</dc.*?:(\w+)>')
        self.re_content = re.compile(r'>(.*?)<', re.S)
        self.re_endline = re.compile(r'</.*?>\s*?(\n|$)', re.M|re.S)

    def read_block(self, stream):
        record = {}
        started = False
        while True:
            pos = stream.tell()
            line = stream.readline()
            if not line.strip():
                break
            if '<olac:olac>' in line and not started:
                started = True
            elif ('<olac:olac>' in line or '</records>' in line) and started:
                if '</records>' not in line:
                    stream.seek(pos)
                return [record]
            elif '</olac:olac>' in line:
                continue
            else:
                if started:
                    while not self.re_endline.search(line):
                        line += stream.readline()
                    elt = self.re_elt.findall(line)[0]
                    content = self.re_content.findall(line)[0]
                    if elt=='subject' and 'xsi:type="olac:language"' in line:
                        if 'iso639' in record:
                            content = record['iso639'] + ' ' + content
                        record['iso639'] = content
                    else:
                        if elt=='identifier':
                            elt = 'Oai_ID'
                        if elt in record:
                            content = record[elt] + ' \\n ' + content
                        record[elt] = content
        return [record]
