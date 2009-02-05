<?xml version="1.0" encoding="UTF-8"?>
<!-- gateway-compile2.xsl
   Compile the stage 2 ("reject") filter for a gateway
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
            <alias:template match="marc:collection">
               <alias:copy>
                  <alias:apply-templates/>
               </alias:copy>
            </alias:template>
            <xsl:apply-templates select="reject-stage/*"
            mode="reject"/>
            <xsl:comment>If none of the reject criteria are met,
               then copy the record.</xsl:comment>
            <alias:template match="*" priority="-1">
                 <alias:copy-of select="self::node()"/>
            </alias:template>
         </alias:stylesheet>
   </xsl:template>
   <xsl:template match="data-field" mode="reject">
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
      </alias:template>
   </xsl:template>
   <xsl:template match="control-field" mode="reject">
      <xsl:variable name="criterion">
         <xsl:apply-templates select="self::node()"
            mode="compile-tag"/>
         <xsl:apply-templates select="self::node()"
            mode="compile-test"/>
      </xsl:variable>
      <alias:template match="marc:record[marc:controlfield{$criterion}]" priority="1">
      </alias:template>
   </xsl:template>
   <xsl:template match="leader" mode="reject">
      <xsl:variable name="criterion">
         <xsl:apply-templates select="self::node()"
            mode="compile-test"/>
      </xsl:variable>
      <alias:template match="marc:record[marc:leader{$criterion}]" priority="1">
      </alias:template>
   </xsl:template>
</xsl:stylesheet>
