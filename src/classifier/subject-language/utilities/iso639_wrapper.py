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

dir_dict = {"directory":basedir}

print "--TRAINING--"
sys.stdout.flush()
os.system('python %(directory)s/iso639_trainer.py -s %(directory)s/stoplist.txt -f %(directory)s/subjectlanguagedata %(directory)s/classifier.pickle'%dir_dict)
print "--CLASSIFYING TEST--"
sys.stdout.flush()
os.system('python %(directory)s/iso639Classifier.py -g %(directory)s/test_data/iso639_test2.gs -d -f %(directory)s/classifier.pickle %(directory)s/test_data/iso639_test2.tab %(directory)s/test_data/iso639_test2.classified'%dir_dict)
print "--EVALUATING TEST--"
sys.stdout.flush()
os.system('python %(directory)s/utilities/iso639_evaluator.py %(directory)s/test_data/iso639_test2.gs %(directory)s/test_data/iso639_test2.classified'%dir_dict)
#print "--CLASSIFYING OLAC DISPLAY--"
#sys.stdout.flush()
#os.system('python %(directory)s/iso639Classifier.py -g %(directory)s/test_data/olac_display_subset2.gs -d -f %(directory)s/classifier.pickle %(directory)s/test_data/olac_display_subset2.xml %(directory)s/test_data/olac_display_subset2.classified'%dir_dict)
#print "--EVALUATING OLAC DISPLAY--"
#sys.stdout.flush()
#os.system('python %(directory)s/utilities/iso639_evaluator.py %(directory)s/test_data/olac_display_subset2.gs %(directory)s/test_data/olac_display_subset2.classified'%dir_dict)
