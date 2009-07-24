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
(options, args) = parser.parse_args()

if options.ten:
    for i in range(1,11):
        print classifier_functions.function_labels[i-1]+'\n'
        print "--CLASSIFYING TEST--"
        sys.stdout.flush()
        os.system('python iso639Classifier.py -d -f -i %d classifier.pickle iso639_test2.tab iso639_test2.classified' % i)
        print "--EVALUATING TEST--"
        sys.stdout.flush()
        os.system('python iso639_evaluator.py iso639_test2.gs iso639_test2.classified')
        print "--CLASSIFYING OLAC DISPLAY--"
        sys.stdout.flush()
        os.system('python iso639Classifier.py -d -f -i %d classifier.pickle olac_display_subset.xml olac_display_subset.classified' % i)
        print "--EVALUATING OLAC DISPLAY--"
        sys.stdout.flush()
        os.system('python iso639_evaluator.py olac_display_subset.gs olac_display_subset.classified')
        print "\n--------------------------------------------------------------------\n"
else:
    print "--TRAINING--"
    sys.stdout.flush()
    os.system('python iso639_trainer.py -f preprocessor/training_data.tab classifier.pickle')
    print "--CLASSIFYING TEST--"
    sys.stdout.flush()
    os.system('python iso639Classifier.py -d -f classifier.pickle iso639_test2.tab iso639_test2.classified')
    print "--EVALUATING TEST--"
    sys.stdout.flush()
    os.system('python iso639_evaluator.py iso639_test2.gs iso639_test2.classified')
    print "--CLASSIFYING OLAC DISPLAY--"
    sys.stdout.flush()
    os.system('python iso639Classifier.py -d -f classifier.pickle olac_display_subset.xml olac_display_subset.classified')
    print "--EVALUATING OLAC DISPLAY--"
    sys.stdout.flush()
    os.system('python iso639_evaluator.py olac_display_subset.gs olac_display_subset.classified')
