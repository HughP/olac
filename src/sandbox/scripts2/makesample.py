import pymarc

f = open('gial_language_LCSH.marc','w')
ctr = 0
marcset = pymarc.MARCReader(open('c:\olac\gial.marc'))
for rec in marcset:
    for tag in (600,610,611,630,650):
        tag = str(tag)

        # condition for inclusion into the sample
        if (rec[tag] and rec[tag].value().lower().find('language') != -1):
            ctr += 1
            f.write(rec.as_marc21())
            break
f.close()
print '%d record(s) written' % ctr
