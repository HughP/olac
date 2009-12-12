EXPECTED_ARGS=1
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` [Archive ID]"
    exit $E_BADARGS
fi

SQL="
delete from METADATA_ELEM using METADATA_ELEM,ARCHIVED_ITEM where ARCHIVED_ITEM.Item_ID = METADATA_ELEM.Item_ID and ARCHIVED_ITEM.Archive_ID = $1;
delete from ARCHIVED_ITEM where Archive_ID = $1;
delete from OLAC_ARCHIVE where Archive_ID = $1;
"
mysql --defaults-file=~/oai.my.cnf -v -e "$SQL"
