#! /bin/sh
#
# commain line option
# $1 : 'e' or ''  (preerase. use only for full harvesting)

#######################################
#       confituration variables       #
# (edit them to fit your environment) #
#######################################

# harvest log
HARVEST_LOG=harvest_log.txt

# error log
ERROR_LOG=error_log.txt

# mysql db account info file
DBINFO=/home/olac/.ovester_dbinfo_olac

# ovester directory
ODIR=/mnt/unagi/speechd8/ldc/wwwhome/htdocs/language-archives/tools/harvester

# Hussein's harvester location
VTHDIR=$ODIR

# perl module location
PERL5LIB=/mnt/unagi/speechd8/ldc/wwwhome/htdocs/language-archives/lib/site-perl

# which perl to use
PERL=/pkg/p/perl5.6.0/bin/perl

# admin email address
ADMIN_EMAIL="olac-admin@language-archives.org haejoong@ldc.upenn.edu"


#########################
# DO NOT EDIT FROM HERE #
#########################

TMP_ERROR_LOG=${ERROR_LOG}-tmp
OVESTER="$PERL -I $ODIR:$PERL5LIB:$VTHDIR ovester.pl -$1pd $DBINFO"
CWD=`pwd`; cd $ODIR

echo >> $HARVEST_LOG
echo >> $HARVEST_LOG
echo '**' `date` >> $HARVEST_LOG
echo >> $HARVEST_LOG

echo >> $TMP_ERROR_LOG
echo >> $TMP_ERROR_LOG
echo '**' `date` >> $TMP_ERROR_LOG
echo >> $TMP_ERROR_LOG

$OVESTER 1>> $HARVEST_LOG 2>> $TMP_ERROR_LOG

( echo "Subject:ovester error log (`date +\"%b %e, %Y\"`)" ;
  cat $TMP_ERROR_LOG ) | /usr/bin/mail $ADMIN_EMAIL

cat $TMP_ERROR_LOG >> $ERROR_LOG

rm -f $TMP_ERROR_LOG

cd $CWD

