<?xml version="1.0" encoding="UTF-8"?>
<!--
    This stylesheet is intended to be used as a post-process transformation for cleanup of olac records
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
        <xsl:call-template name="removeTrailingChars">
            <xsl:with-param name="text">
                <xsl:value-of select="normalize-space(.)" />
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- removeTrailingChars is a recursive template
        operations:
        1) normalize the text
        2) remove stray punctuation separated from text w/ space i.e. [space][symbol][eol]
        3) remove unacceptable ending punctuation from text i.e. [symbol][eol]
        TODO: make this work with slashes
    -->
    <xsl:template name="removeTrailingChars">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="matches($text,'(( [:;.,])|([,;]))$')">
                <xsl:call-template name="removeTrailingChars">
                    <xsl:with-param name="text">
                        <xsl:value-of select="replace(replace($text,' [:;.,]$',''),'[,;]$','')"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"></xsl:value-of>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- do not copy @from attribute -->
    <xsl:template match="@from"/>

    <!-- do not copy empty elements -->
    <xsl:template match="*[not(node())]"/>

</xsl:stylesheet>
