# setup temp files
P=/usr/share/olac/olac/src/sandbox/oai-harvester-classifier
TMPA=$P/restype.outA.tmp # raw source data
TMP0=$P/restype.out0.tmp # clean source data
TMP1=$P/restype.out1.tmp # binary classifier input
TMP2=$P/restype.out2.tmp # binary classifier output
TMP3=$P/restype.out3.tmp # type classifier input
TMP4=$P/restype.out4.tmp # type classifier output
TMP5=$P/restype.out5.tmp # SQL import
SQLTMP=$P/restype.tmp.sql # SQL temporary file

# export oai data
#echo Exporting oai data to be classified...
#time ./resource_type_extract.sh 36 > $TMPA 
#time ./resource_type_extract.sh all > $TMPA 

# clean up non-UTF-8 characters
echo Scrubbing non-UTF-8 data
time ./unicode_scrub.py $TMPA $TMP0

# remove carriage-return (\r or CR or 0x0D)
echo Cleaning out carriage returns...
time tr -d '\r' < $TMP0 > $TMP1

# delete existing enrichments that will be updated
echo Removing existing enrichments for items that will be updated...
for id in `cut -f1 $TMP1`; do
    if [ $id == "Item_ID" ]; then
        continue
    fi
# while we're debugging, don't do this step, this allows us to see all previous classification attempts
    echo "delete from METADATA_ELEM WHERE TagName = 'type' and Item_ID = $id;" >> $SQLTMP ;
    echo "update ARCHIVED_ITEM SET TypeClassifiedDate = NOW() WHERE Item_ID = $id;" >> $SQLTMP ;
done
mysql --defaults-file=~/oai.my.cnf < $SQLTMP

echo Running binary classifier...
cd classifier
# run binary type classifier on oai data; output to $TMP2
#time ./restype_test.sh resourceTypeBinaryClassifier.mallet $TMP1 $TMP2
time ./classify.sh binary $TMP1 $TMP2
cd ..

echo Importing binary classifier probabilities
time ./import-binary-classified.py $TMP2

echo Preparing for multi-type classifier...
time python prep_binary_for_multi.py $TMP1 $TMP2 $TMP3

echo Running multi-type classifier...
cd classifier
# run muli-type classifier on YES lang resources
#CLASSIFIERCOMMENT='original resourceTypeClassifier.mallet'
CLASSIFIERCOMMENT='classifier 20100714'
#./restype_test.sh resourceTypeClassifier.mallet $TMP3 $TMP4
#time ./restype_test.sh resourceTypeMultiClassifier.mallet $TMP3 $TMP4
time ./classify.sh multi $TMP3 $TMP4
cd ..

echo Preparing enrichments for import...
# create mysql data infile
# format(tab-delim): Item_ID Code TagName Tag_ID Content Extension_ID Type
cat $TMP4 |cut -d":" -f1 |awk '{print $1 "\t" $2 "\ttype\t1500\tCLASSIFIERCOMMENT\t15\tresource-type" }'|sed -e "s/CLASSIFIERCOMMENT/$CLASSIFIERCOMMENT/" > $TMP5

# update HasOLACType for each item
rm $SQLTMP
for id in `cat $TMP4 |cut -d":" -f1|cut -f1`; do
    echo "update ARCHIVED_ITEM SET HasOLACType = 1 WHERE Item_ID = $id;" >> $SQLTMP ;
done
mysql --defaults-file=~/oai.my.cnf < $SQLTMP

echo Importing enrichments...
# load into mysql
time mysql --defaults-file=~/oai.my.cnf -e "
LOAD DATA LOCAL INFILE '$TMP5'
INTO TABLE METADATA_ELEM
FIELDS TERMINATED BY '\\t'
LINES TERMINATED BY '\\n'
(Item_ID, Code, TagName, Tag_ID, Content, Extension_ID, Type);"
# fields to import:
# Item_ID = [the item id]
# Code = [the type name e.g. lexicon]
# TagName = type
# Tag_ID = 1500
# Content = ''
# Extension_ID = 15
# Type = linguistic-type (or more accurately) resource-type

# clean up tmp files
#rm $TMP1
#rm $TMP2
#rm $TMP3
#rm $TMP4
#rm $TMP5
#rm $SQLTMP
