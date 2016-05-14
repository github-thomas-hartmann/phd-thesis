::Saxon-B 9.1.0.8

ECHO OFF

SET absolutePath=C:\Daten\Studium\Promotion\journals\2013\IJMSO\evaluation\XSDs
SET absolutePathXSDs=C:\Daten\Studium\Promotion\dissertation\ontologies\XMLSchemaMetamodelOntology\XMLSchemas

::cd..
::cd..
::cd..
::cd..
::cd..
::cd..

::PROMPT $T

:: time
::SET X=%TIME%
::ECHO %X:~0,12%
ECHO %TIME:~0,12%

::DDI3.1
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\archive.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\archive.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\comparative.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\comparative.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\conceptualcomponent.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\conceptualcomponent.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\datacollection.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\datacollection.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\dataset.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\dataset.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\ddiprofile.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\ddiprofile.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\ddi-xhtml11.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\ddi-xhtml11.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\ddi-xhtml11-model-1.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\ddi-xhtml11-model-1.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\ddi-xhtml11-modules-1.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\ddi-xhtml11-modules-1.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\group.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\group.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\instance.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\instance.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\logicalproduct.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\logicalproduct.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\physicaldataproduct.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\physicaldataproduct.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\physicaldataproduct_ncube_inline.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\physicaldataproduct_ncube_inline.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\physicaldataproduct_ncube_normal.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\physicaldataproduct_ncube_normal.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\physicaldataproduct_ncube_tabular.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\physicaldataproduct_ncube_tabular.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\physicaldataproduct_proprietary.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\physicaldataproduct_proprietary.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\physicalinstance.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\physicalinstance.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\reusable.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\reusable.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\DDI3.1\studyunit.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\DDI3.1\studyunit.txt
	
::SimpleDC
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\SimpleDC\simpledc20021212.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\SimpleDC\simpledc20021212.txt
	
::QualifiedDC
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\QualifiedDC\dc.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\QualifiedDC\dc.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\QualifiedDC\dcmitype.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\QualifiedDC\dcmitype.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\QualifiedDC\dcterms.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\QualifiedDC\dcterms.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\QualifiedDC\qualifieddc.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\QualifiedDC\qualifieddc.txt
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\QualifiedDC\simpledc.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\QualifiedDC\simpledc.txt
	
::KML
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\KML2.1\kml21.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\KML2.1\kml21.txt
	
::ASF
::java net.sf.saxon.Transform -s:%absolutePathXSDs%\ASF\atom.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\ASF\atom.txt
	
::AIM
java net.sf.saxon.Transform -s:%absolutePathXSDs%\AIM\AIM_v4_rv44_XML.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\AIM\AIM_v4_rv44_XML.txt
java net.sf.saxon.Transform -s:%absolutePathXSDs%\AIM\ISO_datatypes_Narrative.xsd -xsl:%absolutePath%\countXSDConstructs.xsl -o:%absolutePath%\AIM\ISO_datatypes_Narrative.txt
	
ECHO %TIME:~0,12%
	
PAUSE