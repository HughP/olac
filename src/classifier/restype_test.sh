#!/bin/bash
EXPECTED_ARGS=3
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` classifier input-vectors output"
    echo "input-vectors must be in plaintext format:"
    echo "[name]\t[label]\t[data]"
    exit $E_BADARGS
fi

# set path and java classpath environment variables for mallet
source set_mallet_path.sh

# ensure compiled version of ResourceTypeClassify exists
if [ ! -e "ResourceTypeClassify.class" ]
then
    javac ResourceTypeClassify.java
fi

java ResourceTypeClassify $1 $2 $3
