<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:marc="http://www.loc.gov/MARC21/slim">
   <xsl:output method="xml"/>
   <xsl:template match="marc:collection">
      <xsl:copy>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="marc:record[marc:leader012]" priority="1"/>
   <!--If none of the reject criteria are met,
               then copy the record.-->
   <xsl:template match="*" priority="-1">
      <xsl:copy-of select="self::node()"/>
   </xsl:template>
</xsl:stylesheet>