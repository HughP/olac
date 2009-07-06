<?php

define("OLAC_PATH", '/web/language-archives');
require_once(OLAC_PATH.'/lib/php/OLAC_general.php');
require_once(OLAC_PATH.'/lib/php/OLACDB.php');
require_once(OLAC_PATH."/lib/php/utils.php");
define("OLAC_SYS_ADMIN_EMAIL", $OLAC_SYS_ADMIN_EMAIL);

function error($msg)
{ 
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

$DB = new OLACDB("olac2");

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
$msg = <<<EOT
Administrator of $repoid:

Someone has requested a full re-harvest of your OLAC repository hosted at
$baseurl.

To confirm this, please visit the following url.

http://www.language-archives.org/tools/harvest/confirm_h.php?v=$magic

EOT;

mail_by_olac_admin(OLAC_SYS_ADMIN_EMAIL, $subject, $msg);

echo <<<EOT
<p>An email has been sent to '$adminemail'. Please follow instructions
in the email to confirm your re-harvest request.</p>
EOT;

?>
