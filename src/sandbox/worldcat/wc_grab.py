import httplib
import re
import time
import random
import codecs

def strip_tags(value):
    "Return the given HTML with all tags stripped."
    return re.sub(r'<[^>]*?>', '', value) 

def getwccontent(q):
    headers = {   
        'User-agent': 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2',
        'Accept': 'text/html, application/xhtml+xml, application/xml;q=0.9, */*;q=0.8',
        'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
'Accept-Encoding': 'deflate',
'Accept-Language': 'en-us,en;q=0.5',
'Connection': 'keep-alive',
'Keep-Alive': '300'
    }
    q = q.replace(' ','+').replace(':', '%3A')
    #script_uri = '/scripts/envecho.py?%s' % params 
    script_uri = '/search?q=%s' % q 
    
    print script_uri
    conn = httplib.HTTPConnection('www.worldcat.org')
    #conn = httplib.HTTPConnection('www.hirtfamily.net')
    conn.request("GET", script_uri, '', headers)
    response = conn.getresponse()
    print response.status, response.reason
    content = response.read()
    return strip_tags(content)
    
def gethits(text):
    m = re.search(r'Results \d+-\d+ of about (\d+)', text)
    if m is not None:
        return m.group(1)
    else:
        return 0

def normalize2ascii(str):
    # from Aaron Bentley's comment on
    # http://code.activestate.com/recipes/251871/
    import unicodedata
    return unicodedata.normalize('NFKD', str).encode('ASCII', 'ignore')



outfile = codecs.open('lcsh_hits_map.tab', 'w', 'latin-1')
ctr = 0
for line in codecs.open('lcsh_map.tab','r', 'latin-1'):
    ctr += 1
    line = line.strip()
    line = line.replace('"', '')
    (sh, code) = line.split('\t')
    if sh.find('language') == -1 and sh.find('dialect') == -1:
        sh = sh + ' language'

    query = 'su:"%s"' % normalize2ascii(sh)
    hits = gethits(getwccontent(query))
    print "%d: Found %s hits for '%s'" % (ctr, hits, query)
    outfile.write('%s\t%s\t%s\t%s\n' % (sh, code, hits, query))
    outfile.flush()

    # wait a few seconds
    time.sleep(random.randint(4,8))
