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
    <xsl:param name="show-source">yes</xsl:param>
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
        <olac:olac xsi:schemaLocation=" http://purl.org/dc/elements/1.1/    http://www.language-archives.org/OLAC/1.1/dc.xsd    http://purl.org/dc/terms/    http://www.language-archives.org/OLAC/1.1/dcterms.xsd    http://www.language-archives.org/OLAC/1.1/    http://www.language-archives.org/OLAC/1.1/olac.xsd    http://www.compuling.net/projects/olac/    http://www.language-archives.org/OLAC/1.1/third-party/software.xsd ">
           <xsl:apply-templates select="marc:leader"/>
           <xsl:apply-templates select="marc:controlfield"/>
           <xsl:apply-templates select="marc:datafield"/>
        </olac:olac>
    </xsl:template>

   <xsl:template match="marc:controlfield">
      <!-- Ignore if it did not match a more specific template -->
   </xsl:template>
   
   <xsl:template name="show-source">
      <xsl:param name="subfield"></xsl:param><!-- Optional parameter -->
      <xsl:if test="$show-source='yes'">
         <xsl:attribute name="from">
            <xsl:choose>
               <xsl:when test="self::marc:leader">leader</xsl:when>
               <xsl:otherwise><xsl:value-of select="@tag"/></xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$subfield"/>
         </xsl:attribute>
      </xsl:if>
   </xsl:template>



   <!-- Get the DCMI-Type out of the leader -->  
   <xsl:template match="marc:leader">
      <xsl:variable name="leader6"
         select="substring( . ,7,1)"/>
      <xsl:variable name="leader7"
         select="substring( . ,8,1)"/>
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
   <xsl:template match="marc:controlfield[@tag=001]">
      <dc:identifier>
         <xsl:call-template name="show-source"/>
         <xsl:value-of select="."/>
      </dc:identifier>
   </xsl:template>
   
   <xsl:template match="marc:controlfield[@tag=008]">
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
   


    <xsl:template match="marc:datafield[@tag=020]">
        <dc:identifier from_marc_field="020a">
            <xsl:text>URN:ISBN:</xsl:text>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:identifier>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag=033]/marc:subfield[@code=a]">
        <dcterms:temporal from_marc_field="033a">
            <xsl:value-of select="." />
        </dcterms:temporal>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=050]">
        <dc:subject xsi:type="dcterms:LCC" from_marc_field="050">
            <xsl:value-of select="." />
        </dc:subject>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=082]">
        <dc:subject xsi:type="dcterms:DDC" from_marc_field="082">
            <xsl:value-of select="." />
        </dc:subject>
    </xsl:template>




    <!-- JAS: OLAC prefers contributor to creator
		Subfields abcdq have name information
		e4 contain role information
		omit other subfields -->
    <xsl:template
        match="marc:datafield[@tag=100]">
        <dc:creator from_marc_field="100">
            <!-- GFS: I added the normalize-space which takes out all
                the extraneous white space, but this still isn't the
                right answer. The LOC sample has a 700 field with 3
                subfields, and this just concatenates together the
                content of all the subfields.  Need to add logic for
                the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:creator>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
		Subfields abcdq have name information
		e4 contain role information
		omit other subfields -->
    <xsl:template
        match="marc:datafield[@tag=110]">
        <dc:creator from_marc_field="110">
            <!-- GFS: I added the normalize-space which takes out all
                the extraneous white space, but this still isn't the
                right answer. The LOC sample has a 700 field with 3
                subfields, and this just concatenates together the
                content of all the subfields.  Need to add logic for
                the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:creator>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
		Subfields abcdq have name information
		e4 contain role information
		omit other subfields -->
    <xsl:template
        match="marc:datafield[@tag=111]">
        <dc:creator from_marc_field="111">
            <!-- GFS: I added the normalize-space which takes out all
                the extraneous white space, but this still isn't the
                right answer. The LOC sample has a 700 field with 3
                subfields, and this just concatenates together the
                content of all the subfields.  Need to add logic for
                the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:creator>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=130]">
        <dc:alternative from_marc_field="130">
            <xsl:value-of select="." />
        </dc:alternative>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=210]">
        <dc:alternative from_marc_field="210">
            <xsl:value-of select="." />
        </dc:alternative>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=240]">
        <dc:alternative from_marc_field="240">
            <xsl:value-of select="." />
        </dc:alternative>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=242]">
        <dc:alternative from_marc_field="242">
            <xsl:value-of select="." />
        </dc:alternative>
    </xsl:template>




    <!-- JAS: We probably want additional title fields 242, possibly 130, 240
			Subfields fghk belong in other QDC fields (fg are dates, h is format, k is like type and probably better dealt with through the leader  -->
    <xsl:template match="marc:datafield[@tag=245]">
        <dc:title from_marc_field="245">
            <xsl:value-of select="." />
        </dc:title>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=246]">
        <dc:alternative from_marc_field="246">
            <xsl:value-of select="." />
        </dc:alternative>
    </xsl:template>





    <xsl:template match="marc:datafield[@tag=260]">
        <dc:publisher from_marc_field="260ab">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </dc:publisher>
        <dcterms:dateCopyrighted from_marc_field="260c">
            <xsl:value-of select="marc:subfield[@code=c]"/>
        </dcterms:dateCopyrighted>
        <dcterms:issued from_marc_field="260c">
            <xsl:value-of select="marc:subfield[@code=c]"/>
        </dcterms:issued>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=300]/marc:subfield[@code='a']">
        <dcterms:extent from_marc_field="300a">
            <xsl:value-of select="."/>
        </dcterms:extent>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=310]/marc:subfield[@code=a]">
        <dcterms:accrualPeriodicity from_marc_field="310a">
            <xsl:value-of select="." />
        </dcterms:accrualPeriodicity>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=440]">
        <dcterms:isPartOf from_marc_field="440">
            <xsl:value-of select="." />
        </dcterms:isPartOf>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=490]">
        <dcterms:isPartOf from_marc_field="490">
            <xsl:value-of select="." />
        </dcterms:isPartOf>
    </xsl:template>




    <!-- All 5xx tags must be included within this template declaration -->
    <xsl:template match="marc:datafield[starts-with(@tag,'5')]">
        <xsl:choose>
           <xsl:when test="@tag = 500"></xsl:when>

        <xsl:otherwise>
            <dc:description>
                <xsl:value-of select="." />
            </dc:description>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- cjh: is there a way to implement this with "cascading" templates, such that we could define a template that partially matches the datafield,
    i.e. 5xx and then provide further selections for individual mar tags, as well as a default case to cover all 5xx tags not specifically mentioned? -->
    <xsl:template match="marc:datafield[500&lt;= @tag and @tag&lt;= 599 ][not(@tag=506 or @tag=530 or @tag=540 or @tag=546)]">
        <dc:description>
            <xsl:attribute name="from_marc_field"><xsl:value-of select="@tag" />a</xsl:attribute>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:description>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=500]">
        <dc:description from_marc_field="500">
            <xsl:value-of select="." />
        </dc:description>
    </xsl:template>





    <xsl:template match="marc:datafield[@tag=502]">
        <dc:description from_marc_field="500">
            <xsl:value-of select="." />
        </dc:description>
    </xsl:template>





    <xsl:template match="marc:datafield[@tag=514]">
        <dc:description from_marc_field="500">
            <xsl:value-of select="." />
        </dc:description>
    </xsl:template>





    <xsl:template match="marc:datafield[@tag=518]">
        <dc:description from_marc_field="500">
            <xsl:value-of select="." />
        </dc:description>
    </xsl:template>





    <xsl:template match="marc:datafield[@tag=500 or @tag=502 or @tag=514 or @tag=518]">
        <dc:description>
            <xsl:attribute name="from_marc_field"><xsl:value-of select="@tag" /></xsl:attribute>
            <xsl:value-of select="." />
        </dc:description>
    </xsl:template>





    <xsl:template match="marc:datafield[@tag=505]">
        <dcterms:tableOfContents from_marc_field="505">
            <xsl:value-of select="." />
        </dcterms:tableOfContents>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=506]">
        <dc:rights from_marc_field="506a">
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=510]">
        <dcterms:isReferencedBy from_marc_field="510">
            <xsl:value-of select="." />
        </dcterms:isReferencedBy>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=520][@ind1='' or @ind1=' ' or @ind2=3]">
        <dcterms:abstract from_marc_field="520">
            <xsl:value-of select="."/>
        </dcterms:abstract>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=521]/marc:subfield[@code=a]">
        <dcterms:audience from_marc_field="521a">
            <xsl:value-of select="." />
        </dcterms:audience>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=522]/marc:subfield[@code=a]">
        <dcterms:spatial from_marc_field="522a">
            <xsl:value-of select="." />
        </dcterms:spatial>
    </xsl:template>



    <!-- JAS: skip 530 -->
    <xsl:template match="marc:datafield[@tag=530]">
        <dcterms:hasFormat from_marc_field="530">
            <xsl:value-of select="." />
        </dcterms:hasFormat>
        <dcterms:hasFormat from_marc_field="530u" xsi:type="dcterms:URI">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">u</xsl:with-param>
            </xsl:call-template>
        </dcterms:hasFormat>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=533]">
        <dcterms:extent from_marc_field="533ae">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ae</xsl:with-param>
            </xsl:call-template>
        </dcterms:extent>
        <dcterms:medium from_marc_field="533a">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">a</xsl:with-param>
            </xsl:call-template>
        </dcterms:medium>
        <dcterms:created from_marc_field="533d">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">d</xsl:with-param>
            </xsl:call-template>
        </dcterms:created>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=538]">
        <dcterms:requires from_marc_field="538">
            <xsl:value-of select="." />
        </dcterms:requires>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=540]">
        <dc:rights from_marc_field="540a">
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:rights>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag=541]/marc:subfield[@code=c]">
        <dcterms:accrualMethod from_marc_field="541c">
            <xsl:value-of select="." />
        </dcterms:accrualMethod>
    </xsl:template>


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
        <dcterms:temporal from_marc_field="650y">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">y</xsl:with-param>
            </xsl:call-template>
        </dcterms:temporal>
        <dcterms:spatial from_marc_field="650z">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">z</xsl:with-param>
            </xsl:call-template>
        </dcterms:spatial>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=651]">
        <dcterms:spatial from_marc_field="651az">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">az</xsl:with-param>
            </xsl:call-template>
        </dcterms:spatial>
        <dcterms:temporal from_marc_field="651y">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">y</xsl:with-param>
            </xsl:call-template>
        </dcterms:temporal>
    </xsl:template>



    <!-- JAS: field 651 was skipped; subfields az belong in dcterms:spatial  -->
    <xsl:template match="marc:datafield[@tag=653]">
        <dc:subject from_marc_field="653abcdq">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:subject>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=655]">
        <dc:type from_marc_field="655">
            <xsl:value-of select="."/>
        </dc:type>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag=662]/marc:subfield[@code=a]">
    </xsl:template>

    <!-- JAS: 662 belongs in dcterms:spatial -->
    <xsl:template match="marc:datafield[@tag=662]">
        <dc:coverage from_marc_field="662abcdefgh">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdefgh</xsl:with-param>
            </xsl:call-template>
        </dc:coverage>
        <dcterms:spatial from_marc_field="662a">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">a</xsl:with-param>
            </xsl:call-template>
        </dcterms:spatial>
    </xsl:template>




    <!-- JAS: OLAC prefers contributor to creator
		Subfields abcdq have name information
		e4 contain role information
		omit other subfields -->
    <xsl:template
        match="marc:datafield[@tag=700]">
        <dc:creator from_marc_field="700">
            <!-- GFS: I added the normalize-space which takes out all
                the extraneous white space, but this still isn't the
                right answer. The LOC sample has a 700 field with 3
                subfields, and this just concatenates together the
                content of all the subfields.  Need to add logic for
                the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:creator>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
		Subfields abcdq have name information
		e4 contain role information
		omit other subfields -->
    <xsl:template
        match="marc:datafield[@tag=710]">
        <dc:creator from_marc_field="710">
            <!-- GFS: I added the normalize-space which takes out all
                the extraneous white space, but this still isn't the
                right answer. The LOC sample has a 700 field with 3
                subfields, and this just concatenates together the
                content of all the subfields.  Need to add logic for
                the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:creator>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
		Subfields abcdq have name information
		e4 contain role information
		omit other subfields -->
    <xsl:template
        match="marc:datafield[@tag=711]">
        <dc:creator from_marc_field="711">
            <!-- GFS: I added the normalize-space which takes out all
                the extraneous white space, but this still isn't the
                right answer. The LOC sample has a 700 field with 3
                subfields, and this just concatenates together the
                content of all the subfields.  Need to add logic for
                the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:creator>
    </xsl:template>



    <!-- JAS: OLAC prefers contributor to creator
		Subfields abcdq have name information
		e4 contain role information
		omit other subfields -->
    <xsl:template
        match="marc:datafield[@tag=720]">
        <dc:creator from_marc_field="720">
            <!-- GFS: I added the normalize-space which takes out all
                the extraneous white space, but this still isn't the
                right answer. The LOC sample has a 700 field with 3
                subfields, and this just concatenates together the
                content of all the subfields.  Need to add logic for
                the subfields. -->
            <xsl:value-of select="normalize-space(.)"/>
        </dc:creator>
    </xsl:template>






    <xsl:template match="marc:datafield[@tag=730]">
        <dc:alternative from_marc_field="730">
            <xsl:value-of select="." />
        </dc:alternative>
    </xsl:template>



    <!-- JAS: skip 752 (one occurrence in GIAL data, and that was redundant with 260) -->
    <xsl:template match="marc:datafield[@tag=752]">
        <dc:coverage from_marc_field="752abcdfgh">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdfgh</xsl:with-param>
            </xsl:call-template>
        </dc:coverage>
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




    <xsl:template match="marc:datafield[@tag=775]">
        <dcterms:isVersionOf from_marc_field="775">
            <xsl:value-of select="." />
        </dcterms:isVersionOf>
    </xsl:template>



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




    <xsl:template match="marc:datafield[@tag=785]">
        <dcterms:isReplacedBy from_marc_field="785nt">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">nt</xsl:with-param>
            </xsl:call-template>
        </dcterms:isReplacedBy>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=800]">
        <dcterms:isPartOf from_marc_field="800">
            <xsl:value-of select="." />
        </dcterms:isPartOf>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=810]">
        <dcterms:isPartOf from_marc_field="810">
            <xsl:value-of select="." />
        </dcterms:isPartOf>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=811]">
        <dcterms:isPartOf from_marc_field="811">
            <xsl:value-of select="." />
        </dcterms:isPartOf>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag=830]">
        <dcterms:isPartOf from_marc_field="830">
            <xsl:value-of select="." />
        </dcterms:isPartOf>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=856]/marc:subfield[@code='q']">
        <dcterms:medium xsi:type="dcterms:IMT" from_marc_field="856q">
            <xsl:value-of select="." />
        </dcterms:medium>
        <dc:identifier from_marc_field="856u">
            <xsl:value-of select="marc:subfield[@code='u']"/>
        </dc:identifier>
    </xsl:template>


























    <!-- cjh: why is this commented out? -->
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


    <xsl:template match="marc:datafield">
        <!-- For any datafield that does not match a specific
            template, just do nothing -->
    </xsl:template>
</xsl:stylesheet>
