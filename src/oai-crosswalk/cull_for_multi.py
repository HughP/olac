#!/usr/bin/env python
import sys
import codecs
sys.stderr = codecs.getwriter('utf8')(sys.stderr)

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
    id,probability = line.strip().split('\t')
    id = id.strip()
    print "id: '%s' with P(x): %s" % (id, probability)
    yes.append(id)

# output YES lines
outfile = codecs.open(outputfile, 'w', 'utf-8')
for line in codecs.open(datafile, 'r', 'utf-8'):
    tokens = line.split('\t')
    #if len(tokens) == 3:
    if len(tokens) >= 2:
        id = tokens[0].strip()
        #content = tokens[2].strip()
        if id in yes:
            #outfile.write("%s\t\t%s\n" % (id, content))
            outfile.write(line)
    else:
        #print>>sys.stderr, "error: unparseable data line [", line.encode("utf8"), "]"
        print "error: unparseable data line"
outfile.close()

