#!/usr/bin/env python

import sys
import codecs
import random

# get args from command line
if len(sys.argv) != 4:
    print "arguments: [classifier results] [output file] [classifier comment]"
    sys.exit()
else:
    classifiercomment = sys.argv.pop()
    outputfile = sys.argv.pop()
    inputfile = sys.argv.pop()

outfile = codecs.open(outputfile, 'w', 'latin-1')

# a threshold of .4 will allow up to two labels per item
# threshold of .3 could theoretically allow three labels (although unlikely)
threshold = .4

for line in codecs.open(inputfile, 'r', 'latin-1'):
    tokens = line.split('\t')
    if len(tokens) == 3:
        id = tokens[0].strip()
        content = tokens[2].strip()
        results = content.split(' ')
        for r in results:
            pair = r.strip().split(':')
            if len(pair) == 2:
                label = pair[0]
                prob = float(pair[1])
                if prob > threshold:
                    if prob < .5:
                        print "id %s is less than .5" % id
                    outfile.write("%s\t%s\ttype\t1500\t%s\t15\tresource-type\n" % (id, label, classifiercomment))
outfile.close()
