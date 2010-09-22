#! /bin/sh

if [ -z "$1" ]; then
    echo "Usage: mkzip.sh <collection_id>"
    echo
    echo "    Available collection IDs:"
    echo
    echo "        rosettaproject"
    echo "        LanguageCommons"
    echo
    exit 1
fi

case $1 in
    rosettaproject)
        src=rosetta_harvester.py ;;
    LanguageCommons)
        src=language_commons_harvester.py ;;
    *)
        echo "Unknown collection ID: $1"
        exit 1
        ;;
esac

tmpdir=$(basename $0)-$$
mkdir $tmpdir

cp simple_harvester.py ia_harvester.py $tmpdir
cp $src $tmpdir/__main__.py
cd $tmpdir
zip ../$(basename $src .py).zip *.py
cd ..
rm -rf $tmpdir

