import pymarc
import libxml2
import sys
import utils

# get params from command line
try:
    input = sys.argv.pop(1)
    output = sys.argv.pop(1)
except:
    print "you need two arguments: input_file output_file"
    sys.exit(2)

f = open(output,'w')
ctr = 0
error = 0
marcset = pymarc.MARCReader(open(input))
f.write('<?xml version="1.0" encoding="UTF-8" ?>\n<collection xmlns="http://www.loc.gov/MARC21/slim">')
for rec in marcset:
    try:
        xmlrec = pymarc.record_to_xml(rec)
        #xmlrec = libxml2.parseDoc(xmlrec)
        f.write(xmlrec + '\n')
        ctr += 1
    except IndexError:
        print "error in record",rec[001].value()
        error += 1
    if ctr % 500 == 0: print "writing %sth record..." % ctr
    if ctr > 4500: print rec['001'].value(),rec['245'].value()
    #if ctr == 100: break
f.write('</collection>')
f.close()

#print "formatting xml..."
#xmlrec = libxml2.parseDoc(utils.file2string(output))
#f = open(output,'w')
#f.write(xmlrec.serialize(None,1))
#f.write(xmlrec.serialize(None,2))
#f.close()

print "%s MARC records written as XML to %s" % (ctr,output)
if (error > 0): print "%s error(s) encountered" % error
