class Logger(object):

    def __init__(self, stream, verbose, label = ''):
        self.stream = stream
        self.verbose = verbose
        self.label = label


    def Log(self, msg, isVerboseMsg = False, newline = True):
        if self.verbose and isVerboseMsg and \
                len(self.label) > 0 and newline and len(msg.strip()) > 0:
            self.stream.write('\n' + self.label + ': ')
        if (not isVerboseMsg or 
                (isVerboseMsg and self.verbose)):
            self.stream.write(msg)
            if newline:
                self.stream.write('\n')
