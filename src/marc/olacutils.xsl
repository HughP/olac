<?xml version="1.0" encoding="UTF-8"?>
<!--
    Store utility functions here
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai="http://www.openarchives.org/OAI/2.0/">

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
    

    <!-- function taken verbatim from LOC MARC utilities stylesheet:
    http://www.loc.gov/standards/marcxml/xslt/MARC21slimUtils.xsl
    Purpose: print subfields named in the 'code' param
    Params:  codes - string of characters of subfield codes to be printed
             delimiter - string to delimit more than one subfield
    Note: the order of printing is based upon the XML data, not the order
        of the codes in the parameter
    -->
    <xsl:template name="subfieldSelect">
        <xsl:param name="codes">abcdefghijklmnopqrstuvwxyz1234567890</xsl:param>
        <xsl:param name="delimiter">
            <xsl:text> </xsl:text>
        </xsl:param>
        <xsl:variable name="str">
            <xsl:for-each select="marc:subfield">
                <xsl:if test="contains($codes, @code)">
                    <xsl:value-of select="text()"/>
                    <xsl:value-of select="$delimiter"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($str,1,string-length($str)-string-length($delimiter))"/>
    </xsl:template>
    
    
</xsl:stylesheet>
