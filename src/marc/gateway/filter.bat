rem Syntax: filter gateway-spec input
rem    where "gateway-spec" is without the .xml extention,
rem    but "input" does include the extension
rem
rem The outputs are:
rem    stage1-yes.xml  Records accepted by stage 1 filter
rem    stage1-no.xml   Records rejeted by stage 1 filter
rem    stage2-yes.xml  Records accepted by stage 2 filter
rem    stage2-no.xml   Records rejeted by stage 2 filter

msxsl %1.xml gateway-compile1.xsl -o %1-stage1-yes.xsl
msxsl %1.xml gateway-compile1-inv.xsl -o %1-stage1-no.xsl
msxsl %1.xml gateway-compile2.xsl -o %1-stage2-yes.xsl
msxsl %1.xml gateway-compile2-inv.xsl -o %1-stage2-no.xsl
msxsl %2 %1-stage1-yes.xsl -o stage1-yes.xml
msxsl %2 %1-stage1-no.xsl -o stage1-no.xml
msxsl stage1-yes.xml %1-stage2-yes.xsl -o stage2-yes.xml
msxsl stage1-yes.xml %1-stage2-no.xsl  -o stage2-no.xml

