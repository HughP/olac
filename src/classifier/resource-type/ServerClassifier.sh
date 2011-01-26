#!/bin/bash

# ServerClassify.sh
# Aug 28, 2009
# Joshua S Hou
# mod by Sven Pedersen for Classification "server"
# 
# Test stage of resource type classifier
# 
# Usage: ./ServerClassify.sh input-document output

EXPECTED_ARGS=2
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` input-document output"
    echo "  input-document must be in plaintext format:"
    echo "  [name]\t[label]\t[data]"
    exit $E_BADARGS
fi

# set path and java classpath environment variables for mallet
source set_mallet_path.sh

# ensure compiled version of ResourceTypeClassify exists
if [ ! -e "ResourceTypeClassifierServer.class" ]
then
    echo "No binary for ResourceTypeClassifierServer found."
    echo "Compiling..."
    javac ResourceTypeClassifierServer.java
fi

#classifier=$1
input_file=$1
output_file=$2
process="MalletClassifierInputFile.tmp"
output="MalletClassifierOutputFile.tmp"
classifierFile="resourceTypeBinaryClassifier.mallet"

echo "Classifying..."
# create link to process input file
ln $input_file $process
#RESULT=$(java ResourceTypeClassifierServer $classifier)


# loop until the output file appears
until [ -f $output ]; do
	sleep 6
done
# create link to access output file
ln $output $output_file
echo "Finished."

