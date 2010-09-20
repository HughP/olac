<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet for Olac collection -->

<!DOCTYPE xsl:stylesheet [
	<!ENTITY cdata-start "&#xE501;">
	<!ENTITY cdata-end "&#xE502;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
	xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
	exclude-result-prefixes="xsl  xs oai_dc dc oai">

	<xsl:output encoding="UTF-8" use-character-maps="cdata" indent="yes" method="xml" version="1.0"
		omit-xml-declaration="no"/>

	<xsl:character-map name="cdata">
		<xsl:output-character character="&cdata-start;" string="&lt;![CDATA["/>
		<xsl:output-character character="&cdata-end;" string="]]&gt;"/>
	</xsl:character-map>


	<xsl:template match="/">
		<add>
			<doc>
				<xsl:call-template name="title"/>
				<xsl:apply-templates select="oai:record/oai:header/*"/>
				<xsl:apply-templates select="oai:record/oai:metadata/olac:olac/*"/>
				<field name="format">record</field>

			</doc>
		</add>
	</xsl:template>

	<xsl:template name="title">
		<xsl:variable name="olac_path" select="/oai:record/oai:metadata/olac:olac"/>

		<field name="title">
			<xsl:value-of
				select="if ($olac_path/dc:title) 
			then string-join($olac_path/dc:title, ' -' )
			else '[No title]'"
			/>
		</field>
	</xsl:template>

	<xsl:template match="oai:datestamp">
		<field name="last_update">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>

	<xsl:template match="oai:identifier">
		<xsl:variable name="identifier" select="replace(replace(., '^oai:', ''), '[:|.]', '_')"/>
		<field name="id">
			<xsl:value-of select="$identifier"/>
		</field>
		<xsl:variable name="url"
			select="concat('&lt;a href=&quot;http://www.language-archives.org/item/', .,'&quot;&gt;',.,'&lt;/a&gt;')"/>
		<field name="url">
			<xsl:value-of select="$url"/>
		</field>
		<xsl:variable name="oai_url"
			select="concat('&lt;a href=&quot;http://www.language-archives.org/cgi-bin/olaca3.pl?verb=GetRecord&amp;amp;identifier=', 
			.,'&amp;amp;metadataPrefix=olac_dla&quot;&gt;', '[For debugging purposes]', '&lt;/a&gt;', '') "/>
		<field name="oai_url">
			<xsl:value-of select="$oai_url"/>
		</field>
	</xsl:template>


	<xsl:template match="oai:facet">
		<xsl:choose>
			<xsl:when test="@name='Archive' ">
				<field name="archive">
					<xsl:value-of select="."/>
				</field>
				<field name="archive_home">
					<xsl:value-of
						select="concat('&lt;a href=&quot;',../oai:facet[@name='Archive home'], '&quot; target=&quot;_blank&quot;&gt;' , ., '&lt;/a&gt;')"
					/>
				</field>
			</xsl:when>
			<xsl:when test="@name='Archive description' ">
				<field name="archive_description">
					<xsl:value-of
						select="concat('&lt;a href=&quot;',../oai:facet[@name='Archive description'], ' &quot; target=&quot;_blank&quot;&gt;(see archive description)&lt;/a&gt;')"
					/>
				</field>
			</xsl:when>
			<xsl:when test="@name='Online' ">
				<field name="online">
					<xsl:value-of select="."/>
				</field>
			</xsl:when>
			<xsl:when test="@name='Family' ">
				<field name="family">
					<xsl:value-of select="."/>
				</field>
			</xsl:when>
			<xsl:when test="@name='Region' ">
				<field name="region">
					<xsl:value-of select="."/>
				</field>
			</xsl:when>
			<xsl:when test="@name='Citation' ">
				<field name="rest_of_citation">
					<xsl:value-of select="."/>
				</field>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dc:contributor">
		<field name="contributor">
			<xsl:value-of select="."/>
		</field>
		<field name="contributor_role">
			<xsl:value-of select="."/>
			<xsl:if test="@view"> (<xsl:value-of select="@view"/>)</xsl:if>
		</field>
	</xsl:template>
	
	<xsl:template match="dc:creator">
		<field name="creator">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>

	<xsl:template match="dc:description">
		<field name="description">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	
	<xsl:template match="dc:format">
		<xsl:choose>
			<xsl:when test="@xsi:type='dcterms:IMT' ">
				<field name="imt_format">
					<xsl:value-of select="."/>
				</field>
			</xsl:when>
			<xsl:otherwise>
				<field name="dc_format">
					<xsl:value-of select="."/>
				</field>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="dc:language">
		<field name="language">
			<xsl:value-of select="@view"/>
		</field>
	</xsl:template>
	
	<xsl:template match="dc:rights">
		<field name="rights">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>

	<xsl:template match="dc:subject">
		<xsl:choose>
			<xsl:when test="@xsi:type='olac:language' ">
				<field name="subject_language">
					<xsl:value-of select="@view"/>
				</field>
			</xsl:when>
			<xsl:when test="@xsi:type='dcterms:LCSH' ">
				<field name="lcsh_subject">
					<xsl:value-of select="."/>
				</field>
			</xsl:when>
			<xsl:when test="@xsi:type='dcterms:DDC' ">
				<field name="ddc_subject">
					<xsl:value-of select="."/>
				</field>
			</xsl:when>
			<xsl:when test="@xsi:type='dcterms:LCC' ">
				<field name="lcc_subject">
					<xsl:value-of select="."/>
				</field>
			</xsl:when>
			<xsl:when test="@xsi:type='olac:linguistic-field' ">
				<field name="linguistic_field">
					<xsl:value-of select="@view"/>
				</field>
			</xsl:when>
			<xsl:otherwise>
				<field name="other_subject">
					<xsl:value-of select="."/>
				</field>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="dc:type">
		<xsl:choose>
			<xsl:when test="@xsi:type='dcterms:DCMIType'">
				<field name="dcmi_type">
					<xsl:value-of select="."/>
				</field>
			</xsl:when>
			<xsl:when test="@xsi:type='olac:linguistic-type'">
				<field name="linguistic_type">
					<xsl:value-of select="@view"/>
				</field>
			</xsl:when>
			<xsl:otherwise>
				<field name="other_type">
					<xsl:value-of select="."/>
				</field>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dcterms:spatial">
		<field name="country">
			<xsl:value-of select="@view"/>
		</field>
	</xsl:template>
	<xsl:template match="dc:publisher">
		<field name="publisher">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="dc:date">
		<field name="date">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="dc:identifier">
		<xsl:choose>
			<xsl:when test="matches(.,'^http://')">
				<xsl:variable name="object_url"
					select="concat('&lt;a href=&quot;', 
					.,'&quot;&gt;', ., '&lt;/a&gt;', '') "/>
				<field name="object_url">
					<xsl:value-of select="$object_url"/>
				</field>
			</xsl:when>
			<xsl:otherwise>
				<field name="local_id">
					<xsl:value-of select="."/>
				</field>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*"/>

</xsl:stylesheet>
