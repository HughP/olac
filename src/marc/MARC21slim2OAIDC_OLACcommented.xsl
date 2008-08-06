<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
	<xsl:import href="http://www.loc.gov/standards/marcxml/xslt/MARC21slimUtils.xsl"/>
	<xsl:output method="xml" indent="yes"/>
	<!--
	Suppressed duplicate 520,521.  fixed 752 subfield list, suppressed 856q, added 662.  2008-01-22 ntra
	Fixed 500 fields. 2006-12-11 ntra
	Added ISBN and deleted attributes 6/04 jer
	-->
	<xsl:template match="/">
		<xsl:if test="marc:collection">
			<oai_dc:dcCollection xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
				<xsl:for-each select="marc:collection">
					<xsl:for-each select="marc:record">
						<oai_dc:dc>
							<xsl:apply-templates select="."/>
						</oai_dc:dc>
					</xsl:for-each>
				</xsl:for-each>
			</oai_dc:dcCollection>
		</xsl:if>
		<xsl:if test="marc:record">
			<oai_dc:dc xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
				<xsl:apply-templates/>
			</oai_dc:dc>
		</xsl:if>
	</xsl:template>
	<xsl:template match="marc:record">
		<xsl:variable name="leader" select="marc:leader"/>
		<xsl:variable name="leader6" select="substring($leader,7,1)"/>
		<xsl:variable name="leader7" select="substring($leader,8,1)"/>
		<xsl:variable name="controlField008" select="marc:controlfield[@tag=008]"/>


            <!-- dc:title -->
		<xsl:for-each select="marc:datafield[@tag=245]">
		<!-- JAS: We probably want additional title fields 242, possibly 130, 240
			Subfields fghk belong in other QDC fields (fg are dates, h is format, k is like type and probably better dealt with through the leader  -->

			<dc:title>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abfghk</xsl:with-param>
				</xsl:call-template>
			</dc:title>
		</xsl:for-each>





            <!-- dc:creator -->
		<xsl:for-each select="marc:datafield[@tag=100]|marc:datafield[@tag=110]|marc:datafield[@tag=111]|marc:datafield[@tag=700]|marc:datafield[@tag=710]|marc:datafield[@tag=711]|marc:datafield[@tag=720]">
		<!-- JAS: OLAC prefers contributor to creator
		Subfields abcdq have name information
		e4 contain role information
		omit other subfields -->
			<dc:creator>
                <xsl:value-of select="."/>
			</dc:creator>
		</xsl:for-each>




        <!-- dc:type --> 
		<dc:type>
			<xsl:if test="$leader7='c'">
				<!--Remove attribute 6/04 jer-->
				<!--<xsl:attribute name="collection">yes</xsl:attribute>-->
				<xsl:text>collection</xsl:text>
			</xsl:if>
			<xsl:if test="$leader6='d' or $leader6='f' or $leader6='p' or $leader6='t'">
				<!--Remove attribute 6/04 jer-->
				<!--<xsl:attribute name="manuscript">yes</xsl:attribute>-->
				<xsl:text>manuscript</xsl:text>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$leader6='a' or $leader6='t'">text</xsl:when>
				<xsl:when test="$leader6='e' or $leader6='f'">cartographic</xsl:when>
				<xsl:when test="$leader6='c' or $leader6='d'">notated music</xsl:when>
				<xsl:when test="$leader6='i' or $leader6='j'">sound recording</xsl:when>
				<xsl:when test="$leader6='k'">still image</xsl:when>
				<xsl:when test="$leader6='g'">moving image</xsl:when>
				<xsl:when test="$leader6='r'">three dimensional object</xsl:when>
				<xsl:when test="$leader6='m'">software, multimedia</xsl:when>
				<xsl:when test="$leader6='p'">mixed material</xsl:when>
			</xsl:choose>
		</dc:type>

        <!-- additional dc:type -->
		<xsl:for-each select="marc:datafield[@tag=655]">
			<dc:type>
				<xsl:value-of select="."/>
			</dc:type>
		</xsl:for-each>







        <!-- dc:publisher -->

		<xsl:for-each select="marc:datafield[@tag=260]">
			<dc:publisher>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</dc:publisher>






        <!-- dc:date -->
		</xsl:for-each>
		<!-- JAS: 260c in QDC could be dcterms:issued  -->
		<xsl:for-each select="marc:datafield[@tag=260]/marc:subfield[@code='c']">
			<dc:date>
				<xsl:value-of select="."/>
			</dc:date>
		</xsl:for-each>





        <!-- dc:language , language used to express the metadata, not the language of the content being described -->
		<!-- JAS: prefer 041 and parse, or 590  -->
		<dc:language>
			<xsl:value-of select="substring($controlField008,36,3)"/>
		</dc:language>
	<!--	<xsl:for-each select="marc:datafield[@tag=856]/marc:subfield[@code='q']">
			<dc:format>
				<xsl:value-of select="."/>
			</dc:format>
		</xsl:for-each>-->
		<!--<xsl:for-each select="marc:datafield[@tag=520]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>-->
		<!--<xsl:for-each select="marc:datafield[@tag=521]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>-->
 




        <!-- dc:description -->

		<!-- JAS: 505 could be put in dcterms:tableOfContents; these are common in GIAL data  -->
		<xsl:for-each select="marc:datafield[500&lt;= @tag and @tag&lt;= 599 ][not(@tag=506 or @tag=530 or @tag=540 or @tag=546)]">
			<dc:description>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:description>
		</xsl:for-each>




        <!-- dc:subject -->

		<!-- JAS: 300a belongs in dcterms:extent (strip ending subfield punctuation)  -->
		<!-- JAS: 440/830 should be expressed somewhere,
			it could belong in dcterms:isPartOf  but the latest information from the DCMI abstract model
			specifies that relation term refinements are intended to be used for non-literals 
			(it should point to another resource) -->
		<xsl:for-each select="marc:datafield[@tag=600]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=610]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=611]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=630]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<!-- JAS: subfields abx
		Subfield y in dcterms:temporal
		subfield z in dcterms:spatial-->
		<xsl:for-each select="marc:datafield[@tag=650]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>
		<!-- JAS: field 651 was skipped; subfields az belong in dcterms:spatial  -->
		<xsl:for-each select="marc:datafield[@tag=653]">
			<dc:subject>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdq</xsl:with-param>
				</xsl:call-template>
			</dc:subject>
		</xsl:for-each>












        <!-- dc:coverage -->

		<!-- JAS: 662 belongs in dcterms:spatial -->
		<xsl:for-each select="marc:datafield[@tag=662]">
			<dc:coverage>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdefgh</xsl:with-param>
				</xsl:call-template>
			</dc:coverage>
		</xsl:for-each>
		<!-- JAS: skip 752 (one occurrence in GIAL data, and that was redundant with 260) -->
		<xsl:for-each select="marc:datafield[@tag=752]">
			<dc:coverage>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">adcdfgh</xsl:with-param>
				</xsl:call-template>
			</dc:coverage>
		</xsl:for-each>




        <!-- dc:relation -->

		<!-- JAS: skip 530 -->
		<xsl:for-each select="marc:datafield[@tag=530]">
			<dc:relation type="original">
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">abcdu</xsl:with-param>
				</xsl:call-template>
			</dc:relation>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=760]|marc:datafield[@tag=762]|marc:datafield[@tag=765]|marc:datafield[@tag=767]|marc:datafield[@tag=770]|marc:datafield[@tag=772]|marc:datafield[@tag=773]|marc:datafield[@tag=774]|marc:datafield[@tag=775]|marc:datafield[@tag=776]|marc:datafield[@tag=777]|marc:datafield[@tag=780]|marc:datafield[@tag=785]|marc:datafield[@tag=786]|marc:datafield[@tag=787]">
			<dc:relation>
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ot</xsl:with-param>
				</xsl:call-template>
			</dc:relation>
		</xsl:for-each>




        <!-- dc:identifier -->
		<xsl:for-each select="marc:datafield[@tag=856]">
			<dc:identifier>
				<xsl:value-of select="marc:subfield[@code='u']"/>
			</dc:identifier>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=020]">
			<dc:identifier>
				<xsl:text>URN:ISBN:</xsl:text>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:identifier>
		</xsl:for-each>



        <!-- dc:rights -->
		<xsl:for-each select="marc:datafield[@tag=506]">
			<dc:rights>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:rights>
		</xsl:for-each>
		<xsl:for-each select="marc:datafield[@tag=540]">
			<dc:rights>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</dc:rights>
		</xsl:for-each>
		<!--</oai_dc:dc>-->
	</xsl:template>
</xsl:stylesheet>

