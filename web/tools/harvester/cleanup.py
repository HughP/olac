import os
import sys
import MySQLdb
import datetime
from optionparser import OptionParser

def remove_unregistered_archives():
    sql = "delete oa.*, ai.*, me.* from (select oa.Archive_ID from OLAC_ARCHIVE oa left join ARCHIVES a on oa.RepositoryIdentifier=a.ID and oa.BaseURL=a.BaseURL where a.ID is null) x, OLAC_ARCHIVE oa, ARCHIVED_ITEM ai, METADATA_ELEM me where x.Archive_ID=oa.Archive_ID and oa.Archive_ID=ai.Archive_ID and ai.Item_ID=me.Item_ID"
    cur.execute(sql)

def remove_archives_with_no_baseurl():
    sql = "delete oa.*, ai.*, me.* " \
          "from OLAC_ARCHIVE oa, ARCHIVED_ITEM ai, METADATA_ELEM me " \
          "where (oa.BaseURL='' or oa.BaseURL is null) and " \
          " ai.Archive_ID=oa.Archive_ID and ai.Item_ID=me.Item_ID"
    cur.execute(sql)

def remove_records_with_no_archiveid():
    sql = "delete ai.*, me.* " \
          "from ARCHIVED_ITEM ai, METADATA_ELEM me " \
          "where ai.Archive_ID is null and ai.Item_ID=me.Item_ID"
    cur.execute(sql)
    
def remove_redundant_records():
    sql = "delete ai.*, me.* from METADATA_ELEM me, ARCHIVED_ITEM ai, (%s) x " \
          "where ai.OaiIdentifier=x.OaiIdentifier and ai.%s < m " \
          "and ai.Item_ID=me.Item_ID"
    subsql = "select OaiIdentifier, max(%s) m from ARCHIVED_ITEM " \
             "group by OaiIdentifier having count(*) > 1"

    for f in ("DateStamp", "Item_ID"):
        cur.execute(sql % (subsql % f, f))

if __name__ == "__main__":
    usageString = """\
Usage: %(prog)s [-h] -c <mycnf> [-H <host>] [-d <db>]

    options:

      -h          print this message and exit
      -c <mycnf>  mycnf file
      -H <host>   hostname of the mysql server
      -d <db>     name of the olac database

""" % {"prog":os.path.basename(sys.argv[0])}
    
    def usage(msg=None):
        print >>sys.stderr, usageString
        if msg:
            print >>sys.stderr, "ERROR:", msg
            print >>sys.stderr
        sys.exit(1)
        
    op = OptionParser(
        "*-h",
        "-c:",
        "*-H:",
        "*-d:",
        )
    try:
        op.parse(sys.argv[1:])
    except OptionParser.ParseError, e:
        usage(e.message)
    if op.get('-h'): usage()
    
    mycnf = op.getOne('-c')
    host = op.getOne('-H')
    db = op.getOne('-d')

    opts = {"read_default_file":mycnf}
    if host: opts["host"] = host
    if db: opts["db"] = db
    con = MySQLdb.connect(**opts)
    cur = con.cursor()

    t = lambda: datetime.datetime.now().strftime("[%Y-%m-%d %H:%M:%d]")
    print t(), "Starting database cleanup."
    print t(), "Removing unregistered archives..."
    remove_unregistered_archives()
    print t(), "Removing archives with no BaseURL..."
    remove_archives_with_no_baseurl()
    print t(), "Removing records with no Archive_ID..."
    remove_records_with_no_archiveid()
    print t(), "Removing redundant records..."
    remove_redundant_records()
    print t(), "Database cleanup finished."

    con.commit()
    cur.close()
    con.close()
