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

basedir = os.path.join(os.path.split(sys.argv[0])[0],'..')
parser = optparse.OptionParser()
parser.add_option('-t', '--ten', action='store_true', dest='ten', help='Run classifier over all 10 functions and print the performance results')
parser.add_option('-f', '--file', dest='file', default='test_data/iso639_test2.tab', help='Specifies name of file to be classified.')
(options, args) = parser.parse_args()

header = options.file.split('.')[0]

dir_dict = {"directory":basedir}
if options.ten:
    for i in range(1,11):
        print classifier_functions.function_labels[i-1]+'\n'
        print "--CLASSIFYING TEST--"
        sys.stdout.flush()
        os.system('python %(directory)s/iso639Classifier.py -g %(directory)s/test_data/iso369_test2.gs -d -f -i %d %(direcotry)s/classifier.pickle %(directory)s/iso639_test2.tab %(directory)s/iso639_test2.classified' % dir_dict)
        print "--EVALUATING TEST--"
        sys.stdout.flush()
        os.system('python %(directory)s/utilities/iso639_evaluator.py iso639_test2.gs iso639_test2.classified' % dir_dict)
        print "--CLASSIFYING OLAC DISPLAY--"
        sys.stdout.flush()
        os.system('python %(directory)s/iso639Classifier.py -g $(directory)s/test_data/olac_display_subset2.gs -d -f -i %d %(directory)s/classifier.pickle %(directory)s/test_data/olac_display_subset2.xml %(directory)s/test_data/olac_display_subset2.classified' % i)
        print "--EVALUATING OLAC DISPLAY--"
        sys.stdout.flush()
        os.system('python %(directory)s/utilities/iso639_evaluator.py %(directory)s/test_data/olac_display_subset2.gs %(directory)s/test_data/olac_display_subset2.classified')
        print "\n--------------------------------------------------------------------\n"
else:
    print "--TRAINING--"
    sys.stdout.flush()
    os.system('python %(directory)s/iso639_trainer.py -f %(directory)s/preprocessor/training_data.tab %(directory)s/classifier.pickle'%dir_dict)
    print "--CLASSIFYING TEST--"
    sys.stdout.flush()
    os.system('python %(directory)s/iso639Classifier.py -g %(directory)s/test_data/iso639_test2.gs -d -f %(directory)s/classifier.pickle %(directory)s/test_data/iso639_test2.tab %(directory)s/test_data/iso639_test2.classified'%dir_dict)
    print "--EVALUATING TEST--"
    sys.stdout.flush()
    os.system('python %(directory)s/utilities/iso639_evaluator.py %(directory)s/test_data/iso639_test2.gs %(directory)s/test_data/iso639_test2.classified'%dir_dict)
    print "--CLASSIFYING OLAC DISPLAY--"
    sys.stdout.flush()
    os.system('python %(directory)s/iso639Classifier.py -g %(directory)s/test_data/olac_display_subset2.gs -d -f %(directory)s/classifier.pickle %(directory)s/test_data/olac_display_subset2.xml %(directory)s/test_data/olac_display_subset2.classified'%dir_dict)
    print "--EVALUATING OLAC DISPLAY--"
    sys.stdout.flush()
    os.system('python %(directory)s/utilities/iso639_evaluator.py %(directory)s/test_data/olac_display_subset2.gs %(directory)s/test_data/olac_display_subset2.classified'%dir_dict)
