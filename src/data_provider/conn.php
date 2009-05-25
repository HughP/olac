<?php
/* conn()
 * A simple function which connects to a database and returns a handle
 * to it.
 *
 * Seperated into this file so that the values can be easily changed.
 */

if(!defined("safe_include")) die("Sorry, this file not for outside access");

function conn() {
	$host = "HOST";
	$user = "USER";
	$pass = "PASS";
	$database = "DATABASE";

	$linkID = mysql_connect($host, $user, $pass) or die("Cannot connect to database");
	mysql_select_db($database, $linkID);
	return $linkID;
}

?>
