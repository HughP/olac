<?php
######################################################################
#
# Synopsis: List all records of the specified archive
#
# ChangeLog:
#
# 2003-09-03 Steven Bird
#
######################################################################

require_once("../lib/php/OLACDB.php");
$DB = new OLACDB("olac2");
?>

<HTML>
<HEAD>
<TITLE>List Records from an OLAC Archive</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="/olac.css">
</HEAD>

<BODY>
<HR>
<TABLE CELLPADDING="10">
<TR>
<TD> <A HREF="http://www.language-archives.org/"><IMG
SRC="http://www.language-archives.org/images/olac100.gif"
BORDER="0"></A></TD>
<TD> <H1><FONT COLOR="0x00004a">List Records from an OLAC Archive
</FONT>
</H1>
</TD>
</TR>
</TABLE>
<HR>

<p>This page permits the records of a particular
<a href="/archives.php4">harvested archive</a>
to be displayed.  It may be slow for large archives.
For full-featured search, please see the
<a href="http://saussure.linguistlist.org/olac/">
LINGUIST List search interface</a>.

<?
function archives()
{
    global $DB;

    $tab = $DB->sql("select RepositoryIdentifier from OLAC_ARCHIVE");
    if (! $tab) {
      print "No repositories!";
      exit;
    }
    
    $output = "<select name='archive'>";
    foreach ($tab as $archive) {
      $id = $archive[RepositoryIdentifier];
      $output .= "<option value=\"$id\">$id</option>";
    }
    $output .= "</select>";
    return $output;
}

?>

<form method="get">
<b>Archive:</b>
<? print archives(); ?>
<input type="submit">
</form>

<?
if ($_GET[archive]) {
  $tab = $DB->sql("
    select Item_ID, OaiIdentifier
    from   ARCHIVED_ITEM, OLAC_ARCHIVE
    where  ARCHIVED_ITEM.Archive_ID = OLAC_ARCHIVE.Archive_ID
    and    OLAC_ARCHIVE.RepositoryIdentifier = '$_GET[archive]'
    ORDER BY OaiIdentifier");
  $DB->saw_error() and die("Query failed");

  $count = 1;
  $archive_ids = array();
  $record_ids = array();
  $output = "";

  if ($tab) foreach ($tab as $row) {
    $output .= <<<END
<p>$count.
<a href="http://www.language-archives.org/tools/lookup.php4?identifier=$row[OaiIdentifier]">$row[OaiIdentifier]</a>
END;

    $record_ids[$row[Item_ID]] = 1;
    $count++;
  }

  $records = sizeof($record_ids);
  print "<hr><h2>$records record(s) from $_GET[archive]</h2>";
  print $output;
}

?>

</BODY>
</HTML>
