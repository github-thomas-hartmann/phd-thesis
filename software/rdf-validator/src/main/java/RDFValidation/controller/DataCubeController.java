package RDFValidation.controller;

import helper.DynaTree;
import helper.FileHelper;
import helper.FileMeta;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

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
@RequestMapping( value = "/datacube" )
public class DataCubeController
{
	/* multiple file upload */
	LinkedList<FileMeta> files = new LinkedList<FileMeta>();

	/* file */
	FileMeta fileMeta = null;

	/* resource gclo path */
	final String datacubeResourcePath = "/resources/rdfGraphs/datacube/";
	final String fileUploadPath = "/resources/uploaded_files/";

	// GCLO main
	@RequestMapping( method = RequestMethod.GET )
	public ModelAndView landing( @RequestParam( value = "sessionid", required = false ) final String sessionId, final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "datacube-main", "link", "datacube" );

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
		ModelAndView model = new ModelAndView( "datacube-demo", "link", "datacube" );
		return model;
	}

	@RequestMapping( value = "/demo/validation", method = RequestMethod.POST )
	public ModelAndView demo_tab3( 
		@RequestParam( "nameSpaceDeclaration" ) String nameSpaceDeclarationInput, 
		@RequestParam( "constraints" ) String constraintsInput, 
		@RequestParam( "data" ) String dataInput,
		HttpServletRequest request )
	{
		ModelAndView model = new ModelAndView( "datacube-demo-validation", "link", "datacube" );

		// input graph
		// - add line separators at the end of each input graph
		String ND = new StringBuilder( nameSpaceDeclarationInput ).append( "\r\n" ).toString();
		String C = new StringBuilder( constraintsInput ).append( "\r\n" ).toString();
		String D = new StringBuilder( dataInput ).append( "\r\n" ).toString();
		String inputRDFGraph = new StringBuilder( ND ).append( C ).append( D ).toString();

		// constraints
		String[] constraints = new String[]{
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-02",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-03",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-04",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-05",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-06",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-07",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-08",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-09",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-10",
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-11",
			"DATA-CUBE-C-EXACT-UNQUALIFIED-CARDINALITY-RESTRICTIONS-01",
			"DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01",
			"DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-02",
			"DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-01",
			"DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-02",
			"DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-03",
			"DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-04",
			"DATA-CUBE-C-VALUE-IS-VALID-FOR-DATATYPE-01 (not yet implemented!)",
			"DATA-CUBE-C-MEMBERSHIP-IN-CONTROLLED-VOCABULARIES-01",
			"DATA-CUBE-C-STRUCTURE-01",
			"DATA-CUBE-C-STRUCTURE-02"
		};
		
		String absolutePathConstraints = request.getSession().getServletContext().getRealPath( "/resources/rdfGraphs/DATACUBE/SPARQL" );
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

	@RequestMapping( value = "/upload", method = RequestMethod.GET )
	public ModelAndView uploadGraphInitial( /* tab1 get content via ajax */
	@RequestParam( value = "sessionid", required = false ) final String sessionId, final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "datacube-upload", "link", "datacube" );

		return model;
	}

	@RequestMapping( value = "/upload/validation", method = RequestMethod.POST )
	public ModelAndView uploadGraphValidation( HttpServletRequest request, HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "datacube-upload-validation", "link", "datacube" );

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
			String absolutePath = request.getSession().getServletContext().getRealPath( datacubeResourcePath );
			absolutePath = absolutePath + "/" + "defaultNamespaceDeclarations.ttl";
			// get predefined namespace content and append to rdfGraph
			FileMeta fileMeta = FileHelper.getFileDetails( absolutePath );
			rdfGraph += fileMeta.getFileContent();

			Spin spin = new Spin( "QB\\QB-2-SPIN.ttl", "data-cube.ttl", "technology-driven-validation.ttl" );
			spin.runInferences_checkConstraints( rdfGraph );

			model.addObject( "datacubeValidationResult", spin.validationResults );
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

		String absolutePath = request.getSession().getServletContext().getRealPath( additionalPath != null ? additionalPath : datacubeResourcePath );
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
		String fullPath = request.getSession().getServletContext().getRealPath( specificDirectory != null ? specificDirectory : datacubeResourcePath );
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
		ModelAndView model = new ModelAndView( "datacube-endpoint", "link", "skos" );
		
		// SPARQL endpoints
		List<String> sparqlEndpoints = new ArrayList<String>();
		sparqlEndpoints.add( "European Central Bank (ECB) (http://ecb.270a.info/sparql)" );
		sparqlEndpoints.add( "UNESCO Institute for Statistics (UIS) (http://uis.270a.info/sparql)" );
		sparqlEndpoints.add( "International Monetary Fund (IMF) (http://imf.270a.info/sparql)" ); 
		sparqlEndpoints.add( "Swiss Federal Statistics Office (BFS) (http://bfs.270a.info/sparql)" );
		sparqlEndpoints.add( "Food and Agriculture Organization of the United Nations (FAO) (http://fao.270a.info/sparql)" );
		sparqlEndpoints.add( "World Bank (WB) (http://worldbank.270a.info/sparql)" );
		sparqlEndpoints.add( "Federal Reserve Board (FRB) (http://frb.270a.info/sparql)" );
		sparqlEndpoints.add( "Transparency International (TI) (http://transparency.270a.info/sparql)" );
		sparqlEndpoints.add( "Organisation for Economic Co-operation and Development (OECD) (http://oecd.270a.info/sparql)" );
		sparqlEndpoints.add( "Bank for International Settlements (BIS) (http://bis.270a.info/sparql)" );
		sparqlEndpoints.add( "Australian Bureau of Statistics (ABS) (http://abs.270a.info/sparql)" ); 
		sparqlEndpoints.add( "IEEE VIS Source Data (VIS) (http://ieeevis.tw.rpi.edu/sparql)" );
		sparqlEndpoints.add( "ACORN-SAT (http://lab.environment.data.gov.au/sparql)" ); 
		sparqlEndpoints.add( "HDP (http://healthdata.tw.rpi.edu/sparql)" ); 
		model.addObject( "sparqlEndpoints", sparqlEndpoints );
		
//		// constraints
//		List<String> constraints = new ArrayList<String>();
//		constraints.add( "DATA-CUBE-C-VALUE-IS-VALID-FOR-DATATYPE-01" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_1" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_2" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-02" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-01" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-02" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-03" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-04" );
//		constraints.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01" );
//		constraints.add( "DATA-CUBE-C-VALUE-IS-VALID-FOR-DATATYPE-01" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_1" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_2" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-02" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-01" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-02" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-03" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-04" );
//		constraints.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01" );
//		constraints.add( "DATA-CUBE-C-VALUE-IS-VALID-FOR-DATATYPE-01" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_1" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_2" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-02" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-01" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-02" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-03" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-04" );
//		constraints.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01" );
//		constraints.add( "DATA-CUBE-C-VALUE-IS-VALID-FOR-DATATYPE-01" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_1" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_2" );
//		constraints.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-02" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-01" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-02" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-03" );
//		constraints.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-04" );
//		constraints.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01" );
//		model.addObject( "constraints", constraints );
		
//		ArrayList<ArrayList<String>> constraintsByConstraintType = new ArrayList<ArrayList<String>>();
//		ArrayList<String> list = new ArrayList<String>();
//		list.add("DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01");
//		constraintsByConstraintType.add( list );
//		list = new ArrayList<String>();
//		list.add("DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01");
//		list.add("DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-02");
//		constraintsByConstraintType.add( list );
//		list = new ArrayList<String>();
//		list.add("DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-01");
//		list.add("DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-02");
//		list.add("DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-03");
//		list.add("DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-04");
//		constraintsByConstraintType.add( list );
//		list = new ArrayList<String>();
//		list.add("DATA-CUBE-C-VALUE-IS-VALID-FOR-DATATYPE-01");
//		constraintsByConstraintType.add( list );
//		model.addObject( "constraintsByConstraintType", constraintsByConstraintType );

		// constraints
		Hashtable<String,List<String>> constraintsByConstraintType = new Hashtable<String,List<String>>();
		
		List<String> constraints_0 = new ArrayList<String>();
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-02" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-03" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-04" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-05" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-06" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-07" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-08" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-09" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-10 (!)" );
		constraints_0.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-11" );
		constraintsByConstraintType.put("Data Model Consistency", constraints_0 );
		
		List<String> constraints_1 = new ArrayList<String>();
		constraints_1.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-02" );
		constraintsByConstraintType.put("Exact Qualified Cardinality Restrictions", constraints_1 );
		
		List<String> constraints_2 = new ArrayList<String>();
		constraints_2.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-01" );
		constraints_2.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-02" );
		constraints_2.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-03" );
		constraints_2.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-04" );
		constraintsByConstraintType.put("Existential Quantifications", constraints_2 );
		
		List<String> constraints_3 = new ArrayList<String>();
		constraints_3.add( "DATA-CUBE-C-VALUE-IS-VALID-FOR-DATATYPE-01 (!)" );
		constraintsByConstraintType.put("Value Is Valid For Datatype", constraints_3 );
		
		List<String> constraints_4 = new ArrayList<String>();
		constraints_4.add( "DATA-CUBE-C-MEMBERSHIP-IN-CONTROLLED-VOCABULARIES-01" );
		constraintsByConstraintType.put("Membership In Controlled Vocabularies", constraints_4 );
		
		List<String> constraints_5 = new ArrayList<String>();
		constraints_5.add( "DATA-CUBE-C-STRUCTURE-01" );
		constraints_5.add( "DATA-CUBE-C-STRUCTURE-02" );
		constraintsByConstraintType.put("Structure", constraints_5 );
		
		List<String> constraints_7 = new ArrayList<String>();
		constraints_7.add( "DATA-CUBE-C-EXACT-UNQUALIFIED-CARDINALITY-RESTRICTIONS-01" );
		constraintsByConstraintType.put("Exact Unqualified Cardinality Restrictions", constraints_7 );
		
		List<String> constraints_8 = new ArrayList<String>();
		constraints_8.add( "DATA-CUBE-C-MINIMUM-QUALIFIED-CARDINALITY-RESTRICTIONS-01 (!)" );
		constraints_8.add( "DATA-CUBE-C-MINIMUM-QUALIFIED-CARDINALITY-RESTRICTIONS-02" );
		constraintsByConstraintType.put("Minimum Qualified Cardinality Restrictions", constraints_8 );
		
		List<String> constraints_9 = new ArrayList<String>();
		constraints_9.add( "DATA-CUBE-C-MAXIMUM-QUALIFIED-CARDINALITY-RESTRICTIONS-01" );
		constraintsByConstraintType.put("Maximum Qualified Cardinality Restrictions", constraints_9 );
		
		List<String> constraints_10 = new ArrayList<String>();
		constraints_10.add( "DATA-CUBE-C-PROPERTY-DOMAIN-01 (!)" );
		constraintsByConstraintType.put("Property Domain", constraints_10 );
		
		List<String> constraints_11 = new ArrayList<String>();
		constraints_11.add( "DATA-CUBE-C-PROPERTY-RANGES-01 (!)" );
		constraintsByConstraintType.put("Property Ranges", constraints_11 );
		
		List<String> constraints_12 = new ArrayList<String>();
		constraints_12.add( "DATA-CUBE-C-DISJOINT-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Disjoint Properties", constraints_12 );
		
		List<String> constraints_13 = new ArrayList<String>();
		constraints_13.add( "DATA-CUBE-C-DISJOINT-CLASSES-01 (!)" );
		constraintsByConstraintType.put("Disjoint Classes", constraints_13 );
		
		List<String> constraints_14 = new ArrayList<String>();
		constraints_14.add( "DATA-CUBE-C-EQUIVALENT-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Equivalent Properties", constraints_14 );
		
		List<String> constraints_15 = new ArrayList<String>();
		constraints_15.add( "DATA-CUBE-C-UNIVERSAL-QUANTIFICATIONS-01 (!)" );
		constraintsByConstraintType.put("Universal Quantifications", constraints_15 );
		
		List<String> constraints_16 = new ArrayList<String>();
		constraints_16.add( "DATA-CUBE-C-CONTEXT-SPECIFIC-VALID-CLASSES-01 (!)" );
		constraintsByConstraintType.put("Context-Specific Valid Classes", constraints_16 );
		
		List<String> constraints_17 = new ArrayList<String>();
		constraints_17.add( "DATA-CUBE-C-CONTEXT-SPECIFIC-VALID-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Context-Specific Valid Properties", constraints_17 );
		
		List<String> constraints_18 = new ArrayList<String>();
		constraints_18.add( "DATA-CUBE-C-RECOMMENDED-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Recommended Properties", constraints_18 );
		
		List<String> constraints_19 = new ArrayList<String>();
		constraints_19.add( "DATA-CUBE-C-VOCABULARY-01 (!)" );
		constraintsByConstraintType.put("Vocabulary", constraints_19 );
		
		List<String> constraints_20 = new ArrayList<String>();
		constraints_20.add( "DATA-CUBE-C-HTTP-URI-SCHEME-VIOLATION (!)" );
		constraintsByConstraintType.put("HTTP URI Scheme Violation", constraints_20 );
		
//		List<String> constraints_6 = new ArrayList<String>();
//		constraints_6.add( "count-triples" );
//		constraints_6.add( "count-triples-2" );
//		constraints_6.add( "count-data-set" );
//		constraints_6.add( "count-data-structure-definition" );
//		constraints_6.add( "count-observation" );
//		constraints_6.add( "count-slice" );
//		constraints_6.add( "count-dimension" );
//		constraintsByConstraintType.put("counts", constraints_6 );
		
		model.addObject( "constraintsByConstraintType", constraintsByConstraintType );
		
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
	
	@RequestMapping( value = "/endpoint/validation/parameter", method = RequestMethod.POST )
	public ModelAndView endpointValidationParameter( 
		@RequestParam( value = "sparqlEndpoint", required = true ) String sparqlEndpoint,
		@RequestParam( value = "constraint", required = true ) String constraint,
		@RequestParam( value = "limit", required = true ) String limit,
		HttpServletRequest request )
	{
		ModelAndView model = new ModelAndView( "datacube-endpoint-validation-parameter", "link", "datacube" );
		
		model.addObject( "sparqlEndpoint", sparqlEndpoint );
		model.addObject( "constraint", constraint );
		model.addObject( "limit", limit );
		
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
	
	@RequestMapping( value = "/endpoint/validation", method = RequestMethod.POST )
	public ModelAndView endpointValidation( 
		@RequestParam( value = "sparqlEndpoint", required = true ) String sparqlEndpoint,
		@RequestParam( value = "constraint", required = true ) String constraint,
		@RequestParam( value = "limit", required = true ) String limit,
		HttpServletRequest request )
	{
		ModelAndView model = new ModelAndView( "datacube-endpoint-validation", "link", "datacube" );

		// SPARQL endpoints ( testing )
//		List<String> endpoints = new ArrayList<String>();
//		endpoints.add( "http://ecb.270a.info/sparql" ); // European Central Bank
//		endpoints.add( "http://uis.270a.info/sparql" ); // UNESCO Institute for Statistics
//		endpoints.add( "http://imf.270a.info/sparql" ); // International Monetary Fund
//		endpoints.add( "http://bfs.270a.info/sparql" ); // Swiss Federal Statistics Office
//		endpoints.add( "http://fao.270a.info/sparql" ); // Food and Agriculture Organization of the United Nations
//		endpoints.add( "http://frb.270a.info/sparql" ); // Federal Reserve Board
//		endpoints.add( "http://oecd.270a.info/sparql" ); // Organisation for Economic Co-operation and Development
//		endpoints.add( "http://transparency.270a.info/sparql" ); // Transparency International
//		endpoints.add( "http://worldbank.270a.info/sparql" ); // World Bank
//		endpoints.add( "http://bis.270a.info/sparql" ); // Bank for International Settlements
//		endpoints.add( "http://abs.270a.info/sparql" ); // Australian Bureau of Statistics
//		String[] ep = new String[ endpoints.size() ];
//		ep = endpoints.toArray( ep );
		
		// constraints ( testing )
//		List<String> constraintsList = new ArrayList<String>();
//		constraintsList.add( "DATA-CUBE-C-VALUE-IS-VALID-FOR-DATATYPE-01" );
//		constraintsList.add( "DATA-CUBE-C-EXACT-UNQUALIFIED-CARDINALITY-RESTRICTIONS-01" );
//		constraintsList.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01" );
//		constraintsList.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_1" );
//		constraintsList.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01_2" );
//		constraintsList.add( "DATA-CUBE-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-02" );
//		constraintsList.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-01" );
//		constraintsList.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-02" );
//		constraintsList.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-03" );
//		constraintsList.add( "DATA-CUBE-C-EXISTENTIAL-QUANTIFICATIONS-04" );
//		constraintsList.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01" );
//		constraintsList.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-02" );
//		constraintsList.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-03" );
//		constraintsList.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-04" );
//		String[] c = new String[ constraintsList.size() ];
//		c = constraintsList.toArray( c );
		
		// parameters
		String[] sparqlEndpoints = new String[]{ sparqlEndpoint };
		String[] constraints = new String[]{ constraint };
		model.addObject( "sparqlEndpoint", sparqlEndpoint );
		model.addObject( "constraint", constraint );
		model.addObject( "limit", limit );
		
		String absolutePathConstraints = request.getSession().getServletContext().getRealPath( "/resources/rdfGraphs/DATACUBE/SPARQL" );
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
		constraintDescriptions.put(
			"DATA-CUBE-C-DATA-MODEL-CONSISTENCY-06", 
			"Required attributes: Every qb:Observation has a value for each declared attribute that is marked as required." );
		model.addObject( "constraintDescriptions", constraintDescriptions );

		return model;
	}
	
}
