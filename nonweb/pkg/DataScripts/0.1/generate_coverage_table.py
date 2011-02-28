import MySQLdb
import olac

con = MySQLdb.connect(
    host = olac.olacvar('mysql/host'),
    user = olac.olacvar('mysql/user'),
    passwd = olac.olacvar('mysql/passwd'),
    db = olac.olacvar('mysql/olacdb')
    )

cur = con.cursor()

tab = {}

##
## Number of all living languages
## - Also initialize the table
##

sql = """
select ceil(log10(Population+0.1)) rng, count(*)
from LanguagePopulation
group by ceil(log10(Population+0.1))
"""

cur.execute(sql)
for row in cur.fetchall():
    tab[row[0]] = [row[1], 0, 0, 0, 0]

# extinct languages

sql = """
select count(*) from ISO_639_3 where Type='E'
"""

cur.execute(sql)
tab['extinct'] = [cur.fetchone()[0], 0, 0, 0, 0]


##
## OLAC Coverage data
##
    
sql = """
select ceil(log10(Population+0.1)) rng,
       count(distinct p.LangID) langs,
       count(distinct ms.Item_ID) items
from OLAC_ARCHIVE oa,
     ARCHIVED_ITEM ai,
     LanguagePopulation p,
     METADATA_ELEM ms
where oa.Archive_ID=ai.Archive_ID
and oa.RepositoryIdentifier != 'ethnologue.com'
and ai.Item_ID=ms.Item_ID
and p.LangID=ms.Code
and ms.TagName='subject'
group by ceil(log10(Population+0.1))
"""

cur.execute(sql)
for row in cur.fetchall():
    rec = tab[row[0]]
    rec[1] = row[1]  # number of langs in olac
    rec[2] = row[2]  # number of items

# extinct languages

sql = """
select count(distinct iso.Id) langs,
       count(distinct ms.Item_ID) items
from OLAC_ARCHIVE oa,
     ARCHIVED_ITEM ai,
     ISO_639_3 iso,
     METADATA_ELEM ms
where oa.Archive_ID=ai.Archive_ID
and oa.RepositoryIdentifier != 'ethnologue.com'
and ai.Item_ID=ms.Item_ID
and iso.Type='E'
and iso.Id=ms.Code
and ms.TagName='subject'
"""

cur.execute(sql)
row = cur.fetchone()
tab['extinct'][1] = row[0]  # number of languages
tab['extinct'][2] = row[1]  # number of items


##
## Coverage of online items
##

sql = """
select ceil(log10(Population+0.1)) rng,
       count(distinct p.LangID) langs,
       count(distinct ms.Item_ID) items
from OLAC_ARCHIVE oa,
     ARCHIVED_ITEM ai,
     LanguagePopulation p,
     METADATA_ELEM ms,
     METADATA_ELEM mo
where oa.Archive_ID=ai.Archive_ID
and oa.RepositoryIdentifier != 'ethnologue.com'
and ai.Item_ID=ms.Item_ID
and p.LangID=ms.Code
and ms.TagName='subject'
and mo.Item_ID=ms.Item_ID
and mo.TagName='identifier'
and mo.Content regexp '^(http|https|ftp):.*'
group by ceil(log10(Population+0.1))
"""

cur.execute(sql)
for row in cur.fetchall():
    rec = tab[row[0]]
    rec[3] = row[1]
    rec[4] = row[2]

# extinct languages

sql = """
select count(distinct iso.Id) langs,
       count(distinct ms.Item_ID) items
from OLAC_ARCHIVE oa,
     ARCHIVED_ITEM ai,
     ISO_639_3 iso,
     METADATA_ELEM ms,
     METADATA_ELEM mo
where oa.Archive_ID=ai.Archive_ID
and oa.RepositoryIdentifier != 'ethnologue.com'
and ai.Item_ID=ms.Item_ID
and iso.Type='E'
and iso.Id=ms.Code
and ms.TagName='subject'
and mo.Item_ID=ms.Item_ID
and mo.TagName='identifier'
and mo.Content regexp '^(http|https|ftp):.*'
"""

cur.execute(sql)
row = cur.fetchone()
tab['extinct'][3] = row[0]  # number of languages
tab['extinct'][4] = row[1]  # number of items


##
## Output
##

print "level\t#langs\t#langs_in_olac\t#items\t#online_langs\t#online_items"
for level, rec in tab.items():
    if level is None:
        level = 'unknown'
    elif isinstance(level,float):
        level = str(int(level))
    print "%s\t%d\t%d\t%d\t%d\t%d" % \
          (level, rec[0], rec[1], rec[2], rec[3], rec[4])
