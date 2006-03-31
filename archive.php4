<?php
#
# Synopsis: Display the archive informaion from the olac database.
#
# ChangeLog:
# 
# 2005-01-19  Steven Bird  <sb@ldc.upenn.edu>
#	* change URL of repository explorer
#
# 2004-11-10  Haejoong Lee  <haejoong@ldc.upenn.edu>
#	* set character encoding to utf-8
#
# 2004-01-28  Steven Bird  <sb@ldc.upenn.edu>
#       * linked to archive report cards
#
# 2003-03-05  Haejoong Lee  <haejoong@ldc.upenn.edu>
#	* don't display empty entries
#	* shortLocation should appear
#
# 2003-02-28  Haejoong Lee  <haejoong@ldc.upenn.edu>
#	* created based on previous version built on olac 0.4 db
#

require_once("lib/php/OLACDB.php");
$DB = new OLACDB("olac2");

############################################################
# returns a hash of the following form
#
#   display string ==> value
############################################################
function get_archive_info($id)
{
    global $DB;

    $tab = $DB->sql("select *
		     from   OLAC_ARCHIVE
		     where  Archive_ID=$id");
    if (! $tab) {
      print "Invalid archive id: $id";
      exit;
    }
    $tab1 = $DB->sql("select count(Item_ID) as size
		      from   ARCHIVED_ITEM
		      where  Archive_ID=$id");
    $tab2 = $DB->sql("select distinct SchemaName
		      from   ARCHIVED_ITEM as A, SCHEMA_VERSION as S
		      where  A.Archive_ID=$id and A.Schema_ID=S.Schema_ID");
    $r = $tab[0];

    $o[Size] = $tab1[0][size];
    $o[RepositoryName] = $r[RepositoryName];
    $i = $r[Institution];
    $iu = $r[InstitutionURL];
    if ($i) {
      if ($iu) $o[Institution] = "<a href=\"$iu\">$i</a>";
      else     $o[Institution] = $i;
    } else if ($iu)
	       $o[Institution] = "<a href=\"$iu\">$iu</a>";
    else       $o[Institution] = "";
    $o[ArchiveURL] = "<a href=\"$r[ArchiveURL]\">$r[ArchiveURL]</a>";
    $c = $r[Curator];
    $ce = str_replace('mailto:', '', $r[CuratorEmail]);
    if ($c) {
      if ($ce) $o[Curator] = "<a href=\"mailto:$ce\">$c</a>";
      else     $o[Curator] = $c;
    } else if ($ce)
	       $o[Curator] = "<a href=\"mailto:$ce\">$ce</a>";
    else       $o[Curator] = "";
    $o[Location] = $r[Location];
    $o['Short location'] = $r[ShortLocation];
    $o[Synopsis] = $r[Synopsis];
    $o[Access] = $r[Access];
    $r[AdminEmail] = str_replace('mailto:', '', $r[AdminEmail]);
    $o[Administrator] = "<a href=\"mailto:$r[AdminEmail]\">$r[AdminEmail]</a>";
    $o["Base URL"] = $r[BaseURL];
    $o["Repository ID"] = $r[RepositoryIdentifier];
    $o["OAI version"] = $r[OaiVersion];
    foreach ($tab2 as $v) {
	$o["OLAC MS version(s)"] .= "$v[SchemaName] ";
    }
    $o[Explore] = "<a href=\"http://re.cs.uct.ac.za/cgi-bin/Explorer/2.0-1.46/testoai?archive=$r[BaseURL]\">Visit archive with the Repository Explorer</a>";
    $o["Last harvested"] = $r[LastHarvested];

    # added by SB on 2004-01-23:
    $o["Score card"] = "<a href=\"tools/reports/archiveReportCard.php?archive=$id\">experimental service</a>";

    return $o;
}

?>



<html>
<head>
<title>OLAC - Archive details</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body bgcolor=white>

<?php
$record = get_archive_info($_GET[id]);
echo "<h1>$record[RepositoryName]</h1>";
echo "<table>";
foreach ($record as $k => $v) {
    if (! preg_match('/^\s*$/', $v)) {
        echo "<tr><td align=right valign=top>$k:</td>";
        echo "<td><font color=blue>$v</font></td></tr>\n";
    }
}
echo "</table>";
?>

</body>
</html>
