<?xml version="1.0"?>
<!--edited with XML Spy v4.0 beta 1 build Jun 13 2001 (http://www.xmlspy.com) by Gary Simons (SIL International)

oai.xsl

   XSLT for implementing OAI harvesting protocol on a data repository 
   encoded as a single XML document conforming to olacrep.dtd

Changes:

Eva Banik, Sept 2001
implemented:
* Listrecords 
* From, until, sets
* most of the java code works now

changes in testrep.xml:
* deleted the attributes on the olac element
* encoded sets as attributes on the record element

driving script: http://wave.ldc.upenn.edu:8082/vdp/olac.jsp
has to be extended to return http error codes

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Gary Simons, 28 june 2001
Based on Michel Jacobson's implementation for the LACITO repository.

All of the select="java:..." stuff to execute Java code is from
LACITO and is thus far ignored in this implementation.

Intended limitations of this implementation:
   Supports only olac and oai_dc metadata prefixes
   No resumptionTokens since supported repositories are small

The identifier parameter takes only the part of the id after oai:name:
This is because it is assumed that the driving script decomposes the
full id to find which data file to run the transformation against.

Not yet implemented:
   ListRecords verb
   Mapping to DC metadata format
   From, Until, and Set parameters

Error handling needs to be looked into.  It must be the driving
script that would return the HTTP error codes.  Would the XSLT
return an error structure that the driver would interpret?

The namespace aspects still need work. My XSLT processor is
outputting some superfluous xmlns="" attributes for some of the
elements.  I had to delete the xsi related stuff that the OAI examples
contain because they gave my XSL editor validation problems.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
					xmlns:java="http://xml.apache.org/xslt/java" 
					exclude-result-prefixes="java" 
					version="1.0">
<xsl:import href = "./olac_to_dc.xsl"/> 
	<xsl:output indent="yes"/>
	<xsl:param name="verb" select="''"/>
	<xsl:param name="until" select="''"/>
	<xsl:param name="from" select="''"/>
	<xsl:param name="set" select="''"/>
	<xsl:param name="identifier" select="''"/>
	<xsl:param name="metadataPrefix" select="''"/>
	<xsl:param name="resumptionToken" select="''"/>
	<xsl:param name="baseURL" select="''"/>
	<xsl:variable name="archive" select="//identity/repositoryIdentifier"/>
	<xsl:variable name="timezone" select="java:java.util.TimeZone.getDefault()"/>
	<xsl:variable name="time" select="java:java.lang.System.currentTimeMillis()"/>
	<xsl:variable name="zone" select="java:getRawOffset($timezone)"/>
	<xsl:variable name="format" select="java:java.text.SimpleDateFormat.new('yyyy-MM-dd')"/>
	<xsl:variable name="pos" select="java:java.text.ParsePosition.new(0)"/>
	<xsl:variable name="datefrom" select="java:parse($format, $from, $pos)"/>
	<xsl:variable name="pos2" select="java:java.text.ParsePosition.new(0)"/>
	<xsl:variable name="dateuntil" select="java:parse($format, $until, $pos2)"/>


	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$verb='Identify'">
			<xsl:call-template name="Identify"/>
			</xsl:when>
			<xsl:when test="$verb='ListSets'">
				<xsl:call-template name="ListSets"/>
			</xsl:when>
			<xsl:when test="$verb='ListIdentifiers'">
				<xsl:call-template name="ListIdentifiers"/>
			</xsl:when>
			<xsl:when test="$verb='ListMetadataFormats'">
				<xsl:call-template name="ListMetadataFormats"/>
			</xsl:when>
			<xsl:when test="$verb='GetRecord'">
				<xsl:call-template name="GetRecord"/>
			</xsl:when>
			<xsl:when test="$verb='ListRecords'">
				<xsl:call-template name="ListRecords"/>
			</xsl:when>
			<xsl:otherwise>Error 400: protocol <xsl:value-of select="$verb"/> not supported by OAI</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!--
###################################################################################################################
#								IDENTIFY
###################################################################################################################
-->


<xsl:template name="Identify">

	<Identify xmlns="http://www.openarchives.org/OAI/1.1/OAI_Identify"
			  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			  xsi:schemaLocation="http://www.openarchives.org/OAI/1.1/OAI_Identify         
              http://www.openarchives.org/OAI/1.1/OAI_Identify.xsd">
	<xsl:call-template name="dateAndURL"/>
	<repositoryName>
		<xsl:value-of select="//identity/repositoryName"/>
	</repositoryName>
	<baseURL><xsl:value-of select="$baseURL"/></baseURL>
	<protocolVersion>1.1</protocolVersion>
	<adminEmail>
		<xsl:value-of select="//identity/adminEmail"/>
	</adminEmail>
	<description>
		<xsl:call-template name="olac-archive"/> 
	</description>
	<description>
		<oai-identifier xmlns="http://www.openarchives.org/OAI/1.1/oai-identifier" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			xsi:schemaLocation="http://www.openarchives.org/OAI/1.1/oai-identifier   
			http://www.openarchives.org/OAI/1.1/oai-identifier.xsd">
		 <scheme>oai</scheme>
		 <repositoryIdentifier><xsl:value-of select="/OLAC-Repository/identity/repositoryIdentifier"/></repositoryIdentifier>
		 <delimiter><xsl:value-of select="/OLAC-Repository/identity/delimiter"/></delimiter>
		 <sampleIdentifier> <xsl:value-of select="/OLAC-Repository/identity/sampleIdentifier"/></sampleIdentifier>
		</oai-identifier>
	</description>  
   </Identify>

</xsl:template>





<xsl:template name="olac-archive" match="olac-archive">
	<olac-archive xmlns="http://www.language-archives.org/OLAC/0.4/"
	  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.language-archives.org/OLAC/0.4/
	http://www.language-archives.org/OLAC/0.4/olac-archive.xsd" type="{/OLAC-Repository/identity/olac-archive/@type}">
	<xsl:copy-of select="@*"/>
	<xsl:copy-of select="/OLAC-Repository/identity/olac-archive/*"/>  

	</olac-archive> 
</xsl:template>



<!--
###################################################################################################################
#							LISTSETS
###################################################################################################################
-->



<xsl:template name="ListSets">

	<!-- 	resumptionToken	#EXCLUSIVE	(not implemented) -->

	<ListSets xmlns="http://www.openarchives.org/OAI/1.1/OAI_ListSets"
			  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			  xsi:schemaLocation="http://www.openarchives.org/OAI/1.1/OAI_ListSets     
                  http://www.openarchives.org/OAI/1.1/OAI_ListSets.xsd">
		<xsl:call-template name="dateAndURL"/>
		<xsl:copy-of select="//sets/*"/>
	</ListSets>
</xsl:template>



<!--
###################################################################################################################
#							LISTIDENTIFIERS
###################################################################################################################
-->


<xsl:template name="ListIdentifiers">

<!--	until			#OPTIONAL
	from			#OPTIONAL
	set			#OPTIONAL
	resumptionToken	#EXCLUSIVE	(not implemented)

-->

<ListIdentifiers xmlns="http://www.openarchives.org/OAI/1.1/OAI_ListIdentifiers"
			 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			 xsi:schemaLocation="http://www.openarchives.org/OAI/1.1/OAI_ListIdentifiers         
			 http://www.openarchives.org/OAI/1.1/OAI_ListIdentifiers.xsd">
	<xsl:call-template name="dateAndURL"/>
<!--	<xsl:for-each select="/OLAC-Repository/records/*">
			<identifier>	  <xsl:value-of select="header/recordId"/></identifier>
	</xsl:for-each>
-->

	<xsl:for-each select="/OLAC-Repository/records/*">
		<xsl:if test="($set='') or (@spec=$set)"> 
			<xsl:variable name="datestamp" select="header/datestamp"/>
			<xsl:variable name="pos" select="java:java.text.ParsePosition.new(0)"/>
			<xsl:variable name="ds" select="java:parse($format, $datestamp, $pos)"/>
			<xsl:choose>
				<xsl:when test="($from!='') and ($until!='')">
					<xsl:if test="(not(java:before($ds, $datefrom))) and (not(java:after($ds, $dateuntil)))">
						<identifier>
							<xsl:value-of select="header/recordId"/>
						</identifier>
					</xsl:if>
				</xsl:when>
				<xsl:when test="($from!='') and ($until='')">
					<xsl:if test="not(java:before($ds, $datefrom))">
						<identifier>
							<xsl:value-of select="header/recordId"/>
						</identifier>
					</xsl:if>
				</xsl:when>
				<xsl:when test="($from='')  and ($until!='')">
					<xsl:if test="not(java:after($ds, $dateuntil))">
						<identifier>
							<xsl:value-of select="header/recordId"/>
						</identifier>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<identifier>
					 <xsl:value-of select="header/recordId"/>
					 <xsl:value-of select="$from"/>
					</identifier>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if> 
	</xsl:for-each>
</ListIdentifiers>
</xsl:template>


<!--
###################################################################################################################
#							LISTMETADATAFORMATS
###################################################################################################################
-->

<xsl:template name="ListMetadataFormats">

				  <!-- 	identifier		#OPTIONAL -->

<ListMetadataFormats xmlns="http://www.openarchives.org/OAI/1.1/OAI_ListMetadataFormats"
			 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			 xsi:schemaLocation="http://www.openarchives.org/OAI/1.1/OAI_ListMetadataFormats         
			 http://www.openarchives.org/OAI/1.1/OAI_ListMetadataFormats.xsd">
<xsl:call-template name="dateAndURL"/>
	<metadataFormat>
		<metadataPrefix>oai_dc</metadataPrefix>
		<schema>http://www.openarchives.org/OAI/dc.xsd</schema>
		<metadataNamespace>http://purl.org/dc/elements/1.1/</metadataNamespace>
	</metadataFormat>

	<metadataFormat>
		<metadataPrefix>olac</metadataPrefix>
		<schema>http://www.language-archives.org/OLAC/0.4/olac.xsd</schema>
		<metadataNamespace>http://www.language-archives.org/OLAC/0.4/</metadataNamespace>
	</metadataFormat>

</ListMetadataFormats>
</xsl:template>


<!--
###################################################################################################################
#							GETRECORD
###################################################################################################################
-->


<xsl:template name="GetRecord">
			  <!-- 		identifier		#REQUIRED
						metadataPrefix	#REQUIRED	-->

  <GetRecord xmlns="http://www.openarchives.org/OAI/1.1/OAI_GetRecord"
			 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			 xsi:schemaLocation="http://www.openarchives.org/OAI/1.1/OAI_GetRecord         
             http://www.openarchives.org/OAI/1.1/OAI_GetRecord.xsd">
		<xsl:call-template name="dateAndURL"/>
		<xsl:for-each select="/OLAC-Repository/records/record[header/recordId=$identifier]">
			<xsl:call-template name="oneRecord"/>
		</xsl:for-each>
	</GetRecord>
</xsl:template>



<!--
###################################################################################################################
#								LISTRECORDS
###################################################################################################################
-->


<xsl:template name="ListRecords">
		<!--	metadataPrefix	#REQUIRED	
				until			#OPTIONAL
				from			#OPTIONAL
				set			#OPTIONAL
				resumptionToken	#EXCLUSIVE	(not implemented)	-->

<ListRecords xmlns="http://www.openarchives.org/OAI/1.1/OAI_ListRecords"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			 xsi:schemaLocation="http://www.openarchives.org/OAI/1.1/OAI_ListRecords  http://www.openarchives.org/OAI/1.1/OAI_ListRecords.xsd">

	<xsl:call-template name="dateAndURL"/>
			<xsl:for-each select="/OLAC-Repository/records/*">

				<xsl:if test="($set='') or (@spec=$set)"> 
					<xsl:variable name="datestamp" select="header/datestamp"/>
					<xsl:variable name="pos" select="java:java.text.ParsePosition.new(0)"/>
										<xsl:variable name="ds" select="java:parse($format, $datestamp, $pos)"/>
					<xsl:choose>
						<xsl:when test="($from!='') and ($until!='')">
							<xsl:if test="(not(java:before($ds, $datefrom))) and (not(java:after($ds, $dateuntil)))">
								<xsl:call-template name="oneRecord"/>
							</xsl:if>
						</xsl:when>
						<xsl:when test="($from!='') and ($until='')">
							<xsl:if test="not(java:before($ds, $datefrom))">
								<xsl:call-template name="oneRecord"/>
							</xsl:if>
						</xsl:when>
						<xsl:when test="($from='')  and ($until!='')">
							<xsl:if test="not(java:after($ds, $dateuntil))">
								<xsl:call-template name="oneRecord"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="oneRecord"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>

			</xsl:for-each>
		</ListRecords>
	</xsl:template>




	<!-- ***************************************************************************************************** -->
	<xsl:template name="dateAndURL">
		<xsl:variable name="date" select="number(string($time) + string($zone))"/>
		<xsl:variable name="formatDate" select="java:java.text.SimpleDateFormat.new('yyyy-MM-dd')"/>
		<xsl:variable name="formatTime" select="java:java.text.SimpleDateFormat.new('HH:mm:ss')"/>
		<responseDate>
			<xsl:value-of select="java:format($formatDate, $date)"/>T<xsl:value-of select="java:format($formatTime, $date)"/>+00:00</responseDate> 
	
		<requestURL><xsl:value-of select="$baseURL"/>?verb=<xsl:value-of select="$verb"/>
			<xsl:if test="$until		!=''">&amp;until=<xsl:value-of select="$until"/>					   </xsl:if>
			<xsl:if test="$from			!=''">&amp;from=<xsl:value-of select="$from"/>						   </xsl:if>
			<xsl:if test="$set			!=''">&amp;set=<xsl:value-of select="$set"/>						   	</xsl:if>
			<xsl:if test="$identifier	!=''">&amp;identifier=oai:<xsl:value-of select="$archive"/>:<xsl:value-of select="$identifier"/></xsl:if>
			<xsl:if test="$metadataPrefix	!=''">&amp;metadataPrefix=<xsl:value-of select="$metadataPrefix"/>	</xsl:if>
		</requestURL>
	</xsl:template>



	<xsl:template name="recordIdentifier">
	 <identifier>	oai:<xsl:value-of select="$archive"/>:<xsl:value-of select="header/recordId"/> </identifier>
<!--xsl:element name="identifier" -->
	
	
<!-- /xsl:element -->
	</xsl:template>


<xsl:template name="oneRecord">
 <record>
 <header>
	  <xsl:call-template name="recordIdentifier"/>
	  <datestamp>
	  <xsl:value-of select="header/datestamp"/>
	  </datestamp>
	</header>
  <metadata>	
	<xsl:choose>
		<xsl:when test="$metadataPrefix = 'oai_dc'">
				<!-- <xsl:template match="/OLAC-Repository/records/record">
				<xsl:for-each select="//olac:olac">-->
				<xsl:for-each select="./metadata/*">
				<xsl:call-template name="oai_dc"/>
			</xsl:for-each>
					
		</xsl:when>
		<xsl:when test="$metadataPrefix = 'olac'">
		 
		

				
				<olac  xmlns="http://www.language-archives.org/OLAC/0.4/"
					   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					   xsi:schemaLocation="http://www.language-archives.org/OLAC/0.4/
					   http://www.language-archives.org/OLAC/0.4/olac.xsd">
				  <xsl:copy-of select="./metadata/olac/*"/>
				</olac>
			
		
		</xsl:when>
	</xsl:choose>
  </metadata>	
</record>
	
	</xsl:template>
</xsl:stylesheet>

