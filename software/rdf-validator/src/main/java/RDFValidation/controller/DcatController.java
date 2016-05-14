package RDFValidation.controller;

import helper.DynaTree;
import helper.FileHelper;
import helper.FileMeta;

import java.io.File;
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

import RDFValidation.SPARQLEndpointValidation;
import RDFValidation.Spin;
import RDFValidation.ValidationEnvironment;
import RDFValidation.ValidationExecution;

@Controller
@SessionAttributes( "validationEnvironment" )
@RequestMapping( value = "/dcat" )
public class DcatController
{
	/* multiple file upload */
	LinkedList<FileMeta> files = new LinkedList<FileMeta>();

	/* file */
	FileMeta fileMeta = null;

	/* resource gclo path */
	final String dcatResourcePath = "/resources/rdfGraphs/dcat/";
	final String fileUploadPath = "/resources/uploaded_files/";

	// GCLO main
	@RequestMapping( method = RequestMethod.GET )
	public ModelAndView landing( @RequestParam( value = "sessionid", required = false ) final String sessionId, final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "dcat-main", "link", "dcat" );

		if ( sessionId != null && sessionId.equals( "0" ) )
			response.setHeader( "SESSION_INVALID", "yes" );

		// initialize session variable
		model.addObject( "validationEnvironment", new ValidationEnvironment() );

		return model;
	}

	/**
	 * GCLO demo
	 */
	@RequestMapping( value = "/demo", method = RequestMethod.GET )
	public ModelAndView demo( @RequestParam( value = "sessionid", required = false ) final String sessionId, final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "dcat-demo", "link", "dcat" );
		return model;
	}

	@RequestMapping( value = "/demo/validation", method = RequestMethod.POST )
	public ModelAndView demo_tab3( 
		@RequestParam( "nameSpaceDeclaration" ) String nameSpaceDeclarationInput, 
		@RequestParam( "constraints" ) String constraintsInput, 
		@RequestParam( "data" ) String dataInput,
		HttpServletRequest request )
	{
		ModelAndView model = new ModelAndView( "dcat-demo-validation", "link", "dcat" );

		// input graph
		// - add line separators at the end of each input graph
		String ND = new StringBuilder( nameSpaceDeclarationInput ).append( "\r\n" ).toString();
		String C = new StringBuilder( constraintsInput ).append( "\r\n" ).toString();
		String D = new StringBuilder( dataInput ).append( "\r\n" ).toString();
		String inputRDFGraph = new StringBuilder( ND ).append( C ).append( D ).toString();

		// constraints
		String[] constraints = new String[]{

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
		model.addObject( "constraintDescriptions", constraintDescriptions );

		return model;
	}

	/**
	 * GCLO UPLOAD
	 */
	@RequestMapping( value = "/upload", method = RequestMethod.GET )
	public ModelAndView uploadGraphInitial( /* tab1 get content via ajax */
	@RequestParam( value = "sessionid", required = false ) final String sessionId, final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "dcat-upload", "link", "dcat" );

		return model;
	}

	/* GCLO upload validation */
	@RequestMapping( value = "/upload/validation", method = RequestMethod.POST )
	public ModelAndView uploadGraphValidation( HttpServletRequest request, HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "dcat-upload-validation", "link", "dcat" );

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
			String absolutePath = request.getSession().getServletContext().getRealPath( dcatResourcePath );
			absolutePath = absolutePath + "/" + "defaultNamespaceDeclarations.ttl";
			// get predefined namespace content and append to rdfGraph
			FileMeta fileMeta = FileHelper.getFileDetails( absolutePath );
			rdfGraph += fileMeta.getFileContent();

			Spin spin = new Spin( "DCAT-2-SPIN.ttl", "dcat.ttl", "technology-driven-validation.ttl" );
			spin.runInferences_checkConstraints( rdfGraph );

			model.addObject( "dcatValidationResult", spin.validationResults );
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
	public @ResponseBody
	FileMeta upload( MultipartHttpServletRequest request, HttpServletResponse response )
	{
		// absolute path
		// String absolutePath = this.getClass().getClassLoader().getResource(
		// "rdfGraphs" ).getPath();
		// absolutePath = absolutePath.substring( 1, absolutePath.length() - 1
		// );
		// String absolutePath =
		// request.getSession().getServletContext().getRealPath(
		// gcloResourcePath
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
		return fileMeta;
	}

	/**
	 * Upload document via jquery ajax file upload
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping( value = "/multiple-file-upload", method = RequestMethod.POST )
	public @ResponseBody
	LinkedList<FileMeta> multiUpload( MultipartHttpServletRequest request, HttpServletResponse response )
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
		return files;
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
		// gcloFileUploadPath );
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
		// gcloResourcePath ).getPath();
		// absolutePath = absolutePath.substring( 1, absolutePath.length() - 1
		// );
		// absolutePath = absolutePath + "/" + filePath;

		String absolutePath = request.getSession().getServletContext().getRealPath( additionalPath != null ? additionalPath : dcatResourcePath );
		absolutePath = absolutePath + "/" + filePath;

		// return FileHelper.getFileDetails( request, absolutePath,
		// gcloResourcePath + filePath );
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
		String fullPath = request.getSession().getServletContext().getRealPath( specificDirectory != null ? specificDirectory : dcatResourcePath );
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
		// "SPIN/functions/gclo-functions.ttl" ).getPath(), null, true, "/",
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
		ModelAndView model = new ModelAndView( "dcat-endpoint", "link", "skos" );
		
		// SPARQL endpoints
		List<String> sparqlEndpoints = new ArrayList<String>();
		sparqlEndpoints.add( "SKOS example data (http://svbotomcat01:8080/openrdf-sesame/repositories/rdf-validation-skos)" );
		sparqlEndpoints.add( "TheSoz (http://svbotomcat01:8080/openrdf-sesame/repositories/sparql)" ); 
		sparqlEndpoints.add( "STW Thesaurus for Economics of the ZBW (http://zbw.eu/beta/sparql)" );
		model.addObject( "sparqlEndpoints", sparqlEndpoints );

		Hashtable<String,List<String>> constraintsByConstraintType = new Hashtable<String,List<String>>();
		
		List<String> constraints_0 = new ArrayList<String>();
		constraints_0.add( "SKOS-C-DATA-MODEL-CONSISTENCY-01 (not yet implemented!)" );
		constraints_0.add( "SKOS-C-DATA-MODEL-CONSISTENCY-02 (not yet implemented!)" );
		constraints_0.add( "SKOS-C-DATA-MODEL-CONSISTENCY-03 (not yet implemented!)" );
		constraintsByConstraintType.put("Data Model Consistency", constraints_0 );
		
		List<String> constraints_1 = new ArrayList<String>();
		constraints_1.add( "SKOS-C-PROPERTY-DOMAIN-01 (not yet implemented!)" );
		constraintsByConstraintType.put("Property Domains", constraints_1 );
		
		List<String> constraints_2 = new ArrayList<String>();
		constraints_2.add( "SKOS-C-PROPERTY-RANGES-01 (not yet implemented!)" );
		constraintsByConstraintType.put("Property Ranges", constraints_2 );
		
		List<String> constraints_3 = new ArrayList<String>();
		constraints_3.add( "SKOS-C-DISJOINT-PROPERTIES-01 (not yet implemented!)" );
		constraints_3.add( "SKOS-C-DISJOINT-PROPERTIES-02 (not yet implemented!)" );
		constraintsByConstraintType.put("Disjoint Properties", constraints_3 );
		
		List<String> constraints_4 = new ArrayList<String>();
		constraints_4.add( "SKOS-C-DISJOINT-CLASSES-01 (not yet implemented!)" );
		constraintsByConstraintType.put("Disjoint Classes", constraints_4 );
		
		List<String> constraints_5 = new ArrayList<String>();
		constraints_5.add( "SKOS-C-EQUIVALENT-PROPERTIES-01 (not yet implemented!)" );
		constraintsByConstraintType.put("Equivalent Properties", constraints_5 );
		
		List<String> constraints_6 = new ArrayList<String>();
		constraints_6.add( "SKOS-C-UNIVERSAL-QUANTIFICATIONS-01 (not yet implemented!)" );
		constraintsByConstraintType.put("Universal Quantifications", constraints_6 );
		
		List<String> constraints_7 = new ArrayList<String>();
		constraints_7.add( "SKOS-C-CONTEXT-SPECIFIC-VALID-CLASSES-01 (not yet implemented!)" );
		constraintsByConstraintType.put("Context-Specific Valid Classes", constraints_7 );
		
		List<String> constraints_8 = new ArrayList<String>();
		constraints_8.add( "SKOS-C-CONTEXT-SPECIFIC-VALID-PROPERTIES-01 (not yet implemented!)" );
		constraintsByConstraintType.put("Context-Specific Valid Properties", constraints_8 );
		
		List<String> constraints_9 = new ArrayList<String>();
		constraints_9.add( "SKOS-C-LANGUAGE-TAG-CARDINALITY-01" );
		constraints_9.add( "SKOS-C-LANGUAGE-TAG-CARDINALITY-02" );
		constraints_9.add( "SKOS-C-LANGUAGE-TAG-CARDINALITY-03" );
		constraints_9.add( "SKOS-C-LANGUAGE-TAG-CARDINALITY-04" );
		constraintsByConstraintType.put("Language Tag Cardinality", constraints_9 );
		
		List<String> constraints_10 = new ArrayList<String>();
		constraints_10.add( "SKOS-C-RECOMMENDED-PROPERTIES-01 (not yet implemented!)" );
		constraintsByConstraintType.put("Recommended Properties", constraints_10 );
		
		List<String> constraints_11 = new ArrayList<String>();
		constraints_11.add( "SKOS-C-STRUCTURE-01" );
		constraints_11.add( "SKOS-C-STRUCTURE-02 (not yet implemented!)" );
		constraints_11.add( "SKOS-C-STRUCTURE-03" );
		constraints_11.add( "SKOS-C-STRUCTURE-04" );
		constraints_11.add( "SKOS-C-STRUCTURE-05" );
		constraints_11.add( "SKOS-C-STRUCTURE-06" );
		constraints_11.add( "SKOS-C-STRUCTURE-07" );
		constraints_11.add( "SKOS-C-STRUCTURE-08 (not yet implemented!)" );
		constraints_11.add( "SKOS-C-STRUCTURE-09" );
		constraints_11.add( "SKOS-C-STRUCTURE-10" );
		constraintsByConstraintType.put("Structure", constraints_11 );
		
		List<String> constraints_12 = new ArrayList<String>();
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-01" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-02" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-03" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-04 (not yet implemented)" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-05" );
		constraints_12.add( "SKOS-C-LABELING-AND-DOCUMENTATION-06" );
		constraintsByConstraintType.put("Labeling and Documentation", constraints_12 );
		
		List<String> constraints_13 = new ArrayList<String>();
		constraints_13.add( "SKOS-C-VOCABULARY-01 (not yet implemented!)" );
		constraintsByConstraintType.put("Vocabulary", constraints_13 );
		
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
		ModelAndView model = new ModelAndView( "dcat-endpoint-validation", "link", "datacube" );

		// SPARQL endpoints ( testing )
		List<String> endpoints = new ArrayList<String>();
		endpoints.add( "TheSoz (http://svbotomcat01:8080/openrdf-sesame/repositories/sparql)" ); 
		String[] ep = new String[ endpoints.size() ];
		ep = endpoints.toArray( ep );
		
		// constraints ( testing )
		List<String> constraintsList = new ArrayList<String>();
		constraintsList.add( "SKOS-C-LABELING-AND-DOCUMENTATION-01" );
		String[] c = new String[ constraintsList.size() ];
		c = constraintsList.toArray( c );
		
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
