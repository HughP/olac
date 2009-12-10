EXPECTED_ARGS=1
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` filename"
    exit $E_BADARGS
fi

TMP=filter.tmp

echo Original size...
wc $1

grep -iv "philology" $1 > $TMP
echo philology:
wc $TMP
grep -iv "congresses" $TMP > $1
echo congresses:
wc $1
grep -iv "history" $1 > $TMP
echo history:
wc $TMP
grep -iv "criticism" $TMP > $1
echo criticism:
wc $1
grep -iv "metrics" $1 > $TMP
echo metrics:
wc $TMP
grep -iv "versification" $TMP > $1
echo versification:
wc $1
grep -iv "literature" $1 > $TMP
echo literature:
wc $TMP
grep -iv "poetry" $TMP > $1
echo poetry:
wc $1
grep -iv "rhetoric" $1 > $TMP
echo rhetoric:
wc $TMP
grep -iv "composition" $TMP > $1
echo composition:
wc $1
grep -iv "style" $1 > $TMP
echo style
wc $TMP
echo FINISHED
mv $TMP $1
