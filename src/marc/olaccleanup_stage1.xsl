<?xml version="1.0" encoding="UTF-8"?>
<!--
    This stylesheet is intended to be used as a post-process transformation for cleanup of olac records
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/">
    <xsl:import href="olacutils.xsl"/>
    <xsl:output method="xml" indent="yes"/>

    <!--  match attribute and element "nodes" (not text though - see rule below)   -->
    <xsl:template match="@*|*" priority="-1">
        <!-- do not copy dc:description - this is handled separately down below -->
        <xsl:if test="not(string(node-name(.)) = 'dc:description')">
            <xsl:copy>
                <!-- copy the element -->
                <xsl:apply-templates select="@*|node()"/>
                <!-- apply templates for all node types, including text -->
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!-- clean up the text -->
    <xsl:template match="text()" priority="-1">
        <xsl:call-template name="removeTrailingChars">
            <xsl:with-param name="text">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>



    <!-- TEMPLATES FOR CONCATENATING DC:DESSCRIPTION TOGETHER -->
    <!-- special case for olac:olac, which contains the dc:description elements we want to combine -->
    <xsl:template match="olac:olac">
        <xsl:copy>
            <!-- copy the element -->
            <xsl:apply-templates select="@*|node()"/>       <!-- apply templates for all node types, including text -->
            
            <dc:description>
                <xsl:apply-templates select="dc:description" mode="concatDesc"/>
            </dc:description>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="dc:description" mode="concatDesc">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text> / </xsl:text>
    </xsl:template>

</xsl:stylesheet>
