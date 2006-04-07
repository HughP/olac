#! /usr/local/bin/python

import os
import os.path
import sys

for line in sys.stdin:
    a = line.split()
    if a[-1][0] == '/':
        p = a[-1]
    else:
        p = os.path.dirname(a[-3])+"/"+a[-1]
    if not os.path.lexists(p):
        print "[stale]", a[-3]
    elif not os.path.realpath(p).startswith('/web/'):
        print "[cross]", a[-3]

