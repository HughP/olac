#! /bin/sh

case $0 in
    /*) thisdir=`dirname $0` ;;
    *)  thisdir=`pwd`/`dirname $0` ;;
esac

python=/ldc/bin/python2.4
PYTHONPATH=/web/language-archives/lib/python
export PYTHONPATH

$python $thisdir/get_hit_files_imap.py |
while read report; do
    $python $thisdir/load_report.py -c /home/olac/.my.cnf $report
    rm -f $report
done
