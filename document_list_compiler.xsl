<?xml version="1.0"?>
<!-- edited with XML Spy v4.3 (http://www.xmlspy.com) by Gary Simons (SIL International) -->
<!--document_list_compiler.xsl
     Stylesheet for compiling the list of current document headers from the document list

     G. Simons, 2 Aug 2003
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output method="xml" version="1.0" encoding="ISO-8859-1"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="/documents">
      <xsl:element name="document-headers">
         <xsl:element name="build-date">
            <xsl:value-of select="document('document_build_date.xml')/date"/>
         </xsl:element>
         <xsl:for-each select="//document">
            <xsl:sort select="@href"/>
            <xsl:element name="header">
               <xsl:copy-of select="@href"/>
               <xsl:apply-templates select="document(@href)"/>
            </xsl:element>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template match="OLAC_doc">
      <xsl:copy-of select="header/status"/>
      <xsl:copy-of select="header/issued"/>
      <xsl:copy-of select="header/title"/>
   </xsl:template>
</xsl:stylesheet>
