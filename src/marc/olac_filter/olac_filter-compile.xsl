<?xml version="1.0" encoding="UTF-8"?>
<!-- dc_gateway-compile1.xsl
        Compile the stage 1 ("select") filter for an OAI_DC gateway
        G. Simons, 13 Feb 2009
        Last updated: 16 Feb 2009
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:alias="AliasForXSLT"
   xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository" 
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
   xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
   version="1.0">
  <xsl:output method="xml"/>
   <xsl:namespace-alias stylesheet-prefix="alias" result-prefix="xsl"/>
   <xsl:variable name="sq">'</xsl:variable>
   <xsl:template match="/olac-filter">
         <alias:stylesheet version="1.0">
            <alias:output method="xml"/>
            <alias:template match="/sr:Repository">
               <alias:copy>
                  <alias:copy-of
                     select="sr:Identify | sr:ListMetadataFormats"/>
                  <alias:apply-templates select="sr:ListRecords"/>
               </alias:copy>
            </alias:template>
            <alias:template match="sr:ListRecords">
               <alias:copy>
                  <alias:apply-templates select="oai:record"/>
               </alias:copy>
            </alias:template>
            <xsl:comment>Exclude any record that matches a
               reject rule.</xsl:comment>
            <xsl:apply-templates select="reject-rules/*"/>
            <xsl:comment>Copy any record that matches a
               retain rule.</xsl:comment>
            <xsl:apply-templates select="retain-rules/*"/>
            <xsl:comment>Exclude any remaining record that does not 
               match the retention criteria.</xsl:comment>
            <alias:template match="*" priority="-1">
            </alias:template>
         </alias:stylesheet>
   </xsl:template>
   
   <!-- Compile the tests -->
   <xsl:template match="reject-rules/test">
      <xsl:variable name="criteria">
         <xsl:apply-templates select="*"/>
      </xsl:variable>
      <alias:template 
         match="oai:record[oai:metadata/olac:olac{$criteria}]" priority="2">
      </alias:template>
   </xsl:template>
   
   <xsl:template match="retain-rules/test">
      <xsl:variable name="criteria">
         <xsl:apply-templates select="*"/>
      </xsl:variable>
      <alias:template
         match="oai:record[oai:metadata/olac:olac{$criteria}]" priority="1">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
   
   <xsl:template match="retain-all" priority="1">
      <xsl:comment>Just copy every record to the output.</xsl:comment>
      <alias:template match="*">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
   
   <!-- Compile the criteria -->
   <xsl:template match="dc-element">
      <xsl:text>[</xsl:text>
      <!-- The xpath test is the concatenation of the following predicates
         which are thus ANDed together -->
      <xsl:apply-templates select="self::node()"
         mode="compile-tag"/>
      <xsl:apply-templates select="self::node()"
         mode="compile-test"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <!-- Compile the @tag into an xpath [predicate] -->
   <xsl:template match="dc-element" mode="compile-tag">
      <xsl:choose>
         <xsl:when test="not(@tag)">dc:*</xsl:when>
         <xsl:when test="@tag = '' ">dc:*</xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('dc:', @tag  )"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- Compile the @test into an xpath [predicate] -->
   <xsl:template match="dc-element" mode="compile-test">
      <xsl:choose>
         <!-- What exists and negate='yes' ? -->
         <xsl:when test="@test = 'exists'">[ . != '' ]</xsl:when>
         <xsl:otherwise>
            <xsl:text>[</xsl:text>
            <xsl:if test="@negate='yes'">not(</xsl:if>
            <xsl:for-each select="text">
               <xsl:if test="position() != 1"> or </xsl:if>
               <xsl:choose>
                  <xsl:when test="../@test = 'equals'">
                     <xsl:value-of
                        select="concat(' . = ', $sq, ., $sq  )"
                     />
                  </xsl:when>
                  <xsl:when test="../@test = 'contains'">
                     <xsl:value-of
                        select="concat('contains( . , ', $sq, .,
                        $sq, ')'  )"
                     />
                  </xsl:when>
                  <xsl:when test="../@test = 'starts-with'">
                     <xsl:value-of
                        select="concat('starts-with( . , ', $sq, .,
                        $sq, ')'  )"
                     />
                  </xsl:when>
               </xsl:choose>
            </xsl:for-each>
            <xsl:if test="@negate='yes'">)</xsl:if>
            <xsl:text>]</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   
</xsl:stylesheet>
