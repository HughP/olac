import sys

class CrosswalkPipeline(object):

    def __init__(self, state):
        self._state = state
        self._log = sys.stdout

    def Start(self):
        return
        self.__LoadResources()

    def Log(self, msg, isDebug = 0):
        if (not isDebug or 
                (isDebug and self._state.get('system', 'debug') == 'yes')):
            self._log.write(msg)

    def __LoadResources(self):
        self._Log("Compiling filters")
        config = utils.compileMARCFilters(config)
        config = utils.compileOLACFilters(config)
        self._Log("\n")
        self._Log("Loading subject language classifier...")
        subjClassifier = utils.loadClassifier(config)
        marcxml_filename = projpath + sep + config.get('system','input')
        olacxml_filename = projpath + sep + config.get('system','output')
        utils.writeImportMap(config)


