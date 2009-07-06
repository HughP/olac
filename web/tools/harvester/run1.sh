#! /bin/sh

# mysql db account info file
MYCNF=/home/olac/.my.cnf.olac2

# mysql
MYSQL=/ldc/app/i386/pkg/mysql-5.0.22/bin/mysql

# harvester directory
case `dirname $0` in
    /*) base=`dirname $0` ;;
    *)  base=`pwd`/`dirname $0` ;;
esac

PYTHON=/ldc/bin/python2.4
PYMODS=/web/language-archives/lib/python
PYTHONPATH=$PYMODS
export PYTHONPATH

TMP_LOG=/tmp/harvest.log-$$

opt=
if [ -z "$1" ]; then
    echo "specify a url to harvest"
    exit 1
elif [ "$1" = "-s" ]; then
    opt="--static"
    if [ -z "$2" ]; then
        echo "specify a url to harvest"
        exit 1
    else
        url=$2
    fi
else
    url=$1
fi

$PYTHON $base/harvester.py -c $MYCNF -u -s "$url" $opt 2>&1 | /usr/bin/tee $TMP_LOG

new_records=`grep -e "updated records:" -e "new records:" $TMP_LOG | awk '{sum+=$5} END {print sum}'`
[ ${new_records:-0} -gt 0 ] && touch dirty

rm -f $TMP_LOG


