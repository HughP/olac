# parse a tab-delimited file and output desired text

count = 0
for line in open('LCSHtoISO639-3_fullmatch.tab'):
    count += 1
    if (count == 1): continue # skip header
    (lccn,lcsh,id,name) = line.split('\t')
    print '<xsl:when test=\'$lcsh = "%s"\'>%s</xsl:when>' % (lcsh,id)
    
