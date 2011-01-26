# encoding=utf-8
'''complexname_preprocessor.py

Takes as input a tab-delimited file with ISO 639-3 codes in one column and a
complex language name in another column.  Processes each complex language name
and outputs all possible alternates of the complex language name in the format
described in wiki:iso639_trainerDatafileFormat.

@author: Joshua S Hou

Created Sept 8, 2009

Usage: python complexname_preprocessor.py [options] inputfile
'''
import sys
import optparse
import re
import codecs

class ComplexNameParser:
    def __init__(self):
        self.splitter = re.compile(r'[\s-]+')
        self.stoplist = set(['Central','Coast','Costal','Lower','Middle','Upper','West',
            'Western','East','Eastern','North','Northern','Northeast',
            'Northeastern','Northwest','Northwestern','South','Southern',
            'Southeast','Southeastern','Southwest','Southwestern','Spoken',
            'St.','River','Lesser','Saint','Cluster','Colloquial','Valley','Sign','Language','Gulf',
            'Mt.','Moutain'])

    def parse(self, input):
        input = input.replace(',','')
        return [i for i in self.splitter.split(input) if i not in self.stoplist and len(i)>1]

def main():
    parser = optparse.OptionParser(usage='python complexname_preprocessory [options] inputfile')
    parser.add_option('-o', '--output',dest='output',help='appends complex name data to this file')
    (options, args) = parser.parse_args()

    if options.output:
        output = codecs.open(options.output,'a', encoding='utf-8')
    else:
        output = sys.stdout
    if len(args)!=1:
        parser.print_help()
        sys.exit(1)

    cnp = ComplexNameParser()
    for line in codecs.open(args[0],encoding='utf-8').readlines():
        line = line.strip(u'﻿\n\r\t ')
        if not line or line[0]=='#':
            continue
        try:
            iso, complex_name = line.split('\t')
        except ValueError:
            sys.exit(line)
        variants = cnp.parse(complex_name)
        for variant in variants:
            output.write(iso+'\twn\t'+variant+'\n')

if __name__=="__main__":
    main()
