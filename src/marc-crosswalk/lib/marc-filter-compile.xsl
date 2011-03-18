<?xml version="1.0" encoding="UTF-8"?>
<!-- marc-filter-compile.xsl
        Compile the filter over a MARC record collection
        G. Simons, 4 Feb 2009
        Last updated: 18 Mar 2011
        
     There are two parameters:
        version   Defaults to "1.0". Call with value of "2.0" to
                  create XSLT2 stylesheet
        mode      Defaults to "retain", e.g. create a stylesheet that
                  writes the records retained by the filter. Call with 
                  value of "reject" to create a stylesheet that writes
                  the records rejected by the filter.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:alias="AliasForXSLT"
   xmlns:marc="http://www.loc.gov/MARC21/slim" version="2.0">
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:namespace-alias stylesheet-prefix="alias" result-prefix="xsl"/>
   <xsl:param name="mode">retain</xsl:param>
   <xsl:param name="version">1.0</xsl:param>
   <xsl:variable name="sq">'</xsl:variable>
   
   <xsl:template match="/marc-filter">
      <alias:stylesheet version="{$version}">
         <alias:param name="debug">no</alias:param>
         <alias:output method="xml" encoding="UTF-8"/>
         <alias:strip-space elements="marc:collection"/>
         <alias:template match="marc:collection">
            <alias:copy>
               <alias:apply-templates/>
            </alias:copy>
         </alias:template>

         <xsl:comment> The reject rules </xsl:comment>
         <xsl:apply-templates select="reject-rules/*"/>

         <xsl:comment> The retain rules </xsl:comment>
         <xsl:apply-templates select="retain-rules/*"/>

         <xsl:comment> Handle records that match no rule </xsl:comment>
         <alias:template match="*" priority="-1">
            <xsl:if test="$mode = 'reject'">
               <alias:copy>
                  <alias:if test="$debug = 'yes'">
                     <alias:attribute name="rule">
                        <alias:text>Not retained</alias:text>
                     </alias:attribute>
                  </alias:if>
                  <alias:copy-of select="@* | *"/>
               </alias:copy>
            </xsl:if>
         </alias:template>
      </alias:stylesheet>
   </xsl:template>

   <!-- Compile the tests -->
   <xsl:template match="reject-rules/test">
      <xsl:variable name="criteria">
         <xsl:apply-templates select="*"/>
      </xsl:variable>
      <alias:template match="marc:record{normalize-space($criteria)}"
         priority="2">
         <xsl:if test="$mode = 'reject'">
            <alias:copy>
               <alias:if test="$debug = 'yes'">
                  <alias:attribute name="rule">
                     <xsl:value-of select="@name"/>
                  </alias:attribute>
               </alias:if>
               <alias:copy-of select="@* | *"/>
            </alias:copy>
         </xsl:if>
      </alias:template>
   </xsl:template>

   <xsl:template match="retain-rules/test">
      <xsl:variable name="criteria">
         <xsl:apply-templates select="*"/>
      </xsl:variable>
      <alias:template match="marc:record{normalize-space($criteria)}"
         priority="1">
         <xsl:if test="$mode = 'retain'">
            <alias:copy>
               <alias:if test="$debug = 'yes'">
                  <alias:attribute name="rule">
                     <xsl:value-of select="@name"/>
                  </alias:attribute>
               </alias:if>
               <alias:copy-of select="@* | *"/>
            </alias:copy>
         </xsl:if>
      </alias:template>
   </xsl:template>

   <xsl:template match="retain-all">
      <xsl:if test="$mode = 'retain'">
         <xsl:comment> Just retain everything else </xsl:comment>
         <alias:template match="*" priority="1">
            <alias:copy-of select="self::node()"/>
         </alias:template>
      </xsl:if>
   </xsl:template>

   <!-- Compile the criteria -->

   <xsl:template match="data-field">
      <xsl:text>[marc:datafield</xsl:text>
      <!-- The xpath test is the concatenation of the following predicates
         which are thus ANDed together -->
      <xsl:apply-templates mode="compile-tag" select="self::node()"/>
      <xsl:apply-templates mode="compile-code" select="self::node()"/>
      <xsl:apply-templates mode="compile-test" select="self::node()"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   
   <xsl:template match="control-field">
      <xsl:text>[marc:controlfield</xsl:text>
      <xsl:apply-templates mode="compile-tag" select="self::node()"/>
      <xsl:apply-templates mode="compile-test" select="self::node()"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   
   <xsl:template match="leader">
      <xsl:text>[marc:leader</xsl:text>
      <xsl:apply-templates mode="compile-test" select="self::node()"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   
   <!-- Compile the @tag into an xpath [predicate] -->
   <xsl:template match="data-field" mode="compile-tag">
      <xsl:choose>
         <xsl:when test="@tag = 'xxx'"/>
         <xsl:when test="substring(@tag,2,2) = 'xx'">
            <xsl:value-of
               select="concat('[starts-with(@tag,', $sq,
               substring(@tag,1,1), $sq, ')]'  )"
            />
         </xsl:when>
         <xsl:when test="substring(@tag,3,1) = 'x'">
            <xsl:value-of
               select="concat('[starts-with(@tag,', $sq,
               substring(@tag,1,2), $sq, ')]'  )"
            />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('[@tag = ', $sq,
               @tag, $sq, ']'  )"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- Compile the @test into an xpath [predicate] -->
   <xsl:template match="data-field" mode="compile-test2">
      <xsl:choose>
         <xsl:when test="@test = 'exists'"/>
         <xsl:when test="@test = 'equals'">
            <xsl:value-of select="concat('[ . = ', $sq, ., $sq, ']'  )"/>
         </xsl:when>
         <xsl:when test="@test = 'contains'">
            <xsl:value-of select="concat('[contains( . , ', $sq, .,
               $sq, ')]'  )"/>
         </xsl:when>
         <xsl:when test="@test = 'starts-with'">
            <xsl:value-of select="concat('[starts-with( . , ', $sq, .,
               $sq, ')]'  )"
            />
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="data-field | control-field[@tag &lt; '006']" 
      mode="compile-test">
      <xsl:variable name="test" select="@test"/>
      <xsl:if test="@test != 'exists'">
         <xsl:text>[</xsl:text>
         <xsl:for-each select="text">
            <xsl:if test="position() != 1"> or </xsl:if>
            <xsl:choose>
               <xsl:when test="../@test = 'equals'">
                  <xsl:value-of select="concat(' . = ', $sq, ., $sq  )"/>
               </xsl:when>
               <xsl:when test="../@test = 'contains'">
                  <xsl:value-of select="concat('contains( . , ', $sq, .,
                     $sq, ')'  )"
                  />
               </xsl:when>
               <xsl:when test="../@test = 'starts-with'">
                  <xsl:value-of
                     select="concat('starts-with( . , ', $sq, .,
                     $sq, ')'  )"/>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
         <xsl:text>]</xsl:text>
      </xsl:if>
   </xsl:template>
   
   <!-- Compile the @code into an xpath [predicate] -->
   <xsl:template match="data-field" mode="compile-code">
      <xsl:choose>
         <xsl:when test="@code = ''">
            <!-- No output; we match in the . string for the whole
               record -->
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of
               select="concat('/marc:subfield[contains(', $sq,
               @code, $sq, ', @code)]'  )"
            />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- Compile the @tag into an xpath [predicate] -->
   <xsl:template match="control-field" mode="compile-tag">
      <xsl:value-of select="concat('[@tag = ', $sq,
         @tag, $sq, ']'  )"/>
   </xsl:template>
   
   <!-- Compile @test, @position, and @length into an xpath [predicate] 
      Add 1 to @position since MARC counts positions from 0 -->
   <xsl:template match="control-field[@tag > '005'] | leader" mode="compile-test">
      <xsl:choose>
         <xsl:when test="@test = 'exists'">
            <xsl:value-of
               select="concat('[normalize-space(substring( . ,',
               @position+1, ',', @length, ')) != ', $sq, 
               substring('      ', 1, @length),  $sq, ']'  )"
            />
         </xsl:when>
         <xsl:when test="@test = 'equals'">
            <xsl:text>[</xsl:text>
            <xsl:for-each select="text">
               <xsl:if test="position() != 1"> or </xsl:if>
               <xsl:value-of
                  select="concat('substring( . ,', ../@position+1,
                  ',', ../@length, ') = ', $sq, ., $sq )"
               />
            </xsl:for-each>
            <xsl:text>]</xsl:text>
         </xsl:when>
      </xsl:choose>
      <!-- attribute tag { xsd:string {pattern='[0-9][0-9][0-9]'} },
         attribute position { xsd:unsignedByte },
         attribute length { xsd:unsignedByte },
         attribute test { "exists" | "equals" }, -->
   </xsl:template>
   
</xsl:stylesheet>
