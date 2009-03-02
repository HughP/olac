from mod_python import apache
import MySQLdb

def handler(req):
    con = MySQLdb.connect(read_default_file='/home/olac/.my.cnf')
    cur = con.cursor()

    req.content_type = "text/xml"
    req.send_http_header()
    req.write(
        '<?xml version="1.0" encoding="UTF-8"?>'
        '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')

    cur.execute("select RepositoryIdentifier, CurrentAsOf from OLAC_ARCHIVE")
    for row in cur.fetchall():
        repoid, date = row
        if date is None: date="2008-03-08"
        req.write("<url><loc>http://www.language-archives.org/archive_records/%s</loc><lastmod>%s</lastmod></url>" % (repoid, date))
    req.write("</urlset>")
    
    cur.close()
    con.close()
    return apache.OK
