package RDFValidation;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.jena.riot.RDFDataMgr;
import org.topbraid.spin.constraints.SimplePropertyPath;
import org.topbraid.spin.model.TemplateCall;
import org.topbraid.spin.system.SPINLabels;

import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.QueryFactory;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.query.ResultSetFormatter;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.Literal;

public class JenaSPARQLQueries {
	private String absolutePathResources = null;
	private String inputRDFGraph = null;
	private boolean isLogging = false;
	private BufferedWriter logBufferedWriter = null;
	private BufferedWriter constraintViolationsReportBufferedWriter = null;
	
	// constraint violation list
	private List<RDFValidation.ConstraintViolation> constraintViolationList = null;
	private RDFValidation.ConstraintViolation constraintViolation = null;
	private List<String> constraintViolationPaths = null;
	private List<String> constraintViolationFixes = null;
	
	public JenaSPARQLQueries( String absolutePathResources, String inputRDFGraph, boolean isLogging ) {
		this.absolutePathResources = absolutePathResources;
		this.inputRDFGraph = inputRDFGraph;
		this.isLogging = isLogging;
		
		// log
		openLog();
		
		// constraintViolationsReportBufferedWriter
		
		
		
		
	}

	public void query() {
		Model model = ModelFactory.createDefaultModel();
		
		model.add( getRDFGraphByString( inputRDFGraph, "TTL" ) );
		
		String zipFile = "thesoz_0_93.zip";
		model.add( getRDFGraphFromZip( "/thesauri/" + zipFile, "TTL" ) );
		
		Map<String, List<String>> subjectsPerTriplePatterns = new HashMap<String, List<String>>();
		List<String> subjects = null;
		StringBuffer triplePattern = null;
		
		// variable part of query
		String queryString = getQueryString( "concept-property-literal-conceptscheme.ttl" );
		String variable1Name = "p";
		String variable2Name = "literal";
		String variable3Name = "lang";
		String variable4Name = "conceptScheme";
		
		Query query = QueryFactory.create( queryString ) ;
		try {
	        QueryExecution qexec = QueryExecutionFactory.create(query, model);
		    ResultSet results = qexec.execSelect() ;
		    
		    for ( ; results.hasNext() ; )
		    {
		    	QuerySolution querySolution = results.nextSolution() ;  
		    	triplePattern = new StringBuffer();
		    	
		    	// subject
			    Resource subject = querySolution.getResource( "subject" ) ; 
			    
			    // variable 1
			    RDFNode variable1 = querySolution.get( variable1Name ) ;
			    if ( variable1 == null ) {
			    	triplePattern.append( "|||||");
			    }
			    else {
			    	if ( variable1.isResource() )
				    	triplePattern.append( ( ( Resource ) variable1 ).getURI() );
			    	else if ( variable1.isLiteral() )
			    		triplePattern.append( ( ( Literal ) variable1 ).getLexicalForm() );
			    }
			    
			    // variable 2
			    RDFNode variable2 = querySolution.get( variable2Name ) ;
			    if ( variable2 == null ) {
			    	triplePattern.append( "|||||");
			    }
			    else {
			    	if ( variable2.isResource() )
				    	triplePattern.append( "|||||").append( ( ( Resource ) variable2 ).getURI() );
			    	else if ( variable2.isLiteral() )
			    		triplePattern.append( "|||||").append( ( ( Literal ) variable2 ).getLexicalForm() );
			    }
			    
			    // variable 3
			    RDFNode variable3 = querySolution.get( variable3Name ) ;
			    if ( variable3 == null ) {
			    	triplePattern.append( "|||||");
			    }
			    else {
			    	if ( variable3.isResource() )
				    	triplePattern.append( "|||||").append( ( ( Resource ) variable3 ).getURI() );
			    	else if ( variable3.isLiteral() )
			    		triplePattern.append( "|||||").append( ( ( Literal ) variable3 ).getLexicalForm() );
			    }
			    
			    // variable 4
			    RDFNode variable4 = querySolution.get( variable4Name ) ;
			    if ( variable4 == null ) {
			    	triplePattern.append( "|||||");
			    }
			    else {
			    	if ( variable4.isResource() )
				    	triplePattern.append( "|||||").append( ( ( Resource ) variable4 ).getURI() );
			    	else if ( variable4.isLiteral() )
			    		triplePattern.append( "|||||").append( ( ( Literal ) variable4 ).getLexicalForm() );
			    }
			    
			    subjects = subjectsPerTriplePatterns.get( triplePattern.toString() );
			    if ( subjects == null ) {
			    	subjects = new ArrayList<String>();
			    }
			    subjects.add( subject.getURI() );
			    	
			    subjectsPerTriplePatterns.put( triplePattern.toString(), subjects );
		    }
		} finally {}
		
		// validation
		constraintViolationList = new ArrayList<ConstraintViolation>();
		int constraintViolationsCount = 0;
		String constraintViolationRoot = null;
		String constraintViolationMessage = null;
		String constraintViolationSource = "Labeling and Documentation Issues - Overlapping Labels";
		String constraintViolationFix = null;
		
		int indexOld = 0;
		int indexNew = 0;
		String variable1 = null;
		String variable2 = null;
		String variable3 = null;
		String variable4 = null;
		if ( subjectsPerTriplePatterns.keySet() != null ) {
			for (String tp : subjectsPerTriplePatterns.keySet()) {
				
				// variables ( of triple pattern )
				indexOld = 0;
				indexNew = tp.indexOf( "|||||", indexOld );
				variable1 = tp.substring( indexOld, indexNew );
				indexOld = ( indexNew + 5 );
				indexNew = tp.indexOf( "|||||", indexOld );
				variable2 = tp.substring( indexOld, indexNew );
				indexOld = indexNew + 5;
				indexNew = tp.indexOf( "|||||", indexOld );
				variable3 = tp.substring( indexOld, indexNew );
				indexOld = indexNew + 5;
				indexNew = tp.indexOf( "|||||", indexOld );
				if ( indexNew == -1 )
					variable4 = tp.substring( indexOld );
				else
					variable4 = tp.substring( indexOld, indexNew );
				
				// > 1 subjects ( of specific triple pattern )
				subjects = subjectsPerTriplePatterns.get( tp );
				if ( subjects.size() > 1 ) {
					writeLog( "tp: " + tp );
					for ( String subject1 : subjects ) {
						writeLog( "  subject: " + subject1 );
						constraintViolationRoot = subject1;
//						for ( String subject2 : subjects ) {
//							if ( ! StringUtils.equals( subject1, subject2 ) ) {
								constraintViolationsCount++;
								// raise constraint violation
								constraintViolation = new ConstraintViolation();
								constraintViolation.setRoot( constraintViolationRoot );
								constraintViolationMessage = new StringBuilder 
									("The concept '")
									.append( subject1 )
									.append( "' and the concept '" ) 
//									.append( subject2 )
									.append( "', belonging to the same concept scheme '" )
									.append( variable4 )
									.append( "', have the same preferred lexical label '" )
									.append( variable2 )
									.append( "' in the given language '" )
									.append( variable3 )
									.append( "' for the property '" )
									.append( variable1 )
									.append( "'. | Further explanation: Two concepts cannot have the same preferred lexical label in a given language when they belong to the same concept scheme. " )
									.append( "This could indicate missing disambiguation information and thus lead to problems in autocompletion application." )
									.toString();
								constraintViolation.setMessage( constraintViolationMessage );
								constraintViolation.setSource( constraintViolationSource );
								constraintViolationPaths = new ArrayList<String>();
								constraintViolationPaths.add( variable1 );
								constraintViolation.setPaths( constraintViolationPaths );
								constraintViolationFixes = new ArrayList<String>();
								constraintViolationFix = new StringBuilder 
										("Modify the preferred lexical label '")
										.append( variable2 )
										.append( "' in the given language '" )
										.append( variable3 )
										.append( "', the property '" ) 
										.append( variable1 )
										.append( "' is pointing to, of either concept '" ) 
										.append( subject1 )
										.append( "' or concept '" )
//										.append( subject2 )
										.append( "'." )
										.toString();
								constraintViolationFixes.add( constraintViolationFix );
								constraintViolation.setFixes( constraintViolationFixes );
								constraintViolationList.add( constraintViolation );
//							}
//						}
					}
				}
			}
		}
		
		System.out.println( constraintViolationsCount );
		
//		// iterate over distinct query subjects
//		String subject1 = null;
//		String subject2 = null;
//		String tp1 = null;
//		String tp2 = null;
//	    for( String tripleP1 : triplePatterns ) {
//	    	subject1 = tripleP1.substring( 0, tripleP1.indexOf( "|||||" ) );
//	    	tp1 = tripleP1.substring( tripleP1.indexOf( "|||||" ) + 5 );
//	    	System.out.println( "subject: " + subject1 );
//	    	System.out.println( "triple pattern:" + tp1 );
//		    System.out.println();
//		    for( String tripleP2 : triplePatterns ) {
//		    	subject2 = tripleP2.substring( 0, tripleP2.indexOf( "|||||" ) );
//		    	tp2 = tripleP2.substring( tripleP2.indexOf( "|||||" ) + 5 );
//		    	System.out.println( "  subject: " + subject2 );
//		    	System.out.println( "  triple pattern:" + tp2 );
//			}
//		}
		
//		Map<String, List<Tuples3>> sparqlQueryResultsTuples3 = new HashMap<String, List<Tuples3>>();
//		List<Tuples3> listTuples3 = null;
//		Tuples3 tuples3 = null;
		
//		Query query = QueryFactory.create( queryString ) ;
//		try {
//	        QueryExecution qexec = QueryExecutionFactory.create(query, model);
//		    ResultSet results = qexec.execSelect() ;
////		    ResultSetFormatter.out( System.out, results, query ) ;
//		    
//		    for ( ; results.hasNext() ; )
//		    {
//		    	QuerySolution querySolution = results.nextSolution() ;  
//			    Resource subject = querySolution.getResource( "subject" ) ; 
//			    RDFNode tuple1 = querySolution.get( tuple1Name ) ;
//			    RDFNode tuple2 = querySolution.get( tuple2Name ) ;
//			    RDFNode tuple3 = querySolution.get( tuple3Name ) ;
//			    
//			    // subject already in map?
//			    listTuples3 = sparqlQueryResultsTuples3.get( subject.getURI() );
//			    if ( listTuples3 != null )
//			    {
//			    	tuples3 = new Tuples3();
//			    	
//			    	// set tuple 1
//				    if ( tuple1.isResource() )
//			    		tuples3.setTuple1( ( ( Resource ) tuple1 ).getURI() );
//			    	else if ( tuple1.isLiteral() )
//			    		tuples3.setTuple1( ( ( Literal ) tuple1 ).getLexicalForm() );
//				    
//				    // set tuple 2
//				    if ( tuple2.isResource() )
//			    		tuples3.setTuple2( ( ( Resource ) tuple2 ).getURI() );
//			    	else if ( tuple2.isLiteral() )
//			    		tuples3.setTuple2( ( ( Literal ) tuple2 ).getLexicalForm() );
//				    
//				    // set tuple 3
//				    if ( tuple3.isResource() )
//			    		tuples3.setTuple3( ( ( Resource ) tuple3 ).getURI() );
//			    	else if ( tuple3.isLiteral() )
//			    		tuples3.setTuple3( ( ( Literal ) tuple3 ).getLexicalForm() );
//			    	
//				    listTuples3.add( tuples3 );
//				    
//					sparqlQueryResultsTuples3.put( subject.getURI() , listTuples3 );
//			    }
//			    else
//			    {
//			    	listTuples3 = new ArrayList<Tuples3>();
//			    	tuples3 = new Tuples3();
//			    	
//			    	// set tuple 1
//				    if ( tuple1.isResource() )
//			    		tuples3.setTuple1( ( ( Resource ) tuple1 ).getURI() );
//			    	else if ( tuple1.isLiteral() )
//			    		tuples3.setTuple1( ( ( Literal ) tuple1 ).getLexicalForm() );
//				    
//				    // set tuple 2
//				    if ( tuple2.isResource() )
//			    		tuples3.setTuple2( ( ( Resource ) tuple2 ).getURI() );
//			    	else if ( tuple2.isLiteral() )
//			    		tuples3.setTuple2( ( ( Literal ) tuple2 ).getLexicalForm() );
//				    
//				    // set tuple 3
//				    if ( tuple3.isResource() )
//			    		tuples3.setTuple3( ( ( Resource ) tuple3 ).getURI() );
//			    	else if ( tuple3.isLiteral() )
//			    		tuples3.setTuple3( ( ( Literal ) tuple3 ).getLexicalForm() );
//				    
//				    listTuples3.add( tuples3 );
//			    	
//					sparqlQueryResultsTuples3.put( subject.getURI(), listTuples3 );
//			    }
//		    }
//		} finally {}
		
//		// hash map for comparisons
//		Map<String, List<Tuples3>> sparqlQueryResultsTuples3_Compare = new HashMap<String, List<Tuples3>>();
//		sparqlQueryResultsTuples3_Compare.putAll( sparqlQueryResultsTuples3 );
//		List<Tuples3> listTuples3_Compare = null;
//		
//		// iterate over distinct query subjects
//		if ( sparqlQueryResultsTuples3.keySet() != null ) {
//			String tuple1 = null;
//			String tuple2 = null;
//			String tuple3 = null;
//			String tuple1_Compare = null;
//			String tuple2_Compare = null;
//			String tuple3_Compare = null;
//			for (String subject : sparqlQueryResultsTuples3.keySet()) {
//			    listTuples3 = sparqlQueryResultsTuples3.get( subject );
////			    System.out.println( "subject: " + subject );
//			    for( Tuples3 t3 : listTuples3 ) {
//			    	tuple1 = t3.getTuple1();  
//				    tuple2 = t3.getTuple2();
//				    tuple3 = t3.getTuple3();
////				    System.out.println( "  tuple1: " + tuple1 );
////				    System.out.println( "  tuple2: " + tuple2 );
////				    System.out.println( "  tuple3: " + tuple3 );
////				    System.out.println();
//				    if ( sparqlQueryResultsTuples3_Compare.keySet() != null ) {
//						for (String subject_Compare : sparqlQueryResultsTuples3_Compare.keySet()) {
//						    listTuples3_Compare = sparqlQueryResultsTuples3_Compare.get( subject_Compare );
////						    System.out.println( "    subject: " + subject );
//						    for( Tuples3 t3_Compare : listTuples3_Compare ) {
//						    	tuple1_Compare = t3_Compare.getTuple1();  
//							    tuple2_Compare = t3_Compare.getTuple2();
//							    tuple3_Compare = t3_Compare.getTuple3();
////							    System.out.println( "      tuple1: " + tuple1_Compare );
////							    System.out.println( "      tuple2: " + tuple2_Compare );
////							    System.out.println( "      tuple3: " + tuple3_Compare );
////							    System.out.println();
//						    }
//						}
//					}
//			    }
//			}
//		}
		
		
		
		// save tuples in 1 string 
		
		
		

//	    Query query = QueryFactory.create( queryString ); 
//	    String sparqlEndpoint = "http://lod.gesis.org/thesoz/sparql";
//	    QueryExecution qExe = QueryExecutionFactory.sparqlService( sparqlEndpoint, query );
//	    ResultSet results = qExe.execSelect();
	    
//	    System.out.println("hui");
//	    ResultSetFormatter.out( System.out, results, query ) ;
	    
//	    Model results = qExe.execConstruct();
//	    RDFDataMgr.write(System.out, results, "TURTLE") ;
//	    results.write(System.out, "TURTLE");
	}
	
	public List<String> getConstraintViolationPaths() {
		return constraintViolationPaths;
	}

	public void setConstraintViolationPaths(List<String> constraintViolationPaths) {
		this.constraintViolationPaths = constraintViolationPaths;
	}

	public String getQueryString( String sparqlFilename ) {
		StringBuffer queryStringBuffer = new StringBuffer();
		BufferedReader br = null;
		 
		try 
		{
			String sCurrentLine;
 
			br = new BufferedReader( new FileReader( absolutePathResources + "/rdfGraphs/SKOS/SPARQL/" + sparqlFilename ) );
 
			while ((sCurrentLine = br.readLine()) != null)
				queryStringBuffer.append( sCurrentLine ).append( "\n" );
 
		} catch (IOException e) { 
			e.printStackTrace();
		} finally {
			try {
				if (br != null)br.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		
		System.out.println( queryStringBuffer.toString() );
		
		return queryStringBuffer.toString();
	}
	
	public String getAbsolutePathResources() {
		return absolutePathResources;
	}

	public void setAbsolutePathResources(String absolutePathResources) {
		this.absolutePathResources = absolutePathResources;
	}
	
	public String getInputRDFGraph() {
		return inputRDFGraph;
	}
	
	public void setInputRDFGraph(String inputRDFGraph) {
		this.inputRDFGraph = inputRDFGraph;
	}
	
	/**
	 * get RDF graph ( by string )
	 * 
	 */
	public Model getRDFGraphByString( String rdfGraph, String rdfGraph_ConcreteSyntax ) {
		Model model = ModelFactory.createDefaultModel();
		
		try {
			model.read( IOUtils.toInputStream( rdfGraph, "UTF-8" ), null, rdfGraph_ConcreteSyntax );
		} catch ( Exception e ) { e.printStackTrace(); }
		
		return model;
	}

	/**
	 * get RDF graph ( from zip file )
	 * 
	 */
	public Model getRDFGraphFromZip( String relativePathAndFileName, String rdfGraph_ConcreteSyntax ) {
		Model model = ModelFactory.createDefaultModel();
		
		try {
			ZipFile zipFile = new ZipFile( absolutePathResources +  "/" + relativePathAndFileName );
			Enumeration<? extends ZipEntry> entries = zipFile.entries();
		    while( entries.hasMoreElements()) {
		        ZipEntry entry = entries.nextElement();
		        model.read( zipFile.getInputStream( entry ), null, rdfGraph_ConcreteSyntax );
		    }
		} catch (Exception e) { 
			e.printStackTrace(); 
		}
		
		return model;
	}
	
	private void writeLog( String text ) {
		if( isLogging ) {
			try {
				logBufferedWriter.write( text );
				logBufferedWriter.newLine();
				logBufferedWriter.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	private void openLog() {
		if ( isLogging ) {
			try {
				logBufferedWriter = new BufferedWriter( new FileWriter( new File( absolutePathResources + "/log/log.log" ) ) );
				
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	private void closeLog() {
		if ( isLogging ) {
			try {
				logBufferedWriter.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public List<RDFValidation.ConstraintViolation> getConstraintViolationList() {
		return constraintViolationList;
	}

	public void setConstraintViolationList(
			List<RDFValidation.ConstraintViolation> constraintViolationList) {
		this.constraintViolationList = constraintViolationList;
	}
}
