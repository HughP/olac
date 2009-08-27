#!/usr/bin/python
'''Processes a tab delimited corpus with tabdbreader and saves the data in a
serialized file for Mallet to use in training.
'''
import sys
import os
import codecs
from nltk.probability import *
from tabdbreader import *

def doc_features(record):
    f = FreqDist()
    record.pop('target','NONE')
    words = ' '.join(record.values())
    map(f.inc, wordpunct_tokenize(words.lower()))
    return f

def get_tempfile_name():
    default_name = 'TEMP_FILE'
    tempfilename = default_name
    counter = 1
    while os.path.exists(tempfilename):
        tempfilename = default_name + '_' + str(counter)
    return tempfilename

def main():
    if len(sys.argv)!=3:
        sys.exit('Usage: python malletize.py directory output')
    tempfilename = get_tempfile_name()
    reader = TabDBCorpusReader(sys.argv[1], '.*\.txt')
    records = reader.records()
    tempfile = codecs.open(tempfilename, 'w', encoding='utf-8')
    for record in records:
        record_id = record.pop('record_id')
        target = record.pop('target','NONE')
        print >>tempfile, record_id+'\t'+target+'\t'+ ' '.join(record.values()).replace('\n',' \\n ')
#       fv = doc_features(record)
#       print>>tempfile, record_id+'\t'+target+'\t' + ' '.join([keyval[0]+' '+str(keyval[1]) for keyval in fv.items()])
    tempfile.close()
    os.system('mallet import-file --input %s --output %s --remove-stopwords' % (tempfilename, sys.argv[2]))
    os.remove(tempfilename)
# --name 1 --label 2 --data 3 
if __name__=="__main__":
    main()
