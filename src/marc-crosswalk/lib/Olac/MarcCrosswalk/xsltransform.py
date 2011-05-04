import sys
import os
from os import sep
from logger import Logger

class XSLTransform(Logger):

    def __init__(self, libpath, javaparams, isverbose = False):
        Logger.__init__(self, sys.stdout, isverbose, 'XSLT')
        self._libpath = libpath
        self._params = javaparams

    def DoTransform(self, stylesheet, input, output, params = ''):
        saxonfilepath = self._libpath + sep + "saxon9.jar" 
        systemstring = 'java %s -jar "%s" -xsl:"%s" -s:"%s" -o:"%s" %s' % \
            (self._params, saxonfilepath, stylesheet, input, output, params)
        self.Log(systemstring, True)
        self.Log('.', False, False) # progress indicator
        os.system(systemstring)

    def Finish(self):
        self.Log(' ')
