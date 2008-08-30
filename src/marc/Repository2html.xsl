<?xml version="1.0" encoding="UTF-8"?>
<!-- 
     Repository2html.xsl
     Create an HTML view of an OLAC static repository
-->
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository" 
   xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
   xmlns:olac="http://www.language-archives.org/OLAC/1.1/" 
   xmlns:dc="http://purl.org/dc/elements/1.1/" 
   xmlns:dcterms="http://purl.org/dc/terms/" 
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
    <xsl:output method="html"/>
   
   <xsl:template match="/">
      <xsl:variable name="title" select="concat( 'Repository: ',
         //oai:repositoryName)"></xsl:variable>
      <html>
         <head>
            <title><xsl:value-of select="$title"/></title>
         </head>
         <body>
            <h1><xsl:value-of select="$title"/></h1>
            <xsl:apply-templates select="//sr:ListRecords/oai:record"/>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template match="oai:record">
      <h2><xsl:value-of select="oai:header/oai:identifier"/></h2>
      <xsl:apply-templates select="oai:metadata/olac:olac"
         mode="record"/>
   </xsl:template>
   
   <xsl:template match="olac:olac" mode="record">
      <table cellpadding="1" cellspacing="6">
         <xsl:apply-templates/>
      </table>
   </xsl:template>
   <xsl:template match="*">
      <xsl:variable name="tag">
         <xsl:choose>
            <xsl:when test="contains(name(),':')">
               <xsl:value-of select="substring-after(name(), ':')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="name()"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="label">
         <xsl:call-template name="capitalize">
            <xsl:with-param name="label" select="$tag"/>
         </xsl:call-template>
         <xsl:if test="@xsi:type">
            <xsl:call-template name="add-scheme">
               <xsl:with-param name="prefix" select="substring-before(@xsi:type, ':')"/>
               <xsl:with-param name="scheme" select="substring-after(@xsi:type, ':')"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="code">
         <xsl:value-of
            select="translate(@olac:code,
            '_', ' ')"/>
      </xsl:variable>
      <tr valign="top">
         <td bgcolor="silver">
            <b>
               <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
               <xsl:value-of select="$label"/>
               <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </b>
         </td>         <td bgcolor="silver">
            <xsl:value-of select="@from"/>
         </td>
         
         <td bgcolor="#f0f0f0">
            <xsl:choose>
               <xsl:when test="@xsi:type='olac:discourse-type'">
                  <xsl:call-template name="olac-display-format">
                     <xsl:with-param name="label">Discourse type</xsl:with-param>
                     <xsl:with-param name="primaryCode">
                        <xsl:call-template name="capitalize">
                           <xsl:with-param name="label">
                              <xsl:value-of select="$code"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="@xsi:type='olac:language'">
                  <xsl:call-template name="olac-display-format">
                     <xsl:with-param name="primaryCode">
                        <xsl:value-of select="$code" />
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="@xsi:type='olac:linguistic-field'">
                  <xsl:call-template name="olac-display-format">
                     <xsl:with-param name="primaryCode">
                        <xsl:call-template name="capitalize">
                           <xsl:with-param name="label">
                              <xsl:value-of select="$code"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="@xsi:type='olac:linguistic-type'">
                  <xsl:call-template name="olac-display-format">
                     <xsl:with-param name="label">Linguistic type</xsl:with-param>
                     <xsl:with-param name="primaryCode">
                        <xsl:call-template name="capitalize">
                           <xsl:with-param name="label">
                              <xsl:value-of select="$code"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <!-- The $code value is now parenthesized in the label
                  <xsl:when test="@xsi:type='olac:role'">
                  <xsl:call-template name="olac-display-format">
                  <xsl:with-param name="secondaryCode">
                  <xsl:value-of select="$code"/>
                  </xsl:with-param>
                  </xsl:call-template>
                  </xsl:when>  -->
               <xsl:otherwise>
                  <xsl:call-template name="element-content"/>
               </xsl:otherwise>
            </xsl:choose>
         </td>
      </tr>
   </xsl:template>
   <xsl:template name="capitalize">
      <!-- and insert non-breaking spaces between words -->
      <xsl:param name="label"/>
      <xsl:choose>
         <xsl:when test="$label='accessRights'">Access&#160;Rights</xsl:when>
         <xsl:when test="$label='bibliographicCitation'">Bibliographic&#160;Citation</xsl:when>
         <xsl:when test="$label='conformsTo'">Conforms&#160;To</xsl:when>
         <xsl:when test="starts-with($label, 'date')">
            <xsl:value-of select="concat('Date&#160;', substring-after($label, 'date'))"/>
         </xsl:when>
         <xsl:when test="starts-with($label, 'has')">
            <xsl:value-of
               select="concat('Has&#160;',
               substring-after($label, 'has'))"/>
         </xsl:when>
         <xsl:when test="starts-with($label, 'is')">
            <xsl:value-of
               select="concat('Is&#160;',
               substring($label, 3, string-length($label)-4), '&#160;', substring($label,
               string-length($label)-1, 2))"
            />
         </xsl:when>
         <xsl:when test="$label='rightsHolder'">Rights&#160;Holder</xsl:when>
         <xsl:when test="$label='tableOfContents'">Table&#160;Of&#160;Contents</xsl:when>
         <xsl:otherwise>
            <xsl:value-of
               select="concat( translate(substring($label,1,1),  'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring($label, 2, string-length($label)-1))"
            />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="add-scheme">
      <xsl:param name="prefix"/>
      <xsl:param name="scheme"/>
      <xsl:choose>
         <xsl:when test="$scheme='language'">&#160;(ISO639-3)</xsl:when>
         <xsl:when test="$scheme='DCMIType'">&#160;(DCMI)</xsl:when>
         <xsl:when test="$scheme='role'">
            <xsl:value-of
               select="concat( '&#160;(', @olac:code, ')' )"/>
         </xsl:when>
         <xsl:when test="$prefix='olac'">&#160;(OLAC)</xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat( '&#160;(', $scheme, ')' )"/>
         </xsl:otherwise>
      </xsl:choose>
      
      
   </xsl:template>
   <xsl:template name="olac-display-format">
      <xsl:param name="label"/>
      <xsl:param name="primaryCode"/>
      <xsl:param name="secondaryCode"/>
      <xsl:if test="$label">
         <xsl:value-of select="$label"/>
         <xsl:text>: </xsl:text>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="$primaryCode">
            <xsl:value-of select="$primaryCode"/>
            <xsl:if test=". != ''">
               <xsl:text>, </xsl:text>
               <xsl:call-template name="element-content"/>
            </xsl:if>
         </xsl:when>
         <xsl:when test="$secondaryCode">
            <xsl:call-template name="element-content"/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="$secondaryCode"/>
            <xsl:text>)</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="element-content"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="element-content">
      <xsl:choose>
         <xsl:when test="starts-with(.,'http://')">
            <a href="{.}">
               <xsl:value-of select="."/>
            </a>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
