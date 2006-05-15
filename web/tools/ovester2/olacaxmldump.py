#! /ldc/app/i386/pkg/Python-2.4.3/bin/python
#
# Sends a ListRecords query to OLACA and saves the response in gzip format.
# Resumption token is followed.
#
# Note: The output goes to STDOUT.
#

import sys
import pycurl
from xml.dom.minidom import parse
from StringIO import StringIO
import time
import gzip
import codecs
encf, decf, reader, writer = codecs.lookup('utf-8')
url_base = "http://www.language-archives.org/cgi-bin/olaca3.pl"
OUT = writer(gzip.GzipFile("","w",1,sys.stdout))

def mycurl(url, f):
    """
    @param f: file object
    """
    
    header = [
        "Accept: image/png,*/*;q=0.5",
        "Accept-Language: en-us,en;q=0.5",
        "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7",
        "Keep-Alive: 300",
        "Connection: keep-alive",
        ]

    pycurl.global_init(pycurl.GLOBAL_ALL)
    c = pycurl.Curl()
    print >>sys.stderr, `url`
    c.setopt(pycurl.URL, url)
    c.setopt(pycurl.HTTPHEADER, header)
    c.setopt(pycurl.USERAGENT, "Mozilla/5.0 (X11; U; FreeBSD i386; en-US; rv:1.8.0.1) Gecko/20060208 Firefox/1.5.0.1")
    c.setopt(pycurl.ENCODING, "gzip,deflate")
    c.setopt(pycurl.FOLLOWLOCATION, 1)
    c.setopt(pycurl.WRITEFUNCTION, f.write)
    c.perform()
    pycurl.global_cleanup()

    f.seek(0)

def print_response(url):
    f = StringIO()
    mycurl(url, f)
    dom = parse(f)
    for c in dom.getElementsByTagName("record"):
        OUT.write(c.toprettyxml("  "))
    rtoks = dom.getElementsByTagName("resumptionToken")
    if rtoks:
        rtok = rtoks[0].firstChild.nodeValue
    else:
        rtok = None
    return rtok.strip()

def main():
    url = url_base + "?verb=ListRecords&metadataPrefix=olac"

    OUT.write("""<?xml version="1.0" encoding="UTF-8" ?>
<OAI-PMH xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
<responseDate>%04d-%02d-%02dT%02d:%02d:%02dZ</responseDate>
<request verb="ListRecords" metadataPrefix="olac">http://www.language-archives.org/cgi-bin/olaca3.pl</request>
<ListRecords>
""" % time.gmtime()[:6])

    while url is not None:
        tok = print_response(str(url))
        if tok is not None:
            url = url_base + "?verb=ListRecords&resumptionToken=%s" % tok
        else:
            url = None

    OUT.write("""
</ListRecords>
</OAI-PMH>
""")

main()
