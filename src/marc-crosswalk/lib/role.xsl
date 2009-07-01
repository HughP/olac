<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="marc">


    <xsl:template name="process-role">
        <!-- process MARC relator codes into OLAC roles -->
        <xsl:param name="relator"/>
        <!-- one of the above params is required -->
        <xsl:if test="$relator and $relator != ''">
            <xsl:variable name="relator-string" select="lower-case($relator)"/>
            <xsl:choose>
                
                <!-- begin MARC relator codes -->
                <xsl:when test="$relator-string = 'ann'">annotator</xsl:when>
                <xsl:when test="$relator-string = 'cwt'">annotator</xsl:when>
                <xsl:when test="$relator-string = 'aut'">author</xsl:when>
                <xsl:when test="$relator-string = 'aud'">author</xsl:when>
                <xsl:when test="$relator-string = 'lyr'">author</xsl:when>
                <xsl:when test="$relator-string = 'col'">compiler</xsl:when>
                <xsl:when test="$relator-string = 'com'">compiler</xsl:when>
                <xsl:when test="$relator-string = 'csl'">consultant</xsl:when>
                <xsl:when test="$relator-string = 'csp'">consultant</xsl:when>
                <xsl:when test="$relator-string = 'sad'">consultant</xsl:when>
                <xsl:when test="$relator-string = 'mrk'">data_inputter</xsl:when>
                <xsl:when test="$relator-string = 'dpt'">depositor</xsl:when>
                <xsl:when test="$relator-string = 'prg'">developer</xsl:when>
                <xsl:when test="$relator-string = 'edt'">editor</xsl:when>
                <xsl:when test="$relator-string = 'flm'">editor</xsl:when>
                <xsl:when test="$relator-string = 'ill'">illustrator</xsl:when>
                <xsl:when test="$relator-string = 'ivr'">interviewer</xsl:when>
                <xsl:when test="$relator-string = 'act'">performer</xsl:when>
                <xsl:when test="$relator-string = 'dnc'">performer</xsl:when>
                <xsl:when test="$relator-string = 'itr'">performer</xsl:when>
                <xsl:when test="$relator-string = 'mus'">performer</xsl:when>
                <xsl:when test="$relator-string = 'prf'">performer</xsl:when>
                <xsl:when test="$relator-string = 'ppt'">performer</xsl:when>
                <xsl:when test="$relator-string = 'stl'">performer</xsl:when>
                <xsl:when test="$relator-string = 'pht'">photographer</xsl:when>
                <xsl:when test="$relator-string = 'rce'">recorder</xsl:when>
                <xsl:when test="$relator-string = 'vdg'">recorder</xsl:when>
                <xsl:when test="$relator-string = 'rth'">researcher</xsl:when>
                <xsl:when test="$relator-string = 'rtm'">researcher</xsl:when>
                <xsl:when test="$relator-string = 'res'">researcher</xsl:when>
                <xsl:when test="$relator-string = 'sgn'">signer</xsl:when>
                <xsl:when test="$relator-string = 'sng'">singer</xsl:when>
                <xsl:when test="$relator-string = 'voc'">singer</xsl:when>
                <xsl:when test="$relator-string = 'nrt'">speaker</xsl:when>
                <xsl:when test="$relator-string = 'spk'">speaker</xsl:when>
                <xsl:when test="$relator-string = 'fnd'">sponsor</xsl:when>
                <xsl:when test="$relator-string = 'pat'">sponsor</xsl:when>
                <xsl:when test="$relator-string = 'spn'">sponsor</xsl:when>
                <xsl:when test="$relator-string = 'trc'">transcriber</xsl:when>
                <xsl:when test="$relator-string = 'trl'">translator</xsl:when>
                
                <!-- begin MARC relator terms -->
                <xsl:when test="$relator-string = 'annotator'">annotator</xsl:when>
                <xsl:when test="$relator-string = 'commentator for written text'">annotator</xsl:when>
                <xsl:when test="$relator-string = 'author'">author</xsl:when>
                <xsl:when test="$relator-string = 'author of dialog'">author</xsl:when>
                <xsl:when test="$relator-string = 'lyricist'">author</xsl:when>
                <xsl:when test="$relator-string = 'collector'">compiler</xsl:when>
                <xsl:when test="$relator-string = 'compiler'">compiler</xsl:when>
                <xsl:when test="$relator-string = 'consultant'">consultant</xsl:when>
                <xsl:when test="$relator-string = 'consultant to a project'">consultant</xsl:when>
                <xsl:when test="$relator-string = 'scientific advisor'">consultant</xsl:when>
                <xsl:when test="$relator-string = 'markup editor'">data_inputter</xsl:when>
                <xsl:when test="$relator-string = 'depositor'">depositor</xsl:when>
                <xsl:when test="$relator-string = 'programmer'">developer</xsl:when>
                <xsl:when test="$relator-string = 'editor'">editor</xsl:when>
                <xsl:when test="$relator-string = 'film editor'">editor</xsl:when>
                <xsl:when test="$relator-string = 'illustrator'">illustrator</xsl:when>
                <xsl:when test="$relator-string = 'interviewer'">interviewer</xsl:when>
                <xsl:when test="$relator-string = 'actor'">performer</xsl:when>
                <xsl:when test="$relator-string = 'dancer'">performer</xsl:when>
                <xsl:when test="$relator-string = 'instrumentalist'">performer</xsl:when>
                <xsl:when test="$relator-string = 'musician'">performer</xsl:when>
                <xsl:when test="$relator-string = 'performer'">performer</xsl:when>
                <xsl:when test="$relator-string = 'puppeteer'">performer</xsl:when>
                <xsl:when test="$relator-string = 'storyteller'">performer</xsl:when>
                <xsl:when test="$relator-string = 'photographer'">photographer</xsl:when>
                <xsl:when test="$relator-string = 'recording engineer'">recorder</xsl:when>
                <xsl:when test="$relator-string = 'videographer'">recorder</xsl:when>
                <xsl:when test="$relator-string = 'research team head'">researcher</xsl:when>
                <xsl:when test="$relator-string = 'research team member'">researcher</xsl:when>
                <xsl:when test="$relator-string = 'researcher'">researcher</xsl:when>
                <xsl:when test="$relator-string = 'signer'">signer</xsl:when>
                <xsl:when test="$relator-string = 'singer'">singer</xsl:when>
                <xsl:when test="$relator-string = 'vocalist'">singer</xsl:when>
                <xsl:when test="$relator-string = 'narrator'">speaker</xsl:when>
                <xsl:when test="$relator-string = 'speaker'">speaker</xsl:when>
                <xsl:when test="$relator-string = 'funder'">sponsor</xsl:when>
                <xsl:when test="$relator-string = 'patron'">sponsor</xsl:when>
                <xsl:when test="$relator-string = 'sponsor'">sponsor</xsl:when>
                <xsl:when test="$relator-string = 'transcriber'">transcriber</xsl:when>
                <xsl:when test="$relator-string = 'translator'">translator</xsl:when>

                <!-- the following terms are not LOC relator terms -->
                <xsl:when test="$relator-string = 'informant'">consultant</xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
