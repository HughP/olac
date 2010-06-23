"""
Use Data Export API Protocol v2 to download Google Analytics reports.
This is a work in progress.
"""

import sys
import pycurl
import lxml.etree
import StringIO
import urllib
import olac
import datetime
import math

class Http:
    def __init__(self, url):
        self.out = StringIO.StringIO()
        self.curl = pycurl.Curl()
        self.curl.setopt(pycurl.URL, url)
        self.curl.setopt(pycurl.WRITEFUNCTION, self.out.write)

    def post(self, **kwarg):
        self.curl.setopt(pycurl.HTTPPOST, kwarg.items())

    def header(self, *args):
        self.curl.setopt(pycurl.HTTPHEADER, list(args))
        
    def go(self):
        self.curl.perform()
        self.out.seek(0)

    def result(self):
        return self.out.getvalue()
    
def get_auth_token(email, password):
    url = "https://www.google.com/accounts/ClientLogin"
    http = Http(url)
    http.post(accountType="GOOGLE",
              Email=email,
              Passwd=password,
              service="analytics",
              source="olac-gareport-1.0")
    http.go()

    for line in http.result().split('\n'):
        if line.startswith("Auth="):
            return line.strip()

def get_table_id(authtoken):
    url = "https://www.google.com/analytics/feeds/accounts/default"
    http = Http(url)
    http.header("GData-Version: 2",
                "Authorization:GoogleLogin " + authtoken)
    http.go()

    xml = lxml.etree.fromstring(http.result())
    ns = {'dxp': 'http://schemas.google.com/analytics/2009'}
    tableids = xml.xpath('//dxp:tableId/text()', namespaces=ns)
    return tableids[0]

def get_report(auth_token, table_id, start_date, end_date):
    """
    @param start_date: YYYY-MM-DD
    @param end_date: YYYY-MM-DD
    """
    url = "https://www.google.com/analytics/feeds/data"
    metrics = ['ga:pageviews', 'ga:uniquePageviews', 'ga:timeOnPage',
               'ga:bounces', 'ga:exits']
    query = {
        "ids": table_id,
        "start-date": start_date,
        "end-date": end_date,
        "dimensions": 'ga:pagePath',
        "metrics": ','.join(metrics),
        "filters": 'ga:pagePath=~^/archive_item_.*',
        "prettyprint": 'true'
        }
    url += '?' + urllib.urlencode(query.items())
    http = Http(url)
    http.header("GData-Version: 2",
                "Authorization: GoogleLogin " + auth_token)
    http.go()
    return http.result()

def quarter_limits(year, order):
    """
    @param year: String in YYYY format.
    @param order: 1, 2, 3 or 4.
    """
    dates = [
        ('01-01', '03-31'),
        ('04-01', '06-30'),
        ('07-01', '09-30'),
        ('10-01', '12-31')
        ]
    beg, end = dates[order-1]
    return year+'-'+beg, year+'-'+end

def this_quarter():
    t = datetime.datetime.now()
    order = int(math.ceil(t.month / 3.0))
    year = "%04d" % t.year
    return quarter_limits(year, order)

def previous_quarter():
    t = datetime.datetime.now()
    order = int(math.ceil(t.month / 3.0)) - 1
    year = t.year
    if order == 0:
        order = 4
        year -= 1
    year = "%04d" % year
    return quarter_limits(year, order)

authtok = get_auth_token(olac.olacvar('ga/gmail_user'),
                         olac.olacvar('ga/gmail_passwd'))

if not authtok:
    print "filed to obtain authorization token"
    sys.exit(1)

tableid = get_table_id(authtok)

beg, end = previous_quarter()
print get_report(authtok, tableid, beg, end)
