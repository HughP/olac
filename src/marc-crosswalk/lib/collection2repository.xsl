<?xml version="1.0" encoding="UTF-8"?>
<!-- 
     Collection2Repository.xsl
     Transforms a MARC XML Collection to an OLAC static repository
     G. Simons, SIL International
     26 Aug 2008
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/">
   <xsl:import href="marc2olac.xsl"/>
   <xsl:include href="importmap.xsl"/>
   <xsl:include href="utils.xsl" />
   
   <xsl:output method="xml"/>

   <xsl:template match="/marc:collection">
      <sr:Repository xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository"
         xmlns:oai="http://www.openarchives.org/OAI/2.0/"
         xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
         xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/static-repository 
         http://www.language-archives.org/OLAC/1.1/static-repository.xsd
         http://www.language-archives.org/OLAC/1.1/
         http://www.language-archives.org/OLAC/1.1/olac.xsd
         http://purl.org/dc/elements/1.1/
         http://dublincore.org/schemas/xmls/qdc/2008/02/11/dc.xsd
         http://purl.org/dc/terms/
         http://dublincore.org/schemas/xmls/qdc/2008/02/11/dcterms.xsd">

         <xsl:call-template name="identify-response"/>

         <sr:ListMetadataFormats>
            <oai:metadataFormat>
               <oai:metadataPrefix>olac</oai:metadataPrefix>
               <oai:schema>http://www.language-archives.org/OLAC/1.1/olac.xsd</oai:schema>
               <oai:metadataNamespace>http://www.language-archives.org/OLAC/1.1/</oai:metadataNamespace>
            </oai:metadataFormat>
         </sr:ListMetadataFormats>

         <sr:ListRecords metadataPrefix="olac">
            <xsl:apply-templates select="marc:record"/>
         </sr:ListRecords>
      </sr:Repository>
   </xsl:template>

   <xsl:template match="marc:record">
      <xsl:variable name="modified-date">
         <xsl:choose>
            <xsl:when test="count(marc:controlfield[@tag=005]) > 1">
               <xsl:value-of select="substring(marc:controlfield[@tag=005][1], 1, 8)"/>               
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="substring(marc:controlfield[@tag=005], 1, 8)"/>   
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- The datestamp for the record is the later of the
               metadata version date or the record creation date  -->
      <xsl:variable name="datestamp">
         <xsl:choose>
            <xsl:when test="translate($metadata-version-date,'-','') > $modified-date">
               <xsl:value-of select="$metadata-version-date"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of
                  select="concat(substring($modified-date,1,4),
                      '-', substring($modified-date,5,2), '-',
                      substring($modified-date,7,2))"
               />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <oai:record>
         <oai:header>
            <oai:identifier>
               <xsl:value-of select="concat( 'oai:', $repository-id, ':' )"/>
               <xsl:apply-templates select="." mode="record-id"/>
            </oai:identifier>
            <oai:datestamp>
               <xsl:value-of select="$datestamp"/>
            </oai:datestamp>
         </oai:header>
         <oai:metadata>
            <xsl:apply-templates select="." mode="olac"/>
         </oai:metadata>
      </oai:record>
   </xsl:template>
</xsl:stylesheet>
