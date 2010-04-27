import olac
import sys
import os
import codecs
from lib import *

sys.path.insert(0, olac.olacvar('pywebapi'))

try:
    from nitems import *
except ImportError:
    print >>sys.stderr, "Failed to import nitems module from dir:"
    print >>sys.stderr, olac.olacvar('pywebapi')
    sys.exit(1)

# getTable function
dumpcall(getTable, path='nitems')

# byCountryCode
tabfile = olac.olacvar('data/num_items_by_country')
f = open(tabfile)
f.readline()
S = set()
for l in f:
    a = l.rstrip("\r\n").split('\t')
    if a[2] not in S:
        dumpcall(byCountryCode, [a[2]], path='nitems')
        dumpcall(byCountryCode, [a[2], "true"], path='nitems')
        S.add(a[2])

# byArea
tabfile = olac.olacvar('data/num_items_by_country')
f = open(tabfile)
f.readline()
S = set()
for l in f:
    a = l.rstrip("\r\n").split('\t')
    if a[0] not in S:
        dumpcall(byArea, [a[0]], path='nitems')
        dumpcall(byArea, [a[0], "true"], path='nitems')
        S.add(a[0])
