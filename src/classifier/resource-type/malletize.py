#!/usr/bin/python
'''Processes a tab delimited corpus with tabdbreader and saves the data in a
serialized file for Mallet to use in training.
'''
import sys
import os
import codecs
import optparse
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
    parser = optparse.OptionParser(usage='python malletize.py directory output')
    parser.add_option("-p","--plaintext",action="store_true",default=False,dest="plaintext")
    (options, args) = parser.parse_args()

    if len(args)!=2:
        parser.print_help()
        sys.exit(1)
    
    if options.plaintext:
        tempfilename = args[1]
    else:
        tempfilename = get_tempfile_name()
    reader = TabDBCorpusReader(args[0], '.*\.txt')
    records = reader.records()
    tempfile = codecs.open(tempfilename, 'w', encoding='utf-8')
    for record in records:
        record_id = record.pop('record_id')
        target = record.pop('target','NONE')
        print >>tempfile, record_id+'\t'+target+'\t'+ ' '.join(record.values()).replace('\n',' \\n ')
    tempfile.close()
    if not options.plaintext:
        os.system('mallet import-file --input %s --output %s --remove-stopwords' % (tempfilename, args[1]))
        os.remove(tempfilename)
# --name 1 --label 2 --data 3 
if __name__=="__main__":
    main()
