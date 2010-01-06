import sys
import codecs
import random

# get args from command line
if len(sys.argv) != 4:
    print "arguments: [pre-classified data] [classifier results] [output file]"
    sys.exit()
else:
    outputfile = sys.argv.pop()
    resultsfile = sys.argv.pop()
    datafile = sys.argv.pop()

# store ids of YES items
yes = []
for line in open(resultsfile):
    tokens = line.strip().split()
    id = tokens[0].strip()
    ans,prob = tokens[1].strip().split(':')
    prob = prob[0:4]
    if ans == 'YES':
        yes.append(id)

# output YES lines
outfile = codecs.open(outputfile, 'w', 'latin-1')
for line in codecs.open(datafile, 'r', 'latin-1'):
    tokens = line.split('\t')
    if len(tokens) == 3:
        id = tokens[0].strip()
        content = tokens[2].strip()
        if id in yes:
            outfile.write("%s\t\t%s\n" % (id, content))
outfile.close()
