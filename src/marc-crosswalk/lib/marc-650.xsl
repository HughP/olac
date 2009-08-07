<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:fn="http://www.w3.org/2005/xpath-functions"
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="xs"
      xmlns:dc="http://purl.org/dc/elements/1.1/" 
      xmlns:dcterms="http://purl.org/dc/terms/"
      xmlns:marc="http://www.loc.gov/MARC21/slim" 
      xmlns:oai="http://www.openarchives.org/OAI/2.0/"
      xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      version="2.0">

    <xsl:template match="marc:datafield[@tag='650']">
        <xsl:variable name="heading">
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdexyzv</xsl:with-param>
                <xsl:with-param name="delimiter">--</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <!-- Note that the analysis below of elements within subject
            headings is simply based on this assembled string. Whereas
            the subfield types ought to help, in practice they are not
            reliable since they are not applied consistently. E.g. the
            form subdivision is just as likely to appear in $x as $v. -->
        <!-- Also, everything will be mapped to lower-case for
            matching. This is to account for the possibility of
            different case conventions between libraries. -->
        
        <xsl:choose>
            <xsl:when test="@ind2='0'"><!-- LCSH -->
                
                <xsl:variable name="langCode">
                    <xsl:call-template name="assign-subject-language">
                        <xsl:with-param name="h" select="lower-case($heading)"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="typeCode">
                    <xsl:choose>
                        <xsl:when test="$langCode">
                            <xsl:call-template
                                name="assign-direct-type-for-language">
                                <xsl:with-param name="h" 
                                select="lower-case(substring-after($heading, '--'))"/>
                                <!-- This is an optimization to discard the 
                                    language name so that the matches
                                    do not have to scan over it. -->
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- There's probably a different lookup
                                for the case where there is no subject
                                language
                            -->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="fieldCode">
                    <xsl:choose>
                        <xsl:when test="$typeCode = 'language_lexicon'
                            or $typeCode = 'language_text'
                            or $typeCode = 'language_instruction'">
                            <!-- In these cases, do nothing since
                                there is not also a linguistic subject
                                field
                            -->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="assign-linguistic-field">
                                <xsl:with-param name="h" select="lower-case($heading)"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="inferredType">
                    <xsl:choose>
                        <xsl:when test="$langCode and $fieldCode">
                            <xsl:call-template
                                name="assign-inferred-type-for-language">
                                <xsl:with-param name="f" select="$fieldCode"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                    
                </xsl:variable>
                
                <dc:subject xsi:type="dcterms:LCSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="$heading"/>
                </dc:subject>
                <xsl:if test="$langCode">
                    <dc:subject xsi:type="olac:language"
                       olac:code="{$langCode}"/>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$typeCode">
                        <dc:type xsi:type="olac:resource-type"
                            olac:code="{$typeCode}"/>
                    </xsl:when>
                    <xsl:when test="$langCode">
                        
                        
                    </xsl:when>
                </xsl:choose>
                
                
            </xsl:when>
            <xsl:when test="@ind2='2'">
                <dc:subject xsi:type="dcterms:MESH">
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="$heading"/>
                </dc:subject>
            </xsl:when>
            <xsl:otherwise>
                <dc:subject>
                    <xsl:call-template name="show-source"/>
                    <xsl:value-of select="$heading"/>
                </dc:subject>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="assign-subject-language">
        <xsl:param name="h"/>
        <!-- Returns the ISO 639 code for the subject language.
             Returns nothing if there is no subject language.
        -->
        <xsl:if test="contains($h, 'language') or contains($h,
            'dialect')">
            <!-- This test is simply an optimization.  If the heading
                does not contain the string 'language' or 'dialect'
                then there is no use comparing against 4,000 names -->
        <!-- Use matches like 
                  <xsl:when test="starts-with($h, 'english language')">eng</xsl:when>
               For the historical languages, use something like:
               starts-with($sh, "english language—middle english")
               Note that these must come first to get longest-first
               match. Also, they need not include dates (since there
               seems to be some variation).
        -->
        </xsl:if>
    </xsl:template>

    <xsl:template name="assign-direct-type-for-language">
        <xsl:param name="h"/>
        <!-- The parameter is the rest of the subject heading
            following subfield $a of language name.
            Returns the OLAC code for the language resource type
            when it is known directly from matching a form
            subdivision.
            Returns nothing if a resource type is not directly
            matched. (It may still be inferred later.) 
        -->
        <!-- Use matches like
            <xsl:when test="contains($h, 'dictionaries')">language_lexicon</xsl:when>
        -->
    </xsl:template>
    
    <xsl:template name="assign-inferred-type-for-language">
        <xsl:param name="f"/>
        <!-- The parameter is the linguistic field code.
            Returns the OLAC code for the language resource type
            that can be inferred from that field code (since we
            already know that it is about a particular langauge).
        -->
        <xsl:choose>
            <xsl:when test="$f='morphology'">langauge_description</xsl:when>
            <xsl:when test="$f='phonetics'">langauge_description</xsl:when>
            <xsl:when test="$f='phonology'">langauge_description</xsl:when>
            <xsl:when test="$f='pragmatics'">langauge_description</xsl:when>
            <xsl:when test="$f='semantics'">langauge_description</xsl:when>
            <xsl:when test="$f='syntax'">langauge_description</xsl:when>
            <xsl:when test="$f='writing_systems'">langauge_description</xsl:when>
            <xsl:when test="$f='sociolinguistics'">langauge_situation</xsl:when>
            <xsl:otherwise>unclassified</xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="assign-linguistic-field">
        <xsl:param name="h"/>
    </xsl:template>
    
    <!-- Defined elsewhere.  (Stubs here prevent validation errors.) -->
    <xsl:template name="show-source"/>
    <xsl:template name="subfieldSelect">
        <xsl:param name="codes"/>
        <xsl:param name="delimiter"/>
    </xsl:template>
</xsl:stylesheet>
