<?xml version="1.0" encoding="UTF-8"?>
<!-- 
     Repository2html.xsl
     Create an HTML view of an OLAC static repository
-->
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository" 
   xmlns:oai="http://www.openarchives.org/OAI/2.0/" 
   xmlns:olac="http://www.language-archives.org/OLAC/1.1/" 
   xmlns:dc="http://purl.org/dc/elements/1.1/" 
   xmlns:dcterms="http://purl.org/dc/terms/" 
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
   <xsl:import href="../../web/metadata_record.xsl"/>
    <xsl:output method="html"/>
   
   <xsl:template match="/">
      <xsl:variable name="title" select="concat( 'Repository: ',
         //oai:repositoryName)"></xsl:variable>
      <html>
         <head>
            <title><xsl:value-of select="$title"/></title>
         </head>
         <body>
            <h1><xsl:value-of select="$title"/></h1>
            <xsl:apply-templates select="//sr:ListRecords/oai:record"/>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template match="oai:record">
      <h2><xsl:value-of select="oai:header/oai:identifier"/></h2>
      <xsl:apply-templates select="oai:metadata/olac:olac"
         mode="record"/>
   </xsl:template>
</xsl:stylesheet>
