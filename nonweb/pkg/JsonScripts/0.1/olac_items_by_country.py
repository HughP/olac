import olac
import sys
import os
import codecs
from lib import *

sys.path.insert(0, olac.olacvar('pywebapi'))

try:
    from coverage import *
except ImportError:
    print >>sys.stderr, "Failed to import coverage module from dir:"
    print >>sys.stderr, olac.olacvar('pywebapi')
    sys.exit(1)

# getTable
dumpcall(getTable, path="coverage")

# getLanguageTable
dumpcall(getLanguageTable, path="coverage")

# getOnlineResTable
dumpcall(getOnlineResTable, path="coverage")
