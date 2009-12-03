#!/bin/bash
for x in `ls /home/simonsg/Documents/Abbreviated_DC/*.xml`; do
python prep_type_xml.py $x
done
