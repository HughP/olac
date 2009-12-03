import xml.etree.ElementTree as etree
import sys
import codecs
import os.path

def combineElements(elements):
    text = ''
    if elements is not None:
        for e in elements:
            if e is not None and e.text is not None:
                text = text + e.text + ' | '
    return text

def isLanguageResource(lcc):
    if lcc.startswith('P'):
        if lcc >= 'PA3000' and lcc <= 'PA9999': # Classical (Greek, Roman) literature
            return 0
        elif lcc >= 'PG2900' and lcc <= 'PG3699': # Russian literature
            return 0
        elif lcc >= 'PJ1481' and lcc <= 'PJ1989': # Ancient Egyptian literature
            return 0
        elif lcc >= 'PJ3601' and lcc <= 'PJ3971': # Akkadian literature
            return 0
        elif lcc >= 'PJ5001' and lcc <= 'PJ5060': # Hebrew literature
            return 0
        elif lcc >= 'PJ7501' and lcc <= 'PJ8517': # Arabic literature
            return 0
        elif lcc >= 'PK2030' and lcc <= 'PK2212': # Hindu and Urdu literatures
            return 0
        elif lcc >= 'PK2901' and lcc <= 'PK5471': # Indo-Aryan literature
            return 0
        elif lcc >= 'PK6400' and lcc <= 'PK6599': # New Persian literature
            return 0
        elif lcc >= 'PK8501' and lcc <= 'PK8832': # Armenian literature
            return 0
        elif lcc >= 'PL-700' and lcc <= 'PL-889': # Japanese literature
            return 0
        elif lcc >= 'PL-950' and lcc <= 'PL-998': # Korean literature
            return 0
        elif lcc >= 'PL2250' and lcc <= 'PL3208': # Chinese literature
            return 0
        elif lcc >= 'PL3512' and lcc <= 'PL3517': # Malaysian and Singapore literatures
            return 0
        elif lcc >= 'PN---1' and lcc <= 'PN9999': # Literature (General)
            return 0
        elif lcc >= 'PQ---1' and lcc <= 'PQ9999': # French, Italian, Spanish, Portuguese literature
            return 0
        elif lcc >= 'PR---1' and lcc <= 'PR9999': # English literature
            return 0
        elif lcc >= 'PS---1' and lcc <= 'PS9999': # American and Canadian literature
            return 0
        elif lcc >= 'PT---1' and lcc <= 'PT9999': # German and other germanic languages
            return 0
        elif lcc.startswith('PZ'): # Fiction
            return 0
        else:
            return 1 # it's a language resource!
    else:
        return 0
    pass


# get xml file from command line
if len(sys.argv) != 2:
    print "one xml filename param required"
    sys.exit()
else:
    xmlfile = sys.argv.pop()

# open output file (utf-8)
outfile = codecs.open(os.path.basename(xmlfile) + '.txt', 'w', 'utf-8')
print "processing %s" % xmlfile
doc = etree.parse(xmlfile)
root = doc.getroot()
ctr = 0
skipped = 0
dcNS = '{http://purl.org/dc/elements/1.1/}'
dctermsNS = '{http://purl.org/dc/terms/}'
for rec in root:
    ctr += 1
    lcc = rec.findtext(dctermsNS + 'lcc')
    if lcc is None:
        skipped += 1
        continue
    text = ''
    subj = combineElements(rec.findall(dcNS + 'subject'))
    if subj is not None:
        text += subj
    title = combineElements(rec.findall(dcNS + 'title'))
    if title is not None:
        text += title
    desc = combineElements(rec.findall(dcNS + 'description'))
    if desc is not None:
        text += desc
    if (isLanguageResource(lcc)):
        answer = 'YES'
    else:
        answer = 'NO'
    if ctr % 1000 == 0:
        sys.stdout.write(".")

    outfile.write("%s\t%s\t%s\n" % (str(ctr) + '_' + lcc, answer, text))
print "%s recs skipped because of no lcc" % skipped
print "%s recs total" % ctr
