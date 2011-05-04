from Olac.MarcCrosswalk.runner import CrosswalkRunner
from Olac.MarcCrosswalk.pipeline2 import CrosswalkPipelineForOAI
import os
import sys
from optparse import OptionParser
from os import sep
from ConfigParser import ConfigParser

runner = CrosswalkRunner()
parser = runner.GetCmdParser()
runner.ProcessCmdLine(parser)
runner.UpdatePaths()
state = runner.ProcessConfigFile('setup.cfg')
state['path'] = runner.paths
state['projectName'] = runner.projectName
runner.Log("Processing %s" % runner.projectName)
pipeline = CrosswalkPipelineForOAI(state)

# normal run
pipeline.Log("OAI -> OLAC Crosswalk...")
pipeline.Initialize()
pipeline.Run()
pipeline.Finish()

if runner.inverse:
    runner.Log("Creating inverse output.")
    pipeline.Initialize('inverse')
    pipeline.Run('inverse')
    pipeline.Finish('inverse')
runner.Log("Done.")
