import os
import re

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

def apply_stylesheets(inputfilename,config):
    """apply_stylesheets(xml_filename)
    purpose: apply XSL stylesheets defined in config file
            to the xml file given as input
    param: inputfilename - filename of an xml file to transform
            config - config object
    returns: nothing - output of transformation is now contained in input file"""
    xml_output = 'xml_output.tmp'

    # apply xsl stylesheets using Saxon on the command line
    for xsl_file in config.get('system','xsl_stylesheet_list').split(','):
        #print 'inputfilename = ',inputfilename
        #print 'xml_output = ',xml_output
        systemstring = 'java -jar %s -xsl:%s.xsl -s:"%s" -o:%s' % \
            (config.get('system','saxon_jar_file'),xsl_file,inputfilename,xml_output)
        #print 'sys = ',systemstring
        os.system(systemstring)
        #os.remove(inputfilename)
        try:
            import shutil
            shutil.move(xml_output,inputfilename)
        except WindowsError:
            print "No output resulted from the transformation.  There is probably an error in your XML data or the stylesheet"
            break
