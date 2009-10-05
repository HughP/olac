<?php
# Full reharvest repository confirmation script.
# User uses this page to confirm that he has request the change.

require_once('olac.php');
define("OLAC_PATH", olacvar('docroot'));
require_once(OLAC_PATH.'/lib/php/OLACDB.php');
require_once(OLAC_PATH.'/lib/php/utils.php');
define("OLAC_SYS_ADMIN_EMAIL", olacvar('tech_email'));
$OLAC_ADMIN_EMAIL = olacvar('olac_admin_email');

$error_log = array();

function error_handler($errno, $errstr, $file, $lineno)
{
  global $error_log;
  $error_log[] = "$file [line $lineno]: $errstr";
}

set_error_handler(error_handler);

function error($msg)
{
  global $error_log;

  $msg .= "\n\n";
  foreach ($error_log as $error_line) {
    $msg .= $error_line;
    $msg .= "\n";
  }
  while (array_pop($error_log)); # clear the log for next use

  mail_by_olac_admin
      (OLAC_SYS_ADMIN_EMAIL,
       "registration problem (" .
       olacvar('harvester/web_interface_confirm') . ')',
       $msg);
  echo "<p><font color=red><b>Error</b></font></p>" .
       "<p>Due to a system problem, we cannot update your repository " .
       "at this moment. Please try again. " .
       "The OLAC System Admin has been notified.</p>";
  return;
}

function success($magic)
{
  global $DB;
  $DB->sql("delete from PendingConfirmation where magic_string='$magic'");
  echo "<p><font color=green><b>HARVEST FINISHED</b></font></p>";
}

function harvest($url, $repotype)
{
  if ($repotype == "Static")
    $opt = "-s";
  else
    $opt = "";
  $cmd = olacvar('harvester/web_interface_backend') . " $opt '$url'";
  $ret = 0;
  system("$cmd 2>&1", $ret);
  if ($ret == 0)
    return True;
  else
    return False;
}

$magic = $_GET["v"];
$DB = new OLACDB();
$sql = "select * from PendingConfirmation c, OLAC_ARCHIVE oa ";
$sql .= "where c.repository_id=oa.RepositoryIdentifier ";
$sql .= "and c.magic_string='$magic' and c.ctype='h'";
$rows = $DB->sql($sql);
if ($DB->saw_error()) {
  error("database error while confirming change of base url request\n" .
	"it happened while trying to retrieve the confirmation record\n\n" .
	"Magic string: $magic\n" .
	"DB error msg: " . $DB->get_error_message());
  return;
} elseif (count($rows) == 0) {
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
<TD> <A HREF="<?=olacvar('baseurl')?>"><IMG
SRC="/images/olac100.gif"
BORDER="0"></A></TD>
<TD> <H1><FONT COLOR="0x00004a">OLAC Archive Registration<br></FONT></H1></TD>
</TR>
</TABLE>
<HR>
<?php
ob_end_flush();
flush();
ob_flush();

$repotype = $rows[0]["repository_type"];
$harvesturl = $rows[0]["new_url"];

$lockfile = "/tmp/olac.harvester.lock";
$fp = fopen($lockfile, "w");
$res = flock($fp, LOCK_EX | LOCK_NB);
if ($res === FALSE) {
  echo "<p>A harvester process is already running. We cannot start a ";
  echo "harvester process while another is running. ";
  echo "Please try again later.</p>";
} else {
  ob_end_flush();
  usleep(5000000);  # trick client's input buffering
  echo "<p>This will take a while. Please be patient.</p>";
  echo "<pre>\n";
  flush();
  $res = harvest($harvesturl, $repotype);
  echo "</pre>\n";
  success($magic);
}    
fclose($fp);
@unlink($lockfile);

?>
<br><br>
Please report any problems to
<a href="mailto:<?=$OLAC_ADMIN_EMAIL?>"><?=$OLAC_ADMIN_EMAIL?></a>

<HR>
<A HREF="<?=olacvar('baseurl')?>">OLAC</A>

</BODY>
</HTML>

