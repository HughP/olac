rem Syntax: test filter-spec input
\msxsl %1.xml olac_filter-compiler.xsl -o %1.xsl
\msxsl %2 %1.xsl -o %1-out.xml

