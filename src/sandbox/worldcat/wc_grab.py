import urllib2
import urllib
import httplib
import re
import sys
import urlparse
import time
import random

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
    params = urllib.urlencode({'q': q})
    #script_uri = '/scripts/envecho.py?%s' % params 
    script_uri = '/search?%s' % params 
    
    conn = httplib.HTTPConnection('www.worldcat.org')
    #conn = httplib.HTTPConnection('www.hirtfamily.net')
    conn.request("GET", script_uri, '', headers)
    response = conn.getresponse()
    print response.status, response.reason
    content = response.read()
    return strip_tags(content)
    return content
    
def gethits(text):
    m = re.search(r'Results \d+-\d+ of about (\d+)', text)
    if m is not None:
        return m.group(1)
    else:
        return 0


#content = getwccontent('su:Ankave language')
#file = open('out')
#content = file.read()
#print content
#hits = gethits(content)
#print "hits = %s" % hits
#sys.exit()
outfile = open('lcsh_hits_map.tab', 'w')
ctr = 0
for line in open('lcsh_map.tab'):
    ctr += 1
    line = line.strip()
    line = line.replace('"', '')
    (sh, code) = line.split('\t')

    if sh.find('language') == -1 and sh.find('dialect') == -1:
        sh = sh + ' language'
    query = 'su:%s' % sh
    content = getwccontent(query)
    hits = gethits(content)
    print "%d: Found %s hits for '%s'" % (ctr, hits, query)
    outfile.write('%s\t%s\t%s\t%s\n' % (sh, code, hits, query))
    outfile.flush()

    # wait a few seconds
    time.sleep(random.randint(4,8))


