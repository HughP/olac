#! /bin/sh

sql="select count(distinct ai.Item_ID) from ARCHIVED_ITEM ai, METADATA_ELEM me, INTEGRITY_CHECK ic where ai.Item_ID=me.Item_ID and me.Element_ID=ic.Object_ID and ic.Problem_Code='IHC';"

query() {
    mysql -h $(olacvar mysql/host) \
          -u $(olacvar mysql/user) \
          -p"$(olacvar mysql/passwd)" \
          $(olacvar mysql/olacdb)
}

echo "Content-type: text/plain"
echo
echo $sql | query | sed 1d

