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
        <xsl:choose>
            <xsl:when test="@ind2='0'">
                <xsl:variable name="langCode">
                    <xsl:call-template name="assign-subject-language">
                        <xsl:with-param name="sub-a"
                            select="replace(lower-case(marc:subfield[@code='a']),'\.','')"/>
                        <xsl:with-param name="next"
                        select="replace(lower-case(marc:subfield[@code='a']/following-sibling::subfield[1]),'\.','')"/>
                        <!-- Is the first one always $a?  Can these
                            just be subfield[1] and subfield[2]? -->
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="typeCode">
                    <xsl:choose>
                        <xsl:when test="$langCode">
                            <xsl:call-template
                                name="assign-direct-type-for-language">
                                <xsl:with-param name="last"
                                    select="replace(lower-case(marc:subfield[fn:last()]),'\.','')"/>
                                <xsl:with-param name="second"
                                select="replace(lower-case(marc:subfield[@code='a']/following-sibling::subfield[1]),'\.','')"/>
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
                        <xsl:when test="$typeCode = 'langauge_lexicon'
                            or $typeCode = 'langauge_text'
                            or $typeCode = 'langauge_instruction'">
                            <!-- In these cases, do nothing since
                                there is not also a linguistic subject
                                field
                            -->
                        </xsl:when>
                        <xsl:otherwise>
                            
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:variable>
                
                <dc:subject xsi:type="dcterms:LCSH">
                    <xsl:call-template name="show-source"/>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abcdexyzv</xsl:with-param>
                        <xsl:with-param name="delimiter">--</xsl:with-param>
                    </xsl:call-template>
                </dc:subject>
                <xsl:if test="$langCode">
                    <dc:subject xsi:type="olac:language"
                       olac:code="{$langCode}"/>
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
    </xsl:template>
    
    <xsl:template name="assign-subject-language">
        <xsl:param name="sub-a"></xsl:param>
        <xsl:param name="next"></xsl:param>
        <!-- Returns the ISO 639 code for the subject language.
             Returns nothing if there is no subject language.
             Looks in subfield a ($sub-a) to match the language name.
             The following subfield ($next) is also consulted for
             cases like Middle English where a temporal scope is
             used. 
        -->
    </xsl:template>

    <xsl:template name="assign-direct-type-for-language">
        <xsl:param name="last"></xsl:param>
        <xsl:param name="second"></xsl:param>
        <!-- Returns the OLAC code for the language resource type in
            the case where there is a subject language and the
            resource type is directly known from matching either the
            form subfield (in the $last position of the LCSH) or
            thefirst topic subfield (in the $second position).
            Returns nothing if a resource type is not directly
            matched. (It may still be inferred later.) 
        -->
    </xsl:template>
    
    <xsl:template name="show-source"/>
    <xsl:template name="subfieldSelect">
        <xsl:param name="codes"/>
        <xsl:param name="delimiter"/>
    </xsl:template>
</xsl:stylesheet>
