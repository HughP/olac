<?xml version="1.0" encoding="UTF-8"?>
<!--
    This stylesheet is meant to be imported by a local version that
    may override the definition of any template in order to match
    local cataloging practices.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="marc">
    <xsl:import
        href="http://www.loc.gov/standards/marcxml/xslt/MARC21slimUtils.xsl"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/marc:collection">
        <olac:olacCollection>
            <!-- We haven't yet defined such an
                element in olac.xsd -->
            <xsl:apply-templates select="marc:record"/>
        </olac:olacCollection>
    </xsl:template>
    <xsl:template match="/marc:record">
        <xsl:apply-templates select="."/>
    </xsl:template>
    <xsl:template match="marc:record">
        <xsl:variable name="leader" select="marc:leader"/>
        <xsl:variable name="controlField008"
            select="marc:controlfield[@tag=008]"/>
        <olac:olac xsi:schemaLocation=" http://purl.org/dc/elements/1.1/    http://www.language-archives.org/OLAC/1.0/dc.xsd    http://purl.org/dc/terms/    http://www.language-archives.org/OLAC/1.0/dcterms.xsd    http://www.language-archives.org/OLAC/1.0/    http://www.language-archives.org/OLAC/1.0/olac.xsd    http://www.compuling.net/projects/olac/    http://www.language-archives.org/OLAC/1.0/third-party/software.xsd ">
            <xsl:call-template name="process-DCMI-Type">
                <xsl:with-param name="leader6"
                    select="substring(marc:leader,7,1)"/>
                <xsl:with-param name="leader7"
                    select="substring(marc:leader,8,1)"/>
            </xsl:call-template>
            <xsl:call-template name="process-Language">
                <xsl:with-param name="controlField008"
                    select="marc:controlfield[@tag=008]"/>
            </xsl:call-template>
            <xsl:call-template name="process-ID">
                <xsl:with-param name="controlField001" select="marc:controlfield[@tag=001]" />
            </xsl:call-template>
            <xsl:apply-templates select="marc:datafield"/>
        </olac:olac>
    </xsl:template>



    <!-- JAS: We probably want additional title fields 242, possibly 130, 240
			Subfields fghk belong in other QDC fields (fg are dates, h is format, k is like type and probably better dealt with through the leader  -->
    <xsl:template match="marc:datafield[@tag=245]">
        <dc:title from_marc_field="245">
            <xsl:value-of select="." />
        </dc:title>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=130 or @tag=210 or @tag=240 or @tag=242 or @tag=246 or @tag=730 or @tag=740]">
        <dc:alternative>
            <xsl:attribute name="from_marc_field"><xsl:value-of select="@tag" /></xsl:attribute>
            <xsl:value-of select="." />
        </dc:alternative>
    </xsl:template>






    <!-- JAS: OLAC prefers contributor to creator
		Subfields abcdq have name information
		e4 contain role information
		omit other subfields -->
    <xsl:template
        match="marc:datafield[@tag=100]|marc:datafield[@tag=110]|marc:datafield[@tag=111]|marc:datafield[@tag=700]|marc:datafield[@tag=710]|marc:datafield[@tag=711]|marc:datafield[@tag=720]">
        <dc:creator>
            <!-- GFS: I added the normalize-space which takes out all
                the extraneous white space, but this still isn't the
                right answer. The LOC sample has a 700 field with 3
                subfields, and this just concatenates together the
                content of all the subfields.  Need to add logic for
                the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:creator>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=541]/marc:subfield[@code=c]">
        <dcterms:accrualMethod from_marc_field="541c">
            <xsl:value-of select="." />
        </dcterms:accrualMethod>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=310]/marc:subfield[@code=a]">
        <dcterms:accrualPeriodicity from_marc_field="310a">
            <xsl:value-of select="." />
        </dcterms:accrualPeriodicity>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=521]/marc:subfield[@code=a]">
        <dcterms:audience from_marc_field="521a">
            <xsl:value-of select="." />
        </dcterms:audience>
    </xsl:template>


    <!-- CJH: in our GIAL dataset, the 001 stores the internal ID which is specific to destiny.  I have confirmed with the librarian that the 001 is persistent as long as we are using the Destiny ILS.  The 035 stores a string containing the barcode of the first item under this record... which we won't be using at this point -->
    <xsl:template name="process-ID">
        <xsl:param name="controlField001"/>
        <dc:identifier from_marc_field="001">
            <xsl:value-of select="$controlField001"/>
        </dc:identifier>
    </xsl:template>


    <xsl:template name="process-DCMI-Type">
        <xsl:param name="leader6"/>
        <xsl:param name="leader7"/>
        <xsl:if test="$leader7='c'">
            <dc:type from_marc_field="leader7=c" xsi:type="dcterms:DCMIType">Collection</dc:type>
        </xsl:if>
        <dc:type xsi:type="dcterms:DCMIType">
            <xsl:attribute name="from_marc_field">
                <xsl:choose>
                    <!-- CJH: replaced by regex below: <xsl:when test="$leader6='a' or $leader6='t' or $leader6='e' or $leader6='f' or $leader6='c' or $leader6='d' or $leader6='i' or $leader6='j' or $leader6='k' or $leader6='g' or $leader6='r' or $leader6='m' or $leader6='p'">leader6</xsl:when>
                    -->
                    <xsl:when test="contains('atefcdijkgrmp',$leader6)">leader6</xsl:when>

                </xsl:choose>
            </xsl:attribute>
         <!-- GFS:  Do we care about "manuscript"?
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





    <xsl:template match="marc:datafield[@tag=655]">
        <dc:type from_marc_field="655">
            <xsl:value-of select="."/>
        </dc:type>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=260]">
        <dc:publisher from_marc_field="260ab">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </dc:publisher>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=260]/marc:subfield[@code='c']">
        <dcterms:dateCopyrighted from_marc_field="260c">
            <xsl:value-of select="."/>
        </dcterms:dateCopyrighted>
        <dcterms:issued from_marc_field="260c">
            <xsl:value-of select="."/>
        </dcterms:issued>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=533]/marc:subfield[@code='d']">
        <dcterms:created from_marc_field="533d">
            <xsl:value-of select="."/>
        </dcterms:created>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=520][@ind1='' or @ind1=' ' or @ind2=3]">
        <dcterms:abstract from_marc_field="520">
            <xsl:value-of select="."/>
        </dcterms:abstract>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=505]">
        <dcterms:tableOfContents from_marc_field="505">
            <xsl:value-of select="." />
        </dcterms:tableOfContents>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=500 or @tag=502 or @tag=514 or @tag=518]">
        <dc:description>
            <xsl:attribute name="from_marc_field"><xsl:value-of select="@tag" /></xsl:attribute>
            <xsl:value-of select="." />
        </dc:description>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=300]/marc:subfield[@code='a']">
        <dcterms:extent from_marc_field="300a">
            <xsl:value-of select="."/>
        </dcterms:extent>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=533]">
        <dcterms:extent from_marc_field="533ae">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ae</xsl:with-param>
            </xsl:call-template>
        </dcterms:extent>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=856]/marc:subfield[@code='q']">
        <dcterms:medium xsi:type="dcterms:IMT" from_marc_field="856q">
            <xsl:value-of select="." />
        </dcterms:medium>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=533]/marc:subfield[@code='a']">
        <dcterms:medium from_marc_field="533a">
            <xsl:value-of select="." />
        </dcterms:medium>
    </xsl:template>



    <xsl:template name="process-Language">
        <xsl:param name="controlField008"/>
        <!-- JAS: prefer 041 and parse, or 590  -->
        <dc:language from_marc_field="leader?008">
            <xsl:value-of select="substring($controlField008,36,3)"/>
        </dc:language>
    </xsl:template>


    <xsl:template match="marc:datafield[500&lt;= @tag and @tag&lt;= 599 ][not(@tag=506 or @tag=530 or @tag=540 or @tag=546)]">
        <dc:description>
            <xsl:attribute name="from_marc_field"><xsl:value-of select="@tag" />a</xsl:attribute>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>





    <!-- JAS: 300a belongs in dcterms:extent (strip ending subfield punctuation)  -->
    <!-- JAS: 440/830 should be expressed somewhere,
			it could belong in dcterms:isPartOf  but the latest information from the DCMI abstract model
			specifies that relation term refinements are intended to be used for non-literals 
			(it should point to another resource) -->
    <xsl:template match="marc:datafield[@tag=600]">
        <dc:subject from_marc_field="600abcdq">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=610]">
        <dc:subject from_marc_field="610abcdq">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=611]">
        <dc:subject from_marc_field="611abcdq">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=630]">
        <dc:subject from_marc_field="630abcdq">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>
    <!-- JAS: subfields abx
		Subfield y in dcterms:temporal
		subfield z in dcterms:spatial-->
    <xsl:template match="marc:datafield[@tag=650]">
        <dc:subject from_marc_field="650abcdq">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>
    <!-- JAS: field 651 was skipped; subfields az belong in dcterms:spatial  -->
    <xsl:template match="marc:datafield[@tag=653]">
        <dc:subject from_marc_field="653abcdq">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=082]">
        <dc:subject xsi:type="dcterms:DDC" from_marc_field="082">
            <xsl:value-of select="." />
        </dc:subject>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=050]">
        <dc:subject xsi:type="dcterms:LCC" from_marc_field="050">
            <xsl:value-of select="." />
        </dc:subject>
    </xsl:template>






    <!-- JAS: 662 belongs in dcterms:spatial -->
    <xsl:template match="marc:datafield[@tag=662]">
        <dc:coverage from_marc_field="662abcdefgh">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdefgh</xsl:with-param>
            </xsl:call-template>
        </dc:coverage>
    </xsl:template>
    <!-- JAS: skip 752 (one occurrence in GIAL data, and that was redundant with 260) -->
    <xsl:template match="marc:datafield[@tag=752]">
        <dc:coverage from_marc_field="752abcdfgh">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdfgh</xsl:with-param>
            </xsl:call-template>
        </dc:coverage>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=522]/marc:subfield[@code=a]">
        <dcterms:spatial from_marc_field="522a">
            <xsl:value-of select="." />
        </dcterms:spatial>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=650]/marc:subfield[@code=z]">
        <dcterms:spatial from_marc_field="650z">
            <xsl:value-of select="." />
        </dcterms:spatial>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=662]/marc:subfield[@code=a]">
        <dcterms:spatial from_marc_field="662a">
            <xsl:value-of select="." />
        </dcterms:spatial>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=651]/marc:subfield[@code=a]">
        <dcterms:spatial from_marc_field="651a">
            <xsl:value-of select="." />
        </dcterms:spatial>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=651]/marc:subfield[@code=z]">
        <dcterms:spatial from_marc_field="651z">
            <xsl:value-of select="." />
        </dcterms:spatial>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=033]/marc:subfield[@code=a]">
        <dcterms:temporal from_marc_field="033a">
            <xsl:value-of select="." />
        </dcterms:temporal>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=650]/marc:subfield[@code=y]">
        <dcterms:temporal from_marc_field="650y">
            <xsl:value-of select="." />
        </dcterms:temporal>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=651]/marc:subfield[@code=y]">
        <dcterms:temporal from_marc_field="651y">
            <xsl:value-of select="." />
        </dcterms:temporal>
    </xsl:template>




    <!-- JAS: skip 530 -->
    <xsl:template match="marc:datafield[@tag=530]">
        <dcterms:hasFormat from_marc_field="530">
            <xsl:value-of select="." />
        </dcterms:hasFormat>
    </xsl:template>
    <!--
    <xsl:template match="marc:datafield[@tag=760]|marc:datafield[@tag=762]|marc:datafield[@tag=765]|marc:datafield[@tag=767]|marc:datafield[@tag=770]|marc:datafield[@tag=772]|marc:datafield[@tag=773]|marc:datafield[@tag=774]|marc:datafield[@tag=775]|marc:datafield[@tag=776]|marc:datafield[@tag=777]|marc:datafield[@tag=780]|marc:datafield[@tag=785]|marc:datafield[@tag=786]|marc:datafield[@tag=787]">
        <dc:relation>
            <xsl:attribute name="from_marc_field"><xsl:value-of select="@tag" />ot</xsl:attribute>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ot</xsl:with-param>
            </xsl:call-template>
        </dc:relation>
    </xsl:template>
    -->
    <xsl:template match="marc:datafield[@tag=776]">
        <dcterms:hasFormat from_marc_tag="776nt">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:hasFormat>
        <dcterms:isFormatOf from_marc_tag="776nt">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:isFormatOf>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=530]/marc:subfield[@code=u]">
        <!-- or marc:datafield[@tag=776]/marc:subfield[@code=o] -->
        <dcterms:hasFormat xsi:type="dcterms:URI">
            <xsl:attribute name="from_marc_field"><xsl:value-of select="../@tag" /></xsl:attribute>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes"><xsl:value-of select="@code" /></xsl:with-param>
            </xsl:call-template>
        </dcterms:hasFormat>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=440 or @tag=490 or @tag=800 or @tag=810 or @tag=811 or @tag=830]">
        <dcterms:isPartOf>
            <xsl:attribute name="from_marc_field"><xsl:value-of select="@tag" /></xsl:attribute>
            <xsl:value-of select="." />
        </dcterms:isPartOf>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=760]">
        <dcterms:isPartOf from_marc_field="760nt">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:isPartOf>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=773]">
        <dcterms:isPartOf from_marc_field="773ntgq">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ntgq</xsl:with-param>
            </xsl:call-template>
        </dcterms:isPartOf>
        <dcterms:isPartOf from_marc_field="773o" xsi:type="dcterms:URI">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">o</xsl:with-param>
            </xsl:call-template>
        </dcterms:isPartOf>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag=510]">
        <dcterms:isReferencedBy from_marc_field="510">
            <xsl:value-of select="." />
        </dcterms:isReferencedBy>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=785]">
        <dcterms:isReplacedBy from_marc_field="785nt">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:isReplacedBy>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=775]">
        <dcterms:isVersionOf from_marc_field="775">
            <xsl:value-of select="." />
        </dcterms:isVersionOf>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=780]">
        <dcterms:replaces from_marc_field="780nt">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:replaces>
        <xsl:if test="marc:subfield[@code=o]">
            <dcterms:replaces xsi:type="dcterms:URI" from_marc_field="780o">
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">o</xsl:with-param>
                </xsl:call-template>
            </dcterms:replaces>
        </xsl:if>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=538]">
        <dcterms:requires from_marc_field="538">
            <xsl:value-of select="." />
        </dcterms:requires>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=856]">
        <dc:identifier from_marc_field="856u">
            <xsl:value-of select="marc:subfield[@code='u']"/>
        </dc:identifier>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=020]">
        <dc:identifier from_marc_field="020a">
            <xsl:text>URN:ISBN:</xsl:text>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:identifier>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=506]">
        <dc:rights from_marc_field="506a">
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=540]">
        <dc:rights from_marc_field="540a">
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>



    <xsl:template match="marc:datafield">
        <!-- For any datafield that does not match a specific
            template, just do nothing -->
    </xsl:template>
</xsl:stylesheet>

<!-- Stylus Studio meta-information - (c) 2004-2005. Progress Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\..\..\..\..\..\..\..\..\..\javadev4\testsets\diacriticu8.xml" htmlbaseurl="" outputurl="" processortype="internal" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator=""/></scenarios><MapperMetaTag><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/><MapperBlockPosition></MapperBlockPosition><TemplateContext></TemplateContext><MapperFilter side="source"></MapperFilter></MapperMetaTag>
</metaInformation>
--><!-- Stylus Studio meta-information - (c)1998-2002 eXcelon Corp.
<metaInformation>
<scenarios/><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->
