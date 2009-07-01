<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="marc">


    <xsl:template name="process-linguistic-type">
        <!-- process LCSH into OLAC linguistic types -->
        <xsl:variable name="subject">
            <xsl:value-of select="."/>
        </xsl:variable>

        <!-- TODO: fn:contains() is probably not the best here.  We may be getting false positives.  See id: 28085 
        -->

        <!-- type = language_description -->
        <xsl:if
            test="marc:subfield[@code = 'x' and (contains( . ,'Grammar') or contains( . ,'Phonology') or 
                        contains( . ,'Morphology') or contains( . ,'Orthography') )]">
            <dc:type xsi:type="olac:linguistic-type" olac:code="language_description"/>
        </xsl:if>

        <!-- type = lexicon -->
        <xsl:if
            test="marc:subfield[@code = 'v' and (contains( . ,'Dictionaries') or contains( . ,'Conversation and phrase books') or 
                        contains( . ,'Glossaries, vocabularies, etc.') )]">
            <dc:type xsi:type="olac:linguistic-type" olac:code="lexicon"/>
        </xsl:if>

        <!-- type = primary_text -->
        <xsl:if test="marc:subfield[@code = 'v' and contains( . ,'Texts') ]">
            <dc:type xsi:type="olac:linguistic-type" olac:code="primary_text"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
