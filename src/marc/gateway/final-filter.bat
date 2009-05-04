rem Syntax: final-filters gateway-spec 
rem    where "gateway-spec" is without the .xml extension,
rem    
rem    Creates the two XSLT2 scripts for the filter in the final tool
rem
rem The outputs are:
rem    %1-stage1.xsl   The stage 1 filter
rem    %1-stage2.xsl   The stage 2 filter

msxsl %1.xml gateway-compile1.xsl -o %1-stage1.xsl version='2.0'
msxsl %1.xml gateway-compile2.xsl -o %1-stage2.xsl version='2.0'
