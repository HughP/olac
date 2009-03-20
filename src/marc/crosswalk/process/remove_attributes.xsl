<?xml version="1.0" encoding="UTF-8"?>
<!--
    remove_attribues.xsl
    As the final step in the post-process transformation for
    cleanup of olac records, remove th @from attribute
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/">
    <xsl:output method="xml" indent="yes"/>

       
    <xsl:template match="@from">
        <!-- Discard @from -->
    </xsl:template>

    <xsl:template match="@*|text()" priority="-1">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="*" priority="-1">
        <xsl:copy>
            <!-- copy the element -->
            <xsl:apply-templates select="@*|node()"/>
            <!-- apply templates for all subnodes -->
        </xsl:copy>
    </xsl:template>

    
</xsl:stylesheet>
