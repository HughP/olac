"""
Create a table of (area, country, country code, # items, # items).
The last field is the number items when large languages (>10M speakers)
were excluded.
"""

import MySQLdb
import olac
import codecs
import sys

con = MySQLdb.connect(
    host = olac.olacvar('mysql/host'),
    user = olac.olacvar('mysql/user'),
    passwd = olac.olacvar('mysql/passwd'),
    db = olac.olacvar('mysql/olacdb'),
    charset = 'utf8'
    )

cur = con.cursor()

subsql1 = """
select distinct cc.Area,
       substring_index(cc.Name,' (',1) Name,
       cc.CountryID,
       li.LangID
from LanguageCodes li,
     CountryCodes cc
              
where li.CountryID=cc.CountryID
      and li.LangStatus='L'
"""

subsql2 = """
select distinct cc.Area,
       substring_index(cc.Name,' (',1) Name,
       cc.CountryID,
       li.LangID
from LanguageCodes li,
     CountryCodes cc,
     LanguagePopulation lp
              
where li.CountryID=cc.CountryID
      and li.LangStatus='L'
      and li.LangID=lp.LangID
      and lp.Population < 10000000
"""

sql = """
select li.Area,
       li.Name,
       li.CountryID,
       count(distinct ai.Item_ID) c
       
from ARCHIVED_ITEM ai,
     METADATA_ELEM me,
     (%(subsql)s) li
     
where ai.Item_ID=me.Item_ID
  and me.TagName in ('subject','language')
  and me.Code=li.LangID
  
group by li.Name
order by li.Area, li.Name
"""

# create a table of number of items of countries excluding langs with
# more than 10M speakers
sub10m = {}
cur.execute(sql % {"subsql":subsql2})
for row in cur.fetchall():
    sub10m[row[2]] = row[3]

# generate the final table
cur.execute(sql % {"subsql":subsql1})
out = codecs.getwriter('utf-8')(sys.stdout)
header = ("area_name", "country_name", "country_code",
          "num_items", "num_items_nobiglangs")
out.write("\t".join(header) + "\n")
for row in cur.fetchall():
    # compute number of items excluding langs of more than 10M speakers
    if row[2] in sub10m:
        m = sub10m[row[2]]
    else:
        m = 0
    out.write("%s\t%s\t%s\t%d\t%d\n" % (row + (m,)))

