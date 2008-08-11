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
        <olac:olac>
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
            <xsl:apply-templates select="marc:datafield"/>
        </olac:olac>
    </xsl:template>



    <!-- JAS: We probably want additional title fields 242, possibly 130, 240
			Subfields fghk belong in other QDC fields (fg are dates, h is format, k is like type and probably better dealt with through the leader  -->
    <xsl:template match="marc:datafield[@tag=245]">
        <dc:title from_marc_field="245abfghk">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abfghk</xsl:with-param>
            </xsl:call-template>
        </dc:title>
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
                    <xsl:when test="fn:match($leader6,'[atefcdijkgrmp]')">leader6</xsl:when>

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



    <!-- JAS: 260c in QDC could be dcterms:issued  -->
    <xsl:template
        match="marc:datafield[@tag=260]/marc:subfield[@code='c']">
        <dc:date from_marc_field="260c">
            <xsl:value-of select="."/>
        </dc:date>
    </xsl:template>




    <xsl:template name="process-Language">
        <xsl:param name="controlField008"/>
        <!-- JAS: prefer 041 and parse, or 590  -->
        <dc:language from_marc_field="leader?008">
            <xsl:value-of select="substring($controlField008,36,3)"/>
        </dc:language>
    </xsl:template>




    <!--	<xsl:template match="marc:datafield[@tag=856]/marc:subfield[@code='q']">
			<dc:format>
				<xsl:value-of select="."/>
			</dc:format>
		</xsl:template>-->
    <!--<xsl:template match="marc:datafield[@tag=520]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:template>-->
    <!--<xsl:template match="marc:datafield[@tag=521]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:template>-->




    <!-- JAS: 505 could be put in dcterms:tableOfContents; these are common in GIAL data  -->
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




    <!-- JAS: skip 530 -->
    <xsl:template match="marc:datafield[@tag=530]">
        <dc:relation type="original" from_marc_field="530abcdu">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdu</xsl:with-param>
            </xsl:call-template>
        </dc:relation>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=760]|marc:datafield[@tag=762]|marc:datafield[@tag=765]|marc:datafield[@tag=767]|marc:datafield[@tag=770]|marc:datafield[@tag=772]|marc:datafield[@tag=773]|marc:datafield[@tag=774]|marc:datafield[@tag=775]|marc:datafield[@tag=776]|marc:datafield[@tag=777]|marc:datafield[@tag=780]|marc:datafield[@tag=785]|marc:datafield[@tag=786]|marc:datafield[@tag=787]">
        <dc:relation>
            <xsl:attribute name="from_marc_field"><xsl:value-of select="@tag" />ot</xsl:attribute>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ot</xsl:with-param>
            </xsl:call-template>
        </dc:relation>
    </xsl:template>




    <xsl:template match="marc:controlfield[@tag=001]">
        <dc:identifier from_marc_field="001">
            Accession: <xsl:value-of select="."/>
        </dc:identifier>
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
