# coding=utf-8
'''A compilation of a couple functions that are used often.
Created on Jul 8, 2009

@author: jshou
'''
import sys
import os
import unicodedata

def check_file(filename):
    '''Checks to see if a file exists.  Asks for permission to overwrite if
    it does.  Returns the file ready for writing if permission is given, or
    or if the file does not already exist.
    '''
    if os.path.exists(os.path.join(os.getcwd(),filename)):
        a = raw_input("File %s already exists.  Overwrite? [yn]: " % filename)
        if not a.lower()=='y':
            sys.exit(2)
        else:
            print "Overwriting..."
            return open(filename,'wb')
    else:
        return open(filename,'wb')

def get_or_none(record, key):
    try:
        return record[key]
    except KeyError:
        return ''

def remove_diacritic(input):
    input = input.replace(u'’',u"'")
    return unicodedata.normalize('NFKD',input).encode('ascii','ignore')
