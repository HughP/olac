<!--
  Registration script for OLAC
  Steven Bird 2002-05-10

  This script tests validity of xml responses and olac-pmh conformance.
  For successful registration, OAI membership is required.

  ChangeLog:

  $Log: register.php4,v $
  Revision 1.15  2005/11/29 19:36:16  haepal
  added schematron validation option to the schematron validation error message


  2004-11-18  Haejoong Lee  <haejoong@ldc.upenn.edu>
	* replaced flush() with myflush()

  2003-03-23  Haejoong Lee  <haejoong@ldc.upenn.edu>
	* added links to OLAC Repositories and OLAC Metadata

  2003-03-19  Haejoong Lee  <haejoong@ldc.upenn.edu>
	* implemented repository type auto detection

  2003-03-18  Haejoong Lee  <haejoong@ldc.upenn.edu>
	* imported SRV

  2003-03-11  Haejoong Lee  <haejoong@ldc.upenn.edu>
	* $URLTOFILE: / -> @
	* report_error(): $file argument added for the file that caused the
	error. $include_log indicates the procedure that observed the error -
	0 - schematron, 1 - XSV, 2 - Xerces-J

  2003-03-07  Haejoong Lee  <haejoong@ldc.upenn.edu>
	* cleaned up an unnoticed garbage
	* seperated register/unregister procedure from validate() function
	* pmh() should exit if there's a download error
	* accept $_GET[testnospam] -- if exists, emails are directed to
	$TESTER_EMAIL and register() returns doing nothing
	* all emails are cc'ed to $TESTER_EMAIL

  2003-02-28  Haejoong Lee  <haejoong@ldc.upenn.edu>
	* revised for OLAC 1.0 standards

  Previous ChangeLogs:
   - forced registration (register=1) also sends notification out
     unlink() functions have been moved inside of validate&register block
     (2002-12-19 HL)
   - fatal_error(): now reports repository id and url
   - notify(): inform olac-admin of review site
     (2002-11-25 HL)
   - fixed register() not to delete any records
     changed "REGISTERED" message and confirmation email message
     (2002-11-19 HL)
   - removed OAI membership test 2002-10-22
-->

<?php

define(OLAC_PATH, '/web/language-archives');
define(OLAC_TOOLS, '/pkg/ldc/wwwhome/olac');
require_once(OLAC_PATH.'/lib/php/OLAC_general.php');
require_once(OLAC_PATH.'/lib/php/OLACDB.php');

$TESTER_EMAIL = "haejoong@ldc.upenn.edu";
$POSTEDURL = "";

define(OLAC_URL,      'http://www.language-archives.org');
define(CHAR_LIMIT,    1000);   # how many chars of schematron output to print
define(DR_STRON,      'scripts-1.1/olac-dynamic-repository.xsl');
define(SR_STRON,      'scripts-1.1/olac-static-repository.xsl');
define(XSV_TRANSFORM, 'scripts-1.1/xsv_output_transform.xsl');
define(XSV_XSL,       OLAC_TOOLS.'/xsv/lib/python2.3/site-packages/XSV/pubtext/xsv.xsl');
define(XSV,           OLAC_TOOLS.'/bin/xsv_xml');
define(XERCESJ,       OLAC_TOOLS.'/bin/xercesj');
define(XSLT,          OLAC_TOOLS.'/bin/xalan');
define(GWTEST,        OLAC_TOOLS.'/bin/gwtest');
define(CGISTRON,      'http://www.language-archives.org/cgi-bin/schematron.cgi');


function myurlencode($url) {
  $tmp = preg_replace("'/'", "@", $url);
  return $tmp;
}


function myflush() {
  ob_end_flush();
  flush();
  ob_flush();
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
  $sock = fsockopen($host, $port, $errno, $errstr, 30);
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
  global $TESTER_EMAIL;
  global $POSTEDURL;
  if ($_GET[testnospam])
    $OLAC_ADMIN_EMAIL = $TESTER_EMAIL;

  error($str);
  $mailmsg = "$str\n\nRepository URL: $POSTEDURL\n";
  mail($OLAC_ADMIN_EMAIL, "OLAC REGISTRATION - FATAL ERROR", $mailmsg, "Cc: $TESTER_EMAIL\r\n");
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
    fatal_error("Field \"$field\" was missing or empty in <a href=\"$file\">the file</a>.");
  }

  return $answer;
}



function notify($id, $dp_admin, $bypass=0) {
  global $OLAC_ADMIN_EMAIL;
  global $TESTER_EMAIL;
  global $POSTED_URL;
  if ($_GET[testnospam]) {
    $OLAC_ADMIN_EMAIL = $TESTER_EMAIL;
    $dp_admin = $TESTER_EMAIL;
  }

  print "<p>Email notification sent to: $dp_admin, $OLAC_ADMIN_EMAIL.</p>\n";
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

  mail($OLAC_ADMIN_EMAIL, "OLAC registration received", $msg1, "From:$OLAC_ADMIN_EMAIL\r\nCc: $TESTER_EMAIL\r\n");
  mail($dp_admin, "OLAC registration received", $msg2, "From:$OLAC_ADMIN_EMAIL\r\nCc: $TESTER_EMAIL\r\n");
}



function register($id, $dp_admin) {
  global $DB;
  global $REPOTYPE;
  global $POSTEDURL;
  $DB->sql("insert into ARCHIVES (ID,BASEURL,contactEmail, type)
            values ('$id', '$POSTEDURL', '$dp_admin','$REPOTYPE')");
  if ($DB->saw_error()) {
    fatal_error("Insert query failed");
  }
  print "<p><font color=\"green\"><b>REGISTRATION REQUEST HAS BEEN FILED FOR REVIEW</b></font><br>We will review the request and register the archive shortly.</p>";
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



function dr_validate(&$id, &$dp_admin) {
  global $TESTER_EMAIL;
  global $URLTOFILE;
  global $POSTEDURL;
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
  $id = get_element('repositoryIdentifier', $ID_xml);

  $dp_admin = get_element('adminEmail', $ID_xml);
  $dp_admin = ereg_replace("mailto:", '', $dp_admin);

  pmh($LM_xml, $LM_test);
  pmh($LI_xml, $LI_test);
  pmh($LR_xml, $LR_test);

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

?>

<HTML>
<HEAD>
<TITLE>OLAC Archive Registration</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../olac.css">
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
Learn more about OLAC registration</a> |
<a href="http://www.language-archives.org/archives.php4">
View registered archives</a>

<br><br>
<form enctype="multipart/form-data" method="post">
<b>Base URL:</b><br>
<input type="text" size="50" maxlength="300" name="url"
       value="<?php
         if ($_POST[url]) {
	   $POSTEDURL = $_POST[url];
           print $POSTEDURL;
         }
	 elseif ($_GET[url] && $_GET[register]==1) {
	   print $_GET[url];
	   $POSTEDURL = $_GET[url];
	 } 
	 else {
           print "http://";
	   $POSTEDURL = "";
         }
       ?>"
>

<p>
<input type="submit" name="submit" value="VALIDATE &amp; REGISTER"/>
&nbsp;&nbsp;
<input type="submit" name="validate" value="VALIDATE ONLY"/>
</p>

<p>This is an interface for validating and registering a new OLAC archive.
An OLAC archive can be in the form of either a dynamic or static repository.
Before registration, please make sure that your repository conforms to the
following stadards, against which your repository will be tested during
the registration process:

<dl>
<dd><a href="http://www.language-archives.org/OLAC/repositories.html">
OLAC Repositories standard</a>, and</dd>
<dd><a href="http://www.language-archives.org/OLAC/metadata.html">
OLAC Metadata standard</a>.</dd>
</dl>
</p>

<p>(NB Registration or validation may take several minutes)
</form>

<?php

if ($POSTEDURL) {
  if (substr($POSTEDURL, 0, 7) != 'http://') {
    $POSTEDURL = "http://$POSTEDURL";
  }
  $URLTOFILE = 'tmp/'.myurlencode($POSTEDURL);
  exec("rm -f $URLTOFILE*");
  $DB = new OLACDB("olac2");

  #
  # detect repository type
  #
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
  }
  else {
    print "<hr><p>Can't connect. Please check the base URL again.</p>";
  }


  #
  # dynamic repository
  #
  if ($REPOTYPE == "Dynamic") {
    $id = $dp_admin = '';
    if ($_GET[register]==1) {
      download($URLTOFILE);
      $id = get_element('repositoryIdentifier', $URLTOFILE);
      $dp_admin = get_element('adminEmail', $URLTOFILE);
      $dp_admin = preg_replace("/^mailto:/", "", $dp_admin);
      register($id, $dp_admin);
      notify2($id, $dp_admin, 1);
    }      
    else if ($_POST[submit] && dr_validate($id, $dp_admin)) {
      register($id, $dp_admin);
      notify($id, $dp_admin);
    }
    else {
      #assert(empty($_POST[submit]));
      #assert(!empty($_POST[validate]));
      dr_validate($id, $dp_admin);
    }
  }

  #
  # static repository
  #
  else if ($REPOTYPE == "Static") {
    if ($_GET[register] == 1) {
      download($URLTOFILE);
      $id = get_element('repositoryIdentifier', $URLTOFILE);
      $dp_admin = get_element('adminEmail', $URLTOFILE);
      $dp_admin = preg_replace("/^mailto:/", "", $dp_admin);
      register($id, $dp_admin);
      notify($id, $dp_admin, 1);
    }
    else if ($_POST[submit] && sr_validate($URLTOFILE)) {
      $id = get_element('repositoryIdentifier', $URLTOFILE);
      $dp_admin = get_element('adminEmail', $URLTOFILE);
      $dp_admin = preg_replace("/^mailto:/", "", $dp_admin);
      register($id, $dp_admin);
      notify($id, $dp_admin);
    }
    else {
      #assert(empty($_POST[submit]));
      #assert(!empty($_POST[validate]));
      sr_validate($URLTOFILE);
    }
  }

}
?>

<br><br>
Please report any problems to
<a href="mailto:<?=$OLAC_ADMIN_EMAIL?>"><?=$OLAC_ADMIN_EMAIL?></a>

<HR>
<A HREF="http://www.language-archives.org/">OLAC</A>

</BODY>
</HTML>
