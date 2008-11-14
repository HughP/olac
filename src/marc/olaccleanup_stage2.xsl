<?xml version="1.0" encoding="UTF-8"?>
<!--
    This stylesheet is intended to be used as a post-process transformation for cleanup of olac records
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="olacutils.xsl"/>
    <xsl:output method="xml" indent="yes"/>

    <!--  match attribute and element "nodes" (not text though - see rule below)   -->
    <xsl:template match="@*|*" priority="-1">
                <xsl:copy>
                    <!-- copy the element -->
                    <xsl:apply-templates select="@*|node()"/>
                    <!-- apply templates for all node types, including text -->
                </xsl:copy>
    </xsl:template>

    <!-- clean up the text -->
    <xsl:template match="text()" priority="-1">
        <xsl:call-template name="removeFinalPeriod">
            <xsl:with-param name="text">
                <xsl:call-template name="removeTrailingChars">
                    <xsl:with-param name="text">
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- do not copy @from attribute 
        <xsl:template match="@from"/> -->

    <!-- do not copy empty elements with no attributes -->
    <xsl:template match="*[not(node()|@*)]"/>

</xsl:stylesheet>
