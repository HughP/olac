#! /usr/bin/env python

"""
Run PHP/WSGI scripts in CGI mode and save the output as HTML files.
"""

import os
import olac
import MySQLdb
from subprocess import Popen, PIPE
import datetime

DOCROOT = olac.olacvar('docroot')
WSGIROOT = olac.olacvar('wsgiroot')
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

def run_wsgi(script, url, outputfile=None):
    # url is of the form "/a/b/c" where /a is the mount point
    env = os.environ.copy()
    env['PATH_INFO'] = '/' + '/'.join(url.split('/')[2:])
    pipe = Popen(["python", script], stdout=PIPE, env=env)

    # remove header
    for line in pipe.stdout:
        if line == '\r\n':
            break

    output = []
    for line in pipe.stdout:
        output.append(line)
    output = ''.join(output)
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

def proc1py(script, mount_dir, param_list):
    script_path = os.path.join(WSGIROOT, script)
    outdir_path = os.path.join(STATICROOT, mount_dir)
    prefix = '/' + mount_dir + '/'

    for param in param_list:
        c = datetime.datetime.now()
        url = prefix + param
        output = os.path.join(outdir_path, param) + '.html'
        make_dirs(output)
        run_wsgi(script_path, url, open(output,'w'))
        print output, datetime.datetime.now() - c

def proc1cite(param_list):
    outdir_path = os.path.join(STATICROOT, 'cite')
    prog = olac.olacvar('cite')
    pipe = Popen([prog], stdin=PIPE, stdout=PIPE)
    for param in param_list:
        t = datetime.datetime.now()
        output = os.path.join(outdir_path, param) + '.txt'
        make_dirs(output)
        out = open(output,'w')
        pipe.stdin.write(param + "\n")
        out.write(pipe.stdout.readline())
        print output, datetime.datetime.now() - t

    pipe.stdin.close()
    
def main():
    tbeg = datetime.datetime.now()

    status_data = {}
    for line in open(STATICSTATUS):
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
        select OaiIdentifier from ARCHIVED_ITEM
        where ts >= '%(STARTED)s'
        """ % status_data

        proc1('item.php', sql_to_list(sql))

        proc1cite(sql_to_list(sql))

        proc1py('integrity_check.wsgi', 'checks', repoids)
        proc1py('integrity_check.wsgi', 'checks',
                [x + '/download' for x in repoids])

    out = open(STATICSTATUS, 'w')
    print >>out, "UPDATED_ITEMS:", N
    print >>out, "STARTED:", tbeg.strftime('%Y-%m-%d %H:%M:%S')
    print >>out, "FINISHED:",
    print >>out, datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

if __name__ == "__main__":
    main()

