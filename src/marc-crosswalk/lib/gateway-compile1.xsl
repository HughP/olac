<?xml version="1.0" encoding="UTF-8"?>
<!-- gateway-compile1.xsl
        Compile the stage 1 ("select") filter for a gateway
        G. Simons, 4 Feb 2009
        Last updated: 4 May 2009
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:alias="AliasForXSLT"
   xmlns:marc="http://www.loc.gov/MARC21/slim"
   version="2.0">
  <xsl:output method="xml"/>
   <!-- Create an XSLT v. 1.0 stylesheet by default -->
   <xsl:param name="version">1.0</xsl:param>
   <xsl:include href="gateway-shared.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="alias" result-prefix="xsl"/>
   <xsl:template match="/gateway">
         <alias:stylesheet version="{$version}">
            <alias:output method="xml"/>
            <alias:strip-space elements="marc:collection"/>
            <alias:template match="marc:collection">
               <alias:copy>
                  <alias:apply-templates/>
               </alias:copy>
            </alias:template>
            <xsl:comment>Copy any record that matches a
               selection test.</xsl:comment>
            <xsl:apply-templates select="select-stage/*"/>
            <xsl:comment>Exclude any record that does not match any
               of the selection criteria.</xsl:comment>
            <alias:template match="*" priority="-1">
            </alias:template>
         </alias:stylesheet>
   </xsl:template>
   <xsl:template match="select-all" priority="1">
      <xsl:comment>Just copy every record to the output.</xsl:comment>
        <alias:template match="*">
         <alias:copy-of select="self::node()"/>
        </alias:template>
   </xsl:template>
   <xsl:template match="test">
      <xsl:variable name="criteria">
         <xsl:apply-templates select="*"/>
      </xsl:variable> <!-- Giving each criterion a different priority simply
         prevents the XSLT processor from reporting warnings that
         multiple templates matched. It is okay that multiple
         templates match and it does not matter which one it
         chooses since they all do the same thing, namely, copy the
         record. -->
      <alias:template match="marc:record{$criteria}" 
         priority="{position()}">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
</xsl:stylesheet>
