import xml.etree.ElementTree as etree
import sys
import codecs
import os.path

olacNS = '{http://www.language-archives.org/OLAC/1.1/}'
dcNS = '{http://purl.org/dc/elements/1.1/}'
dctNS = '{http://purl.org/dc/terms/}'
oaiNS = '{http://www.openarchives.org/OAI/2.0/}'
srNS = '{http://www.openarchives.org/OAI/2.0/static-repository}'

def combineElements(elements):
    text = ''
    if elements is not None:
        for e in elements:
            if e is not None and e.text is not None:
                text = text + e.text + ' | '
    return text

def maketext(rec, elements):
    text = ''
    for e in elements:
        text += combineElements(rec.findall(e))
    return text

def gettypes(rec):
    elements = rec.findall(dcNS+'type')
    types = []
    for e in elements:
        for a in e.attrib:
            if a == olacNS+'code':
                types.append(e.attrib[a])
    return types


# get xml file from command line
if len(sys.argv) != 2:
    print "one xml filename param required"
    sys.exit()
else:
    xmlfile = sys.argv.pop()

# open output files (utf-8)
out1 = codecs.open(os.path.basename(xmlfile) + '.1label_1line.txt', 'w', 'utf-8')
out2 = codecs.open(os.path.basename(xmlfile) + '.multilabel_1line.txt', 'w', 'utf-8')
out3 = codecs.open(os.path.basename(xmlfile) + '.1label_multiline.txt', 'w', 'utf-8')
print "processing %s" % xmlfile
doc = etree.parse(xmlfile)
root = doc.getroot()
ctr = 0
multirecs = 0
for rec in root.find(srNS + 'ListRecords').findall(oaiNS + 'record'):
    rec = rec.find(oaiNS + 'metadata').find(olacNS + 'olac')
    types = gettypes(rec)
    for t in types:
        single_type = t
        if t != 'language_description':
            break
    ctr += 1
    text = maketext(rec, (dcNS+'title', dctNS+'alternative', dcNS+'subject', dcNS+'description', dcNS+'creator', dctNS+'abstract', dcNS+'contributor'))
    if ctr % 1000 == 0:
        sys.stdout.write(".")

    # write to outfiles

    # single type label, one line per record (this means we potentially lose type information if a record has more than one type)
    out1.write("%s\t%s\t%s\n" % (ctr, single_type, text))

    #  multiple type labels, one line per record.  Label are concatenated with '&'
    out2.write("%s\t%s\t%s\n" % (ctr, '&'.join(types), text))

    # single type label, one line per type of each record (this means that for a record that has more than one type, a line exists for each type in the record, effectively duplicating the text on which to train, but with a different label for that same text
    ctr2 = 1
    for t in sorted(types):
        out3.write("%s_%s\t%s\t%s\n" % (ctr, ctr2, t, text))
        ctr2 += 1
    if ctr2 > 2:
        multirecs += 1

print "%s recs had more than one type" % multirecs
print "%s recs total" % ctr
