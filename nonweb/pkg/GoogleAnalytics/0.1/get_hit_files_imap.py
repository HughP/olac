# get_hit_files_imap.py
#
# AUTHOR  Haejoong Lee, Matthew Baxter
# CREATED July 2008
# UPDATED February 2009
#
# Google Analytics is scheduled to generate monthly reports on the number of
# hits and outgoing link clicks for item pages, giving the number of each
# for every archive. It emails those reports to a dummy Gmail account.
#
# This script reads emails from the dummy gmail account, extracting the
# reports and saving them to the current directory. It downloads emails that
# have been received after the last checked date. The last checked date is
# obtained from the GoogleAnalyticsReports table of the OLAC database.
#
# Google Analytics sends the reports as CSV attachments with filenames of
# the form:
# "Analytics_www.language-archives.org_MONTH_(Item_Hits_&_Clicks).csv"
# and this script saves them in the form: "ga_MONTH.csv"
# where MONTH of the form yyyymm
#

import sys
import imaplib
import email
import re
import MySQLdb
import datetime
import olac

# Connect to GMail using IMAP over SSL
M = imaplib.IMAP4_SSL("imap.gmail.com")
M.login(olac.olacvar('ga/gmail_user'), olac.olacvar('ga/gmail_passwd'))
M.select()

con = MySQLdb.connect(host=olac.olacvar('mysql/host'),
                      user=olac.olacvar('mysql/user'),
                      passwd=olac.olacvar('mysql/passwd'),
                      db=olac.olacvar('mysql/olacdb'))
cur = con.cursor()
cur.execute("select max(end_date) from GoogleAnalyticsReports")
date = cur.fetchone()[0]
if date is None:
    typ, data = M.search(None, 'ALL')
else:
    date += datetime.timedelta(1)
    typ, data = M.search(None, 'SINCE', date.strftime('%d-%b-%Y'))

# this pattern matches with only Matthew's emails
subjpat = re.compile(r'^hits_and_clicks$', re.S)

# Loop through each email
for num in data[0].split():
    typ, data = M.fetch(num, '(RFC822)')
    message = email.message_from_string(data[0][1])

    # Mark message as Read.
    M.store(num, '+FLAGS.SILENT', r'\Seen')
    subj = message.get("Subject")
    if not subjpat.match(message.get("Subject")): continue
    for part in message.walk():
        if part.get_content_type() in ('application/octet-stream','text/csv'):
            year_month = part.get_filename().split()[6].split('-')[0][:6]
            filename = "ga_" + year_month + ".csv"
            fp = open(filename, 'wb')
            fp.write(part.get_payload(decode=True))
            fp.close()
            print filename

M.close()
M.logout()

