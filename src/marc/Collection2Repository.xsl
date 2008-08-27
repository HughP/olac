<?xml version="1.0" encoding="UTF-8"?>
<!-- 
     Collection2Repository.xsl
     Transforms a MARC XML Collection to an OLAC static repository
     G. Simons, SIL International
     26 Aug 2008
-->
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:marc="http://www.loc.gov/MARC21/slim" 
   xmlns:oai="http://www.openarchives.org/OAI/2.0/" >
   <xsl:import href="marc2olac_v1.xsl"/>
   <xsl:include href="LocalCustomizations.xsl"/>
    <xsl:output method="xml"/>
   
   <xsl:template match="/marc:collection">
      <sr:Repository 
         xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository" 
         xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
         xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
         xmlns:dc="http://purl.org/dc/elements/1.1/"
         xmlns:dcterms="http://purl.org/dc/terms/"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/static-repository 
         http://www.language-archives.org/OLAC/1.1/static-repository.xsd
         http://www.language-archives.org/OLAC/1.1/
         http://www.language-archives.org/OLAC/1.1/olac.xsd
         http://purl.org/dc/elements/1.1/
         http://dublincore.org/schemas/xmls/qdc/2006/01/06/dc.xsd
         http://purl.org/dc/terms/
         http://dublincore.org/schemas/xmls/qdc/2006/01/06/dcterms.xsd">
         
         <xsl:call-template name="identify-response"/>
         
         <sr:ListMetadataFormats>
            <oai:metadataFormat>
               <oai:metadataPrefix>olac</oai:metadataPrefix>
               <oai:schema>http://www.language-archives.org/OLAC/1.1/olac.xsd</oai:schema>
               <oai:metadataNamespace>http://www.language-archives.org/OLAC/1.1/ </oai:metadataNamespace>
            </oai:metadataFormat>
         </sr:ListMetadataFormats>
         
         <sr:ListRecords metadataPrefix="olac">
            <xsl:apply-templates select="marc:record"/>
         </sr:ListRecords>
      </sr:Repository>
   </xsl:template>
   
   <xsl:template match="marc:record">
      
      <oai:record>
         <oai:header>
            <oai:identifier>
               <xsl:value-of select="concat( 'oai:', $repository-id, ':' )"/>
               <xsl:apply-templates select="." mode="record-id"/>
            </oai:identifier>
            <!-- The datestamp for the record is the later of the
               metadata version date or the record creation date  -->
            <oai:datestamp>
               <xsl:value-of select="$metadata-version-date"/>
            </oai:datestamp>
         </oai:header>
         <oai:metadata>
            <xsl:apply-templates select="." mode="olac"/>
         </oai:metadata>
      </oai:record>
   </xsl:template>
</xsl:stylesheet>
