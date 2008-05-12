import sys
import MySQLdb

coninfo = {"read_default_file":"~/.my.cnf"}
con = MySQLdb.connect(**coninfo)
cur = con.cursor()

sqls = [
    "delete from Metrics",

    "insert into Metrics (archive_id,num_resources) select oa.Archive_ID, sum(if(Item_ID is null,0,1)) from OLAC_ARCHIVE oa left join ARCHIVED_ITEM ai on oa.Archive_ID=ai.Archive_ID group by oa.Archive_ID",

    "insert into Metrics (archive_id,num_resources) select -1, count(*) from ARCHIVED_ITEM",
    
    "create temporary table langcodes select Archive_ID, Code from METADATA_ELEM me, ARCHIVED_ITEM ai where me.Item_ID=ai.Item_ID and Type='language' and Code is not null and Code!=''",

    "insert into langcodes select Archive_ID, lc.LangID from METADATA_ELEM me, LanguageCodes lc, ARCHIVED_ITEM ai where me.Item_ID=ai.Item_ID and me.Type='language' and (me.Code is null or me.Code='') and me.Content is not null and me.Content=lc.Name",

    "update Metrics set num_languages=(select count(distinct Code) from langcodes where Archive_ID=Metrics.archive_id)",

    "update Metrics set num_languages=(select count(distinct Code) from langcodes) where archive_id=-1",
    
    "drop table langcodes",

    "update Metrics set num_linguistic_fields=(select count(distinct Code) from METADATA_ELEM me, ARCHIVED_ITEM ai where me.Item_ID=ai.Item_ID and Type='linguistic-field' and Archive_ID=Metrics.archive_id)",

    "update Metrics set num_linguistic_fields=(select count(distinct Code) from METADATA_ELEM where Type='linguistic-field') where archive_id=-1",
    
    "update Metrics set num_linguistic_types=(select count(distinct Code) from METADATA_ELEM me, ARCHIVED_ITEM ai where me.Item_ID=ai.Item_ID and Type='linguistic-type' and Archive_ID=Metrics.archive_id)",

    "update Metrics set num_linguistic_types=(select count(distinct Code) from METADATA_ELEM where Type='linguistic-type') where archive_id=-1",

    "update Metrics set num_dcmi_types=(select count(distinct Content) from METADATA_ELEM me, ARCHIVED_ITEM ai where me.Item_ID=ai.Item_ID and Type='DCMIType' and Archive_ID=Metrics.archive_id)",

    "update Metrics set num_dcmi_types=(select count(distinct Content) from METADATA_ELEM where Type='DCMIType') where archive_id=-1",

    "delete from MetricsElementUsage",

    "insert into MetricsElementUsage select Archive_ID, Tag_ID, count(*) from METADATA_ELEM me, ARCHIVED_ITEM ai where me.Item_ID=ai.Item_ID and Tag_ID is not null group by Archive_ID, Tag_ID",

    "delete from MetricsQualityScore",

    """
    insert into MetricsQualityScore
    select
        Item_ID,
        least(title,1) title,
        least(date,1) date,
        least(agent,1) agent,
        least(about,1) about,
        least(greatest(depth-8,0),6)/6 depth,
        least(content_language,1) content_language,
        least(linguistic_type,1) linguistic_type,
        least(subject_language,1) subject_language,
        least(dcmi_type,1) dcmi_type,
        least(W3CDTF+role+IMT+URI+Coverage,3)/3 prec
     from
        (select
            Item_ID,
            sum(if(Tag_ID=1400 and Content,1,0)) title,
            sum(if(DcElement=400 and Content,1,0)) date,
            sum(if((Tag_ID=100 or Tag_ID=300 or Tag_ID=900) and Content,1,0)) agent,
            sum(if((Tag_ID=1300 and (Content or Code is not null)) or (DcElement=500 and Content),1,0)) about,
            sum(if(Content or Code is not null,1,0)) depth,
            sum(if(Tag_ID=800 and Code is not null,1,0)) content_language,
            sum(if(Tag_ID=1500 and Type='linguistic-type' and Code is not null,1,0)) linguistic_type,
            sum(if((Tag_ID=1300 and Type='language' and Code is not null) or (Tag_ID=1500 and Type='linguistic-type' and Code='primary_text'),1,0)) subject_language,
            sum(if(Tag_ID=1500 and Type='DCMIType' and (Content or Code is not null),1,0)) dcmi_type,
            least(sum(if(Type='W3CDTF' and Content,1,0)),1) W3CDTF,
            least(sum(if(Type='role' and Code is not null and Content,1,0)),1) role,
            least(sum(if(Type='IMT' and Content,1,0)),1) IMT,
            least(sum(if(Type='URI' and Content,1,0)),1) URI,
            least(sum(if(DcElement=200 and Type is not null,1,0)),1) Coverage
         from
            (select
                Item_ID, me.Tag_ID, DcElement, Type,
                (Content is not null and Content!='') Content,
                if(Type='language',LangID,if(Type is null or Code='',null,Code)) Code
             from
                METADATA_ELEM me
                left join ELEMENT_DEFN ed on me.Tag_ID=ed.Tag_ID
                left join LanguageCodes lc on me.Code=lc.LangID
            ) t
         group by Item_ID
        ) t
    """,

    """
    update
        (select
            ai.Archive_ID,
            sum(title+date+agent+about+depth+content_language+linguistic_type+subject_language+dcmi_type+prec)/count(distinct ai.Item_ID) score
         from
            MetricsQualityScore mqs, Metrics m, ARCHIVED_ITEM ai
         where ai.Archive_ID=m.archive_id and ai.Item_ID=mqs.Item_ID
         group by m.archive_id
         order by score
        ) t
        left join Metrics m
        on t.Archive_ID=m.archive_id
    set m.metadata_quality=t.score
    """,

    "update Metrics set metadata_quality=(select sum(title+date+agent+about+depth+content_language+linguistic_type+subject_language+dcmi_type+prec)/count(*) from MetricsQualityScore) where archive_id=-1",

    """
    update Metrics m
        left join
        (select Archive_ID, avg(c) a, std(c) s
         from
            (select ai.Archive_ID, count(*) c
             from Metrics m, ARCHIVED_ITEM ai, METADATA_ELEM me
             where m.archive_id=ai.Archive_ID and ai.Item_ID=me.Item_ID
             group by ai.Item_ID
            ) t
         group by Archive_ID
        ) x
        on m.archive_id=x.Archive_ID
    set m.avg_num_elements=x.a, m.std_num_elements=x.s
    """,

    "update Metrics m left join (select avg(c) a, std(c) s from (select count(*) c from METADATA_ELEM group by Item_ID) t) t on m.archive_id=-1 set m.avg_num_elements=t.a, m.std_num_elements=t.s where m.archive_id=-1",

    "update Metrics m left join (select ai.Archive_ID, count(*) c from ARCHIVED_ITEM ai where exists (select 1 from METADATA_ELEM where Item_ID=ai.Item_ID and TagName='identifier' and (Content like 'http:%' or Content like 'https:%' or Content like 'ftp:%')) group by ai.Archive_ID) x on m.archive_id=x.Archive_ID set m.num_online_resources=x.c",

    "update Metrics set num_online_resources=(select count(*) from ARCHIVED_ITEM ai where exists (select 1 from METADATA_ELEM where Item_ID=ai.Item_ID and TagName='identifier' and (Content like 'http%' or Content like 'https:%' or Content like 'ftp:%'))) where archive_id=-1",

    "update Metrics set num_online_resources=0 where num_online_resources is null",

    "update Metrics m left join (select Archive_ID, max(DateStamp) d from ARCHIVED_ITEM group by Archive_ID) x on m.archive_id=x.Archive_ID set m.last_updated=x.d",

    "update Metrics set last_updated=(select max(DateStamp) d from ARCHIVED_ITEM) where archive_id=-1",

    "update Metrics m left join (select Archive_ID, sum(if(Type is not null,1,0))/count(distinct ai.Item_ID) f from ARCHIVED_ITEM ai, METADATA_ELEM me where ai.Item_ID=me.Item_ID group by Archive_ID) x on m.archive_id=x.Archive_ID set m.avg_xsi_types=x.f",

    "update Metrics set avg_xsi_types=(select sum(if(Type is not null,1,0))/count(distinct ai.Item_ID) f from ARCHIVED_ITEM ai, METADATA_ELEM me where ai.Item_ID=me.Item_ID) where archive_id=-1",

    "delete from MetricsEncodingSchemes",

    "insert into MetricsEncodingSchemes select Archive_ID, Type, count(*) c from ARCHIVED_ITEM ai, METADATA_ELEM me where ai.Item_ID=me.Item_ID and Type is not null group by Archive_ID, Type",

    "update Metrics set integrity_problems=0",

    "update Metrics m, (select ai.Archive_ID, count(*) c from INTEGRITY_CHECK ic left join INTEGRITY_PROBLEM ip on ic.Problem_Code=ip.Problem_Code left join METADATA_ELEM me on ic.Object_ID=me.Element_ID left join ARCHIVED_ITEM ai on ai.Item_ID=me.Item_ID where ip.Applies_To='E' group by ai.Archive_ID) x set m.integrity_problems=x.c where m.archive_id=x.Archive_ID",

    "update Metrics m, (select ic.Object_ID, count(*) c from INTEGRITY_CHECK ic left join INTEGRITY_PROBLEM ip on ic.Problem_Code=ip.Problem_Code where ip.Applies_To='A' group by ic.Object_ID) x set m.integrity_problems=m.integrity_problems+x.c where m.archive_id=x.Object_ID",

    "update Metrics set integrity_problems=(select count(*) from INTEGRITY_CHECK) where archive_id=-1",
    ]

for sql in sqls:
    cur.execute(sql)
con.commit();
