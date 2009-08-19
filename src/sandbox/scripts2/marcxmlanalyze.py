import pymarc
import sys
import codecs
import xml.etree.ElementTree as etree

# marcxmlanalyze.py
# Chris Hirt
# 06/17/09
#

stat = {}
def updateStat(val):
    global stat
    if stat.has_key(val):
        stat[val] += 1
    else:
        stat[val] = 1

def parseFile(file):
    ctr = 0
    doc = etree.parse(file)
    for rec in doc.getroot():
        for field in rec:
            if field.attrib.has_key('tag'):
                updateStat(field.attrib['tag'] + ' ')
                if field.tag.find('datafield') != -1:
                    for subfield in field:
                        updateStat(field.attrib['tag'] + subfield.attrib['code']) 


while len(sys.argv) > 1:
    file = sys.argv.pop(1)
    parseFile(file)

if len(stat) > 0:
    outfile = codecs.open('marcxmlanalyze.output','w','utf-8')
    for id in sorted(stat):
        outfile.write(u"%4s %6d\n" % (id,stat[id]))
