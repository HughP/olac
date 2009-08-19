import pymarc
import sys
import codecs

# marcseek.py
# Chris Hirt
# 3/28/09
#
# params: marcfilename outputfilename skip_recs num_recs
# skip_recs = the 0-based index number of the record to begin with.  So, if this is 1, then it will skip 1 record before writing out records
# num_recs = number of records to write out before stopping
# 

# get marc source file from command line
try:
    marcfile = sys.argv.pop(1)
except:
    print "please specify a valid marc input file"
    sys.exit(2)

# get output file from command line
try:
    outputfile = sys.argv.pop(1)
except:
    print "please specify an output filename"
    sys.exit(2)

# if num_recs parameter is omitted, output the rest of the file
num_recs = 0
if (len(sys.argv) > 1):
    num_recs = int(sys.argv.pop(1))

# required param (zero means start at beginning)
skip_recs = 0
if (len(sys.argv) > 1):
    skip_recs = int(sys.argv.pop(1))

ctr = 0
recs_written = 0
error_recs = 0
marcset = pymarc.MARCReader(codecs.open(marcfile,encoding='utf-8'))
#f = codecs.open(outputfile,encoding='utf-8',mode='w')
#writer = pymarc.MARCWriter(codecs.open(outputfile,encoding='utf-8',mode='w'))
writer = pymarc.MARCWriter(open(outputfile,'wb'))
for rec in marcset:
    if (ctr >= skip_recs):
        if (num_recs == 0 or recs_written < num_recs):
            try:
                writer.write(rec)
                recs_written += 1
            except UnicodeEncodeError:
                print 'unicode error!'
                error_recs += 1
marcset.close()
writer.close()
print '%d record(s) written' % recs_written
if error_recs > 0: print '%d error recs' % error_recs
