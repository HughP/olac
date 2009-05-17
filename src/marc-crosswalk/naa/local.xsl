<?xml version="1.0" encoding="UTF-8"?>
<!-- 
      Expresses local customizations for the process of converting a 
      collection of MARC records to an OLAC static repository
   
   For repository: GIAL Library
   Developed by: Chris Hirt
   Revision date:  2008-08-27
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- Fill in the date for this version of the metadata;
          see Implementers FAQ for full explanation -->
    <xsl:variable name="metadata-version-date">2009-05-11</xsl:variable>

    <!-- Fill in today's date (as the date as of which the archive
      description and participant list is current) -->
    <xsl:variable name="current-as-of-date">2009-05-11</xsl:variable>

    <!-- Fill in the web domain name that uniquely identifies your
      archive -->
    <xsl:variable name="repository-id">naa.nmnh.si.edu</xsl:variable>

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
        <Identify xmlns="http://www.openarchives.org/OAI/2.0/static-repository"
            xmlns:oai="http://www.openarchives.org/OAI/2.0/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/static-repository
             http://www.language-archives.org/OLAC/1.1/static-repository.xsd
        http://www.openarchives.org/OAI/2.0/
             http://www.language-archives.org/OLAC/1.1/OLAC-PMH.xsd">
            <!-- Fill in the full name of the repository -->
            <oai:repositoryName>National Anthropological Archives</oai:repositoryName>
            <!-- Fill in the URL where the static repository resides on the web -->
            <oai:baseURL>http://www.nmnh.si.edu/naa/olac_repository.xml</oai:baseURL>
            <!-- Don't touch this -->
            <oai:protocolVersion>2.0</oai:protocolVersion>
            <!-- Fill in the email address of the person responsible for
            the implementation and maintenance of the repository -->
            <oai:adminEmail>email?</oai:adminEmail>
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
                    <archiveURL>http://www.nmnh.si.edu/naa/</archiveURL>
                    <!-- Make as many copies of <participant> as you need -->
                    <participant name="Who" role="Role?" email="email?"/>
                    <institution>National Anthropological Archives</institution>
                    <institutionURL>http://www.nmnh.si.edu/naa/</institutionURL>
                    <shortLocation>Suitland, MD</shortLocation>
                    <location>The archives are located in the Smithsonian Institution's Museum
                        Support Center in Suitland, MD, approximately six miles southeast of the
                        museums on the National Mall</location>
                    <synopsis>purpose of the archive...</synopsis>
                    <access>The Smithsonian operates a free hourly shuttle bus service between the
                        Mall and MSC; please request a pass when you schedule your appointment.
                        Public transportation is also available via Metrorail; the Museum Support
                        Center is a 10-15 minute walk from the Suitland Station. Free parking is
                        available if you prefer to drive. Archivists are available to assist
                        visitors with reference inquries and guide them to appropriate materials.
                        The NAA and HSFA also accept reference inquiries by email and
                        phone.</access>
                </olac-archive>
            </oai:description>
        </Identify>
    </xsl:template>

    <!-- Place any templates below that are local overrides of the
          templates as defined in the marc2olac stylesheet -->


    <xsl:template match="marc:controlfield[@tag='008']">
        <!-- ignore 'und' code because it is useless in the NAA set -->
        <xsl:if test="substring( . ,36,3) != 'und' and substring( . ,36,3) != '   '">
            <dc:language xsi:type="olac:language">
                <xsl:call-template name="show-source">
                    <xsl:with-param name="subfield">-35</xsl:with-param>
                </xsl:call-template>
                <xsl:attribute name="olac:code">
                    <xsl:value-of select="substring( . ,36,3)"/>
                </xsl:attribute>
            </dc:language>
        </xsl:if>
        <xsl:variable name="datecode" select="substring( . ,7,1)"/>
        <xsl:choose>
            <xsl:when test="$datecode = 'e'">
                <!-- e - detailed date typically used as creation date with manuscripts; dcterms:created -->
                <dcterms:created>
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">-07-14</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="substring( . , 8, 4)"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="substring( . , 12, 4)"/>
                    <xsl:text>-</xsl:text>
                    <xsl:if test="substring( . ,14) != ' '">
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="substring( . , 14, 2)"/>
                    </xsl:if>
                </dcterms:created>
            </xsl:when>
            <xsl:when
                test="($datecode = 'i' or $datecode = 'k') and substring( . ,8,4) != '    ' and substring( . ,12,4) != '    '">
                <!-- i k -  creation date range -->
                <dcterms:created>
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">-07-14</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="substring( . ,8,4)"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="substring( . ,12,4)"/>
                </dcterms:created>
            </xsl:when>
            <xsl:when
                test="$datecode = 'p' and substring( . ,8,4) != '    ' and substring( . ,12,4) != '    '">
                <!-- p - dcterms:issued (07-10) and dcterms:created (11-14) -->
                <dcterms:issued xsi:type="dcterms:W3CDTF">
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">-07-10</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="translate(substring( . ,8,4),' u','00')"/>
                </dcterms:issued>
                <dcterms:created xsi:type="dcterms:W3CDTF">
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">-11-14</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="translate(substring( . ,12,4),'u ','00')"/>
                </dcterms:created>
            </xsl:when>
            <xsl:when
                test="$datecode = 'r' and substring( . ,8,4) != '    ' and substring( . ,12,4) != '    '">
                <!-- r - dcterms:issued (07-10) and dc:date (11-14) -->
                <dcterms:issued xsi:type="dcterms:W3CDTF">
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">-07-10</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="translate(substring( . ,8,4),' u','00')"/>
                </dcterms:issued>
                <dc:date>
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">-11-14</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="translate(substring( . ,12,4),'u ','00')"/>
                </dc:date>
            </xsl:when>
            <xsl:when test="$datecode = 's' and substring( . ,8,4) != '    '">
                <!-- s - dc:date (07-10) -->
                <dc:date xsi:type="dcterms:W3CDTF">
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">-07-10</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="translate(substring( . ,8,4),' u','00')"/>
                </dc:date>
            </xsl:when>
            <xsl:when
                test="$datecode = 't' and substring( . ,8,4) != '    ' and substring( . ,12,4) != '    '">
                <!-- t - dcterms:issued (07-10) and dcterms:dateCopyrighted (11-14) -->
                <dcterms:issued xsi:type="dcterms:W3CDTF">
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">-07-10</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="translate(substring( . ,8,4),' u','00')"/>
                </dcterms:issued>
                <dcterms:dateCopyrighted xsi:type="dcterms:W3CDTF">
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">-11-14</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="translate(substring( . ,12,4),'u ','00')"/>
                </dcterms:dateCopyrighted>
            </xsl:when>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='650']">
        <xsl:call-template name="process-linguistic-type"/>
        <xsl:call-template name="process-linguistic-subject"/>

        <xsl:if test="not(contains( marc:subfield[@code='a'] , 'Language and language'))">
            <xsl:choose>
                <xsl:when test="@ind2='0'">
                    <xsl:variable name="sub-a" select="lower-case(marc:subfield[@code='a'])"/>
                    <xsl:variable name="code">
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
                                    <xsl:call-template name="map-to-iso639">
                                        <xsl:with-param name="lcsh" select="$sub-a"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:variable>
                    <dc:subject xsi:type="dcterms:LCSH">
                        <xsl:if test="$code = 'failed' ">
                            <xsl:attribute name="no_code">1</xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="show-source"/>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">abcdexyzv</xsl:with-param>
                            <xsl:with-param name="delimiter">--</xsl:with-param>
                        </xsl:call-template>
                    </dc:subject>
                    <xsl:if test="$code != '' and $code != 'failed' ">
                        <dc:subject xsi:type="olac:language">
                            <xsl:attribute name="olac:code" select="$code"/>
                            <xsl:call-template name="show-source"/>
                        </dc:subject>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@ind2='2'">
                    <dc:subject xsi:type="dcterms:MESH">
                        <xsl:call-template name="show-source"/>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">abcdexyzv</xsl:with-param>
                            <xsl:with-param name="delimiter">--</xsl:with-param>
                        </xsl:call-template>
                    </dc:subject>
                </xsl:when>
                <xsl:otherwise>
                    <dc:subject>
                        <xsl:call-template name="show-source"/>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">abcdexyzv</xsl:with-param>
                            <xsl:with-param name="delimiter">--</xsl:with-param>
                        </xsl:call-template>
                    </dc:subject>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="marc:subfield[@code='y']">
                <dcterms:temporal>
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">y</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">y</xsl:with-param>
                    </xsl:call-template>
                </dcterms:temporal>
            </xsl:if>
            <xsl:if test="marc:subfield[@code='z']">
                <dcterms:spatial>
                    <xsl:call-template name="show-source">
                        <xsl:with-param name="subfield">z</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">z</xsl:with-param>
                        <xsl:with-param name="delimiter">, </xsl:with-param>
                    </xsl:call-template>
                </dcterms:spatial>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag='695']">
        <xsl:variable name="code">
            <xsl:if test="marc:subfield[@code='a']">
                <xsl:call-template name="map-to-iso639">
                    <xsl:with-param name="lcsh"
                        select="concat( marc:subfield[@code='a'] , ' language')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <dc:subject>
            <xsl:if test="$no_code = 'yes' and $code and $code = 'failed' ">
                <xsl:attribute name="no_code">1</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcexz</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcexz</xsl:with-param>
                <xsl:with-param name="delimiter">--</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
        <xsl:if test="$code and $code != '' and $code != 'failed' ">
            <dc:subject xsi:type="olac:language">
                <xsl:attribute name="olac:code" select="$code"/>
                <xsl:call-template name="show-source">
                    <xsl:with-param name="subfield">a</xsl:with-param>
                </xsl:call-template>
            </dc:subject>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
