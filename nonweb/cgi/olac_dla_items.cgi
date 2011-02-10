#! /bin/sh

sql="select count(*) from ARCHIVED_ITEM ai left join (select distinct Item_ID from METADATA_ELEM me, INTEGRITY_CHECK ic where ic.Object_ID=me.Element_ID and ic.Problem_Code='IHC') x on ai.Item_ID=x.Item_ID where x.Item_ID is null;"

query() {
    mysql -h $(olacvar mysql/host) \
          -u $(olacvar mysql/user) \
          -p"$(olacvar mysql/passwd)" \
          $(olacvar mysql/olacdb)
}

echo "Content-type: text/plain"
echo
echo $sql | query | sed 1d

