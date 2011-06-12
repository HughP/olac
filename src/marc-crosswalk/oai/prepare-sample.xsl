<?xml version="1.0" encoding="UTF-8"?>
<!-- prepare-sample.xsl
     Run this over the result of extract-sample.xquery
     in order to clear out the irrelevant metadata fields
     and add the <result> element for recording the evaluation
     G. Simons, 4 June 2011
-->

<xsl:stylesheet xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                version="2.0">
   <xsl:output method="xml" encoding="UTF-8"/>
   <xsl:template match="/sr:Repository">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:copy-of select="oai:repositoryName"/>
         <xsl:apply-templates select="sr:ListRecords"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="sr:ListRecords">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="oai:record"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="oai:record">
      <xsl:copy>
         <xsl:copy-of select="oai:header"/>
         <xsl:apply-templates select="oai:metadata"/>
         <olac:result true="yes"
            right="{count(.//dc:subject[@olac:code])}" wrong="0"
            missing="0"></olac:result>
      </xsl:copy>
   </xsl:template>
   
   <!-- Suppress these -->
   <xsl:template match="dc:date | dc:creator | dc:contributor |
          dc:format | dc:identifier | dc:publisher | 
          dc:relation | dc:rights | dc:source ">
   </xsl:template>
   
   <!-- Simplify these -->
   <xsl:template match="dc:type">
      <xsl:if test="@olac:code='binary'">
         <xsl:copy>
            <xsl:copy-of select="@olac:code | text()"/>
         </xsl:copy>
      </xsl:if>
   </xsl:template>
   <xsl:template match="dc:subject[@olac:code]">
      <xsl:copy>
         <xsl:copy-of select="@olac:code | @xsi:type"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- Copy everything else -->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   
</xsl:stylesheet>
