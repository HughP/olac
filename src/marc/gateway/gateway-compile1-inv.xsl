<?xml version="1.0" encoding="UTF-8"?>
<!-- gateway-compile1-inv.xsl
   Compile the stage 1 inverse filter for a gateway
       That is, extract the records rejected by stage1
   G. Simons, 4 Feb 2009
   Last revised: 15 Apr 2009
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
         <xsl:comment>If one of the following selection criteria is met,
            then discard the record.</xsl:comment>
            <xsl:apply-templates select="select-stage/*"/>
            <xsl:comment>If none of the select criteria are met,
               then copy the record.</xsl:comment>
            <alias:template match="*" priority="-1">
                 <alias:copy-of select="self::node()"/>
            </alias:template>
         </alias:stylesheet>
   </xsl:template>
   <xsl:template match="test">
      <xsl:variable name="criteria">
         <xsl:apply-templates select="*"/>
      </xsl:variable>
      <alias:template match="marc:record{$criteria}" priority="1">
      </alias:template>
   </xsl:template>
</xsl:stylesheet>
