<?
# freestanding_validate.php4
#
# Validate a free-standing OLAC metadata document
# Gary Simons and Haejoong Lee
# 5 July 2003
#
# See: http://www.language-archives.org/tools/metadata/freestanding.html
#
# Changes:
# 2006-02-14: paths to the external tools have been updated -HL
#
#

# Parameters in the calling POST request
#    metadata -- the submitted free-standing metadata

# If there is no metadata, go back to main page

  if (!$HTTP_POST_VARS['metadata'])
     {
     $mainpage = "http://www.language-archives.org/tools/metadata/freestanding.html";
     header("Content-Type: text/html");
     readfile($mainpage);
     exit;
     }

# PHP changed " to \"; change it back

  $metadata = ereg_replace('\\\"', '"', $HTTP_POST_VARS['metadata']);

# Write the submitted metadata to a temporary file

  $tmpfile = tempnam("tmp", '');
  $tmpfile = "$tmpfile.xml";
  $fd = fopen($tmpfile, 'w');

  ########## Force use of standard OLAC schema
  ##
  $olacns = "http://www.language-archives.org/OLAC/1.0/";
  $olacxsd = $olacns . "olac.xsd";

  ## find namespace prefix for olac tag
  preg_match("{^(.*<(([^/][^:]*):)?olac\s*)([^>]*)(>.*)$}s",$metadata,$group);
  $body1 = $group[1];
  $body2 = $group[4];  # atts of olac tag
  $body3 = $group[5];
  if ($group[3]) {
    $nssuffix = ":$group[3]";
  } else {
    $nssuffix = "";
  }
  $nsprefix = $group[2];

  ## find namespace for olac
  if (preg_match("/xmlns$nssuffix\s*=\s*(\"|')\s*([^\"' \t\n]*)/",
                 $body2, $group)) {
    $ns = $group[2];
  } else {
    $body2 = "xmlns$nssuffix=\"$olacns\" $body2";
    $ns = $olacns;
  }

  ## find&replace schema location for olac
  ## schemaLoc att exists and olac xsd location is specified
  if (preg_match("{xsi:schemaLocation\s*=\s*(\"|').*$ns\s+}",$body2)) {
    $body2 =
    preg_replace("{(xsi:schemaLocation\s*=\s*(\"|').*$ns\s+)([^\s\"']+)}",
                 "\$1$olacxsd", $body2);
  }
  ## schemaLoc att exists but olac xsd location is not specified
  else if (preg_match("/xsi:schemaLocation/", $body2)) {
    $body2 =
    preg_replace("{(xsi:schemaLocation\s*=\s*(\"|'))}",
                 "\$1 $ns $olacxsd ", $body2);
  }
  ## schemaLoc att doesn't exist
  else {
    $body2 = "xsi:schemaLocation=\"$ns $olacxsd\" $body2";
  }

  ## xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  if (!preg_match("{http://www.w3.org/2001/XMLSchema-instance}", $body2))
    $body2 .= ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"';

  $metadata = "$body1 $body2$body3";
  ##
  ##############################

  fputs($fd, $metadata);
  fclose($fd);
  chmod($tmpfile, 0644);
# readfile($tmpfile);     # For debug purposes


# Validate the tempfile

  $command = "/mnt/unagi/speechd8/ldc/wwwhome/olac/bin/xercesj $tmpfile";
  exec($command, $result);

#    $command = "/mnt/unagi/speechd8/ldc/wwwhome/olac/bin/xsv_html $tmpfile";
#    exec($command, $result, $errcode);
#    errcode: 0 = success; 1 = fail
#    also, xsv_xml, which is faster


  if (!$result) { # The record is valid

# Set up the XSLT processor

  $xsl     = "http://www.language-archives.org/tools/metadata/metadata.xsl";
  #$java    = "/pkg/j/j2sdk1.4.0/bin/java";
  #$xalan   = "/mnt/unagi/ldc/wwwhome/jakarta-tomcat-3.2.3-sb/lib/xalan.jar";
  #$xerces  = "/pkg/x/xerces-2_0_1/xercesImpl.jar";
  #$xslt    = "$java -classpath $xalan:$xerces org.apache.xalan.xslt.Process -xsl $xsl";

# Transform output

  #$command = "$xslt -IN $tmpfile";
  $command = "/mnt/unagi/speechd8/ldc/wwwhome/olac/bin/xalan $tmpfile $xsl";
  exec($command, $result);
  
# Return the HTML page

  header("Content-Type: text/html"); 
  print join("\n", $result);

?>
<?
  } else {

# Return the HTML page reporting validation errors

  header("Content-Type: text/html"); 
?>
<HTML>
<HEAD>
<TITLE>Validate Free-standing Metadata</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1252"> 
<LINK HREF="olac.css" TYPE="text/css" REL="stylesheet"> 

</HEAD>
<BODY>
<HR>
<TABLE CELLPADDING="10">
<TBODY>
<TR>
<TD><A HREF="http://www.language-archives.org/"><IMG
SRC="http://www.language-archives.org/images/olac100.gif" BORDER="0"
ALT="OLAC Logo"> </A> </TD>
<TD> <H1>Free-standing OLAC Metadata:<BR>Validation Service</H1>
</TD>
</TR>
</TBODY>
</TABLE>
<HR>
<P>The following validation errors were detected in the document you uploaded:</P>
<BLOCKQUOTE><PRE>
<?  print join("\n", $result);  ?>
</PRE></BLOCKQUOTE>
<P>The document is not a valid OLAC metadata record. Go back to the previous page and correct this before proceeding to the step of display formatting.</P>

<?
# The following didn't do anything:
# <P> Here are the results from another parser ...</P>
# <BLOCKQUOTE>
# <?
#     $command = "/mnt/unagi/speechd8/ldc/wwwhome/olac/bin/xsv_html $tmpfile";
#     exec($command, $result2, $errcode);
#     print join("\n", $result2);
# ?>
# </BLOCKQUOTE>
?>

</BODY>
</HTML>

<?
  }
?>

