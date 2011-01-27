#!/bin/bash

DATE=`date +%Y%m%d`
LOG_FILE=output/classifyrun-$DATE.log

./enrich_metadata.sh > $LOG_FILE 2>&1 &

