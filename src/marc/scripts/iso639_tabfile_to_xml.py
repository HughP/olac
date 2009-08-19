import sys
import codecs

# This script processes a tab-delimited text file and outputs XSLT conditional statements for use in the iso639.xsl file of the MARC2OLAC process

# a tab-delimited UNICODE file with 3 columns is expected as input
# use excel and export as "Unicode Text" (which is actually UTF-16, I think)
#column order must be:
# lcsh     subfield-y     Identifier(iso639-3)
# do NOT include column headers in the file


# this is how you run it:
# python iso639_tabfile_to_xml.py [tabfile]

# customize the XSL below, if necessary

try:
    tabfile = codecs.open(sys.argv.pop(1),'r','utf-16')
except:
    print "please specify a tab-delimited file to process"
    sys.exit(2)

#print "lcsh will have 'language' appended to every one that does not contain 'language' or 'dialect' in it already"
lcsh_out = codecs.open('lcsh.out','w','utf-8')
ctr = 0
for line in tabfile:
    ctr += 1
    #print line
    lcsh, y, code = line.split('\t')
    code = code.strip()
    if lcsh == '' or code == '':
        continue
        sys.stderr.write('Error on line %d') % ctr
    lcsh = lcsh.strip(' "').lower()
    if y != '': lcsh = lcsh + u'--' + y.strip(' "').lower()
    if lcsh.find('language') == -1 and lcsh.find('dialect') == -1:
        lcsh = lcsh + ' language'
    lcsh_out.write(u"<xsl:when test=\"starts-with($lcsh_lc, &quot;%s&quot;)\">%s</xsl:when>\n" \
            % (lcsh,code))

lcsh_out.close()
print "outputfile is lcsh.out"
