<?xml version="1.0" encoding="UTF-8"?>
<!-- 
     languagecommons_repository.xsl
     
     Transforms the complete OAI_PMH ListRecords response for the
     LanguageCommons collection at the Internet Archive to an OLAC
     static repository.
     
     The input data file is created by running language_commons_harvester.py.
     It starts with the request: 
     
        http://www.archive.org/services/oai.php?verb=ListRecords&metadataPrefix=oai_dc&set=collection:LanguageCommons
     
     and follows up with all the resumptionTokens and concatenates 
     all the results to create a single ListRecords response
     containing all records. It also makes a similar request for the 
     collection:LanguageCommons_audio and collection:LanguageCommons_video
     and appends the results.
     
     This XSTL when applied to that output creates the equivalent OLAC
     static repository. Don't forget to set the dates at the begining
     of the script.
     
     This stylesheet and documentation were originally written by Gary Simons
     at SIL International to process the rosettaproject collection.

     Haejoong Lee, LDC
     23 Sept 2010
     Last updated: 23 Sept 2010
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository"
   xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
   xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
   xmlns:dc="http://purl.org/dc/elements/1.1/" 
   xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   
   <xsl:output method="xml" encoding="UTF-8"/>
   
   <!-- Fill in the date for this version of the metadata; that is,
      update this only if the script is changed to update the metadata.
      See Implementers FAQ for full explanation -->
   <xsl:variable name="metadata-version-date">2010-09-23</xsl:variable>
   <xsl:variable name="metadata-numeric-date"
      select="translate($metadata-version-date, '-', '')"/>
   
   <!-- Fill in today's date (as the date as of which the archive
      description and participant list is current) -->
   <xsl:variable name="current-as-of-date">2010-09-23</xsl:variable>
   
   <!-- Fill in the web domain name that uniquely identifies your
      archive -->
   <xsl:variable name="repository-id">languagecommons.org</xsl:variable>
   

   <xsl:template match="/oai:OAI-PMH">
      <sr:Repository xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository"
         xmlns:oai="http://www.openarchives.org/OAI/2.0/"
         xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
         xmlns:dc="http://purl.org/dc/elements/1.1/" 
         xmlns:dcterms="http://purl.org/dc/terms/"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/static-repository http://www.language-archives.org/OLAC/1.1/static-repository.xsd
         http://www.language-archives.org/OLAC/1.1/ http://www.language-archives.org/OLAC/1.1/olac.xsd
         http://purl.org/dc/elements/1.1/ http://www.language-archives.org/OLAC/1.1/dc.xsd
         http://purl.org/dc/terms/ http://www.language-archives.org/OLAC/1.1/dcterms.xsd">

         <xsl:call-template name="identify-response"/>

         <sr:ListMetadataFormats>
            <oai:metadataFormat>
               <oai:metadataPrefix>olac</oai:metadataPrefix>
               <oai:schema>http://www.language-archives.org/OLAC/1.1/olac.xsd</oai:schema>
               <oai:metadataNamespace>http://www.language-archives.org/OLAC/1.1/</oai:metadataNamespace>
            </oai:metadataFormat>
         </sr:ListMetadataFormats>

         <sr:ListRecords metadataPrefix="olac">
            <xsl:apply-templates select="oai:ListRecords/oai:record"/>
         </sr:ListRecords>
      </sr:Repository>
   </xsl:template>
   
   <xsl:template name="identify-response">
      <sr:Identify>
         <oai:repositoryName>Language Commons Language Corpora
            </oai:repositoryName>
         <oai:baseURL>http://www.language-archives.org/devel/sr/languagecommons.org.xml</oai:baseURL>
         <oai:protocolVersion>2.0</oai:protocolVersion>
         <oai:adminEmail>laura@longnow.org</oai:adminEmail>
         <oai:earliestDatestamp>
            <xsl:value-of select="$metadata-version-date"/>
         </oai:earliestDatestamp>
         <oai:deletedRecord>no</oai:deletedRecord>
         <oai:granularity>YYYY-MM-DD</oai:granularity>
         <oai:description>
            <oai-identifier xmlns="http://www.openarchives.org/OAI/2.0/oai-identifier"
               xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai-identifier 
               http://www.language-archives.org/OLAC/1.1/oai-identifier.xsd">
               <scheme>oai</scheme>
               <repositoryIdentifier>
                  <xsl:value-of select="$repository-id"/>
               </repositoryIdentifier>
               <delimiter>:</delimiter>
               <sampleIdentifier>
                  <xsl:value-of select="concat('oai:', $repository-id,
                     substring-after(//oai:record[1]/oai:header/oai:identifier, '.org'))"/>
               </sampleIdentifier>
            </oai-identifier>
         </oai:description>
         <oai:description>
            <olac-archive currentAsOf="{$current-as-of-date}"
               type="institutional"
               xmlns="http://www.language-archives.org/OLAC/1.1/olac-archive"
               xsi:schemaLocation="http://www.language-archives.org/OLAC/1.1/olac-archive
               http://www.language-archives.org/OLAC/1.1/olac-archive.xsd">
               <archiveURL>http://www.archive.org/details/LanguageCommons</archiveURL>
               <participant email="ebice@meedan.net"
                  name="Ed Bice" role="Coordinator x3"/>
               <participant email="sb@csse.unimelb.edu.au"
                  name="Steven Bird" role="Coordinator x3"/>
               <participant email="laura@longnow.org"
                  name="Laura Welcher" role="Coordinator x3"/>
               <institution>Language Commons</institution>
               <institutionURL>http://languagecommons.org/</institutionURL>
               <shortLocation>San Francisco, USA</shortLocation>
               <location>Internet Archive, 300 Funston Avenue, San Francisco, CA 94118</location>
	       <synopsis>The Language Commons is an international consortium
                         that is creating a large collection of written and
                         spoken language material, made available under open
                         licenses. The content includes text and speech
                         corpora, along with translations, lexicons and other
                         linguistic resources that support large-scale
                         investigation of the world's languages. Members of
                         the consortium include academic, industrial, and
                         government organizations in many countries.
               </synopsis>
               <access>All holdings of the collection are freely accessible
                       online under open licenses as a special collection
                       within the Internet Archive.
               </access>
               <archivalSubmissionPolicy>The Language Commons accepts
                       linguistic corpora which may be distributed under any
                       of the licenses supported by the Internet Archive.
               </archivalSubmissionPolicy>
            </olac-archive>
         </oai:description>
      </sr:Identify>
   </xsl:template>
   
   <xsl:template match="oai:record">
      <!-- The SR standard supports only YYYY-MM-DD granularity -->
      <xsl:variable name="modified-date" 
         select="substring-before(oai:header/oai:datestamp,'T')"/>
      <!-- The datestamp for the record is the later of the
               metadata version date or the record modification date  -->
      <xsl:variable name="datestamp">
         <xsl:choose>
            <xsl:when test="$metadata-numeric-date >
               translate($modified-date,'-','')">
               <xsl:value-of select="$metadata-version-date"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$modified-date"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="mediatype" 
         select="substring-after(oai:header/oai:setspec[starts-with(.,'mediatype')],
         ':')"/>
         
      

      <oai:record>
         <oai:header>
            <oai:identifier>
               <xsl:value-of select="concat('oai:', $repository-id,
                  substring-after(oai:header/oai:identifier, '.org'))"/>
            </oai:identifier>
            <oai:datestamp>
               <xsl:value-of select="$datestamp"/>
            </oai:datestamp>
         </oai:header>
         <oai:metadata>
            <xsl:apply-templates select="oai:metadata/oai_dc:dc"/>
         </oai:metadata>
      </oai:record>
   </xsl:template>
   
   <xsl:template match="oai_dc:dc">
      <xsl:variable name="media" 
         select="ancestor::oai:record/oai:header/oai:setSpec[starts-with(.,'mediatype')]"/>
      <olac:olac>
         <xsl:if test="dc:format[contains(., 'Text')]">
            <dc:type xsi:type="dcterms:DCMIType">Text</dc:type>
         </xsl:if>
         <xsl:if test="$media = 'mediatype:audio'">
            <dc:type xsi:type="dcterms:DCMIType">Sound</dc:type>
         </xsl:if>
         <xsl:if test="$media = 'mediatype:movies'">
            <dc:type xsi:type="dcterms:DCMIType">MovingImage</dc:type>
         </xsl:if>
         <xsl:apply-templates/>
      </olac:olac>
   </xsl:template>
   
   <xsl:template match="dc:creator">
      <!-- These include semicolon delimited lists. Best practice 
         is one contributor per element. Therefore, convert to
         mulitple elements.  -->
      <xsl:call-template name="split-creators">
         <xsl:with-param name="creators" 
            select="concat(., ';')"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="split-creators">
      <xsl:param name="creators"/>
      <dc:creator>
         <xsl:value-of select="substring-before($creators, ';')"/>
      </dc:creator>
      <xsl:if test="substring-after($creators, ';')">
         <xsl:call-template name="split-creators">
            <xsl:with-param name="creators" 
               select="substring-after($creators, '; ')"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="dc:date">
      <!-- Reduce the date value to just the year. The harvested
         valuesare not valid, including month and day as 00, \
         and including the exact time (also as zero)  -->
      <dc:date xsi:type="dcterms:W3CDTF">
         <xsl:value-of select="substring-before(.,'-')"/>
      </dc:date>
   </xsl:template>
   
   <xsl:template match="dc:description">
      <xsl:variable name="media" 
         select="ancestor::oai:record/oai:header/oai:setSpec[starts-with(.,'mediatype')]"/>
      <dc:description><xsl:value-of select="."/></dc:description>
      <xsl:if test="$media = 'mediatype:audio' or $media =
         'mediatype:video' ">
         <xsl:choose>
            <xsl:when test="contains(., 'Grammar') or contains(.,
               'grammar')">
               <dc:type xsi:type="olac:linguistic-type"
                  olac:code="language_description"/>
               <dc:subject xsi:type="olac:linguistic-field"
                  olac:code="syntax"/>
            </xsl:when>
            <xsl:when test="contains(., 'conversation')">
               <dc:type xsi:type="olac:linguistic-type"
                  olac:code="primary_text"/>
            </xsl:when>
            <xsl:when test="contains(., 'word list') or contains(.,
               'vocabulary')">
               <dc:type xsi:type="olac:linguistic-type"
                  olac:code="lexicon"/>
            </xsl:when>
         </xsl:choose>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="dc:format">
      <xsl:choose>
         <!-- Suppress "Metadata" and "Scandata"  -->
         <xsl:when test=". = 'Metadata' or . = 'Scandata' or . =
            'Checksums' or . = 'Thumbnail' "/>
         <xsl:otherwise>
            <dc:format>
               <xsl:value-of select="."/>
            </dc:format>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="contains(., 'PDF')">
            <dc:format xsi:type="dcterms:IMT">application/pdf</dc:format>
         </xsl:when>
         <xsl:when test=". = 'Text'">
            <dc:format xsi:type="dcterms:IMT">text/plain</dc:format>
         </xsl:when>
         <xsl:when test=". = 'Shockwave Flash'">
            <dc:format xsi:type="dcterms:IMT">application/x-shockwave-flash</dc:format>
            <dc:type xsi:type="dcterms:DCMIType">Sound</dc:type>
         </xsl:when>
         <xsl:when test=". = 'Ogg Vorbis'">
            <dc:format xsi:type="dcterms:IMT">audio/ogg</dc:format>
         </xsl:when>
         <xsl:when test=". = 'VBR MP3'">
            <dc:format xsi:type="dcterms:IMT">audio/mpeg</dc:format>
         </xsl:when>
         <xsl:when test=". = 'WAVE'">
            <dc:format xsi:type="dcterms:IMT">audio/x-wav</dc:format>
         </xsl:when>
         <xsl:when test=". = '512Kb MPEG4'">
            <dc:format xsi:type="dcterms:IMT">video/mp4</dc:format>
         </xsl:when>
         <xsl:when test=". = 'Ogg Video'">
            <dc:format xsi:type="dcterms:IMT">video/ogg</dc:format>
         </xsl:when>
         <xsl:when test=". = 'QuickTime'">
            <dc:format xsi:type="dcterms:IMT">video/quicktime
            </dc:format>
         </xsl:when>
         <xsl:when test=". = 'Animated GIF'">
            <dc:format xsi:type="dcterms:IMT">image/gif</dc:format>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="dc:identifier">
      <dc:identifier xsi:type="dcterms:URI">
         <xsl:value-of select="."/>
      </dc:identifier>
   </xsl:template>
   
   <xsl:template match="dc:language">
      <xsl:choose>
         <xsl:when test="string-length(.) = 3">
            <dc:language xsi:type="olac:language" olac:code="{.}"/>
         </xsl:when>
         <xsl:when test=". = 'English'">
            <dc:language xsi:type="olac:language" olac:code="eng"/>
         </xsl:when>
         <xsl:when test=". = 'French'">
            <dc:language xsi:type="olac:language" olac:code="fra"/>
         </xsl:when>
         <xsl:otherwise>
            <dc:language><xsl:value-of select="."/></dc:language>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   
   <xsl:template match="dc:subject">
      <xsl:choose>
         <!-- If it's 3 letters in the same case, it's a language code -->
         <xsl:when test="string-length(.) = 3 and
            string-length(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
            '')) = 3
            or string-length(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
            '')) = 0">
            <dc:subject xsi:type="olac:language" olac:code="{.}"/>
         </xsl:when>
         <xsl:otherwise>
            <dc:subject><xsl:value-of select="."/></dc:subject>
            <xsl:choose>
               <xsl:when test="contains(., 'Orthography')">
                  <dc:type xsi:type="olac:linguistic-type"
                     olac:code="language_description"/>
                  <dc:subject xsi:type="olac:linguistic-field"
                     olac:code="writing_systems"/>
               </xsl:when>
               <xsl:when test="contains(., 'Grammar') or contains(.,
                  'grammar')">
                  <dc:type xsi:type="olac:linguistic-type"
                     olac:code="language_description"/>
                  <dc:subject xsi:type="olac:linguistic-field"
                     olac:code="syntax"/>
               </xsl:when>
               <xsl:when test="contains(., 'phonology') or contains(., 'Phonology')">
                  <dc:type xsi:type="olac:linguistic-type"
                     olac:code="language_description"/>
                  <dc:subject xsi:type="olac:linguistic-field"
                     olac:code="phonology"/>
               </xsl:when>
               <xsl:when test="contains(., 'Genesis') or contains(.,
                  'Glossed') or contains(., 'audio')"><!-- check
                     "audio" over time to see if it is always a text -->
                  <dc:type xsi:type="olac:linguistic-type"
                     olac:code="primary_text"/>
               </xsl:when>
               <xsl:when test="contains(., 'Vocabulary') or
                  contains(., 'Swadesh')">
                  <dc:type xsi:type="olac:linguistic-type"
                     olac:code="lexicon"/>
               </xsl:when>
            </xsl:choose>
            
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   
   <xsl:template match="dc:*">
      <xsl:element name="{name()}">
         <xsl:value-of select="."/>
      </xsl:element>
   </xsl:template>
   
</xsl:stylesheet>
