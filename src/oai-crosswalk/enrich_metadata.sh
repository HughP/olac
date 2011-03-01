# setup temp files
P=/usr/share/olac/olac/src/oai-crosswalk
RAW=$P/output/data0-raw.tmp           # raw source data
CLEAN=$P/output/data1-clean.tmp       # clean source data -- binary classifier input
BINOUT=$P/output/data2-binout.tmp     # binary classifier output
BIN2CULL=$P/output/data3-bin2cull.tmp # cull data to prep for multi
BIN2TYPE=$P/output/data4-bin2type.tmp # type classifier input
TYPEOUT=$P/output/data5-typeout.tmp   # type classifier output
# These don't take a full path
BIN2LANG=../../oai-crosswalk/output/data4-bin2type.tmp    # language classifier input
LANGOUT=../../oai-crosswalk/output/data6-langout.tmp      # subject language identifier output
LANGSAVE=$P/output/data6-langout.tmp      # subject language identifier output

UTF8CONDITIONER=/usr/share/olac/olac/nonweb/pkg/Utf8Conditioner/1.15-olac/bin/utf8conditioner_unbuffered_stdout

# "select distinct Archive_ID from ARCHIVED_ITEM"
NUM_ARCHIVES=487
#for ARCHIVE in `seq 1 $NUM_ARCHIVES`;
#ARCHIVE_LIST=( 4 5 85 96 108 244 99 142 )
ARCHIVE_LIST=( 4 5 85 )
for ARCHIVE in "${ARCHIVE_LIST[@]}";
do
   echo "Processing archive $ARCHIVE"

   echo Resetting archive $ARCHIVE for enrichment
   #time ./reset_for_type_enrichment.py $ARCHIVE
   time ./remove_type_enrichments.py $ARCHIVE

   # export oai data
   echo Exporting archive $ARCHIVE oai data to be classified...
   time ./resource_type_extract.sh $ARCHIVE > $RAW 

   # clean up non-UTF-8 characters, carriage-return (\r or CR or 0x0D)
   echo Scrubbing non-UTF-8 data
   time ./unicode_scrub.py $RAW $CLEAN
   #time $UTF8CONDITIONER -q < $RAW | tr -d '\r' > $CLEAN

   echo Running binary classifier...
   cd ../classifier/resource-type
   # run binary type classifier on oai data
   time ./classify.sh binary $CLEAN $BINOUT
   cd ../../oai-crosswalk

   echo Importing binary classifier probabilities
   time ./import-binary-classified.py $BINOUT $BIN2CULL

   echo Preparing for multi-type classifier...
   time ./cull_for_multi.py $CLEAN $BIN2CULL $BIN2TYPE

   echo Running multi-type classifier...
   cd ../classifier/resource-type
   # run multi-type classifier on YES lang resources
   time ./classify.sh multi $BIN2TYPE $TYPEOUT
   cd ../../oai-crosswalk

   echo Importing type classifier results
   time ./import-type-classified.py $TYPEOUT
   
   echo Running subject langauge identifier...
   cd ../classifier/subject-language
   THRESHOLD=0.6
   time ./classify.py -f -d -t $THRESHOLD ./SubjectLang.pickle $BIN2LANG $LANGOUT
   cd ../../oai-crosswalk
   
   cp $LANGSAVE output/$ARCHIVE-langout.tmp
done
echo Tetelestai!

# clean up tmp files
#rm $RAW
#rm $CLEAN
#rm $BINOUT
#rm $BIN2CULL
#rm $BIN2TYPE
#rm $TYPEOUT


