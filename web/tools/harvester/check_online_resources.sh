#! /bin/sh

# mysql db account info file
MYCNF=/home/olac/.my.cnf.olac2

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

$PYTHON $ODIR/integrity.py -c $MYCNF -u
/usr/bin/lockf /tmp/olac.metrics.lock $PYTHON $ODIR/compute_olac_metrics.py -c $MYCNF