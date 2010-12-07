#! /bin/sh

find $1 -type f -name "*.html" \( ! -path "$1/static/*" \) \( ! -path "$1/ci/*" \) | while read a; do [ -z "$(grep gatrack $a)" ] && echo $a; done

