<xsl:template match="olac:olac">
<xsl:copy>
<for-each select="*">
<xsl:choose>
<xsl:when test="following-sibling::*[name() = current()[name()]]
			[@olac:code = current()/@olac:code]
			[text() = current()/text()]">
</xsl:when>
<xsl:otherwise>
<xsl:copy-of select="self::node()" />
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:copy>
</template>
