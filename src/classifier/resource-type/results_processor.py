#!/usr/bin/python
#
# Processes results printout of the 10 binary classifiers and outputs a tab
# delimited table of the results.

import sys
import optparse

def main():
    parser = optparse.OptionParser(usage="python results_processor.py [options] results_file")
    (options, args) = parser.parse_args()
    if len(args)!=1:
        parser.print_help()
        sys.exit()

    results_file = open(args[0]).readlines()
    iso639_test = { 'Precision':[], 'Recall':[], 'F-score':[] }
    olac_display= { 'Precision':[], 'Recall':[], 'F-score':[] }
    
    flipper = True
    for line in results_file:
        if ': ' in line:
            type, score = line.strip().split(': ')
            if flipper:
                olac_display[type].append(score)
            else:
                iso639_test[type].append(score)

            if type=='F-score':
                flipper = not flipper

    print "olac_display_subset"
    print_chart(olac_display)
    print ""

    print "iso639_test"
    print_chart(iso639_test)

def print_chart(d):
    print "F\tPrecision\tRecall\tF-score"
    for i in range(len(d['Recall'])):
        print '\t'.join([str(i+1), d['Precision'][i], d['Recall'][i], d['F-score'][i]])

if __name__=='__main__':
    main()
