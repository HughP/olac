import os
import re
import codecs
import sys
import xml.etree.ElementTree as etree
import shutil

# a "safe" move function, with a special error message
def tryToMove(fr, to, stylesheet = None):
    try:
        shutil.move(fr,to)
        return True
    except IOError, e:
        if stylesheet is not None:
            print "Error transforming XML %s with stylesheet %s" \
                    % (os.path.basename(fr), \
                    os.path.basename(stylesheet))
        else:
            print e
        return False 

# slurp a file into a string
def file2string(fileName):
    """file2string(fileName)
    purpose: read the contents of a file into a string
    param: fileName
    returns: string (contents of file)"""
    file = codecs.open(fileName, 'r', 'utf-8')
    str = file.readlines()
    file.close()
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

