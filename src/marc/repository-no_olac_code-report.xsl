<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
    <xsl:output indent="yes"/>


    <xsl:template match="/sr:Repository">
        <subjectCollection xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:marc="http://www.loc.gov/MARC21/slim">
            <xsl:apply-templates select="sr:ListRecords"/>
        </subjectCollection>
    </xsl:template>
    <xsl:template match="sr:ListRecords">
        <xsl:apply-templates select="oai:record"/>
    </xsl:template>
    <xsl:template match="oai:record">
        <xsl:apply-templates select="oai:metadata"/>
    </xsl:template>
    <xsl:template match="oai:metadata">
        <xsl:apply-templates select="olac:olac"/>
    </xsl:template>
    <xsl:template match="olac:olac">

        <xsl:apply-templates select="dc:subject"/>

    </xsl:template>
    <xsl:template match="dc:subject">
        <xsl:if test="@no_code and not(starts-with(., 'Language and'))">
            <subject>
                <xsl:value-of select="."/>
            </subject>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
