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
            <xsl:for-each select="*">
                <xsl:sort select="name()" />
                <!--
                <xsl:for-each select="following-sibling::*">
                    <followingsiblingname><xsl:value-of select="name()" /></followingsiblingname>
                    <currentname><xsl:value-of select="name(current())" /></currentname>
                    <followingsiblingolaccode><xsl:value-of select="@olac:code"></xsl:value-of></followingsiblingolaccode>
                    <olaccode><xsl:value-of select="current()/@olac:code"></xsl:value-of></olaccode>
                </xsl:for-each>
                -->
                <xsl:choose>
                    <xsl:when
                        test="following-sibling::*[name() = name(current())]
			[@olac:code = current()/@olac:code]">
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
