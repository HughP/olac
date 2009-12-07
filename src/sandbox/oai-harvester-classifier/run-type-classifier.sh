# setup temp files
TMP1=restype.out1.tmp
TMP2=restype.out2.tmp
TMP3=restype.out3.tmp
TMP4=restype.out4.tmp
TMP5=restype.out5.tmp

# export oai data
echo Exporting oai data to be classified...
mysql < resource_type_extract_single_archive.sql > $TMP1 
#mysql < resource_type_extract_all.sql > $TMP1 

echo Running binary classifier...
# run binary type classifier on oai data; output to $TMP2
# TODO: how do you do this???
classifier/restype_test.sh $TMP1 $TMP2

# grep for only YES lines
# removing the YES with sed may be optional - check this
grep "\tYES" $TMP2 |sed -e 's/\tYES/\t/' > $TMP3

echo Running multi-type classifier...
# run muli-type classifier on YES lang resources
# TODO: how do you do this???
classifier/restype_test.sh $TMP3 $TMP4

echo Preparing enrichments for import...
# create mysql data infile
# format(tab-delim): Item_ID Code TagName Tag_ID Content Extension_ID Type
awk '{print $1 "\t" $2 "\ttype\t1500\t\t15\tresource-type" }' $TMP4 > $TMP5

echo Importing enrichments...
# load into mysql
mysql -e "
LOAD DATA LOCAL INFILE '$TMP5'
INTO TABLE METADATA_ELEM
FIELDS TERMINATED BY '\\t'
LINES TERMINATED BY '\\n'
(Item_ID, Code, TagName, Tag_ID, Content, Extension_ID, Type);" olac
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
