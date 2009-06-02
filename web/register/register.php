<?php
#  Registration script for OLAC
#  Originally written by Steven Bird on 2002-05-10
#  Revised by Haejoong Lee for OLAC 1.0.
#  Revised by Haejoong Lee for OLAC 1.1 in Summer 2008.
#

define(OLAC_PATH, '/web/language-archives');
define(OLAC_TOOLS, '/pkg/ldc/wwwhome/olac');
require_once(OLAC_PATH.'/lib/php/OLAC_general.php');
require_once(OLAC_PATH.'/lib/php/OLACDB.php');

$POSTEDURL = "";

define('TESTER_EMAIL',  'haejoong@ldc.upenn.edu');
define('OLAC_URL',      'http://www.language-archives.org');
define('CHAR_LIMIT',    1000);   # how many chars of schematron output to print
define('DR_STRON',      'scripts-1.1/olac-dynamic-repository.xsl');
define('SR_STRON',      'scripts-1.1/olac-static-repository.xsl');
define('VERSION_STRON', 'scripts-1.1/olac-version.xsl');
define('XSV_TRANSFORM', 'scripts-1.1/xsv_output_transform.xsl');
define('XSV_XSL',       OLAC_TOOLS.'/xsv/lib/python2.3/site-packages/XSV/pubtext/xsv.xsl');
define('XSV',           OLAC_TOOLS.'/bin/xsv_xml');
define('XERCESJ',       OLAC_TOOLS.'/bin/xercesj');
define('XSLT',          OLAC_TOOLS.'/bin/xalan');
define('GWTEST',        OLAC_TOOLS.'/bin/gwtest');
define('CGISTRON',      'http://www.language-archives.org/cgi-bin/schematron.cgi');


function myurlencode($url) {
  $tmp = preg_replace("'/'", "@", $url);
  return $tmp;
}


function myflush() {
  ob_end_flush();
  flush();
  ob_flush();
}

function mail_by_olac_admin($to, $subject, $msg, $cc="")
{
  $header = "From: OLAC Web Server <www@ldc.upenn.edu>\r\n";
  $header .= "Reply-To: OLAC Administrator <olac-admin@language-archives.org>\r\n";
  if ($cc) {
    $header .= "Cc: $cc\r\n";
  }
  $header .= "X-Mailer: PHP/" . phpversion();
  mail($to, $subject, $msg, $header);
}

function get_data_using_socket($url, &$data) {
  # open the remote http port and get data
  ereg("http://([^/:]+):?([0-9]*)(/.*)", $url, $reg);
  $host = $reg[1];
  $port = $reg[2];
  $path = $reg[3];
  if (!$port) {
    $port = 80;
  }
  $sock = @fsockopen($host, $port, $errno, $errstr, 30);
  if ($sock) {
    $data = '';
    $location = '';
    fputs($sock, "GET $path HTTP/1.0\r\nHost: $host\r\n\r\n");
    $line = "pass me";
    while (!feof($sock)) {
      $line = fgets($sock, 1024);
      if (preg_match("'^Location: (.*)'",$line,$group)) {
        $location = $group[1];
        break;
      }
      if (preg_match("/^\s*$/",$line)) {
        break;
      }
    }
    while (!feof($sock)) {
      $data .= fgets($sock,1024);
    }
    fclose($sock);

    if ($location) {
      get_data_using_socket($location, $data);
    }
  }
}



function get_data($file, $url) {
  # download the data form $url
  if ($arr = @file($url)) {             # first try using file()
    $data = @join('', $arr);
  } else {
    get_data_using_socket($url, $data); # second try using socket
  }

  if (! $data) {    # download failed
    error("Could not read URL \"$url\"");
    return 0;
  }

  # open $file for writing
  $fp = fopen($file, 'w');
  if (! $fp) {      # sysgem error - can't open the file
    fatal_error("Could not open file \"$file\" for writing");
    return 0;
  }

  # ok
  fputs($fp, $data);
  fclose($fp);
  return 1;
}



function error($str) {
  print "<p><font color=red><b>ERROR: $str</b></font></p>\n";
  myflush();
}



function report_dr_error($test, $file, $include_log) {
  global $POSTEDURL;
  $requrl = "$POSTEDURL?$test";
  error("Test failed");
  print "<p>Here are some URLs which may help in diagnosing the problem:</p>";
  print "<ul>";
  print "<li><a href=\"$requrl\">$requrl</a></li>";
  print "<li><a href=\"$file\">Local copy</a> of that response that we've tested</li>";
  if ($include_log) {
    if ($include_log == 1) {
      $xsv_log = "$file-xsv.html";
      print "<li><a href=\"$xsv_log\">XSV error log</a></li>";
    }
    if ($include_log == 2) {
      $xercesj_log = "$file-xercesj.txt";
      print "<li><a href=\"$xercesj_log\">Xerces-J error log</a></li>";
    }
    print "<li><a href=\"/tools/xsv\">XML Schema validator</a></li>";
  }
  print "<li><a href=\"http://rocky.dlib.vt.edu/~oai/cgi-bin/Explorer/oai2.0/testoai?archive=$POSTEDURL\">Repository Explorer for this archive</a></li>";
  print "</ul>";
  myflush();
}



function report_sr_error($file, $include_log) {
  $logprefix = $file;
  error("Test failed");
  print "<p>Here are some URLs which may help in diagnosing the problem:</p>";
  print "<ul>";
  print "<li><a href=\"$logprefix\">The file we've tested</a></li>";
  if ($include_log) {
    if ($include_log == 1) {
      $xsv_log = "$logprefix-xsv.html";
      print "<li><a href=\"$xsv_log\">XSV error log</a></li>";
    }
    if ($include_log == 2) {
      $xercesj_log = "$logprefix-xercesj.txt";
      print "<li><a href=\"$xercesj_log\">Xerces-J error log</a></li>";
    }
    print "<li><a href=\"/tools/xsv\">XML Schema validator</a></li>";
  }
  print "</ul>";
  myflush();
}



function fatal_error($str) {
  global $OLAC_ADMIN_EMAIL;
  global $POSTEDURL;
  if ($_GET[testnospam])
    $OLAC_ADMIN_EMAIL = TESTER_EMAIL;

  error($str);
  #$mailmsg = "$str\n\nRepository URL: $POSTEDURL\n";
  #mail($OLAC_ADMIN_EMAIL, "OLAC REGISTRATION - FATAL ERROR", $mailmsg, "Cc: ".TESTER_EMAIL."\r\n");
  die();
}



function report_result($result) {
  print "<h3>Validation Result:</h3>\n";
  if ($result) {
    print "<h2><font color=green><b>SUCCESS</b></font></h2>\n";
  } else {
    print "<h2><font color=\"red\"><b>FAILURE</b></font></h2>\n";
  }
}



function get_output($cmd, $num) {
  $fp = popen($cmd, 'r');
  $result = fread($fp, $num);
  pclose($fp);
  return $result;
}



# get the content of an XML element
function get_element($field, $file) {
  if ($data = @join("", @file($file))) {
    $data = preg_replace("/<!--.*?-->/s", "", $data);
    $pat = '/<([^:> \t\n]+:)?'.$field.'[^>]*>([^<]+)<\/([^:> \t\n]+:)?'.$field.'>/';
    if (preg_match("$pat", $data, $matches)) {
      $answer = $matches[2];
    }
  } else {
    fatal_error("Could not open <a href=\"$file\">the file</a> for reading");
  }

  if (! $answer) {
    fatal_error("Field \"$field\" is missing or empty in <a href=\"$file\">the file</a>.");
  }

  return $answer;
}



function notify($id, $dp_admin, $bypass=0) {
  global $OLAC_ADMIN_EMAIL;
  global $POSTED_URL;
  if ($_GET[testnospam]) {
    $OLAC_ADMIN_EMAIL = TESTER_EMAIL;
    $dp_admin = TESTER_EMAIL;
  }

  $emailarr = preg_split("{\s+}", $OLAC_ADMIN_EMAIL);
  array_unshift($emailarr, $dp_admin);
  $emails = implode(", ", $emailarr);
  print "<p>Email notification sent to: $emails.</p>\n";
  $message = "
Registration request for
    Repository ID: $id
    Repository URL: $POSTEDURL
    adminEmail: $dp_admin
has been filed for review.
";

  if ($bypass) {
    $message .= "\n(Note: This repository didn't go throuth the OLAC Validation step.)\n";
  }

  $msg1 = $message . "
Visit the following URL to review the archive

   http://www.language-archives.org/register/archive_review.php4

(This message was Generated by register.php4)
";

  $msg2 = "
Dear $id administrator,

Thank you for registering the archive.

$message

We will review and register the archive shortly.  You will be notified
as soon as we process your archive. Thank you.

Regards,

OLAC administration team
$OLAC_ADMIN_EMAIL

";

  mail_by_olac_admin($OLAC_ADMIN_EMAIL,
		     "OLAC registration received",
		     $msg1,
		     $OLAC_SYS_ADMIN_EMAIL);
  mail_by_olac_admin($dp_admin,
		     "OLAC registration received",
		     $msg2,
		     $OLAC_SYS_ADMIN_EMAIL);
		     
}



function register($id, $dp_admin) {
  global $DB;
  global $OLAC_ADMIN_EMAIL;
  
  $repoid = $_POST["repositoryid"];
  $repotype = $_POST["repositorytype"];
  $baseurl = $_POST["baseurl"];
  $adminemail = $_POST["adminemail"];

  $DB->sql("insert into ARCHIVES (ID,BASEURL,contactEmail, type) " .
           "values ('$repoid', '$baseurl', '$adminemail','$repotype') " .
           "on duplicate key update ID='$repoid', BASEURL='$baseurl', " .
           "contactEmail='$adminemail', type='$repotype'");
  if ($DB->saw_error()) {
    error("Database error");

    echo <<<EOT
<p>Registration failed due to a system error. You can either try it again or
notify OLAC administrators who can manually register your repository.
Click on the "NOTIFY REGISTRATION ERROR" button below to notify
OLAC administrators.</p>

<form method="post">
<inpyt type="hidden" name="repositoryid" value="$repoid"/>
<input type="hidden" name="repositorytype" value="$repotype"/>
<input type="hidden" name="baseurl" value="$baseurl"/>
<input type="hidden" name="adminemail" value="$adminemail"/>
<input type="submit" name="action" value="NOTIFY REGISTRATION ERROR"/>
</form>
EOT;
  }
  else {
    echo <<<EOT
<p><font color="green"><b>REGISTRATION REQUEST HAS BEEN FILED FOR REVIEW</b>
</font><br>We will review the request and register the archive shortly.</p>
EOT;
    notify($repoid, $adminemail);
  }
}



function change_baseurl()
{
  global $DB;
  global $OLAC_SYS_ADMIN_EMAIL;

  clear_page();

  $adminemail = $_POST["adminemail"];
  $baseurl = $_POST["baseurl"];
  $repoid = $_POST["repositoryid"];

  $error_msg = <<<EOT
<p><font color=red><b>Error</b></font></p>
<p>A database error occurred while processing your request.
Please try it again later.  If problem continues, please let us know
by email.  Sorry about the inconvenience.</p>
EOT;

  while (true) {
    $magic = sha1(rand().rand().rand());
    $sql = "select count(*) c from PendingConfirmation where magic_string='$magic'";
    $rows = $DB->sql($sql);
    if ($DB->saw_error()) {
      $subject = "olac registration error (kind 1)";
      $msg = "Database failed when checking existence of magic string.\n\n";
      $msg .= "Magic string: $magic";
      $msg .= "DB error msg: " . $DB->get_error_message();
      mail_by_olac_admin($OLAC_SYS_ADMIN_EMAIL, $subject, $msg);
      echo $error_msg;
      return;
    }
    if ($rows[0]["c"] == 0) {
      $sql = "insert into PendingConfirmation (magic_string, repository_id, repository_type, new_url) ";
      $sql .= "values ('$magic', '$_POST[repositoryid]', '$_POST[repositorytype]', '$_POST[baseurl]')";
      $DB->sql($sql);
      if ($DB->saw_error()) {
	$subject = "olac registration error (kind 2)";
	$msg = "Database failed when inserting confirmation request.\n\n";
	$msg .= "DB error msg: " . $DB->get_error_message();
	mail_by_olac_admin($OLAC_SYS_ADMIN_EMAIL, $subject, $msg);
	echo $error_msg;
	return;
      } else {
	break;
      }
    }
  }
  
  $confirmation_url = OLAC_URL . "/register/confirm.php?v=$magic";

  $msg = <<<EOT
Administrator of $repoid:

Someone has requested a change of base URL of your repository registered with
OLAC. To confirm this, please visit the following URL:

  $confirmation_url

This message was automatically generated by OLAC Registration Service.

EOT;

  $subject = "OLAC Registration Confirmation";
  mail_by_olac_admin($adminemail, $subject, $msg);

  echo <<<EOT
<p><font color=green><b>REQUEST FOR CONFIRMATION HAS BEEN SENT</b></font></p>
<p>An email has been sent to the following email address. Please check the
email and follow the included link to confirm the change of registration.</p>
<p>Admin email: $adminemail</p>
EOT;
}



function unregister() {
  global $DB;
  global $POSTEDURL;
  $DB->sql("delete from ARCHIVES where BASEURL='$POSTEDURL'");
  if ($DB->saw_error()) {
    fatal_error("Delete query failed");
  }
  print "<h2><font color=\"green\">ARCHIVE UNREGISTERED</font></h2>\n";
}



function pmh($file, $test) {
  global $POSTEDURL;
  $requrl = "$POSTEDURL?$test";
  print "<p>Fetching data for protocol request: $test\n";
  myflush();

  if (get_data($file, $requrl)) {
    if (! preg_match("'</(\w+:)?error>\s*</(\w+:)?OAI-PMH>'s", join('',@file($file)))) {
      print "<font color=green>OK</font>\n";
      chmod($file, 0644);
      return;
    }
    else {
      error("Protocol request failed for URL: \"$requrl\"");
      if (preg_match("'verb=GetRecord'", $test)) {
        print <<<END
<p>Note: We issued the GetRecord request using the sampleIdentifier of the
oai-identifier element.  This might have caused the error.  Please make sure
the the sampleIdentifier is the id of an existing record.  See
<a href="/OLAC/repositories.html#OAI identifier description">OLAC
Repositories standard</a> for the sampleIdentifier requirement.</p>
END;
      }
    }
  }
  else {
    error("Protocol request failed for URL: \"$requrl\"");
  }

  report_dr_error($test, $file, 0);
  report_result(0);
  myflush();
  exit;
}



function download($file) {
  global $POSTEDURL;
  print "<p>Downloading...";
  myflush();

  if (get_data($file, $POSTEDURL)) {
    print "<font color=green>OK</font>\n";
    chmod($file, 0644);
  }
  else {
    error("Download failed for URL: \"$requrl\"");
    #report_error(0);
    report_result(0);
    exit;
  }
  myflush();
}



function test_dr_valid($file, $test) {
  $logprefix = $file;
  $result1 = 1;
  $result2 = 1;

  print '<p><b>Testing protocol request: '.$test."</b><br>\n";
  myflush();

  #####
  # XSV validation
  $xsv_xml_output = "$logprefix-xsv.xml";
  $xsv_html_output = "$logprefix-xsv.html";
  exec(XSV." $file $xsv_xml_output");
  exec(XSLT." $xsv_xml_output ".XSV_XSL." $xsv_html_output");
  $output = get_output(XSLT." $xsv_xml_output ".XSV_TRANSFORM, CHAR_LIMIT);
  print str_replace("OK.", "XSV <font color=green>OK</font>", $output);
  if (substr_count($output, "OK") == 0) {
    $msg = join(file($xsv_xml_output),'');
    if (substr_count($msg, 'timeout')) {
      print "XSV <font color=red>Timeout</font>";
    } else {
      report_dr_error($test, $file, 1);
    }
    $result1 = 0;
  }
  myflush();

  #####
  # Xerces-J validataion
  $xercesj_output = "$logprefix-xercesj.txt";
  $output = get_output(XERCESJ." $file", CHAR_LIMIT);
  # save output for future reference
  $fp = fopen($xercesj_output, 'w');
  fputs($fp, $output);
  fclose($fp);
  # output result
  if ($output) {
    report_dr_error($test, $file, 2);
    $result2 = 0;
  } else {
    print " - Xerces-J <font color=green>OK</font>";
  }
  myflush();

  return ($result1 || $result2);
}



function test_dr_conformant($file, $test) {
  print '<p><b>Testing protocol request: '.$test."</b><br>\n";
  myflush();

  $command = XSLT." $file ".DR_STRON.' | egrep -v "In pattern"';
  $output = get_output($command, CHAR_LIMIT);
  if (! $output) {
    error('Conformance test generated no output for test: '.$test);
    $url = CGISTRON."?url=http://www.language-archives.org/register/tmp/$file&type=dynamic";
    $here = "<a style=\"text-decoration:underline; color:blue\" onClick=\"window.open('$url')\">here</a>";
    print "Click $here to run the validation again and see if there is any error.";
    error('Please take a more closer look at your file for any (formatting) error.');
    report_dr_error($test, $file, 0);
    return 0;
  }
    
  # manually generate a response that schematron should have generated!
  $output1 = ereg_replace("\n", "<br>\n", $output);
  $output1 = preg_replace("/(ERROR[^\n]*)/", "<font color=red>$1</font>", $output1);
  $output1 = str_replace("OK", "<font color=green>OK</font>", $output1);
  print $output1;
  if (strlen($output) == CHAR_LIMIT) {
    print "&nbsp;<b>ETC...</b>";
  }

  if (preg_match("/ERROR/",$output1)) {
    report_dr_error($test, $file, 0);
    return 0;
  }

  return 1;
}



function check_olac_version($file)
{
  print '<p>Checking OLAC version... ';
  myflush();
  $command = XSLT . " $file " . VERSION_STRON;
  $command .= ' | grep -v "In pattern" | head -n 10 | sed \'s/^\s*//\'';
  $output = get_output($command, CHAR_LIMIT);
  $h = array();
  foreach (explode("\n", trim($output)) as $line) {
    $key = trim($line);
    $h[$key] += 1;
  }
  if (count($h) != 1) {
    echo "<font color=red>error</font></p>";
    myflush();
    fatal_error("Cannot check the version of the repository.");
  } else {
    $keys = array_keys($h);
    echo "<font color=green>" . $keys[0] . "</font></p>";
    myflush();
    $a = explode(' ', $keys[0]);
    if ($a[1] == '1.0') {
      $msg = "OLAC 1.0 repository detected. Please upgrade it to 1.1. (See ";
      $msg .= '<a href="  http://olac.wiki.sourceforge.net/Call_for_1.1">';
      $msg .= 'instructions</a>.)';
      fatal_error($msg);
    }
    else if ($a[1] != '1.1')
      fatal_error("Not OLAC 1.1 repository.");
  }
}



function dr_validate() {
  global $URLTOFILE;
  global $POSTEDURL;
  global $IDENTIFY_XML;

  $ID_xml = sprintf("%s_ID.xml", $URLTOFILE);
  $LM_xml = sprintf("%s_LM.xml", $URLTOFILE);
  $LI_xml = sprintf("%s_LI.xml", $URLTOFILE);
  $LR_xml = sprintf("%s_LR.xml", $URLTOFILE);
  $GR_xml = sprintf("%s_GR.xml", $URLTOFILE);

  $ID_test = 'verb=Identify';
  $LM_test = 'verb=ListMetadataFormats';
  $LI_test = 'verb=ListIdentifiers&metadataPrefix=olac';
  $LR_test = 'verb=ListRecords&metadataPrefix=olac';
  $GR_test_base = 'verb=GetRecord&metadataPrefix=olac';

  print "<hr><br><h2>Validation Log</h2>\n";
  print "<p>Archive: $POSTEDURL";
  myflush();

  print "<h2>Retrieving Data</h2>";
  pmh($ID_xml, $ID_test);
  check_olac_version($ID_xml);
  pmh($LM_xml, $LM_test);
  pmh($LI_xml, $LI_test);
  pmh($LR_xml, $LR_test);
  check_olac_version($LR_xml);

  # construct the full GetRecord request
  $record_id = get_element('sampleIdentifier', $ID_xml);
  $GR_test = sprintf("%s&identifier=%s", $GR_test_base, $record_id);
  pmh($GR_xml, $GR_test);

  print "<h2>Validating XML Responses</h2>";
  print "<p>(It's sufficient to pass either XSV or Xerces-J validation.)</p>";
  myflush();

  $ID_valid = test_dr_valid($ID_xml, $ID_test);
  $LM_valid = test_dr_valid($LM_xml, $LM_test);
  $LI_valid = test_dr_valid($LI_xml, $LI_test);
  $LR_valid = test_dr_valid($LR_xml, $LR_test);
  $GR_valid = test_dr_valid($GR_xml, $GR_test);
  $valid = ($ID_valid && $LM_valid && $LI_valid && $LR_valid && $GR_valid);

  print "<h2>OLAC-PMH Validation</h2>\n";
  $ID_conf  = test_dr_conformant($ID_xml, $ID_test);
  $LM_conf  = test_dr_conformant($LM_xml, $LM_test);
  $LR_conf  = test_dr_conformant($LR_xml, $LR_test);
  $conformant = ($ID_conf && $LM_conf && $LR_conf);

  $validation_result = $valid && $conformant;
  report_result($validation_result);

  $IDENTIFY_XML = $ID_xml;
  return $validation_result;
}



function sr_schema_valid($file) {
  $result1 = 1;
  $result2 = 1;

  #####
  # XSV validation
  print "<b>XSV</b> - "; myflush();
  $xsv_xml_output = "$file-xsv.xml";
  $xsv_html_output = "$file-xsv.html";
  exec(XSV." $file $xsv_xml_output");
  exec(XSLT." $xsv_xml_output ".XSV_XSL." $xsv_html_output");
  $output = get_output(XSLT." $xsv_xml_output ".XSV_TRANSFORM, CHAR_LIMIT);
  print str_replace("OK.", "XSV <font color=green>OK</font>", $output);
  if (substr_count($output, "OK") == 0 ) {
    $msg = join(file($xsv_xml_output),'');
    if (substr_count($msg, 'timeout') > 0) {
      print "XSV <font color=red>Timeout</font>";
    } else {
      report_sr_error($file, 1);
    }
    $result1 = 0;
  }
  print "<br>\n";
  myflush();


  #####
  # Xerces-J validataion
  print "<b>Xerces-J</b> - "; myflush();
  $xercesj_output = "$file-xercesj.txt";
  $output = get_output(XERCESJ." $file", CHAR_LIMIT);
  # save output for future reference
  $fp = fopen($xercesj_output, 'w');
  fputs($fp, $output);
  fclose($fp);
  # output result
  if ($output) {
    report_sr_error($file, 2);
    $result2 = 0;
  } else {
    print "<font color=green>OK</font>";
  }
  myflush();

  return ($result1 || $result2);
}



function sr_schematron_valid($file) {
  $command = XSLT." $file ".SR_STRON.' | egrep -v "In pattern"';
  $output = get_output($command, CHAR_LIMIT);
  if (! $output) {
    error('Conformance test generated no output.');
    $url = CGISTRON."?url=http://www.language-archives.org/register/tmp/$file&type=static";
    $here = "<a style=\"text-decoration:underline; color:blue\" onClick=\"window.open('$url')\">here</a>";
    print "Click $here to run the validation again and see if there is any error.";
    error('Please take a more closer look at your file for any (formatting) error.');
    report_sr_error($file, 0);
    return 0;
  }
    
  # manually generate a response that schematron should have generated!
  $output1 = ereg_replace("\n", "<br>\n", $output);
  $output1 = preg_replace("/(ERROR[^\n]*)/", "<font color=red>$1</font>", $output1);
  $output1 = str_replace("OK", "<font color=green>OK</font>", $output1);
  print "$output1";
  if (strlen($output) == CHAR_LIMIT) {
    print "&nbsp;<b>ETC...</b>";
  }
  $v1 = sr_baseurl_check($file);
  $v2 = sr_sampleIdentifier_check($file);

  if (preg_match("/ERROR/",$output1) || $v1==0 || $v2==0) {
    report_sr_error($file, 0);
    return 0;
  }

  return 1;
}



function sr_baseurl_check($URLTOFILE) {
  global $POSTEDURL;
  print "The Base URL in the repository file and the one supplied in the form match - ";
  myflush();
  $baseURL = get_element('baseURL', $URLTOFILE);
  $baseURL = preg_replace("'^\s*(.*?)\s*$'", "\\1", $baseURL);
  if ($baseURL == $POSTEDURL) {
    print "<font color=green>OK</font><br>";
    return 1;
  }
  else {
    print "<font color=red>Failed</font><br>";
    return 0;
  }
}



function sr_sampleIdentifier_check($file) {
  print "The record by the sampleIdentifier really exists in the repository - ";
  myflush();
  $sampleid = get_element('sampleIdentifier', $file);
  $sampleid = preg_replace("'^\s*(.*?)\s*$'", "\\1", $sampleid);
  $bigstr = join('', @file($file));
  if (preg_match("'<(\w+:)?identifier>\s*$sampleid\s*</(\w+:)?identifier>'s", $bigstr)) {
    print "<font color=green>OK</font><br>";
    return 1;
  }
  else {
    print "<font color=red>Failed</font><br>";
    return 0;
  }
}



function sr_srepod_check($file) {
  $output = get_output(GWTEST." $file", CHAR_LIMIT);
  print '<b>Xmlwf</b> of <a href="http://www.jclark.com/xml/expat.html">';
  print 'expat</a> - ';
  myflush();
  if ($output) {
    print '<font color="red">Failed</font>';
    print "<ul><li>Error message:</li><pre>$output</pre></ul>";
    return 0;
  }
  else {
    print '<font color="green">OK</font>';
    return 1;
  }
}


function sr_validate($URLTOFILE) {
  global $POSTEDURL;
  print "<hr><br><h2>Validation Log</h2>\n";
  print "<p>OLAC Static Repository: $POSTEDURL";
  myflush();

  print "<h2>Retrieving Data</h2>";
  myflush();
  download($URLTOFILE);

  check_olac_version($URLTOFILE);

  print "<h2>Requirement Check</h2>\n";
  myflush();
  $v1 = sr_schematron_valid($URLTOFILE);

  print "<h2>OAI Gateway Tests</h2>";
  $v2 = sr_srepod_check($URLTOFILE);
  myflush();

  print "<h2>XML Schema Validation</h2>";
  print "<p>(It's sufficient to pass either XSV or Xerces-J validation.)</p>";
  myflush();
  $v3 = sr_schema_valid($URLTOFILE);

  $validation_result = $v1 && $v2 && $v3;
  report_result($validation_result);
  return $validation_result;
}


function check_repository_type() {
  global $REPOTYPE;
  global $POSTEDURL;
  $REPOTYPE = '';
  #$fp = @fopen("$POSTEDURL?verb=badVerb", "r");
  get_data_using_socket("$POSTEDURL?verb=badVerb", $bvout);
  if ($bvout) {

    if (preg_match("'<(\w+:)?OAI-PMH'", $bvout)) {
      $REPOTYPE = 'Dynamic';
    }
    else if (preg_match("'<(\w+:)?Repository'", $bvout)) {
      $REPOTYPE = 'Static';
    }

    if ($REPOTYPE == '') {
      print <<<END
<hr>
<p>Couldn't determine the type of the repository.  Reasons could be:
<ul>
<li>You gave the wrong URL,</li>
<li>The repository is using the old OLAC 0.4 standards,</li>
<li>The repository doesn't conform to the OLAC standards,</li>
</ul>

For the OLAC 1.0 standards, see
<a href="/OLAC/repositories.html">OLAC Repositories</a> and
<a href="/OLAC/metadata.html">OLAC Metadata</a>.</li>
</p>
END;
    }

  } else {

    print "<hr><p>Can't connect. Please check the base URL again.</p>";

  }

  return $bvout && $REPOTYPE != '';
}


function check_repository_status()
{
  global $DB;
  global $IDENTIFY_XML;

  $id = get_element('repositoryIdentifier', $IDENTIFY_XML);
  $baseurl = get_element('baseURL', $IDENTIFY_XML);
  $sql = "select BaseURL from OLAC_ARCHIVE where RepositoryIdentifier='$id'";
  $rows = $DB->sql($sql);
  if ($DB->saw_error()) return "error";
  if (count($rows) == 0) return "new";
  if ($rows[0]["BaseURL"] == $baseurl)
    return "exists";
  else
    return "new_base_url";
}


function validate() {
  global $REPOTYPE;
  global $URLTOFILE;
  global $IDENTIFY_XML;

  if (!check_repository_type()) return;

  $validation_ok = false;
  if ($REPOTYPE == "Dynamic") {
    $validation_ok = dr_validate();
  }
  else if ($REPOTYPE == "Static") {
    if ($_GET[register] == 1) {
      download($URLTOFILE);
      $validation_ok = true;
    } else {
      $validation_ok = sr_validate($URLTOFILE);
    }
    $IDENTIFY_XML = $URLTOFILE;
  }

  return $validation_ok;
}


function validation_response_for_new_archive()
{
  global $IDENTIFY_XML;
  global $REPOTYPE;
  global $POSTEDURL;
  $id = get_element('repositoryIdentifier', $IDENTIFY_XML);
  $dp_admin = get_element('adminEmail', $IDENTIFY_XML);
  $dp_admin = preg_replace("/^mailto:/", "", $dp_admin);

  echo <<<EOT
<p>Congratulations! Now you can continue to register your repository with OLAC.
If you press the button below, your request will be submitted to the OLAC
Coordinators.</p>

<form enctype="multipart/form-data" method="post">
<input type="hidden" name="repositoryid" value="$id"/>
<input type="hidden" name="repositorytype" value="$REPOTYPE"/>
<input type="hidden" name="baseurl" value="$POSTEDURL"/>
<input type="hidden" name="adminemail" value="$dp_admin"/>
<input type="submit" name="action" value="REGISTER NOW"/>
</form>
EOT;
}


function validation_response_for_existing_archive()
{
  echo <<<EOT
<p>Your repository is valid. It is already registered at this baseURL and
will continue to be harvested.</p>
EOT;
}


function validation_response_for_new_baseurl()
{
  global $IDENTIFY_XML;
  global $POSTEDURL;
  global $REPOTYPE;
  $id = get_element('repositoryIdentifier', $IDENTIFY_XML);
  $dp_admin = get_element('adminEmail', $IDENTIFY_XML);
  $dp_admin = preg_replace("/^mailto:/", "", $dp_admin);

  echo <<<EOT
<p>Your repository is valid. It is already registered, but at a different
baseURL. Press the "CHANGE REGISTRATION" button below to move your repository
to this new base URL.</p>

<form enctype="multipart/form-data" method="post">
<input type="hidden" name="repositoryid" value="$id"/>
<input type="hidden" name="repositorytype" value="$REPOTYPE"/>
<input type="hidden" name="baseurl" value="$POSTEDURL"/>
<input type="hidden" name="adminemail" value="$dp_admin"/>
<input type="submit" name="action" value="CHANGE REGISTRATION"/>
</form>
EOT;
}


function clear_page()
{
  echo "<script>document.getElementById('main').innerHTML='';</script>";
}


function registration_response()
{
  clear_page();
  register($_POST["repositoryid"], $_POST["adminemail"]);
}


function registration_response_for_system_error()
{
  clear_page();
  $msg = <<<EOT
OLAC Administrator:

An attempt to register a valid repository has failed due to a system error.
User was told that he could try later, but he chose to let us do it.  Here's
the registration information.

  Repository ID: $_POST[repositoryid]
  Repository Type: $_POST[repositorytype]
  Base URL: $_POST[baseurl]
  Admin Email: $_POST[adminemail]

This message was automatically generated by OLAC Registration Service.

EOT;

  $subject = "OLAC registration failed due to a system error";
  mail_by_olac_admin($OLAC_ADMIN_EMAIL, $subject, $msg, $OLAC_SYS_ADMIN_EMAIL);

  echo "<p><font color=green><b>NOTIFICATION HAS BEEN SENT TO OLAC ";
  echo "ADMINISTRATORS</b></font></p>";
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

<a href="http://www.language-archives.org/register/archive.html">
Learn about OLAC registration</a> |
<a href="http://www.language-archives.org/archives.php4">
View registered archives</a>

<br><br>
<div id="main">
<form enctype="multipart/form-data" method="post">
<b>Base URL:</b><br>
<input type="text" size="50" maxlength="300" name="url" value=""/>
<input type="submit" name="action" value="VALIDATE"/>
</form>

<p>This is an interface for validating and registering a new OLAC archive.
Once the validation has finished successfully, you will be invited to register
your repository.</p>

<p>An OLAC archive can be in the form of either a dynamic or static repository.
Before registration, please make sure that your repository conforms to the
following standards, against which your repository will be tested during
the registration process:

<dl>
<dd><a href="http://www.language-archives.org/OLAC/repositories.html">
OLAC Repositories standard</a>, and</dd>
<dd><a href="http://www.language-archives.org/OLAC/metadata.html">
OLAC Metadata standard</a>.</dd>
</dl>
</p>

<p>(NB: Validation may take several minutes.)</p>
</div>
<?php



$script = array();
if ($_POST[url]) {
  $POSTEDURL = $_POST[url];
  $script[] = "document.forms[0].url.value = '$POSTEDURL';";
}
elseif ($_GET[url] && $_GET[register]==1) {
  $script[] = "document.forms[0].url.value = '$_GET[url]';";
  $POSTEDURL = $_GET[url];
} 
else {
  $script[] = "document.forms[0].url.value = 'http://';";
  $POSTEDURL = "";
}



?>
<script>
<?= implode("\n", $script); ?>
</script>
<?php



$DB = new OLACDB("olac2");

if ($_POST["action"] == "VALIDATE" && $POSTEDURL) {
  # User entered an URL and clicked on the VALIDATE button.

  if (substr($POSTEDURL, 0, 7) != 'http://') {
    $POSTEDURL = "http://$POSTEDURL";
  }
  $URLTOFILE = 'tmp/'.myurlencode($POSTEDURL);
  exec("rm -f \"$URLTOFILE\"*");

  if (validate()) {
    switch (check_repository_status()) {
    case "new":
      validation_response_for_new_archive();
      break;

    case "exists":
      validation_response_for_existing_archive();
      break;

    case "new_base_url":
      validation_response_for_new_baseurl();
      break;

    case "error":
      echo "<p>Your repository is valid</p>";
      echo "<p>Unfortunately we cannot access our database at this moment. ";
      echo "If you want to register your repository or change the baseURL, ";
      echo "please try again in several minutes.</p>";
      break;
    }
  }
}

else if ($_POST["action"] == "REGISTER NOW") {
  # Validation was successful so the user was offerred an
  # "regieter now" button which he clicked on.
  registration_response();
}

else if ($_POST["action"] == "CHANGE REGISTRATION") {
  change_baseurl();
}

else if ($_POST["action"] == "NOTIFY REGISTRATION ERROR") {
  registration_response_for_system_error();
}

?>
<br><br>
Please report any problems to
<a href="mailto:<?=$OLAC_ADMIN_EMAIL?>"><?=$OLAC_ADMIN_EMAIL?></a>

<HR>
<A HREF="http://www.language-archives.org/">OLAC</A>

</BODY>
</HTML>
