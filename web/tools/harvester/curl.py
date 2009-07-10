"""
MyUrl and MyCurl classes are borrowed from the original webcol framework and
then modified to suit our purposes.  So, don't confuse these with the
original classes.
"""

import sys
import pycurl
from StringIO import StringIO
import traceback
import time
import re
import random
import urlparse

__all__ = ["MyUrl", "MyCurl", "StopFetching"]

class StopFetching: pass

class MyUrl(unicode):
    def __init__(self, *args):
        unicode.__init__(self, *args)
        self.referer = None
        self.postdata = None
        self.offset = 0

class MyCurl:

    def __init__(self, writefunc, statusfunc, resetfunc=None, debug=False):

        self.writefunc = writefunc
        self.statusfunc = statusfunc
        if resetfunc:
            self.resetfunc = resetfunc
        else:
            self.resetfunc = lambda: None
        self.debug = debug

        # this part of header doesn't change
        self._header = [
            "Accept: text/xml, text/*;q=0.5",
            "Accept-Language: en-us, en, *;q=0.7",
            "Accept-Charset: utf-8, *;q=0.5",
            "Keep-Alive: 300",
            "Connection: keep-alive",
            "User-Agent: OLAC Harvester",
            ]

        # dynamic portion of header
        self._cookies = {}

    def _makeCookie(self):
        s = ""
        for k,v in self._cookies.items():
            s += k + "=" + v + "; "
        return s.rstrip("; ")
        
    def _mycurl(self, url, head=False):
        self._headerout = []
        curl = pycurl.Curl()
        curl.setopt(pycurl.URL, unicode(url).encode('utf-8'))
        if head:
            curl.setopt(pycurl.NOBODY, 1)
        else:
            curl.setopt(pycurl.HTTPGET, 1)
        curl.setopt(pycurl.HTTPHEADER, self._header)
        curl.setopt(pycurl.ENCODING, "gzip,deflate")
        if url.referer: curl.setopt(pycurl.REFERER, str(url.referer))
        cookie = self._makeCookie()
        if cookie: curl.setopt(pycurl.COOKIE, str(cookie))
        if url.postdata is not None:
            curl.setopt(pycurl.POSTFIELDS, url.postdata)
        if url.offset > 0:
            curl.setopt(pycurl.RESUME_FROM, url.offset)
        curl.setopt(pycurl.WRITEFUNCTION, self.writefunc)
        curl.setopt(pycurl.VERBOSE, 0)
        curl.setopt(pycurl.DEBUGFUNCTION, self._callback_debugFunc)
        curl.setopt(pycurl.HEADERFUNCTION, self._callback_headerFunc)
        # timeout works against large repository hosted on a slow machine
        curl.setopt(pycurl.TIMEOUT, 1200)
        try:
            stderr = sys.stderr
            sys.stderr = open('/dev/null','w')
            curl.perform()
            sys.stderr = stderr
        except pycurl.error, e:
            sys.stderr = stderr
            curl.close()
            if e[0] == 23:  # CURLE_WRITE_ERROR
                # this comes from a client, so it's okay not to report it
                # back to the client
                return
            else:
                raise
        curl.close()

    def _callback_headerFunc(self, data):
        self._headerout.append(data)
        if len(self._headerout) == 1:
            try:
                self.statusfunc(data)
            except StopFetching:
                return -1
        else:
            i = data.find(':')
            field = data[:i].lower()
            fieldVal = data[i+1:].strip()
            if field == 'set-cookie':
                cookie = fieldVal.split(';')[0]
                i = cookie.find('=')
                key = cookie[:i].strip()
                value = cookie[i+1:].strip()
                self._cookies[key] = value
            elif field == 'location':
                self._location = fieldVal
        return len(data)
        
    def _callback_debugFunc(self, infotype, data):
        if self.debug:
            if infotype == pycurl.INFOTYPE_TEXT:
                file("text.txt","a").write(data)
            elif infotype == pycurl.INFOTYPE_HEADER_IN:
                file("header_in.txt","a").write(data)
            elif infotype == pycurl.INFOTYPE_HEADER_OUT: 
                file("header_out.txt","w").write(data)
            elif infotype == pycurl.INFOTYPE_DATA_IN:
                file("data_in.dat", "wb").write(data)
            elif infotype == pycurl.INFOTYPE_DATA_OUT:
                file("data_out.dat", "wb").write(data)
        return 0

    def fetch(self, url, head=False):
        """
        fetch url
        custom options AUTOREFERER & FOLLOWLOCATION are implemented
        @param head: header only
        """
        try:
            self._location = None
            self._mycurl(url, head)
            while self._location is not None:
                self.resetfunc()
                oldurl = url
                url = MyUrl(urlparse.urljoin(oldurl, self._location))
                url.referer = oldurl
                self._location = None
                self._mycurl(url, head)
        except StopFetching:
            pass
        if head: return self._headerout

