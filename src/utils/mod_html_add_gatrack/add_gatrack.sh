#! /bin/sh

x=$(grep gatrack $1)
if [ -n "$x" ]; then
    echo "already being tracked: $1"
    exit 1
fi
python add_gatrack.py $1 > /tmp/x.html
x=$(diff $1 /tmp/x.html | sed -r -e 1d -e 's/^>\s*//')
if [ "$x" = '<script type="text/javascript" src="/js/gatrack.js"></script>' ]; then
    cp /tmp/x.html $1
    echo "success: $1"
else
    echo "failure: $1"
fi


