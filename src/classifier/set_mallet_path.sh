#!/bin/bash
# Sets Java CLASSPATH to include MALLET class and src directories, as well as
# two jar files that the Resource Type Classifier is dependent on.  Please set
# variable MALLET_PATH to path to MALLET directory.
#MALLET_PATH=/usr/share/mallet-2.0-RC4
MALLET_PATH=/usr/share/mallet-2.0.5
export PATH=${PATH}:${MALLET_PATH}/bin
export CLASSPATH=.:${MALLET_PATH}/src:${MALLET_PATH}/class:${MALLET_PATH}/lib/trove-2.0.2.jar:${MALLET_PATH}/lib/bsh.jar
