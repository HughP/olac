<?xml version="1.0" encoding="UTF-8"?>
<!--
    This stylesheet is intended to be used as a post-process transformation for cleanup of olac records
-->
<xsl:stylesheet version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="utils.xsl"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="inverse"/>

    <xsl:template match="dcterms:issued[@from = '533d']">
        <xsl:if
            test="not(following-sibling::dc:date or preceding-sibling::dc:date or
            following-sibling::dc:issued or preceding-sibling::dc:issued)">
            <xsl:copy>
                <!-- copy the element -->
                <xsl:apply-templates select="@*|node()"/>
                <!-- apply templates for all node types, including text -->
            </xsl:copy>
        </xsl:if>

    </xsl:template>
    <!-- define tag prioritization rules here
        i.e. 533$d dcterms:issued - only keep if no other date exists in the record
        651 ???
        
        651 - rank 3
        JAS: 651$a must be separated from 651$z, as these are usually two 
        different jurisdictions. See note below regarding term source. Rank 3
    -->


    <!--  match attribute and element "nodes" (not text though - see rule below)   -->
    <xsl:template match="@*|*" priority="-2">
        <xsl:copy>
            <!-- copy the element -->
            <xsl:apply-templates select="@*|node()"/>
            <!-- apply templates for all node types, including text -->
        </xsl:copy>
    </xsl:template>

    <xsl:template match="olac:olac">
        <xsl:choose>
            <xsl:when test="$inverse = 'yes'">
                <xsl:copy>
                    <xsl:apply-templates mode="inverse"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates mode="cleanup"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- clean up the text inside olac elements -->
    <xsl:template mode="cleanup" match="*[text()]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:call-template name="removeFinalPeriod">
                <xsl:with-param name="text">
                    <xsl:call-template name="removeTrailingChars">
                        <xsl:with-param name="text">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>
    
    <!-- special rules for inverse processing -->
    <xsl:template match="@*|*" mode="inverse" priority="-1">
<!-- do nothing -->
    </xsl:template>
    <xsl:template match="marc:datafield" mode="inverse">
        <xsl:copy-of select="." />
    </xsl:template>
    <xsl:template match="marc:controlfield" mode="inverse">
        <xsl:copy-of select="." />
    </xsl:template>
    

    <!-- If the element does not have any text, only copy it if there is an attribute named (in the list below) -->
    <xsl:template mode="cleanup" match="*[@olac:code|@xsi:type]" priority="-1">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- catch all to do nothing -->
    <xsl:template mode="cleanup" match="@*|node()" priority="-3"/>
</xsl:stylesheet>
