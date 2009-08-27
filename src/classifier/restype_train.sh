#!/bin/bash

EXPECTED_ARGS=3
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` data-directory mallet-vectors classifier"
    exit $E_BADARGS
fi

export PATH=${PATH}:/usr/share/mallet-2.0-RC4/bin
export CLASSPATH=.:/usr/share/mallet-2.0-RC4/src:/usr/share/mallet-2.0-RC4/class:/usr/share/mallet-2.0-RC4/lib/trove-2.0.2.jar:/usr/share/mallet-2.0-RC4/lib/bsh.jar

python malletize.py $1 $2
mallet train-classifier --input $2 --output-classifier $3 --trainer MaxEnt
