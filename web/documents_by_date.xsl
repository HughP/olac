<?xml version="1.0"?>
<!-- edited with XML Spy v4.3 (http://www.xmlspy.com) by Gary Simons (SIL International) -->
<!--documents_by_date.xsl
     Stylesheet for generating list of OLAC documents by date

     G. Simons, 2 Aug 2003
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output method="html" version="4.0" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd" encoding="ISO-8859-1"/>
   <xsl:include href="OLAC_doc_functions.xsl"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="/documents">
      <HTML>
         <HEAD>
            <TITLE>OLAC Documents by Date</TITLE>
            <meta name="Title">
               <xsl:attribute name="content">OLAC Documents by Date</xsl:attribute>
            </meta>
            <meta name="Description">
               <xsl:attribute name="content">Lists all of the OLAC documents by latest date of revision</xsl:attribute>
            </meta>
            <meta name="Publisher" content="OLAC (Open Language Archives Community)"/>
            <STYLE>
          BODY       { MARGIN:10px; BACKGROUND: white }

        </STYLE>
         </HEAD>
         <BODY>
            <hr/>
            <table cellpadding="10">
               <tr>
                  <td>
                     <a href="http://www.language-archives.org/">
                        <img border="0" src="http://www.language-archives.org/images/olac100.gif"/>
                     </a>
                  </td>
                  <td valign="middle">
                     <h1>
                        <font color="0x00004a">OLAC Documents by Date</font>
                     </h1>
                     <p>
								Last updated: <xsl:value-of select="//build-date"/>
                     </p>
                  </td>
               </tr>
            </table>
            <hr/>
            <table width="90%" cellpadding="5" align="center">
               <tr>
                  <td>
                     <p>The documents are listed by latest date of revision, beginning with the most recent.</p>
                     <p>See also <a href="document_index.html">OLAC documents by type</a> and <a href="documents_by_status.html">OLAC documents by status</a>.</p>
                  </td>
               </tr>
            </table>
            <hr/>
            <br/>
            <table>
               <xsl:for-each select="//header">
                  <xsl:sort select="issued" order="descending"/>
                  <xsl:sort select="title"/>
                  <xsl:apply-templates select="document(@href)"/>
               </xsl:for-each>
            </table>
         </BODY>
      </HTML>
   </xsl:template>
   <xsl:template match="OLAC_doc">
      <xsl:for-each select="header">
         <tr valign="top">
            <td nowrap="nowrap">
               <xsl:call-template name="format-date"/>
               <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
            </td>
            <td>
               <p>
                  <a>
                     <xsl:attribute name="href"><xsl:text>http://www.language-archives.org/</xsl:text><xsl:choose><xsl:when test="status[@type='standard']"><xsl:text>OLAC/</xsl:text></xsl:when><xsl:when test="status[@type='recommendation']"><xsl:text>REC/</xsl:text></xsl:when><xsl:otherwise><xsl:text>NOTE/</xsl:text></xsl:otherwise></xsl:choose><xsl:value-of select="baseName"/><xsl:text>.html</xsl:text></xsl:attribute>
                     <xsl:value-of select="title"/>
                  </a>
               </p>
               <blockquote>
                  <xsl:for-each select="status">
                     <xsl:call-template name="format-status-and-type"/>
                  </xsl:for-each>
                  <xsl:value-of select="abstract"/>
               </blockquote>
            </td>
         </tr>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>
