#!/usr/bin/env python

import MySQLdb
import oursql

def connect():
    opts = {"db":"oai", "use_unicode":True, "charset":"utf8",
    "user" : 'olac',
    "host" : '127.0.0.1',
    'passwd' : 'OLAcProjekt' }
    return MySQLdb.connect(**opts)


def oursql_connect():
    return oursql.connect(host='127.0.0.1', user='olac', passwd='OLAcProjekt',
    db='oai', port=3306)
