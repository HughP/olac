#!/bin/bash

EXPECTED_ARGS=3
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` data-directory mallet-vectors classifier"
    exit $E_BADARGS
fi

./set_mallet_path.sh
python malletize.py $1 $2
mallet train-classifier --input $2 --output-classifier $3 --trainer MaxEnt
