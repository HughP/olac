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

    <xsl:template name="process-role">
        <!-- process MARC relator codes into OLAC roles -->
        <xsl:param name="subfield"/>
        <!-- required param -->
        <xsl:if test="marc:subfield[@code=$subfield]">
            <xsl:variable name="code">
                <xsl:value-of select="marc:subfield[@code=$subfield]"/>
            </xsl:variable>
            <xsl:attribute name="olac:code">
                <xsl:choose>
                    <xsl:when test="$code = 'ann'">annotator</xsl:when>
                    <xsl:when test="$code = 'cwt'">annotator</xsl:when>
                    <xsl:when test="$code = 'aut'">author</xsl:when>
                    <xsl:when test="$code = 'aud'">author</xsl:when>
                    <xsl:when test="$code = 'lyr'">author</xsl:when>
                    <xsl:when test="$code = 'col'">compiler</xsl:when>
                    <xsl:when test="$code = 'com'">compiler</xsl:when>
                    <xsl:when test="$code = 'csl'">consultant</xsl:when>
                    <xsl:when test="$code = 'csp'">consultant</xsl:when>
                    <xsl:when test="$code = 'sad'">consultant</xsl:when>
                    <xsl:when test="$code = 'mrk'">data_inputter</xsl:when>
                    <xsl:when test="$code = 'dpt'">depositor</xsl:when>
                    <xsl:when test="$code = 'prg'">developer</xsl:when>
                    <xsl:when test="$code = 'edt'">editor</xsl:when>
                    <xsl:when test="$code = 'flm'">editor</xsl:when>
                    <xsl:when test="$code = 'ill'">illustrator</xsl:when>
                    <xsl:when test="$code = 'ivr'">interviewer</xsl:when>
                    <xsl:when test="$code = 'act'">performer</xsl:when>
                    <xsl:when test="$code = 'dnc'">performer</xsl:when>
                    <xsl:when test="$code = 'itr'">performer</xsl:when>
                    <xsl:when test="$code = 'mus'">performer</xsl:when>
                    <xsl:when test="$code = 'prf'">performer</xsl:when>
                    <xsl:when test="$code = 'ppt'">performer</xsl:when>
                    <xsl:when test="$code = 'stl'">performer</xsl:when>
                    <xsl:when test="$code = 'pht'">photographer</xsl:when>
                    <xsl:when test="$code = 'rce'">recorder</xsl:when>
                    <xsl:when test="$code = 'vdg'">recorder</xsl:when>
                    <xsl:when test="$code = 'rth'">researcher</xsl:when>
                    <xsl:when test="$code = 'rtm'">researcher</xsl:when>
                    <xsl:when test="$code = 'res'">researcher</xsl:when>
                    <xsl:when test="$code = 'sgn'">signer</xsl:when>
                    <xsl:when test="$code = 'sng'">singer</xsl:when>
                    <xsl:when test="$code = 'voc'">singer</xsl:when>
                    <xsl:when test="$code = 'nrt'">speaker</xsl:when>
                    <xsl:when test="$code = 'spk'">speaker</xsl:when>
                    <xsl:when test="$code = 'fnd'">sponsor</xsl:when>
                    <xsl:when test="$code = 'pat'">sponsor</xsl:when>
                    <xsl:when test="$code = 'spn'">sponsor</xsl:when>
                    <xsl:when test="$code = 'trc'">transcriber</xsl:when>
                    <xsl:when test="$code = 'trl'">translator</xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="@olac:code">
                <!-- output xsi:type  only if olac:code exists -->
                <xsl:attribute name="xsi:type">olac:role</xsl:attribute>
            </xsl:if>
        </xsl:if>
    </xsl:template>


    <xsl:template name="process-linguistic-type">
        <!-- process LCSH into OLAC linguistic types -->
        <xsl:param name="subject"/>
        <!-- required param -->

        <xsl:variable name="linguistictype">
            <!-- TODO: fn:contains() is probably not the best here.  We may be getting false positives.  See id: 28085
                JAS: use only the $x subfield instances. That avoids Grammar as a main topic ("Grammar, comparative and general")
                Morphology appears only in $x whether it is a general work (i.e., with Grammar, comparative and general
                as the $a content) or a work on the morphology of a language.
                However, any one of these appearing in $x when there is also "{some} language" in the same 650 in the 
                $a, we are on firm ground to take the work as a language description. 
            --> 
            <xsl:choose>
                <!-- type = language_description -->
                <xsl:when test="contains($subject,'Grammar')">language_description</xsl:when>
                <xsl:when test="contains($subject,'Phonology')">language_description</xsl:when>
                <xsl:when test="contains($subject,'Morphology')">language_description</xsl:when>
                <xsl:when test="contains($subject,'Orthography')">language_description</xsl:when>

                <!-- type = lexicon
                JAS: The dictionaries and phrase books should be identifiable through finding the right set word or phrase 
                         only in the $v subfield
                         Dictionaries
                         Conversation and phrase books
                         Glossaries, vocabularies, etc.
                -->
                <xsl:when test="contains($subject,'Dictionaries')">lexicon</xsl:when>

                <!-- type = primary_text -->
                <!-- what should we search for here? 
                    JAS: $vTexts
                -->
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="$linguistictype != '0'">
            <!-- output xsi:type only if a linguistic-type has been found -->
            <dc:type xsi:type="olac:linguistic-type">
                <xsl:attribute name="olac:code">
                    <xsl:value-of select="$linguistictype"/>
                </xsl:attribute>
            </dc:type>
        </xsl:if>
    </xsl:template>


    <!-- Get the DCMI-Type out of the leader -->
    <xsl:template match="marc:leader">
        <xsl:variable name="leader6" select="substring( . ,7,1)"/>
        <xsl:variable name="leader7" select="substring( . ,8,1)"/>
        <xsl:if test="$leader7='c' or $leader7='s'">
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
                vocabulary; e.g. should be uppercase? 
                JAS: these are the MARC terms; cartographic should be mapped to StillImage, 
                three dimensional object to PhysicalObject, etc.-->
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

    <!-- CJH: in our GIAL dataset, the 001 stores the internal ID which is specific to destiny.  
        I have confirmed with the librarian that the 001 is persistent as long as we are using the Destiny ILS.  
        The 035 stores a string containing the barcode of the first item under this record... which we won't be using at this point -->
    <xsl:template match="marc:controlfield[@tag='001']">
        <dc:identifier>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:identifier>
    </xsl:template>

    <xsl:template match="marc:controlfield[@tag='008']">
        <!-- Process the language field -->
        <!-- JAS: prefer 041 and parse, or 590  
        Must repent of believing the librarian: GIAL data has 1501 records with 094 tags
        probably 13th or 14th ed. Ethnologue -->
        <dc:language xsi:type="olac:language">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">-36</xsl:with-param>
            </xsl:call-template>
            <xsl:attribute name="olac:code">
                <xsl:value-of select="substring( . ,36,3)"/>
            </xsl:attribute>
        </dc:language>

        <!-- CJH: Question??? JAS: The correct interpretation of 008/07-10 depends on the coding of 008/06 
            and should include 008/11-14 in some cases. How much detail should we attempt?
            06 - Type of date/Publication status 
            b - No dates given; B.C. date involved 
            c - Continuing resource currently published 
            d - Continuing resource ceased publication 
            e - Detailed date 
            i - Inclusive dates of collection 
            k - Range of years of bulk of collection 
            m - Multiple dates 
            n - Dates unknown 
            p - Date of distribution/release/issue and production/recording session when different 
            q - Questionable date 
            r - Reprint/reissue date and original date 
            s - Single known date/probable date 
            t - Publication date and copyright date 
            u - Continuing resource status unknown 
            
            b unlikely; c d u eliminated (as applying only to journals); 
            e - detailed date typically used as creation date with manuscripts; cdterms:created
            i k -  creation date range
            p - dcterms:issued (07-10) and dcterms:created (11-14)
            r - dcterms:issued (07-10) and dc:date (11-14)
            s - dcterms:issued (07-10)
            t - dcterms:issued (07-10) and dcterms:dateCopyrighted (11-14)
            
            Or just only take whatever is here for these (e i k p r s t) and put in plain vanilla dc:date
        -->
        <dcterms:issued> </dcterms:issued>
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



    <!-- JAS: Note: Some 255 information equivalent to DC encoding scheme but different syntax. -->
    <!-- JAS: Note: Only worthwhile if 034$defg or $jkmn or 255$c are present; subfield a is often present 
        without data, as 255$a "scale not given" sometimes with a projection in $b. Rank 1 (if contains useful data) -->
    <!-- CJH: Question? Is this right? -->
    <!-- JAS: retain defg, but not jkmn (which are for celestial charts). I missed that before.
            Do we want to put them into the Box schema ? (I know this syntax isn't right) 
            <dcterms:spatial xsi:type="dcterms:Box">westlimit={$d}; eastlimit={$e}; northlimit={$f}; southlimit={$g};
            </dcterms:spatial>
            
            The info from $abc can be better obtained from 255 as Description
    -->
    <xsl:template match="marc:datafield[@tag='034']">
        <dcterms:spatial>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">defgjkmn</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">defgjkmn</xsl:with-param>
            </xsl:call-template>
        </dcterms:spatial>
    </xsl:template>



    <!-- JAS: Does this deal with the presence of multiple code elements in a single $a? -->

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




    <xsl:template match="marc:datafield[@tag='043']">
        <dcterms:spatial xsi:type="dcterms:ISO3166">
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">c</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='c']"/>
        </dcterms:spatial>
    </xsl:template>





    <xsl:template match="marc:datafield[@tag='046']">
        <!-- JAS: All the dates and date ranges in 046 should be ignored if the code in 046$a = “x” (indicating Incorrect dates) 
        I am inclined to dismiss this field altogether, preferring the leader info, 260c or nothing
        GIAL data in this field are all erroneous; should be 040s or 041s -->
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



    <xsl:template match="marc:datafield[@tag='060']">
        <dc:subject xsi:type="dcterms:NLM">
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:subject>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='080']">
        <dc:subject xsi:type="dcterms:UDC">
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




    <xsl:template match="marc:datafield[@tag='100']">
        <dc:contributor>
            <xsl:call-template name="process-role">
                <xsl:with-param name="subfield">e</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdeq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:contributor>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='110']">
        <dc:contributor>
            <xsl:call-template name="process-role">
                <xsl:with-param name="subfield">e</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdeq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:contributor>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='111']">
        <dc:contributor>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">e</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='e']"/>
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
        Subfields fghk belong in other QDC fields (fg are dates, h is format, k is like type and 
        probably better dealt with through the leader  -->
    



    <!-- JAS: Should capture 245abnp -->
    <xsl:template match="marc:datafield[@tag='245']">
        <dc:title>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dc:title>
    </xsl:template>




    <!-- JAS: Should capture 246abnp but not fghi-->
    <xsl:template match="marc:datafield[@tag='246']">
        <dc:alternative>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:alternative>
    </xsl:template>



    <!-- JAS: Note: Some 255 information equivalent to DC encoding scheme but different syntax. -->
    <!-- JAS: Note: Only worthwhile if 034$defg or $jkmn or 255$c are present; subfield a is often 
        present without data, as 255$a "scale not given" sometimes with a projection in $b. 
        If only $a + b present, then this belongs better in Description. If $c is present, the same data ought to be in 034
        also, as these are supposed to be paired. So maybe skip c. -->
    <xsl:template match="marc:datafield[@tag='255']">
        <dcterms:spatial>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">c</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">c</xsl:with-param>
            </xsl:call-template>
        </dcterms:spatial>
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
        <!-- if “c”  precedes date (e.g. c1999) 
            JAS: also need to remove the "c" that is contained as the first character of the subfield content. 
            Should this be handled as a Choose ?-->
        <xsl:if test="substring(marc:subfield[@code='c'],1,1) = 'c'">
            <dcterms:dateCopyrighted>
                <xsl:call-template name="show-source">
                    <xsl:with-param name="subfield">c</xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="marc:subfield[@code='c']"/>
            </dcterms:dateCopyrighted>
        </xsl:if>
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


    
    <!-- JAS: I think this can be skipped. We had tentatively concluded that we will not include Serials records. -->
    <xsl:template match="marc:datafield[@tag=310]">
        <dcterms:accrualPeriodicity>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dcterms:accrualPeriodicity>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag=340]">
        <dcterms:medium>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dcterms:medium>
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




    <!-- Default rule for 5xx tags when no other 5xx tag is matched by following rules 
        JAS: I think we can select the Notes fields that interest us, and omit the remainder. 
        So we should not need a generic 5xx match. -->
    <xsl:template match="marc:datafield[starts-with(@tag,'5')]" priority="0.5">
        <dc:description>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>

    <!-- All 5xx templates much have a priority=1 so that it does not conflict with the above catch-all rule -->

    <!-- JAS: no specific label with this tag. -->
    <xsl:template priority="1" match="marc:datafield[@tag='500']">
        <dc:description>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>




    <!-- JAS:  label: Dissertation note: -->
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




    <!-- cjh Note: I skipped putting in logic for dcterms:accessRights because it seems too complicated and 
        I'm not sure if it's worth it 
    JAS: agreed -->
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



    <!-- JAS:  label: Data quality:  -->
    <xsl:template priority="1" match="marc:datafield[@tag='514']">
        <dc:description>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>




    <!-- JAS:  label: Event details  -->
    <xsl:template priority="1" match="marc:datafield[@tag='518']">
        <dc:description>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:description>
    </xsl:template>


    <!-- JAS: Should this be testing whether @ind1='3' ? Indicator 2 is undefined -->
    <xsl:template priority="1"
        match="marc:datafield[@tag='520'][@ind1='' or @ind1=' ' or @ind2='3']">
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




    <xsl:template priority="1" match="marc:datafield[@tag=524]">
        <dcterms:bibliographicCitation>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">a</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </dcterms:bibliographicCitation>
    </xsl:template>




    <!-- JAS: skip 530 -->
    <!-- CJH: Question: Why skip this one?
        JAS: If there is a 530 and also a 776, which is preferred? See record example 28091 
        In that record, the 776 actually contains more info desired,
        where this note simply states the thing exists This could be very inconsistent among different libraries.-->
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
        <!-- JAS: I wonder if dcterms:created is misleading here, as usually pertaining to when the intellectual
            content is created (that is the usual OLAC interpretation, whereas this date relates to 
            when the reproduction was made. There is no good refinement that fits this need. -->
        <dcterms:created>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">d</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">d</xsl:with-param>
            </xsl:call-template>
        </dcterms:created>
    </xsl:template>



    <!-- JAS: considering the usual content of this field, dcterms:requires is probably not a good choice. Should be, but isn't
        538 ##$aData in extended ASCII character set.  
        538 ##$aWritten in FORTRAN H with 1.5K source program statements.  
        538 ##$aSystem requirements: IBM 360 and 370; 9K bytes of internal memory; OS SVS and OSMVS.  
        538 ##$aDisk characteristics: Disk is single sided, double density, soft sectored.  
        538 ##$aVHS.  
        538 ##$aMode of access: Electronic mail via Internet and BITNET; also available via FTP.  
        538 ##$aMode of access: Internet.  
        
    Not sure what would be the best label, lacking a refinement term -->
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



    <!-- JAS: skip -->
    <xsl:template priority="1" match="marc:datafield[@tag=541]">
        <dcterms:accrualMethod>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">c</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='c']"/>
        </dcterms:accrualMethod>
    </xsl:template>



    <!-- JAS: there is no 542 -->
    <xsl:template priority="1" match="marc:datafield[@tag=542]">
        <dcterms:rightsHolder>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">d</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='d']"/>
        </dcterms:rightsHolder>
        <dcterms:dateCopyrighted>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">g</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='g']"/>
        </dcterms:dateCopyrighted>
    </xsl:template>



    <xsl:template priority="1" match="marc:datafield[@tag='561']">
        <dcterms:provenance>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:provenance>
    </xsl:template>



    <!-- JAS: GIAL_Marc_590sample1.mrc contains a sample set of records that includes the patterns
        found thus far with regard to use of 590. 
        patterns:
        =590  \\$aEthnologue 15 = ISO 639-3 bca (52 records of the whole set of 29000+ have this pattern)
        =590  \\$aarz Ethnologue 15 = ISO 639-3
        =590  \\$askl$2Ethnologue 15 = ISO 639-3
    -->
    <xsl:template priority="1" match="marc:datafield[@tag='590']">
        <xsl:if test="starts-with(marc:subfield[@code='2'],'Ethnologue 15')">
            <dc:subject xsi:type="olac:language">
                <xsl:call-template name="show-source">
                    <xsl:with-param name="subfield">a</xsl:with-param>
                </xsl:call-template>
                <xsl:attribute name="olac:code">
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </xsl:attribute>
            </dc:subject>
        </xsl:if>
    </xsl:template>


    <!-- cjh Question? We used to have subfieldSelect for 'abcdq' but I removed that to simplify.  
        Was that a good idea, since we may not want to include $y and $z in this field?  
    
        JAS: I think removing the subfield selection for 600, 610, 611, 630 is okay. We want the whole thing, and 
        most of them are so rare, we're better leaving them, incl the yz subfields, in this and not try to
        make coverage elements with these instances. -->
    <xsl:template match="marc:datafield[@tag='600']">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <dc:subject xsi:type="dcterms:LCSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
                <xsl:call-template name="process-linguistic-type">
                    <xsl:with-param name="subject">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@ind2='2'">
                <dc:subject xsi:type="dcterms:MeSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='610']">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <dc:subject xsi:type="dcterms:LCSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
                <xsl:call-template name="process-linguistic-type">
                    <xsl:with-param name="subject">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@ind2='2'">
                <dc:subject xsi:type="dcterms:MeSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>





    <xsl:template match="marc:datafield[@tag='611']">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <dc:subject xsi:type="dcterms:LCSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
                <xsl:call-template name="process-linguistic-type">
                    <xsl:with-param name="subject">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@ind2='2'">
                <dc:subject xsi:type="dcterms:MeSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='630']">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <dc:subject xsi:type="dcterms:LCSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
                <xsl:call-template name="process-linguistic-type">
                    <xsl:with-param name="subject">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@ind2='2'">
                <dc:subject xsi:type="dcterms:MeSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
            </xsl:when>
        </xsl:choose>
    </xsl:template>





    <!-- JAS: subfields abx
    Subfield y in dcterms:temporal
    subfield z in dcterms:spatial
    
    JAS (change): Take the whole of 650 and retain all subfields in the Subject element, but then also generate a separate Coverage 
        element (or refinement) for $y or $z -->
    <!-- cjh: Question?: does the LCSH content appear in a specific subfield?  I ask because we are
        selecting the entire tag in 650 for processing of linguistic-type but 650 also contains temporal and spatial information --> 
    <xsl:template match="marc:datafield[@tag='650']">
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <dc:subject xsi:type="dcterms:LCSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
                <xsl:call-template name="process-linguistic-type">
                    <xsl:with-param name="subject">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@ind2='2'">
                <dc:subject xsi:type="dcterms:MeSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="."/>
                </dc:subject>
            </xsl:when>
        </xsl:choose>
        
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




    <!-- TODO: Question? JAS: 651$a must be separated from 651$z, as these are usually two 
        different jurisdictions. See note below regarding term source. Rank 3 -->
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
        <xsl:if test="@ind2='7' and marc:subfield[@code='2'] = 'tgn'">
            <dcterms:spatial xsi:type="dcterms:TGN">
                <xsl:call-template name="show-source">
                    <xsl:with-param name="subfield">az</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">az</xsl:with-param>
                </xsl:call-template>
            </dcterms:spatial>
        </xsl:if>
    </xsl:template>



    <!-- TODO: Question? JAS: field 651 was skipped; subfields az belong in dcterms:spatial  -->
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


    <xsl:template match="marc:datafield[@tag='654']">
        <dc:subject>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:subject>
    </xsl:template>



    <!-- cjh Question?  Is the following correctly implemented?  Is the content for the dc:type element contained in 655a? -->
    <xsl:template match="marc:datafield[@tag='655']">
        <xsl:if test="marc:subfield[@code='2'] = 'dct'">
            <dc:type xsi:type="dcterms:DCMIType">
                <xsl:call-template name="show-source">
                    <xsl:with-param name="subfield">a</xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="marc:subfield[@code='a']"/>
            </dc:type>
        </xsl:if>
        <xsl:if test="@ind2 = '7' and marc:subfield[@code='2'] = 'tgn'">
            <dc:subject xsi:type="dcterms:TGN">
                <xsl:call-template name="show-source"/>
                <xsl:value-of select="."/>
            </dc:subject>
        </xsl:if>
    </xsl:template>



    <!-- JAS: 662 belongs in dcterms:spatial -->
    <!-- CJH: Question?: do we still need the dc:coverage tag as well? (might be left over from simple DC template) -->
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
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dcterms:spatial>
    </xsl:template>

    <!-- Default rule for 69x tags when no other 69x tag is matched by following rules -->
    <xsl:template match="marc:datafield[starts-with(@tag,'69')]" priority="0.5">
        <dc:subject>
            <xsl:call-template name="show-source"/>
            <xsl:value-of select="."/>
        </dc:subject>
    </xsl:template>


    <xsl:template match="marc:datafield[@tag='700']">
        <dc:contributor>
            <xsl:call-template name="process-role">
                <xsl:with-param name="subfield">e</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdeq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:contributor>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='710']">
        <dc:contributor>
            <xsl:call-template name="process-role">
                <xsl:with-param name="subfield">e</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcdeq</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdq</xsl:with-param>
            </xsl:call-template>
        </dc:contributor>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='711']">
        <dc:contributor>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">e</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="marc:subfield[@code='e']"/>
        </dc:contributor>
    </xsl:template>




    <xsl:template match="marc:datafield[@tag='720']">
        <dc:contributor>
            <xsl:call-template name="process-role">
                <xsl:with-param name="subfield">e</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="show-source">
                <xsl:with-param name="subfield">abcde</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcd</xsl:with-param>
            </xsl:call-template>
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




    <!-- JAS: 76x-78x $o is an identifier, but is not a URI type of identifier. 
        Not worth separating out the $o subfield in these cases
        GIAL has no instance of its use in this whole range of tags
    -->
    
    <!-- JAS:  Why select only $nt ? If from the simple DC mapping, I think we can throw out the suggestion.
        If I suggested, I cannot remember why. 
        I'll agree that not all are helpful, so I suggest retaining abcdgjknpqstz in the order they appear in the record (not here) -->
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



    <!-- The 856 may contain a reference to a digital form of the whole work, in which case Identifier is appropriate.
        Or it may contain a description, table of contents, book review, etc. of the item, available in digital form.
        The conventions used wrt this field may vary by library.
        For GIAL, it is predictable that:
        - If $3 is present, it is NOT the resource itself, but some description-like thing, and its content may be 
        used to determine the kind of thing. However, the phrasing is not totally consistent, and may be better used as 
        a label within a Description element (as discussed with the Notes and other description related MARC tags),
        rather than attempting to use it to determine which refinement term could be used (e.g., tableOfContents).
        - If $3 is not present, the $u subfield does link to a digital manifestation of the resource, 
        and the $q is generally present.
        -->
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
