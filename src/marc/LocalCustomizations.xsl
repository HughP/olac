<?xml version="1.0" encoding="UTF-8"?>
<!-- 
   LocalCustomizations.xsl
      Expresses local customizations for the process of converting a 
      collection of MARC records to an OLAC static repository
   
   For repository: GIAL Library
   Developed by: Chris Hirt
   Revision date:  2008-08-27
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="1.0"
   xmlns:marc="http://www.loc.gov/MARC21/slim" >
   
   <!-- Fill in the date for this version of the metadata;
          see Implementers FAQ for full explanation -->
   <xsl:variable name="metadata-version-date">2008-08-26</xsl:variable>
   
   <!-- Fill in today's date (as the date as of which the archive
      description and participant list is current) -->
   <xsl:variable name="current-as-of-date">2008-08-27</xsl:variable>
   
   <!-- Fill in the web domain name that uniquely identifies your
      archive -->
   <xsl:variable name="repository-id">gial.edu</xsl:variable>
   
   <!-- The function that extracts the unique identifier for the
      record from the MARC record. By default it is the MARC 001
      control field, but you may need to change it for your
      application. -->
   <xsl:template match="marc:record" mode="record-id">
      <xsl:value-of select="marc:controlfield[@tag=001]"/>
   </xsl:template>
   
   <!-- Fill in descriptors for your repository and institution as
      directed below -->
   <xsl:template name="identify-response">
      <Identify
         xmlns="http://www.openarchives.org/OAI/2.0/static-repository"
         xmlns:oai="http://www.openarchives.org/OAI/2.0/"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/static-repository
             http://www.language-archives.org/OLAC/1.1/static-repository.xsd
        http://www.openarchives.org/OAI/2.0/
             http://www.language-archives.org/OLAC/1.1/OLAC-PMH.xsd">
         <!-- Fill in the full name of the repository -->
         <oai:repositoryName>Graduate Institute of Applied Linguistics Library</oai:repositoryName>
         <!-- Fill in the URL where the static repository resides on the web -->
         <oai:baseURL>http://www.gial.edu/library/olac_repository.xml</oai:baseURL>
         <!-- Don't touch this -->
         <oai:protocolVersion>2.0</oai:protocolVersion>
         <!-- Fill in the email address of the person responsible for
            the implementation and maintenance of the repository -->
         <oai:adminEmail>joan_spanne@sil.org</oai:adminEmail>
         <!-- Don't touch any of the following up to the next comment -->
         <oai:earliestDatestamp><xsl:value-of
            select="$metadata-version-date"/></oai:earliestDatestamp>
         <oai:deletedRecord>no</oai:deletedRecord>
         <oai:granularity>YYYY-MM-DD</oai:granularity>
         <oai:description>
            <oai-identifier
               xmlns="http://www.openarchives.org/OAI/2.0/oai-identifier"
               xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai-identifier 
         http://www.language-archives.org/OLAC/1.1/oai-identifier.xsd">
               <scheme>oai</scheme>
               <repositoryIdentifier><xsl:value-of select="$repository-id"/></repositoryIdentifier>
               <delimiter>:</delimiter>
               <sampleIdentifier>
                  <xsl:value-of select="concat( 'oai:', $repository-id, ':' )"/>
                  <xsl:apply-templates select="//marc:record[1]" mode="record-id"/>
               </sampleIdentifier>
            </oai-identifier>
         </oai:description>
         <oai:description>
            <olac-archive type="institutional"
               currentAsOf="{$current-as-of-date}"
               xmlns="http://www.language-archives.org/OLAC/1.1/olac-archive"
               xsi:schemaLocation="http://www.language-archives.org/OLAC/1.1/olac-archive
              http://www.language-archives.org/OLAC/1.1/olac-archive.xsd">
               <!-- Fill in the remainder of these fields following the definitions give in:
                  http://www.language-archives.org/OLAC/repositories.html#OLAC%20archive%20description
               -->
               <archiveURL>http://www.gial.edu/library</archiveURL>
               <!-- Make as many copies of <participant> as you need -->
               <participant name="Ferne Weimer"
                  role="Library Director" email="library@gial.edu"/>
               <participant name="Joan Spanne"
                  role="Automation Consultant" email="joan_spanne@sil.org"/>
               <institution>Graduate Institute of Applied Linguistics
                  (GIAL)</institution>
               <institutionURL>http://www.gial.edu</institutionURL>
               <shortLocation>Dallas, TX</shortLocation>
               <location/>
               <synopsis/>
               <access>Items are available for checkout to all GIAL
                  faculty and students, members of Bible translation
                  organizations, and International Linguistics Center
                  employees and volunteers</access>
            </olac-archive>
         </oai:description>
      </Identify>
   </xsl:template>
   
   <!-- Place any templates below that are local overrides of the
          templates as defined in the marc2olac stylesheet -->
   
</xsl:stylesheet>