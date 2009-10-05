#! /bin/sh

python=python

tmpdir=/tmp/ga-$$
mkdir -p $tmpdir
cd $tmpdir

$python $(olacvar ga/download) |
while read report; do
    $python $(olacvar ga/load) $report
    rm -f $report
done

cd /tmp
rm -rf $tmpdir


