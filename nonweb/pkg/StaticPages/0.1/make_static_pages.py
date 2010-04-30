#! /usr/bin/env python

"""
Run PHP scripts in CGI mode and save the output as HTML files.
"""

import os
import olac
import MySQLdb
from subprocess import Popen, PIPE
import datetime

DOCROOT = olac.olacvar('docroot')
STATICROOT = olac.olacvar('static/root')
STATICSTATUS = olac.olacvar('static/status')
CONN = MySQLdb.connect(read_default_file="~/.my.cnf",
                       read_default_group="client_dbm")
cur = CONN.cursor()

def run_php(script, url, outputfile=None):
    env = os.environ.copy()
    env['PATH_INFO'] = '/' + os.path.basename(url)
    env['REQUEST_URI'] = url
    pipe = Popen(["php-cgi", "-q", script], stdout=PIPE, env=env)
    output = pipe.stdout.read()
    pipe.communicate()
    if outputfile:
        outputfile.write(output)
    else:
        return output

def sql_to_list(sql):
    cur.execute(sql)
    for row in cur.fetchall():
        yield row[0]

def make_dirs(file_path):
    d = os.path.dirname(file_path)
    if not os.path.exists(d):
        os.makedirs(d)

def php_script_to_dir(script):
    if script.endswith('.php'):
        return os.path.join(STATICROOT, script[:-4])
    elif script.endswith('.php4'):
        return os.path.join(STATICROOT, script[:-5])
    else:
        return os.path.join(STATICROOT, 'static', script)

def proc0(script):
    c = datetime.datetime.now()
    script_path = os.path.join(DOCROOT, script)
    output = php_script_to_dir(script) + ".html"
    make_dirs(output)
    run_php(script_path, '/' + script, open(output,'w'))
    print output, datetime.datetime.now() - c
    
def proc1(script, param_list):
    script_path = os.path.join(DOCROOT, script)
    outdir_path = php_script_to_dir(script)
    prefix = '/' + script + '/'
    
    for param in param_list:
        c = datetime.datetime.now()
        url = prefix + param
        output = os.path.join(outdir_path, param) + '.html'
        make_dirs(output)
        run_php(script_path, url, open(output,'w'))
        print output, datetime.datetime.now() - c


def main():
    tbeg = datetime.datetime.now()

    status_data = {}
    for line in open(STATUSFILE):
        try:
            a = line.strip().split(': ')
            status_data[a[0]] = a[1]
        except:
            pass

    sql = "select count(*) from ARCHIVED_ITEM where ts>='%(STARTED)s'" % \
          status_data
    cur.execute(sql)
    N = cur.fetchone()[0]

    if N > 0:
        proc0('archives.php')

        repoids = list(sql_to_list(
            "select RepositoryIdentifier from OLAC_ARCHIVE"))
        
        proc1('archive.php', repoids)
        proc1('archive_records.php', repoids)

        proc1('area.php', sql_to_list(
            "select distinct Area from CountryCodes"))
        proc1('country.php', sql_to_list(
            "select distinct CountryID from CountryCodes"))
        proc1('language.php', sql_to_list(
            "select distinct Id from ISO_639_3"))

        sql = """
        select OiaIdentifier from ARCHIVED_ITEM
        where ts >= '%(STARTED)s'
        """ % status_data

        proc1('item.php', sql_to_list(sql))


    out = open(STATUSFILE, 'w')
    print >>out, "UPDATED_ITEMS:", N
    print >>out, "STARTED:", tbeg.strftime('%Y-%m-%d %H:%M:%S')
    print >>out, "FINISHED:",
    print >>out, datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
