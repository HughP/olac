# this is a throwaway script for converting XSL file

types = {}
for line in open('type.xsl'):
    subj,type = line.strip().split('=')
    if type in types:
        types[type].append(subj)
    else:
        types[type] = [subj]

output = open('olac2LCsubj.txt', 'w')
for type in types:
    output.write("%s=%s\n" % (type, "|".join(types[type])))
output.close()
