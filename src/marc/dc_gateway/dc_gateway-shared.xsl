<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:alias="AliasForXSLT"
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
   version="1.0">
  <xsl:output method="xml"/>
   <xsl:variable name="sq">'</xsl:variable>
   <xsl:namespace-alias stylesheet-prefix="alias" result-prefix="xsl"/>   
   <xsl:template match="dc-element">
      <xsl:text>[</xsl:text>
      <!-- The xpath test is the concatenation of the following predicates
         which are thus ANDed together -->
         <xsl:apply-templates select="self::node()"
            mode="compile-tag"/>
         <xsl:apply-templates select="self::node()"
            mode="compile-code"/>
         <xsl:apply-templates select="self::node()"
            mode="compile-test"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <!-- Compile the @tag into an xpath [predicate] -->
   <xsl:template match="dc-element" mode="compile-tag">
      <xsl:choose>
         <xsl:when test="not(@tag)">dc:*</xsl:when>
         <xsl:when test="@tag = '' ">dc:*</xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('dc:', @tag  )"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- Compile the @test into an xpath [predicate] -->
    <xsl:template match="dc-element" mode="compile-test">
        <xsl:choose>
            <!-- What exists and negate='yes' ? -->
            <xsl:when test="@test = 'exists'">[ . != '' ]</xsl:when>
            <xsl:otherwise>
                <xsl:text>[</xsl:text>
                <xsl:if test="@negate='yes'">not(</xsl:if>
                <xsl:for-each select="text">
                    <xsl:if test="position() != 1"> or </xsl:if>
                    <xsl:choose>
                        <xsl:when test="../@test = 'equals'">
                            <xsl:value-of
                                select="concat(' . = ', $sq, ., $sq  )"
                            />
                        </xsl:when>
                        <xsl:when test="../@test = 'contains'">
                            <xsl:value-of
                                select="concat('contains( . , ', $sq, .,
               $sq, ')'  )"
                            />
                        </xsl:when>
                        <xsl:when test="../@test = 'starts-with'">
                            <xsl:value-of
                                select="concat('starts-with( . , ', $sq, .,
               $sq, ')'  )"
                            />
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:if test="@negate='yes'">)</xsl:if>
                <xsl:text>]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
