#! /bin/sh

MYSQL=mysql

PYTHON=python

TMP_LOG=/tmp/harvest.log-$$

echo $$ > $(olacvar pids/web_harvester)

# parse command line
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

FIFO=/var/tmp/fifo.harvester.web.olac
if [ ! -f $FIFO ]; then
        mkfifo $FIFO
elif [ "$(file -b $FIFO)" != "fifo (named pipe)" ]; then
        rm -rf $FIFO >/dev/null 2>&1 || FIFO=$FIFO-$$
        mkfifo $FIFO
fi

FIFO2=/var/tmp/fifo2.harvester.web.olac
if [ ! -f $FIFO2 ]; then
	mkfifo $FIFO2
elif [ "$(file -b $FIFO2)" != "fifo (named pipe)" ]; then
	rm -rf $FIFO2 >/dev/null 2>&1 || FIFO2=$FIFO2-$$
	mkfifo $FIFO2
fi

facility=$(echo $(olacvar syslog/facility) | sed 's/LOG_//' | tr [A-Z] [a-z])
LOGGER="logger -t 'run1.sh[$$]' -p $facility.info"

# Here's how program output is distributed/duplicated:
#
# stdout+stderr -> FIFO -> tee -> FIFO2 -> tee -> TMP_LOG
#                           |               |
#                           |               +---> stdout
#                           |
#                           +-------------------> logger
cat $FIFO | tee $FIFO2 | $LOGGER &
cat $FIFO2 | tee $TMP_LOG &

exec 5>&1 6>&2 1>$FIFO 2>&1

$PYTHON -u $(olacvar harvester/main) -f -u -s "$url" $opt --stdout

# close down all output channels
exec 1>&- 2>&-
wait %1 %2

# output only goes to the loggger from now on
cat $FIFO | $LOGGER &
exec 1>$FIFO 2>&1

new_records=`grep -e "updated records:" -e "new records:" $TMP_LOG | awk '{sum+=$5} END {print sum}'`
[ ${new_records:-0} -gt 0 ] && touch $(olacvar dirty)

rm -f $TMP_LOG
rm -f $FIFO
rm -f $FIFO2
rm -f $(olacvar pids/web_harvester)

