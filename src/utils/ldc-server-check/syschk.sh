#! /bin/sh

webroot=/web/org/language-archives
base=/home/olac/bin
dat=$base/syschk.dat
dat_xsv_html=$base/syschk.dat.xsv_html
dat_xercesj=$base/syschk.dat.xercesj
tmp=/tmp/olac.syschk.tmp.$$
PS="/bin/ps awx"

[ -f $dat ] && . $dat
grep -v '^_OLACSEARCH_' $dat > $dat.copy
mv -f $dat.copy $dat && chmod g+w $dat

SCRIPT_ACCESSLOG_CRON="$base/access_log-cron.sh"
HTTPD_ACCESS_LOG=`grep '^LOG=' $SCRIPT_ACCESSLOG_CRON | sed 's/^LOG=//'`

CHKSUM_PHP="/usr/local/libexec/apache/libphp5.so"
CHKSUM_PERL="/usr/bin/perl"
CHKSUM_JAVA="/usr/local/bin/java"
CHKSUM_JBOSS_JAVA=`$PS | grep jboss | grep java | grep -v grep | awk '{print $5}' | head -1`
CHKSUM_JBOSS=`$PS | grep jboss | grep java | grep -v grep | sed -E 's@.*[ :]([^:]*run\.jar)[ :].*@\1@' | head -1`
CHKSUM_XALAN="/mnt/unagi/speechd8/ldc/wwwhome/olac/xalan-J/bin/xalan.jar"
CHKSUM_XERCESJ="/mnt/unagi/speechd8/ldc/wwwhome/olac/xerces-J/xml-apis.jar"
CHKSUM_PYTHON="/usr/local/bin/python2.3"
CHKSUM_XSV1="/mnt/unagi/speechd8/ldc/wwwhome/olac/xsv/lib/python2.3/site-packages/XSV/commandLine.py"
CHKSUM_XSV2="/mnt/unagi/speechd8/ldc/wwwhome/olac/xsv/lib/python2.3/site-packages/XSV/driver.py"

#CHKSUM2_DCXMLS="http://dublincore.org/schemas/xmls/"
CHKSUM2_DC="http://dublincore.org/schemas/xmls/qdc/2006/01/06/dc.xsd"
CHKSUM2_DCTERMS="http://dublincore.org/schemas/xmls/qdc/2006/01/06/dcterms.xsd"
CHKSUM2_DCMITYPE="http://dublincore.org/schemas/xmls/qdc/2006/01/06/dcmitype.xsd"
CHKSUM2_SIMPLEDC="http://dublincore.org/schemas/xmls/qdc/2006/01/06/simpledc.xsd"
CHKSUM2_QUALIFIEDDC="http://dublincore.org/schemas/xmls/qdc/2006/01/06/qualifieddc.xsd"
CHKSUM2_OLACDC="http://www.language-archives.org/OLAC/1.0/dc.xsd"
CHKSUM2_OLACDCTERMS="http://www.language-archives.org/OLAC/1.0/dcterms.xsd"
CHKSUM2_OLAC="http://www.language-archives.org/OLAC/1.0/olac.xsd"
CHKSUM2_OLAC_EXTENSION="http://www.language-archives.org/OLAC/1.0/olac-extension.xsd"

RESULT=SUCCESS

##
## httpd
##
echo "Checking httpd ... "
echo

# get pid of the leader
printf "  * Get pid: "
pid_httpd=`$PS -o comm,pid,ppid | grep httpd | egrep '\b1$' | awk '{print $2}'`
if [ -n "$pid_httpd" ] ; then
    echo "OK ($pid_httpd)"
    #echo
    #$PS -p $pid_httpd -o pid,stat,%cpu,%mem,lstart
    #ecjp
else
    echo "Fail"
    RESULT=FAIL
fi

printf "  * Fetch l-a.org index page: "
# fetch header only
line=`curl -sI "http://www.language-archives.org/" | head -1`
if [ -n "$line" ] ; then
    ret=`echo $line | awk '{print $2}'`
    if [ "$ret" = "200" ] ; then
	echo "OK"
    else
	echo "Fail"
	RESULT=FAIL
    fi
    #echo
    #echo $line
    #echo
else
    echo "Fail"
    RESULT=FAIL
fi
echo


##
## mysql
##
echo "Checking mysql ..."
echo

# mysql is on brown
# its not so simple to have a remote process information

printf "  * Get number of archives: "
mysql="mysql --defaults-file=/home/olac/.my.cnf.olac2"
q1="select count(*) from OLAC_ARCHIVE"
q2="select count(*) from ARCHIVED_ITEM"
narc=`echo $q1 | $mysql | sed 1d`
if [ "$narc" -gt 0 ] ; then
    echo $narc
else
    echo "Fail"
    RESULT=FAIL
fi

printf "  * Get number of archived items: "
nitm=`echo $q2 | $mysql | sed 1d`
if [ "$nitm" -gt 0 ] ; then
    echo $nitm
else
    echo "Fail"
    RESULT=FAIL
fi
echo

##
## sendmail (actually postfix)
##

echo "Checking sendmail ..."
echo

## get pid of "master"

# note that i'm not familiar with postfix
# it seems that "master" is the deamon that takes send requests
printf "  * Get pid of postfix/master: "
pid_master=`$PS -o comm,pid | grep '^master' | grep -v grep | awk '{print $2}'`
if [ -n "$pid_master" ] ; then
    echo "OK ($pid_master)"
else
    echo "Fail"
    RESULT=FAIL
fi

# send HELO and QUIT commands to the smtp server
printf "  * helo&quit test: "
$base/syschk.smtp.exp > /dev/null 2>&1
if [ $? -eq 0 ] ; then
    echo "OK"
else
    echo "Fail"
    RESULT=FAIL
fi
echo



##
## logfile cycling
##
echo "Check http access log cycling ..."
echo

## get path
printf "  * current access log is active: "

# last log line
a=`cat $HTTPD_ACCESS_LOG | grep www.language-archives.org | tail -1`
#a=`tail $HTTPD_ACCESS_LOG | grep www.language-archives.org | grep '/tools/search/' | grep -m 1 'query=' | tail -1`
#a=`tail -1 $HTTPD_ACCESS_LOG`
# date
b=`echo $a | awk '{print $5,$6}'`
echo "_OLACSEARCH_LAST_ACCESS='$b'" >>$dat
if [ -z "$b" -o "$b" = "$_OLACSEARCH_LAST_ACCESS" ] ; then
    _OLACSEARCH_MATCH_COUNT=`expr $_OLACSEARCH_MATCH_COUNT + 1`
else
    _OLACSEARCH_MATCH_COUNT=0
fi
if [ $_OLACSEARCH_MATCH_COUNT -lt 24 ] ; then
    echo "OK"
else
    echo "Fail"
    RESULT=FAIL
fi
echo "_OLACSEARCH_MATCH_COUNT=$_OLACSEARCH_MATCH_COUNT" >>$dat
echo


##
## search/report alive?
##
echo "Checking OLAC Search/Report ... "
echo

URL_SEARCH="http://www.language-archives.org/tools/search/?query=hindi&archive=&page=1&webLangID=ENG"
URL_REPORT="http://www.language-archives.org/tools/reports/?archive=41"

printf "  * Query OLAC Search: "
# fetch header only
line=`curl -sI "$URL_SEARCH" | head -1`
if [ -n "$line" ] ; then
    ret=`echo $line | awk '{print $2}'`
    if [ "$ret" = "200" ] ; then
	echo "OK"
    else
	echo "Fail"
	RESULT=FAIL
    fi
else
    echo "Fail"
    RESULT=FAIL
fi
printf "  * Query OLAC Report: "
# fetch header only
line=`curl -sI "$URL_REPORT" | head -1`
if [ -n "$line" ] ; then
    ret=`echo $line | awk '{print $2}'`
    if [ "$ret" = "200" ] ; then
	echo "OK"
    else
	echo "Fail"
	RESULT=FAIL
    fi
else
    echo "Fail"
    RESULT=FAIL
fi
echo




##
## xsv run
##
echo "Checking XSV & XALAN ..."
echo
printf "  * Running /pkg/ldc/wwwhome/olac/bin/xsv_html: "
/pkg/ldc/wwwhome/olac/bin/xsv_html /web/language-archives/OLAC/1.0/static-repository.xml > $tmp 2> /dev/null
if [ -z "`diff $tmp $dat_xsv_html`" ] ; then
    echo "OK - got expected result"
else
    echo "Fail - unexpected output"
    RESULT=FAIL
fi
rm -f $tmp
echo "    (for this to be successful, xsv and xalan should work correctly)" 
echo

##
## xercesj run
##
echo "Checking Xerces-J ..."
echo
printf "  * Running /pkg/ldc/wwwhome/olac/bin/xercesj.syschk: "
/pkg/ldc/wwwhome/olac/bin/xercesj.syschk /web/language-archives/OLAC/1.0/static-repository.xml 2>&1 | sed -E 's/[0-9]+ ms//' > $tmp
if [ -z "`diff $tmp $dat_xercesj`" ] ; then
    echo "OK - got expected result"
else
    echo "Fail - unexpected result"
    RESULT=FAIL
fi
rm -f $tmp
echo

##
## disk space
##
echo "Checking disk space ..."
echo
printf "  * Have enought space? "
n=`df -k /web/language-archives | tail -1 | awk '{print $4}'`
if [ "$n" -ge 200000 ] ; then
    echo "OK - $n 1K-blocks available"
else
    echo "Fail - only $n 1K-blocks remaining"
    RESULT=FAIL
fi
echo

##
## symlinks
##
echo "Checking symbolic links ..."
echo
find $webroot -type l -exec ls -l \{} \; > $tmp 2> /dev/null
cat $tmp | $base/syschk.symlinks.py |
while read a ; do
    echo "  $a"
done | tee $tmp.2
echo
if [ -s $tmp.2 ] ; then
    echo "  Fail"
    RESULT=FAIL
else
    echo "  OK"
fi
rm -f $tmp $tmp.2
echo

##
## file permissions
##
echo "Checking file/directory permissions ..."
echo
dir=/web/language-archives/tools/search/logs/
printf "  * $dir "
if [ -r "$dir" -a -w "$dir" ] ; then
    echo "is read-/writable - OK"
else
    echo "is not read-/writable - Fail"
fi
echo


##
## md5 checksum
##
echo "Checking md5 checksum ..."
echo
for var in `set | grep '^CHKSUM_' | sed 's/=.*//' | sort` ; do
    path=`eval 'echo $'$var`
    printf "  * %20s: %s" `echo $var | sed s'/[^_]*._//'` $path
    md5old=`eval 'echo $MD5_'$var`
    md5val=`md5 $path | awk '{print $NF}'`
    if [ "$md5old" = "$md5val" ] ; then
	echo "    OK"
    else
	echo "    <font color=red>Fail</font>"
	RESULT=FAIL
    fi
    #echo "MD5_$var=\"$md5val\"" >>$dat
    #echo "MD5_$var=\"$md5old\"" >>$dat
done
for var in `set | grep '^CHKSUM2_' | sed 's/=.*//' | sort` ; do
    path=`eval 'echo $'$var`
    printf "  * %20s: %s" `echo $var | sed s'/[^_]*._//'` $path
    md5old=`eval 'echo $MD5_'$var`
    md5val=`curl -s "$path" | md5`
    if [ "$md5old" = "$md5val" ] ; then
	echo "    OK"
    else
	echo "    <font color=red>Fail</font>"
	RESULT=FAIL
    fi
    #echo "MD5_$var=\"$md5val\"" >>$dat
    #echo "MD5_$var=\"$md5old\"" >>$dat
done
echo


##
## return
##

if [ "$RESULT" = FAIL ] ; then
    echo "Test failed"
    exit 1
else
    echo "Test succeeded"
    exit 0
fi
