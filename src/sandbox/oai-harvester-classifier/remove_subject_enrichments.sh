EXPECTED_ARGS=1
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` [Archive ID]|all"
    exit $E_BADARGS
fi

if [ $1 == "all" ]; then
SQL="delete from METADATA_ELEM using ARCHIVED_ITEM inner join METADATA_ELEM on METADATA_ELEM.Item_ID = ARCHIVED_ITEM.Item_ID where Code is not NULL and Extension_ID = 13;
    update ARCHIVED_ITEM set SubjectClassifiedDate = NULL,HasOLACLanguage = 0;"
else
SQL="delete from METADATA_ELEM using ARCHIVED_ITEM inner join METADATA_ELEM on METADATA_ELEM.Item_ID = ARCHIVED_ITEM.Item_ID where Code is not NULL and Extension_ID = 13 and Archive_ID = $1;
    update ARCHIVED_ITEM set SubjectClassifiedDate = NULL,HasOLACLanguage = 0 where Archive_ID = $1;"
fi
mysql --defaults-file=~/oai.my.cnf -v -e "$SQL"

