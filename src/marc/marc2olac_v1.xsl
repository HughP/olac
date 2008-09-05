<?xml version="1.0" encoding="UTF-8"?>
<!--
This stylesheet is meant to be imported by a local version that
may override the definition of any template in order to match
local cataloging practices.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="marc">
    <xsl:import href="http://www.loc.gov/standards/marcxml/xslt/MARC21slimUtils.xsl"/>
    <xsl:param name="show-source">yes</xsl:param>
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/marc:collection">
        <olac:olacCollection>
            <!-- We haven't yet defined such an
            element in olac.xsd -->
            <xsl:apply-templates select="marc:record" mode="olac"/>
        </olac:olacCollection>
    </xsl:template>
    <xsl:template match="/marc:record">
        <xsl:apply-templates select="." mode="olac"/>
    </xsl:template>


    <xsl:template match="marc:record" mode="olac">
        <olac:olac
            xsi:schemaLocation=" http://purl.org/dc/elements/1.1/    http://www.language-archives.org/OLAC/1.1/dc.xsd    http://purl.org/dc/terms/    http://www.language-archives.org/OLAC/1.1/dcterms.xsd    http://www.language-archives.org/OLAC/1.1/    http://www.language-archives.org/OLAC/1.1/olac.xsd    http://www.compuling.net/projects/olac/    http://www.language-archives.org/OLAC/1.1/third-party/software.xsd ">
            <xsl:apply-templates select="marc:leader"/>
            <xsl:apply-templates select="marc:controlfield"/>
            <xsl:apply-templates select="marc:datafield"/>
        </olac:olac>
    </xsl:template>

    <xsl:template match="marc:controlfield">
        <!-- Ignore if it did not match a more specific template -->
    </xsl:template>

    <xsl:template name="show-source">
        <xsl:param name="subfield"/>
        <!-- Optional parameter -->
        <xsl:if test="$show-source='yes'">
            <xsl:attribute name="from">
                <xsl:choose>
                    <xsl:when test="self::marc:leader">leader</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@tag"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="$subfield"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>



    <!-- Get the DCMI-Type out of the leader -->
    <xsl:template match="marc:leader">
        <xsl:variable name="leader6" select="substring( . ,7,1)"/>
        <xsl:variable name="leader7" select="substring( . ,8,1)"/>
        <xsl:if test="$leader7='c'">
            <dc:type xsi:type="dcterms:DCMIType">
                <xsl:call-template name="show-source"/>
                <xsl:text>Collection</xsl:text>
            </dc:type>
        </xsl:if>
        <dc:type xsi:type="dcterms:DCMIType">
            <xsl:call-template name="show-source"/>
            <!-- GFS:  Do we care about "manuscript" somewhere else?
            (It doesn't belong here as a DCMI Type.)
            <xsl:if
                test="$leader6='d' or $leader6='f' or $leader6='p' or $leader6='t'">
                <xsl:text>manuscript</xsl:text>
            </xsl:if>
            -->
            <xsl:choose>
                <!-- GFS: These are not the exact terms from the
                vocabulary; e.g. should be uppercase? -->
                <xsl:when test="$leader6='a' or $leader6='t'">text</xsl:when>
                <xsl:when test="$leader6='e' or $leader6='f'">cartographic</xsl:when>
                <xsl:when test="$leader6='c' or $leader6='d'">notated music</xsl:when>
                <xsl:when test="$leader6='i' or $leader6='j'">sound recording</xsl:when>
                <xsl:when test="$leader6='k'">still image</xsl:when>
                <xsl:when test="$leader6='g'">moving image</xsl:when>
                <xsl:when test="$leader6='r'">three dimensional object</xsl:when>
                <xsl:when test="$leader6='m'">software, multimedia</xsl:when>
                <xsl:when test="$leader6='p'">mixed material</xsl:when>
            </xsl:choose>
        </dc:type>
    </xsl:template>

    <!-- CJH: in our GIAL dataset, the 001 stores the internal ID which is specific to destiny.  I have confirmed with the librarian that the 001 is persistent as long as we are using the Destiny ILS.  The 035 stores a string containing the barcode of the first item under this record... which we won't be using at this point -->
    <xsl:template match="marc:controlfield[@tag='001']">
        <dc:identifier>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:identifier>
    </xsl:template>

    <xsl:template match="marc:controlfield[@tag='008']">
        <!-- Process the language field -->
        <!-- JAS: prefer 041 and parse, or 590  -->
        <dc:language xsi:type="olac:language">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">-36</xsl:with-param>
            </xsl:call-template>
            <xsl:attribute name="olac:code">
                <xsl:value-of select="substring( . ,36,3)"/>
            </xsl:attribute>
        </dc:language>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='020']">
        <dc:identifier>
            <xsl:call-template name="show-source"/>
            <xsl:text>URN:ISBN:</xsl:text>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:identifier>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=033]">
        <dcterms:temporal>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dcterms:temporal>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='041']">
        <xsl:choose>
            <xsl:when test="lower-case(marc:subfield[@code='2']) = 'iso639-2'">
                <dc:language xsi:type="dcterms:ISO639-2">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </dc:language>
            </xsl:when>
            <xsl:when test="lower-case(marc:subfield[@code='2']) = 'iso639-3'">
                <dc:language xsi:type="dcterms:ISO639-3">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </dc:language>
            </xsl:when>
            <xsl:when test="lower-case(marc:subfield[@code='2']) = 'rfc1766'">
                <dc:language xsi:type="dcterms:RFC1766">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </dc:language>
            </xsl:when>
            <xsl:when test="lower-case(marc:subfield[@code='2']) = 'rfc3066'">
                <dc:language xsi:type="dcterms:RFC3066">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </dc:language>
            </xsl:when>
            <xsl:when test="lower-case(marc:subfield[@code='2']) = 'rfc4646'">
                <dc:language xsi:type="dcterms:RFC4646">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </dc:language>
            </xsl:when>
            <xsl:otherwise>
                <!-- default case assumes ISO639-2 -->
                <dc:language xsi:type="dcterms:ISO639-2">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:language>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='046']">
        <!-- JAS: All the dates and date ranges in 046 should be ignored if the code in 046$a = “x” (indicating Incorrect dates) -->
        <xsl:if test="marc:subfield[@code='a'] != 'x'">
            <dcterms:created>
                <xsl:call-template name="show-source">
                    <xsl:with-param name="subfield">kl</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">kl</xsl:with-param>
                </xsl:call-template>
            </dcterms:created>
        </xsl:if>
        <dcterms:modified>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">j</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='j']"/>
        </dcterms:modified>
        <dcterms:valid>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">mn</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">mn</xsl:with-param>
            </xsl:call-template>
        </dcterms:valid>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='050']">
        <dc:subject xsi:type="dcterms:LCC">
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:subject>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='082']">
        <dc:subject xsi:type="dcterms:DDC">
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:subject>
    </xsl:template>




    <!-- JAS: OLAC prefers contributor to creator
    Subfields abcdq have name information
    e4 contain role information
    omit other subfields -->
    <xsl:template match="marc:datafield[@tag='100']">
        <dc:contributor>
            <xsl:call-template name="show-source"/>
            <!-- GFS: I added the normalize-space which takes out all
            the extraneous white space, but this still isn't the
            right answer. The LOC sample has a 700 field with 3
            subfields, and this just concatenates together the
            content of all the subfields.  Need to add logic for
            the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:contributor>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
    Subfields abcdq have name information
    e4 contain role information
    omit other subfields -->
    <xsl:template match="marc:datafield[@tag='110']">
        <dc:contributor>
            <xsl:call-template name="show-source"/>
            <!-- GFS: I added the normalize-space which takes out all
            the extraneous white space, but this still isn't the
            right answer. The LOC sample has a 700 field with 3
            subfields, and this just concatenates together the
            content of all the subfields.  Need to add logic for
            the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:contributor>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
    Subfields abcdq have name information
    e4 contain role information
    omit other subfields -->
    <xsl:template match="marc:datafield[@tag='111']">
        <dc:contributor>
            <xsl:call-template name="show-source"/>
            <!-- GFS: I added the normalize-space which takes out all
            the extraneous white space, but this still isn't the
            right answer. The LOC sample has a 700 field with 3
            subfields, and this just concatenates together the
            content of all the subfields.  Need to add logic for
            the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:contributor>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag='130']">
        <dcterms:alternative>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:alternative>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='210']">
        <dc:alternative>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:alternative>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='240']">
        <dc:alternative>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:alternative>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='242']">
        <dc:alternative>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:alternative>
    </xsl:template>




    <!-- JAS: We probably want additional title fields 242, possibly 130, 240
    Subfields fghk belong in other QDC fields (fg are dates, h is format, k is like type and probably better dealt with through the leader  -->
    <xsl:template match="marc:datafield[@tag='245']">
        <dc:title>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:title>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='246']">
        <dc:alternative>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:alternative>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag='260']">
        <dc:publisher>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">ab</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </dc:publisher>
        <dcterms:dateCopyrighted>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">c</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='c']"/>
        </dcterms:dateCopyrighted>
        <dcterms:issued>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">c</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='c']"/>
        </dcterms:issued>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=300]">
        <dcterms:extent>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dcterms:extent>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=310]">
        <dcterms:accrualPeriodicity>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dcterms:accrualPeriodicity>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='440']">
        <dcterms:isPartOf>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:isPartOf>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='490']">
        <dcterms:isPartOf>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:isPartOf>
    </xsl:template>




    <!-- Default rule for 5xx tags when no other 5xx tag is matched by following rules -->
    <xsl:template match="marc:datafield[starts-with(@tag,'5')]" priority="0.5">
        <dc:description>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>


    <xsl:template priority="1" match="marc:datafield[@tag='500']">
        <dc:description>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>





    <xsl:template priority="1" match="marc:datafield[@tag='502']">
        <dc:description>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>




    <xsl:template priority="1" match="marc:datafield[@tag='505']">
        <dcterms:tableOfContents>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:tableOfContents>
    </xsl:template>



    <xsl:template priority="1" match="marc:datafield[@tag='506']">
        <dc:rights>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>



    <xsl:template priority="1" match="marc:datafield[@tag='510']">
        <dcterms:isReferencedBy>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:isReferencedBy>
    </xsl:template>




    <xsl:template priority="1" match="marc:datafield[@tag='514']">
        <dc:description>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>





    <xsl:template priority="1" match="marc:datafield[@tag='518']">
        <dc:description>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>



    <xsl:template priority="1" match="marc:datafield[@tag='520'][@ind1='' or @ind1=' ' or @ind2=3]">
        <dcterms:abstract>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:abstract>
    </xsl:template>




    <xsl:template priority="1" match="marc:datafield[@tag='521']">
        <dcterms:audience>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dcterms:audience>
    </xsl:template>




    <xsl:template priority="1" match="marc:datafield[@tag=522]">
        <dcterms:spatial>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dcterms:spatial>
    </xsl:template>



    <!-- JAS: skip 530 -->
    <xsl:template priority="1" match="marc:datafield[@tag='530']">
        <dcterms:hasFormat>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:hasFormat>
        <dcterms:hasFormat xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">u</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">u</xsl:with-param>
            </xsl:call-template>
        </dcterms:hasFormat>
    </xsl:template>



    <xsl:template priority="1" match="marc:datafield[@tag='533']">
        <dcterms:extent>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">e</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">e</xsl:with-param>
            </xsl:call-template>
        </dcterms:extent>
        <dcterms:medium>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">a</xsl:with-param>
            </xsl:call-template>
        </dcterms:medium>
        <dcterms:created>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">d</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">d</xsl:with-param>
            </xsl:call-template>
        </dcterms:created>
    </xsl:template>




    <xsl:template priority="1" match="marc:datafield[@tag='538']">
        <dcterms:requires>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:requires>
    </xsl:template>




    <xsl:template priority="1" match="marc:datafield[@tag='540']">
        <dc:rights>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>




    <xsl:template priority="1" match="marc:datafield[@tag=541]">
        <dcterms:accrualMethod>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">c</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='c']"/>
        </dcterms:accrualMethod>
    </xsl:template>



    <xsl:template priority="1" match="marc:datafield[@tag=542]">
        <dcterms:rightsHolder>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">d</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='d']"/>
        </dcterms:rightsHolder>
    </xsl:template>



    <xsl:template priority="1" match="marc:datafield[@tag='561']">
        <dcterms:provenance>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:provenance>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='600']">
        <dc:subject>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='610']">
        <dc:subject>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='611']">
        <dc:subject>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='630']">
        <dc:subject>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>






    <!-- JAS: subfields abx
    Subfield y in dcterms:temporal
    subfield z in dcterms:spatial-->
    <xsl:template match="marc:datafield[@tag='650']">
        <dc:subject>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
        <dcterms:temporal>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">y</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">y</xsl:with-param>
            </xsl:call-template>
        </dcterms:temporal>
        <dcterms:spatial>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">z</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">z</xsl:with-param>
            </xsl:call-template>
        </dcterms:spatial>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='651']">
        <dcterms:spatial>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">az</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">az</xsl:with-param>
            </xsl:call-template>
        </dcterms:spatial>
        <dcterms:temporal>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">y</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">y</xsl:with-param>
            </xsl:call-template>
        </dcterms:temporal>
    </xsl:template>



    <!-- JAS: field 651 was skipped; subfields az belong in dcterms:spatial  -->
    <xsl:template match="marc:datafield[@tag='653']">
        <dc:subject>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='655']">
        <dc:type>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:type>
    </xsl:template>



    <!-- JAS: 662 belongs in dcterms:spatial -->
    <xsl:template match="marc:datafield[@tag='662']">
        <dc:coverage>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdefgh</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdefgh</xsl:with-param>
            </xsl:call-template>
        </dc:coverage>
        <dcterms:spatial>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">a</xsl:with-param>
            </xsl:call-template>
        </dcterms:spatial>
    </xsl:template>




    <!-- JAS: OLAC prefers contributor to creator
    Subfields abcdq have name information
    e4 contain role information
    omit other subfields -->
    <xsl:template match="marc:datafield[@tag='700']">
        <dc:contributor>
            <xsl:call-template name="show-source"/>
            <!-- GFS: I added the normalize-space which takes out all
            the extraneous white space, but this still isn't the
            right answer. The LOC sample has a 700 field with 3
            subfields, and this just concatenates together the
            content of all the subfields.  Need to add logic for
            the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:contributor>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
    Subfields abcdq have name information
    e4 contain role information
    omit other subfields -->
    <xsl:template match="marc:datafield[@tag='710']">
        <dc:contributor>
            <xsl:call-template name="show-source"/>
            <!-- GFS: I added the normalize-space which takes out all
            the extraneous white space, but this still isn't the
            right answer. The LOC sample has a 700 field with 3
            subfields, and this just concatenates together the
            content of all the subfields.  Need to add logic for
            the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:contributor>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
    Subfields abcdq have name information
    e4 contain role information
    omit other subfields -->
    <xsl:template match="marc:datafield[@tag='711']">
        <dc:contributor>
            <xsl:call-template name="show-source"/>
            <!-- GFS: I added the normalize-space which takes out all
            the extraneous white space, but this still isn't the
            right answer. The LOC sample has a 700 field with 3
            subfields, and this just concatenates together the
            content of all the subfields.  Need to add logic for
            the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:contributor>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
    Subfields abcdq have name information
    e4 contain role information
    omit other subfields -->
    <xsl:template match="marc:datafield[@tag='720']">
        <dc:contributor>
            <xsl:call-template name="show-source"/>
            <!-- GFS: I added the normalize-space which takes out all
            the extraneous white space, but this still isn't the
            right answer. The LOC sample has a 700 field with 3
            subfields, and this just concatenates together the
            content of all the subfields.  Need to add logic for
            the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:contributor>
    </xsl:template>






    <xsl:template match="marc:datafield[@tag='730']">
        <dc:alternative>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:alternative>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='740']">
        <dc:alternative>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:alternative>
    </xsl:template>



    <!-- JAS: skip 752 (one occurrence in GIAL data, and that was redundant with 260) -->
    <xsl:template match="marc:datafield[@tag='752']">
        <dc:coverage>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdfgh</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdfgh</xsl:with-param>
            </xsl:call-template>
        </dc:coverage>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='760']">
        <dcterms:isPartOf>
            <xsl:call-template name="show-source"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:isPartOf>
        <dcterms:isPartOf xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">o</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">o</xsl:with-param>
            </xsl:call-template>
        </dcterms:isPartOf>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag='773']">
        <dcterms:isPartOf>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">ntgq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ntgq</xsl:with-param>
            </xsl:call-template>
        </dcterms:isPartOf>
        <dcterms:isPartOf xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">o</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">o</xsl:with-param>
            </xsl:call-template>
        </dcterms:isPartOf>
    </xsl:template>






    <xsl:template match="marc:datafield[@tag='774']">
        <dcterms:hasPart>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">nt</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:hasPart>
        <dcterms:hasPart xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">o</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">o</xsl:with-param>
            </xsl:call-template>
        </dcterms:hasPart>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='775']">
        <dcterms:hasVersion>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">nt</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:hasVersion>
        <dcterms:hasVersion xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">o</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">o</xsl:with-param>
            </xsl:call-template>
        </dcterms:hasVersion>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='776']">
        <dcterms:hasFormat>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">nt</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:hasFormat>
        <dcterms:hasFormat xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">o</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">o</xsl:with-param>
            </xsl:call-template>
        </dcterms:hasFormat>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='780']">
        <dcterms:replaces>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">nt</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:replaces>
        <dcterms:replaces xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">o</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">o</xsl:with-param>
            </xsl:call-template>
        </dcterms:replaces>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='785']">
        <dcterms:isReplacedBy>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">nt</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:isReplacedBy>
        <dcterms:isReplacedBy xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">o</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">o</xsl:with-param>
            </xsl:call-template>
        </dcterms:isReplacedBy>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='786']">
        <dcterms:source xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">o</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">o</xsl:with-param>
            </xsl:call-template>
        </dcterms:source>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='800']">
        <dcterms:isPartOf>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:isPartOf>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='810']">
        <dcterms:isPartOf>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:isPartOf>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='811']">
        <dcterms:isPartOf>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:isPartOf>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='830']">
        <dcterms:isPartOf>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:isPartOf>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=856]">
        <dcterms:format xsi:type="dcterms:IMT">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">q</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='q']"/>
        </dcterms:format>
        <dc:identifier xsi:type="dcterms:URI">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">u</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='u']"/>
        </dc:identifier>
    </xsl:template>





    <xsl:template match="marc:datafield" priority="0">
        <!-- For any datafield that does not match a specific
        template, just do nothing -->
    </xsl:template>
</xsl:stylesheet>
