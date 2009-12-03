# reduce lines
import codecs
import sys


# get input file from command line
if len(sys.argv) != 3:
    print "usage: reducelines.py [factor] [inputfile]"
    sys.exit()
else:
    infile = sys.argv.pop()
    factor = int(sys.argv.pop())
print "factor = %s" % factor

input = codecs.open(infile, 'r', 'utf-8')
outfile = infile + '.reduced'
output = codecs.open(outfile, 'w', 'utf-8')
print "output file is %s" % outfile

ctr = 1
written = 0
for line in input:
    if ctr % factor == 0:
        output.write(line)
        written += 1
    ctr += 1
print "%s lines total" % ctr
print "%s lines written" % written
