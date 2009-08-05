<?xml version="1.0" encoding="UTF-8"?>
<!-- olac_filter-compile.xsl
        Compile the filter over an OLAC repository
        G. Simons, 2 July 2009
        Last updated: 2 July 2009
        
     There are two parameters:
        version   Defaults to "1.0". Call with value of "2.0" to
                  create XSLT2 stylesheet
        mode      Defaults to "retain", e.g. create stylesheet that
                  retains desired records. Call with value of "reject" to create
                  stylesheet that write the rejected records.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:alias="AliasForXSLT"
   xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository"
   xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:oai="http://www.openarchives.org/OAI/2.0/"
   xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:namespace-alias stylesheet-prefix="alias" result-prefix="xsl"/>
   <xsl:param name="mode">retain</xsl:param>
   <xsl:param name="version">1.0</xsl:param>
   <xsl:variable name="sq">'</xsl:variable>
   <xsl:template match="/olac-filter">
      <alias:stylesheet version="{$version}">
         <alias:param name="debug">no</alias:param>
         <alias:output method="xml" encoding="UTF-8"/>
         <alias:template match="/sr:Repository">
            <alias:copy>
               <alias:copy-of select="@*" />
               <alias:copy-of select="sr:Identify | sr:ListMetadataFormats"/>
               <alias:apply-templates select="sr:ListRecords"/>
            </alias:copy>
         </alias:template>
         <alias:template match="sr:ListRecords">
            <alias:copy>
               <alias:copy-of select="@*" />
               <alias:apply-templates select="oai:record"/>
            </alias:copy>
         </alias:template>

         <xsl:comment> The reject rules </xsl:comment>
         <xsl:apply-templates select="reject-rules/*"/>

         <xsl:comment> The retain rules </xsl:comment>
         <xsl:apply-templates select="retain-rules/*"/>

         <xsl:comment> Handle records that match no rule </xsl:comment>
         <alias:template match="*" priority="-1">
            <xsl:if test="$mode = 'reject'">
               <alias:copy>
                  <alias:if test="$debug = 'yes'">
                     <alias:attribute name="rule">
                        <alias:text>Not retained</alias:text>
                     </alias:attribute>
                  </alias:if>
                  <alias:copy-of select="@* | *"/>
               </alias:copy>
            </xsl:if>
         </alias:template>
      </alias:stylesheet>
   </xsl:template>

   <!-- Compile the tests -->
   <xsl:template match="reject-rules/test">
      <xsl:variable name="criteria">
         <xsl:apply-templates select="*"/>
      </xsl:variable>
      <alias:template match="oai:record[oai:metadata/olac:olac{normalize-space($criteria)}]"
         priority="2">
         <xsl:if test="$mode = 'reject'">
            <alias:copy>
               <alias:if test="$debug = 'yes'">
                  <alias:attribute name="rule">
                     <xsl:value-of select="@name"/>
                  </alias:attribute>
               </alias:if>
               <alias:copy-of select="@* | *"/>
            </alias:copy>
         </xsl:if>
      </alias:template>
   </xsl:template>

   <xsl:template match="retain-rules/test">
      <xsl:variable name="criteria">
         <xsl:apply-templates select="*"/>
      </xsl:variable>
      <alias:template match="oai:record[oai:metadata/olac:olac{normalize-space($criteria)}]"
         priority="1">
         <xsl:if test="$mode = 'retain'">
            <alias:copy>
               <alias:if test="$debug = 'yes'">
                  <alias:attribute name="rule">
                     <xsl:value-of select="@name"/>
                  </alias:attribute>
               </alias:if>
               <alias:copy-of select="@* | *"/>
            </alias:copy>
         </xsl:if>
      </alias:template>
   </xsl:template>

   <xsl:template match="retain-all">
      <xsl:if test="$mode = 'retain'">
         <xsl:comment> Just retain everything else </xsl:comment>
         <alias:template match="*" priority="1">
            <alias:copy-of select="self::node()"/>
         </alias:template>
      </xsl:if>
   </xsl:template>

   <!-- Compile the criteria -->
   <xsl:template match="dc-element">
      <xsl:choose>
         <xsl:when test="@negate='yes'"> [not(<xsl:value-of select="@tag"/><xsl:apply-templates
               select="*"/>)] </xsl:when>
         <xsl:otherwise> [<xsl:value-of select="@tag"/><xsl:apply-templates select="*"/>]
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- The xpath for the test on the tag is the concatenation of
      any of the following subtests which are present
      which are ANDed together -->
   <!-- Compile the test on @xsi:type, @olac:code, or . into an xpath [predicate] -->
   <xsl:template match="type | code | content">
      <xsl:variable name="target">
         <xsl:if test="self::type">@xsi:type</xsl:if>
         <xsl:if test="self::code">@olac:code</xsl:if>
         <xsl:if test="self::content">.</xsl:if>
      </xsl:variable> [<xsl:if test="@negate='yes'">not(</xsl:if>
      <xsl:choose>
         <xsl:when test="@test = 'exists'">
            <xsl:value-of select="concat($target, ' != ', $sq, $sq )"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:for-each select="text">
               <xsl:if test="position() != 1"> or </xsl:if>
               <xsl:choose>
                  <xsl:when test="../@test = 'equals'">
                     <xsl:value-of select="concat($target, ' = ', $sq, ., $sq  )"/>
                  </xsl:when>
                  <xsl:when test="../@test = 'contains'">
                     <xsl:value-of
                        select="concat('contains(', $target, ', ', $sq, .,
                        $sq, ')'  )"
                     />
                  </xsl:when>
                  <xsl:when test="../@test = 'starts-with'">
                     <xsl:value-of
                        select="concat('starts-with(', $target, ', ', $sq, .,
                        $sq, ')'  )"
                     />
                  </xsl:when>
               </xsl:choose>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@negate='yes'">)</xsl:if>] </xsl:template>


</xsl:stylesheet>
