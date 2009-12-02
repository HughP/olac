#!/bin/bash
# restype_test.sh
# Aug 28, 2009
# Joshua S Hou
#
# Test stage of resource type classifier
#
# Usage: ./restype_test.sh classifier input-document output

EXPECTED_ARGS=3
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` classifier input-document output"
    echo "  input-document must be in plaintext format:"
    echo "  [name]\t[label]\t[data]"
    exit $E_BADARGS
fi

# set path and java classpath environment variables for mallet
source set_mallet_path.sh

# ensure compiled version of ResourceTypeClassify exists
if [ ! -e "ResourceTypeClassify.class" ]
then
    echo "No binary for ResourceTypeClassify found."
    echo "Compiling..."
    javac ResourceTypeClassify.java
fi

echo "Classifying..."
java ResourceTypeClassify $1 $2 $3
