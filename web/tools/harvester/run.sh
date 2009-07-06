#! /bin/sh


#######################################
#       configuration variables       #
# (edit them to fit your environment) #
#######################################

# harvest log
HARVEST_LOG=harvest_log.txt

# mysql db account info file
MYCNF=/home/olac/.my.cnf.olac2

# mysql
MYSQL=/ldc/app/i386/pkg/mysql-5.0.22/bin/mysql

# ovester directory
case `dirname $0` in
    /*) ODIR=`dirname $0` ;;
    *)  ODIR=`pwd`/`dirname $0` ;;
esac

PYTHON=/ldc/bin/python2.4
PYMODS=/web/language-archives/lib/python
PYTHONPATH=$PYMODS
export PYTHONPATH

# admin email address
ADMIN_EMAIL="olac-admin@language-archives.org haejoong@ldc.upenn.edu"
#ADMIN_EMAIL="sb@csse.unimelb.edu.au Gary_Simons@sil.org haejoong@ldc.upenn.edu"

# which php?
PHP=/pkg/ldc/freebsd/pkg/php-5.0.3/bin/php

# xml dump directory
XMLDUMPDIR=/web/language-archives/xmldump

# static record pages directory
SRECDIR=/ldc/web/language-archives/static-records

#########################
# DO NOT EDIT FROM HERE #
#########################

TMP_LOG=${HARVEST_LOG}-tmp
CWD=`pwd`; cd $ODIR

(
	echo
	echo
	echo "** `date`"
	echo
	if [ "$1" = "MONTHLY" ]; then
		echo 'Do monthly full harvest first.'
		echo
		$PYTHON $ODIR/monthly_harvester.py -c $MYCNF -t olac 2>&1
		echo
		echo 'Now regular incremental harvest.'
		echo
	fi
	$PYTHON $ODIR/harvester.py -c $MYCNF -u 2>&1
	$PYTHON $ODIR/cleanup.py -c $MYCNF
	/usr/bin/lockf /tmp/olac.integrity.lock $PYTHON $ODIR/integrity.py -c $MYCNF
	/usr/bin/lockf /tmp/olac.metrics.lock $PYTHON $ODIR/compute_olac_metrics.py -c $MYCNF
) | /usr/bin/tee $TMP_LOG >> $HARVEST_LOG

new_records=`grep -e "updated records:" -e "new records:" $TMP_LOG | awk '{sum+=$5} END {print sum}'`
if [ ${new_records:-0} -gt 0 -o "$1" = "MONTHLY" -o -f dirty] ; then
    (
        echo
        echo "Copying METADATA_ELEM to METADATA_ELEM_MYISAM ..."
        echo
        echo "delete from METADATA_ELEM_MYISAM" | $MYSQL --defaults-file=$MYCNF
        echo "insert into METADATA_ELEM_MYISAM select * from METADATA_ELEM" | $MYSQL --defaults-file=$MYCNF

        (
        echo
	echo "Updating search database..."
	echo
        cd ../../tools/reports/lib
	#echo "  - Updating tag usage table..."
        #$PHP createTagUsageTable.php
	echo "  - Updating soundex table..."
	$PHP createSoundexTable.php
	#echo "  - Updating item scores table..."
	#$PHP createItemScoresTable.php
	#cd ..
	#echo "  - Generating report..."
	#$PHP generateReports.php
	)

        echo
        echo "Creating an XML dump and static record pages..."
        echo
        dumpnam=$XMLDUMPDIR/ListRecords-`date +%Y%m%d-%H%M%S`.xml.gz
	PATH=/ldc/app/i386/pkg/sqlite-3.3.5/bin:/ldc/app/i386/pkg/mysql-5.0.22/bin:$PATH ./olacaxmldump.py $MYCNF $dumpnam $SRECDIR 2>/dev/null
        ln -sf $dumpnam $XMLDUMPDIR/ListRecords.xml.gz
	(
	cd $SRECDIR
	find . -name "*.xml" | sort | sed -E -e 's@^./(.*)@<li><a href="./\1">\1</a>@' > index.html
	)

        rm -f dirty

    ) | /usr/bin/tee -a $TMP_LOG >> $HARVEST_LOG
fi


######## BEGIN: ISO 630 report generation ########
#(
#	echo
#	echo "Generating ISO 639 conversion report..."
#	for u in `/usr/local/bin/curl "http://www.language-archives.org/register/archive_list.php4" 2> /dev/null | grep baseURL |sed -E -e 's/.*baseURL="//' -e 's/".*//'` ; do
#		echo $u
#		u2=`echo $u | sed -E -e 's#http://#http://www.language-archives.org/tools/eth15filter/gen_report.php/#' -e 's#$#?verb=ListRecords\&metadataPrefix=olac#'`
#		/usr/local/bin/curl "$u2" > /dev/null 2>&1
#	done
#	echo
#) | /usr/bin/tee -a $TMP_LOG >> $HARVEST_LOG
######## END: ISO 630 report generation ########


cat $TMP_LOG | /usr/bin/mail -s "OLAC Harvester Log: `date +\"%b %e, %Y\"`" $ADMIN_EMAIL

rm -f $TMP_LOG

cd $CWD

