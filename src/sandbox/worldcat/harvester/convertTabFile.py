import codecs

def normalize2ascii(str):
    # from Aaron Bentley's comment on
    # http://code.activestate.com/recipes/251871/
    import unicodedata
    return unicodedata.normalize('NFKD', str).encode('ASCII', 'ignore')

ctr = 0
subjFile = codecs.open('queries.tab.subj', 'w', 'latin-1')
subjTypeFile = codecs.open('queries.tab.subjAndType', 'w', 'latin-1')

# open type file
types = []
for line in open('olac2LCsubj.txt'):
    types.append(line.strip().split('=')[0])
    
for line in codecs.open('lcsh_map.tab','r', 'latin-1'):
    line = line.strip()
    line = line.replace('"', '')
    (sh, code) = line.split('\t')
    if sh.find('language') == -1 and sh.find('dialect') == -1:
        sh = sh + ' language'
    sh = normalize2ascii(sh)

    subjFile.write("%s\t%s\t\n" % (code, sh))
    for t in types:
        subjTypeFile.write("%s\t%s\t%s\n" % (code, sh, t))
subjFile.close()
subjTypeFile.close()

