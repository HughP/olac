<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="marc">

    <!-- This is called when there is a subject language and its is
        not of a subject-less resource type (e.g. lexicon, text,
        instruction) -->
    <xsl:template name="assign-linguistic-field">
        <xsl:param name="h"/>
        
        <xsl:choose>
            <xsl:when test="contains($h, 'ability testing')"
                >applied_linguistics</xsl:when>
            <xsl:when test="contains($h, 'absolute constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'accents and accentuation')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'acquisition')"
                >language_acquisition</xsl:when>
            <xsl:when test="contains($h, 'adjectivals')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'adjective')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'adverb')">syntax</xsl:when>
            <xsl:when test="contains($h, 'adverbials')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'affixes')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'agreement')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'alphabet')"
                >writing_systems</xsl:when>
            <xsl:when test="contains($h, 'anaphora')"
                >discourse_analysis</xsl:when>
            <xsl:when test="contains($h, 'animacy')">syntax</xsl:when>
            <xsl:when test="contains($h, 'apheresis')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'apposition')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'archaisms')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'article')">syntax</xsl:when>
            <xsl:when test="contains($h, 'aspiration')"
                >phonetics</xsl:when>
            <xsl:when test="contains($h, 'asyndeton')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'augmentatives')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'auxiliary verbs')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'capitalization')"
                >writing_systems</xsl:when>
            <xsl:when test="contains($h, 'case grammar')"
                >linguistic_theories</xsl:when>
            <xsl:when test="contains($h, 'case')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'cataphora')"
                >discourse_analysis</xsl:when>
            <xsl:when test="contains($h, 'categorial grammar')"
                >linguistic_theories</xsl:when>
            <xsl:when test="contains($h, 'causative')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'classifiers')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'clauses')">syntax</xsl:when>
            <xsl:when test="contains($h, 'clitics')">syntax</xsl:when>
            <xsl:when test="contains($h, 'cognate words')"
                >historical_linguistics</xsl:when>
            <xsl:when test="contains($h, 'collective nouns')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'comparative clauses')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'comparison')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'complement')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'compound words')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'concessive clauses')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'conditionals')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'conjunctions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'connectives')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'consonants')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'context')"
                >pragmatics</xsl:when>
            <xsl:when test="contains($h, 'contraction')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'coordinate constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'data processing')"
                >computational_linguistics</xsl:when>
            <xsl:when test="contains($h, 'declension')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'definiteness')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'deixis')"
                >discourse_analysis</xsl:when>
            <xsl:when test="contains($h, 'demonstratives')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'dependency grammar')"
                >linguistic_theories</xsl:when>
            <xsl:when test="contains($h, 'determiners')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'dialectology')"
                >sociolinguistics</xsl:when>
            <xsl:when test="contains($h, 'dialects')"
                >sociolinguistics</xsl:when>
            <xsl:when test="contains($h, 'diminutives')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'diphthongs')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'direct object')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'discourse analysis')"
                >discourse_analysis</xsl:when>
            <xsl:when test="contains($h, 'dissimilation')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'elision')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'ellipsis')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'enclitics')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'eponyms')">syntax</xsl:when>
            <xsl:when test="contains($h, 'ergative constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'errors of usage')"
                >applied_linguistics</xsl:when>
            <xsl:when test="contains($h, 'etymology')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'euphemism')"
                >pragmatics</xsl:when>
            <xsl:when test="contains($h, 'existential constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'function words')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'gemination')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'gerund')">syntax</xsl:when>
            <xsl:when test="contains($h, 'globalization')"
                >sociolinguistics</xsl:when>
      
            <xsl:when test="contains($h, 'grammar, comparative')"
                >syntax</xsl:when>

            <xsl:when test="contains($h, 'grammar, generative')"
                >linguistic_theories</xsl:when>

            <xsl:when test="contains($h, 'grammar, historical')"
                >historical_linguistics</xsl:when>
            <xsl:when test="contains($h, 'grammar')">syntax</xsl:when>
            <xsl:when test="contains($h, 'grammatical categories')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'grammaticalization')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'graphemics')"
                >writing_systems</xsl:when>
            <xsl:when test="contains($h, 'heteronyms')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'hiatus')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'homonyms')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'honorific')"
                >pragmatics</xsl:when>
            <xsl:when test="contains($h, 'humor')"
                >pragmatics</xsl:when>
            <xsl:when test="contains($h, 'ideophone')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'idioms')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'imperative')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'indicative')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'indirect discourse')"
                >discourse_analysis</xsl:when>
            <xsl:when test="contains($h, 'indirect object')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'infinitival constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'infinitive')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'infixes')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'inflection')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'influence on')"
                >historical_linguistics</xsl:when>
            <xsl:when test="contains($h, 'intensification')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'interjections')"
                >discourse_analysis</xsl:when>
            <xsl:when test="contains($h, 'interrogative')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'intonation')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'labiality')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'lexicography')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'locative constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'machine translating')"
                >computational_linguistics</xsl:when>
            <xsl:when test="contains($h, 'metonyms')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'mimetic words')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'modality')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'mood')">syntax</xsl:when>
            <xsl:when test="contains($h, 'morphemics')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'morphology')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'morphophonemics')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'morphosyntax')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'negatives')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'new words')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'nominals')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'noun')">syntax</xsl:when>
            <xsl:when test="contains($h, 'noun phrase')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'number')">syntax</xsl:when>
            <xsl:when test="contains($h, 'numerals')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'obscene words')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'obsolete words')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'onomatopoeic words')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'orthography and spelling')"
                >writing_systems</xsl:when>
            <xsl:when test="contains($h, 'palatalization')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'paragraphs')"
                >discourse_analysis</xsl:when>
            <xsl:when test="contains($h, 'parallelism')"
                >discourse_analysis</xsl:when>
            <xsl:when test="contains($h, 'paraphrase')"
                >translating_and_interpreting</xsl:when>
            <xsl:when
                test="contains($h, 'parenthetical constructions')"
                >discourse_analysis</xsl:when>
            <xsl:when test="contains($h, 'paronyms')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'parsing')"
                >computational_linguistics</xsl:when>
            <xsl:when test="contains($h, 'participle')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'particles')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'partitives')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'parts of speech')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'passive voice')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'person')">syntax</xsl:when>
            <xsl:when test="contains($h, 'philosophy')"
                >philosophy_of_language</xsl:when>
            <xsl:when test="contains($h, 'phonemics')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'phonetic transcriptions')"
                >phonetics</xsl:when>
            <xsl:when test="contains($h, 'phonetics')"
                >phonetics</xsl:when>
            <xsl:when test="contains($h, 'phonology, comparative')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'phonology, historical')"
                >historical_linguistics</xsl:when>
            <xsl:when test="contains($h, 'phonology')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'political aspects')"
                >sociolinguistics</xsl:when>
            <xsl:when test="contains($h, 'polysemy')"
                >semantics</xsl:when>
            <xsl:when test="contains($h, 'possessives')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'postpositions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'prepositional phrases')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'prepositions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'pronominals')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'pronoun')">syntax</xsl:when>
            <xsl:when
                test="contains($h, 'pronunciation by foreign speakers')"
                >applied_linguistics</xsl:when>
            <xsl:when test="contains($h, 'pronunciation')"
                >phonetics</xsl:when>
            <xsl:when test="contains($h, 'prosodic analysis')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'psychological aspects')"
                >psycholinguistics</xsl:when>
            <xsl:when test="contains($h, 'punctuation')"
                >writing_systems</xsl:when>
            <xsl:when test="contains($h, 'quantifiers')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'quantity')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'reduplication')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'reflexives')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'reform')"
                >sociolinguistics</xsl:when>
            <xsl:when test="contains($h, 'relational grammar')"
                >linguistic_theories</xsl:when>
            <xsl:when test="contains($h, 'relative clauses')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'religious aspects')"
                >sociolinguistics</xsl:when>
            <xsl:when test="contains($h, 'remedial teaching')"
                >applied_linguistics</xsl:when>
            <xsl:when test="contains($h, 'resultative constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'roots')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'semantics')"
                >semantics</xsl:when>
            <xsl:when test="contains($h, 'sentences')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'sex differences')"
                >sociolinguistics</xsl:when>
            <xsl:when test="contains($h, 'social aspects')"
                >sociolinguistics</xsl:when>
            <xsl:when test="contains($h, 'sonorants')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'spectral analysis')"
                >phonetics</xsl:when>
            <xsl:when test="contains($h, 'spelling')"
                >writing_systems</xsl:when>
            <xsl:when test="contains($h, 'standardization')"
                >sociolinguistics</xsl:when>
            <xsl:when test="contains($h, 'subjectless constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'subjunctive')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'subordinate constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'suffixes and prefixes')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'suppletion')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'switch-reference')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'syllabication')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'synonyms and antonyms')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'syntax')">syntax</xsl:when>
            <xsl:when test="contains($h, 'tempo')"
                >linguistics_and_literature</xsl:when>
            <xsl:when test="contains($h, 'temporal clauses')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'temporal constructions')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'tense')">syntax</xsl:when>
            <xsl:when test="contains($h, 'transcription')"
                ></xsl:when>
            <xsl:when test="contains($h, 'transitivity')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'translating')"
                >translating_and_interpreting</xsl:when>
            <xsl:when test="contains($h, 'transliteration')"
                >writing_systems</xsl:when>
            <xsl:when test="contains($h, 'variation')"
                >sociolinguistics</xsl:when>
            <xsl:when test="contains($h, 'verb')">syntax</xsl:when>
            <xsl:when test="contains($h, 'verb phrase')"
                >syntax</xsl:when>

            <xsl:when test="contains($h, 'verbals')">syntax</xsl:when>
            <xsl:when test="contains($h, 'versification')"
                >linguistics_and_literature</xsl:when>
            <xsl:when test="contains($h, 'voice')">syntax</xsl:when>
            <xsl:when test="contains($h, 'vowel gradation')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'vowel reduction')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'vowels')"
                >phonology</xsl:when>
            <xsl:when test="contains($h, 'word formation')"
                >morphology</xsl:when>
            <xsl:when test="contains($h, 'word frequency')"
                >lexicography</xsl:when>
            <xsl:when test="contains($h, 'word order')"
                >syntax</xsl:when>
            <xsl:when test="contains($h, 'writing')"
                >writing_systems</xsl:when>

            <xsl:when test="contains($h, 'aspect')">syntax</xsl:when>
            
        </xsl:choose>
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
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Agraphia')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Ambiguity')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Analogy (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Anthropological linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="anthropological_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Antonyms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Applied linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="applied_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Arabic alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Archaisms (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="lexicography"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Artificial intelligence')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Aspiration (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Assimilation (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Asymmetry (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="philosophy_of_language"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Autographs')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Autolexical theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Autosegmental theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Bharati alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Binary principle (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="general_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Brahmi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Calligraphy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Case grammar')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Causative (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Celtiberian alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Clicks (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cognitive neuroscience')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cognitive psychology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cognitive science')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cohesion (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Collocation (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Componential analysis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Componential analysis in anthropology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Compositionality (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Computational linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="computational_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Connotation (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Consonants')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Court interpreting and translating')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Critical discourse analysis')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cryptography')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cuneiform writing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Cyrillic alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Deep structure (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Definiteness (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Definition (Logic)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Dependency grammar')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Deseret alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Devanagari alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Diglossia (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Direction in language')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Discourse analysis')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Discourse markers')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Dissimilation (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Distinctive features (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Dorvolzhin alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Duration (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Emotive (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Emphasis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Emphasis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Euphemism')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Evidentials (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Field theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Focus (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Forensic linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="forensic_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Forensic phonetics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Formal languages--Semantics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Game-theoretical semantics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Gemination')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Glagolitic alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Glossematics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Glottalization (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Glottochronology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Government-binding theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Absolute constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Agreement')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Clauses')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Compensatory lengthening')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Connectives')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Coordinate constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Deletion')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Ellipsis')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Ergative constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Exclamations')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Grammaticalization')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Grammaticalization')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Honorific')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Indirect discourse')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Infinitival constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Inflection')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Locative constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Mathematical models')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Morphosyntax')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Morphosyntax')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Parenthetical constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Parsing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Phonology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Phonology, Comparative')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Resultative constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Subjectless constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Subordinate constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Syntax')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'Grammar, Comparative and general--Temporal constructions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Topic and comment')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammar, Comparative and general--Word formation')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grammaticality (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Grantha alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Graphemics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Graphology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Gurmukhi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'H (The sound)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Haplology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Heteronyms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Hiatus (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Hieroglyphics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Historical linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="historical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Homonyms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Idioms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Indexicals (Semantics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Information theory in translating')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Intonation (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Jawi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Juncture (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Keyboarding')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Kharosthi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'L (The sound)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Labiality (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language acquisition')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="language_acquisition"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and culture')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="anthropological_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Ability testing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="language_acquisition"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Classification')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="historical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Handbooks, manuals, etc.')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="general_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Origin')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="historical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Orthography and spelling')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Philosophy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="philosophy_of_language"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Phonetic transcriptions')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Study and teaching')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="language_acquisition"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Universals')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="typology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and languages--Variation')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language and logic')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language arts')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="language_acquisition"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language attrition')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language maintenance')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language obsolescence')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language planning')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language policy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language purism')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language revival')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language services')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="applied_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language spread')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language survey')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Language surveys')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Languages in contact')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Laryngeals (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Lexical phonology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Lexicography')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="lexicography"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic analysis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="general_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic demography')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic minorities')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic models')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="typology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistic paleontology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="anthropological_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistics--Graphic methods')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistics--History')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="history_of_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistics--Statistical methods')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="general_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Literature and society')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Machine translating')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Mahajani alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Markedness (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Mathematical linguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Metrical phonology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Minimalist theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Modi alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Monophthongization')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Morphemics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Mutation (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Native language and education')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="applied_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Natural language processing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="computational_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Neurolinguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="neurolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Neutralization (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Numerals, Writing of')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Ogham alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Ol alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Onomasiology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Optimality theory (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Palatalization')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Paleography')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Paragraphs')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Paraphrase')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if
            test="starts-with($subject,'People with disabilities--Printing and writing systems')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Philosophy and cognitive science')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="cognitive_science"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonemics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonemics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonetic alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonetics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonetics, Acoustic')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phonetics, Experimental')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Phraseology')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Picture-writing')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Pidgin languages')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Play on words')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Politeness (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Polysemy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Pragmatics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="pragmatics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Prosodic analysis (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Psycholinguistics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="psycholinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'R (The sound)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Racism in language')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Reference (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Register (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Rizaleo alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'S (The sound)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sapir-Whorf hypothesis')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="anthropological_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sarada alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Semantic differential technique')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Semantics--Mathematical models')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="mathematical_linguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Semantics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Semiotics')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sequence (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Shorthand')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Signatures (Writing)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Simultaneous interpreting')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Siyaqat alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sonorants (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sound symbolism')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Spectral analysis (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Speech acts (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Standard language')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Stratificational grammar')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="linguistic_theories"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Sublanguage')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="discourse_analysis"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Surface structure (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Synonyms')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Tempo (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Tod alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Tone (Phonetics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Toponymy')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="lexicography"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Translating and interpreting')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Translating services')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="translating_and_interpreting"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Typology (Linguistics)')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="typology"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Uighur alphabet')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Urban dialects')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Vowels')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Writing, Arabic')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
        </xsl:if>
        <xsl:if test="starts-with($subject,'Xenophobia in language')">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>

        <!-- irregular rules -->
        <xsl:for-each select="marc:subfield[@code='a']">
            <xsl:if test="starts-with( . ,'Proto-') and ends-with( . ,'language')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="historical_linguistics"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="starts-with($subject,&quot;&#x0027;Phags-pa alphabet&quot;)">
            <dc:subject xsi:type="olac:linguistic-field" olac:code="sociolinguistics"/>
        </xsl:if>

        <!-- subfield $x -->
        <xsl:for-each select="marc:subfield[@code='x']">
            <xsl:if test="starts-with( . ,'Alphabet')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
            </xsl:if>
            <xsl:if test="starts-with( . ,'Lexicography')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="lexicography"/>
            </xsl:if>
            <xsl:if test="starts-with( . ,'Morphology')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="morphology"/>
            </xsl:if>
            <xsl:if test="starts-with( . ,'Orthography and spelling')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
            </xsl:if>
            <xsl:if test="starts-with( . ,'Phonetics')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="phonetics"/>
            </xsl:if>
            <xsl:if test="starts-with( . ,'Semantics')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="semantics"/>
            </xsl:if>
            <xsl:if test="starts-with( . ,'Syntax')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="syntax"/>
            </xsl:if>
            <xsl:if test="starts-with( . ,'Writing')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="writing_systems"/>
            </xsl:if>
        </xsl:for-each>

        <!-- subfield $v -->
        <xsl:for-each select="marc:subfield[@code='v']">
            <xsl:if test="starts-with( . ,'Texts')">
                <dc:subject xsi:type="olac:linguistic-field" olac:code="language_documentation"/>
            </xsl:if>
        </xsl:for-each>


    </xsl:template>

</xsl:stylesheet>
