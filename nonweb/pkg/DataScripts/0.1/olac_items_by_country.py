"""
Create a table of (area, country, country code, # olac items).
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

sql = """
select li.Area,
       li.Name,
       li.CountryID,
       count(distinct ai.Item_ID) c
       
from ARCHIVED_ITEM ai,
     METADATA_ELEM me,
     (
         select distinct cc.Area,
                         substring_index(cc.Name,' (',1) Name,
                         cc.CountryID,
                         li.LangID
         from LanguageCodes li,
              CountryCodes cc
              
         where li.CountryID=cc.CountryID
           and li.LangStatus='L'
     ) li
     
where ai.Item_ID=me.Item_ID
  and me.TagName in ('subject','language')
  and me.Code=li.LangID
  
group by li.Name
order by li.Area, li.Name
"""

cur.execute(sql)

out = codecs.getwriter('utf-8')(sys.stdout)

out.write("area_name\tcountry_name\tcountry_code\tnum_items\n")
for row in cur.fetchall():
    out.write("%s\t%s\t%s\t%d\n" % row)

