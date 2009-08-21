<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    type.xsl
       Named templates for determining OLAC langauge reseource type
       assign-direct-type-for-language: Uses LCSH form subdivision to
          assign the resource type when there is a subject language
       assign-inferred-type-for-language: Infers the type from
          linguistic subfield when there is a subject language but no
          form subdivision 

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="marc">


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
        <xsl:choose>
            <xsl:when test="contains($h, 'dictionaries')">language_lexicon</xsl:when>
            <xsl:when test="contains($h, 'gazatteers')">language_lexicon</xsl:when>
            <xsl:when test="contains($h, 'glossaries, vocabularies, etc')">language_lexicon</xsl:when>
            <xsl:when test="contains($h, 'nomenclature')">language_lexicon</xsl:when>
            <xsl:when test="contains($h, 'reverse indexes')">language_lexicon</xsl:when>
            <xsl:when test="contains($h, 'synonyms and antonyms')">language_lexicon</xsl:when>
            <xsl:when test="contains($h, 'terminology')">language_lexicon</xsl:when>
            <xsl:when test="contains($h, 'terms and phrases')">language_lexicon</xsl:when>
            <xsl:when test="contains($h, 'concordances')">language_text</xsl:when>
            <xsl:when test="contains($h, 'comic books, strips, etc')">language_text</xsl:when>
            <xsl:when test="contains($h, 'correspondence')">language_text</xsl:when>
            <xsl:when test="contains($h, 'drama')">language_text</xsl:when>
            <xsl:when test="contains($h, 'fiction')">language_text</xsl:when>
            <xsl:when test="contains($h, 'folklore')">language_text</xsl:when>
            <xsl:when test="contains($h, 'juvenile drama')">language_text</xsl:when>
            <xsl:when test="contains($h, 'juvenile fiction')">language_text</xsl:when>
            <xsl:when test="contains($h, 'juvenile literature')">language_text</xsl:when>
            <xsl:when test="contains($h, 'juvenile poetry')">language_text</xsl:when>
            <xsl:when test="contains($h, 'legends')">language_text</xsl:when>
            <xsl:when test="contains($h, 'literary collections')">language_text</xsl:when>
            <xsl:when test="contains($h, 'newspapers')">language_text</xsl:when>
            <xsl:when test="contains($h, 'personal narratives')">language_text</xsl:when>
            <xsl:when test="contains($h, 'phonetic transcriptions')">language_text</xsl:when>
            <xsl:when test="contains($h, 'poetry')">language_text</xsl:when>
            <xsl:when test="contains($h, 'prayer-books and devotions')">language_text</xsl:when>
            <xsl:when test="contains($h, 'quotations, maxims, etc')">language_text</xsl:when>
            <xsl:when test="contains($h, 'records and correspondence')">language_text</xsl:when>
            <xsl:when test="contains($h, 'sermons')">language_text</xsl:when>
            <xsl:when test="contains($h, 'songs and music')">language_text</xsl:when>
            <xsl:when test="contains($h, 'sources')">language_text</xsl:when>
            <xsl:when test="contains($h, 'texts')">language_text</xsl:when>
            <xsl:when test="contains($h, 'atlases')">language_situation</xsl:when>
            <xsl:when test="contains($h, 'maps')">language_situation</xsl:when>
            <xsl:when test="contains($h, 'statistics')">language_situation</xsl:when>
            <xsl:when test="contains($h, 'conversation and phrase books')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'computer-assisted instruction')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'curricula')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'examinations, questions, etc')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'exercises')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'guidebooks')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'handbooks, manuals, etc')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'laboratory manuals')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'outlines, syllabi, etc')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'problems, exercises, etc')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'programmed instruction')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'readers')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'self-instruction')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'sound recordings for')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'style manuals')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'study and teaching')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'study guides')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'textbooks for')">language_instruction</xsl:when>
            <xsl:when test="contains($h, 'bibliography')">resource_index</xsl:when>
            <xsl:when test="contains($h, 'catalogs')">resource_index</xsl:when>
            <xsl:when test="contains($h, 'indexes')">resource_index</xsl:when>
            <xsl:when test="contains($h, 'microform catalogs')">resource_index</xsl:when>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="assign-inferred-type-for-language">
        <xsl:param name="f"/>
        <!-- The parameter is the linguistic field code.
            Returns the OLAC code for the language resource type
            that can be inferred from that field code (since we
            already know that it is about a particular language).
        -->
        <xsl:choose>
            <xsl:when test="$f='discourse_analysis'">language_description</xsl:when>
            <xsl:when test="$f='morphology'">language_description</xsl:when>
            <xsl:when test="$f='phonetics'">language_description</xsl:when>
            <xsl:when test="$f='phonology'">language_description</xsl:when>
            <xsl:when test="$f='pragmatics'">language_description</xsl:when>
            <xsl:when test="$f='semantics'">language_description</xsl:when>
            <xsl:when test="$f='syntax'">language_description</xsl:when>
            <xsl:when test="$f='writing_systems'">language_description</xsl:when>
            <xsl:when test="$f='applied_linguistics'">language_instruction</xsl:when>
            <xsl:when test="$f='anthropological_linguistics'">language_situation</xsl:when>
            <xsl:when test="$f='sociolinguistics'">language_situation</xsl:when>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- The following is obsolete; to be deleted soon. -->
    
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
