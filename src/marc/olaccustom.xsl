<?xml version="1.0" encoding="UTF-8"?>
<!--
This stylesheet defines institution-specific modifications to the marc2olac stylesheet

Include overriding templates below
Don't forget to make them a priority of 2
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="marc">

    <!-- JAS: GIAL_Marc_590sample1.mrc contains a sample set of records that includes the patterns
        found thus far with regard to use of 590. 
        patterns:
        =590  \\$aEthnologue 15 = ISO 639-3 bca (52 records of the whole set of 29000+ have this pattern)
        =590  \\$aarz Ethnologue 15 = ISO 639-3
        =590  \\$askl$2Ethnologue 15 = ISO 639-3
        
        Also 594:
        =594  \\$aEthnologue 15 = ISO/DIS 639-3 piu
        =594  \\$aEthnologue 15 = ISO/DIS 639-3 sml, sse
        (usually the tag is repeated)
        =594  \\$abhk$2Ethnologue 15=ISO 639-3
        =594  \\$acmn$2Ethnologue 15/ISO/DIS 639-3
        =594  \\$acmn$hEthnologue: ISO/DIS 639-3
        =594  \\$aort$2Ethnologue:ISO/DIS 639-3
        =594  \\$anya$2ISO/DIS 639-3
    -->
    <xsl:template match="marc:datafield[@tag='590' or @tag='594']">
        <xsl:if test="starts-with(marc:subfield[@code='2'],'Ethnologue 15')">
            <dc:subject xsi:type="olac:language">
                <xsl:call-template name="show-source">
                    <xsl:with-param name="subfield">a</xsl:with-param>
                </xsl:call-template>
                <xsl:attribute name="olac:code">
                    <xsl:call-template name="parse-language-note-GIAL"/>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </xsl:attribute>
            </dc:subject>
        </xsl:if>
    </xsl:template>


<xsl:template name="parse-language-note-GIAL">
    
    
</xsl:template>



    <!-- Default rule for 5xx tags when no other 5xx tag is matched by following rules 
        JAS: I think we can select the Notes fields that interest us, and omit the remainder. 
        So we should not need a generic 5xx match. -->
    <!--
        <xsl:template match="marc:datafield[starts-with(@tag,'5')]" priority="0.5">
        <dc:description>
        <xsl:call-template name="show-source"/>
        <xsl:value-of select="."/>
        </dc:description>
        </xsl:template>
        All 5xx templates much have a priority=1 so that it does not conflict with the above catch-all rule
    -->

</xsl:stylesheet>
