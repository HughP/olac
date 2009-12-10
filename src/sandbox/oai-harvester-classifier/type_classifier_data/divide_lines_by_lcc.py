import sys

if len(sys.argv) != 3:
    print "usage: %s [input file] [output dir]" % sys.argv.pop(-1)
    sys.exit()
else :
    outdir = sys.argv.pop()
    infile = sys.argv.pop()

names = {}
print "reading file..."
for line in open(infile):
    id, label, content = line.split('\t')
    name = id[0:2].upper().strip('-')
    if name in names:
        names[name].append(line)
    else:
        names[name] = []
        names[name].append(line)

print "outputting files..."
for f in sorted(names):
    size = len(names[f])
    file = open('%s/%s.txt' % (outdir, f), 'w')
    file.writelines(sorted(names[f]))
    file.close()
    print f,size,"lines"

