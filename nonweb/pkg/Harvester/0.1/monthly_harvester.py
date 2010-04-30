"""
This is a harvest scheduler. It selects a few archives and perform full
harvest. If invoked everyday, it makes sure that all archives are
full-harvested fairly and regularly.

Full harvest is necessary because incremental harvest cannot handle two things
reliably: deleted records and modified records without timestamp being updated.

For harvesting, we use harvester.py, but the data is stored in a different
database within the same MySQL server. If the harvest is successful, the stored
data is moved to the main database.

AUTHOR: Haejoong Lee <haejoong@ldc.upenn.edu>
CREATED: February 19, 2009
UPDATED: July 28, 2009
"""

import os
import sys
import MySQLdb
import datetime
import random
import subprocess
import re
try:
    import olac
except:
    olac = None
try:
    from optionparser import OptionParser
except ImportError:
    print >>sys.stderr, """
Can't find the 'optionparser' module, which can be obtained from here:
http://olac.svn.sourceforge.net/viewvc/*checkout*/web/lib/python/optionparser.py
"""
    sys.exit(1)

HARVEST_INTERVAL = 28
USESYSLOG = False

def logline(line):
    head = datetime.datetime.now().strftime("[%Y-%m-%d %H:%M:%S] ")
    sys.stdout.write(head + line + "\n")
    if USESYSLOG: olac.log(line)

    
def log(*args):
    line = " ".join([unicode(a) for a in args])
    line = re.sub(r'[\r\n]', ' ', line)
    logline(line)


def log2(lines):
    for line in lines: log(line)


def select_archives(archives, today=datetime.datetime.today()):
    N = len(archives)
    D = float(HARVEST_INTERVAL)
    C = sum([x[1] for x in archives]) / D  # avg number of records per day
    CA = max(1.0, N / D)  # avg number of archives per day

    if N == 0: return []

    bigs = []
    mediums = []
    smalls = []
    for row in archives:
        if row[1] > C:
            bigs.append(row)
        elif row[1] < C/2:
            smalls.append(row)
        else:
            mediums.append(row)

    # normalize archive size (row[1])
    # it's at most CA and at least 0.5
    for row in bigs: row[1] = CA
    for row in mediums: row[1] = 1.0
    if smalls:
        discount = (CA - 1.0) * len(bigs) / len(smalls)
        for row in smalls: row[1] = max(0.5, 1.0-discount)

    archives.sort(lambda row1,row2:cmp(row1[2],row2[2]))
    c = 0.0 # used capacity
    harvest_list = []
    for aid, size, date in archives:
        if (today-date).days >= D:
            p1 = CA - c           # current capacity (this can be negative)
            p = p1 / max(size,p1) # the chance that this archive is selected
            if random.random() <= p:
                if size >= CA: harvest_list = []
                harvest_list.append(aid)
                c += size
    return harvest_list


def get_all_archives(cur):
    cur.execute("""
    update OLAC_ARCHIVE set LastFullHarvest=substr(subdate(now(),7),1,10)
    where LastFullHarvest is null
    """)
    cur.execute("""
    select oa.BaseURL, count(*), timestamp(LastFullHarvest) d
    from OLAC_ARCHIVE oa
    left join ARCHIVED_ITEM ai /* left join in case there are no records */
    on oa.Archive_ID=ai.Archive_ID
    group by oa.Archive_ID
    """)
    return [list(row) for row in cur.fetchall()]


def remove_foreign_key_constraints(schema):
    # assumes that each element of the create table statement is separated by
    # a new line character
    L = [l for l in schema.split('\n') if 'FOREIGN KEY' not in l]
    schema = re.compile(r",\s*\)",re.S).sub(r")",'\n'.join(L))
    return schema


def initialize_tmp_db(cur, tmpdb, maindb):
    # we drop tables and recreate them to make sure that the schema
    # used by both tmpdb and maindb are identical
    
    # drop the core tables
    cur.execute("""
    drop table if exists
    %(tmpdb)s.CODE_DEFN,
    %(tmpdb)s.METADATA_ELEM,
    %(tmpdb)s.ARCHIVED_ITEM,
    %(tmpdb)s.ARCHIVE_PARTICIPANT,
    %(tmpdb)s.EXTENSION,
    %(tmpdb)s.OLAC_ARCHIVE
    """ % {"tmpdb":tmpdb})

    # create tables
    cur.connection.select_db(tmpdb)
    for tab in ["EXTENSION", "OLAC_ARCHIVE", "ARCHIVED_ITEM", "METADATA_ELEM",
                "ARCHIVE_PARTICIPANT",
                "CODE_DEFN" # maybe this isn't necessary
                ]:
        cur.execute("show create table %s.%s" % (maindb, tab))
        schema = cur.fetchone()[1]
        schema = remove_foreign_key_constraints(schema)
        cur.execute(schema)
    cur.connection.select_db(maindb)

    # copy extensions
    cur.execute("""
    insert ignore into %s.EXTENSION select * from %s.EXTENSION
    """ % (tmpdb, maindb))


def update_ids(cur, db, newaid, archiveid):
    # we update ids because we want to keep the original archive id
    template = "update %s.%s set Archive_ID=%%s where Archive_ID=%%s"
    cur.execute(template % (db,"OLAC_ARCHIVE"), (archiveid, newaid))
    cur.execute(template % (db,"ARCHIVED_ITEM"), (archiveid, newaid))
    cur.execute(template % (db,"ARCHIVE_PARTICIPANT"), (archiveid, newaid))


def purge(cur, maindb, archiveid):
    """
    @param cur:
    @param maindb: main database name
    @param archiveid: archive id in the main db
    """

    params = {
        "maindb": maindb,
        "aid": archiveid,
        }
    
    # delete all metadata elements
    cur.execute("""
    delete me.* from %(maindb)s.ARCHIVED_ITEM ai, %(maindb)s.METADATA_ELEM me
    where ai.Archive_ID=%(aid)d and ai.Item_ID=me.Item_ID
    """ % params)

    # delete all records
    cur.execute("""
    delete from %(maindb)s.ARCHIVED_ITEM
    where Archive_ID=%(aid)d
    """ % params)
    
    # delete archive participants
    cur.execute("""
    delete from %(maindb)s.ARCHIVE_PARTICIPANT
    where Archive_ID=%(aid)d
    """ % params)

    # delete archive
    cur.execute("""
    delete from %(maindb)s.OLAC_ARCHIVE
    where Archive_ID=%(aid)d
    """ %params)


def move(cur, maindb, tmpdb, archiveid):
    """
    Move data from the temporary database to the main database.
    
    @param cur:
    @param maindb: main database name
    @param tmpdb: temporary database name
    @param archiveid: archive id in the main db
    """

    params = {
        "maindb": maindb,
        "tmpdb": tmpdb,
        "aid": archiveid,
        }

    # add archive
    cur.execute("""
    insert into %(maindb)s.OLAC_ARCHIVE
    select * from %(tmpdb)s.OLAC_ARCHIVE
    where Archive_ID=%(aid)d
    """ % params)

    # add records
    fields = get_fields(cur, "ARCHIVED_ITEM")
    fields.remove("Item_ID")
    params['fields'] = ','.join(fields)
    cur.execute("""
    insert into %(maindb)s.ARCHIVED_ITEM (%(fields)s)
    select %(fields)s from %(tmpdb)s.ARCHIVED_ITEM
    where Archive_ID=%(aid)d
    """ % params)

    # update Item_ID of metadata elements
    cur.execute("""
    update
    %(tmpdb)s.ARCHIVED_ITEM ai
    join %(maindb)s.ARCHIVED_ITEM ai2
    on ai.OaiIdentifier=ai2.OaiIdentifier
    join %(tmpdb)s.METADATA_ELEM me
    on ai.Item_ID=me.Item_ID
    set ai.Item_ID=ai2.Item_ID, me.Item_ID=ai2.Item_ID
    where ai.Archive_ID=%(aid)d
    """ % params)

    # add metadata elements
    fields = get_fields(cur, "METADATA_ELEM")
    fields.remove("Element_ID")
    params['fields'] = ','.join(fields)
    params['fields2'] = ','.join(['me.'+f for f in fields])
    cur.execute("""
    insert into %(maindb)s.METADATA_ELEM (%(fields)s)
    select %(fields2)s
    from %(tmpdb)s.ARCHIVED_ITEM ai, %(tmpdb)s.METADATA_ELEM me
    where ai.Item_ID=me.Item_ID and ai.Archive_ID=%(aid)d
    """ % params)

    # add archive participants
    cur.execute("""
    insert into %(maindb)s.ARCHIVE_PARTICIPANT
    select * from %(tmpdb)s.ARCHIVE_PARTICIPANT
    where Archive_ID=%(aid)d
    """ % params)
    
    # update the datestamp
    cur.execute("""
    update %(maindb)s.OLAC_ARCHIVE
    set LastFullHarvest=substr(now(),1,10)
    where Archive_ID=%(aid)d
    """ % params)
    
    
def defer(cur, maindb, archiveid, days=7):
    "postphone harvesting by 1 week"
    sql = """
    update %s.OLAC_ARCHIVE
    set LastFullHarvest=%%s
    where Archive_ID=%%s
    """ % maindb
    d = datetime.datetime.today() - datetime.timedelta(HARVEST_INTERVAL-days)
    cur.execute(sql, (d.date(), archiveid))

 
def get_archive_id(cur, db, baseurl):
    """
    @param cur:
    @param db: database name
    @param baseurl:
    """
    template = "select Archive_ID from %s.OLAC_ARCHIVE where BaseURL=%%s" % db
    cur.execute(template, baseurl)
    if cur.rowcount > 0: return cur.fetchone()[0]


def get_archive_type(cur, db, baseurl):
    """
    @param cur:
    @param db: database name
    @param baseurl:
    """
    template = "select type from %s.ARCHIVES where BASEURL=%%s" % db
    cur.execute(template, baseurl)
    if cur.rowcount > 0: return cur.fetchone()[0]


def get_fields(cur, tab):
    cur.execute("desc %s" % tab)
    return [row[0] for row in cur.fetchall()]


def process_options():
    usageString = """\
Usage: %(prog)s [-h] -c <mycnf> [-H <host>] [-d <db>] [-f]

    options:

      -h          print this message and exit
      -c <mycnf>  mycnf file. If not given, system configuration is used.
      -H <host>   hostname of the mysql server
      -d <db>     name of the main OLAC database
      -t <db>     name of a temporary database
      -x          path to the OLAC harvester. By default, system configuration
                  is checked and then 'harvester.py' is searched in the same
                  directory as the monthly harvester.
      -l          send log message to the log daemon (unix)

""" % {"prog":os.path.basename(sys.argv[0])}
    
    def usage(msg=None):
        print >>sys.stderr, usageString
        if msg:
            print >>sys.stderr, "ERROR:", msg
            print >>sys.stderr
        sys.exit(1)
        
    op = OptionParser(
        "*-h",
        "*-c:",
        "*-H:",
        "*-d:",
        "*-t:",
        "*-x:",
        "*-l",
        )
    try:
        op.parse(sys.argv[1:])
    except OptionParser.ParseError, e:
        usage(e.message)
    if op.get('-h'): usage()

    global USESYSLOG
    USESYSLOG = bool(op.get('-l')) & bool(olac)
    
    harvester = op.getOne('-x')
    if harvester is None and olac:
        log("checking configuration for harvester program ...")
        harvester = olac.olacvar('harvester/main')
        if not os.path.exists(harvester) or harvester == '/null/value':
            harvester = None
    if harvester is None:
        log("checking current directory for harvester program ...")
        base = os.path.dirname(sys.argv[0])
        harvester = os.path.join(base, 'harvester.py')
    if not os.path.exists(harvester):
        log("ERROR: harvester not found")
        sys.exit(1)
    log("harvester is: %s" % harvester)
        
    mycnf = op.getOne('-c')
    host = op.getOne('-H')
    db = op.getOne('-d')
    tmpdb = op.getOne('-t')

    kwargs = {}
    
    if mycnf:
        kwargs["read_default_file"] = mycnf
    elif olac:
        kwargs['host'] = olac.olacvar('mysql/host')
        kwargs['db'] = olac.olacvar('mysql/olacdb')
        kwargs['user'] = olac.olacvar('mysql/user')
        kwargs['passwd'] = olac.olacvar('mysql/passwd')
        for k in kwargs.keys():
            if kwargs[k] == '/null/value':
                del kwargs[k]

    if host: kwargs['host'] = host
    if db: kwargs['db'] = db

    if tmpdb is None:
        tmpdb = olac.olacvar('harvester/monthlydb')
        if tmpdb == '/null/value':
            log("ERROR: temporary not specified nor found in configuration")
            sys.exit(1)
            
    con = MySQLdb.connect(**kwargs)
    cur = con.cursor()
    cur.execute("select database()")
    db = cur.fetchone()[0]
    log("main database:", db)
    log("temp database:", tmpdb)
    if db is None:
        log("ERROR: can't use invalid main db specified in configuration")
        sys.exit(1)
    if db == tmpdb:
        log("ERROR: temporary db shouldn't be the same as the main db:", db)
        sys.exit(1)

    return mycnf, host, db, tmpdb, con, cur, harvester


if __name__ == "__main__":
    mycnf, host, db, tmpdb, con, cur, harvester = process_options()

    if USESYSLOG:
        if olac:
            progname = olac.olacvar('harvester/monthly_logname')
            if progname == '/null/value':
                progname = 'monthly_harvester'
            log.openlog(progname)
        else:
            USESYSLOG = False
            log2("Failed to load olac module.\n" \
                 "Logging to log daemon will be diabled.")

    log("obtaining archive list...")
    archives = get_all_archives(cur)
    con.commit()  # because LastFullHarvest is updated for new archives

    log("initializing the temp database...")
    initialize_tmp_db(cur, tmpdb, db)
    con.commit()
    
    # run scheduler
    for url in select_archives(archives):

        archiveid = get_archive_id(cur, db, url)
        archivetype = get_archive_type(cur, db, url)

        log("harvesting:", url)
        cmd = [sys.executable, harvester, "-d", tmpdb, "-f", "-u", "-s", url]
        if mycnf: cmd += ['-c', mycnf]
        if archivetype == 'Static': cmd.append('--static')
        if host: cmd += ["-H", host]
        proc = subprocess.Popen(
            cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = proc.communicate()
        con.commit()  # make sure that the newly harvested archive is seen
        log("STDOUT:")
        log2(stdout.split('\n'))
        log("STDERR:")
        log2(stderr.split('\n'))
        newaid = get_archive_id(cur, tmpdb, url)
        if not re.search("harvest successful", stderr) or not newaid:
            log("harvest failed")
            log("it will be tried again one week later at the latest")
            defer(cur, db, archiveid)
            con.commit()
            continue
        log("ok")
        
        log("original archive id is:", archiveid)
        log("new archive id is:", newaid)
        
        if archiveid != newaid:
            log("updating temp archive id: %d -> %d" % (newaid,archiveid))
            update_ids(cur, tmpdb, newaid, archiveid)
        con.commit()
        
        log("purging the main db...")
        purge(cur, db, archiveid)
        log("now moving the data to the main db...")
        move(cur, db, tmpdb, archiveid)
        con.commit()
        log("done")
