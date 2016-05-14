<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- purpose: -->
	<!-- generic creation of generated ontologies based on any XML Schemas -->

<!-- XSLT processor: -->
	<!-- Saxon (Saxon-B 9.1.0.8) [saxon:evaluate(); <saxon:call-template name="{$tname}"/>] -->

<!-- XSLT stylesheet version: 2.0 -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon">
	<!-- xml declaration: -->
		<!-- - XML version -->
		<!-- - character set, the encoding of the RDF document's content -->
		<xsl:output version="1.0" encoding="ISO-8859-1"/>
		
	<!-- parameters: -->
		<xsl:param name="localOntologyIRIUserDefined"/>
		<!-- relative path of input XML Schemas (separated by '/' and ending with '/') [default: 'XMLSchemas/']: -->
		<xsl:param name="relativePathInputXMLSchemas">XMLSchemas/</xsl:param>
	
	<!-- global variables: -->
	
		<!-- XML Schema namespace prefix: -->
			<!-- letters before the colon of the input XML Schema's root element information item 'schema' -->
			<xsl:variable name="XMLSchemaNamespacePrefix">
				<xsl:variable name="rootElement" select="name(/*)"/>
				<xsl:value-of select="substring-before($rootElement, ':')"/>
			</xsl:variable>
		
		<!-- base ontology IRI: -->
			<xsl:variable name="baseOntologyIRI">http://www.semanticweb.org/ontologies/XMLSchemaOntologies</xsl:variable>
		
		<!-- local ontology IRI: -->
			<xsl:variable name="localOntologyIRI">
				<xsl:call-template name="getLocalOntologyIRI"/>
			</xsl:variable>
			
		<!-- local ontology version IRI: -->
			<xsl:variable name="localOntologyVersionIRI">1.0.0</xsl:variable>
	
	<xsl:template match="/">
	<!-- template for the document node representing the input XML Schema -->
	
		<!-- RDF document header information: -->
			<!-- xml declaration (see above) -->
			<xsl:call-template name="documentTypeDeclaration"/>
			<xsl:call-template name="rdfDocumentHeader"/>
			<xsl:call-template name="owlDocumentHeader"/>
		
		<xsl:call-template name="ontologyDefinition"/>
		
		<xsl:call-template name="rdfDocumentEnd"/>
		
	</xsl:template>
	
	<!-- local ontology IRI: -->
	
		<!-- 1. target namespace of input XML Schema -->
		<!-- 2. user-defined local ontology IRI (input parameter) -->
		<!-- 3. file name of input XML Schema -->
		<xsl:template name="getLocalOntologyIRI">
		
			<xsl:variable name="xpath">//<xsl:value-of select="$XMLSchemaNamespacePrefix"/>:schema/@targetNamespace</xsl:variable>
			<xsl:variable name="targetNamespaceInputXMLSchema" select="saxon:evaluate($xpath)"/>
			
			<xsl:choose>
				<!-- 1. target namespace of input XML Schema -->
				<xsl:when test="string-length($targetNamespaceInputXMLSchema)>0">
					<xsl:value-of select="$targetNamespaceInputXMLSchema"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<!-- 2. user-defined local ontology IRI (parameter) -->
						<xsl:when test="string-length($localOntologyIRIUserDefined)>0">
							<xsl:value-of select="$localOntologyIRIUserDefined"/>
						</xsl:when>
						<!-- 3. file name of input XML Schema -->
						<xsl:otherwise>
							<xsl:variable name="fileNameInputXMLSchema">
								<xsl:call-template name="getFileNameInputXMLSchema">
									<xsl:with-param name="filePathInputXMLSchema" select="base-uri()"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$fileNameInputXMLSchema"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:template>
	
	<xsl:template name="getFileNameInputXMLSchema">
	
		<xsl:param name="filePathInputXMLSchema"/>
		
		<xsl:choose>
			<xsl:when test="contains($filePathInputXMLSchema, '/')">
				<xsl:call-template name="getFileNameInputXMLSchema">
					<xsl:with-param name="filePathInputXMLSchema">
						<xsl:value-of select="substring-after($filePathInputXMLSchema, '/')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="fileNameInputXMLSchema">
					<xsl:value-of select="substring-before($filePathInputXMLSchema, '.')"/>
				</xsl:variable>
				<xsl:value-of select="$fileNameInputXMLSchema"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!-- document type declaration: -->
	<xsl:template name="documentTypeDeclaration">
	<!-- The document type declaration contains internal entity declarations specifying abbreviations for long namespace URI strings used in the RDF document -->
	
		<!-- to suppress the regular behavior of the parser escaping particular characters in the serialization process of the text node -->
		<xsl:text disable-output-escaping="yes"><![CDATA[	

<!DOCTYPE rdf:RDF [
	<!ENTITY owl "http://www.w3.org/2002/07/owl#" >
	<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#" >
	<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#" >
	<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
	<!ENTITY XMLSchemaMetamodelOntology "]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/XMLSchemaMetamodelOntology.owl#" >
]>
]]></xsl:text>

	</xsl:template>
	
	<!-- RDF document header: -->
	<xsl:template name="rdfDocumentHeader">
	<!-- The RDF document header defines the default namespace of the RDF document, the base URL, as well as the XML Schema, RDF, RDFS, OWL, and the XML Schema Metamodel Ontology's namespace prefixes -->
	
		<xsl:text disable-output-escaping="yes"><![CDATA[	
<rdf:RDF 
     xmlns="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/]]></xsl:text>
		<xsl:value-of select="$localOntologyIRI"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[.owl#"
	 xml:base="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/]]></xsl:text>
		<xsl:value-of select="$localOntologyIRI"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[.owl"
	 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	 xmlns:owl="http://www.w3.org/2002/07/owl#"
	 xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	 xmlns:XSDMetamodelOntology="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/XMLSchemaMetamodelOntology.owl#">
]]></xsl:text>

	</xsl:template>
	
	<!-- OWL document header: -->
	<xsl:template name="owlDocumentHeader">
	<!-- - ontology IRI: -->
	<!--   <base ontology IRI>/<local ontology IRI>.owl -->
	<!--   The ontology IRI is used to identify the ontology in the context of the WWW. The ontology IRI represents the URL where the latest version of the ontology is published -->
	<!-- - ontology version IRI: -->
	<!--   <base ontology IRI>/<local ontology IRI>:<local ontology version IRI>.owl -->
	<!--   The ontology version IRI represents the URL where a given version of the ontology is published  -->
	<!-- - import of XML Schema Metamodel Ontology's classes, datatype properties, object properties, and class axioms -->
	
		<xsl:text disable-output-escaping="yes"><![CDATA[	
	<owl:Ontology rdf:about="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/]]></xsl:text>
		<xsl:value-of select="$localOntologyIRI"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[.owl">
		<owl:versionIRI rdf:resource="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/]]></xsl:text>
		<xsl:value-of select="$localOntologyIRI"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[:]]></xsl:text>
		<xsl:value-of select="$localOntologyVersionIRI"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[.owl"/>
		<owl:imports rdf:resource="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/XMLSchemaMetamodelOntology:1.0.0.owl"/>
	</owl:Ontology>
]]></xsl:text>

	</xsl:template>
	
	<xsl:template name="rdfDocumentEnd">
	
		<xsl:text disable-output-escaping="yes"><![CDATA[	
</rdf:RDF>
]]></xsl:text>

	</xsl:template>
	
	<xsl:template name="ontologyDefinition">
	<!-- This template serves as starting point to traverse the XML Schema's document tree in order to implement the mappings between the input XML Schema and the generated ontology beginning with the XML Schema's root element 'schema' -->
	
		<xsl:text disable-output-escaping="yes"><![CDATA[	
	
	<!-- 
    ///////////////////////////////////////////////////////////////////////////////////////
    //
    // Classes
    //
    ///////////////////////////////////////////////////////////////////////////////////////
     -->]]></xsl:text>
     
		<!-- each element information item located in the input XML Schema is mapped to the generated ontology by calling a template named according to the appropriate XML Schema Metamodel Ontology's super-class representing the corresponding meta-element information item  -->
		<!-- as the element information item 'schema' is always the root element of any XML Schema, the template 'Schema' is called first -->
		<xsl:variable name="xpath"><xsl:value-of select="$XMLSchemaNamespacePrefix"/>:schema</xsl:variable>
		<xsl:for-each select="saxon:evaluate($xpath)">
			<!-- -> new sequence containing the actual context nodes -->
			
			<!-- the template named after the range meta-element information item is invoked recursively in order to define each range element information item of the given meta-element informartion item -->
			<saxon:call-template name="Schema">
				<xsl:with-param name="domainMetaElementInformationItem">Schema</xsl:with-param>
				<!-- naming convention of element information items 'schema': -->
				<!-- <local ontology IRI>-Schema (e.g. ddi:reusable:3_1-Schema) -->
				<xsl:with-param name="domainElementInformationItem"><xsl:value-of select="$localOntologyIRI"/>-Schema</xsl:with-param>
			</saxon:call-template>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="Schema">
	<!-- after invoicing the template 'Schema', the XML Schema's root element is located at the actual position of the process traversing the XML Schema's document tree -->
	<!-- At this time, the root element stands for the actual domain element information item, which may include multiple range element information items as content -->
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		<!-- the identifier of the current domain element information item is built recursively and hierarchically containing all the ancestor element information items -->
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- attributeFormDefault_Schema_String -->
			<!-- 0 - 1 attributeFormDefault -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">attributeFormDefault_Schema_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@attributeFormDefault"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- blockDefault_Schema_String -->
			<!-- 0 - 1 blockDefault -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">blockDefault_Schema_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@blockDefault"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- elementFormDefault_Schema_String -->
			<!-- 0 - 1 elementFormDefault -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">elementFormDefault_Schema_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@elementFormDefault"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- finalDefault_Schema_String -->
			<!-- 0 - 1 finalDefault -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">finalDefault_Schema_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@finalDefault"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_Schema_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Schema_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- targetNamespace_Schema_String -->
			<!-- 0 - 1 targetNamespace -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">targetNamespace_Schema_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@targetNamespace"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- version_Schema_String -->
			<!-- 0 - 1 version -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">version_Schema_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@version"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- xml:lang_Schema_String -->
			<!-- 0 - 1 xml:lang -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">xml:lang_Schema_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@xml:lang"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
		
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Schema_Include -->
				<!-- 0 - n Include -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_Include</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_Import -->
				<!-- 0 - n Import -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_Import</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_Redefine -->
				<!-- 0 - n Redefine -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_Redefine</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_Annotation -->
				<!-- 0 - n Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_SimpleType -->
				<!-- 0 - n SimpleType -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_SimpleType</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_ComplexType -->
				<!-- 0 - n ComplexType -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_ComplexType</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_Group -->
				<!-- 0 - n Group -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_Group</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_AttributeGroup -->
				<!-- 0 - n AttributeGroup -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_AttributeGroup</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_Element -->
				<!-- 0 - n Element -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_Element</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_Attribute -->
				<!-- 0 - n Attribute -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_Attribute</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Schema_Notation -->
				<!-- 0 - n Notation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Schema_Notation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
		
		<!-- Element information items may contain other element information items. Part-of-relationships have been defined as object properties _contains_<domain meta-element information item>_<range meta-element information item>_ in the XML Schema Metamodel Ontology. Containing element information items are in the domain of these object properties, contained element information items in the range --> 	
		<!-- After the mapping of the actual domain element information item to an equivalent class of the generated ontology, the contained range element information items have to be defined -->	
		
			<!-- contains_Schema_Include -->
			<!-- 0 - n Include -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_Include</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_Import -->
			<!-- 0 - n Import -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_Import</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_Redefine -->
			<!-- 0 - n Redefine -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_Redefine</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_Annotation -->
			<!-- 0 - n Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_SimpleType -->
			<!-- 0 - n SimpleType -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_SimpleType</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_ComplexType -->
			<!-- 0 - n ComplexType -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_ComplexType</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_Group -->
			<!-- 0 - n Group -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_Group</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_AttributeGroup -->
			<!-- 0 - n AttributeGroup -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_AttributeGroup</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_Element -->
			<!-- 0 - n Element -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_Element</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_Attribute -->
			<!-- 0 - n Attribute -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_Attribute</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Schema_Notation -->
			<!-- 0 - n Notation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Schema_Notation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
		
	</xsl:template>
	
	<xsl:template name="Include">
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties .......... -->
		<!-- id_Import_String -->
		<!-- 0 - 1 id -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">id_Import_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@id"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- schemaLocation_Import_String -->
		<!-- 1 schemaLocation -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">schemaLocation_Import_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@schemaLocation"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties ..... -->
		<!-- universal restrictions on object properties .......... -->
		<!-- contained range element information items (-> definition of range element information items) .......... -->
		<!-- contains_Include_Annotation -->
		<!-- 0 - 1 Annotation -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_Include_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contained range element information items (-> definition of range element information items) ..... -->
		<!-- universal restrictions on object properties ..... -->
		<xsl:call-template name="classDefinitionEnd"/>
		<!-- definition of range element information items .......... -->
		<!-- contains_Include_Annotation -->
		<!-- 0 - 1 Annotation -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_Include_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- definition of range element information items ..... -->
	</xsl:template>
	<xsl:template name="Import">
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties .......... -->
		<!-- id_Import_String -->
		<!-- 0 - 1 id -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">id_Import_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@id"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- namespace_Import_String -->
		<!-- 0 - 1 namespace -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">namespace_Import_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@namespace"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- schemaLocation_Import_String -->
		<!-- 0 - 1 schemaLocation -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">schemaLocation_Import_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@schemaLocation"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties ..... -->
		<!-- universal restrictions on object properties .......... -->
		<!-- contained range element information items (-> definition of range element information items) .......... -->
		<!-- contains_Import_Annotation -->
		<!-- 0 - n Annotation -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_Import_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contained range element information items (-> definition of range element information items) ..... -->
		<!-- universal restrictions on object properties ..... -->
		<xsl:call-template name="classDefinitionEnd"/>
		<!-- definition of range element information items .......... -->
		<!-- contains_Import_Annotation -->
		<!-- 0 - n Annotation -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_Import_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- definition of range element information items ..... -->
	</xsl:template>
	<xsl:template name="Redefine">
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties .......... -->
		<!-- id_Redefine_String -->
		<!-- 0 - 1 id -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">id_Redefine_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@id"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- schemaLocation_Redefine_String -->
		<!-- 0 - 1 schemaLocation -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">schemaLocation_Redefine_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@schemaLocation"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties ..... -->
		<!-- universal restrictions on object properties .......... -->
		<!-- contained range element information items (-> definition of range element information items) .......... -->
		<!-- contains_Redefine_Annotation -->
		<!-- 0 - n Annotation -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_Redefine_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Redefine_SimpleType -->
		<!-- 0 - n SimpleType -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_Redefine_SimpleType</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Redefine_ComplexType -->
		<!-- 0 - n ComplexType -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_Redefine_ComplexType</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Redefine_Group -->
		<!-- 0 - n Group -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_Redefine_Group</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Redefine_AttributeGroup -->
		<!-- 0 - n AttributeGroup -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_Redefine_AttributeGroup</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contained range element information items (-> definition of range element information items) ..... -->
		<!-- universal restrictions on object properties ..... -->
		<xsl:call-template name="classDefinitionEnd"/>
		<!-- definition of range element information items .......... -->
		<!-- contains_Redefine_Annotation -->
		<!-- 0 - n Annotation -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_Redefine_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Redefine_SimpleType -->
		<!-- 0 - n SimpleType -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_Redefine_SimpleType</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Redefine_ComplexType -->
		<!-- 0 - n ComplexType -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_Redefine_ComplexType</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Redefine_Group -->
		<!-- 0 - n Group -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_Redefine_Group</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Redefine_AttributeGroup -->
		<!-- 0 - n AttributeGroup -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_Redefine_AttributeGroup</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- definition of range element information items ..... -->
	</xsl:template>
	<xsl:template name="Annotation">
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties .......... -->
		<!-- id_Annotation_String -->
		<!-- 0 - 1 id -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">id_Annotation_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@id"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties ..... -->
		<!-- universal restrictions on object properties .......... -->
		<!-- contained range element information items (-> definition of range element information items) .......... -->
		<!-- contains_Annotation_Appinfo -->
		<!-- 0 - n Appinfo -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_Annotation_Appinfo</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Annotation_Documentation -->
		<!-- 0 - n Documentation -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_Annotation_Documentation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contained range element information items (-> definition of range element information items) ..... -->
		<!-- universal restrictions on object properties ..... -->
		<xsl:call-template name="classDefinitionEnd"/>
		<!-- definition of range element information items .......... -->
		<!-- contains_Annotation_Appinfo -->
		<!-- 0 - n Appinfo -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_Annotation_Appinfo</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_Annotation_Documentation -->
		<!-- 0 - n Documentation -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_Annotation_Documentation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- definition of range element information items ..... -->
	</xsl:template>
	<xsl:template name="SimpleType">
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties .......... -->
		<!-- final_SimpleType_String -->
		<!-- 0 - 1 final -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">final_SimpleType_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@final"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- id_SimpleType_String -->
		<!-- 0 - 1 id -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">id_SimpleType_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@id"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- name_SimpleType_String -->
		<!-- 1 name -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">name_SimpleType_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@name"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties ..... -->
		<!-- universal restrictions on object properties .......... -->
		<!-- contained range element information items (-> definition of range element information items) .......... -->
		<!-- contains_SimpleType_Annotation -->
		<!-- 0 - 1 SimpleType -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_SimpleType_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_SimpleType_Restriction -->
		<!-- 0 - 1 Restriction -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_SimpleType_Restriction</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_SimpleType_List -->
		<!-- 0 - 1 List -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_SimpleType_List</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_SimpleType_Union -->
		<!-- 0 - 1 Union -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_SimpleType_Union</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contained range element information items (-> definition of range element information items) ..... -->
		<!-- universal restrictions on object properties ..... -->
		<xsl:call-template name="classDefinitionEnd"/>
		<!-- definition of range element information items .......... -->
		<!-- contains_SimpleType_Annotation -->
		<!-- 0 - 1 SimpleType -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_SimpleType_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_SimpleType_Restriction -->
		<!-- 0 - 1 Restriction -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_SimpleType_Restriction</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_SimpleType_List -->
		<!-- 0 - 1 List -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_SimpleType_List</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_SimpleType_Union -->
		<!-- 0 - 1 Union -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_SimpleType_Union</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- definition of range element information items ..... -->
	</xsl:template>
	<xsl:template name="ComplexType">
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		<!-- test cases -->
		<!--<xsl:if test="./@name='NameType'">-->
		<!--<xsl:if test="./@name='InternationalStringType'">-->
		<!--<xsl:if test="./@name='ComplexType_1'">-->
		<!--<xsl:if test="./@name='HistoricalDateType'">-->
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties .......... -->
		<!-- abstract_ComplexType_String -->
		<!-- 0 - 1 abstract -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">abstract_ComplexType_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@abstract"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- block_ComplexType_String -->
		<!-- 0 - 1 block -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">block_ComplexType_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@block"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- final_ComplexType_String -->
		<!-- 0 - 1 final -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">final_ComplexType_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@final"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- id_ComplexType_String -->
		<!-- 0 - 1 id -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">id_ComplexType_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@id"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- mixed_ComplexType_String -->
		<!-- 0 - 1 mixed -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">mixed_ComplexType_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@mixed"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- name_ComplexType_String -->
		<!-- 1 name -->
		<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
			<xsl:with-param name="datatypeProperty">name_ComplexType_String</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="hasValueRestriction" select="./@name"/>
			<!-- adapt! -->
		</xsl:call-template>
		<!-- hasValue restrictions on datatype properties ..... -->
		<!-- universal restrictions on object properties .......... -->
		<!-- contained range element information items (-> definition of range element information items) .......... -->
		<!-- contains_ComplexType_Annotation -->
		<!-- 0 - 1 Annotation -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_SimpleContent -->
		<!-- 0 - 1 SimpleContent -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_SimpleContent</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_ComplexContent -->
		<!-- 0 - 1 ComplexContent -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_ComplexContent</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_Group -->
		<!-- 0 - 1 Group -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_Group</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_All -->
		<!-- 0 - 1 All -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_All</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_Choice -->
		<!-- 0 - 1 Choice -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_Choice</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_Sequence -->
		<!-- 0 - 1 Sequence -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_Sequence</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_Attribute -->
		<!-- 0 - n Attribute -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_Attribute</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_AttributeGroup -->
		<!-- 0 - n AttributeGroup -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_AttributeGroup</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_AnyAttribute -->
		<!-- 0 - 1 AnyAttribute -->
		<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
			<xsl:with-param name="objectProperty">contains_ComplexType_AnyAttribute</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contained range element information items (-> definition of range element information items) ..... -->
		<!-- universal restrictions on object properties ..... -->
		<xsl:call-template name="classDefinitionEnd"/>
		<!-- definition of range element information items .......... -->
		<!-- contains_ComplexType_Annotation -->
		<!-- 0 - 1 Annotation -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_Annotation</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_SimpleContent -->
		<!-- 0 - 1 SimpleContent -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_SimpleContent</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_ComplexContent -->
		<!-- 0 - 1 ComplexContent -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_ComplexContent</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_Group -->
		<!-- 0 - 1 Group -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_Group</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_All -->
		<!-- 0 - 1 All -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_All</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_Choice -->
		<!-- 0 - 1 Choice -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_Choice</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_Sequence -->
		<!-- 0 - 1 Sequence -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_Sequence</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_Attribute -->
		<!-- 0 - n Attribute -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_Attribute</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_AttributeGroup -->
		<!-- 0 - n AttributeGroup -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_AttributeGroup</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- contains_ComplexType_AnyAttribute -->
		<!-- 0 - 1 AnyAttribute -->
		<xsl:call-template name="rangeElementInformationItemsDefinition">
			<xsl:with-param name="objectProperty">contains_ComplexType_AnyAttribute</xsl:with-param>
			<!-- adapt! -->
			<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
		</xsl:call-template>
		<!-- definition of range element information items ..... -->
		<!--</xsl:if>-->
	</xsl:template>
	
	<xsl:template name="Group">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Group_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Group_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- maxOccurs_Group_String -->
			<!-- 0 - 1 maxOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">maxOccurs_Group_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@maxOccurs"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- minOccurs_Group_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">minOccurs_Group_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@minOccurs"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- name_Group_String -->
			<!-- 0 - 1 name -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">name_Group_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@name"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
		
			<!-- no contained range element information items (-> no definition of range element information items) -->
			
				<!-- ref_Group_Group -->
				<!-- 0 - 1 ref -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">ref_Group_Group</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@ref"/><!-- adapt! -->
				</xsl:call-template>
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Group_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Group_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Group_All -->
				<!-- 0 - 1 All -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Group_All</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Group_Choice -->
				<!-- 0 - 1 Choice -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Group_Choice</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Group_Sequence -->
				<!-- 0 - 1 Sequence -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Group_Sequence</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
		
			<!-- contains_Group_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Group_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Group_All -->
			<!-- 0 - 1 All -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Group_All</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Group_Choice -->
			<!-- 0 - 1 Choice -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Group_Choice</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Group_Sequence -->
			<!-- 0 - 1 Sequence -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Group_Sequence</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
		
	</xsl:template>
	
	<xsl:template name="AttributeGroup">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_AttributeGroup_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_AttributeGroup_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- name_AttributeGroup_String -->
			<!-- 0 - 1 name -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">name_AttributeGroup_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@name"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
		
			<!-- no contained range element information items (-> no definition of range element information items) -->
			
				<!-- ref_AttributeGroup_AttributeGroup -->
				<!-- 0 - 1 ref -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">ref_AttributeGroup_AttributeGroup</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@ref"/><!-- adapt! -->
				</xsl:call-template>
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_AttributeGroup_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_AttributeGroup_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_AttributeGroup_Attribute -->
				<!-- 0 - n Attribute -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_AttributeGroup_Attribute</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_AttributeGroup_AttributeGroup -->
				<!-- 0 - n AttributeGroup -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_AttributeGroup_AttributeGroup</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_AttributeGroup_AnyAttribute -->
				<!-- 0 - 1 AnyAttribute -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_AttributeGroup_AnyAttribute</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_AttributeGroup_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_AttributeGroup_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_AttributeGroup_Attribute -->
			<!-- 0 - n Attribute -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_AttributeGroup_Attribute</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_AttributeGroup_AttributeGroup -->
			<!-- 0 - n AttributeGroup -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_AttributeGroup_AttributeGroup</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_AttributeGroup_AnyAttribute -->
			<!-- 0 - 1 AnyAttribute -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_AttributeGroup_AnyAttribute</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
		
	</xsl:template>
	
	<xsl:template name="Element">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- abstract_Element_String -->
			<!-- 0 - 1 abstract -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">abstract_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@abstract"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- block_Element_String -->
			<!-- 0 - 1 block -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">block_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@block"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- default_Element_String -->
			<!-- 0 - 1 default -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">default_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@default"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- final_Element_String -->
			<!-- 0 - 1 final -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">final_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@final"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- fixed_Element_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- form_Element_String -->
			<!-- 0 - 1 form -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">form_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@form"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_Element_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- maxOccurs_Element_String -->
			<!-- 0 - 1 maxOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">maxOccurs_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@maxOccurs"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- minOccurs_Element_String -->
			<!-- 0 - 1 minOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">minOccurs_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@minOccurs"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- name_Element_String -->
			<!-- 0 - 1 name -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">name_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@name"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- nillable_Element_String -->
			<!-- 0 - 1 nillable -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">nillable_Element_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@nillable"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
		
			<!-- no contained range element information items (-> no definition of range element information items) -->
			
				<!-- ref_Element_Element -->
				<!-- 0 - 1 ref -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">ref_Element_Element</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@ref"/><!-- adapt! -->
				</xsl:call-template>
				
				<!-- substitutionGroup_Element_Element -->
				<!-- 0 - 1 substitutionGroup -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">substitutionGroup_Element_Element</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@substitutionGroup"/><!-- adapt! -->
				</xsl:call-template>
				
				<!-- type_Element_Type -->
				<!-- 0 - 1 type -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">type_Element_Type</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@type"/><!-- adapt! -->
				</xsl:call-template>
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Element_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Element_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Element_SimpleType -->
				<!-- 0 - 1 SimpleType -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Element_SimpleType</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Element_ComplexType -->
				<!-- 0 - 1 ComplexType -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Element_ComplexType</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Element_Unique -->
				<!-- 0 - n Unique -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Element_Unique</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Element_Key -->
				<!-- 0 - n Key -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Element_Key</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Element_Keyref -->
				<!-- 0 - n Keyref -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Element_Keyref</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Element_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Element_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Element_SimpleType -->
			<!-- 0 - 1 SimpleType -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Element_SimpleType</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Element_ComplexType -->
			<!-- 0 - 1 ComplexType -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Element_ComplexType</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Element_Unique -->
			<!-- 0 - n Unique -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Element_Unique</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Element_Key -->
			<!-- 0 - n Key -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Element_Key</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Element_Keyref -->
			<!-- 0 - n Keyref -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Element_Keyref</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>			
		
	</xsl:template>
	
	<xsl:template name="Attribute">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- default_Attribute_String -->
			<!-- 0 - 1 default -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">default_Attribute_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@default"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- fixed_Attribute_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_Attribute_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- form_Attribute_String -->
			<!-- 0 - 1 form -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">form_Attribute_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@form"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_Attribute_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Attribute_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- name_Attribute_String -->
			<!-- 0 - 1 name -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">name_Attribute_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@name"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- use_Attribute_String -->
			<!-- 0 - 1 use -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">use_Attribute_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@use"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
		
			<!-- no contained range element information items (-> no definition of range element information items) -->
			
				<!-- ref_Attribute_Attribute -->
				<!-- 0 - 1 ref -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">ref_Attribute_Attribute</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@ref"/><!-- adapt! -->
				</xsl:call-template>
				
				<!-- type_Attribute_Type -->
				<!-- 0 - 1 type -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">type_Attribute_Type</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@type"/><!-- adapt! -->
				</xsl:call-template>
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Attribute_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Attribute_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Attribute_SimpleType -->
				<!-- 0 - 1 SimpleType -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Attribute_SimpleType</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Attribute_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Attribute_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Attribute_SimpleType -->
			<!-- 0 - 1 SimpleType -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Attribute_SimpleType</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>			
		
	</xsl:template>
	
<xsl:template name="Notation">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Notation_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Notation_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- name_Notation_String -->
			<!-- 1 name -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">name_Notation_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@name"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- public_Notation_String -->
			<!-- 0 - 1 public -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">public_Notation_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@public"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- system_Notation_String -->
			<!-- 0 - 1 system -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">system_Notation_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@system"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Notation_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Notation_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Notation_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Notation_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>	
		
	</xsl:template>
	
<xsl:template name="Appinfo">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- source_Appinfo_String -->
			<!-- 0 - 1 source -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">source_Appinfo_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@source"/><!-- adapt! -->
			</xsl:call-template>		
			
			<!-- any_Appinfo_String -->
			<!-- 0 - 1 any -->		
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">any_Appinfo_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="."/><!-- adapt! -->
			</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
	</xsl:template>  
	
	<xsl:template name="Documentation">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- source_Documentation_String -->
			<!-- 0 - 1 source -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">source_Documentation_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@source"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- xml:lang_Documentation_String -->
			<!-- 0 - 1 lang -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">xml:lang_Documentation_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@xml:lang"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- any_Documentation_String -->
			<!-- 0 - 1 any -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">any_Documentation_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="."/><!-- adapt! -->
			</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
	</xsl:template>
	
	<xsl:template name="Restriction">
	<!-- restriction for SimpleType, ComplexType/SimpleContent and ComplexType/ComplexContent with differing content -->
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Restriction_String -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Restriction_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
		
			<!-- no contained range element information items (-> no definition of range element information items) -->
			
				<!-- base_Restriction_Type -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">base_Restriction_Type</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@base"/><!-- adapt! -->
				</xsl:call-template>
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Restriction_Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_SimpleType -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_SimpleType</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_MinExclusive -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_MinExclusive</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_MinInclusive -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_MinInclusive</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_MaxExclusive -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_MaxExclusive</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_MaxInclusive -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_MaxInclusive</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_TotalDigits -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_TotalDigits</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_FractionDigits -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_FractionDigits</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_Length -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_Length</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_MinLength -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_MinLength</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_MaxLength -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_MaxLength</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_Enumeration -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_Enumeration</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_WhiteSpace -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_WhiteSpace</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_Pattern -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_Pattern</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_Attribute -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_Attribute</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_AttributeGroup -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_AttributeGroup</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_AnyAttribute -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_AnyAttribute</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_Group -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_Group</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_All -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_All</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_Choice -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_Choice</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Restriction_Sequence -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Restriction_Sequence</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
	
			<!-- contains_Restriction_Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_SimpleType -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_SimpleType</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_MinExclusive -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_MinExclusive</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_MinInclusive -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_MinInclusive</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_MaxExclusive -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_MaxExclusive</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_MaxInclusive -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_MaxInclusive</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_TotalDigits -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_TotalDigits</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_FractionDigits -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_FractionDigits</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_Length -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_Length</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_MinLength -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_MinLength</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_MaxLength -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_MaxLength</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_Enumeration -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_Enumeration</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_WhiteSpace -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_WhiteSpace</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_Pattern -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_Pattern</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>	
		
			<!-- contains_Restriction_Attribute -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_Attribute</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_AttributeGroup -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_AttributeGroup</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_AnyAttribute -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_AnyAttribute</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_Group -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_Group</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_All -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_All</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_Choice -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_Choice</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Restriction_Sequence -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Restriction_Sequence</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>		
		
	</xsl:template>
	
	<xsl:template name="List">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_List_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_List_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
		
			<!-- no contained range element information items (-> no definition of range element information items) -->
			
				<!-- itemType_List_Type -->
				<!-- 0 - 1 itemType -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">itemType_List_Type</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@itemType"/><!-- adapt! -->
				</xsl:call-template>
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_List_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_List_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_List_SimpleType -->
				<!-- 0 - 1 SimpleType -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_List_SimpleType</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_List_SimpleType -->
			<!-- 0 - 1 SimpleType -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_List_SimpleType</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_List_SimpleType -->
			<!-- 0 - 1 SimpleType -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_List_SimpleType</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="Union">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Union_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Union_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
		
			<!-- no contained range element information items (-> no definition of range element information items) -->
			
				<!-- memberTypes_Union_Type -->
				<!-- 0 - 1 memberTypes -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyMemberTypes">
					<xsl:with-param name="objectProperty">memberTypes_Union_Type</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="rangeElementInformationItem" select="./@memberTypes"/><!-- adapt! -->
				</xsl:call-template>
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Union_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Union_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Union_SimpleType -->
				<!-- 0 - 1 SimpleType -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Union_SimpleType</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Union_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Union_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Union_SimpleType -->
			<!-- 0 - 1 SimpleType -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Union_SimpleType</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="SimpleContent">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_SimpleContent_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_SimpleContent_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_SimpleContent_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_SimpleContent_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_SimpleContent_Restriction -->
				<!-- 0 - 1 Restriction -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_SimpleContent_Restriction</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_SimpleContent_Extension -->
				<!-- 0 - 1 Extension -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_SimpleContent_Extension</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_SimpleContent_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_SimpleContent_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_SimpleContent_Restriction -->
			<!-- 0 - 1 Restriction -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_SimpleContent_Restriction</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_SimpleContent_Extension -->
			<!-- 0 - 1 Extension -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_SimpleContent_Extension</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="ComplexContent">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_ComplexContent_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_ComplexContent_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- mixed_ComplexContent_String -->
			<!-- 0 - 1 mixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">mixed_ComplexContent_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@mixed"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_ComplexContent_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_ComplexContent_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_ComplexContent_Restriction -->
				<!-- 0 - 1 Restriction -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_ComplexContent_Restriction</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_ComplexContent_Extension -->
				<!-- 0 - 1 Extension -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_ComplexContent_Extension</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_ComplexContent_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_ComplexContent_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_ComplexContent_Restriction -->
			<!-- 0 - 1 Restriction -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_ComplexContent_Restriction</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_ComplexContent_Extension -->
			<!-- 0 - 1 Extension -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_ComplexContent_Extension</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="All">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_All_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_All_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- maxOccurs_All_String -->
			<!-- 0 - 1 maxOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">maxOccurs_All_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@maxOccurs"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- minOccurs_All_String -->
			<!-- 0 - 1 minOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">minOccurs_All_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@minOccurs"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_All_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_All_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_All_Element -->
				<!-- 0 - n Element -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_All_Element</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_All_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_All_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_All_Element -->
			<!-- 0 - n Element -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_All_Element</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="Choice">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Choice_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Choice_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- maxOccurs_Choice_String -->
			<!-- 0 - 1 maxOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">maxOccurs_Choice_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@maxOccurs"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- minOccurs_Choice_String -->
			<!-- 0 - 1 minOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">minOccurs_Choice_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@minOccurs"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Choice_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Choice_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Choice_Element -->
				<!-- 0 - n Element -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Choice_Element</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Choice_Group -->
				<!-- 0 - n Group -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Choice_Group</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Choice_Choice -->
				<!-- 0 - n Choice -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Choice_Choice</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Choice_Sequence -->
				<!-- 0 - n Sequence -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Choice_Sequence</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Choice_Any -->
				<!-- 0 - 1 Any -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Choice_Any</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Choice_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Choice_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Choice_Element -->
			<!-- 0 - n Element -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Choice_Element</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Choice_Group -->
			<!-- 0 - n Group -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Choice_Group</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Choice_Choice -->
			<!-- 0 - n Choice -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Choice_Choice</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Choice_Sequence -->
			<!-- 0 - n Sequence -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Choice_Sequence</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Choice_Any -->
			<!-- 0 - 1 Any -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Choice_Any</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="Sequence">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Sequence_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Sequence_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- maxOccurs_Sequence_String -->
			<!-- 0 - 1 maxOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">maxOccurs_Sequence_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@maxOccurs"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- minOccurs_Sequence_String -->
			<!-- 0 - 1 minOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">minOccurs_Sequence_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@minOccurs"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- ............... -->
			<!-- sequence -->
			<!--<xsl:call-template name="sequence">
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>-->
				<xsl:call-template name="sequence">
					<xsl:with-param name="objectProperty">sequence</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
			<!-- ..... -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
				
				<!-- contains_Sequence_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Sequence_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Sequence_Element -->
				<!-- 0 - n Element -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Sequence_Element</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Sequence_Group -->
				<!-- 0 - n Group -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Sequence_Group</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Sequence_Choice -->
				<!-- 0 - n Choice -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Sequence_Choice</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Sequence_Sequence -->
				<!-- 0 - n Sequence -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Sequence_Sequence</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Sequence_Any -->
				<!-- 0 - n Any -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Sequence_Any</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Sequence_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Sequence_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Sequence_Element -->
			<!-- 0 - n Element -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Sequence_Element</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Sequence_Group -->
			<!-- 0 - n Group -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Sequence_Group</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Sequence_Choice -->
			<!-- 0 - n Choice -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Sequence_Choice</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Sequence_Sequence -->
			<!-- 0 - n Sequence -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Sequence_Sequence</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Sequence_Any -->
			<!-- 0 - n Any -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Sequence_Any</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="AnyAttribute">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_AnyAttribute_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_AnyAttribute_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- namespace_AnyAttribute_String -->
			<!-- 0 - 1 namespace -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">namespace_AnyAttribute_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@namespace"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- processContents_AnyAttribute_String -->
			<!-- 0 - 1 processContents -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">processContents_AnyAttribute_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@processContents"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_AnyAttribute_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_AnyAttribute_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_AnyAttribute_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_AnyAttribute_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="Unique">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Unique_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Unique_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- name_Unique_String -->
			<!-- 1 name -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">name_Unique_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@name"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Unique_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Unique_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Unique_Selector -->
				<!-- 1 Selector -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Unique_Selector</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Unique_Field -->
				<!-- 1 - n Field -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Unique_Field</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Unique_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Unique_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Unique_Selector -->
			<!-- 1 Selector -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Unique_Selector</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Unique_Field -->
			<!-- 1 - n Field -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Unique_Field</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>

	<xsl:template name="Key">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Key_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Key_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- name_Key_String -->
			<!-- 1 name -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">name_Key_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@name"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Key_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Key_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Key_Selector -->
				<!-- 1 Selector -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Key_Selector</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Key_Field -->
				<!-- 1 - n Field -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Key_Field</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Key_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Key_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Key_Selector -->
			<!-- 1 Selector -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Key_Selector</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Key_Field -->
			<!-- 1 - n Field -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Key_Field</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="Keyref">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Keyref_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Keyref_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- name_Keyref_String -->
			<!-- 1 name -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">name_Keyref_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@name"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- no contained range element information items (-> no definition of range element information items) -->
			
				<!-- refer_Keyref_Type -->
				<!-- 1 refer -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">refer_Keyref_Key</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@refer"/><!-- adapt! -->
				</xsl:call-template>				
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Keyref_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Keyref_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Keyref_Selector -->
				<!-- 1 Selector -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Keyref_Selector</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Keyref_Field -->
				<!-- 1 - n Field -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Keyref_Field</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Keyref_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Keyref_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Keyref_Selector -->
			<!-- 1 Selector -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Keyref_Selector</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Keyref_Field -->
			<!-- 1 - n Field -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Keyref_Field</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>	
	
	<xsl:template name="Extension">
	<!-- extension for ComplexType/SimpleContent and ComplexType/ComplexContent with differing content -->
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Extension_String -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Extension_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
		
			<!-- no contained range element information items (-> no definition of range element information items) -->
			
				<!-- base_Extension_Type -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">base_Extension_Type</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					<xsl:with-param name="rangeElementInformationItem" select="./@base"/><!-- adapt! -->
				</xsl:call-template>
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Extension_Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Extension_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Extension_Attribute -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Extension_Attribute</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Extension_AttributeGroup -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Extension_AttributeGroup</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Extension_AnyAttribute -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Extension_AnyAttribute</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Extension_Group -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Extension_Group</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Extension_All -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Extension_All</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Extension_Choice -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Extension_Choice</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
				
				<!-- contains_Extension_Sequence -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Extension_Sequence</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
	
			<!-- contains_Extension_Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Extension_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Extension_Attribute -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Extension_Attribute</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Extension_AttributeGroup -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Extension_AttributeGroup</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Extension_AnyAttribute -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Extension_AnyAttribute</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Extension_Group -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Extension_Group</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Extension_All -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Extension_All</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Extension_Choice -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Extension_Choice</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
			
			<!-- contains_Extension_Sequence -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Extension_Sequence</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>
		
	</xsl:template>
	
	<xsl:template name="MinExclusive">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_MinExclusive_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_MinExclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_MinExclusive_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_MinExclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_MinExclusive_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_MinExclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_MinExclusive_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_MinExclusive_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_MinExclusive_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_MinExclusive_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="MinInclusive">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_MinInclusive_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_MinInclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_MinInclusive_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_MinInclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_MinInclusive_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_MinInclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_MinInclusive_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_MinInclusive_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_MinInclusive_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_MinInclusive_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="MaxExclusive">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_MaxExclusive_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_MaxExclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_MaxExclusive_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_MaxExclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_MaxExclusive_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_MaxExclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_MaxExclusive_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_MaxExclusive_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_MaxExclusive_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_MaxExclusive_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="MaxInclusive">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_MaxInclusive_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_MaxInclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_MaxInclusive_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_MaxInclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_MaxInclusive_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_MaxInclusive_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_MaxInclusive_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_MaxInclusive_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_MaxInclusive_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_MaxInclusive_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="TotalDigits">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_TotalDigits_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_TotalDigits_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_TotalDigits_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_TotalDigits_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_TotalDigits_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_TotalDigits_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_TotalDigits_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_TotalDigits_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_TotalDigits_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_TotalDigits_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="FractionDigits">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_FractionDigits_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_FractionDigits_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_FractionDigits_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_FractionDigits_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_FractionDigits_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_FractionDigits_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_FractionDigits_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_FractionDigits_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_FractionDigits_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_FractionDigits_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="Length">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_Length_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_Length_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_Length_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Length_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_Length_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_Length_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Length_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Length_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Length_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Length_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="MinLength">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_MinLength_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_MinLength_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_MinLength_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_MinLength_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_MinLength_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_MinLength_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_MinLength_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_MinLength_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_MinLength_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_MinLength_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="MaxLength">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_MaxLength_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_MaxLength_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_MaxLength_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_MaxLength_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_MaxLength_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_MaxLength_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_MaxLength_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_MaxLength_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_MaxLength_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_MaxLength_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>	
	
	<xsl:template name="Enumeration">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
			
			<!-- id_Enumeration_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Enumeration_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_Enumeration_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_Enumeration_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Enumeration_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Enumeration_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Enumeration_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Enumeration_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="WhiteSpace">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- fixed_WhiteSpace_String -->
			<!-- 0 - 1 fixed -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">fixed_WhiteSpace_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@fixed"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- id_WhiteSpace_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_WhiteSpace_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_WhiteSpace_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_WhiteSpace_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_WhiteSpace_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_WhiteSpace_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_WhiteSpace_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_WhiteSpace_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>	
	
	<xsl:template name="Pattern">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
			
			<!-- id_Pattern_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Pattern_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- value_Pattern_String -->
			<!-- 1 value -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">value_Pattern_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@value"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Pattern_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Pattern_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Pattern_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Pattern_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>	
	
	<xsl:template name="Any">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Any_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Any_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- maxOccurs_Any_String -->
			<!-- 0 - 1 maxOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">maxOccurs_Any_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@maxOccurs"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- minOccurs_Any_String -->
			<!-- 0 - 1 minOccurs -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">minOccurs_Any_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@minOccurs"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- namespace_Any_String -->
			<!-- 0 - 1 namespace -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">namespace_Any_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@namespace"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- processContents_Any_String -->
			<!-- 0 - 1 processContents -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">processContents_Any_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@processContents"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->			
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Any_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Any_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Any_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Any_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>	
	
	<xsl:template name="Selector">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Selector_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Selector_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- xpath_Selector_String -->
			<!-- 1 xpath -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">xpath_Selector_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@xpath"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Selector_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Selector_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Selector_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Selector_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="Field">
	
		<xsl:param name="domainMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- class definition -->
		<xsl:call-template name="classDefinition">
			<xsl:with-param name="localOntologyIRI" select="$localOntologyIRI"/>
			<xsl:with-param name="localClassIdentifier" select="$domainElementInformationItem"/>
		</xsl:call-template>
		
		<!-- superClass definition -->
		<xsl:call-template name="superClassDefinition">
			<xsl:with-param name="superClass">
				<xsl:value-of select="$domainMetaElementInformationItem"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- hasValue restrictions on datatype properties -->
		
			<!-- id_Field_String -->
			<!-- 0 - 1 id -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">id_Field_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@id"/><!-- adapt! -->
			</xsl:call-template>
			
			<!-- xpath_Field_String -->
			<!-- 1 xpath -->
			<xsl:call-template name="hasValueRestrictionOnDatatypeProperty">
				<xsl:with-param name="datatypeProperty">xpath_Field_String</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="hasValueRestriction" select="./@xpath"/><!-- adapt! -->
			</xsl:call-template>
		
		<!-- universal restrictions on object properties -->
				
			<!-- contained range element information items (-> definition of range element information items) -->
		
				<!-- contains_Field_Annotation -->
				<!-- 0 - 1 Annotation -->
				<xsl:call-template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
					<xsl:with-param name="objectProperty">contains_Field_Annotation</xsl:with-param><!-- adapt! -->
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
		
		<xsl:call-template name="classDefinitionEnd"/>
		
		<!-- definition of range element information items -->
			
			<!-- contains_Field_Annotation -->
			<!-- 0 - 1 Annotation -->
			<xsl:call-template name="rangeElementInformationItemsDefinition">
				<xsl:with-param name="objectProperty">contains_Field_Annotation</xsl:with-param><!-- adapt! -->
				<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
			</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="classDefinition">
	
		<xsl:param name="localOntologyIRI"/>
		<xsl:param name="localClassIdentifier"/>
		<!-- current domain element information item -->
		
		<!-- <base ontology IRI>/<local ontology IRI>.owl#<domain element information item> -->
		<xsl:text disable-output-escaping="yes"><![CDATA[	
	
	<!-- ]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/]]></xsl:text>
		<xsl:value-of select="$localOntologyIRI"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[.owl#]]></xsl:text>
		<xsl:value-of select="$localClassIdentifier"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[ -->
	]]></xsl:text>
	
		<!-- <owl:Class rdf:about="<base ontology IRI>/<local ontology IRI>.owl#<domain element information item>"/> -->
		<xsl:text disable-output-escaping="yes"><![CDATA[
	<owl:Class rdf:about="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/]]></xsl:text>
		<xsl:value-of select="$localOntologyIRI"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[.owl#]]></xsl:text>
		<xsl:value-of select="$localClassIdentifier"/>
		
	</xsl:template>
	
	<xsl:template name="classDefinitionEnd">
	
		<!-- </owl:Class> -->
		<xsl:text disable-output-escaping="yes"><![CDATA[
	</owl:Class>]]></xsl:text>
	
	</xsl:template>
	
	<xsl:template name="superClassDefinition">
	
		<xsl:param name="superClass"/>
		<!-- meta-element information item -->
		
		<!-- <rdfs:subClassOf rdf:resource="<base ontology IRI>/XMLSchemaMetamodelOntology.owl#<meta-element information item>"/> -->
		<xsl:text disable-output-escaping="yes"><![CDATA[">
		<rdfs:subClassOf rdf:resource="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/XMLSchemaMetamodelOntology.owl#]]></xsl:text>
		<xsl:value-of select="$superClass"/>
		<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
		
	</xsl:template>
	
	<xsl:template name="hasValueRestrictionOnDatatypeProperty">
	
		<xsl:param name="datatypeProperty"/>
		<xsl:param name="hasValueRestriction"/>
		
		<!-- any_<Appinfo|Documentation>_String: -->
		<xsl:variable name="hasValueRestriction">
			<xsl:choose>
				<xsl:when test="compare($datatypeProperty, 'any_Appinfo_String') = 0">
					<xsl:apply-templates mode="any" select="."/>
				</xsl:when>
				<xsl:when test="compare($datatypeProperty, 'any_Documentation_String') = 0">
					<xsl:apply-templates mode="any" select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$hasValueRestriction"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="string-length($hasValueRestriction)>0">
		<!-- the presence of the optional attributes and element information items' XML contents is checked before the datatype property hasValue restriction can be defined -->
			<xsl:text disable-output-escaping="yes"><![CDATA[
		<rdfs:subClassOf>
			<owl:Restriction>
				<owl:onProperty rdf:resource="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/XMLSchemaMetamodelOntology.owl#]]></xsl:text>
			<xsl:value-of select="$datatypeProperty"/>
			<xsl:text disable-output-escaping="yes"><![CDATA["/>
				<owl:hasValue rdf:datatype="&xsd;string">]]></xsl:text>
			<xsl:copy-of select="$hasValueRestriction"/>
			<xsl:text disable-output-escaping="yes"><![CDATA[</owl:hasValue>
			</owl:Restriction>
		</rdfs:subClassOf>]]></xsl:text>
		</xsl:if>
		
	</xsl:template>
	
	<!-- any_<Appinfo|Documentation>_String: -->
	<xsl:template mode="any" match="*">
	<!-- If hasValue restrictions on the datatype properties 'any_<Appinfo|Documentation>_String' have to be defined, the default template for element nodes with the template mode 'any' is invoked. The sequence, transmitted to this template, encompasses the current node representing the actual domain element information item 'appinfo' or 'documentation'. The element nodes '<XML Schema namespace prefix>:<appinfo|documentation>' can include any well-formed XML content (i.e. text nodes, element nodes, and element nodes' attributes). The XML content is added to the result tree recursively by calling the element nodes' default template with the template mode 'any' for all the child and descendent element nodes of the element information items 'appinfo' and 'documentation'. The element nodes 'appinfo' and 'documentation' themselves are not part of the output tree. In hasValue restrictions on datatype properties not allowed characters (<, >, ") are escaped and the attribute and text nodes for each actual child or descendent element node are also appended to the output tree. -->
	
		<xsl:variable name="elementNodeNameAppinfo"><xsl:value-of select="$XMLSchemaNamespacePrefix"/>:appinfo</xsl:variable>
		<xsl:variable name="elementNodeNameDocumentation"><xsl:value-of select="$XMLSchemaNamespacePrefix"/>:documentation</xsl:variable>
		<xsl:variable name="currentElementNodeName" select="name(.)"/>
		<xsl:choose>
			<!-- element nodes '<XMLSchemaNamespacePrefix>:appinfo|documentation' are NOT part of the result tree -->
			<xsl:when test="compare($currentElementNodeName, $elementNodeNameAppinfo) = 0 or compare($currentElementNodeName, $elementNodeNameDocumentation) = 0">
				<xsl:apply-templates mode="any"/>
			</xsl:when>
			<xsl:otherwise>
				<!--<xsl:element name="{name(.)}">
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="any"/>
				</xsl:element>-->
				<!-- The attribute and text nodes for each actual child or descendent element are also appended to the output tree -->
				<xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="$currentElementNodeName"/>
				<xsl:for-each select="./attribute()">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:value-of select="name()"/>
					<xsl:text disable-output-escaping="yes">=&quot;</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text disable-output-escaping="yes">&quot;</xsl:text>
				</xsl:for-each>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				<xsl:apply-templates mode="any"/>
				<xsl:text disable-output-escaping="yes">&lt;/</xsl:text><xsl:value-of select="$currentElementNodeName"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>  
	
	<xsl:template name="universalRestrictionOnObjectProperty">
	<!-- As the active domain element information item may contain one or multiple range element information items, the class corresponding to the actual domain element information item can only have 'contains_<domain meta-element information item>_<range meta-element information item>' relationships with one specific class representing a range element information item or with a union of specific classes standing for contained element information items -->
	
		<xsl:param name="objectProperty"/>
		<!-- ontology IRIs of the range element information items contained in the actual domain element information item: -->
		<xsl:param name="rangeElementInformationItemsOntologyIRIs"/>
		<!-- identifiers of the range element information items contained in the actual domain element information item: -->
		<xsl:param name="rangeElementInformationItemsIdentifiers"/>
		
		<xsl:text disable-output-escaping="yes"><![CDATA[
		<rdfs:subClassOf>
            <owl:Restriction>
                <owl:onProperty rdf:resource="]]></xsl:text><xsl:value-of select="$baseOntologyIRI"/><xsl:text disable-output-escaping="yes"><![CDATA[/XMLSchemaMetamodelOntology.owl#]]></xsl:text>
		<xsl:value-of select="$objectProperty"/>
		<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
		<xsl:choose>
		
			<!-- 1 range element information item: -->
			<!-- <objectProperty> only <range element information item> -->
			<xsl:when test="count($rangeElementInformationItemsIdentifiers)=1">
				<xsl:text disable-output-escaping="yes"><![CDATA[
                <owl:allValuesFrom rdf:resource="]]></xsl:text>
				<xsl:value-of select="$rangeElementInformationItemsOntologyIRIs[1]"/>
				<xsl:text disable-output-escaping="yes"><![CDATA[#]]></xsl:text>
				<xsl:value-of select="$rangeElementInformationItemsIdentifiers[1]"/>
				<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
			</xsl:when>
			
			<!-- >=2 range element information items: -->
			<!-- <objectProperty> only (<range element information item 1> OR <range element information item 2> OR ...) -->
			<xsl:when test="count($rangeElementInformationItemsIdentifiers)>=2">
				<xsl:text disable-output-escaping="yes"><![CDATA[
				<owl:allValuesFrom>
					<owl:Class>
						<owl:unionOf rdf:parseType="Collection">]]></xsl:text>
				<xsl:for-each select="$rangeElementInformationItemsIdentifiers">
					<xsl:variable name="i" select="position()" as="xs:integer"/>
					<xsl:text disable-output-escaping="yes"><![CDATA[
							<rdf:Description rdf:about="]]></xsl:text>
					<xsl:value-of select="$rangeElementInformationItemsOntologyIRIs[$i]"/>
					<xsl:text disable-output-escaping="yes"><![CDATA[#]]></xsl:text>
					<xsl:value-of select="$rangeElementInformationItemsIdentifiers[$i]"/>
					<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
				</xsl:for-each>
				<xsl:text disable-output-escaping="yes"><![CDATA[
						</owl:unionOf>
                    </owl:Class>
                </owl:allValuesFrom>]]></xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<xsl:text disable-output-escaping="yes"><![CDATA[
            </owl:Restriction>
        </rdfs:subClassOf>]]></xsl:text>
	</xsl:template>
	
	<xsl:template name="universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems">
	<!-- subsequent definition of element information items is NOT necessary -->
	<!-- The range element information items do not have to be defined after the specification of the object properties' universal restrictions, since classes, representing other element information items or type definitions, are already defined or will still be defined in the process traversing the XML Schema's document tree.  -->
	
		<xsl:param name="objectProperty"/>
		<xsl:param name="domainElementInformationItem"/>
		<xsl:param name="rangeElementInformationItem"/>
		<xsl:variable name="rangeMetaElementInformationItem" select="tokenize($objectProperty, '_')[3]"/>
		
		<xsl:if test="string-length($rangeElementInformationItem)>0">
		<!-- as the attributes including the range element information items of the object properties' universal restrictions are not mandatory, the object properties' universal restrictions can only be defined if the attributes are present -->

			<!-- ontology IRI of the range element information item: -->
			<xsl:variable name="rangeElementInformationItemOntologyIRI">
				<xsl:call-template name="getNotContainedRangeElementInformationItemOntologyIRI">
					<xsl:with-param name="rangeElementInformationItem" select="$rangeElementInformationItem"/>
				</xsl:call-template>
			</xsl:variable>
			
			<!-- identifier of the range element information item: -->
			<xsl:variable name="rangeElementInformationItem">
				<xsl:call-template name="getNotContainedRangeElementInformationItemIdentifier">
					<xsl:with-param name="rangeElementInformationItem" select="$rangeElementInformationItem"/>
					<xsl:with-param name="rangeMetaElementInformationItem" select="$rangeMetaElementInformationItem"/>
				</xsl:call-template>
			</xsl:variable>
	
			<xsl:call-template name="universalRestrictionOnObjectProperty">
				<xsl:with-param name="objectProperty" select="$objectProperty"/>
				<xsl:with-param name="rangeElementInformationItemsOntologyIRIs" as="xs:string*" select="$rangeElementInformationItemOntologyIRI"/>
				<xsl:with-param name="rangeElementInformationItemsIdentifiers" as="xs:string*" select="$rangeElementInformationItem"/>
			</xsl:call-template>
			
		</xsl:if>
		
	</xsl:template>
	
	<!-- memberTypes_Union_Type: -->
	<xsl:template name="universalRestrictionOnObjectPropertyMemberTypes">
		<!-- The attribute 'memberTypes' of the element information item 'union' may contain multiple simple ur-type and simple type definitions separated by blank characters (e.g. memberTypes="SimpleType1 SimpleType2 xs:string"). To specifiy the universal restriction on the object property 'memberTypes_Union_Type', the XSLT processor invokes the template 'universalRestrictionOnObjectPropertyMember Types'. The template normally called when references to element information items have to be defined, is not invoiced, since 'memberTypes' is the only attribute possibly including multiple references to other element information items. Finally, the general template 'universalRestrictionOnObject Property' is called to define the universal restriction on the object property. Two variables containing string sequences of the type definitions' ontology IRIs and identifiers serve as parameters. -->
					
		<xsl:param name="objectProperty"/>
		<xsl:param name="rangeElementInformationItem"/>
		
		<xsl:if test="string-length($rangeElementInformationItem)>0">

			<!-- memberTypes: -->
				<xsl:variable name="memberTypes" as="xs:string*">
					<xsl:for-each select="tokenize(./@memberTypes, '\s+')">
						<xsl:sequence select="."/>
					</xsl:for-each>
				</xsl:variable>
				<!-- test: -->
					<!--<xsl:text>&#xa;</xsl:text><xsl:text>memberTypes:</xsl:text><xsl:text>&#xa;</xsl:text>
					<xsl:for-each select="$memberTypes">
						<xsl:value-of select="."/><xsl:text> </xsl:text>
					</xsl:for-each>
					<xsl:text>&#xa;</xsl:text>-->

			<!-- memberTypes' prefixes: -->
				<xsl:variable name="memberTypesPrefixes" as="xs:string*">
					<xsl:for-each select="$memberTypes">
						<xsl:sequence select="substring-before(., ':')"/>
					</xsl:for-each>
				</xsl:variable>
				<!-- test: -->
					<!--<xsl:text>&#xa;</xsl:text><xsl:text>memberTypesPrefixes:</xsl:text><xsl:text>&#xa;</xsl:text>
					<xsl:for-each select="$memberTypesPrefixes">
						<xsl:value-of select="."/><xsl:text> </xsl:text>
					</xsl:for-each>
					<xsl:text>&#xa;</xsl:text>-->
							
			<!-- memberTypes' namespace URIs: -->
				<xsl:variable name="fileNameInputXMLSchema" as="xs:string">
					<xsl:call-template name="getFileNameInputXMLSchema">
						<xsl:with-param name="filePathInputXMLSchema" select="string(base-uri())"/>
					</xsl:call-template>
				</xsl:variable>	
				<!-- Type definitions may be specified in external XML Schemas, wherefore they can have an associated namespace prefix. To store the namespace URIs of type definitions' prefixes, it is iterated over each type definition referenced in the attribute 'memberTypes'. To receice the namespace URI of a specific prefix, the node containing the assignment of the namespace URI to the prefix is needed. As it is iterated over atomic values, the context node is of type 'string' and not of the needed type 'node'. As a consequence, the node containing the namespace statements has to be addressed absolutely using the XPath function 'document'. -->
				<!-- document('<pathInputXMLSchemas><fileNameInputXMLSchema>.xsd')/<XMLSchemaNamespacePrefix>:schema -->
				<xsl:variable name="rootElementInputXMLSchema"><xsl:text>document('</xsl:text><xsl:value-of select="$relativePathInputXMLSchemas"/><xsl:value-of select="$fileNameInputXMLSchema"/><xsl:text>.xsd')/</xsl:text><xsl:value-of select="$XMLSchemaNamespacePrefix"/><xsl:text>:schema</xsl:text></xsl:variable>	
				<!-- test: -->
					<!--<xsl:text>&#xa;</xsl:text><xsl:text>rootElementInputXMLSchema:</xsl:text><xsl:text>&#xa;</xsl:text>
					<xsl:value-of select="$rootElementInputXMLSchema"/>
					<xsl:text>&#xa;</xsl:text>-->			
				<xsl:variable name="memberTypesNamespaceURIs" as="xs:string*">
					<xsl:for-each select="$memberTypesPrefixes">
						<xsl:sequence select="namespace-uri-for-prefix(., saxon:evaluate($rootElementInputXMLSchema))"/>
					</xsl:for-each>
				</xsl:variable>		
				<!-- test: -->	
					<!--<xsl:text>&#xa;</xsl:text><xsl:text>memberTypesNamespaceURIs:</xsl:text><xsl:text>&#xa;</xsl:text>
					<xsl:for-each select="$memberTypesNamespaceURIs">
						<xsl:value-of select="."/><xsl:text> </xsl:text>
					</xsl:for-each>
					<xsl:text>&#xa;</xsl:text>-->

			<!-- memberTypes' ontology IRIs: -->
				<!-- <base ontology IRI><[external] local ontology IRI>.owl -->
				<xsl:variable name="memberTypesOntologyIRIs" as="xs:string*">
					<xsl:for-each select="$memberTypesNamespaceURIs">
						<xsl:variable name="sequence"><xsl:value-of select="$baseOntologyIRI"/>/<xsl:value-of select="."/>.owl</xsl:variable>
						<xsl:sequence select="$sequence"/>					
					</xsl:for-each>
				</xsl:variable>
				<!-- test: -->
					<!--<xsl:text>&#xa;</xsl:text><xsl:text>memberTypesOntologyIRIs:</xsl:text><xsl:text>&#xa;</xsl:text>
					<xsl:for-each select="$memberTypesOntologyIRIs">
						<xsl:value-of select="."/><xsl:text> </xsl:text>
					</xsl:for-each>
					<xsl:text>&#xa;</xsl:text>-->

			<!-- memberTypes' identifiers: -->
				<!-- <memberType [without possible namespace prefix]>-Type_<[external] local ontology IRI>-Schema -->
				<xsl:variable name="memberTypesIdentifiers" as="xs:string*">
					<xsl:for-each select="$memberTypes">
						<xsl:variable name="i" select="position()"/>
						<xsl:choose>
							<!-- memberType contains namespace prefix: -->
								<!-- memberType is defined in an external XML Schema -->
								<!-- (e.g. string-Type_http://www.w3.org/2001/XMLSchema-Schema) -->
								<xsl:when test="string-length($memberTypesPrefixes[$i]) > 0">
									<xsl:variable name="memberTypeIdentifierWithoutNamespacePrefix">
										<xsl:value-of select="substring-after(., ':')"/>
									</xsl:variable>
									<xsl:variable name="memberTypeIdentifier"><xsl:value-of select="$memberTypeIdentifierWithoutNamespacePrefix"/>-Type_<xsl:value-of select="$memberTypesNamespaceURIs[$i]"/>-Schema</xsl:variable>
									<xsl:sequence select="$memberTypeIdentifier"/>
								</xsl:when>
							<!-- memberType NOT contains namespace prefix: -->
								<!-- memberType is defined in the input XML Schema -->
								<!-- (e.g. SimpleType1-Type_targetNamespaceSchema-Schema) -->
								<xsl:otherwise>
									<xsl:variable name="memberTypeIdentifier"><xsl:value-of select="."/>-Type_<xsl:value-of select="$memberTypesNamespaceURIs[$i]"/>-Schema</xsl:variable>
									<xsl:sequence select="$memberTypeIdentifier"/>
								</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<!-- test: -->
					<!--<xsl:text>&#xa;</xsl:text><xsl:text>memberTypesIdentifiers:</xsl:text><xsl:text>&#xa;</xsl:text>
					<xsl:for-each select="$memberTypesIdentifiers">
						<xsl:value-of select="."/><xsl:text> </xsl:text>
					</xsl:for-each>
					<xsl:text>&#xa;</xsl:text>-->
			
			<xsl:call-template name="universalRestrictionOnObjectProperty">
				<xsl:with-param name="objectProperty" select="$objectProperty"/>
				<xsl:with-param name="rangeElementInformationItemsOntologyIRIs" as="xs:string*">
					<xsl:for-each select="$memberTypesOntologyIRIs">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:with-param>
				<xsl:with-param name="rangeElementInformationItemsIdentifiers" as="xs:string*">
					<xsl:for-each select="$memberTypesIdentifiers">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="sequence_100">
		<xsl:param name="domainElementInformationItem"/>
		<xsl:variable name="objectProperty"><xsl:text>sequence</xsl:text></xsl:variable>
		
		<!-- ............... -->
		<!-- XPath: -->
			<!-- ./* -->
			<xsl:variable name="xpath">
				<xsl:text>./*</xsl:text>
			</xsl:variable>
		<!-- ..... -->
		
		<!-- ............... -->
		<!-- for each possible range meta-element information item: -->
			<!--<xsl:variable name="rangeMetaElementInformationItems" as="xs:string*">
				<xsl:text>Sequence</xsl:text>
				<xsl:text>Element</xsl:text>
			</xsl:variable>-->
		<!-- ..... -->
		
<!--		<xsl:variable name="rangeElementInformationItemsIdentifiers" as="xs:string*">
			<xsl:for-each select="$rangeMetaElementInformationItems">
				<xsl:variable name="rangeMetaElementInformationItem" select="."/>
				<xsl:for-each select="saxon:evaluate($xpath)">
					<xsl:call-template name="getContainedRangeElementInformationItemIdentifier">
						<xsl:with-param name="rangeMetaElementInformationItem" select="$rangeMetaElementInformationItem"/>
						<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:variable>-->
		
		<xsl:variable name="rangeElementInformationItemsIdentifiers" as="xs:string*">
				<xsl:variable name="rangeMetaElementInformationItem" select="."/>
				<xsl:for-each select="saxon:evaluate($xpath)">
					<!--<xsl:variable name="i" as="xs:integer" select="$i"/>-->
					<xsl:call-template name="getContainedRangeElementInformationItemIdentifier">
						<xsl:with-param name="rangeMetaElementInformationItem" select="concat(upper-case(substring(substring-after(./name(), concat($XMLSchemaNamespacePrefix, ':')), 1, 1)), substring(substring-after(./name(), concat($XMLSchemaNamespacePrefix, ':')), 2, string-length(substring-after(./name(), concat($XMLSchemaNamespacePrefix, ':')))))"/>
						<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
						<!--<xsl:with-param name="i" as="xs:integer" select="$i">-->
						<!--<xsl:with-param name="xpath" select="$xpath"/>-->
					</xsl:call-template>
				</xsl:for-each>
		</xsl:variable>
			
		<!-- ontology IRIs of the range element information items of the given range meta-element information item contained in the actual domain element information item: -->
		<xsl:variable name="rangeElementInformationItemsOntologyIRIs" as="xs:string*">
			<xsl:for-each select="saxon:evaluate($xpath)">
				<xsl:call-template name="getContainedRangeElementInformationItemOntologyIRI"/>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:call-template name="universalRestrictionOnObjectProperty">
			<xsl:with-param name="objectProperty" select="$objectProperty"/>
			<xsl:with-param name="rangeElementInformationItemsOntologyIRIs" as="xs:string*">
				<xsl:for-each select="$rangeElementInformationItemsOntologyIRIs">
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:with-param>
			<xsl:with-param name="rangeElementInformationItemsIdentifiers" as="xs:string*">
				<xsl:for-each select="$rangeElementInformationItemsIdentifiers">
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
			
	</xsl:template>
	
	<!-- ............... -->
	<!-- 28.04.2012 -->
	<xsl:template name="sequence">
		<!-- differences to template 'universalRestrictionOnObjectPropertyContainedRangeElementInformationItems': -->
			<!-- - rangeMetaElementInformationItem -->
			<!-- - xpath -->
	
		<xsl:param name="objectProperty"/>
		<xsl:param name="domainElementInformationItem"/>
		<xsl:variable name="xpath"><xsl:text>./*</xsl:text></xsl:variable>
	
		<!-- current domain element information item really includes at least 1 range element information item? -->
		<xsl:if test="saxon:evaluate($xpath)">
			
			<xsl:variable name="rangeElementInformationItemsIdentifiers" as="xs:string*">
				<xsl:for-each select="saxon:evaluate($xpath)">
					<xsl:call-template name="getContainedRangeElementInformationItemIdentifier">
						<xsl:with-param name="rangeMetaElementInformationItem"></xsl:with-param>
						<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:variable>
			
			<xsl:variable name="rangeElementInformationItemsOntologyIRIs" as="xs:string*">
				<xsl:for-each select="saxon:evaluate($xpath)">
					<xsl:call-template name="getContainedRangeElementInformationItemOntologyIRI"/>
				</xsl:for-each>
			</xsl:variable>
			
			<xsl:call-template name="universalRestrictionOnObjectProperty">
				<xsl:with-param name="objectProperty" select="$objectProperty"/>
				<xsl:with-param name="rangeElementInformationItemsOntologyIRIs" as="xs:string*">
					<xsl:for-each select="$rangeElementInformationItemsOntologyIRIs">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:with-param>
				<xsl:with-param name="rangeElementInformationItemsIdentifiers" as="xs:string*">
					<xsl:for-each select="$rangeElementInformationItemsIdentifiers">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
		
		</xsl:if>
		
	</xsl:template>
	<!-- ..... -->
	
	<xsl:template name="universalRestrictionOnObjectPropertyContainedRangeElementInformationItems">
	<!-- For each object property 'contains_<domain meta-element information item>_<range meta-element information item>' defined for the actual domain element information item's associated meta-element information item, the template 'universalRestrictionOnObject PropertyContainedRanges' is called -->
				
	<!-- subsequent definition of element information items is necessary -->
	
	<!-- mapping of element information items' part-of relationships to universal restrictions on XML Schema Metamodel Ontology's object properties <domain element information item> subClassOf universal quantifier contains_<domain meta-element information item>_<range meta-element information item>.<union of range element information items> -->
	
		<xsl:param name="objectProperty"/>
		<xsl:param name="domainElementInformationItem"/>
		<xsl:variable name="rangeMetaElementInformationItem" select="tokenize($objectProperty, '_')[3]"/>
		<xsl:variable name="xpath">
			<!-- ./<XMLSchemaNamespacePrefix>:<rangeMetaElementInformationItem> (e.g. ./xs:complexType) -->
			./<xsl:value-of select="$XMLSchemaNamespacePrefix"/>:<xsl:value-of select="concat(lower-case(substring($rangeMetaElementInformationItem,1,1)), substring($rangeMetaElementInformationItem, 2, string-length($rangeMetaElementInformationItem)))"/>
		</xsl:variable>
		
		<xsl:if test="saxon:evaluate($xpath)">
		<!-- current domain element information item really includes the range element information items of the given range meta-element information item? -> universal restriction on object property will be defined -->
		
			<!-- ............... -->
			<!-- 28.04.2012 -->
				<xsl:variable name="xpath">
					<xsl:text>./*</xsl:text>
				</xsl:variable>
			<!-- ..... -->
		
			<!-- identifiers of the range element information items of the given range meta-element information item contained in the actual domain element information item: -->
			<xsl:variable name="rangeElementInformationItemsIdentifiers" as="xs:string*">
				<!-- iteration over the range element information items of the given range meta-element information item: -->
				<xsl:for-each select="saxon:evaluate($xpath)">
					<xsl:call-template name="getContainedRangeElementInformationItemIdentifier">
						<xsl:with-param name="rangeMetaElementInformationItem" select="$rangeMetaElementInformationItem"/>
						<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:variable>
			
			<!-- ontology IRIs of the range element information items of the given range meta-element information item contained in the actual domain element information item: -->
			<xsl:variable name="rangeElementInformationItemsOntologyIRIs" as="xs:string*">
				<!-- iteration over the range element information items of the given range meta-element information item -->
				<xsl:for-each select="saxon:evaluate($xpath)">
					<xsl:call-template name="getContainedRangeElementInformationItemOntologyIRI"/>
				</xsl:for-each>
			</xsl:variable>
			
			<xsl:call-template name="universalRestrictionOnObjectProperty">
				<xsl:with-param name="objectProperty" select="$objectProperty"/>
				<xsl:with-param name="rangeElementInformationItemsOntologyIRIs" as="xs:string*">
					<xsl:for-each select="$rangeElementInformationItemsOntologyIRIs">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:with-param>
				<xsl:with-param name="rangeElementInformationItemsIdentifiers" as="xs:string*">
					<xsl:for-each select="$rangeElementInformationItemsIdentifiers">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
			
		</xsl:if>
		
	</xsl:template>

	<xsl:template name="rangeElementInformationItemsDefinition">
	<!-- As contained element information items are referenced in definitions of universal restrictions on the object properties 'contains_<domain meta-element information item><range meta-element information item>', the range element information items have to be defined as well  -->
	
		<xsl:param name="objectProperty"/>
		<xsl:param name="domainElementInformationItem"/>
		<xsl:variable name="rangeMetaElementInformationItem" select="tokenize($objectProperty, '_')[3]"/>
		<xsl:variable name="xpath">
		<!-- ./<XMLSchemaNamespacePrefix>:<rangeMetaElementInformationItem> (e.g. ./xs:complexType) -->
			./<xsl:value-of select="$XMLSchemaNamespacePrefix"/>:<xsl:value-of select="concat(lower-case(substring($rangeMetaElementInformationItem,1,1)), substring($rangeMetaElementInformationItem, 2, string-length($rangeMetaElementInformationItem)))"/>
		</xsl:variable>
		
		<!-- ............... -->
		<!-- 28.04.2012 -->
			<xsl:variable name="xpath">
				<xsl:text>./*</xsl:text>
			</xsl:variable>
		<!-- ..... -->
		
		<!-- for each range element information item of the given range meta-element information item -->
		<xsl:for-each select="saxon:evaluate($xpath)">
		
			<!-- range element information item's identifier -->
			<xsl:variable name="rangeElementInformationItem">
				<xsl:call-template name="getContainedRangeElementInformationItemIdentifier">
					<xsl:with-param name="rangeMetaElementInformationItem" select="$rangeMetaElementInformationItem"/>
					<xsl:with-param name="domainElementInformationItem" select="$domainElementInformationItem"/>
				</xsl:call-template>
			</xsl:variable>
			
			<!-- ............... -->
			<!-- 28.04.2012 -->
			<xsl:if test="string-length($rangeElementInformationItem) > 0">
			<!-- ..... -->
			
			<!-- the template named after the range meta-element information item is invoked recursively in order to define each range element information item of the given meta-element informartion item -->
			<saxon:call-template name="{$rangeMetaElementInformationItem}">
				<xsl:with-param name="domainMetaElementInformationItem">
					<xsl:value-of select="$rangeMetaElementInformationItem"/>
				</xsl:with-param>
				<xsl:with-param name="domainElementInformationItem">
					<xsl:value-of select="$rangeElementInformationItem"/>
				</xsl:with-param>
			</saxon:call-template>
			
			<!-- ............... -->
			<!-- 28.04.2012 -->
			</xsl:if>
			<!-- ..... -->
			
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="getNotContainedRangeElementInformationItemOntologyIRI">
	<!-- <base ontology IRI><[external] local ontology IRI>.owl -->
	
		<xsl:param name="rangeElementInformationItem"/>
		
		<xsl:choose>
		
			<!-- attribute contains namespace prefix: -->
			
				<!-- range element information item is defined in an external XML Schema -->
				<!-- (e.g. http://www.semanticweb.org/ontologies/XMLSchemaOntologies/http://www.w3.org/XML/1998/namespace.owl) -->
				<xsl:when test="contains($rangeElementInformationItem, ':')">
					<xsl:variable name="prefix" select="substring-before($rangeElementInformationItem, ':')"/>
					<xsl:variable name="rootElement">//<xsl:value-of select="$XMLSchemaNamespacePrefix"/>:schema</xsl:variable>
					<xsl:variable name="externalLocalOntologyIRI" select="namespace-uri-for-prefix($prefix, saxon:evaluate($rootElement))"/>
					<xsl:value-of select="$baseOntologyIRI"/><xsl:text>/</xsl:text><xsl:value-of select="$externalLocalOntologyIRI"/><xsl:text>.owl</xsl:text>
				</xsl:when>
				
			<!-- attribute NOT contains namespace prefix: -->
			
				<!-- range element information item is defined in the input XML Schema -->
				<!-- (e.g. http://www.semanticweb.org/ontologies/XMLSchemaOntologies/localOntologyIRI.owl) -->
				<xsl:otherwise>
					<xsl:value-of select="$baseOntologyIRI"/><xsl:text>/</xsl:text><xsl:value-of select="$localOntologyIRI"/><xsl:text>.owl</xsl:text>
				</xsl:otherwise>		
		
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="getContainedRangeElementInformationItemOntologyIRI">
	<!-- <base ontology IRI>/<local ontology IRI>.owl -->
	
		<xsl:variable name="rangeOntology"><xsl:value-of select="$baseOntologyIRI"/><xsl:text>/</xsl:text><xsl:value-of select="$localOntologyIRI"/><xsl:text>.owl</xsl:text></xsl:variable>
		
		<xsl:sequence select="$rangeOntology"/>
		
	</xsl:template>	
	
	<xsl:template name="getNotContainedRangeElementInformationItemIdentifier">
	<!-- not contained range element information items; references to top-level element information items (e.g. attributes 'ref', 'substitutionGroup', 'type', 'base') -->
	<!-- <range element information item [without possible namespace prefix]>-<Range meta-element information item>_<[external] local ontology IRI>-Schema -->
	
		<xsl:param name="rangeElementInformationItem"/>
		<xsl:param name="rangeMetaElementInformationItem"/>	
		
		<!--range meta-element information items 'SimpleType' and 'ComplexType' are set to 'Type': -->
		<xsl:variable name="rangeMetaElementInformationItem">
		<!-- If type definitions, specified in external XML Schemas, are referenced, the type definitions' local class identifiers have to be determined. The meta-element information item's name is one part of the type definitions' local class identifiers. If specific meta-element information items like 'SimpleType' or 'ComplexType' serve as the meta-element information item parts of the type definitions' local class identifiers, the corresponding external XML Schemas, in which the type definitions are specified, have to be traversed. And if, in contrast, the general meta-element information item 'Type' serves as the meta-element information item part of the type definitions' local class identifiers, the corresponding external XML Schemas do not have to be traversed. An obligatory traversing of external XML Schemas' XML document trees would be critical, since in many cases, external XML Schemas cannot be available physically and namespaces can be imported using arbitrary values of 'schemaLocation' attributes. Because of these reasons, the type definitions' local class identifiers' meta-element information item parts 'AnySimpleType', 'SimpleType', and 'ComplexType' are set to 'Type'. 'Type' is the super-class representing the general meta-element information item of the sub-classes standing for the more specific meta-element information items of type definitions (i.e. simple ur-type, simple type and complex type definitions).  -->
			<xsl:choose>
				<xsl:when test="(compare($rangeMetaElementInformationItem, 'ComplexType') = 0) or (compare($rangeMetaElementInformationItem, 'SimpleType') = 0)">
				<!-- In case of simple ur-type definitions, the value for the parameter 'rangeMetaElementInformationItem' is set to 'Type' when the template 'universalRestrictionOnObjectPropertyNotContainedRangeElementInformationItems' is invoked. -->
					<xsl:text>Type</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rangeMetaElementInformationItem"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
		
			<!-- attribute contains namespace prefix: -->
			
				<!-- range element information item is defined in an external XML Schema -->
				<!-- (e.g. lang-Attribute_http://www.w3.org/XML/1998/namespace-Schema) -->
				<xsl:when test="contains($rangeElementInformationItem, ':')">
					<xsl:variable name="prefix" select="substring-before($rangeElementInformationItem, ':')"/>
					<xsl:variable name="rootElement">//<xsl:value-of select="$XMLSchemaNamespacePrefix"/>:schema</xsl:variable>
					<xsl:variable name="rangeElementInformationItemWithoutNamespacePrefix">
						<xsl:choose>
							<xsl:when test="contains($rangeElementInformationItem, ':')">
								<xsl:value-of select="substring-after($rangeElementInformationItem, ':')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$rangeElementInformationItem"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="externalLocalOntologyIRI" select="namespace-uri-for-prefix($prefix, saxon:evaluate($rootElement))"/>
					<xsl:value-of select="concat($rangeElementInformationItemWithoutNamespacePrefix, '-', $rangeMetaElementInformationItem, '_', $externalLocalOntologyIRI, '-Schema')"/>
				</xsl:when>
				
			<!-- attribute NOT contains namespace prefix: -->
			
				<!-- range element information item is defined in the input XML Schema -->
				<!-- (e.g. g2-Group_targetNamespaceSchema-Schema) -->
				<xsl:otherwise>
					<xsl:value-of select="concat($rangeElementInformationItem, '-', $rangeMetaElementInformationItem, '_', $localOntologyIRI, '-Schema')"/>
				</xsl:otherwise>
				
		</xsl:choose>
		
	</xsl:template>

	<xsl:template name="getContainedRangeElementInformationItemIdentifier">
	
		<xsl:param name="rangeMetaElementInformationItem"/>
		<xsl:param name="domainElementInformationItem"/>
		
		<!-- ............... -->
		<!-- 28.04.2012 -->
		<!-- contained range EIIs are sequentially numbered: -->
		<xsl:if test="compare($rangeMetaElementInformationItem, concat(upper-case(substring(substring-after(./name(), concat($XMLSchemaNamespacePrefix, ':')), 1, 1)), substring(substring-after(./name(), concat($XMLSchemaNamespacePrefix, ':')), 2, string-length(substring-after(./name(), concat($XMLSchemaNamespacePrefix, ':')))))) = 0 or string-length($rangeMetaElementInformationItem) = 0">
		<xsl:variable name="rangeMetaElementInformationItem">
			<xsl:choose>
				<xsl:when test="string-length($rangeMetaElementInformationItem) = 0">
					<xsl:value-of select="concat(upper-case(substring(substring-after(./name(), concat($XMLSchemaNamespacePrefix, ':')), 1, 1)), substring(substring-after(./name(), concat($XMLSchemaNamespacePrefix, ':')), 2, string-length(substring-after(./name(), concat($XMLSchemaNamespacePrefix, ':')))))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rangeMetaElementInformationItem"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- ..... -->
		
		<xsl:variable name="rangeMetaElementInformationItemSpecific" select="$rangeMetaElementInformationItem"/>
		
		<!--range meta-element information item 'Type': -->
		<xsl:variable name="rangeMetaElementInformationItem">
			<xsl:choose>
				<xsl:when test="(compare($rangeMetaElementInformationItem, 'ComplexType') = 0) or (compare($rangeMetaElementInformationItem, 'SimpleType') = 0)">
					<xsl:text>Type</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rangeMetaElementInformationItem"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
		
			<!-- attribute 'name': -->
			
				<!-- <range element information item>-<Range meta-element information item>_<domain element information item> -->
				<!-- (e.g. st3-Type_localOntologyIRI-Schema) -->
				<xsl:when test="string-length(./@name)>0 and compare($rangeMetaElementInformationItem, 'Key') != 0">
					<xsl:variable name="rangeElementInformationItem">
						<xsl:value-of select="./@name"/>-<xsl:value-of select="$rangeMetaElementInformationItem"/>_<xsl:value-of select="$domainElementInformationItem"/>
					</xsl:variable>
					<xsl:sequence select="$rangeElementInformationItem"/>
				</xsl:when>
				
				<!-- range meta-element information item 'Key': -->
					<!-- <range element information item>-Key_<local ontology IRI>-Schema -->
					<!-- It is assumed that references point to top-level element information items. 'key' (referenced by the attribute 'refer' of the element information item 'keyref') is the only referenced element information item which is not located at the global position in an XML Schema. But as element information items 'key' have to be unique in an XML Schema, the identifiers can also be set as if they would be top-level element information items: <range element information item>-Key_<local ontology IRI>-Schema. And because of this, it can be referenced to XML Schema unique element information items 'key' as if they would be top-level element information items. If referenced keys are defined in external XML Schemas, the target namespaces of the input XML Schema and of the external XML Schema have to be identical. Thus, the local ontology IRI can be used to identify the external XML Schema in which the key is defined. As element information items 'key' are named like top-level element information items, external XML Schemas do not have to be traversed to locate the element information items containing the keys. -->
					<xsl:when test="string-length(./@name)>0 and compare($rangeMetaElementInformationItem, 'Key') = 0">
						<xsl:variable name="rangeElementInformationItem">
							<xsl:value-of select="./@name"/>-<xsl:value-of select="$rangeMetaElementInformationItem"/>_<xsl:value-of select="$localOntologyIRI"/><xsl:text>-Schema</xsl:text>
						</xsl:variable>
						<xsl:sequence select="$rangeElementInformationItem"/>
					</xsl:when>
				
			<!-- attribute 'ref': -->
			
				<!-- <range element information item [without possible namespace prefix]>-<Range meta-element information item>-Reference<position()>[-<possible namespace URI>]_<domain element information item> -->
				<!-- The namespace URI is part of the identifier, as references to top-level element information items defined in different namespaces are possible (e.g. <xs:attribute ref="lang"/> and <xs:attribute ref="xml:lang"/>). Identifiers without namespace URI statements would not be unique -->
				<!-- Domain element information items may include multiple range element information items of the same meta-element information item with identical 'ref' attribute values (e.g. <xs:extension...><xs:attributeGroup ref="ag1"/><xs:attributeGroup ref="ag1"/></xs:extension>).  To ensure the uniqueness of range element information items' identifiers, their positions within the domain element information item have to be part of their identifiers. -->
				<!-- 'ref' contains namespace prefix: (e.g. lang-Attribute-Reference1-http://www.w3.org/XML/1998/namespace_ct4-Type_localOntologyIRI-Schema) -->
				<!-- 'ref' NOT contains namespace prefix: (e.g. a3-Attribute-Reference1_ct5-Type_localOntologyIRI-Schema) -->
				<xsl:when test="string-length(./@ref)>0">
					<xsl:variable name="rangeElementInformationItem" select="./@ref"/>
					<xsl:variable name="rangeElementInformationItemWithoutPossibleNamespacePrefix">
						<xsl:choose>
							<xsl:when test="contains($rangeElementInformationItem, ':')">
								<xsl:value-of select="substring-after($rangeElementInformationItem, ':')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$rangeElementInformationItem"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="possibleNamespaceURI">
						<xsl:if test="contains($rangeElementInformationItem, ':')">
							<xsl:variable name="prefix" select="substring-before($rangeElementInformationItem, ':')"/>
							<xsl:variable name="rootElement">//<xsl:value-of select="$XMLSchemaNamespacePrefix"/>:schema</xsl:variable>
							<xsl:text>-</xsl:text><xsl:value-of select="namespace-uri-for-prefix($prefix, saxon:evaluate($rootElement))"/>
						</xsl:if>
					</xsl:variable>
					<xsl:variable name="rangeElementInformationItem">
						<xsl:value-of select="$rangeElementInformationItemWithoutPossibleNamespacePrefix"/>-<xsl:value-of select="$rangeMetaElementInformationItem"/>-Reference<xsl:value-of select="position()"/><xsl:value-of select="$possibleNamespaceURI"/>_<xsl:value-of select="$domainElementInformationItem"/>
					</xsl:variable>
					<xsl:sequence select="$rangeElementInformationItem"/>
				</xsl:when>
				
			<!-- NO attributes 'name' or 'ref': -->
			
				<!--  <base ontology IRI>/<local ontology IRI>.owl# <Range meta-element information item ['SimpleType' or 'ComplexType' for simple and complex type definitions]><position()>-<Range meta-element information item ['Type' for simple type and complex type definitions]>_<domain element information item> -->
				<!-- (e.g. Annotation1-Annotation_localOntologyIRI-Schema; Annotation2-Annotation_localOntologyIRI-Schema; SimpleType1-Type_Restriction1-Restriction_st1-Type_localOntologyIRI-Schema) -->
				
				<!-- As domain element information items may include multiple range element information items, which have no attributes 'name' or 'ref', of the same meta-element information item, these range element information items will be identified using sequential numbers -->
				<!-- If simple or complex type definitions are included, the first range meta-element information item part of the identifier is set to the more specific type definitions  'SimpleType' or 'ComplexType' and the second range meta-element information item part of the name is set to the super-class representing the more general type definition 'Type' (e.g. SimpleType1-Type_Restriction1-Restriction_st1-Type_localOntologyIRI-Schema), in order to distinguish simple and complex type definitions. -->
				
				<xsl:otherwise>
					<xsl:variable name="rangeElementInformationItem">
						<xsl:value-of select="$rangeMetaElementInformationItemSpecific"/><xsl:value-of select="position()"/>-<xsl:value-of select="$rangeMetaElementInformationItem"/>_<xsl:value-of select="$domainElementInformationItem"/>
					</xsl:variable>
					<xsl:sequence select="$rangeElementInformationItem"/>
				</xsl:otherwise>
			
		</xsl:choose>
		
		<!-- ............... -->
		<!-- 28.04.2012 -->
		</xsl:if>
		<!-- ..... -->
		
	</xsl:template>	
	
</xsl:stylesheet>
