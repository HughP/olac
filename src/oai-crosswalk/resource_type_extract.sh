#!/bin/bash

EXPECTED_ARGS=1
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` [Archive ID]|all"
    exit $E_BADARGS
fi

if [ $1 == "all" ]; then
SQL="set session group_concat_max_len = 10000;
select METADATA_ELEM.Item_ID,'',group_concat(replace(Content,'\\n',' ') SEPARATOR ' *** ') from ARCHIVED_ITEM inner join METADATA_ELEM on ARCHIVED_ITEM.Item_ID = METADATA_ELEM.Item_ID where (TagName = 'description' or TagName = 'title' or TagName = 'subject' or TagName = 'coverage') and (TypeClassifiedDate is NULL or TypeClassifiedDate < ARCHIVED_ITEM.DateStamp) group by METADATA_ELEM.Item_ID;
"
else
SQL="set session group_concat_max_len = 10000;
select METADATA_ELEM.Item_ID,'',group_concat(replace(Content,'\\n',' ') SEPARATOR ' *** ') from ARCHIVED_ITEM inner join METADATA_ELEM on ARCHIVED_ITEM.Item_ID = METADATA_ELEM.Item_ID where ( TagName = 'description' or TagName = 'title' or TagName = 'subject' or TagName = 'coverage') and Archive_ID = $1 and (TypeClassifiedDate is NULL or TypeClassifiedDate < ARCHIVED_ITEM.DateStamp) group by METADATA_ELEM.Item_ID;
"
fi
mysql --defaults-file=~/oai.my.cnf -e "$SQL"
