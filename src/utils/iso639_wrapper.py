'''Wrapper that calls iso 639 trainer, classifier, and evaluator.

Wrapper that calls iso639_trainer.py, iso639Classifier.py and iso639_evaluator
all in one go.  It is not scalable, but is meant for running experiments,
because it can call everything at once.

Created on Jul 9, 2009

@author: jshou
'''
import sys
import os
import optparse
import classifier_functions
from util import *

parser = optparse.OptionParser()
parser.add_option('-t', '--ten', action='store_true', dest='ten', help='Run classifier over all 10 functions and print the performance results')
parser.add_option('-f', '--file', dest='file', default='test_data/iso639_test2.tab', help='Specifies name of file to be classified.')
(options, args) = parser.parse_args()

header = options.file.split('.')[0]

if options.ten:
    for i in range(1,11):
        print classifier_functions.function_labels[i-1]+'\n'
        print "--CLASSIFYING TEST--"
        sys.stdout.flush()
        os.system('python iso639Classifier.py -g %s -d -f -i %d classifier.pickle %s %s.classified' % (header+'.gs', i, options.file, header))
        print "--EVALUATING TEST--"
        sys.stdout.flush()
        os.system('python iso639_evaluator.py %s.gs %s.classified' % (header, header))
        print "--CLASSIFYING OLAC DISPLAY--"
        sys.stdout.flush()
        os.system('python iso639Classifier.py -g test_data/olac_display_subset2.gs -d -f -i %d classifier.pickle test_data/olac_display_subset2.xml test_data/olac_display_subset2.classified' % i)
        print "--EVALUATING OLAC DISPLAY--"
        sys.stdout.flush()
        os.system('python iso639_evaluator.py test_data/olac_display_subset2.gs test_data/olac_display_subset2.classified')
        print "\n--------------------------------------------------------------------\n"
else:
    print "--TRAINING--"
    sys.stdout.flush()
    os.system('python iso639_trainer.py -f preprocessor/training_data.tab classifier.pickle')
    print "--CLASSIFYING TEST--"
    sys.stdout.flush()
    os.system('python iso639Classifier.py -g %s -d -f classifier.pickle %s %s.classified' % (header+'.gs', options.file, header))
    print "--EVALUATING TEST--"
    sys.stdout.flush()
    os.system('python iso639_evaluator.py %s.gs %s.classified' % (header, header))
    print "--CLASSIFYING OLAC DISPLAY--"
    sys.stdout.flush()
    os.system('python iso639Classifier.py -g test_data/olac_display_subset2.gs -d -f classifier.pickle test_data/olac_display_subset2.xml test_data/olac_display_subset2.classified')
    print "--EVALUATING OLAC DISPLAY--"
    sys.stdout.flush()
    os.system('python iso639_evaluator.py test_data/olac_display_subset2.gs test_data/olac_display_subset2.classified')
