#!/bin/bash
# subjlang_train.sh
# Sept 14, 2009
# Gary Simons
#
# Trains the subject language classifier from a directory of 
# tab-delimited files of training data and saves a pickle
# of the trained classifier to the test folder.
#
# Usage: ./subjlang_train

EXPECTED_ARGS=0
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0`"
    exit $E_BADARGS
fi

echo "Training classifier..."

python iso639_trainer.py -f -s stoplist.txt subjectlanguagedata test/SubjectLang.pickle
