"""
Create an XML file of the following format:

<submissionPolicies>
  <policy>
    <repositoryName>...</repositoryName>
    <text>...</text>
  </policy>
  ...
</submissionPolicies>
"""

import MySQLdb
import olac
import codecs
import sys
import textwrap
import re
import xml.sax.saxutils

con = MySQLdb.connect(
    host = olac.olacvar('mysql/host'),
    user = olac.olacvar('mysql/user'),
    passwd = olac.olacvar('mysql/passwd'),
    db = olac.olacvar('mysql/olacdb'),
    charset = 'utf8'
    )

cur = con.cursor()

sql = """
select RepositoryName, RepositoryIdentifier, ArchivalSubmissionPolicy
from OLAC_ARCHIVE
where ArchivalSubmissionPolicy is not null
and RepositoryIdentifier not like '%olac-example.org'
"""

cur.execute(sql)

out = codecs.getwriter("utf-8")(sys.stdout)

print >>out, "<submissionPolicies>"
for row in cur.fetchall():
    print >>out, "<policy>"
    reponame = xml.sax.saxutils.escape(row[0])
    link = xml.sax.saxutils.escape(row[1])
    policy_text = re.sub(r"\s+", " ", row[2].strip())
    policy_text = xml.sax.saxutils.escape(policy_text)
    print >>out, "<repositoryName>%s</repositoryName>" % reponame
    print >>out, "<link>%s</link>" % link
    print >>out, "<text>\n%s\n</text>" % textwrap.fill(policy_text, 70)
    print >>out, "</policy>"
print >>out, "</submissionPolicies>"
