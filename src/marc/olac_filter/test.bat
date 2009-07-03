rem
rem Syntax: test filter input  (where filter and input names are minus .xml)
rem
\msxsl %1.xml olac_filter-compiler.xsl -o %1-retain.xsl
\msxsl %1.xml olac_filter-compiler.xsl -o %1-reject.xsl mode=reject
\msxsl %2.xml %1-retain.xsl -o %2-retained.xml
\msxsl %2.xml %1-reject.xsl -o %2-rejected.xml

