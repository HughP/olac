EXPECTED_ARGS=1
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` filename"
    exit $E_BADARGS
fi

TMP=cleanup.tmp

# replace pipe with space
tr "|" " " < $1 > $TMP

# replace \n with pipe
tr "\n" "|" < $TMP > $1

# replace non print chars with spaces
tr -c "[:graph:]" " " < $1 > $TMP

# replace pipe with \n
tr "|" "\n" < $TMP > $1

rm $TMP
