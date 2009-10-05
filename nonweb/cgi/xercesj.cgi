#! /bin/sh
#
# synopsis:
#   CGI interface to /mnt/unagi/speechd8/ldc/wwwhome/olac/bin/xercesj
#
# changelog:
#   2004-11-17  made changes for new FreeBSD server - HL
#   2003-02-21  sed for $url fix -- url can have '&'  - HL
#   2003-02-17  created by HL
#

url=`echo $QUERY_STRING | sed 's/\(.*&\)*url=\(.*\)/\2/'`

if test -z "$url" ; then
  echo "Content-type: text/plain"
  echo
  echo "usage: $(olacvar baseurl)/cgi-bin/xercesj.cgi?url=<url>"
  echo
  echo "  <url> is the URL of the file to validate"
  exit 1
fi

echo "Content-type:text/html"
echo
echo "<html><head><title>Xerces-J validation result</title></head><body>"
echo "<h1>Xerces-J validation result</h1>"
echo "<p>Error message follows.  If there's nothing, you are good!</p>"
echo "<table bgcolor=#e0e0e0 width=100%><tr><td><pre>"

$(olacvar xml_validator) "$url"

echo "</pre></td></tr></table>"
echo "<p>done.</p>"
echo "</body></html>"

