<?php
# Update repository confirmation script.
# User uses this page to confirm that he has request the change.

define("OLAC_PATH", '/web/language-archives');
define("OLAC_TOOLS", '/pkg/ldc/wwwhome/olac');
require_once(OLAC_PATH.'/lib/php/OLAC_general.php');
require_once(OLAC_PATH.'/lib/php/OLACDB.php');
define("OLAC_SYS_ADMIN_EMAIL", $OLAC_SYS_ADMIN_EMAIL);


function error($msg)
{
  mail_by_olac_admin
      (OLAC_SYS_ADMIN_EMAIL,
       "registration problem (/register/confirm_u.php)",
       $msg);
  echo "<p><font color=red><b>Error</b></font></p>" .
       "<p>Due to a system problem, we cannot update your repository " .
       "at this moment. Please try again. " .
       "The OLAC System Admin has been notified.</p>";
  return;
}

function success($magic, $repoid, $baseurl)
{
  global $DB;
  $DB->sql("delete from PendingConfirmation where magic_string='$magic'");
  echo "<p><font color=green><b>UPDATE REPOSITORY REQUEST CONFIRMED</b></font></p>" .
       "<p>The new repository file has replaced the old one.</p>";
}

function mail_by_olac_admin($to, $subject, $msg, $cc="")
{
  $header = "From: OLAC Web Server <www@ldc.upenn.edu>\r\n";
  $header .= "Reply-To: OLAC Administrator <olac-admin@language-archives.org>\r\n";
  if ($cc) $header .= "Cc: $cc\r\n";
  $header .= "X-Mailer: PHP/" . phpversion();
  mail($to, $subject, $msg, $header);
}

function update_repository($repoid, $postedurl)
{
  $file = preg_replace("! |/!", "_", $repoid) + ".xml";
  $base = "/web/language-archives";
  $src = "$base/register/pending/" . basename($postedurl);
  $dst = "$base/devel/sr/$file";
  if (!rename($src, $dst)) {
    error("file system error while updating the repository\n\n" .
          "repoid: $repoid\n" .
	  "posted url: $postedurl\n");
    return FALSE;
  }
  return TRUE;
}

$magic = $_GET["v"];
$DB = new OLACDB("olac2");
$sql = "select * from PendingConfirmation c, OLAC_ARCHIVE oa ";
$sql .= "where c.repository_id=oa.RepositoryIdentifier and c.magic_string='$magic'";
$rows = $DB->sql($sql);
if ($DB->saw_error()) {
  error("database error while confirming change of base url request\n" .
	"it happened while trying to retrieve the confirmation record\n\n" .
	"Magic string: $magic\n" .
	"DB error msg: " . $DB->get_error_msg());
  return;
} else if (count($rows) == 0) {
  header("HTTP/1.1 404 not found");
  echo "<h2>Not Found</h2>";
  return;
}


?>
<HTML>
<HEAD>
<TITLE>OLAC Archive Registration</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="/olac.css">
</HEAD>

<BODY>
<HR>
<TABLE CELLPADDING="10">
<TR>
<TD> <A HREF="http://www.language-archives.org/"><IMG
SRC="http://www.language-archives.org/images/olac100.gif"
BORDER="0"></A></TD>
<TD> <H1><FONT COLOR="0x00004a">OLAC Archive Registration<br></FONT></H1></TD>
</TR>
</TABLE>
<HR>
<?php


$postedurl = $rows[0]["new_url"];

if (update_repository($postedurl))
  success($magic, $repoid, $baseurl);


?>
<br><br>
Please report any problems to
<a href="mailto:<?=$OLAC_ADMIN_EMAIL?>"><?=$OLAC_ADMIN_EMAIL?></a>

<HR>
<A HREF="http://www.language-archives.org/">OLAC</A>

</BODY>
</HTML>

