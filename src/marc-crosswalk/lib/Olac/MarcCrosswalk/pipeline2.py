import sys
import os
import os.path
import codecs
from os import sep
from Olac.MarcCrosswalk import utils
from Olac.MarcCrosswalk import pipeline

class CrosswalkPipelineForOAI(CrosswalkPipeline):

    def __init__(self, state):
        CrosswalkPipeline.__init__(self, state)


    def _ProcessLoop(self, mode='normal'):
        ctr = 1;
        xml_footer = ''
        tmpfile = self._s['path']['tmp'] + sep + 'xml_output.tmp'
        tmpfile2 = self._s['path']['tmp'] + sep + 'xml_output2.tmp'

        outputfilename = self._s['path']['proj'] + sep + self._s.get('system', 'output')
        if mode == 'inverse':
            root,ext = os.path.splitext(outputfilename)
            outputfilename = root + '-inverse' + ext
        output = codecs.open(outputfilename, 'w', 'utf-8')

        if len(self._files) > 1:
            self.Log("Processing %d files" % len(self._files))
        else:
            self.Log("Processing 1 file", False, False)

        for f in self._files:
        # TODO this loop would be more readable if implemented using a state machine (switch) instead of if/else
            if len(self._files) > 1: self.Log(str(ctr), False, False) 

            xslt = XSLTransform(self._s['path']['lib'],
                    self._s.get('system', 'java_params'), self._s['verbose'])
            xslt.label = 'LOOP'

            # Crosswalk
            stylesheet = self._s['path']['lib'] + \
                    sep + 'listRecords2repository.xsl'
            params = ''
            if (self._s['debug']): params = 'debug=yes'
            xslt.DoTransform(stylesheet, f, tmpfile, params)
            if (not utils.tryToMove(tmpfile, f, stylesheet)): break

            # Post-Crosswalk: cleanup
            stylesheet = self._s['path']['lib'] + \
                    sep + 'cleanup.xsl'
            params = ''
            if (self._s['debug']): params = 'debug=yes'
            xslt.DoTransform(stylesheet, f, tmpfile, params)
            if (not utils.tryToMove(tmpfile, f, stylesheet)): break

            # Post-Crosswalk: remove duplicates
            stylesheet = self._s['path']['lib'] + \
                    sep + 'remove_duplicates.xsl'
            xslt.DoTransform(stylesheet, f, tmpfile)
            if (not utils.tryToMove(tmpfile, f, stylesheet)): break

            if self._s['laststage'] != 'crosswalk':

                # Type Classifier
                if self._typeClassifier is not None:
                    self._typeClassifier.Classify(f, tmpfile)
                    if (not utils.tryToMove(tmpfile, f)):
                        self.Log("Error: TypeClassifier did not output a file!")
                        break
                
                    # Filter: has OLAC type (asserts all records have an OLAC type)
                    # Are we sure that we need this step???  Maybe the subject language classifier has been improved?
                    stylesheet = self._s['path']['lib'] + \
                            sep + 'olac-filter-has-olac-type.xsl'
                    xslt.DoTransform(stylesheet, f, tmpfile)
                    if (not utils.tryToMove(tmpfile, f, stylesheet)): break

                # Subject Classifier
                if 'nltk' in sys.modules:
                    self._subjLangClassifier.Classify(f, tmpfile)
                    if (not utils.tryToMove(tmpfile, f)):
                        self.Log("Error: SubjectLanguageClassifier did not output a file!")
                        break

                if self._s['laststage'] != 'enrichment':

                    # OLAC Filter
                    stylesheet = self._s['path']['tmp'] + sep + \
                        self._s['projectName']
                    if mode == 'inverse':
                        stylesheet += '-olac-filter-inverse.xsl'
                    else:
                        stylesheet += '-olac-filter.xsl'

                    xslt.DoTransform(stylesheet, f, tmpfile)
                    if (not utils.tryToMove(tmpfile, f, stylesheet)): break

            header, recs, footer = self.ParseOLACRepo(f)
            xslt.Finish()



            # write and capture XML header and footer for output file
            if ctr == 1:
                output.write(header)
                xml_footer = footer

            output.write(recs)
            ctr += 1

        output.write(xml_footer)
        output.close()
