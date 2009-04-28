<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:alias="AliasForXSLT" xmlns:marc="http://www.loc.gov/MARC21/slim"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="xml"/>
   <xsl:variable name="sq">'</xsl:variable>
   <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="alias"/>
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

   <xsl:template match="data-field | control-field[@tag != '008']" mode="compile-test">
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
   <!-- Compile @test, @position, and @length into an xpath [predicate] -->
   <xsl:template match="control-field[@tag='008'] | leader" mode="compile-test">
      <xsl:choose>
         <xsl:when test="@test = 'exists'">
            <xsl:value-of
               select="concat('[normalize-space(substring( . ,', @position,
               ',', @length, ')) != ', $sq, ' ', $sq, ']'  )"
            />
         </xsl:when>
         <xsl:when test="@test = 'equals'">
            <xsl:text>[</xsl:text>
            <xsl:for-each select="text">
               <xsl:if test="position() != 1"> or </xsl:if>
               <xsl:value-of
                  select="concat('substring( . ,', ../@position,
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
