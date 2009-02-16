<?xml version="1.0" encoding="UTF-8"?>
<!-- dc_gateway-compile1.xsl
        Compile the stage 1 ("select") filter for an OAI_DC gateway
        G. Simons, 13 Feb 2009
        Last updated: 14 Feb 2009
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:alias="AliasForXSLT"
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
   xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
   version="1.0">
  <xsl:output method="xml"/>
   <xsl:include href="dc_gateway-shared.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="alias" result-prefix="xsl"/>
   <xsl:template match="/gateway">
         <alias:stylesheet version="1.0">
            <alias:output method="xml"/>
            <alias:template match="/root">
               <alias:copy>
                  <alias:apply-templates select="//oai:record"/>
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
      </xsl:variable>
      <alias:template
         match="oai:record[oai:metadata/oai_dc:dc{$criteria}]" priority="1">
         <alias:copy-of select="self::node()"/>
      </alias:template>
   </xsl:template>
</xsl:stylesheet>
