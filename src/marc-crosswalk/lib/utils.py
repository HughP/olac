import os
import re
import codecs
import sys

# slurp a file into a string
def file2string(fileName):
    """file2string(fileName)
    purpose: read the contents of a file into a string
    param: fileName
    returns: string (contents of file)"""
    file = open(fileName)
    str = file.readlines()
    return ''.join(str)

def cfglist2dict(list):
    """cfglist2dict(list)
    purpose: conver a config list of names/values into a dictionary
    param: config list
    return: dictionary """
    d = {}
    for (name,value) in list:
        d[name] = value
    return d

def getstringfromfile(filename,start,end):
    """getstringfromfile(filename,start,end)
    purpose: extract a substring from a text file
    params: filename - the name of the text file
            start - the beginning part of the string to extract
            end - the final part of the string you want to extract
    returns: a string including the beginning and end strings, and everything
            in between"""
    doc = file2string(filename)
    startindex = doc.find(start)
    endindex = doc.find(end) + len(end)
    return doc[startindex:endindex]

def parseOLACRepository(filename):
    """parseOLACRepository(xml_filename)
    purpose: extract three elements from an OLAC XML Repository file:
            1) olac header (text that precedes the start of the first record)
            2) olac_records, not including the <sr:ListRecords> wrapper tags
            3) olac footer (text that follows the last record)
    returns: string tuple:
        olac_header (string)
        olac_records (string)
        olac_footer (string)
        """
    s = file2string(filename)
    p = re.compile("^(.*<sr:ListRecords[^>]+>)(.*)(</sr:ListRecords>.*)$",re.DOTALL)
    m = p.search(s)
    if m:
        return (m.group(1),m.group(2),m.group(3))
    else:
        return ('','','')

def parseMARCCollection(filename):
    """parseMARCCollection(xml_filename)
    purpose: extract three elements from a MARC XML Collection file:
            1) marc collection header (text that precedes the start of the first record)
            2) marc_records, not including the <marc:collection> wrapper tags
            3) marc collection footer (text that follows the last record)
    returns: string tuple:
        marc_header (string)
        marc_records (string)
        marc_footer (string)
        """
    s = file2string(filename)
    p = re.compile("^(.*<marc:collection[^>]+>)(.*)(</marc:collection>.*)$",re.DOTALL)
    m = p.search(s)
    if m:
        return (m.group(1),m.group(2),m.group(3))
    else:
        return ('','','')

def transform(config,stylesheet,input,output,params = ''):
    saxon = config.get('system','libpath') + config.get('system','sep') + \
        config.get('system','saxon_jar_file')
    systemstring = 'java -jar "%s" -xsl:"%s.xsl" -s:"%s" -o:"%s" %s' % \
       (saxon,stylesheet,input,output,params)
    #print systemstring
    os.system(systemstring)

def applyStylesheets(inputfilename,config):
    """applyStylesheets(xml_filename)
    purpose: apply XSL stylesheets defined in config file
            to the xml file given as input
    param: inputfilename - filename of an xml file to transform
            config - config object
    returns: nothing - output of transformation is now contained in input file"""
    libpath = config.get('system','libpath')
    sep = config.get('system','sep')
    xml_output = config.get('system','tmppath') + sep + 'xml_output.tmp'
    stage = int(config.get('system','stage'))

    # stage 1 (marc filter accept)
    xsllist = [(config.get('stylesheet','stage1'),'','1')]

    # stage 2 (marc filter reject)
    if stage >= 2:
        xsllist += [(config.get('stylesheet','stage2'),'','2')]

    # stage 3 (marc2olac transformation)
    if stage >= 3:
        stage3a_params = ''
        stage3b_params = ''
        inverse_param = 'inverse=yes'
        if config.get('system','debug') == 'yes':
            stage3a_params += 'debug=yes '
        if config.get('system','inverse') == 'yes' and stage == 3:
            stage3a_params += inverse_param
            stage3b_params += inverse_param

        # a list of tuple(stylesheet,params)
        xsllist += [(libpath + sep + s,p,st) for s,p,st in \
               [('collection2repository',stage3a_params,'3a'),('cleanup', stage3b_params, '3b')
                   ,('remove_duplicates','','3c')]]

    # stage 4 (olac filter)
    if stage >= 4:
        stage4_params = ''
        if config.get('system','debug') == 'yes':
            stage4_params += 'debug=yes '
        xsllist += [(config.get('stylesheet','stage4'), stage4_params, '4')]

    # apply xsl stylesheets using Saxon on the command line
    sys.stdout.write('\tstage ')
    for (xsl_file,params,stage) in xsllist:
        sys.stdout.write(stage + ' ')
        transform(config,xsl_file,inputfilename,xml_output,params)
        import shutil
        if os.path.exists(xml_output):
            shutil.move(xml_output,inputfilename)
        else:
            print "Error transforming XML %s with stylesheet %s" \
                    % (os.path.basename(inputfilename), \
                    os.path.basename(xsl_file))
            break
    sys.stdout.write('\n')

# need to implement this
def checkValidSystem(config):
    return

def compileOLACFilters(config):
    sep = config.get('system','sep')
    projectname = config.get('system','projectname')
    tmppath = config.get('system','tmppath')
    libpath = config.get('system','libpath')
    projpath = config.get('system','projpath')
    stage = int(config.get('system','stage'))

    filter = projpath + sep + config.get('system','olacfilter')
    filterstylesheet = tmppath + sep + projectname + '-olac-filter'
    config.set('stylesheet','stage4',filterstylesheet)

    filter_compiler = libpath + sep + 'olac-filter-compile'
    p = 'version="2.0"'
    if config.get('system','inverse') == 'yes' and stage == 4: p += ' mode=reject'
    sys.stdout.write('.')
    transform(config,filter_compiler,filter,filterstylesheet + '.xsl', p)
    return config

def compileMARCFilters(config):
    sep = config.get('system','sep')
    projectname = config.get('system','projectname')
    tmppath = config.get('system','tmppath')
    libpath = config.get('system','libpath')
    projpath = config.get('system','projpath')
    stage = int(config.get('system','stage'))

    filter = projpath + sep + config.get('system','marcfilter')
    reject = tmppath + sep + projectname + '-marc-filter-reject'
    accept = tmppath + sep + projectname + '-marc-filter-accept'
    config.set('stylesheet','stage1',accept)
    config.set('stylesheet','stage2',reject)

    # compile marc filters here

    # stage 1
    filter_compiler = libpath + sep + 'marc-filter-compile1'
    p = 'version="2.0"'
    if config.get('system','inverse') == 'yes' and stage == 1: p += ' inverse="yes"'
    sys.stdout.write('.')
    transform(config,filter_compiler,filter,accept + '.xsl', p)

    # stage 2
    if stage >= 2:
        filter_compiler = libpath + sep + 'marc-filter-compile2'
        p = 'version="2.0"'
        if config.get('system','inverse') == 'yes' and stage == 2: p += ' inverse="yes"'
        sys.stdout.write('.')
        transform(config,filter_compiler,filter,reject + '.xsl', p)
    
    return config

def writeImportMap(config):
    sep = config.get('system','sep')
    projpath = config.get('system','projpath')
    libpath = config.get('system','libpath')

    localpath = projpath + sep + config.get('system','local_customizations')
    localpath = localpath.replace(sep,'/')

    f = codecs.open(libpath + sep + 'importmap.xsl', encoding='utf-8', mode='w')
    string = """<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:include href="file:///%s"/>
</xsl:stylesheet>""" % localpath
    f.write(unicode(string))
    f.close()
