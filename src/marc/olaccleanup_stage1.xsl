<?xml version="1.0" encoding="UTF-8"?>
<!--
    This stylesheet is intended to be used as a post-process transformation for cleanup of olac records
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/">
    <xsl:import href="olacutils.xsl"/>
    <xsl:output method="xml" indent="yes"/>



<!-- define tag prioritization rules here
    i.e. 533$d dcterms:issued - only keep if no other date exists in the record
    651 ???
    
    651 - rank 3
     JAS: 651$a must be separated from 651$z, as these are usually two 
    different jurisdictions. See note below regarding term source. Rank 3
-->


    <!--  match attribute and element "nodes" (not text though - see rule below)   -->
    <xsl:template match="@*|*" priority="-1">
        <!-- do not copy dc:description - this is handled separately down below -->
            <xsl:copy>
                <!-- copy the element -->
                <xsl:apply-templates select="@*|node()"/>
                <!-- apply templates for all node types, including text -->
            </xsl:copy>
    </xsl:template>

    <!-- clean up the text -->
    <xsl:template match="text()" priority="-1">
        <xsl:call-template name="removeTrailingChars">
            <xsl:with-param name="text">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
