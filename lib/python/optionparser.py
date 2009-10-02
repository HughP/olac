#! /ldc/bin/python2.4

import sys
import os
import re
import random

class OptionParser:
    class ParseError(Exception):
        def __init__(self, *args):
            Exception.__init__(self, *args)
            # for compatibility with older python (<2.5)
            self.message = str(self)
    
    def __init__(self, *args):
        self.result = []
        self.args = []
        self.error = None
        self.config = []
        for opt in args:
            m = re.match(r'^(\*?)(.*?)(:*)$', opt)
            if m is None: continue
            a, core, b = m.groups()
            mandatory = (a=='')
            nargs = len(b)
            self.config.append((core,a=='',nargs))
        
    def parse(self, L):
        self.result = []
        self.args = []
        self.error = None
        i = 0
        while i < len(L):
            opt = L[i]
            for core, mandatory, nargs in self.config:
                if opt == core:
                    i += 1
                    x = []
                    x.append(opt)
                    for j in range(nargs):
                        try:
                            a = L[i+j]
                        except IndexError:
                            self.error = 'Missing argument for option %s' % opt
                            raise OptionParser.ParseError(self.error)
                        if a != '-' and a != '--' and a[0] == '-':
                            self.error = 'Invalid argument for ' \
                                         'option %s: %s' % (opt, `a`)
                            raise OptionParser.ParseError(self.error)
                    x.append(L[i:i+nargs])
                    self.result.append(x)
                    i += nargs
                    break
            else:
                if opt[0] == '-':
                    self.error = 'Unknown option: %s' % `opt`
                    raise OptionParser.ParseError(self.error)
                else:
                    self.args.append(opt)
                    i += 1
            opt = None

        for core, mandatory, nargs in self.config:
            if mandatory and not self.get(core):
                self.error = 'Mandatory option %s is missing' % `core`
                raise OptionParser.ParseError(self.error)

    def iterate(self):
        if self.error: return
        for opt, vals in self.result:
            yield opt, vals

    def get(self, opt):
        if self.error: return
        return [x[1] for x in self.result if x[0]==opt]

    def getOne(self, opt):
        if self.error: return
        for x in self.result:
            if x[0] == opt:
                for core, mandatory, nargs in self.config:
                    if core == opt:
                        if nargs == 1:
                            return x[1][0]
                        else:
                            return x[1]
                        
def example():
    usageString = """\
Usage: %s [-g|-h] -pencil A -lined B -fast C -careful D -docs L1 -scribes L2

    options:

      -h  print this message and exit
      -g  enforce the global distribution
      
    parameters:
  
      A   %% writings with pencil (<=100)
      B   %% writings on lined paper (<=100)
      C   %% written hastely (<=100)
      D   %% written carefully (<=100)
      L1  list of documents
      L2  list of scribes

      C + D should be less than or equal to 100.
""" % os.path.basename(sys.argv[0])

    def usage(msg=None):
        print >>sys.stderr, usageString
        if msg:
            print >>sys.stderr, "ERROR:", msg
            print >>sys.stderr
        sys.exit(1)
        
    op = OptionParser(
        "*-h",
        "*-g",
        "-pencil:",
        "-lined:",
        "-fast:",
        "-careful:",
        "-docs:",
        "-scribes:"
        )
    
    try:
        op.parse(sys.argv[1:])
    except OptionParser.ParseError, e:
        usage(e.message)

    if op.get('-h'): usage()

    if op.args:
        msg = "WARNING: There are extra paramters in " \
              "the command line which will be ignored."
        print >>sys.stderr, msg

        usage(msg)

    doclist = op.getOne('-docs')
