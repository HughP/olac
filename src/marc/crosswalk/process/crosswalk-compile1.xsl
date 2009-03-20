<?xml version="1.0" encoding="UTF-8"?>
<!-- crosswalk-compile1.xsl
      Compile the stage 1 ("select") filter for a crosswalk
      G. Simons, 20 March 2009
-->
<xsl:stylesheet version="1.0" xmlns:alias="AliasForXSLT"
   xmlns:marc="http://www.loc.gov/MARC21/slim"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="xml"/>
   <xsl:include href="crosswalk-shared.xsl"/>
   <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="alias"/>
   <xsl:template match="/crosswalk">
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
         <xsl:apply-templates mode="select" select="select-stage/*"/>
         <xsl:comment>Exclude any record that does not match a
               criterion.</xsl:comment>
         <alias:template match="*" priority="-1"> </alias:template>
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
         <xsl:apply-templates mode="compile-tag" select="self::node()"/>
         <xsl:apply-templates mode="compile-code"
            select="self::node()"/>
         <xsl:apply-templates mode="compile-test"
            select="self::node()"/>
      </xsl:variable>
      <alias:template match="marc:record[marc:datafield{$criterion}]"
         priority="1">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
   <xsl:template match="control-field" mode="select">
      <xsl:variable name="criterion">
         <xsl:apply-templates mode="compile-tag" select="self::node()"/>
         <xsl:apply-templates mode="compile-test"
            select="self::node()"/>
      </xsl:variable>
      <alias:template
         match="marc:record[marc:controlfield{$criterion}]"
         priority="1">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
   <xsl:template match="leader" mode="select">
      <xsl:variable name="criterion">
         <xsl:apply-templates mode="compile-test"
            select="self::node()"/>
      </xsl:variable>
      <alias:template match="marc:record[marc:leader{$criterion}]"
         priority="1">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
</xsl:stylesheet>
