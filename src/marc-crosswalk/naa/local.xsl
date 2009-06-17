<?xml version="1.0" encoding="UTF-8"?>
<!-- 
      Expresses local customizations for the process of converting a 
      collection of MARC records to an OLAC static repository
   
   For repository: National Anthropological Archives (NAA)
   Developed by: Chris Hirt
   Revision date:  2009-05-27
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- Fill in the date for this version of the metadata;
          see Implementers FAQ for full explanation -->
    <xsl:variable name="metadata-version-date">2009-05-27</xsl:variable>

    <!-- Fill in today's date (as the date as of which the archive
      description and participant list is current) -->
    <xsl:variable name="current-as-of-date">2009-05-27</xsl:variable>

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
            <oai:baseURL>http://www.gial.edu/olac/naa.xml</oai:baseURL>
            <!-- Don't touch this -->
            <oai:protocolVersion>2.0</oai:protocolVersion>
            <!-- Fill in the email address of the person responsible for
            the implementation and maintenance of the repository -->
            <oai:adminEmail>email@naa.nmnh.si.edu</oai:adminEmail>
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
                    <participant name="Robert Leopold" role="Director" email="leopold@si.edu"/>
                    <participant name="Who" role="Role?" email="email@naa.nmnh.si.edu"/>
                    <institution>National Anthropological Archives</institution>
                    <institutionURL>http://www.nmnh.si.edu/naa/</institutionURL>
                    <shortLocation>Suitland, MD</shortLocation>
                    <location>The archives are located in the Smithsonian Institution's Museum
                        Support Center, 4210 Silver Hill Road,  Suitland, MD, approximately six miles southeast of the
                        museums on the National Mall.</location>
                    <synopsis>The National Anthropological Archives  collect and preserve 
                        historical and contemporary anthropological materials that document the
                        world's cultures and the history of anthropology. Their collections 
                        represent the four fields of anthropology &#x2014; ethnology, linguistics, 
                        archaeology, and physical anthropology &#x2014; and include fieldnotes, 
                        journals, manuscripts, correspondence, photographs, maps, 
                        sound recordings, film and video created by Smithsonian 
                        anthropologists and other preeminent scholars  This OLAC
                        repository encodes the subset of holdings
                        that are cataloged with the subject heading: 
                        Language and languages&#x2014;Documentation .
                    </synopsis>
                    <access>The National Anthropological Archives may
                        be visited by appointment only. For an online
                        appointment request form and directions for
                        finding the archives, see http://www.nmnh.si.edu/naa/about.htm#visiting.
                        Archivists are available to assist
                        visitors with reference inquries and guide them to appropriate materials.
                        The NAA also accepts reference inquiries by email and
                        phone.</access>
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


    <xsl:template match="marc:controlfield[@tag='008']">
        <!-- ignore 'und' code because it is useless in the NAA set -->
        <xsl:if test="substring( . ,36,3) != 'und' and matches(lower-case(substring( . ,36,3)),'[a-z][a-z][a-z]')">
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
                        <xsl:if test="$no_code = 'yes' and $code = 'failed' ">
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
        <xsl:variable name="code2">
            <xsl:if test="$code and $code = 'failed'">
            <xsl:call-template name="map695">
                <xsl:with-param name="string695">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abcexz</xsl:with-param>
                        <xsl:with-param name="delimiter">--</xsl:with-param>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <dc:subject>
            <xsl:if test="$no_code = 'yes' and $code and $code = 'failed' and $code2 and $code2 = 'failed'">
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
        <xsl:variable name="displaycode">
            <xsl:choose>
                <xsl:when test="$code and $code != 'failed'">
                    <xsl:value-of select="$code" />
                </xsl:when>
                <xsl:when test="$code2 and $code2 != 'failed'">
                    <xsl:value-of select="$code" />
                </xsl:when>
                <xsl:otherwise>failed</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$displaycode and $displaycode != '' and $displaycode != 'failed' ">
            <dc:subject xsi:type="olac:language">
                <xsl:attribute name="olac:code" select="$displaycode"/>
                <xsl:call-template name="show-source">
                    <xsl:with-param name="subfield">a</xsl:with-param>
                </xsl:call-template>
            </dc:subject>
        </xsl:if>
    </xsl:template>

    <xsl:template name="map695">
        <xsl:param name="string695"/>
        <xsl:choose>
            <xsl:when test="$string695 = 'Acadians'">fra</xsl:when>
            <xsl:when test="$string695 = 'Ahtna'">aht</xsl:when>
            <xsl:when test="$string695 = 'Ahtna[?]'">aht</xsl:when>
            <xsl:when test="$string695 = &quot;Akwa'ala&quot;">ppi</xsl:when>
            <xsl:when test="$string695 = 'Alabama Indians'">akz</xsl:when>
            <xsl:when test="$string695 = 'Algonkin'">alg</xsl:when>
            <xsl:when test="$string695 = 'Algonquian'">alg</xsl:when>
            <xsl:when test="$string695 = 'Alibamu'">akz</xsl:when>
            <xsl:when test="$string695 = 'Apache'">apa</xsl:when>
            <xsl:when test="$string695 = 'Assiniboin'">asb</xsl:when>
            <xsl:when test="$string695 = 'Athapascan Indians'">ath</xsl:when>
            <xsl:when test="$string695 = 'Athapaskan'">ath</xsl:when>
            <xsl:when test="$string695 = 'Bannock'">pao</xsl:when>
            <xsl:when test="$string695 = 'Basques'">eus</xsl:when>
            <xsl:when test="$string695 = 'Beaver'">bea</xsl:when>
            <xsl:when test="$string695 = 'Bellacoola'">blc</xsl:when>
            <xsl:when test="$string695 = 'Bhutanese'">dzo</xsl:when>
            <xsl:when test="$string695 = 'Blackfeet'">bla</xsl:when>
            <xsl:when test="$string695 = 'Blackfoot'">bla</xsl:when>
            <xsl:when test="$string695 = 'Caddoan'">cad</xsl:when>
            <xsl:when test="$string695 = 'Caddoan Indians'">cad</xsl:when>
            <xsl:when test="$string695 = 'Cahuilla?'">chl</xsl:when>
            <xsl:when test="$string695 = 'Canela'">ram</xsl:when>
            <xsl:when test="$string695 = 'Cayuse'">xcy</xsl:when>
            <xsl:when test="$string695 = 'Chemakum'">cmk</xsl:when>
            <xsl:when test="$string695 = 'Chepewyan'">chp</xsl:when>
            <xsl:when test="$string695 = 'Cherokee Indians'">chr</xsl:when>
            <xsl:when test="$string695 = 'Chetco'">ctc</xsl:when>
            <xsl:when test="$string695 = 'Chickasaw Indians'">cic</xsl:when>
            <xsl:when test="$string695 = 'Chiga (African people)'">cgg</xsl:when>
            <xsl:when test="$string695 = 'Chilcotin'">clc</xsl:when>
            <xsl:when test="$string695 = 'Chimalapa'">zoh</xsl:when>
            <xsl:when test="$string695 = 'Chippewa'">ciw</xsl:when>
            <xsl:when test="$string695 = 'Chitimachan'">ctm</xsl:when>
            <xsl:when test="$string695 = 'Chiwere'">iow</xsl:when>
            <xsl:when test="$string695 = 'Choctaw Indians'">cho</xsl:when>
            <xsl:when test="$string695 = 'Chuckchee'">ckt</xsl:when>
            <xsl:when test="$string695 = 'Chukchee'">ckt</xsl:when>
            <xsl:when test="$string695 = 'Cochimi'">coj</xsl:when>
            <xsl:when test="$string695 = 'Comecrudo'">xcm</xsl:when>
            <xsl:when test="$string695 = 'Comeya'">dih</xsl:when>
            <xsl:when test="$string695 = 'Comox'">coo</xsl:when>
            <xsl:when test="$string695 = 'Cotonam'">xcn</xsl:when>
            <xsl:when test="$string695 = 'Cotoname'">xcn</xsl:when>
            <xsl:when test="$string695 = 'Coushatta Indians'">cku</xsl:when>
            <xsl:when test="$string695 = 'Cowichan'">hur</xsl:when>
            <xsl:when test="$string695 = 'Cowlitz'">cow</xsl:when>
            <xsl:when test="$string695 = 'Creek Indians'">mus</xsl:when>
            <xsl:when test="$string695 = 'Cubeo Indians'">cub</xsl:when>
            <xsl:when test="$string695 = 'Diegueno'">dih</xsl:when>
            <xsl:when test="$string695 = 'Diola (African people)'">dyo</xsl:when>
            <xsl:when test="$string695 = 'Diriku (African people)'">diu</xsl:when>
            <xsl:when test="$string695 = 'Dodoth (African people)'">kdj</xsl:when>
            <xsl:when test="$string695 = 'Duau'">dva</xsl:when>
            <xsl:when test="$string695 = 'Duwamish'">slh</xsl:when>
            <xsl:when test="$string695 = 'Ebon'">mah</xsl:when>
            <xsl:when test="$string695 = 'Efe (African people)'">efe</xsl:when>
            <xsl:when test="$string695 = 'Flathead'">fla</xsl:when>
            <xsl:when test="$string695 = 'Fox Indians'">sac</xsl:when>
            <xsl:when test="$string695 = 'Fox language'">sac</xsl:when>
            <xsl:when test="$string695 = 'Gabrieleno'">xgf</xsl:when>
            <xsl:when test="$string695 = 'Gabrielino'">xgf</xsl:when>
            <xsl:when test="$string695 = 'Gabrielino Indians'">xgf</xsl:when>
            <xsl:when test="$string695 = 'Galabi'">car</xsl:when>
            <xsl:when test="$string695 = 'Galice Creek'">gce</xsl:when>
            <xsl:when test="$string695 = 'Gisu (African people)'">myx</xsl:when>
            <xsl:when test="$string695 = 'Gros Ventre'">ats</xsl:when>
            <xsl:when test="$string695 = 'Guajiro'">wayuu</xsl:when>
            <xsl:when test="$string695 = 'Gullah'">gul</xsl:when>
            <xsl:when test="$string695 = 'Han'">haa</xsl:when>
            <xsl:when test="$string695 = 'Hindu'">hin</xsl:when>
            <xsl:when test="$string695 = 'Hindustani'">hin</xsl:when>
            <xsl:when test="$string695 = 'Hoh'">qui</xsl:when>
            <xsl:when test="$string695 = 'Hopi Indians'">hop</xsl:when>
            <xsl:when test="$string695 = 'Hupa Indians'">hup</xsl:when>
            <xsl:when test="$string695 = 'Huron'">way</xsl:when>
            <xsl:when test="$string695 = 'Igbo (African people)'">ibo</xsl:when>
            <xsl:when test="$string695 = 'Iroquoian'">iro</xsl:when>
            <xsl:when test="$string695 = 'Iroquois'">iro</xsl:when>
            <xsl:when test="$string695 = 'Izi (African People)'">izi</xsl:when>
            <xsl:when test="$string695 = 'Juaneno'">lui</xsl:when>
            <xsl:when test="$string695 = 'Kansa'">ksk</xsl:when>
            <xsl:when test="$string695 = 'Karamojong (African people)'">kdj</xsl:when>
            <xsl:when test="$string695 = 'Karankawa'">zkk</xsl:when>
            <xsl:when test="$string695 = 'Karkin'">krb</xsl:when>
            <xsl:when test="$string695 = 'Karok Indians'">kyh</xsl:when>
            <xsl:when test="$string695 = 'Karuk'">kyh</xsl:when>
            <xsl:when test="$string695 = 'Kasua'">khs</xsl:when>
            <xsl:when test="$string695 = 'Kechua'">que</xsl:when>
            <xsl:when test="$string695 = 'Kichai'">kii</xsl:when>
            <xsl:when test="$string695 = 'Kili'">keb</xsl:when>
            <xsl:when test="$string695 = 'Kiliwi'">kib</xsl:when>
            <xsl:when test="$string695 = 'Klikitat'">yak</xsl:when>
            <xsl:when test="$string695 = 'Koasati Indians'">cku</xsl:when>
            <xsl:when test="$string695 = 'Kootenai'">kut</xsl:when>
            <xsl:when test="$string695 = 'Kula'">tpg</xsl:when>
            <xsl:when test="$string695 = 'Kulanapan'">poo</xsl:when>
            <xsl:when test="$string695 = 'Kutchin'">gwi</xsl:when>
            <xsl:when test="$string695 = 'Kuvale (African people)'">her</xsl:when>
            <xsl:when test="$string695 = 'Kwalhioqua'">qwt</xsl:when>
            <xsl:when test="$string695 = 'Lamut'">eve</xsl:when>
            <xsl:when test="$string695 = 'Leya (African people)'">toi</xsl:when>
            <xsl:when test="$string695 = 'Loma (African people)'">lom</xsl:when>
            <xsl:when test="$string695 = 'Luganda'">lug</xsl:when>
            <xsl:when test="$string695 = 'LuisenÌƒo'">lui</xsl:when>
            <xsl:when test="$string695 = 'Luiseno'">lui</xsl:when>
            <xsl:when test="$string695 = 'Luiseno/Diegueno'">lui</xsl:when>
            <xsl:when test="$string695 = 'Lumbee'">lmz</xsl:when>
            <xsl:when test="$string695 = 'Magyars'">hun</xsl:when>
            <xsl:when test="$string695 = 'Makah'">myh</xsl:when>
            <xsl:when test="$string695 = 'Malay'">msa</xsl:when>
            <xsl:when test="$string695 = 'Malecite'">pqm</xsl:when>
            <xsl:when test="$string695 = 'Massachusett'">wam</xsl:when>
            <xsl:when test="$string695 = 'Mbandieru (African people)'">her</xsl:when>
            <xsl:when test="$string695 = 'Miami'">mia</xsl:when>
            <xsl:when test="$string695 = 'Modoc'">kla</xsl:when>
            <xsl:when test="$string695 = 'Molala'">mbe</xsl:when>
            <xsl:when test="$string695 = 'Monachi'">mnr</xsl:when>
            <xsl:when test="$string695 = 'Montauk'">mof</xsl:when>
            <xsl:when test="$string695 = 'Moquelummnan'">skd</xsl:when>
            <xsl:when test="$string695 = 'Mosquito'">miq</xsl:when>
            <xsl:when test="$string695 = 'Munsee Indians'">umu</xsl:when>
            <xsl:when test="$string695 = 'Nahane'">kkz</xsl:when>
            <xsl:when test="$string695 = 'Nanaimo'">hur</xsl:when>
            <xsl:when test="$string695 = 'Narraganset'">mof</xsl:when>
            <xsl:when test="$string695 = 'Nascapi'">nsk</xsl:when>
            <xsl:when test="$string695 = 'Natick'">wam</xsl:when>
            <xsl:when test="$string695 = 'Navaho'">nav</xsl:when>
            <xsl:when test="$string695 = 'Nepalese'">nep</xsl:when>
            <xsl:when test="$string695 = 'Netsilik Eskimos'">iku</xsl:when>
            <xsl:when test="$string695 = 'Nez Perce'">nez</xsl:when>
            <xsl:when test="$string695 = 'Nicola'">thp</xsl:when>
            <xsl:when test="$string695 = 'Nisqualli'">slh</xsl:when>
            <xsl:when test="$string695 = 'Nooksak'">nok</xsl:when>
            <xsl:when test="$string695 = 'Nottoway'">ntw</xsl:when>
            <xsl:when test="$string695 = 'Nyaturu (African people)'">rim</xsl:when>
            <xsl:when test="$string695 = 'Okanagan Indians'">oka</xsl:when>
            <xsl:when test="$string695 = 'Otawa'">otw</xsl:when>
            <xsl:when test="$string695 = 'Pamlico'">pmk</xsl:when>
            <xsl:when test="$string695 = 'Papago'">ood</xsl:when>
            <xsl:when test="$string695 = 'Patagonian'">cym</xsl:when>
            <xsl:when test="$string695 = 'Pawnee Indians'">paw</xsl:when>
            <xsl:when test="$string695 = 'Pentlatch'">ptw</xsl:when>
            <xsl:when test="$string695 = 'Peoria'">mia</xsl:when>
            <xsl:when test="$string695 = 'Pequot'">mof</xsl:when>
            <xsl:when test="$string695 = 'Piegan'">bla</xsl:when>
            <xsl:when test="$string695 = 'Pohnpeian (Micronesian people)'">pon</xsl:when>
            <xsl:when test="$string695 = 'Pokot'">pko</xsl:when>
            <xsl:when test="$string695 = 'Ponapean'">pon</xsl:when>
            <xsl:when test="$string695 = 'Ponca'">oma</xsl:when>
            <xsl:when test="$string695 = 'Ponka'">oma</xsl:when>
            <xsl:when test="$string695 = 'Poosepatuck'">mof</xsl:when>
            <xsl:when test="$string695 = 'Portueguese'">por</xsl:when>
            <xsl:when test="$string695 = 'Potowatomi'">pot</xsl:when>
            <xsl:when test="$string695 = 'Puelchean'">pue</xsl:when>
            <xsl:when test="$string695 = 'Quiche'">quc</xsl:when>
            <xsl:when test="$string695 = 'Sac &amp; Fox'">sac</xsl:when>
            <xsl:when test="$string695 = 'Safwa (African people)'">sbk</xsl:when>
            <xsl:when test="$string695 = 'Samaritan'">smp</xsl:when>
            <xsl:when test="$string695 = 'Samoans'">smo</xsl:when>
            <xsl:when test="$string695 = 'Sandia'">tix</xsl:when>
            <xsl:when test="$string695 = 'Sarcee'">srs</xsl:when>
            <xsl:when test="$string695 = 'Sauk'">sac</xsl:when>
            <xsl:when test="$string695 = 'Seminole Indians'">mus</xsl:when>
            <xsl:when test="$string695 = 'Serian'">sei</xsl:when>
            <xsl:when test="$string695 = 'Serrano'">ser</xsl:when>
            <xsl:when test="$string695 = 'Shawnee Indians'">sjw</xsl:when>
            <xsl:when test="$string695 = 'Shoshone'">shh</xsl:when>
            <xsl:when test="$string695 = 'Shoshonean'">shh</xsl:when>
            <xsl:when test="$string695 = 'Shoshonian'">shh</xsl:when>
            <xsl:when test="$string695 = 'Sioux'">dak</xsl:when>
            <xsl:when test="$string695 = 'Squamish'">squ</xsl:when>
            <xsl:when test="$string695 = 'Suk (African people)'">pko</xsl:when>
            <xsl:when test="$string695 = 'Tagalog (Philippine people)'">tgl</xsl:when>
            <xsl:when test="$string695 = 'Tanaina'">tfn</xsl:when>
            <xsl:when test="$string695 = 'Tenino'">tgn</xsl:when>
            <xsl:when test="$string695 = 'Tibetans'">bod</xsl:when>
            <xsl:when test="$string695 = 'Timucua Indians'">tjm</xsl:when>
            <xsl:when test="$string695 = 'Tlatskanai'">qwt</xsl:when>
            <xsl:when test="$string695 = 'Tlingit ?'">tli</xsl:when>
            <xsl:when test="$string695 = 'Tolowa'">tol</xsl:when>
            <xsl:when test="$string695 = 'Toma (African people)'">tod</xsl:when>
            <xsl:when test="$string695 = 'Tonto-Apache'">apw</xsl:when>
            <xsl:when test="$string695 = 'Trobriand Islanders'">kij</xsl:when>
            <xsl:when test="$string695 = 'Trukese (Micronesian people)'">chk</xsl:when>
            <xsl:when test="$string695 = 'Tsimshian[?]'">tsi</xsl:when>
            <xsl:when test="$string695 = 'Tubare'">tbu</xsl:when>
            <xsl:when test="$string695 = 'Tuolumne'">csm</xsl:when>
            <xsl:when test="$string695 = 'Tututni'">tuu</xsl:when>
            <xsl:when test="$string695 = 'Twana'">twa</xsl:when>
            <xsl:when test="$string695 = 'Tzotzil'">tzo</xsl:when>
            <xsl:when test="$string695 = 'Umpqua'">xup</xsl:when>
            <xsl:when test="$string695 = 'Wailaki'">wlk</xsl:when>
            <xsl:when test="$string695 = 'Walapai'">yuf</xsl:when>
            <xsl:when test="$string695 = 'Walla Walla'">waa</xsl:when>
            <xsl:when test="$string695 = 'Wallawalla'">waa</xsl:when>
            <xsl:when test="$string695 = 'Wintun'">wit</xsl:when>
            <xsl:when test="$string695 = 'Yakima'">yak</xsl:when>
            <xsl:when test="$string695 = 'Yakona'">aes</xsl:when>
            <xsl:when test="$string695 = 'Yakutat Tlingit'">tli</xsl:when>
            <xsl:when test="$string695 = 'Yana Indians'">ynn</xsl:when>
            <xsl:when test="$string695 = 'Yapese (Micronesian people)'">yap</xsl:when>
            <xsl:when test="$string695 = 'Yaquina'">aes</xsl:when>
            <xsl:when test="$string695 = 'Yoruba (African people)'">yor</xsl:when>
            <xsl:when test="$string695 = 'Yuchean'">yuc</xsl:when>
            <xsl:when test="$string695 = 'Yuchi Indians'">yuc</xsl:when>
            <xsl:when test="$string695 = 'Yuki ?'">yuk</xsl:when>
            <xsl:when test="$string695 = 'Yuma'">yum</xsl:when>
            <xsl:when test="$string695 = 'Yurok ?'">yur</xsl:when>
            <xsl:when test="$string695 = 'Zapoteco'">zap</xsl:when>
            <xsl:when test="$string695 = 'Zulu (African people)'">zul</xsl:when>

            <xsl:when test="$string695 = 'Apache--Chiricahua'">apm</xsl:when>
            <xsl:when test="$string695 = 'Apache--Jicarilla'">apj</xsl:when>
            <xsl:when test="$string695 = 'Apache--Jicarilla--medicine lodge'">apj</xsl:when>
            <xsl:when test="$string695 = 'Apache--Lipan'">apl</xsl:when>
            <xsl:when test="$string695 = 'Apache--Mescalero'">apm</xsl:when>
            <xsl:when test="$string695 = 'Apache--Sierra Blanca'">apw</xsl:when>
            <xsl:when test="$string695 = 'Apache--Tonto'">apw</xsl:when>
            <xsl:when test="$string695 = 'Apache--White Mountain'">apw</xsl:when>
            <xsl:when test="$string695 = 'Apaches--Sierra Blanco'">apw</xsl:when>
            <xsl:when test="$string695 = 'Athapascan--Northern'">ath</xsl:when>
            <xsl:when test="$string695 = 'Baluba--ethnobotany'">lua</xsl:when>
            <xsl:when test="$string695 = 'Chehalis, Lower--Literature, Folklore'">cea</xsl:when>
            <xsl:when test="$string695 = 'Dakota Indians--Folklore'">dak</xsl:when>
            <xsl:when test="$string695 = 'Delaware (tribe)--linguistics'">del</xsl:when>
            <xsl:when test="$string695 = 'Gabrielino + Luiseno--Music, Songs'">lui</xsl:when>
            <xsl:when test="$string695 = 'Gabrielino + Serrano--Music, Songs--Dance, War'"
                >ser</xsl:when>
            <xsl:when test="$string695 = 'Gila River--etymology'">mrc</xsl:when>
            <xsl:when test="$string695 = 'Ilocano--linguistics'">ilo</xsl:when>
            <xsl:when test="$string695 = 'Iroquois--Oneida'">one</xsl:when>
            <xsl:when test="$string695 = 'Iroquois--Onondaga'">ono</xsl:when>
            <xsl:when test="$string695 = 'Iroquois--Seneca'">see</xsl:when>
            <xsl:when test="$string695 = 'Iroquois--Tuscarora'">tus</xsl:when>
            <xsl:when test="$string695 = 'Irouqois--Onondaga--tobacco'">ono</xsl:when>
            <xsl:when test="$string695 = 'Italians--United States'">ita</xsl:when>
            <xsl:when test="$string695 = 'Maya--Kekchi'">kek</xsl:when>
            <xsl:when test="$string695 = 'Maya--Tzotzil'">tzo</xsl:when>
            <xsl:when test="$string695 = 'Mayan--Cakchiquel'">cak</xsl:when>
            <xsl:when test="$string695 = 'Mayan--Quiche'">quc</xsl:when>
            <xsl:when test="$string695 = 'Nooksaak--vocabulary'">nok</xsl:when>
            <xsl:when test="$string695 = 'Okinagan--Saimilkameen--vocabulary'">oka</xsl:when>
            <xsl:when test="$string695 = 'Paiute--Northern'">pao</xsl:when>
            <xsl:when test="$string695 = 'Paiute--Southern'">ute</xsl:when>
            <xsl:when test="$string695 = 'Sauk and Fox--gentes'">sac</xsl:when>
            <xsl:when test="$string695 = 'Skagit--vocabulary'">ska</xsl:when>
            <xsl:when test="$string695 = 'Tipai--linguistics'">dih</xsl:when>
            <xsl:when test="$string695 = 'Towa--Jemez'">tow</xsl:when>
            <xsl:when test="$string695 = 'Towa--Old Pecos'">tow</xsl:when>
            <xsl:when test="$string695 = 'Umpqua--Upper'">xup</xsl:when>
            <xsl:otherwise>failed</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
