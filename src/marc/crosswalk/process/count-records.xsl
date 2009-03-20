<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
       xmlns:marc="http://www.loc.gov/MARC21/slim" version="1.0">
<xsl:output method="xml"/>
    <xsl:template match="/marc:collection">
        <Record-count>
            <xsl:value-of select="count(*)"/>
        </Record-count>
    </xsl:template>
</xsl:stylesheet>
