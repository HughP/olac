<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                version="1.0">
   <xsl:param name="debug">no</xsl:param>
   <xsl:output method="xml" encoding="UTF-8"/>
   <xsl:template match="/sr:Repository">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:copy-of select="sr:Identify | sr:ListMetadataFormats"/>
         <xsl:apply-templates select="sr:ListRecords"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="sr:ListRecords">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="oai:record"/>
      </xsl:copy>
   </xsl:template>
   <!-- The reject rules --><!-- The retain rules --><xsl:template match="oai:record[oai:metadata/olac:olac[dc:type [starts-with(@xsi:type, 'olac')] ]]"
                 priority="1">
      <xsl:copy>
         <xsl:if test="$debug = 'yes'">
            <xsl:attribute name="rule"/>
         </xsl:if>
         <xsl:copy-of select="@* | *"/>
      </xsl:copy>
   </xsl:template>
   <!-- Handle records that match no rule --><xsl:template match="*" priority="-1"/>
</xsl:stylesheet>