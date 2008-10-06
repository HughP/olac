<?php

class MetricsDB extends Model {

	function MetricsDB()
	{
		parent::Model();
		$this->load->database();
	}

	function archiveList()
	{
		$this->db->select('Archive_ID, RepositoryName, RepositoryIdentifier');
		$this->db->orderby('RepositoryName');
		$query = $this->db->get('OLAC_ARCHIVE');
		return $query->result_array();
	}

	function OLACMetrics()
	{
		$query = $this->db->get("Metrics");
		$res = array();
		foreach ($query->result_array() as $row) {
		  $res[$row['archive_id']] = $row;
		}
		return $res;
	}
	
	function elementUsage($archiveId)
	{
		if ($archiveId > 0) {
			$cond = " and meu.archive_id=$archiveId";
		} else {
			$cond = "";
		}
		$sql1 = <<<EOF
select TagName label, sum(if(cnt is null,0,cnt)) cnt
from ELEMENT_DEFN ed left join MetricsElementUsage meu
on ed.Tag_ID=meu.tag_id $cond
where ed.Tag_ID=ed.DcElement and ed.Display=true
group by TagName
order by TagName
EOF;
		$query = $this->db->query($sql1);
		return $query->result_array();
	}

 	function refinementUsage($archiveId)
	{
		if ($archiveId > 0) {
			$cond = " and meu.archive_id=$archiveId";
		} else {
			$cond = "";
		}
		$sql1 = <<<EOF
select TagName label, sum(if(cnt is null,0,cnt)) cnt
from ELEMENT_DEFN ed left join MetricsElementUsage meu
on ed.Tag_ID=meu.tag_id $cond
where ed.Tag_ID!=ed.DcElement
group by TagName
order by TagName
EOF;
		$query = $this->db->query($sql1);
		return $query->result_array();
	}
	
	function encodingSchemeUsage($archiveId)
	{
		if (!is_numeric($archiveId)) return;

		if ($archiveId == -1) {
			$sql1 = <<<EOF
select distinct concat(x.NSPrefix, ':', x.Type) Type, sum(if(Count is null,0,Count)) cnt
from EXTENSION x left join MetricsEncodingSchemes y on x.Type=y.Type
where x.Display = true or y.Archive_ID is not null
group by Type
order by Type
EOF;
		}
		else {
			$sql1 = <<<EOF
select distinct concat(x.NSPrefix, ':', x.Type) Type, if(Count is null,0,Count) cnt
from EXTENSION x left join MetricsEncodingSchemes y on x.Type=y.Type and y.Archive_ID=$archiveId
where x.Display = true or y.Archive_ID is not null
order by Type
EOF;
		}
		$query = $this->db->query($sql1);
		return $query->result();
/*
		$sql1 = <<<EOF
select sum(content_language) `Content Language`,
       sum(linguistic_type) `Linguistic Type`,
       sum(subject_language) `Subject Language`,
       sum(dcmi_type) `DCMI Type`
from MetricsQualityScore mqs, ARCHIVED_ITEM ai
where mqs.Item_ID=ai.Item_ID
EOF;
		if ($archiveId > 0) {
			$sql1 .= " and ai.Archive_ID=$archiveId";
		}
		$query = $this->db->query($sql1);
		return $query->row();
*/
	}	

	function coreElementPct($archiveId)
	{
		$sql1 = <<<EOF
select sum(title)/count(*) Title,
       sum(date)/count(*) Date,
       sum(agent)/count(*) Agent,
       sum(about)/count(*) About,
       sum(content_language)/count(*) `Content Language`,
       sum(linguistic_type)/count(*) `Linguistic Type`,
       sum(subject_language)/count(*) `Subject Language`,
       sum(dcmi_type)/count(*) `DCMI Type`
from MetricsQualityScore mqs, ARCHIVED_ITEM ai
where mqs.Item_ID=ai.Item_ID
EOF;
		if ($archiveId > 0) {
			$sql1 .= " and ai.Archive_ID=$archiveId";
		}
		$query = $this->db->query($sql1);
		return $query->row();
	}	


    ###########
    # Metrics #
    ###########

    function numArchives()
    {
        $sql1 = <<<EOF
select count(*) c from OLAC_ARCHIVE
EOF;
        $query = $this->db->query($sql1);
        return $query->row()->c;
    }

    function numArchiveItems($archiveId=False)
    {
        if ($archiveId)
            $cond = " where ArchiveID=$archiveId ";
        else
            $cond = "";

        $sql1 = <<<EOF
select count(*) c from ARCHIVED_ITEM $cond
EOF;
        $query = $this->db->query($sql1);
        return $query->row()->c;
    }

    function numLanguages($archiveId=False)
    {
        if ($archiveId)
            $cond = " and ArchiveID=$archiveId ";
        else
            $cond = "";

        $sql1 = <<<EOF
create temporary table langcode
select Code from METADATA_ELEM
where Type='language' and Code is not null and Code!='' $cond
EOF;
        $sql2 = <<<EOF
insert into langcode
select lc.LangID from METADATA_ELEM me, LanguageCodes lc
where me.Type='language' and (me.Code is null or me.Code='')
and me.Content is not null and me.Content=lc.Name $cond
EOF;
        $sql3 = <<<EOF
select count(distinct Code) c from langcode
EOF;
        $this->db->simple_query($sql1);
        $this->db->simple_query($sql2);
        $query = $this->db->query($sql3);
        return $query->row()->c;
    }

    function percentLanguages($archiveId=False)
    {
        $numLangCodes = 7299;   # number of lang codes for ISO639-3

        # NOTE: It would be ideal to have something like the following.
        # The problem is that we have different language code sets
        # defined under the same language extension, e.g. the old 2-ltter
        # language codes, xil-* codes, ISO639-3 codes, and other
        # unidentified codes.
        
#         $sql1 = <<<EOF
# select Extension_ID from EXTENSION where Type='language'
# EOF;
#         $sql2 = <<<EOF
# select count(*) c from CODE_DEFN where Extension_ID=?
# EOF;
#         $query1 = $this->db->query($sql1);
#         $query2 = $this->db->query($sql2, $query1->row_array());
#         $numLangCodes = $query2->row()->c;

        $numLangs = $this->numLanguages($archiveId);
        return $numLangs / $numLangCodes * 100.0;
    }

    function numLinguisticFields($archiveId=False)
    {
        if ($archiveId)
            $cond = " and ArchiveID=$archiveId ";
        else
            $cond = "";

        $sql1 = <<<EOF
select count(distinct Code) c from METADATA_ELEM
where Type='linguistic-field' $cond
EOF;
        $query = $this->db->query($sql1);
        return $query->row()->c;
    }

    function percentLinguisticFields($archiveId=False)
    {
    }

    function numLinguisticTypes($archiveId=False)
    {
        if ($archiveId)
            $cond = " and ArchiveID=$archiveId ";
        else
            $cond = "";

        $sql1 = <<<EOF
select count(distinct Code) c from METADATA_ELEM
where Type='linguistic-type' $cond
EOF;
        $query = $this->db->query($sql1);
        return $query->row()->c;
    }

    function numDcmiTypes($archiveId=False)
    {
        if ($archiveId)
            $cond = " and ArchiveID=$archiveId ";
        else
            $cond = "";

        # NOTE: There are no codes defined for DCMIType elements

        $sql1 = <<<EOF
select count(distinct Content) c from METADATA_ELEM
where Type='DCMIType' $cond
EOF;
        $query = $this->db->query($sql1);
        return $query->row()->c;
    }

    function avgElementsPerItem($archiveId=False)
    {
        if ($archiveId)
            $cond = " where ArchiveID=$archiveId ";
        else
            $cond = "";


        $sql1 = <<<EOF
select count(*) c from ARCHIVED_ITEM $cond
EOF;
        $sql2 = <<<EOF
select count(*) c from METADATA_ELEM $cond
EOF;
        $query1 = $this->db->query($sql1);
        $query2 = $this->db->query($sql2);
        $items = $query1->row()->c;
	$elems = $query2->row()->c;
        return $elems / $items;
    }

	####

	function getArchiveId($stringId)
	{
		$this->db->select('Archive_ID');
		$this->db->from('OLAC_ARCHIVE');
		$this->db->where('RepositoryIdentifier',$stringId);
		$query = $this->db->get();
		if ($query->num_rows() > 0)
			return $query->row()->Archive_ID;
	}

	function validArchiveId($arcid)
	{
		if (!is_numeric($arcid)) return FALSE;
		$this->db->select('Archive_ID');
		$this->db->from('OLAC_ARCHIVE');
		$this->db->where('Archive_ID', $arcid);
		$query = $this->db->get();
		return $query->num_rows() > 0;
	}
}

?>
