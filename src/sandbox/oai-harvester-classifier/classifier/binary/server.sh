#!/bin/bash

# server.sh
# Apr 28, 2010
# Sven Pedersen for Classification "server"
# 
# Test stage of resource type classifier
# 
# Usage: ./server.sh

EXPECTED_ARGS=0
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0`"
    echo "  input-document must be in plaintext format:"
    echo "  [name]\t[label]\t[data]"
    exit $E_BADARGS
fi

# set path and java classpath environment variables for mallet
source ../set_mallet_path.sh

# ensure compiled version of ResourceTypeClassify exists
if [ ! -e "ResourceTypeClassifierServer.class" ]
then
    echo "No binary for ResourceTypeClassifierServer found."
    echo "Compiling..."
    cp ../ResourceTypeClassifierServer.java .
    javac ResourceTypeClassifierServer.java
fi

process="MalletClassifierInputFile.tmp"
output="MalletClassifierOutputFile.tmp"
classifierFile="resourceTypeBinaryClassifier.mallet"

echo "Starting classifier server..."
#RESULT=$(java ResourceTypeClassifierServer $classifierFile)
java -Xms18m -Xmx128m ResourceTypeClassifierServer $classifierFile &


