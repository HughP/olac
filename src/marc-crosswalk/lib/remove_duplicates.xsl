<?xml version="1.0" encoding="UTF-8"?>
<!--
    This stylesheet is intended to be used as a post-process transformation for cleanup of olac records
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="olac:olac">

        <xsl:copy>
            <!-- case for elements that don't have an olac:code -->
            <xsl:for-each select="*[not(@olac:code)]">
                <xsl:variable name="currentname" select="name()" />
                <xsl:variable name="currenttext" select="text()" />
                <xsl:choose>
                    <xsl:when
                        test="following-sibling::*[name() = $currentname][text() = $currenttext]">
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="self::node()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- case for elements that DO have an OLAC code, but don't have text -->
            <xsl:for-each select="*[@olac:code][not(text())]">
                <xsl:variable name="currentname" select="name()" />
                <xsl:variable name="currentcode" select="@olac:code" />
                <xsl:choose>
                    <xsl:when
                        test="following-sibling::*[name() = $currentname][@olac:code = $currentcode]">
			</xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="self::node()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
           
           <!--  case for elements with an OLAC code, and also with text -->
            <xsl:for-each select="*[@olac:code][text()]">
                <xsl:variable name="currentname" select="name()" />
                <xsl:variable name="currenttext" select="text()" />
                <xsl:variable name="currentcode" select="@olac:code" />
                <xsl:choose>
                    <xsl:when
                        test="following-sibling::*[name() = $currentname][text() = $currenttext] and following-sibling::*[name() = $currentname][@olac:code = $currentcode]">
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="self::node()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*|*" priority="-1">
        <xsl:copy>
            <!-- copy the element -->
            <xsl:apply-templates select="@*|node()"/>
            <!-- apply templates for all node types, including text -->
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" priority="-1">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
</xsl:stylesheet>
