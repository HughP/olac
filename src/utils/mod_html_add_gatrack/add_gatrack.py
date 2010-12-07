import sys
import re

data = open(sys.argv[1]).read()
pat = re.compile(r'(.*?)([ \t]*)(<title>.*?</title>)((?:\n|\r|\n\r)?)(.*)', re.I|re.S)
m = pat.search(data)
if m:
    sys.stdout.write(m.group(1))
    indent = m.group(2)
    sys.stdout.write(indent)
    sys.stdout.write(m.group(3))
    sys.stdout.write('\n')
    sys.stdout.write(indent)
    sys.stdout.write('<script type="text/javascript" src="/js/gatrack.js"></script>')
    sys.stdout.write('\n')
    if m.group(4) == '':
        sys.stdout.write(indent)
    sys.stdout.write(m.group(5))
else:
    sys.stdout.write(data)

