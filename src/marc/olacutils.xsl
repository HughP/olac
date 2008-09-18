<?xml version="1.0" encoding="UTF-8"?>
<!--
    Store utility functions here
-->


<!-- removeTrailingChars is a recursive template
    operations:
    1) normalize the text
    2) remove stray punctuation separated from text w/ space i.e. [space][symbol][eol]
    3) remove unacceptable ending punctuation from text i.e. [symbol][eol]
    TODO: make this work with slashes
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="removeTrailingChars">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="matches($text,'(( [:;.,/])|([,;/]))$')">
                <xsl:call-template name="removeTrailingChars">
                    <xsl:with-param name="text">
                        <xsl:value-of select="replace(replace($text,' [:;.,/]$',''),'[,;/]$','')"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
