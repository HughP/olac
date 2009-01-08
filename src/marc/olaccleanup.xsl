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
    <xsl:import href="olacutils.xsl"/>
    <xsl:output method="xml" indent="yes"/>


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
    <xsl:template match="@*|*" priority="-1">
        <xsl:copy>
            <!-- copy the element -->
            <xsl:apply-templates select="@*|node()"/>
            <!-- apply templates for all node types, including text -->
        </xsl:copy>
    </xsl:template>

    <!-- clean up the text -->
    <xsl:template match="text()">
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

    <!-- do not copy @from attribute   -->
        <xsl:template match="@from"/>

    <!-- do not copy @no_code attributes -->
    <xsl:template match="@no_code"/>


    <!-- do not copy empty elements with no attributes -->
    <xsl:template match="*[not(node()|@*)]"/>

</xsl:stylesheet>
