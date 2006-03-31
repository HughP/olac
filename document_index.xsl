<?xml version="1.0"?>
<!-- edited with XML Spy v4.3 (http://www.xmlspy.com) by Gary Simons (SIL International) -->
<!--document_index.xsl
     Stylesheet for generating the main OLAC document index (by type)

     G. Simons, 10 Sept 2002
     Last revised: 2 Aug 2003
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output method="html" version="4.0" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd" encoding="ISO-8859-1"/>
   <xsl:include href="OLAC_doc_functions.xsl"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="/documents">
      <HTML>
         <HEAD>
            <TITLE>OLAC Document Index</TITLE>
            <meta name="Title">
               <xsl:attribute name="content">OLAC Document Index</xsl:attribute>
            </meta>
            <meta name="Keywords">
               <xsl:attribute name="content">OLAC, Open Language Archives Community, language resources, archiving standards, best practice recommendations</xsl:attribute>
            </meta>
            <meta name="Description">
               <xsl:attribute name="content">Lists all of the OLAC documents by category (Standard, Recommendation, or Note) and status (Draft, Proposed, Candidate, Adopted, Superseded)</xsl:attribute>
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
                        <font color="0x00004a">OLAC Documents</font>
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
                  <td colspan="2">
                     <p>This index lists only the documents that are current within the OLAC document process. The other indexes, <a href="documents_by_status.html">OLAC documents by status</a> and <a href="documents_by_date.html">OLAC documents by date</a>, also includes documents that have been retired or withdrawn.</p>
                  </td>
               </tr>
               <xsl:for-each select="byType/section">
                  <tr valign="top">
                     <td>
                        <h4>
                           <a href="#{heading}">
                              <xsl:value-of select="heading"/>
                           </a>
                        </h4>
                     </td>
                     <td>
                        <xsl:value-of select="intro"/>
                     </td>
                  </tr>
               </xsl:for-each>
               <tr>
                  <td colspan="2">
                     <p>
                        <small>N.B. See the <a href="http://www.language-archives.org/OLAC/process.html">OLAC Process</a> document for an explanation of the document types and status levels.</small>
                     </p>
                  </td>
               </tr>
            </table>
            <hr/>
            <xsl:apply-templates select="byType/section"/>
         </BODY>
      </HTML>
   </xsl:template>
   <xsl:template match="section">
      <h2 align="center">
         <a name="{heading}"/>
         <xsl:value-of select="heading"/>
      </h2>
      <xsl:choose>
         <xsl:when test="heading='Standards'">
            <xsl:for-each select="//header[status[not(@endDate) and @type = 'standard']]">
               <xsl:sort select="title"/>
               <xsl:apply-templates select="document(@href)"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:when test="heading='Recommendations'">
            <xsl:for-each select="//header[status[not(@endDate) and @type = 'recommendation']]">
               <xsl:sort select="title"/>
               <xsl:apply-templates select="document(@href)"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:for-each select="//header[status[not(@endDate) and not(@type = 'standard') and not(@type = 'recommendation') ]]">
               <xsl:sort select="title"/>
               <xsl:apply-templates select="document(@href)"/>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="OLAC_doc">
      <xsl:for-each select="header">
         <p>
            <a>
               <xsl:attribute name="href"><xsl:text>http://www.language-archives.org/</xsl:text><xsl:choose><xsl:when test="status[@type='standard']"><xsl:text>OLAC/</xsl:text></xsl:when><xsl:when test="status[@type='recommendation']"><xsl:text>REC/</xsl:text></xsl:when><xsl:otherwise><xsl:text>NOTE/</xsl:text></xsl:otherwise></xsl:choose><xsl:value-of select="baseName"/><xsl:text>.html</xsl:text></xsl:attribute>
               <xsl:value-of select="title"/>
            </a>
            <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;[</xsl:text>
            <xsl:call-template name="format-date"/>
            <xsl:text>]</xsl:text>
         </p>
         <blockquote>
            <xsl:for-each select="status">
               <xsl:call-template name="format-status-and-type"/>
            </xsl:for-each>
            <xsl:value-of select="abstract"/>
         </blockquote>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>
