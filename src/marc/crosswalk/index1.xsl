<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:dir="http://apache.org/cocoon/directory/2.0">
   <xsl:output method="xml" />
   <xsl:template match="dir:directory">
      <html>
         <head>
            <title>Crosswalk Index</title>
         </head>
         <body>
            <h1>Workbench for MARC-to-OLAC Crosswalk</h1>
            <blockquote><p><a href="crosswalk.rnc">Crosswalk schema</a></p>
            </blockquote>
            <h3>Available MARC data sets</h3>
            <ul>
               <xsl:for-each select="dir:file">
                  <xsl:sort select="@size" data-type="number"/>
                  <li><a href="{@name}/index"><xsl:value-of select="@name"/></a> 
                      (<xsl:value-of select="format-number( (@size *
                         1.0) div 1000000.0, '0.0' )"/>M)</li>
               </xsl:for-each>
            </ul>
         </body>
      </html>
    </xsl:template>
   
</xsl:stylesheet>
