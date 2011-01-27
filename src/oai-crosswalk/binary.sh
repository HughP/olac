#!/bin/bash
CLEAN=/usr/share/olac/olac/src/oai-crosswalk/output/data1-clean.tmp
BINOUT=/usr/share/olac/olac/src/oai-crosswalk/output/data2-binout.tmp
BIN2CULL=/usr/share/olac/olac/src/oai-crosswalk/output/data3-bin2cull.tmp
BIN2TYPE=/usr/share/olac/olac/src/oai-crosswalk/output/data4-bin2type.tmp

   echo Running binary classifier...
   cd ../classifier/resource-type
   # run binary type classifier on oai data
   #time ./classify.sh binary $CLEAN $BINOUT
   cd ../../oai-crosswalk

   echo Importing binary classifier probabilities
   #time ./import-binary-classified.py $BINOUT $BIN2CULL

   echo Preparing for multi-type classifier...
   time ./cull_for_multi.py $CLEAN $BIN2CULL $BIN2TYPE
