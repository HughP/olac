# encoding=utf-8
"""Tab-delimited corpus reader for training data for Resource Type Classifier."""

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
        record = {}
        while True:
            pos = stream.tell()
            line = stream.readline().decode('utf-8')
            if not line.strip(): break
            fieldvals = [i.strip() for i in line.strip(u'﻿').strip().split('\t')]
            (record_id, element_tag, element_value) = fieldvals
            if not record:
                record['record_id'] = record_id
            else:
                if record['record_id'] != record_id:
                    stream.seek(pos)
                    return [record]

            if element_tag in record:
                element_value = record[element_tag] + ' ' + element_value
            record[element_tag] = element_value

        return [record]

    def _mkrecord(self, line):
        return dict(zip(self.fields, fieldvals))
