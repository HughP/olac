import sys
import codecs
import random

# get xml file from command line
if len(sys.argv) != 4:
    print "arguments: [pre-classified data] [classifier results] [output file]"
    sys.exit()
else:
    outputfile = sys.argv.pop()
    resultsfile = sys.argv.pop()
    datafile = sys.argv.pop()

# make content list
content = {}
for line in codecs.open(datafile, 'r', 'latin-1'):
    tokens = line.split('\t')
    if len(tokens) == 3:
        id = tokens[0]
        c = tokens[2]
        content[id] = c

# fill up results list
# make YES and NO lists
yes = []
no = []
for line in open(resultsfile):
    tokens = line.strip().split()
    id = tokens[0].strip()
    ans,prob = tokens[1].strip().split(':')
    prob = prob[0:4]
    if id in content:
        c = content[id]
    else:
        c = ''
    if ans == 'YES':
        yes.append([id, ans, prob, c])
    else:
        no.append([id, ans, prob, c])

# percent of YES lines in the quiz
yes_percent = 30
# number of lines in the quiz
quiz_lines = 100

# number of lines to include from each
yes_lines = int(quiz_lines * yes_percent / 100)
no_lines = quiz_lines - yes_lines

# make results list
results = []
for i in range(0,yes_lines):
    results.append(random.choice(yes))
for i in range(0,no_lines):
    results.append(random.choice(no))

# shuffle results list
random.shuffle(results)

# write results list to file
outfile = codecs.open(outputfile, 'w', 'utf-8')
outfile.write("id\tcomputer_guess\tprobability\thuman_answer\tcontent\n")
for i in results:
    outfile.write("%s\t%s\t%s\t\t%s" % (i[0], i[1], i[2], i[3])) 
outfile.close()
