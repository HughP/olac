# get_hit_files_imap.py
#
# AUTHOR Matthew Baxter (July 2008)
#
# SUMMARY
# Google Analytics is scheduled to generate weekly reports on the number of
# hits and outgoing link clicks for item pages, giving the number of each
# for every archive. It emails those reports to a dummy Gmail account.
#
# This script reads emails from the dummy gmail account, extracting the
# reports and saving them to the current directory.
#
# INVOCATION
# (noargs)  Reads all emails that have not been read.	
# -a        Reads all emails.
#
# DETAILS
#
# Google Analytics sends the reports as CSV attachments with filenames of
# the form:
# "Analytics_www.language-archives.org_FROM-TO_(Item_Hits_&_Clicks).csv"
# and this script saves them in the form: "ga_FROM-TO.csv"
# where both FROM and TO are of the form yyyymmdd
#
# There is some commented-out code relating to my attempt to only get emails
# received since the last execution of the script. GMail was returning "BAD"
# on the SEARCH command (to indicate a badly formed search string). Since I
# was following the RFC 2060 standard to the letter (as far as I could tell)
# I abandoned this and now use the \Seen flag to check whether to read an
# email or not.
#

import sys
import imaplib
import email
import re

# The months, as defined by RFC 2060 (IMAP).
#date_month_list = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
#                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

# See if we need to get all emails
get_all = False
if len(sys.argv) > 1 and sys.argv[1] == '-a':
    get_all = True
#else:
#        try:
#                date_file = open(".get_hit_files_imap.date", "r")
#                from_date = datetime.date.fromordinal(int(date_file.read()))
#                date_file.close()
#        except IOError:
#                get_all = True

# Connect to GMail using IMAP over SSL
M = imaplib.IMAP4_SSL("imap.gmail.com")
M.login("olac.hit.monitor@gmail.com", "olac2357")
M.select()

# Get a list of emails
if get_all:
    typ, data = M.search(None, 'ALL')
else:
    #from_date.day
    # searchstr = 'ALL SINCE "' + ('%02u' % from_date.day) + "-" \
    #                 + date_month_list[from_date.month] + "-" + \
    #                 ('%04u' % from_date.year)+'"'
    # typ, data = M.search(None, searchstr)
    typ, data = M.search(None, 'UNSEEN')

# Loop through each email
#work_was_done = False
for num in data[0].split():
    typ, data = M.fetch(num, '(RFC822)')
    message = email.message_from_string(data[0][1])

    # Mark message as Read.
    M.store(num, '+FLAGS.SILENT', '\\Seen')
    #print '\nMessage %s\n%s\n%s' % \
    #    (num, message.get("Subject"), message.get("From"))
    if message.get("Subject").startswith("Analytics www.language-archives"):   
        #print email.iterators._structure(message)
        for part in message.walk():
            if part.get_content_type() == 'application/octet-stream':
                filename = re.sub(r"\s+", "", part.get_filename())
                filename = filename.split('_')[2]
                print filename.replace("-"," ")
                filename = "ga_" + filename + ".csv"
                fp = open(filename, 'wb')
                fp.write(part.get_payload(decode=True))
                fp.close()
                #print "Extracted an attachment."
#               work_was_done = True

# Write a file when emails were last checked
#if work_was_done:
#        date_file = open(".get_hit_files_imap.date", "w")
#        date_file.write("%d" % datetime.date.today().toordinal())
#        date_file.close()

M.close()
M.logout()

