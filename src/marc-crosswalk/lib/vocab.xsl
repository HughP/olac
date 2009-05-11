<?xml version="1.0" encoding="UTF-8"?>
<!--
    OLAC Vocabulary templates are defined here:

    process-role
    process-linguistic-type

    
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="marc">


    <xsl:template name="process-role">
        <!-- process MARC relator codes into OLAC roles -->
        <xsl:param name="subfield"/>
        <!-- required param -->
        <xsl:if test="marc:subfield[@code=$subfield] and marc:subfield[@code=$subfield] != ''">
            <xsl:variable name="code">
                <xsl:value-of select="marc:subfield[@code=$subfield]"/>
            </xsl:variable>
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
        </xsl:if>
    </xsl:template>


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

    <xsl:template name="process-linguistic-subject">
        <!-- Process LCSH into OLAC linguistic subjects
            see: http://www.language-archives.org/REC/field.html
        -->
        <xsl:variable name="subject">
            <xsl:value-of select="."/>
        </xsl:variable>

        <!-- use if statements, because the same subject heading could map to more than one linguistic field type -->

        <!-- regular-style mappings (see below irregular mappings) -->
        <xsl:if test="starts-with($subject,'Acceptability (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Agraphia')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Ambiguity')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Analogy (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Anthropological linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="anthropological_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Antonyms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Applied linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="applied_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Arabic alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Archaisms (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="lexicography" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Artificial intelligence')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Aspiration (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Assimilation (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Asymmetry (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="philosophy_of_language" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Autographs')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Autolexical theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Autosegmental theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Bharati alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Binary principle (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="general_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Brahmi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Calligraphy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Case grammar')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Causative (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Celtiberian alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Clicks (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cognitive neuroscience')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cognitive psychology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cognitive science')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cohesion (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Collocation (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Componential analysis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Componential analysis in anthropology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Compositionality (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Computational linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="computational_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Connotation (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Consonants')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Court interpreting and translating')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Critical discourse analysis')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cryptography')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cuneiform writing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cyrillic alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Deep structure (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Definiteness (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Definition (Logic)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Dependency grammar')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Deseret alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Devanagari alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Diglossia (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Direction in language')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Discourse analysis')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Discourse markers')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Dissimilation (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Distinctive features (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Dorvolzhin alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Duration (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Emotive (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Emphasis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Emphasis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Euphemism')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Evidentials (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Field theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Focus (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Forensic linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="forensic_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Forensic phonetics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Formal languages--Semantics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Game-theoretical semantics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Gemination')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Glagolitic alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Glossematics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Glottalization (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Glottochronology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Government-binding theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Absolute constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Agreement')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Clauses')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Compensatory lengthening')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Connectives')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Coordinate constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Deletion')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Ellipsis')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Ergative constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Exclamations')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Grammaticalization')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Grammaticalization')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Honorific')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Indirect discourse')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Infinitival constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Inflection')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Locative constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Mathematical models')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Morphosyntax')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Morphosyntax')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Parenthetical constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Parsing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Phonology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Phonology, Comparative')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Resultative constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Subjectless constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Subordinate constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Syntax')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Temporal constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Topic and comment')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Word formation')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammaticality (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grantha alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Graphemics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Graphology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Gurmukhi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'H (The sound)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Haplology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Heteronyms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Hiatus (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Hieroglyphics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Historical linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="historical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Homonyms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Idioms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Indexicals (Semantics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Information theory in translating')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Intonation (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Jawi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Juncture (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Keyboarding')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Kharosthi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'L (The sound)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Labiality (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language acquisition')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="language_acquisition" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and culture')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="anthropological_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Ability testing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="language_acquisition" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Classification')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="historical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Handbooks, manuals, etc.')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="general_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Origin')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="historical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Orthography and spelling')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Philosophy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="philosophy_of_language" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Phonetic transcriptions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Study and teaching')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="language_acquisition" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Universals')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="typology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Variation')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and logic')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language arts')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="language_acquisition" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language attrition')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language maintenance')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language obsolescence')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language planning')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language policy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language purism')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language revival')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language services')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="applied_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language spread')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language survey')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language surveys')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Languages in contact')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Laryngeals (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Lexical phonology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Lexicography')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="lexicography" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic analysis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="general_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic demography')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic minorities')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic models')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="typology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic paleontology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="anthropological_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistics--Graphic methods')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistics--History')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="history_of_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistics--Statistical methods')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="general_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Literature and society')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Machine translating')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Mahajani alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Markedness (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Mathematical linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Metrical phonology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Minimalist theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Modi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Monophthongization')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Morphemics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Mutation (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Native language and education')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="applied_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Natural language processing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="computational_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Neurolinguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="neurolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Neutralization (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Numerals, Writing of')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Ogham alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Ol alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Onomasiology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Optimality theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Palatalization')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Paleography')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Paragraphs')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Paraphrase')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'People with disabilities--Printing and writing systems')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Philosophy and cognitive science')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonemics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonemics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonetic alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonetics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonetics, Acoustic')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonetics, Experimental')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phraseology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Picture-writing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Pidgin languages')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Play on words')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Politeness (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Polysemy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Pragmatics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="pragmatics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Prosodic analysis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Psycholinguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="psycholinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'R (The sound)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Racism in language')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Reference (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Register (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Rizaleo alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'S (The sound)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sapir-Whorf hypothesis')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="anthropological_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sarada alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Semantic differential technique')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Semantics--Mathematical models')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Semantics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Semiotics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sequence (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Shorthand')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Signatures (Writing)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Simultaneous interpreting')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Siyaqat alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sonorants (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sound symbolism')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Spectral analysis (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Speech acts (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Standard language')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Stratificational grammar')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sublanguage')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Surface structure (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Synonyms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Tempo (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Tod alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Tone (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Toponymy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="lexicography" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Translating and interpreting')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Translating services')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Typology (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="typology" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Uighur alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Urban dialects')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Vowels')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Writing, Arabic')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
        </xsl:if>
        <xsl:if test="starts-with($subject,'Xenophobia in language')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>

        <!-- irregular rules -->
        <xsl:for-each select="marc:subfield[@code='a']">
            <xsl:if test="starts-with( . ,'Proto-') and ends-with( . ,'language')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="historical_linguistics" />
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="starts-with($subject,&quot;&#x0027;Phags-pa alphabet&quot;)">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics" />
        </xsl:if>

        <!-- subfield $x -->
        <xsl:for-each select="marc:subfield[@code='x']">
            <xsl:if test="starts-with( . ,'Alphabet')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
            </xsl:if>
            <xsl:if test="starts-with( . ,'Lexicography')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="lexicography" />
            </xsl:if>
            <xsl:if test="starts-with( . ,'Morphology')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology" />
            </xsl:if>
            <xsl:if test="starts-with( . ,'Orthography and spelling')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
            </xsl:if>
            <xsl:if test="starts-with( . ,'Phonetics')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics" />
            </xsl:if>
            <xsl:if test="starts-with( . ,'Semantics')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics" />
            </xsl:if>
            <xsl:if test="starts-with( . ,'Syntax')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax" />
            </xsl:if>
            <xsl:if test="starts-with( . ,'Writing')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems" />
            </xsl:if>
        </xsl:for-each>

        <!-- subfield $v -->
        <xsl:for-each select="marc:subfield[@code='v']">
            <xsl:if test="starts-with( . ,'Texts')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="language_documentation" />
            </xsl:if>
        </xsl:for-each>


    </xsl:template>

</xsl:stylesheet>
