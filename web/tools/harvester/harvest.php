<?php

require_once('olac.php');
define("OLAC_PATH", olacvar('docroot'));
require_once(OLAC_PATH.'/lib/php/OLACDB.php');
require_once(OLAC_PATH."/lib/php/utils.php");
define("OLAC_SYS_ADMIN_EMAIL", olacvar('tech_email'));

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
     "registration problem (/tools/harvester/harvest.php)",
     $msg);
  echo <<<EOT
<p><font color=red><b>Error</b></font></p>
<p>Due to a system problem, we cannot process your request at this moment.
Please try again. The OLAC System Admin has been notified.</p>
EOT;
  return;
} 

$DB = new OLACDB();

$repoid = $_GET["id"];
$adminemail = get_admin_email($DB, $repoid);
if ($adminemail === FALSE) {
  error("Database error while obtaining AdminEmail for $repoid\n\n".
	"DB error msg: " . $DB->get_error_message() . "\n" .
	"SQL: " . $DB->get_error_sql());
  return;
}
$baseurl = get_baseurl($DB, $repoid);
if ($baseurl === FALSE) {
  error("Database error while obtaining base URL for $repoid\n\n".
	"DB error msg: " . $DB->get_error_message() . "\n" .
	"SQL: " . $DB->get_error_sql());
  return;
}
$magic = get_confirmation_magic_string($DB);
if ($magic === FALSE) {
  error("Database error while obtaining magic string\n\n" .
	"DB error msg: " . $DB->get_error_message() . "\n" .
	"SQL: " . $DB->get_error_sql());
  return;
}
$repotype = get_repository_type($DB, $repoid);
if ($repotype === FALSE) {
  error("Database error while obtaining repository type\n\n" .
	"DB error msg: " . $DB->get_error_message() . "\n" .
	"SQL: " . $DB->get_error_sql());
  return;
}
$sql = "insert into PendingConfirmation (magic_string, repository_id, repository_type, new_url, ctype) values ('$magic', '$repoid', '$repotype', '$baseurl', 'h')";
$DB->sql($sql);
if ($DB->saw_error()) {
  error("Database error while recording pending confirmation\n\n" .
	"DB error msg: " . $DB->get_error_message() . "\n" .
	"SQL: " . $DB->get_error_sql());
  return;
}

$subject = "[OLAC] forced full harvest confirmation";
$url = olacvar('harvester/web_interface_confirm');
$msg = <<<EOT
Administrator of $repoid:

Someone has requested a full re-harvest of your OLAC repository hosted at
$baseurl.

To confirm this, please visit the following url.

$url?v=$magic

EOT;

mail_by_olac_admin($adminemail, $subject, $msg);

echo <<<EOT
<p>An email has been sent to '$adminemail'. Please follow instructions
in the email to confirm your re-harvest request.</p>
EOT;

?>
