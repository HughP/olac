"""
Generates static record pages.

input:  ListRecords output
output: Static record pages
"""

import sys
import gzip
from cStringIO import StringIO
import os.path

record = """<record
     xmlns:olac="http://www.language-archives.org/OLAC/1.0/"
     xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:dcterms="http://purl.org/dc/terms/"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
"""
     
flag = False
f = gzip.open(sys.argv[1])
l = f.readline()
g = None
while l:
    if '<record>' in l:
        g = StringIO()
        g.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        g.write('<?xml-stylesheet type="text/xsl" href="/static-records/staticrecord.xsl" ?>\n')
        l = record
    elif '<identifier>' in l:
        g.write(l)
        l = f.readline()
        oaiid = l.strip()
    elif '<olac:olac ' in l:
        l = '    <olac:olac>\n'
    elif '</record>' in l:
        g.write(l)
        a = oaiid.split('/')
        for d in a[:-1]:
            if not os.path.exists(d):
                os.mkdir(d)
        file(oaiid+".xml","w").write(g.getvalue())
        g = None
        
    if g: g.write(l)

    l = f.readline()
