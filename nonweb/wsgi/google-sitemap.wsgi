import MySQLdb
import olac
import re

class GoogleSitemap:
    def __init__(self, environ, start_response):
        self.environ = environ
        self.respond = start_response
        self.con = MySQLdb.connect(
            host = olac.olacvar('mysql/host'),
            db = olac.olacvar('mysql/olacdb'),
            user = olac.olacvar('mysql/user'),
            passwd = olac.olacvar('mysql/passwd'),
            )
        self.cur = self.con.cursor(MySQLdb.cursors.SSCursor)
        self.baseurl = olac.olacvar('baseurl')

    def __iter__(self):
        headers = [('Content-type','text/xml')]
        self.respond('200 OK', headers)
        yield '<?xml version="1.0" encoding="UTF-8"?>\n'
        yield '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'

        if self.environ['PATH_INFO'] == '/general':
            sql = """
            select RepositoryIdentifier, max(DateStamp)
            from OLAC_ARCHIVE oa, ARCHIVED_ITEM ai
            where oa.Archive_ID=ai.Archive_ID group by oa.Archive_ID
            """
            self.cur.execute(sql)
            row = self.cur.fetchone()
            template = "<url><loc>%s/archive_records/%%s</loc><lastmod>%%s</lastmod></url>\n" % self.baseurl
            while row:
                repoid, date = row
                if date is None: date='2008-03-08'
                yield template % (repoid, date)
                row = self.cur.fetchone()

            sql = """
            select distinct Code, max(DateStamp)
            from (METADATA_ELEM me, ISO_639_3, EXTENSION ex)
            left join ARCHIVED_ITEM ai on me.Item_ID=ai.Item_ID
            where ex.Type='language' and ex.Extension_ID=me.Extension_ID
            and Code=Id group by Id
            """
            self.cur.execute(sql)
            row = self.cur.fetchone()
            template = "<url><loc>%s/language/%%s</loc><lastmod>%%s</lastmod></url>\n" % self.baseurl
            while row:
                langid, date = row
                yield template % (langid, date)
                row = self.cur.fetchone()

        elif re.match(r'^/items/\d+$', self.environ['PATH_INFO']):
            r = int(self.environ['PATH_INFO'].split('/')[-1])
            sql = """
            select OaiIdentifier, DateStamp
            from ARCHIVED_ITEM
            where mod(Item_ID, 10) = %s
            """
            self.cur.execute(sql, r)
            row = self.cur.fetchone()
            template = "<url><loc>%s/item/%%s</loc><lastmod>%%s</lastmod></url>\n" % self.baseurl
            while row:
                oaiid, date = row
                if date:
                    yield template % (oaiid, date)
                row = self.cur.fetchone()
            
        yield '</urlset>\n'
application = GoogleSitemap
