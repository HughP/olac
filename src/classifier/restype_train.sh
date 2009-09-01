#!/bin/bash
# restype_train.sh
# Aug 28, 2009
# Joshua S Hou
#
# Trains a mallet classifier from a directory of tab-delimited files of training
# data.  Saves mallet classifier and mallet binary vectors to file.
#
# Usage: ./restype_train data-directory mallet-vectors classifier

EXPECTED_ARGS=3
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` data-directory mallet-vectors classifier"
    exit $E_BADARGS
fi

source set_mallet_path.sh
echo "Reading corpus and converting to feature vectors..."
cat $1/*.txt > $1/training-vectors
mallet import-file --input $1/training-vectors --output $2 --remove-stopwords --line-regex "^(\\S*)[\\s]*(\\S*)[\\s]*(.*)$"
echo "Training classifier..."
mallet train-classifier --input $2 --output-classifier $3 --trainer MaxEnt
