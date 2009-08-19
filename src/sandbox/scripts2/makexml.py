import pymarc
import libxml2

f = open('test.xml','w')
ctr = 0
marcset = pymarc.MARCReader(open('c:\olac\gial.marc'))
for rec in marcset:
    #if rec['590'] is not None and rec[590]['2'].startswith('Ethnologue'):
    if rec['590'] is not None and rec['590']['2'] is not None and \
        rec['590']['2'].startswith('Ethnologue 15'):
        print rec['001'].value() + ': ' + rec['590']['a']
        xmlrec = pymarc.record_to_xml(rec)
        xmlrec = libxml2.parseDoc(xmlrec)
        f.write(xmlrec.serialize(None,1))
    ctr += 1
    #if ctr == 2: break
f.close()
