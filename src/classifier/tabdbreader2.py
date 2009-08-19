"""
Corpus readers for the Tab-delineated table format used by
olacdb.tab and oaidb.tab.  The corpus reader scans through the
file and collects all of the elements for a given item together,
returning them as a single "record."  A record is a dictionary
with two special keys (Archive_ID and Item_ID) identifying the
record item, along with keys for the individual elements in the
table.  E.g.:

    >>> reader = TabTableCorpusReader('oai_classifier_trn', '.*db\.tab')
    >>> olac_records = reader.records('olacdb.tab')
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

from nltk.corpus.reader.util import *
from nltk.corpus.reader.api import *

class TabDBCorpusReader(CorpusReader):
    def records(self, fileids=None):
        if fileids is None: fileids = self._fileids
        elif isinstance(fileids, basestring): fileids = [fileids]
        return concat([TabDBCorpusView(fileid,encoding=enc)
                       for (fileid, enc) in self.abspaths(fileids, True)])

class TabDBCorpusView(StreamBackedCorpusView):
    def read_block(self, stream):
        if stream.tell() == 0:
            # Read header.
#            assert stream.readline() == '--------------\n'
#            self.select_cmd = stream.readline()
#            assert self.select_cmd.startswith('select ')
#            assert stream.readline() == '--------------\n'
#            assert stream.readline() == '\n'
#            assert stream.readline() == (
#                'Archive_ID\tItem_ID\tElement_ID\tOaiIdentifier\tTagName\tType\t'
#                'Code\tContent\n')
            self.fields = stream.readline().rstrip('\n').split('\t')
            

        record = {}
        while True:
            pos = stream.tell()
            line = stream.readline().decode('utf-8')
            if not line.strip(): break
            fieldvals = line.rstrip('\n').split('\t')
            (archive_id, item_id, elt_id, oai_id, tag_name,
                type, code, content) = fieldvals
            if not record:
                record['Archive_ID'] = archive_id
                record['Item_ID'] = item_id
                record['Oai_ID'] = oai_id
            else:
                if (record['Archive_ID'] != archive_id or
                    record['Item_ID'] != item_id or
                    record['Oai_ID'] != oai_id):
                    stream.seek(pos)
                    return [record]

            # For fields with multiple values, use newlines to
            # separate them.
            if not (tag_name=='subject' and type=='language'):    
                if tag_name in record:
                    content = record[tag_name] + ' \n ' + content
                record[tag_name] = content
            elif type=='language':
                if 'iso639' in record:
                    code = record['iso639'] + ' ' + code
                record['iso639'] = code

        return [record]

    def _mkrecord(self, line):
        return dict(zip(self.fields, fieldvals))
