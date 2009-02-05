<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:marc="http://www.loc.gov/MARC21/slim">
   <xsl:output method="xml"/>
   <xsl:strip-space elements="marc:collection"/>
   <xsl:template match="marc:collection">
      <xsl:copy>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   <!--Copy any record that matches a
               criterion.-->
   <xsl:template
      match="marc:record[marc:leader[substring( . ,1,3) = '012']]"
      priority="1">
      <xsl:copy-of select="self::node()"/>
   </xsl:template>
   <xsl:template
      match="marc:record[marc:datafield[contains( . , 'morphology')]]"
      priority="1">
      <xsl:copy-of select="self::node()"/>
   </xsl:template>
   <xsl:template
      match="marc:record[marc:datafield[@tag = '245']/marc:subfield[contains('ab', @code)][contains( . , 'dictionary')]]"
      priority="1">
      <xsl:copy-of select="self::node()"/>
   </xsl:template>
   <xsl:template
      match="marc:record[marc:datafield[starts-with(@tag,'24')][contains( . , 'lexicon')]]"
      priority="1">
      <xsl:copy-of select="self::node()"/>
   </xsl:template>
   <xsl:template match="marc:record[marc:datafield[@tag = '246']]"
      priority="1">
      <xsl:copy-of select="self::node()"/>
   </xsl:template>
   <!--Exclude any record that does not match a
               criterion.-->
   <xsl:template match="*" priority="-1"/>
</xsl:stylesheet>