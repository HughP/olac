<?xml version="1.0" encoding="UTF-8"?>
<!-- gateway-compile2.xsl
   Compile the stage 2 ("reject") filter for a gateway
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
            <alias:template match="marc:collection">
               <alias:copy>
                  <alias:apply-templates/>
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
         <!-- Giving each criterion a different priority simply
            prevents the XSLT processor from reporting warnings that
            multiple templates matched. It is okay that multiple
            templates match and it does not matter which one it
            chooses since they all do the same thing, namely, delete
            the record. -->
      <alias:template match="marc:record{$criteria}"
         priority="{position()}">
      </alias:template>
   </xsl:template>
</xsl:stylesheet>
