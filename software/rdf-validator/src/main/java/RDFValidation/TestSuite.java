package RDFValidation;

import java.util.ArrayList;
import java.util.List;

public class TestSuite {

	public static void main(String[] args) {
		DiscoTestSuite();
//		DataCubeTestSuite();
//		SKOSTestSuite();
		
		System.exit(0);
	}
	
	public static void DiscoTestSuite() {
		
		// SPARQL endpoints
		String[] sparqlEndpoints = new String[]{
//			"Microdata Information System (Missy) (http://svko-missy:8181/openrdf-sesame/repositories/native-java-store)",
			"Missy Local Testsystem (http://localhost:8081/openrdf-sesame/repositories/missy)"
//			"DwB Discovery Portal (DwB) (http://dwb-dev.nsd.uib.no/sparql)",
//			"DDA and SND DDI-RDF (DDA-SND) (http://ddi-rdf.borsna.se/endpoint/)"
		};
		
		// constraints
		String[] constraints = new String[]{
//			"count-triples",
//			"count-study-group"
//			"count-study",
//			"count-logical-data-set",
//			"count-universe",
//			"count-variable",
//			"count-question",
//			"count-summary-statistics",
//			"count-category-statistics",
//			"count-concept"
//			"DISCO-C-ALLOWED-VALUES-01"
//			"DISCO-C-LITERAL-RANGES-01"
//			"DISCO-C-INVERSE-FUNCTIONAL-PROPERTIES-01"
//			"DISCO-C-INVERSE-FUNCTIONAL-PROPERTIES-02"
//			"DISCO-C-CLASS-SPECIFIC-PROPERTY-RANGE-01"
//			"DATA-CUBE-C-MEMBERSHIP-IN-CONTROLLED-VOCABULARIES-01"
//			"DISCO-C-LITERAL-VALUE-COMPARISON-01"
//			"DISCO-C-CONTEXT-SPECIFIC-VALID-PROPERTIES-01"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-01",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-02",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-03",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-04",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-05",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-06",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-07",
			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-08"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-09",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-10"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-11",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-12",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-13",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-14",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-15",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-16",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-17",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-18",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-19",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-20",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-21",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-22"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-23",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-24"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-25",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-26"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-27"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-28",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-29",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-30",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-31"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-32",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-33",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-34"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-35",
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-36"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-37"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-38"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-39"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-40"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-41"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-42"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-43"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-44"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-45"
//			"DISCO-C-EXISTENTIAL-QUANTIFICATIONS-46"
//			"DISCO-C-CONDITIONAL-PROPERTIES-01"
//			"DISCO-C-CONDITIONAL-PROPERTIES-02"
//			"DISCO-C-CONDITIONAL-PROPERTIES-03"
//			"DISCO-C-CONDITIONAL-PROPERTIES-04",
//			"DISCO-C-CONDITIONAL-PROPERTIES-05"
//			"DISCO-C-CONDITIONAL-PROPERTIES-06"
//			"DISCO-C-DATA-PROPERTY-FACETS-01",
//			"DISCO-C-DATA-PROPERTY-FACETS-02"
//			"DISCO-C-PROVENANCE-01",
//			"DISCO-C-PROVENANCE-02",
//			"DISCO-C-PROVENANCE-03",
//			"DISCO-C-PROVENANCE-04",
//			"DISCO-C-LABELING-AND-DOCUMENTATION-01",
//			"DISCO-C-LABELING-AND-DOCUMENTATION-02",
//			"DISCO-C-LABELING-AND-DOCUMENTATION-03",
//			"DISCO-C-LABELING-AND-DOCUMENTATION-04",
//			"DISCO-C-LABELING-AND-DOCUMENTATION-05",
//			"DISCO-C-LABELING-AND-DOCUMENTATION-06"
//			"DISCO-C-VALUE-IS-VALID-FOR-DATATYPE-01"
//			"DISCO-C-VALUE-IS-VALID-FOR-DATATYPE-02"
//			"DISCO-C-DATA-MODEL-CONSISTENCY-05"
//			"DISCO-C-COMPARISON-VARIABLES-01",
//			"DISCO-C-COMPARISON-VARIABLES-02",
//			"DISCO-C-COMPARISON-VARIABLES-03",
//			"DISCO-C-COMPARISON-VARIABLES-04",
//			"DISCO-C-COMPARISON-VARIABLES-05"
		};
		
		// limit
		String limit = "0";
		
		// print query string
		boolean printQueryString = false;
//		boolean printQueryString = true;
		
		// validate
		String absolutePathConstraints = "C:\\Daten\\workspaces\\rdf-validation\\RDFValidation\\src\\main\\webapp\\resources\\rdfGraphs\\" + "Disco" + "\\SPARQL\\COUNT";
		SPARQLEndpointValidationBatch sparqlEndpointValidationBatch = 
			new SPARQLEndpointValidationBatch( absolutePathConstraints, sparqlEndpoints, constraints, limit, printQueryString );
		sparqlEndpointValidationBatch.validate();
	}
	
	public static void DataCubeTestSuite() {
		// SPARQL endpoints
		String[] sparqlEndpoints = new String[]{	
			// too many triples
//			"European Central Bank (ECB) (http://ecb.270a.info/sparql)",
//			"Food and Agriculture Organization of the United Nations (FAO) (http://fao.270a.info/sparql)",
//			"Federal Reserve Board (FRB) (http://frb.270a.info/sparql)", 
//			"Organisation for Economic Co-operation and Development (OECD) (http://oecd.270a.info/sparql)", 
//			"World Bank (WB) (http://worldbank.270a.info/sparql)",
//			"Australian Bureau of Statistics (ABS) (http://abs.270a.info/sparql)",
//			"ACORN-SAT (http://lab.environment.data.gov.au/sparql)",
//			"HDP (http://healthdata.tw.rpi.edu/sparql)",
				
//			"UNESCO Institute for Statistics (UIS) (http://uis.270a.info/sparql)",
//			"International Monetary Fund (IMF) (http://imf.270a.info/sparql)",
//			"Swiss Federal Statistics Office (BFS) (http://bfs.270a.info/sparql)",
//			"Transparency International (TI) (http://transparency.270a.info/sparql)", 
//			"Bank for International Settlements (BIS) (http://bis.270a.info/sparql)", 
//			"IEEE VIS Source Data (VIS) (http://ieeevis.tw.rpi.edu/sparql)"
			
			// service unavailable
//			"Nomenclator Asturias (Asturias) (http://156.35.31.156/sparql)", // service unavailable
//			"ISTAT Immigration (LinkedOpenData.it) (ISTAT) (http://sparql.linkedopendata.it/istat)", // service unavailable
//			"Statistical Office of Cantabria (Instituto Cántabro de Estad´ıstica, ICANE) (http://www.icane.es/opendata/sparql)", // service unavailable
//			"European Election Results 2009 (EE-2009) (http://api.talis.com/stores/elections/services/sparql)", // service unavailable
//			"Standard Eurobarometer (EU-B) (http://api.talis.com/stores/eurobarometer/services/sparql)", // service unavailable
//			"European Central Bank Statistics (PublicData.eu) (ECB-S) (http://ecb.publicdata.eu/sparql)", // service unavailable
//			"Common Procurement Vocabulary (CPV) 2008 (CPV-2008) (http://156.35.82.103/sparql)", // service unavailable
//			"Common Procurement Vocabulary (CPV) 2003 (CPV-2003) (http://156.35.31.156/sparql)" // service unavailable
//			"Eurostat (http://eurostat.linked-statistics.org/sparql)" // SPARQL Endpoint unavailable
		};
		
		// constraints
		String[] constraints = new String[]{
//			"count-triples"
//			"count-triples-2"
//			"count-data-set"
//			"count-data-structure-definition"
//			"count-observation"
//			"count-slice"
				
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-02",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-03",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-04",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-05",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-06",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-07",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-08",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-09",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-10 (not yet implemented!)",
//			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-11"
				
			"DATA-CUBE-C-MINIMUM-QUALIFIED-CARDINALITY-RESTRICTIONS-02",
			"DATA-CUBE-C-MAXIMUM-QUALIFIED-CARDINALITY-RESTRICTIONS-01",
			"DATA-CUBE-C-EXACT-UNQUALIFIED-CARDINALITY-RESTRICTIONS-01",
			"DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-02"
			
//			"DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-01",
//			"DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-02",
//			"DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-03",
//			"DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-04"
			
//			"DATA-CUBE-C-STRUCTURE-01",
//			"DATA-CUBE-C-STRUCTURE-02"
		};
		
		// limit
		String limit = "0";
		
		// validate
		String absolutePathConstraints = "C:\\Daten\\workspaces\\rdf-validation\\RDFValidation\\src\\main\\webapp\\resources\\rdfGraphs\\" + "DATACUBE" + "\\SPARQL\\COUNT";
		SPARQLEndpointDatasetValidationBatch sparqlEndpointDatasetValidationBatch = 
			new SPARQLEndpointDatasetValidationBatch( absolutePathConstraints, sparqlEndpoints, constraints, limit );
		sparqlEndpointDatasetValidationBatch.validate();
	}
	
	public static void SKOSTestSuite() {
		
		// SPARQL endpoints
		String[] sparqlEndpoints = new String[]{
			"Local SKOS example data (http://localhost:8081/openrdf-sesame/repositories/rdf-validation-skos)",
			"TheSoz Local Testsystem (http://localhost:8081/openrdf-sesame/repositories/TheSoz)",
			"SKOS example data (http://svbotomcat01:8080/openrdf-sesame/repositories/rdf-validation-skos)",
			"TheSoz Testsystem (http://svbotomcat01:8080/openrdf-sesame/repositories/sparql)", 
			"STW Thesaurus for Economics of the ZBW (http://zbw.eu/beta/sparql/stw/query)",
			"AGROVOC Multilingual agricultural thesaurus (http://202.45.139.84:10035/catalogs/fao/repositories/agrovoc)",
			"The Getty Thesaurus of Geographic Names (TGN) (http://vocab.getty.edu/sparql)",
			"UNESCO Thesaurus (http://skos.um.es/sparql/)",
			"Open Data Thesaurus (ODT) (http://vocabulary.semantic-web.at/PoolParty/sparql/OpenData)",
			"Social Semantic Web Thesaurus (SSWT) (http://vocabulary.semantic-web.at/PoolParty/sparql/semweb)",
			"Thesaurus of the Geological Survey of Austria - Geology Unit (GBA-GU) (http://resource.geolba.ac.at/PoolParty/sparql/GeologicUnit)",
			"Thesaurus of the Geological Survey of Austria - Geologic Time Scale (GBA-GTS) (http://resource.geolba.ac.at/PoolParty/sparql/GeologicTimeScale)",
			"Thesaurus of the Geological Survey of Austria - Lithology (GBA-L) (http://resource.geolba.ac.at/PoolParty/sparql/lithology)",
			"Thesaurus of the Geological Survey of Austria - Lithotectonic Unit (GBA-LU) (http://resource.geolba.ac.at/PoolParty/sparql/tectonicunit)",
			"Clean Energy and Climate Change Thesaurus (CECCT) (http://poolparty.reegle.info/PoolParty/sparql/glossary)",
			"Environmental Applications Reference Thesaurus (EARTh) (http://linkeddata.ge.imati.cnr.it:8890/sparql)", 
			"GEneral Multilingual Environmental Thesaurus (GEMET) (http://semantic.eea.europa.eu/sparql)", 
			"EuroVoc (https://open-data.europa.eu/sparqlep)", 
			"Spanish Linguistic Datasets (SLD) (http://linguistic.linkeddata.es/sparql)" 
		};
		
		// constraints
		String[] constraints = new String[]{
//			"count-conceptscheme",
//			"count-concept",
//			"count-broader",
//			"count-narrower",
//			"count-hasTopConcept",
//			"count-inScheme"
//			"SKOS-C-DATA-MODEL-CONSISTENCY-01 (not yet implemented!)",
//			"SKOS-C-DATA-MODEL-CONSISTENCY-02 (not yet implemented!)",
//			"SKOS-C-DATA-MODEL-CONSISTENCY-03 (not yet implemented!)",
//			"SKOS-C-PROPERTY-DOMAIN-01 (not yet implemented!)",
//			"SKOS-C-PROPERTY-RANGES-01 (not yet implemented!)",
//			"SKOS-C-DISJOINT-PROPERTIES-01 (not yet implemented!)",
//			"SKOS-C-DISJOINT-PROPERTIES-02 (not yet implemented!)",
//			"SKOS-C-DISJOINT-PROPERTIES-02 (not yet implemented!)",
//			"SKOS-C-DISJOINT-CLASSES-01 (not yet implemented!)",
//			"SKOS-C-EQUIVALENT-PROPERTIES-01 (not yet implemented!)",
//			"SKOS-C-UNIVERSAL-QUANTIFICATIONS-01 (not yet implemented!)",
//			"SKOS-C-CONTEXT-SPECIFIC-VALID-CLASSES-01 (not yet implemented!)",
//			"SKOS-C-CONTEXT-SPECIFIC-VALID-PROPERTIES-01 (not yet implemented!)",
//			"SKOS-C-LANGUAGE-TAG-CARDINALITY-01",
//			"SKOS-C-LANGUAGE-TAG-CARDINALITY-01_LIMIT-1",
//			"SKOS-C-LANGUAGE-TAG-CARDINALITY-01_LIMIT-2"
//			"SKOS-C-LANGUAGE-TAG-CARDINALITY-02",
//			"SKOS-C-LANGUAGE-TAG-CARDINALITY-03",
			"SKOS-C-LANGUAGE-TAG-CARDINALITY-04",
//			"SKOS-C-RECOMMENDED-PROPERTIES-01 (not yet implemented!)",
//			"SKOS-C-STRUCTURE-01",
//			"SKOS-C-STRUCTURE-02 (not yet implemented!)",
//			"SKOS-C-STRUCTURE-03",
//			"SKOS-C-STRUCTURE-04",
//			"SKOS-C-STRUCTURE-05",
//			"SKOS-C-STRUCTURE-06",
//			"SKOS-C-STRUCTURE-07",
//			"SKOS-C-STRUCTURE-08 (not yet implemented!)",
//			"SKOS-C-STRUCTURE-09",
//			"SKOS-C-STRUCTURE-10",
//			"SKOS-C-LABELING-AND-DOCUMENTATION-01",
//			"SKOS-C-LABELING-AND-DOCUMENTATION-02",
//			"SKOS-C-LABELING-AND-DOCUMENTATION-03",
//			"SKOS-C-LABELING-AND-DOCUMENTATION-04 (not yet implemented!)",
//			"SKOS-C-LABELING-AND-DOCUMENTATION-05",
//			"SKOS-C-LABELING-AND-DOCUMENTATION-06",
//			"SKOS-C-VOCABULARY-01 (not yet implemented!)"
//			"count-triples"
//			"test"
		};
		
		// limit
		String limit = "0";
		
		// print query string
//		boolean printQueryString = false;
		boolean printQueryString = true;
		
		// validate
//		String absolutePathConstraints = "C:\\Daten\\workspaces\\rdf-validation\\RDFValidation\\src\\main\\webapp\\resources\\rdfGraphs\\" + "SKOS" + "\\SPARQL\\COUNT";
//		SPARQLEndpointValidationBatchMode sparqlEndpointValidationBatchMode = new SPARQLEndpointValidationBatchMode( absolutePathConstraints, sparqlEndpoints, constraints, limit, isLogging );
//		sparqlEndpointValidationBatchMode.validate();

		String absolutePathConstraints = "C:\\Daten\\workspaces\\rdf-validation\\RDFValidation\\src\\main\\webapp\\resources\\rdfGraphs\\" + "SKOS" + "\\SPARQL\\COUNT";
		SPARQLEndpointValidationBatch sparqlEndpointValidationBatch = 
			new SPARQLEndpointValidationBatch( absolutePathConstraints, sparqlEndpoints, constraints, limit, printQueryString );
		sparqlEndpointValidationBatch.validate();
	}
}
