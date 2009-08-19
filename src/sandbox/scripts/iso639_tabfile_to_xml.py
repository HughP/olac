import sys
import codecs

# This script processes a tab-delimited text file and outputs XSLT conditional statements for use in the iso639.xsl file of the MARC2OLAC process

# a tab-delimited UNICODE file with 3 columns is expected as input
# use excel and export as "Unicode Text" (which is actually UTF-16, I think)
#column order must be:
# LCCN     Heading     Identifier(iso639-3)
# do NOT include column headers in the file


# this is how you run it:
# python iso639_tabfile_to_xml.py [tabfile]

# customize the XSL below, if necessary

try:
    tabfile = codecs.open(sys.argv.pop(1),'r','utf-16')
except:
    print "please specify a tab-delimited file to process"
    sys.exit(2)

lccn2code = {}
lcsh2code = {}
print "lcsh will have 'language' appended to every one that does not contain 'language' or 'dialect' in it already"
for line in tabfile:
    lccn,lcsh,code = line.strip().split('\t')
    if lccn == '' or lcsh == '' or code == '':
        sys.stderr.write('Error on line: %s\n') % line
    lcsh = lcsh.strip(' "').lower()
    if lcsh.find('language') == -1 and lcsh.find('dialect') == -1:
        lcsh = lcsh + ' language'
    lccn2code[lccn] = code
    lcsh2code[lcsh] = code

lccn_out = codecs.open('lccn.out','w','utf-8')
for lccn in lccn2code:
    lccn_out.write(u"<xsl:when test=\"$lccn = '%s'\">%s</xsl:when>\n" \
        % (lccn,lccn2code[lccn]))

lcsh_out = codecs.open('lcsh.out','w','utf-8')
for lcsh in lcsh2code:
    lcsh_out.write(u"<xsl:when test=\"$lcsh_lc = &quot;%s&quot;\">%s</xsl:when>\n" \
            % (lcsh,lcsh2code[lcsh]))
lcsh_out.close()
lccn_out.close()
print "outputfiles are lccn.out and lcsh.out"
