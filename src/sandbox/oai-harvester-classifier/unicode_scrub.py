#!/usr/bin/python
import sys,codecs
# use Mark Pilgrim's Universal Encoding Detector
# http://chardet.feedparser.org
import chardet

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
   input = open(inputfile, 'r')
   output = codecs.open(outputfile, 'w', 'utf-8')

   for line in input:
      output.write( to_unicode(line) )

   input.close()
   output.close()

# strip out non-ASCII characters
def onlyascii(char):
   if ord(char) < 48 or ord(char) > 127: return ''
   else: return char

# try to convert any code-page to UTF-8
enc = []
def to_unicode(bytes):
   assert(isinstance(bytes, str))
   answer = chardet.detect(bytes)
   encoding = answer['encoding']
   #confidence = answer['confidence']
   try:
      return bytes.decode(encoding)
   except UnicodeDecodeError:
      pass

   # failed to convert -- fall back to ASCII-only
   return filter(onlyascii, bytes)

if __name__ == '__main__':
    main()

