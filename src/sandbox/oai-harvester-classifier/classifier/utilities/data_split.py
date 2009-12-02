'''Splits classified data into three sets based on their results, for evaluation purposes.

Splits the output of iso639Classifier.py into three sets:
1) The right answer is in the proposed set of ISO 639 codes.
2) The right answer is not in the proposed set of ISO 639 codes.
3) There are not enough clues in the data to propose a set of ISO 639 codes.

Created on Jul 10, 2009

@author: Joshua S Hou

Usage: python data_split.py [options] test goldstandard set1 set2 set3
'''
import sys
from optparse import OptionParser
from util import *

def data_split(gold_standard, test, out1, out2, out3):
    test_len = len(filter(lambda x: x[0]!='#', [i for i in open(test).readlines()]))
    test = codecs.open(test, encoding='utf-8').readlines()
    gs = codecs.open(gold_standard, encoding='utf-8').readlines()
    if test_len!=len(gs):
        print "Test file and gold standard are for different files."
        return None

    last_output_file = None
    test_idx = 0
    gs_idx = 0

    lengths = {1:0, 2:0, 3:0}

    print>>out1, '# List of records for which the proposed set of ISO 639 codes includes the correct answer.'
    print>>out2, '# List of records for which the proposed set of ISO 639 codes does not include the correct answer.'
    print>>out3, '# List of records for which there were not enough clues in the data to propose a set of ISO 639 codes.'

    while test_idx<len(test):
        if test[test_idx][0]!='#':
            test_isos = set(test[test_idx].strip('\n').split('\t')[1].split())
            gs_isos = set(gs[gs_idx].strip('\n').split('\t')[1].split())
            
            if not test_isos:
                last_output_file = out3
                lengths[3] += 1
            elif not test_isos.intersection(gs_isos):
                last_output_file = out2
                lengths[2] += 1
            else:
                last_output_file = out1
                lengths[1] += 1
            print>>last_output_file, test[test_idx].strip()
            gs_idx += 1
        else: # debug line, print to appropriate file.
            print>>last_output_file, test[test_idx].strip()
        test_idx += 1

    denom = float(sum(lengths.values()))
    print "Classification includes correct answer:", lengths[1]/denom
    print "Classification doesn't include correct answer:", lengths[2]/denom
    print "Not enough evidence to propose anything:", lengths[3]/denom

if __name__=='__main__':
    parser = OptionParser('Usage: python data_split.py [options] goldstandard test set1 set2 set3')
    parser.add_option('-f','--force',dest='force',action='store_true',\
                        help='Forces overwrite of files')
    (options, args) = parser.parse_args()
    if len(args)!=5:
        parser.print_help()
        sys.exit(1)

    if options.force:
        out1 = codecs.open(args[2],'w', encoding='utf-8')
        out2 = codecs.open(args[3],'w', encoding='utf-8')
        out3 = codecs.open(args[4],'w', encoding='utf-8')
    else:
        out1 = check_file(args[2],'w', utf=True)
        out2 = check_file(args[3],'w', utf=True)
        out3 = check_file(args[4],'w', utf=True)
    data_split(args[0],args[1],out1,out2,out3)
