#! /bin/sh

sql="select count(*) from ARCHIVED_ITEM;"

query() {
    mysql -h $(olacvar mysql/host) \
          -u $(olacvar mysql/user) \
          -p"$(olacvar mysql/passwd)" \
          -N \
          $(olacvar mysql/olacdb)
}

echo "Content-type: text/plain"
echo
echo $sql | query

