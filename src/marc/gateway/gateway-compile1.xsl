<?xml version="1.0" encoding="UTF-8"?>
<!-- gateway-compile1.xsl
        Compile the stage 1 ("select") filter for a gateway
        G. Simons, 4 Feb 2009
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:alias="AliasForXSLT"
   xmlns:marc="http://www.loc.gov/MARC21/slim"
   version="1.0">
  <xsl:output method="xml"/>
   <xsl:include href="gateway-shared.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="alias" result-prefix="xsl"/>
   <xsl:template match="/gateway">
         <alias:stylesheet version="1.0">
            <alias:output method="xml"/>
            <alias:strip-space elements="marc:collection"/>
            <alias:template match="marc:collection">
               <alias:copy>
                  <alias:apply-templates/>
               </alias:copy>
            </alias:template>
            <xsl:comment>Copy any record that matches a
               criterion.</xsl:comment>
            <xsl:apply-templates select="select-stage/*"
            mode="select"/>
            <xsl:comment>Exclude any record that does not match a
               criterion.</xsl:comment>
            <alias:template match="*" priority="-1">
            </alias:template>
         </alias:stylesheet>
   </xsl:template>
   <xsl:template match="select-all" mode="select" priority="1">
      <xsl:comment>Just copy every record to the output.</xsl:comment>
        <alias:template match="*">
         <alias:copy-of select="self::node()"/>
        </alias:template>
   </xsl:template>
   <xsl:template match="data-field" mode="select">
      <!-- The xpath test is the concatenation of the following predicates
             which are thus ANDed together -->
      <xsl:variable name="criterion">
         <xsl:apply-templates select="self::node()"
            mode="compile-tag"/>
         <xsl:apply-templates select="self::node()"
            mode="compile-code"/>
         <xsl:apply-templates select="self::node()"
            mode="compile-test"/>
      </xsl:variable>
      <alias:template match="marc:record[marc:datafield{$criterion}]" priority="1">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
   <xsl:template match="control-field" mode="select">
      <xsl:variable name="criterion">
         <xsl:apply-templates select="self::node()"
            mode="compile-tag"/>
         <xsl:apply-templates select="self::node()"
            mode="compile-test"/>
      </xsl:variable>
      <alias:template match="marc:record[marc:controlfield{$criterion}]" priority="1">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
   <xsl:template match="leader" mode="select">
      <xsl:variable name="criterion">
         <xsl:apply-templates select="self::node()"
            mode="compile-test"/>
      </xsl:variable>
      <alias:template match="marc:record[marc:leader{$criterion}]" priority="1">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
</xsl:stylesheet>
