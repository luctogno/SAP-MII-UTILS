<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output indent="no" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="/Rowsets">
		<xsl:text>{</xsl:text>
		<xsl:apply-templates select="*"/>
		<xsl:text>}</xsl:text>
	</xsl:template>
	<!-- Object or Element Property -->
	<xsl:template match="*">
		<xsl:text>"</xsl:text>
		<xsl:value-of select="name()"/>
		<xsl:text>":</xsl:text>
		<xsl:call-template name="Properties"/>
	</xsl:template>
	<xsl:template match="Rowset">
		<xsl:text>"Rows":[</xsl:text>
		<xsl:call-template name="PropertiesRow"/>
		<xsl:text>]</xsl:text>
		<xsl:if test="following-sibling::*">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- Object Properties -->
	<xsl:template name="PropertiesRow">
		<xsl:apply-templates mode="ArrayElement" select="Row"/>
	</xsl:template>
	
	<!-- find element start with LIST 
	<xsl:template match="*[starts-with(name(), 'LIST_')]">
		<xsl:text>"</xsl:text>
		<xsl:value-of select="name()"/>
		<xsl:text>"</xsl:text>
		<xsl:text>:[</xsl:text>
		<xsl:call-template name="PropertiesList"/>
		<xsl:text>]</xsl:text>
		<xsl:if test="following-sibling::*">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template> -->
	
	<!-- find element start with LIST and have a child with name Rowset-->
	<xsl:template match="*[starts-with(name(), 'LIST_')]">
		<xsl:text>"</xsl:text>
		<xsl:value-of select="name()"/>
		<xsl:text>"</xsl:text>
		<xsl:text>:[</xsl:text>
		<xsl:choose>
			<xsl:when test="name(*[*]) = 'Rowset'">
				<xsl:call-template name="PropertiesNestedObject" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="PropertiesList"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>]</xsl:text>
		<xsl:if test="following-sibling::*">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- List Properties -->
	<xsl:template name="PropertiesList">
		<xsl:apply-templates mode="ArrayElement" select="*[*]"/>
	</xsl:template>
	
		<!-- List PropertiesNestedObject -->
	<xsl:template name="PropertiesNestedObject">
		<xsl:apply-templates mode="ArrayElement" select="*/Row"/>
	</xsl:template>
	
	<!-- Array Element -->
	<xsl:template match="*" mode="ArrayElement">
		<xsl:call-template name="Properties"/>
	</xsl:template>
	
	<!-- Object Properties -->
	<xsl:template name="Properties">
		<xsl:variable name="childName" select="name(*[1])"/>
		<xsl:choose>
			<xsl:when test="not(*)">
				<xsl:text>"</xsl:text>
				<xsl:call-template name="escapeQuote"/>
				<xsl:text>"</xsl:text>
			</xsl:when>
			<xsl:when test="count(*[name()=$childName]) &gt; 1">
				<xsl:text>{"</xsl:text>
				<xsl:value-of select="$childName"/>
				<xsl:text>":[</xsl:text>
				<xsl:apply-templates mode="ArrayElement" select="*"/>
				<xsl:text>]}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>{</xsl:text>
				<xsl:apply-templates select="*"/>
				<xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="following-sibling::*">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="escapeQuote">
		<xsl:param name="pText" select="."/>
		<xsl:if test="string-length($pText) >0">
			<xsl:value-of select= "substring-before(concat($pText, '&quot;'), '&quot;')"/>
			<xsl:if test="contains($pText, '&quot;')">
				<xsl:text>\"</xsl:text>
				<xsl:call-template name="escapeQuote">
					<xsl:with-param name="pText" select= "substring-after($pText, '&quot;')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- Attribute Property -->
	<xsl:template match="@*">
		<xsl:text>"@</xsl:text>
		<xsl:value-of select="name()"/>
		<xsl:text>":"</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>",</xsl:text>
	</xsl:template>
</xsl:stylesheet>
