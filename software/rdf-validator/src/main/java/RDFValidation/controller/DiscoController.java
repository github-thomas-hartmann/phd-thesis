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
@RequestMapping( value = "/disco" )
public class DiscoController
{
	/* multiple file upload */
	LinkedList<FileMeta> files = new LinkedList<FileMeta>();

	/* file */
	FileMeta fileMeta = null;

	/* resource gclo path */
	final String discoResourcePath = "/resources/rdfGraphs/disco/";
	final String fileUploadPath = "/resources/uploaded_files/";

	// GCLO main
	@RequestMapping( method = RequestMethod.GET )
	public ModelAndView landing( @RequestParam( value = "sessionid", required = false ) final String sessionId, final HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "disco-main", "link", "disco" );

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
		ModelAndView model = new ModelAndView( "disco-demo", "link", "disco" );
		return model;
	}

	@RequestMapping( value = "/demo/validation", method = RequestMethod.POST )
	public ModelAndView demo_tab3( 
		@RequestParam( "nameSpaceDeclaration" ) String nameSpaceDeclarationInput, 
		@RequestParam( "constraints" ) String constraintsInput, 
		@RequestParam( "data" ) String dataInput,
		HttpServletRequest request )
	{
		ModelAndView model = new ModelAndView( "disco-demo-validation", "link", "disco" );

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
		ModelAndView model = new ModelAndView( "disco-upload", "link", "disco" );

		return model;
	}

	/* GCLO upload validation */
	@RequestMapping( value = "/upload/validation", method = RequestMethod.POST )
	public ModelAndView uploadGraphValidation( HttpServletRequest request, HttpServletResponse response )
	{
		ModelAndView model = new ModelAndView( "disco-upload-validation", "link", "disco" );

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
			String absolutePath = request.getSession().getServletContext().getRealPath( discoResourcePath );
			absolutePath = absolutePath + "/" + "defaultNamespaceDeclarations.ttl";
			// get predefined namespace content and append to rdfGraph
			FileMeta fileMeta = FileHelper.getFileDetails( absolutePath );
			rdfGraph += fileMeta.getFileContent();

			Spin spin = new Spin( "Disco-2-SPIN.ttl", "discovery.ttl", "technology-driven-validation.ttl" );
			spin.runInferences_checkConstraints( rdfGraph );

			model.addObject( "discoValidationResult", spin.validationResults );
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

		String absolutePath = request.getSession().getServletContext().getRealPath( additionalPath != null ? additionalPath : discoResourcePath );
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
		String fullPath = request.getSession().getServletContext().getRealPath( specificDirectory != null ? specificDirectory : discoResourcePath );
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
		ModelAndView model = new ModelAndView( "disco-endpoint", "link", "skos" );
		
		// SPARQL endpoints
		List<String> sparqlEndpoints = new ArrayList<String>();
		sparqlEndpoints.add( "Microdata Information System (Missy) (http://svko-missy:8181/openrdf-sesame/repositories/native-java-store)" );
		sparqlEndpoints.add( "DwB Discovery Portal (DwB) (http://dwb-dev.nsd.uib.no/sparql)" );
		sparqlEndpoints.add( "DDA and SND DDI-RDF (DDA-SND) (http://ddi-rdf.borsna.se/endpoint/)" );
		model.addObject( "sparqlEndpoints", sparqlEndpoints );

		Hashtable<String,List<String>> constraintsByConstraintType = new Hashtable<String,List<String>>();
		
//		List<String> constraints_0 = new ArrayList<String>();
//		constraints_0.add( "count-triples" );				
//		constraints_0.add( "count-study-group" );
//		constraints_0.add( "count-study" );
//		constraints_0.add( "count-logical-data-set" );
//		constraints_0.add( "count-universe" );
//		constraints_0.add( "count-variable" );
//		constraints_0.add( "count-question" );
//		constraints_0.add( "count-summary-statistics" );
//		constraints_0.add( "count-category-statistics" );
//		constraints_0.add( "count-concept" );
//		constraintsByConstraintType.put("counts", constraints_0 );
		
		List<String> constraints_1 = new ArrayList<String>();
		constraints_1.add( "DISCO-C-ALLOWED-VALUES-01" );
		constraintsByConstraintType.put("Allowed Values", constraints_1 );
		
		List<String> constraints_2 = new ArrayList<String>();
		constraints_2.add( "DISCO-C-LITERAL-RANGES-01" );
		constraintsByConstraintType.put("Literal Ranges", constraints_2 );
		
		List<String> constraints_3 = new ArrayList<String>();
		constraints_3.add( "DISCO-C-INVERSE-FUNCTIONAL-PROPERTIES-01" );
		constraints_3.add( "DISCO-C-INVERSE-FUNCTIONAL-PROPERTIES-02" );
		constraintsByConstraintType.put("Inverse Functional Properties", constraints_3 );
		
		List<String> constraints_4 = new ArrayList<String>();
		constraints_4.add( "DISCO-C-CLASS-SPECIFIC-PROPERTY-RANGE-01" );
		constraintsByConstraintType.put("Class-Specific Property Ranges", constraints_4 );
		
		List<String> constraints_5 = new ArrayList<String>();
		constraints_5.add( "DISCO-C-MEMBERSHIP-IN-CONTROLLED-VOCABULARIES-01" );
		constraintsByConstraintType.put("Membership In Controlled Vocabularies", constraints_5 );
		
		List<String> constraints_6 = new ArrayList<String>();
		constraints_6.add( "DISCO-C-LITERAL-VALUE-COMPARISON-01" );
		constraintsByConstraintType.put("Literal Value Comparison", constraints_6 );
		
		List<String> constraints_7 = new ArrayList<String>();
		constraints_7.add( "DISCO-C-CONTEXT-SPECIFIC-VALID-PROPERTIES-01" );
		constraintsByConstraintType.put("Context-Specific Valid Properties", constraints_7 );
		
		List<String> constraints_8 = new ArrayList<String>();
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-01" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-02" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-03" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-04" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-05" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-06" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-07" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-08" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-09" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-10" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-11" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-12" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-13" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-14" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-15" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-16" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-17" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-18" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-19" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-20" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-21" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-22" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-23" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-24" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-25" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-26" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-27" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-28" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-29" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-30" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-31" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-32" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-33" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-34" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-35" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-36" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-37" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-38" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-39" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-40" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-41" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-42" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-43" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-44" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-45" );
		constraints_8.add( "DISCO-C-EXISTENTIAL-QUANTIFICATIONS-46" );
		constraintsByConstraintType.put("Existential Quantifications", constraints_8 );
		
		List<String> constraints_9 = new ArrayList<String>();
		constraints_9.add( "DISCO-C-CONDITIONAL-PROPERTIES-01" );
		constraints_9.add( "DISCO-C-CONDITIONAL-PROPERTIES-02" );
		constraints_9.add( "DISCO-C-CONDITIONAL-PROPERTIES-03" );
		constraints_9.add( "DISCO-C-CONDITIONAL-PROPERTIES-04" );
		constraints_9.add( "DISCO-C-CONDITIONAL-PROPERTIES-05" );
		constraints_9.add( "DISCO-C-CONDITIONAL-PROPERTIES-06" );
		constraintsByConstraintType.put("Conditional Properties", constraints_9 );
		
		List<String> constraints_10 = new ArrayList<String>();
		constraints_10.add( "DISCO-C-DATA-PROPERTY-FACETS-01" );
		constraints_10.add( "DISCO-C-DATA-PROPERTY-FACETS-02" );
		constraintsByConstraintType.put("Data Property Facets", constraints_10 );
		
		List<String> constraints_11 = new ArrayList<String>();
		constraints_11.add( "DISCO-C-PROVENANCE-01" );
		constraints_11.add( "DISCO-C-PROVENANCE-02" );
		constraints_11.add( "DISCO-C-PROVENANCE-03" );
		constraints_11.add( "DISCO-C-PROVENANCE-04" );
		constraintsByConstraintType.put("Provenance", constraints_11 );
		
		List<String> constraints_12 = new ArrayList<String>();
		constraints_12.add( "DISCO-C-LABELING-AND-DOCUMENTATION-01" );
		constraints_12.add( "DISCO-C-LABELING-AND-DOCUMENTATION-02" );
		constraints_12.add( "DISCO-C-LABELING-AND-DOCUMENTATION-03" );
		constraints_12.add( "DISCO-C-LABELING-AND-DOCUMENTATION-04" );
		constraints_12.add( "DISCO-C-LABELING-AND-DOCUMENTATION-05" );
		constraints_12.add( "DISCO-C-LABELING-AND-DOCUMENTATION-06" );
		constraintsByConstraintType.put("Labeling and Documentation", constraints_12 );
		
		List<String> constraints_13 = new ArrayList<String>();
		constraints_13.add( "DISCO-C-VALUE-IS-VALID-FOR-DATATYPE-01" );
		constraints_13.add( "DISCO-C-VALUE-IS-VALID-FOR-DATATYPE-02" );
		constraintsByConstraintType.put("Value Is Valid For Datatype", constraints_13 );
		
		List<String> constraints_14 = new ArrayList<String>();
		constraints_14.add( "DISCO-C-DATA-MODEL-CONSISTENCY-01 (!)" );
		constraints_14.add( "DISCO-C-DATA-MODEL-CONSISTENCY-02 (!)" );
		constraints_14.add( "DISCO-C-DATA-MODEL-CONSISTENCY-03 (!)" );
		constraints_14.add( "DISCO-C-DATA-MODEL-CONSISTENCY-04 (!)" );
		constraints_14.add( "DISCO-C-DATA-MODEL-CONSISTENCY-05" );
		constraints_14.add( "DISCO-C-DATA-MODEL-CONSISTENCY-06 (!)" );
		constraints_14.add( "DISCO-C-DATA-MODEL-CONSISTENCY-07 (!)" );
		constraintsByConstraintType.put("Data Model Consistency", constraints_14 );
		
		List<String> constraints_15 = new ArrayList<String>();
		constraints_15.add( "DISCO-C-COMPARISON-VARIABLES-01 (!)" );
		constraints_15.add( "DISCO-C-COMPARISON-VARIABLES-02" );
		constraints_15.add( "DISCO-C-COMPARISON-VARIABLES-03 (!)" );
		constraints_15.add( "DISCO-C-COMPARISON-VARIABLES-04" );
		constraints_15.add( "DISCO-C-COMPARISON-VARIABLES-05" );
		constraintsByConstraintType.put("Comparison", constraints_15 );
		
		List<String> constraints_16 = new ArrayList<String>();
		constraints_16.add( "DISCO-C-MATHEMATICAL-OPERATIONS-01 (!)" );
		constraints_16.add( "DISCO-C-MATHEMATICAL-OPERATIONS-02 (!)" );
		constraints_16.add( "DISCO-C-MATHEMATICAL-OPERATIONS-03 (!)" );
		constraints_16.add( "DISCO-C-MATHEMATICAL-OPERATIONS-04 (!)" );
		constraints_16.add( "DISCO-C-MATHEMATICAL-OPERATIONS-05 (!)" );
		constraintsByConstraintType.put("Mathematical Operationsn", constraints_16 );
		
		List<String> constraints_17 = new ArrayList<String>();
		constraints_17.add( "DISCO-C-LANGUAGE-TAG-MATCHING-01 (!)" );
		constraints_17.add( "DISCO-C-LANGUAGE-TAG-CARDINALITY-01 (!)" );
		constraints_17.add( "DISCO-C-LANGUAGE-TAG-CARDINALITY-02 (!)" );
		constraints_17.add( "DISCO-C-LANGUAGE-TAG-CARDINALITY-03 (!)" );
		constraintsByConstraintType.put("Language Tags", constraints_17 );
		
		List<String> constraints_18 = new ArrayList<String>();
		constraints_18.add( "DISCO-C-AGGREGATION-01 (!)" );
		constraints_18.add( "DISCO-C-AGGREGATION-02 (!)" );
		constraints_18.add( "DISCO-C-AGGREGATION-03 (!)" );
		constraints_18.add( "DISCO-C-AGGREGATION-04 (!)" );
		constraints_18.add( "DISCO-C-AGGREGATION-05 (!)" );
		constraints_18.add( "DISCO-C-AGGREGATION-06 (!)" );
		constraints_18.add( "DISCO-C-AGGREGATION-07 (!)" );
		constraintsByConstraintType.put("Aggregation", constraints_18 );
		
		List<String> constraints_19 = new ArrayList<String>();
		constraints_19.add( "DISCO-C-SUBSUMPTION-01 (!)" );
		constraintsByConstraintType.put("Subsumption", constraints_19 );
		
		List<String> constraints_20 = new ArrayList<String>();
		constraints_20.add( "DISCO-C-CLASS-EQUIVALENCE-01 (!)" );
		constraintsByConstraintType.put("Class Equivalence", constraints_20 );
		
		List<String> constraints_21 = new ArrayList<String>();
		constraints_21.add( "DISCO-C-SUB-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Sub Properties", constraints_21 );
		
		List<String> constraints_22 = new ArrayList<String>();
		constraints_22.add( "DISCO-C-PROPERTY-DOMAIN-01 (!)" );
		constraintsByConstraintType.put("Property Domain", constraints_22 );
		
		List<String> constraints_23 = new ArrayList<String>();
		constraints_23.add( "DISCO-C-PROPERTY-RANGES-01 (!)" );
		constraintsByConstraintType.put("Property Ranges", constraints_23 );
		
		List<String> constraints_24 = new ArrayList<String>();
		constraints_24.add( "DISCO-C-INVERSE-OBJECT-PROPERTIES-01 (!)}" );
		constraints_24.add( "DISCO-C-INVERSE-OBJECT-PROPERTIES-02 (!)}" );
		constraints_24.add( "DISCO-C-INVERSE-OBJECT-PROPERTIES-03 (!)}" );
		constraintsByConstraintType.put("Inverse Object Properties", constraints_24 );
		
		List<String> constraints_25 = new ArrayList<String>();
		constraints_25.add( "DISCO-C-DISJOINT-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Disjoint Properties", constraints_25 );
		
		List<String> constraints_26 = new ArrayList<String>();
		constraints_26.add( "DISCO-C-ASYMMETRIC-OBJECT-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Asymmetric Object Properties", constraints_26 );
		
		List<String> constraints_27 = new ArrayList<String>();
		constraints_27.add( "DISCO-C-IRREFLEXIVE-OBJECT-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Irreflexive Object Properties", constraints_27 );
		
		List<String> constraints_28 = new ArrayList<String>();
		constraints_28.add( "DISCO-C-CLASS-SPECIFIC-IRREFLEXIVE-OBJECT-PROPERTIES-01 (!)" );
		constraints_28.add( "DISCO-C-CLASS-SPECIFIC-IRREFLEXIVE-OBJECT-PROPERTIES-02 (!)" );
		constraintsByConstraintType.put("Class-Specific Irreflexive Object Properties", constraints_28 );
		
		List<String> constraints_29 = new ArrayList<String>();
		constraints_29.add( "DISCO-C-DISJOINT-CLASSES-01 (!)" );
		constraintsByConstraintType.put("Disjoint Classes", constraints_29 );
		
		List<String> constraints_30 = new ArrayList<String>();
		constraints_30.add( "DISCO-C-EQUIVALENT-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Equivalent Properties", constraints_30 );
		
		List<String> constraints_31 = new ArrayList<String>();
		constraints_31.add( "DISCO-C-LITERAL-PATTERN-MATCHING-01 (!)" );
		constraintsByConstraintType.put("Literal Pattern Matching", constraints_31 );
		
		List<String> constraints_32 = new ArrayList<String>();
		constraints_32.add( "DISCO-C-DISJUNCTION-01 (!)" );
		constraintsByConstraintType.put("Disjunction", constraints_32 );
		
		List<String> constraints_33 = new ArrayList<String>();
		constraints_33.add( "DISCO-C-UNIVERSAL-QUANTIFICATIONS-01 (!)" );
		constraintsByConstraintType.put("Universal Quantifications", constraints_33 );
		
		List<String> constraints_34 = new ArrayList<String>();
		constraints_34.add( "DISCO-C-MINIMUM-QUALIFIED-CARDINALITY-RESTRICTIONS-01 (!)" );
		constraintsByConstraintType.put("Minimum Qualified Cardinality Restrictions", constraints_34 );
		
		List<String> constraints_35 = new ArrayList<String>();
		constraints_35.add( "DISCO-C-MAXIMUM-QUALIFIED-CARDINALITY-RESTRICTIONS-01 (!)" );
		constraintsByConstraintType.put("Maximum Qualified Cardinality Restrictions", constraints_35 );
		
		List<String> constraints_36 = new ArrayList<String>();
		constraints_36.add( "DISCO-C-EXACT-QUALIFIED-CARDINALITY-RESTRICTIONS-01 (!)" );
		constraintsByConstraintType.put("Exact Qualified Cardinality Restrictions", constraints_36 );
		
		List<String> constraints_37 = new ArrayList<String>();
		constraints_37.add( "DISCO-C-CONTEXT-SPECIFIC-EXCLUSIVE-OR-OF-PROPERTY-GROUPS-01 (!)" );
		constraintsByConstraintType.put("Context-Specific Exclusive Or Of Property Groups", constraints_37 );
		
		List<String> constraints_38 = new ArrayList<String>();
		constraints_38.add( "DISCO-C-IRI-PATTERN-MATCHING-01 (!)" );
		constraintsByConstraintType.put("IRI Pattern Matching", constraints_38 );
		
		List<String> constraints_39 = new ArrayList<String>();
		constraints_39.add( "DISCO-C-ORDERING-01 (!)" );
		constraints_39.add( "DISCO-C-ORDERING-02 (!)" );
		constraints_39.add( "DISCO-C-ORDERING-03 (!)" );
		constraintsByConstraintType.put("Ordering", constraints_39 );
		
		List<String> constraints_40 = new ArrayList<String>();
		constraints_40.add( "DISCO-C-STRING-OPERATIONS-01 (!)" );
		constraintsByConstraintType.put("String Operations", constraints_40 );
		
		List<String> constraints_41 = new ArrayList<String>();
		constraints_41.add( "DISCO-C-CONTEXT-SPECIFIC-VALID-CLASSES-01 (!)" );
		constraintsByConstraintType.put("Context-Specific Valid Classes", constraints_41 );
		
		List<String> constraints_42 = new ArrayList<String>();
		constraints_42.add( "DISCO-C-WHITESPACE-HANDLING-01 (!)" );
		constraintsByConstraintType.put("Whitespace Handling", constraints_42 );
		
		List<String> constraints_43 = new ArrayList<String>();
		constraints_43.add( "DISCO-C-HTML-HANDLING-01 (!)" );
		constraints_43.add( "DISCO-C-HTML-HANDLING-02 (!)" );
		constraintsByConstraintType.put("HTML Handling", constraints_43 );
		
		List<String> constraints_44 = new ArrayList<String>();
		constraints_44.add( "DISCO-C-RECOMMENDED-PROPERTIES-01 (!)" );
		constraintsByConstraintType.put("Recommended Properties", constraints_44 );
		
		List<String> constraints_45 = new ArrayList<String>();
		constraints_45.add( "DISCO-C-HANDLE-RDF-COLLECTIONS-01 (!)" );
		constraints_45.add( "DISCO-C-HANDLE-RDF-COLLECTIONS-02 (!)" );
		constraintsByConstraintType.put("Handle RDF Collections", constraints_45 );
		
		List<String> constraints_46 = new ArrayList<String>();
		constraints_46.add( "DISCO-C-USE-SUB-SUPER-RELATIONS-IN-VALIDATION-01 (!)" );
		constraints_46.add( "DISCO-C-USE-SUB-SUPER-RELATIONS-IN-VALIDATION-02 (!)" );
		constraintsByConstraintType.put("Use Sub-Super Relations In Validation", constraints_46 );
		
		List<String> constraints_47 = new ArrayList<String>();
		constraints_47.add( "DISCO-C-STRUCTURE-01 (!)" );
		constraintsByConstraintType.put("Structure", constraints_47 );
		
		List<String> constraints_48 = new ArrayList<String>();
		constraints_48.add( "DISCO-C-VOCABULARY-01 (!)" );
		constraintsByConstraintType.put("Vocabulary", constraints_48 );
		
		List<String> constraints_49 = new ArrayList<String>();
		constraints_49.add( "DISCO-C-HTTP-URI-SCHEME-VIOLATION (!)" );
		constraintsByConstraintType.put("HTTP URI Scheme Violation", constraints_49 );
		
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
		ModelAndView model = new ModelAndView( "disco-endpoint-validation", "link", "datacube" );
		
		// parameters
		String[] sparqlEndpoints = new String[]{ sparqlEndpoint };
		String[] constraints = new String[]{ constraint };
		model.addObject( "sparqlEndpoint", sparqlEndpoint );
		model.addObject( "constraint", constraint );
		model.addObject( "limit", limit );
		
		String absolutePathConstraints = request.getSession().getServletContext().getRealPath( "/resources/rdfGraphs/DISCO/SPARQL" );
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
