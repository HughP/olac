# setup temp files
P=/usr/share/olac/olac/src/sandbox/oai-harvester-classifier
TMP1=$P/restype.out1.tmp # binary classifier input
TMP2=$P/restype.out2.tmp # binary classifier output
TMP3=$P/restype.out3.tmp # type classifier input
TMP4=$P/restype.out4.tmp # type classifier output
TMP5=$P/restype.out5.tmp # SQL import
SQLTMP=$P/restype.tmp.sql # SQL temporary file

# export oai data
echo Exporting oai data to be classified...
./resource_type_extract.sh 1 > $TMP1 
#./resource_type_extract.sh all > $TMP1 

# delete existing enrichments that will be updated
echo Removing existing enrichments for items that will be updated...
for id in `cut -f1 $TMP1`; do
    if [ $id == "Item_ID" ]; then
        continue
    fi
# while we're debugging, don't do this step, this allows us to see all previous classification attempts
#    echo "delete from METADATA_ELEM WHERE TagName = 'type' and Item_ID = $id;" >> $SQLTMP ;
    echo "update ARCHIVED_ITEM SET TypeClassifiedDate = NOW() WHERE Item_ID = $id;" >> $SQLTMP ;
done
mysql --defaults-file=~/oai.my.cnf < $SQLTMP

echo Running binary classifier...
cd classifier
# run binary type classifier on oai data; output to $TMP2
./restype_test.sh resourceTypeBinaryClassifier.mallet $TMP1 $TMP2
cd ..

echo Preparing for multi-type classifier...
python prep_binary_for_multi.py $TMP1 $TMP2 $TMP3

echo Running multi-type classifier...
cd classifier
# run muli-type classifier on YES lang resources
#CLASSIFIERCOMMENT='original resourceTypeClassifier.mallet'
CLASSIFIERCOMMENT='multi_m-1 classifier 20100113'
#./restype_test.sh resourceTypeClassifier.mallet $TMP3 $TMP4
./restype_test.sh resourceTypeMultiClassifier.mallet $TMP3 $TMP4
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
mysql --defaults-file=~/oai.my.cnf -e "
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
rm $TMP1
rm $TMP2
rm $TMP3
#rm $TMP4
rm $TMP5
rm $SQLTMP
