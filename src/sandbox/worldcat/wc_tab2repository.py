import string
import codecs
from datetime import date

tmpl = string.Template(open('wc_olac_record.tmpl').read())
file = codecs.open('olac_recs2.xml', 'w','latin-1')
err = codecs.open('zero_hits2.tab', 'w', 'latin-1')

vars = {'date': date.today().strftime('%Y-%m-%d')}

ctr = 0
errctr = 0
for line in codecs.open('lcsh_hits_map_new.tab', 'r', 'latin-1'):
    line = line.strip()
    (sh, code, hits, q) = line.split('\t')

    if hits == '0':
        err.write(line + '\n')
        errctr += 1
        continue
    ctr += 1

    # make an id by normalizing the subject heading
    id = sh.lower().replace(' ','_').replace('-','_').replace(')','').replace('(','')

    vars['subject_heading'] = sh
    vars['id'] = id
    vars['code'] = code
    vars['hits'] = hits
    vars['url'] = 'http://www.worldcat.org/search?%s' % \
           q.replace(' ','+').replace(':', '%3A') 

    file.write(tmpl.substitute(vars))

print '%d olac records created; %d lines skipped because of zero hits' % \
        (ctr, errctr)
file.close()
