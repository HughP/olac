import sys
import re
import MySQLdb
import olac

opts = {
    "host": olac.olacvar("mysql/host"),
    "db": olac.olacvar("mysql/olacdb"),
    "user": olac.olacvar("mysql/user"),
    "passwd": olac.olacvar("mysql/passwd"),
    "use_unicode": True,
    "charset": "utf8",
    }

con = MySQLdb.connect(**opts)
con2 = MySQLdb.connect(**opts)
cur = con.cursor(MySQLdb.cursors.SSCursor)
cur2 = con2.cursor()

sql1 = "select Content from METADATA_ELEM_MYISAM"
sql2 = "create temporary table words (word varchar(128)) " \
       "engine=innodb charset=utf8"
sql3 = "insert ignore into SOUNDEX_TABLE " \
       "select substring(soundex(word),1,4), word from words"
cur.execute(sql1)
row = cur.fetchone()
S = set()
cur2.execute(sql2)
cur2.execute("begin")
while row:
    if row[0]:
        for word in re.findall(r"\w+", row[0]):
            if word not in S:
                sql = "insert ignore into words values (%s)"
                cur2.execute(sql, word)
                S.add(word)
    row = cur.fetchone()
cur2.execute(sql3)
cur2.execute("commit")
