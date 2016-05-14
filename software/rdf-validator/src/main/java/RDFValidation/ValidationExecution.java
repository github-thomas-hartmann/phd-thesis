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

public class ValidationExecution {
	private String absolutePathConstraints = null;
	private String inputRDFGraph = null;
	private String[] constraints = null;
	
	// constraint violations
	public List<RDFValidation.ConstraintViolation> constraintViolationList = null;
	private RDFValidation.ConstraintViolation constraintViolation = null;
	private List<String> constraintViolationPaths = null;
	private List<String> constraintViolationFixes = null;
	
	// counts ( constraints grouped by constraint type )
	public short countInformations = 0;
	public short countWarnings = 0;
	public short countErrors = 0;
	
	// validation exception
	public ValidationException validationException  = null;
	
	public ValidationExecution( 
		String absolutePathConstraints, 
		String inputRDFGraph,
		String[] constraints ) {
		this.absolutePathConstraints = absolutePathConstraints;
		this.inputRDFGraph = inputRDFGraph;
		this.constraints = constraints;
		
		// counts ( constraints grouped by constraint type )
		countInformations = 0;
		countWarnings = 0;
		countErrors = 0;
	}

	public void validate() {
		
		constraintViolationList = new ArrayList<ConstraintViolation>();
		
		// input RDF graph
		Model model = ModelFactory.createDefaultModel();
		model.add( getRDFGraphByString( inputRDFGraph, "TTL" ) );
						
		for ( String constraint : constraints ) {
			
			if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {
			
				String queryString = getQueryString( constraint );
				
				try {
					Query query = QueryFactory.create( queryString ) ;
					QueryExecution qexec = QueryExecutionFactory.create(query, model);
				    ResultSet results = qexec.execSelect() ;	    
				    for ( ; results.hasNext() ; ) {
				    	QuerySolution querySolution = results.nextSolution() ;  
				    	 
					    constraintViolation = new ConstraintViolation();
					    
					    // root
					    RDFNode root = querySolution.get( "subject" ) ;
					    if ( root != null && root.isResource() )
					    	constraintViolation.setRoot( ( ( Resource ) root ).getURI() );
					    
					    // violation message
					    RDFNode violationMessage = querySolution.get( "violationMessage" ) ;
					    if ( violationMessage != null && violationMessage.isLiteral() )
					    	constraintViolation.setMessage( ( ( Literal ) violationMessage ).getLexicalForm() );
					    
					    // violation source
					    RDFNode violationSource = querySolution.get( "violationSource" ) ;
					    if ( violationSource != null && violationSource.isLiteral() )
					    	constraintViolation.setSource( ( ( Literal ) violationSource ).getLexicalForm() );
					    
					    // severity level
					    RDFNode severityLevel = querySolution.get( "severityLevel" ) ;
					    if ( severityLevel != null && severityLevel.isLiteral() ) {
					    	constraintViolation.setSeverityLevel( ( ( Literal ) severityLevel ).getLexicalForm() );
					 
						    // counts ( constraints grouped by constraint type )
							if ( StringUtils.equals( ( ( Literal ) severityLevel ).getLexicalForm(), "INFO" ) )
								countInformations++;
							else if ( StringUtils.equals( ( ( Literal ) severityLevel ).getLexicalForm(), "WARNING" ) )
								countWarnings++;
							else if ( StringUtils.equals( ( ( Literal ) severityLevel ).getLexicalForm(), "ERROR" ) )
								countErrors++;
					    }
					    
					    constraintViolationList.add( constraintViolation );
				    }
				}
				catch (Exception e) {
					// validation exception
					validationException = new ValidationException();
					validationException.setSource( "validation" );
					if ( e.getMessage() != null )
						validationException.setMessage( e.getMessage().replace( "<", "&lt;" ).replace( ">", "&gt;" ) );
					if ( e.getCause() != null )
						validationException.setCause( e.getCause().toString() );
					if ( e.getStackTrace() != null ) {
						String stackTrace = null;
						for ( StackTraceElement ste : e.getStackTrace() ) {
							stackTrace = stackTrace + ste.toString() + "\n";
						}
						validationException.setStackTrace( stackTrace );
					}
				}
				finally {}
			}
		}
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

	public String getQueryString( String sparqlFilename ) {
		StringBuffer queryStringBuffer = new StringBuffer();
		BufferedReader br = null;
		 
		try 
		{
			String sCurrentLine;
			br = new BufferedReader( new FileReader( absolutePathConstraints + "/" + sparqlFilename + ".ttl" ) );
 
			while ((sCurrentLine = br.readLine()) != null)
				queryStringBuffer.append( sCurrentLine ).append( "\n" );
 
		} catch (IOException e) {
			// validation exception
			validationException = new ValidationException();
			validationException.setSource( "get query string" );
			if ( e.getMessage() != null )
				validationException.setMessage( e.getMessage().replace( "<", "&lt;" ).replace( ">", "&gt;" ) );
		} finally {
			try {
				if (br != null)br.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		
		// testing
		System.out.println(queryStringBuffer.toString());
		
		return queryStringBuffer.toString();
	}
}
