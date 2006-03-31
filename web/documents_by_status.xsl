<?xml version="1.0"?>
<!-- edited with XML Spy v4.3 (http://www.xmlspy.com) by Gary Simons (SIL International) -->
<!--documents_by_status.xsl
     Stylesheet for generating list of OLAC documents by status

     G. Simons, 2 Aug 2003
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output method="html" version="4.0" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd" encoding="ISO-8859-1"/>
   <xsl:include href="OLAC_doc_functions.xsl"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="/documents">
      <HTML>
         <HEAD>
            <TITLE>OLAC Documents by Status</TITLE>
            <meta name="Title">
               <xsl:attribute name="content">OLAC Documents by Status</xsl:attribute>
            </meta>
            <meta name="Description">
               <xsl:attribute name="content">Lists all of the OLAC documents by status (Draft, Proposed, Candidate, Adopted, Retired, Withdrawn)</xsl:attribute>
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
                        <font color="0x00004a">OLAC Documents by Status</font>
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
                  <td>See also:</td>
                  <td>
                     <a href="document_index.html">OLAC documents by type</a> and <a href="documents_by_date.html">OLAC documents by date</a>
                  </td>
               </tr>
               <xsl:for-each select="byStatus/section">
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
                        <small>See the <a href="http://www.language-archives.org/OLAC/process.html">OLAC Process</a> document for a fuller explanation of these status levels and the document review process.</small>
                        <br/>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                     </p>
                  </td>
               </tr>
            </table>
            <hr/>
            <xsl:apply-templates select="byStatus/section"/>
         </BODY>
      </HTML>
   </xsl:template>
   <xsl:template match="section">
      <xsl:variable name="code">
         <xsl:value-of select="translate(heading, 'ACDP', 'acdp')"/>
      </xsl:variable>
      <h2 align="center">
         <a name="{heading}"/>
         <xsl:value-of select="heading"/>
      </h2>
      <xsl:choose>
         <xsl:when test="$code='Retired'">
            <xsl:if test="not(//header[status[@endDate !='' and @code = 'adopted']])">
               <blockquote>No documents have this status.</blockquote>
            </xsl:if>
            <xsl:for-each select="//header[status[@endDate !='' and @code = 'adopted']]">
               <xsl:sort select="title"/>
               <xsl:apply-templates select="document(@href)"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:when test="$code='Withdrawn'">
            <xsl:if test="not(//header[status[@endDate !='' and @code != 'adopted']])">
               <blockquote>No documents have this status.</blockquote>
            </xsl:if>
            <xsl:for-each select="//header[status[@endDate !='' and @code != 'adopted']]">
               <xsl:sort select="title"/>
               <xsl:apply-templates select="document(@href)"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="not(//header[status[@code=$code]])">
               <blockquote>No documents have this status.</blockquote>
            </xsl:if>
            <xsl:for-each select="//header[status[@code=$code and not(@endDate)]]">
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
