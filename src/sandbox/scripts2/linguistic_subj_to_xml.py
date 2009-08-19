import sys

# use prep_linguistic_subj_tabfile.py to prepare the tab file from Joan

# This script processes a tab-delimited text file and outputs XSLT code to represent the conditional statements used to process the OLAC linguistic subject from the LC Subject Headings

try:
    tabfile = open(sys.argv.pop(1))
except:
    print "please specify a tab-delimited file to process"
    sys.exit(2)

for line in tabfile.read().splitlines():
    subject,field = line.split('\t')
    print "<xsl:if test=\"starts-with($subject,'%s')\">" % subject
    print "<dc:subject xsi:type='olac:linguistic'>%s</dc:subject>" % field
    print "</xsl:if>"
