import olac
import sys
import os
import codecs
from lib import *

sys.path.insert(0, olac.olacvar('pywebapi'))

try:
    from submissionPolicies import *
except ImportError:
    print >>sys.stderr, "Failed to import submissionPolicies module from dir:"
    print >>sys.stderr, olac.olacvar('pywebapi')
    sys.exit(1)

# getPolicies
dumpcall(getPolicies, path='submissionPolicies')
