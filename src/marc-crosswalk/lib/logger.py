class Logger(object):

    def __init__(self, stream, label = ''):
        self._log = stream
        self._verbose = False
        self._label = label

    def Log(self, msg, isVerboseMsg = False, newline = True):
        if self._verbose and len(self._label) > 0 and newline and len(msg.strip()) > 0:
            self._log.write('\n' + self._label + ': ')
        if (not isVerboseMsg or 
                (isVerboseMsg and self._verbose)):
            self._log.write(msg)
            if newline:
                self._log.write('\n')

    def SetVerbose(self, on):
        self._verbose = on

    def SetLabel(self, label):
        self._label = label
