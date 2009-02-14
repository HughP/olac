rem Syntax: test gateway-spec input
\msxsl %1.xml gateway-compile1.xsl -o %1-stage1.xsl
\msxsl %1.xml gateway-compile2.xsl -o %1-stage2.xsl
\msxsl %2 %1-stage1.xsl -o temp.xml
\msxsl temp.xml %1-stage2.xsl -o %1-out.xml

