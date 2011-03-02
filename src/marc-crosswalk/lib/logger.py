class Logger(object):

    def __init__(self, stream, label = ''):
        self._log = stream
        self._debug = 0
        self._label = label

    def Log(self, msg, isDebugMsg = False, newline = True):
        if self._debug and count(self._label) and newline:
            self._log.write(label + ': ')
        if (not isDebugMsg or 
                (isDebugMsg and self._debug)):
            self._log.write(msg)
            if newline:
                self._log.write('\n')

    def SetDebug(self, on):
        self._debug = on
