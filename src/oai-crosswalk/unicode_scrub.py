#!/usr/bin/python

import sys
import codecs

# use Mark Pilgrim's Universal Encoding Detector
try:
    import chardet
except ImportError:
    print >>sys.stderr, """
Can't find the 'chardet' module, which can be obtained from here:
http://chardet.feedparser.org/download/
"""
    sys.exit(1)

# unicode_scrub.py
# July 14, 2010
# Sven Pedersen

# Scrubs UTF-8 files of all impure adulterated evil code page data
#  such as CP-1251 from Windows and its ilk.

# based on a solution by Hao Lian
#  http://answers.oreilly.com/topic/1306-building-a-utf8-unicode-sanitizer-for-python/
# and ASCII-only code from Larry Bates:
#  http://bytes.com/topic/python/answers/28293-way-remove-all-non-ascii-characters-file

def main():
   try:
      inputfile = sys.argv.pop(1)
      outputfile = sys.argv.pop(1)
   except IndexError:
      sys.stderr.write("usage: unicode_scrub.py input_file output_file\n")
      sys.exit()
   unicode_scrub(inputfile, outputfile)

def unicode_scrub(inputfile, outputfile):
   input = open(inputfile, 'r')
   output = codecs.open(outputfile, 'w', 'utf-8')

   for line in input:
      output.write( to_unicode(line.replace('\r', '')) )

   input.close()
   output.close()

# strip out non-ASCII characters
def onlyascii(char):
   if ord(char) > 127:
      return '?'
   else:
      return char

# try to convert any code-page to UTF-8
enc = {}
def to_unicode(bytes):
   assert(isinstance(bytes, str))
   answer = chardet.detect(bytes)
   encoding = answer['encoding']
   if encoding == 'EUC-TW': encoding = 'latin-1'
   #confidence = answer['confidence']
   try:
      return bytes.decode(encoding)
   except UnicodeDecodeError,LookupError:
      # first fall back to Extended ASCII
      try:
         return bytes.decode("latin-1")
      except UnicodeDecodeError:
         pass

   # failed to convert -- fall back to ASCII-only
   print "falling back"
   return filter(onlyascii, bytes)

if __name__ == '__main__':
    main()

