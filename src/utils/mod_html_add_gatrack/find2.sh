#! /bin/sh

list_files() {
	find /olac/svn/web \
		\( \
		\( -name ".svn" -prune \) -o \
		\( -path "/olac/svn/web/static-records" -prune \) -o \
		\( -path "/olac/svn/web/static" -prune \) -o \
		\( -path "/olac/svn/web/ci" -prune \) -o \
		\( -path "/olac/svn/web/xmldump" -prune \) -o \
		\( -path "/olac/svn/web/js" -prune \) -o \
		\( -path "/olac/svn/web/register/tmp" -prune \) \
		\) , -type f
}

check() {
	test -n "$(grep $1 $2)"
}

filter() {
	test -z "$(grep $1 $2)"
}

apply() {
	while read a; do
		$1 $2 $a && echo $a
	done
}

list_files | apply filter gatrack

