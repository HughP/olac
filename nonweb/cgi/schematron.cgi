#! /bin/sh
#
# synopsis:
#   run schematron validation against the given file
#
# changelog:
#   2005-11-29  created by HL
#

get_arg() {
  echo $QUERY_STRING | sed -r 's/(.*\&)*'$1'=([^&]*).*/\2/'
}

url=`get_arg url`
typ=`get_arg "type"`

if [ -z "$url" -o "$typ" != dynamic -a "$typ" != static ] ; then
  echo "Content-type: text/plain"
  echo
  echo "usage: $(olacvar baseurl)/cgi-bin/schematron.cgi?url=<url>&type=<type>"
  echo
  echo "  <url> is the URL of the file to validate"
  echo "  <type> is the repository type (either dynamic or static)"
  exit 1
fi

xslt=$(olacvar xslt)
case $typ in
    dynamic)
	xsl=$(olacvar docroot)/register/scripts-1.1/olac-dynamic-repository-report.xsl
	;;
    static)
	xsl=$(olacvar docroot)/register/scripts-1.1/olac-static-repository-report.xsl
	;;
esac
tmperr=/tmp/schematron.cgi-$$-err
tmpout=/tmp/schematron.cgi-$$-out
$xslt "$url" $xsl 1> $tmpout 2> $tmperr

if [ `stat -c %s $tmperr` -ne 0 ] ; then
    echo "Content-type:text/html"
    echo
    echo "<html><head><title>Schematron validation result</title></head><body>"
    echo "<h1>Schematron validation error</h1>"
    echo "<table bgcolor=#e0e0e0 width=100%><tr><td><pre>"

    cat $tmperr

    echo "</pre></td></tr></table>"
    echo "</body></html>"
else
    echo "Content-type: text/html"
    echo
    cat $tmpout
fi

rm -f $tmperr $tmpout
