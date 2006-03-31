<?xml version="1.0"?>
<!-- edited with XML Spy v4.3 (http://www.xmlspy.com) by Gary Simons (SIL International) -->
<!--document_list_summary.xsl
     Stylesheet for generating the summary document list for the Documents page

     G. Simons, 10 Sept 2002
     Last revised: 2 Aug 2003
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output method="html" version="4.0" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd" encoding="ISO-8859-1"/>
   <xsl:include href="OLAC_doc_functions.xsl"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="/documents">
      <div>
         <BODY>
            <h2>Recommendations</h2>
            <ul>
               <xsl:for-each select="//header[status[not(@endDate) and @type = 'recommendation']]">
                  <xsl:sort select="title"/>
                  <xsl:apply-templates select="document(@href)"/>
               </xsl:for-each>
            </ul>
            <h2>Notes</h2>
            <ul>
               <xsl:for-each select="//header[status[not(@endDate) and not(@type = 'standard') and not(@type = 'recommendation') ]]">
                  <xsl:sort select="title"/>
                  <xsl:apply-templates select="document(@href)"/>
               </xsl:for-each>
            </ul>
         </BODY>
      </div>
   </xsl:template>
   <xsl:template match="OLAC_doc">
      <xsl:for-each select="header">
         <li>
            <a>
               <xsl:attribute name="href"><xsl:text>http://www.language-archives.org/</xsl:text><xsl:choose><xsl:when test="status[@type='standard']"><xsl:text>OLAC/</xsl:text></xsl:when><xsl:when test="status[@type='recommendation']"><xsl:text>REC/</xsl:text></xsl:when><xsl:otherwise><xsl:text>NOTE/</xsl:text></xsl:otherwise></xsl:choose><xsl:value-of select="baseName"/><xsl:text>.html</xsl:text></xsl:attribute>
               <xsl:value-of select="title"/>
            </a>
         </li>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>
