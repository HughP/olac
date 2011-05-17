<?xml version="1.0" encoding="UTF-8"?>
<!-- 
      Expresses local customizations for the process of converting a 
      collection of MARC records to an OLAC static repository
   
   For repository: European Counsel of Modern Languages (ECML)
   Developed by: Chris Hirt
   Revision date:  2009-06-16
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   

    <!-- Fill in the date for this version of the metadata;
          see Implementers FAQ for full explanation -->
    <xsl:variable name="metadata-version-date">2009-06-16</xsl:variable>

    <!-- Fill in today's date (as the date as of which the archive
      description and participant list is current) -->
    <xsl:variable name="current-as-of-date">2009-06-16</xsl:variable>

    <!-- Fill in the web domain name that uniquely identifies your
      archive -->
    <xsl:variable name="repository-id">ecml.at</xsl:variable>

    <!-- The function that extracts the unique identifier for the
      record from the MARC record. By default it is the MARC 001
      control field, but you may need to change it for your
      application. -->
    <xsl:template match="marc:record" mode="record-id">
        <xsl:value-of select="substring(marc:datafield[@tag='035'] , 8)"/>
    </xsl:template>

    <!-- Fill in descriptors for your repository and institution as
      directed below -->
    <xsl:template name="identify-response">
        <Identify xmlns="http://www.openarchives.org/OAI/2.0/static-repository"
            xmlns:oai="http://www.openarchives.org/OAI/2.0/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/static-repository
             http://www.language-archives.org/OLAC/1.1/static-repository.xsd
        http://www.openarchives.org/OAI/2.0/
             http://www.language-archives.org/OLAC/1.1/OLAC-PMH.xsd">
            <!-- Fill in the full name of the repository -->
            <oai:repositoryName>European Centre for Modern Languages</oai:repositoryName>
            <!-- Fill in the URL where the static repository resides on the web -->
            <oai:baseURL>http://www.gial.edu/olac/ecml.xml</oai:baseURL>
            <!-- Don't touch this -->
            <oai:protocolVersion>2.0</oai:protocolVersion>
            <!-- Fill in the email address of the person responsible for
            the implementation and maintenance of the repository -->
            <oai:adminEmail>Catherine.Seewald@ecml.at</oai:adminEmail>
            <!-- Don't touch any of the following up to the next comment -->
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
                        <xsl:value-of select="concat( 'oai:', $repository-id, ':' )"/>
                        <xsl:apply-templates select="//marc:record[1]" mode="record-id"/>
                    </sampleIdentifier>
                </oai-identifier>
            </oai:description>
            <oai:description>
                <olac-archive type="institutional" currentAsOf="{$current-as-of-date}"
                    xmlns="http://www.language-archives.org/OLAC/1.1/olac-archive"
                    xsi:schemaLocation="http://www.language-archives.org/OLAC/1.1/olac-archive
              http://www.language-archives.org/OLAC/1.1/olac-archive.xsd">
                    <!-- Fill in the remainder of these fields following the definitions give in:
                  http://www.language-archives.org/OLAC/repositories.html#OLAC%20archive%20description
               -->
                    <archiveURL>http://www.ecml.at/doccentre/doccentre.asp?t=rescentre</archiveURL>
                    <!-- Make as many copies of <participant> as you need -->
                    <participant name="Catherine Seewald" role="Documentalist"
                        email="catherine.seewald@ecml.at"/>
                    <participant name="Waldemar Martyniuk" role="Executive Director"
                        email="waldemar.martyniuk@ecml.at"/>
                    <institution>European Centre for Modern Languages</institution>
                    <institutionURL>http://www.ecml.at</institutionURL>
                    <shortLocation>Graz, Austria</shortLocation>
                    <location/>
                    <synopsis/>
                    <access/>
                </olac-archive>
            </oai:description>
        </Identify>
    </xsl:template>


    <!-- local map to ISO639
        This is typically just an empty stub template.  It can be customized to provide additional institution-specific mappings that 
        the delivered iso639 mapping does not provide.
    -->
    <xsl:template name="local-map-to-iso639">
        <xsl:param name="lcsh"/>
        <xsl:if test="$lcsh">
            <xsl:variable name="lcsh_lc" select="lower-case($lcsh)"/>
            <xsl:choose>
                <!-- replace the line below with a real LC subject heading and cooresponding 3 letter ISO639 code-->
                <xsl:when test="$lcsh_lc = &quot;example language&quot;">failed</xsl:when>
                <!-- Below are additional examples of how to provide your own LCSH to ISO639 mappings that may be specific to you institution
                    <xsl:when test="$lcsh_lc = &quot;bacama language&quot;">bcy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yaqay language&quot;">jaq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;attie language&quot;">ati</xsl:when>
                -->

                <!-- if this template does not define any real mappings, it is normal for it to always return 'failed' -->
                <xsl:otherwise>failed</xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>






    <!-- Place any templates below that are local overrides of the
          templates as defined in the marc2olac stylesheet -->

<xsl:template name="process-690">
    <xsl:param name="content" />
    <xsl:param name="lang" />
        
    <!-- sub-a is lower case and with trailing period stripped, if it exists -->
    <xsl:variable name="sub-a" select="replace(lower-case( $content ),'\.','')"/>
    <xsl:variable name="code1">
        <xsl:if test="contains($sub-a, 'language') or contains($sub-a, 'dialect')">
            <xsl:choose>
                <!-- Bail out if it is not an individual language LCSH -->
                <xsl:when test="starts-with($sub-a, 'language')"/>
                <xsl:when test="starts-with($sub-a, 'second language')"/>
                <xsl:when test="starts-with($sub-a, 'natural language')"/>
                <xsl:when test="starts-with($sub-a, 'sign language')"/>
                <xsl:when test="contains($sub-a, 'languages')"/>
                <!-- Map to a code, returning either three letters or "failed" -->
                <xsl:otherwise>
                    <xsl:call-template name="local-map-to-iso639">
                        <xsl:with-param name="lcsh" select="$sub-a"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="code2">
        <xsl:choose>
            <xsl:when test="$code1 = 'failed' ">
                <xsl:call-template name="map-to-iso639">
                    <xsl:with-param name="lcsh" select="$sub-a"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$code1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <dc:subject>
        <xsl:if test="$debug = 'yes' and $code2 = 'failed' ">
            <xsl:attribute name="no_code">1</xsl:attribute>
        </xsl:if>
        <xsl:if test="$debug='yes'">
            <xsl:attribute name="from">690a</xsl:attribute>
        </xsl:if>
        <xsl:if test="$lang != '' ">
            <xsl:attribute name="xml:lang" select="$lang" />
        </xsl:if>
        <xsl:value-of select="$content" />
    </dc:subject>
    
    <xsl:if test="$code2 != '' and $code2 != 'failed' ">
        <dc:subject xsi:type="olac:language">
            <xsl:attribute name="olac:code" select="$code2"/>
            <xsl:if test="$debug='yes'">
                <xsl:attribute name="from">690a</xsl:attribute>
            </xsl:if>
        </dc:subject>
    </xsl:if>
</xsl:template>


    <xsl:template match="marc:datafield[@tag='690']">
        <xsl:choose>
            <xsl:when test="count(marc:subfield[@code='a']) = 2">
                <xsl:call-template name="process-690">
                    <xsl:with-param name="content" select="marc:subfield[@code='a'][1]" />
                    <xsl:with-param name="lang">fra</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="process-690">
                    <xsl:with-param name="content" select="marc:subfield[@code='a'][2]" />
                    <xsl:with-param name="lang">eng</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="marc:subfield[@code='a']">
                    <xsl:call-template name="process-690">
                        <xsl:with-param name="content" select=" . " />
                    </xsl:call-template>
                </xsl:for-each>                
            </xsl:otherwise>
        </xsl:choose>
        



    </xsl:template>


</xsl:stylesheet>
