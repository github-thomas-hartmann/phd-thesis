package RDFValidation.controller;

import helper.DynaTree;
import helper.FileHelper;
import helper.FileMeta;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import RDFValidation.JenaSPARQLQueries;
import RDFValidation.SPARQLEndpointValidation;
import RDFValidation.Spin;
import RDFValidation.ValidationEnvironment;
import RDFValidation.ValidationExecution;

@Controller
@SessionAttributes( "validationEnvironment" )
@RequestMapping( value = "/skos" )
public class SKOSController
{
	/* multiple file upload */
	LinkedList<FileMeta> files = new LinkedList<FileMeta>();

	/* file */
	FileMeta fileMeta = null;

	/* resource skos path */
	final String skosResourcePath = "/resources/rdfGraphs/SKOS/";
	final String fileUploadPath = "/resources/uploaded_files/";

	// skos main
	@RequestMapping( method = RequestMethod.GET )
	public ModelAndView landing( @RequestParam( value = "sessionid", required = false ) final String sessionId, final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "skos-main", "link", "skos" );

		if ( sessionId != null && sessionId.equals( "0" ) )
			response.setHeader( "SESSION_INVALID", "yes" );

		// initialize session variable
		model.addObject( "validationEnvironment", new ValidationEnvironment() );
		
		List<String> thesauri = new ArrayList<String>();
		thesauri.add( "TheSoz" );
		thesauri.add( "STW Thesaurus for Economics" );
		thesauri.add( "AGROVOC" );
		thesauri.add( "DBpedia" );
		model.addObject("thesauri", thesauri);

		return model;
	}

	/**
	 * skos demo
	 */
	@RequestMapping( value = "/demo", method = RequestMethod.GET )
	public ModelAndView demo( @RequestParam( value = "sessionid", required = false ) final String sessionId, final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "skos-demo", "link", "skos" );
		
		return model;
	}

	@RequestMapping( value = "/demo/validation", method = RequestMethod.POST )
	public ModelAndView demo_tab3( 
		HttpServletRequest request,
		@RequestParam( "nameSpaceDeclaration" ) String nameSpaceDeclarationInput, 
		@RequestParam( "constraints" ) String constraintsInput, 
		@RequestParam( "data" ) String dataInput,
		@RequestParam( value = "thesauri[]", required = false ) final String[] thesauri )
	{
		ModelAndView model = new ModelAndView( "skos-demo-validation", "link", "skos" );

		// input graph
		// - add line separators at the end of each input graph
		String ND = new StringBuilder( nameSpaceDeclarationInput ).append( "\r\n" ).toString();
		String C = new StringBuilder( constraintsInput ).append( "\r\n" ).toString();
		String D = new StringBuilder( dataInput ).append( "\r\n" ).toString();
		String inputRDFGraph = new StringBuilder( ND ).append( C ).append( D ).toString();

		// constraints
		String[] constraints = new String[]{
			"SKOS-C-DATA-MODEL-CONSISTENCY-01 (!)",
			"SKOS-C-DATA-MODEL-CONSISTENCY-02 (!)",
			"SKOS-C-DATA-MODEL-CONSISTENCY-03 (!)",
			"SKOS-C-PROPERTY-DOMAIN-01 (!)",
			"SKOS-C-PROPERTY-RANGES-01 (!)",
			"SKOS-C-DISJOINT-PROPERTIES-01 (!)",
			"SKOS-C-DISJOINT-PROPERTIES-02 (!)",
			"SKOS-C-DISJOINT-PROPERTIES-02 (!)",
			"SKOS-C-DISJOINT-CLASSES-01 (!)",
			"SKOS-C-EQUIVALENT-PROPERTIES-01 (!)",
			"SKOS-C-UNIVERSAL-QUANTIFICATIONS-01 (!)",
			"SKOS-C-CONTEXT-SPECIFIC-VALID-CLASSES-01 (!)",
			"SKOS-C-CONTEXT-SPECIFIC-VALID-PROPERTIES-01 (!)",
			"SKOS-C-LANGUAGE-TAG-CARDINALITY-01",
			"SKOS-C-LANGUAGE-TAG-CARDINALITY-02",
			"SKOS-C-LANGUAGE-TAG-CARDINALITY-03",
			"SKOS-C-LANGUAGE-TAG-CARDINALITY-04",
			"SKOS-C-RECOMMENDED-PROPERTIES-01 (!)",
			"SKOS-C-STRUCTURE-01",
			"SKOS-C-STRUCTURE-02 (!)",
			"SKOS-C-STRUCTURE-03",
			"SKOS-C-STRUCTURE-04",
			"SKOS-C-STRUCTURE-05",
			"SKOS-C-STRUCTURE-06",
			"SKOS-C-STRUCTURE-07",
			"SKOS-C-STRUCTURE-08 (!)",
			"SKOS-C-STRUCTURE-09",
			"SKOS-C-STRUCTURE-10",
			"SKOS-C-LABELING-AND-DOCUMENTATION-01",
			"SKOS-C-LABELING-AND-DOCUMENTATION-02",
			"SKOS-C-LABELING-AND-DOCUMENTATION-03",
			"SKOS-C-LABELING-AND-DOCUMENTATION-04 (!)",
			"SKOS-C-LABELING-AND-DOCUMENTATION-05",
			"SKOS-C-LABELING-AND-DOCUMENTATION-06",
			"SKOS-C-VOCABULARY-01 (!)"
		};
		
		String absolutePathConstraints = request.getSession().getServletContext().getRealPath( "/resources/rdfGraphs/SKOS/SPARQL" );
		ValidationExecution validationExecution = new ValidationExecution( absolutePathConstraints, inputRDFGraph, constraints );
		validationExecution.validate();

		model.addObject( "constraintViolationList", validationExecution.constraintViolationList );
		
		// counts ( constraints grouped by constraint type )
		model.addObject( "countInformations", validationExecution.countInformations );
		model.addObject( "countWarnings", validationExecution.countWarnings );
		model.addObject( "countErrors", validationExecution.countErrors );
		
		// validation exception
		if ( validationExecution.validationException != null )
			model.addObject( "validationException", validationExecution.validationException );
		
		// garbage collection
		validationExecution = null;
		
		// constraint descriptions
		Hashtable<String,String> constraintDescriptions = new Hashtable<String,String>();
		constraintDescriptions.put(
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-05", 
			"No duplicate observations: No two qb:Observations in the same qb:DataSet may have the same value for all dimensions." );
		model.addObject( "constraintDescriptions", constraintDescriptions );
		constraintDescriptions.put(
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-06", 
			"Required attributes: Every qb:Observation has a value for each declared attribute that is marked as required." );
		model.addObject( "constraintDescriptions", constraintDescriptions );

		return model;
	}

	/**
	 * skos UPLOAD
	 */
	@RequestMapping( value = "/upload", method = RequestMethod.GET )
	public ModelAndView uploadGraphInitial( /* tab1 get content via ajax */
	@RequestParam( value = "sessionid", required = false ) final String sessionId, final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "skos-upload", "link", "skos" );

//		String rdfGraph = 
//			"@prefix xsd: <http://www.w3.org/2001/XMLSchema#> . @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> . @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> . @prefix owl: <http://www.w3.org/2002/07/owl#> .  @prefix dcterms: <http://purl.org/dc/terms#> . @prefix skos: <http://www.w3.org/2004/02/skos/core#> . @prefix foaf: <http://xmlns.com/foaf/0.1/#> . @prefix: <http://www.example.org/skos/data#> .";
//		
//		SpinSKOS spin = new SpinSKOS( "SKOS_SPIN-Mapping.ttl", "thesoz_0_93.ttl" );
//		spin.runInferences_checkConstraints( rdfGraph );
//
//		model.addObject( "skosValidationResult", spin.validationResults );
//		model.addObject( "constraintViolationList", spin.getConstraintViolationList() );
//
//		// SPIN exception
//		if ( spin.getSPINException() != null )
//		{
//			model.addObject( "spinException", spin.getSPINException() );
//		}
		
		List<String> constraints = new ArrayList<String>();
		constraints.add( "Omitted or Invalid Language Tags" );
		constraints.add( "Incomplete Language Coverage" );
		model.addObject( "constraints", constraints );
		
		return model;
	}

	/* skos upload validation */
	@RequestMapping( value = "/upload/validation", method = RequestMethod.POST )
	public ModelAndView uploadGraphValidation( 
		HttpServletRequest request, 
		HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "skos-upload-validation", "link", "skos" );

		if ( this.files != null && this.files.size() > 0 )
		{
			String rdfGraph = "";
			for ( FileMeta fm : files )
			{
				// add file content
				rdfGraph += fm.getFileContent();
				rdfGraph += "\r\n";
			}

			// add predefined namespace declarations to RDF graph
			String absolutePath = request.getSession().getServletContext().getRealPath( skosResourcePath );
			absolutePath = absolutePath + "/" + "defaultNamespaceDeclarations.ttl";
			// get predefined namespace content and append to rdfGraph
			FileMeta fileMeta = FileHelper.getFileDetails( absolutePath );
			rdfGraph += fileMeta.getFileContent();

			Spin spin = new Spin( "SKOS//SKOS-2-SPIN.ttl", "technology-driven-validation.ttl", "SKOS//skos.ttl" );
			spin.runInferences_checkConstraints( rdfGraph );

			model.addObject( "skosValidationResult", spin.validationResults );
			model.addObject( "constraintViolationList", spin.getConstraintViolationList() );

			// SPIN exception
			if ( spin.getSPINException() != null )
			{
				model.addObject( "spinException", spin.getSPINException() );
			}
		}
		return model;
	}

	/** END UPLOAD GRAPH */

	/**
	 * UTILITY METHODS
	 */

	/**
	 * Upload document via jquery ajax file upload
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping( value = "/upload", method = RequestMethod.POST )
	public ModelAndView upload( MultipartHttpServletRequest request, HttpServletResponse response )
	{
		// absolute path
		// String absolutePath = this.getClass().getClassLoader().getResource(
		// "rdfGraphs" ).getPath();
		// absolutePath = absolutePath.substring( 1, absolutePath.length() - 1
		// );
		// String absolutePath =
		// request.getSession().getServletContext().getRealPath(
		// skosResourcePath
		// );
		String absolutePath = request.getSession().getServletContext().getRealPath( fileUploadPath );

		// build an iterator
		Iterator<String> itr = request.getFileNames();
		MultipartFile mpf = null;

		// get each file
		while (itr.hasNext())
		{
			// get next MultipartFile
			mpf = request.getFile( itr.next() );
			// upload file and get the file back
			fileMeta = FileHelper.uploadFile( request, mpf, absolutePath, fileUploadPath );
		}


		ModelAndView model = new ModelAndView( "skos-upload-validation", "link", "skos" );

		if ( this.files != null && this.files.size() > 0 )
		{
			String rdfGraph = "";
			for ( FileMeta fm : files )
			{
				// add file content
				rdfGraph += fm.getFileContent();
				rdfGraph += "\r\n";
			}

			// add predefined namespace declarations to RDF graph
			absolutePath = absolutePath + "/" + "defaultNamespaceDeclarations.ttl";
			// get predefined namespace content and append to rdfGraph
			FileMeta fileMeta = FileHelper.getFileDetails( absolutePath );
			rdfGraph += fileMeta.getFileContent();

			
			
//			try {
//				URL u = new URL("https://github.com/boschthomas/rdf-validation/blob/master/data/skos-examples.ttl");
//				URLConnection uc = u.openConnection();
//			    String contentType = uc.getContentType();
//			    int contentLength = uc.getContentLength();
//			    if (contentType.startsWith("text/") || contentLength == -1) {
//			      throw new IOException("This is not a binary file.");
//			    }
//			    InputStream raw = uc.getInputStream();
//			    InputStream in = new BufferedInputStream(raw);
//			    byte[] data = new byte[contentLength];
//			    int bytesRead = 0;
//			    int offset = 0;
//			    while (offset < contentLength) {
//			        bytesRead = in.read(data, offset, data.length - offset);
//			        if (bytesRead == -1)
//			          break;
//			        offset += bytesRead;
//			      }
//			      in.close();
//
//			      if (offset != contentLength) {
//			        throw new IOException("Only read " + offset + " bytes; Expected " + contentLength + " bytes");
//			      }
//			}
//			catch (IOException e){}
			
			
			
			
			Spin spin = new Spin( "SKOS//SKOS-2-SPIN.ttl", "technology-driven-validation.ttl", "SKOS//skos.ttl" );
			spin.runInferences_checkConstraints( rdfGraph );

			model.addObject( "constraintViolationList", spin.getConstraintViolationList() );

			// SPIN exception
			if ( spin.getSPINException() != null )
			{
				model.addObject( "spinException", spin.getSPINException() );
			}
		}
		return model;
	}

	/**
	 * Upload document via jquery ajax file upload
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping( value = "/multiple-file-upload", method = RequestMethod.POST )
	public ModelAndView multiUpload( 
		MultipartHttpServletRequest request, 
		HttpServletResponse response,
		@RequestParam( value = "constraints[]", required = false ) final String[] constraints )
	{
		// get full path
		String fullPath = request.getSession().getServletContext().getRealPath( "/" );

		// build an iterator
		Iterator<String> itr = request.getFileNames();
		MultipartFile mpf = null;

		// get each file
		while (itr.hasNext())
		{
			// get next MultipartFile
			mpf = request.getFile( itr.next() );
			// upload file and get the file back
			fileMeta = FileHelper.uploadFile( request, mpf, fullPath, fileUploadPath );

			// add to linkedList
			files.add( fileMeta );
		}

		ModelAndView model = new ModelAndView( "skos-upload-validation", "link", "skos" );

		if ( this.files != null && this.files.size() > 0 )
		{
			String rdfGraph = "";
			
			// add predefined namespace declarations to RDF graph
			fullPath = fullPath + "/resources/rdfGraphs/SKOS/defaultNamespaceDeclarations.ttl";
			FileMeta fileMeta = FileHelper.getFileDetails( fullPath );
			rdfGraph += fileMeta.getFileContent();
			rdfGraph += "\r\n";
			
			for ( FileMeta fm : files )
			{
				// add file content
				rdfGraph += fm.getFileContent();
				rdfGraph += "\r\n";
			}

//			Spin spin = new Spin( "SKOS-2-SPIN.ttl", "technology-driven-validation.ttl", "skos.ttl" );
//			spin.runInferences_checkConstraints( rdfGraph );

//			model.addObject( "constraintViolationList", spin.getConstraintViolationList() );

			model.addObject( "rdfGraph", rdfGraph );
			model.addObject( "rdfGraphEnd", rdfGraph.substring( rdfGraph.length() - 100, rdfGraph.length() ) );
			
//			// SPIN exception
//			if ( spin.getSPINException() != null )
//			{
//				model.addObject( "spinException", spin.getSPINException() );
//			}
		}
		return model;
	}

	@RequestMapping( value = "/getuploaded", method = RequestMethod.GET )
	public @ResponseBody
	LinkedList<FileMeta> getUploaded()
	{
		return files;
	}

	@RequestMapping( value = "/deleteFile", method = RequestMethod.POST )
	public @ResponseBody
	String deleteFile( @RequestParam( value = "filename" ) String filename, HttpServletRequest request, HttpServletResponse response )
	{
		// removing files from the list
		Iterator<FileMeta> iteratorFiles = files.iterator();
		while (iteratorFiles.hasNext())
			if ( iteratorFiles.next().getFileName().equalsIgnoreCase( filename ) )
				iteratorFiles.remove();

		// String absolutePath =
		// request.getSession().getServletContext().getRealPath(
		// skosFileUploadPath );
		// remove file from the local drive.
		// FileHelper.deleteFile( absolutePath + filename );

		return "success";
	}

	/**
	 * get detail of document from specific folder
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping( value = "/file_details", method = RequestMethod.POST )
	public @ResponseBody
	FileMeta getFileDetails( @RequestParam( "filePath" ) String filePath, @RequestParam( value = "additionalPath", required = false ) String additionalPath, HttpServletRequest request, HttpServletResponse response )
	{
		// String absolutePath = this.getClass().getClassLoader().getResource(
		// skosResourcePath ).getPath();
		// absolutePath = absolutePath.substring( 1, absolutePath.length() - 1
		// );
		// absolutePath = absolutePath + "/" + filePath;

		String absolutePath = request.getSession().getServletContext().getRealPath( additionalPath != null ? additionalPath : skosResourcePath );
		absolutePath = absolutePath + "/" + filePath;

		// return FileHelper.getFileDetails( request, absolutePath,
		// skosResourcePath + filePath );
		return FileHelper.getFileDetails( absolutePath );
	}

	/**
	 * Get the json structure of specific folder
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping( value = "/resource_structure", method = RequestMethod.POST )
	public @ResponseBody
	List<DynaTree> directoryStructure( @RequestParam( value = "specificDirectory", required = false ) String specificDirectory, HttpServletRequest request, HttpServletResponse response )
	{
		DynaTree dynaTree = new DynaTree( "root", null, true, "/", null );
		// get full path
		String fullPath = request.getSession().getServletContext().getRealPath( specificDirectory != null ? specificDirectory : skosResourcePath );
		// System.out.println( fullPath );

		// System.out.println(this.getClass().getClassLoader().getResource(
		// "rdfGraphs" ).getPath());

		// String absolutePath = this.getClass().getClassLoader().getResource(
		// "/rel.txt" ).getPath();
		// absolutePath = absolutePath.substring( 1, absolutePath.length() - 8
		// );
		// System.out.println( absolutePath );

		// System.out.println(absolutePath.lastIndexOf( "resources" ));

		// absolutePath = absolutePath.substring( 0, absolutePath.lastIndexOf(
		// "resources" ) - 9 ) + absolutePath.substring(
		// absolutePath.lastIndexOf( "resources" ), absolutePath.length() );

		// replace %20 in absolute path of web app
		// absolutePath = absolutePath.replace( "%20", " " );

		// dynaTree.addChild( new DynaTree( absolutePath, null, true, "/", null
		// ) );

		// String test = fullPath + "/";
		// get the directory structure
		// dynaTree.setChildren( convertDirectoryToDynaTree( new File(
		// "C:/Program Files/ApacheTomcat8/webapps/rdf-validation/WEB-INF/classes/rdfGraphs"
		// + "/" ), "" ) );
		// dynaTree.setChildren( convertDirectoryToDynaTree( new File(
		// "lelystad.informatik.uni-mannheim.de" + "/" ), "" ) );
		dynaTree.setChildren( FileHelper.convertDirectoryToDynaTree( new File( fullPath ), "", true ) );
		// dynaTree.setChildren( convertDirectoryToDynaTree( new File(
		// "127.0.0.1" + "/" ), "" ) );

		// testing
		// List<DynaTree> listDynaTree = new ArrayList<DynaTree>();
		// listDynaTree.add( new DynaTree(
		// this.getClass().getClassLoader().getResource( "/" +
		// "SPIN/functions/skos-functions.ttl" ).getPath(), null, true, "/",
		// null
		// ) );
		// dynaTree.setChildren( listDynaTree );

		// return json
		return dynaTree.getChildren();
	}

	@RequestMapping( value = "/endpoint", method = RequestMethod.GET )
	public ModelAndView endpoint( 
		@RequestParam( value = "sessionid", required = false ) final String sessionId, 
		final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "skos-endpoint", "link", "skos" );
		
		// SPARQL endpoints
		List<String> sparqlEndpoints = new ArrayList<String>();
//		sparqlEndpoints.add( "SKOS example data (http://svbotomcat01:8080/openrdf-sesame/repositories/rdf-validation-skos)" );
		sparqlEndpoints.add( "Thesaurus for the Social Sciences (TheSoz) (http://lod.gesis.org/thesoz/sparql)" );
		sparqlEndpoints.add( "TheSoz Testsystem (http://svbotomcat01:8080/openrdf-sesame/repositories/sparql)" ); 
		sparqlEndpoints.add( "STW Thesaurus for Economics of the ZBW (http://zbw.eu/beta/sparql/stw/query)" );
		sparqlEndpoints.add( "AGROVOC Multilingual agricultural thesaurus (http://202.45.139.84:10035/catalogs/fao/repositories/agrovoc)" );
		sparqlEndpoints.add( "The Getty Thesaurus of Geographic Names (TGN) (http://vocab.getty.edu/sparql)" );
		sparqlEndpoints.add( "UNESCO Thesaurus (http://skos.um.es/sparql/)" );
		sparqlEndpoints.add( "Open Data Thesaurus (ODT) (http://vocabulary.semantic-web.at/PoolParty/sparql/OpenData)" );
		sparqlEndpoints.add( "Social Semantic Web Thesaurus (SSWT) (http://vocabulary.semantic-web.at/PoolParty/sparql/semweb)" );
		sparqlEndpoints.add( "Thesaurus of the Geological Survey of Austria - Geology Unit (GBA-GU) (http://resource.geolba.ac.at/PoolParty/sparql/GeologicUnit)" );
		sparqlEndpoints.add( "Thesaurus of the Geological Survey of Austria - Geologic Time Scale (GBA-GTS) (http://resource.geolba.ac.at/PoolParty/sparql/GeologicTimeScale)" );
		sparqlEndpoints.add( "Thesaurus of the Geological Survey of Austria - Lithology (GBA-L) (http://resource.geolba.ac.at/PoolParty/sparql/lithology)" );
		sparqlEndpoints.add( "Thesaurus of the Geological Survey of Austria - Lithotectonic Unit (GBA-LU) (http://resource.geolba.ac.at/PoolParty/sparql/tectonicunit)" );
		sparqlEndpoints.add( "Clean Energy and Climate Change Thesaurus (CECCT) (http://poolparty.reegle.info/PoolParty/sparql/glossary)" );
		sparqlEndpoints.add( "Environmental Applications Reference Thesaurus (EARTh) (http://linkeddata.ge.imati.cnr.it:8890/sparql)" );
		sparqlEndpoints.add( "GEneral Multilingual Environmental Thesaurus (GEMET) (http://semantic.eea.europa.eu/sparql)" );
		sparqlEndpoints.add( "EuroVoc (https://open-data.europa.eu/sparqlep)" );
		sparqlEndpoints.add( "Spanish Linguistic Datasets (SLD) (http://linguistic.linkeddata.es/sparql)" );
		model.addObject( "sparqlEndpoints", sparqlEndpoints );
		
		// constraints
		Hashtable<String,List<String>> constraintsByConstraintType = new Hashtable<String,List<String>>();
		
		List<String> constraints_0 = new ArrayList<String>();
		constraints_0.add( "SKOS-C-DATA-MODEL-CONSISTENCY-01 (!)" );
		constraints_0.add( "SKOS-C-DATA-MODEL-CONSISTENCY-02 (!)" );
		constraints_0.add( "SKOS-C-DATA-MODEL-CONSISTENCY-03 (!)" );
		constraintsByConstraintType.put("Data Model Consistency", constraints_0 );
		
		List<String> constraints_1 = new ArrayList<String>();
		constraints_1.add( "SKOS-C-PROPERTY-DOMAIN-01 (!)" );
		constraintsByConstraintType.put("Property Domains", constraints_1 );
		
		List<String> constraints_2 = new ArrayList<String>();
		constraints_2.add( "SKOS-C-PROPERTY-RANGES-01 (!)" );
		constraintsByConstraintType.put("Property Ranges", constraints_2 );
		
		List<String> constraints_3 = new ArrayList<String>();
		constraints_3.add( "SKOS-C-DISJOINT-PROPERTIES-01 (!)" );
		constraints_3.add( "SKOS-C-DISJOINT-PROPERTIES-02 (!)" );
		constraintsByConstraintType.put("Disjoint Properties", constraints_3 );
		
		List<String> constraints_4 = new ArrayList<String>();
		constraints_4.add( "SKOS-C-DISJOINT-CLASSES-01 (!)" );
		constraintsByConstraintType.put("Disjoint Classes", constraints_4 );
		
		List<String> constraints_5 = new ArrayList<String>();
		constraints_5.add( "SKOS-C-EQUIVALENT-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Equivalent Properties", constraints_5 );
		
		List<String> constraints_6 = new ArrayList<String>();
		constraints_6.add( "SKOS-C-UNIVERSAL-QUANTIFICATIONS-01 (!)" );
		constraintsByConstraintType.put("Universal Quantifications", constraints_6 );
		
		List<String> constraints_7 = new ArrayList<String>();
		constraints_7.add( "SKOS-C-CONTEXT-SPECIFIC-VALID-CLASSES-01 (!)" );
		constraintsByConstraintType.put("Context-Specific Valid Classes", constraints_7 );
		
		List<String> constraints_8 = new ArrayList<String>();
		constraints_8.add( "SKOS-C-CONTEXT-SPECIFIC-VALID-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Context-Specific Valid Properties", constraints_8 );
		
		List<String> constraints_9 = new ArrayList<String>();
		constraints_9.add( "SKOS-C-LANGUAGE-TAG-CARDINALITY-01" );
		constraints_9.add( "SKOS-C-LANGUAGE-TAG-CARDINALITY-02" );
		constraints_9.add( "SKOS-C-LANGUAGE-TAG-CARDINALITY-03" );
		constraints_9.add( "SKOS-C-LANGUAGE-TAG-CARDINALITY-04" );
		constraintsByConstraintType.put("Language Tag Cardinality", constraints_9 );
		
		List<String> constraints_10 = new ArrayList<String>();
		constraints_10.add( "SKOS-C-RECOMMENDED-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Recommended Properties", constraints_10 );
		
		List<String> constraints_11 = new ArrayList<String>();
		constraints_11.add( "SKOS-C-STRUCTURE-01" );
		constraints_11.add( "SKOS-C-STRUCTURE-02 (!)" );
		constraints_11.add( "SKOS-C-STRUCTURE-03" );
		constraints_11.add( "SKOS-C-STRUCTURE-04" );
		constraints_11.add( "SKOS-C-STRUCTURE-05" );
		constraints_11.add( "SKOS-C-STRUCTURE-06" );
		constraints_11.add( "SKOS-C-STRUCTURE-07" );
		constraints_11.add( "SKOS-C-STRUCTURE-08 (!)" );
		constraints_11.add( "SKOS-C-STRUCTURE-09" );
		constraints_11.add( "SKOS-C-STRUCTURE-10" );
		constraintsByConstraintType.put("Structure", constraints_11 );
		
		List<String> constraints_12 = new ArrayList<String>();
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-01" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-02" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-03" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-04 (!)" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-05" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-06" );
		constraintsByConstraintType.put("Labeling and Documentation", constraints_12 );
		
		List<String> constraints_13 = new ArrayList<String>();
		constraints_13.add( "SKOS-C-VOCABULARY-01 (!)" );
		constraintsByConstraintType.put("Vocabulary", constraints_13 );
		
		List<String> constraints_14 = new ArrayList<String>();
		constraints_14.add( "SKOS-C-HTTP-URI-SCHEME-VIOLATION (!)" );
		constraintsByConstraintType.put("HTTP URI Scheme Violation", constraints_14 );
		
//		List<String> constraints_14 = new ArrayList<String>();
//		constraints_14.add( "count-triples" );
//		constraints_14.add( "count-triples-2" );
//		constraints_14.add( "count-conceptscheme" );
//		constraints_14.add( "count-concept" );
//		constraints_14.add( "count-broader" );
//		constraints_14.add( "count-narrower" );
//		constraints_14.add( "count-hasTopConcept" );
//		constraints_14.add( "count-inScheme" );
//		constraintsByConstraintType.put("counts", constraints_14 );
		
		model.addObject( "constraintsByConstraintType", constraintsByConstraintType );
		
		return model;
	}
	
	@RequestMapping( value = "/endpoint/validation", method = RequestMethod.POST )
	public ModelAndView endpointValidation( 
		@RequestParam( value = "sparqlEndpoint", required = true ) String sparqlEndpoint,
		@RequestParam( value = "constraint", required = true ) String constraint,
		@RequestParam( value = "limit", required = true ) String limit,
		HttpServletRequest request )
	{
		ModelAndView model = new ModelAndView( "skos-endpoint-validation", "link", "datacube" );

//		// SPARQL endpoints ( testing )
//		List<String> endpoints = new ArrayList<String>();
//		endpoints.add( "TheSoz (http://svbotomcat01:8080/openrdf-sesame/repositories/sparql)" ); 
//		String[] ep = new String[ endpoints.size() ];
//		ep = endpoints.toArray( ep );
		
//		// constraints ( testing )
//		List<String> constraintsList = new ArrayList<String>();
//		constraintsList.add( "SKOS-C-LABELING-AND-DOCUMENTATION-01" );
//		String[] c = new String[ constraintsList.size() ];
//		c = constraintsList.toArray( c );
		
		// parameters
		String[] sparqlEndpoints = new String[]{ sparqlEndpoint };
		String[] constraints = new String[]{ constraint };
		model.addObject( "sparqlEndpoint", sparqlEndpoint );
		model.addObject( "constraint", constraint );
		model.addObject( "limit", limit );
		
		String absolutePathConstraints = request.getSession().getServletContext().getRealPath( "/resources/rdfGraphs/SKOS/SPARQL" );
		SPARQLEndpointValidation sparqlEndpointValidation = new SPARQLEndpointValidation( absolutePathConstraints, sparqlEndpoints, constraints, limit );
		sparqlEndpointValidation.validate();

		model.addObject( "constraintViolationList", sparqlEndpointValidation.constraintViolationList );
		
		// counts ( constraints grouped by constraint type )
		model.addObject( "countInformations", sparqlEndpointValidation.countInformations );
		model.addObject( "countWarnings", sparqlEndpointValidation.countWarnings );
		model.addObject( "countErrors", sparqlEndpointValidation.countErrors );
		
		// validation exception
		if ( sparqlEndpointValidation.validationException != null )
			model.addObject( "validationException", sparqlEndpointValidation.validationException );
		
		// garbage collection
		sparqlEndpointValidation = null;
		
		// constraint descriptions
		Hashtable<String,String> constraintDescriptions = new Hashtable<String,String>();
		constraintDescriptions.put(
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-05", 
			"No duplicate observations: No two qb:Observations in the same qb:DataSet may have the same value for all dimensions." );
		model.addObject( "constraintDescriptions", constraintDescriptions );

		return model;
	}
	
}
