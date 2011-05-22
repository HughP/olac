<?xml version="1.0" encoding="UTF-8"?>
<!-- 
     ListRecords2Repository.xsl
     Transforms an OAI-PMH ListRecords response to an OLAC static repository
     G. Simons, SIL International
     29 Apr 2011
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:oai="http://www.openarchives.org/OAI/2.0/"
   xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
   xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
   >
   
   <xsl:include href="importmap.xsl"/>
   <xsl:output method="xml"/>

   <xsl:template match="/oai:OAI-PMH">
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

         <!-- The following is in local.xsl which is imported
              via importmap.xsl -->
         <xsl:call-template name="identify-response"/>

         <sr:ListMetadataFormats>
            <oai:metadataFormat>
               <oai:metadataPrefix>olac</oai:metadataPrefix>
               <oai:schema>http://www.language-archives.org/OLAC/1.1/olac.xsd</oai:schema>
               <oai:metadataNamespace>http://www.language-archives.org/OLAC/1.1/</oai:metadataNamespace>
            </oai:metadataFormat>
         </sr:ListMetadataFormats>

         <sr:ListRecords metadataPrefix="olac">
            <xsl:apply-templates select="oai:ListRecords/*"/>
         </sr:ListRecords>
      </sr:Repository>
   </xsl:template>
   
   <!-- Remove any subject language codes. This is cleaning up
   leftovers from early work in the MySQL database. -->
   <xsl:template match="dc:subject[@xsi:type='olac:language']"/>

   <!--Copy anything else-->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>
