<?xml version="1.0" encoding="UTF-8"?>
<!-- dc_gateway-compile2.xsl
   Compile the stage 2 ("reject") filter for an OAI_DC gateway
        G. Simons, 13 Feb 2009
        Last updated: 16 Feb 2009
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:alias="AliasForXSLT"
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
   version="1.0">
   <xsl:output method="xml"/>
   <xsl:include href="dc_gateway-shared.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="alias" result-prefix="xsl"/>
   <xsl:template match="/gateway">
      <alias:stylesheet version="1.0">
            <alias:output method="xml"/>
         <alias:template match="/oai:OAI-PMH">
            <alias:copy>
               <alias:copy-of
                  select="oai:responseDate | oai:request"/>
               <alias:apply-templates select="oai:ListRecords"/>
               </alias:copy>
         </alias:template>
         <alias:template match="oai:ListRecords">
            <alias:copy>
               <alias:apply-templates select="oai:record"/>
            </alias:copy>
         </alias:template>
         <xsl:comment>If one of the following rejection criteria is met,
            then discard the record.</xsl:comment>
            <xsl:apply-templates select="reject-stage/*"/>
            <xsl:comment>If none of the reject criteria are met,
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
      <alias:template match="oai:record[oai:metadata/oai_dc:dc{$criteria}]" priority="1">
      </alias:template>
   </xsl:template>
</xsl:stylesheet>
