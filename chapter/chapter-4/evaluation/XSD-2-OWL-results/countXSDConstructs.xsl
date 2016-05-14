<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- XSLT processor: Saxon (Saxon-B 9.1.0.8) -->

<xsl:stylesheet 
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:saxon="http://saxon.sf.net/" 
    extension-element-prefixes="saxon"
    xmlns:guid="java:GUID" 
    xmlns:writeRDF="java:WriteRDF" 
    xmlns:XML2RDF="XML2RDF">

	<!--<xsl:output version="1.0" encoding="ISO-8859-1"/>-->

	<xsl:variable name="XMLSchemaNamespacePrefix"><xsl:text>xs</xsl:text></xsl:variable>
	
	<xsl:template match="/">
	
		<xsl:text disable-output-escaping="yes"><![CDATA[
		]]></xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[
		]]></xsl:text>
		
		<!--<xsl:value-of select="current-dateTime()"/>-->
		
		<!-- all XSD constructs -->
		<xsl:variable name="xpath">//<xsl:value-of select="$XMLSchemaNamespacePrefix"/>:*</xsl:variable>
		<xsl:text disable-output-escaping="yes"><![CDATA[
		]]></xsl:text>
<xsl:text>all XSD constructs: </xsl:text><xsl:value-of select="count(saxon:evaluate($xpath))"/>
	
		<!-- element -->
		<xsl:variable name="xpath">//<xsl:value-of select="$XMLSchemaNamespacePrefix"/>:element</xsl:variable>
		<xsl:text disable-output-escaping="yes"><![CDATA[
		]]></xsl:text>
<xsl:text>element: </xsl:text><xsl:value-of select="count(saxon:evaluate($xpath))"/>
	
		<!-- complexType -->
		<xsl:variable name="xpath">//<xsl:value-of select="$XMLSchemaNamespacePrefix"/>:complexType</xsl:variable>
		<xsl:text disable-output-escaping="yes"><![CDATA[
		]]></xsl:text>
<xsl:text>complexType: </xsl:text><xsl:value-of select="count(saxon:evaluate($xpath))"/>
		
	</xsl:template>
	
</xsl:stylesheet>
