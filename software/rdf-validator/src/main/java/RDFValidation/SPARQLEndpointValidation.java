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
import java.util.Hashtable;
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

public class SPARQLEndpointValidation {
	private String absolutePathConstraints = null;
	private String[] sparqlEndpoints = null;
	private String[] constraints = null;
	private String limit;
	
	// constraint violations
	public List<RDFValidation.ConstraintViolation> constraintViolationList = null;
	private RDFValidation.ConstraintViolation constraintViolation = null;
	private List<String> constraintViolationPaths = null;
	private List<String> constraintViolationFixes = null;
	
	// counts ( constraints grouped by constraint type )
	public int countInformations = 0;
	public int countWarnings = 0;
	public int countErrors = 0;
	
	// validation exception
	public ValidationException validationException  = null;
	
//	// constraint violations per constraint
//	Hashtable<String,ConstraintViolationPerConstraint> constraintViolationsPerConstraint = null;
	
	public SPARQLEndpointValidation( 
		String absolutePathConstraints, 
		String[] sparqlEndpoints, 
		String[] constraints,
		String limit ) {
		this.absolutePathConstraints = absolutePathConstraints;
		this.sparqlEndpoints = sparqlEndpoints;
		this.constraints = constraints;
		this.limit = limit;
		
		// counts ( constraints grouped by constraint type )
		countInformations = 0;
		countWarnings = 0;
		countErrors = 0;
		
//		// constraint violations per constraint
//		constraintViolationsPerConstraint = new Hashtable<String,ConstraintViolationPerConstraint>();
//		ConstraintViolationPerConstraint constraintViolationPerConstraint = new ConstraintViolationPerConstraint();
	}

	public void validate() {
		
		// default namespace declarations
		String defaultNamespaceDeclarations = getQueryString( "default-namespace-declarations" );
		
		constraintViolationList = new ArrayList<ConstraintViolation>();
		
		for ( String sparqlEndpoint : sparqlEndpoints ) {
			
			// endpoint selected
			if ( ! sparqlEndpoint.equals( "" ) ) {
				
				// testing
				System.out.println( "endpoint: " + sparqlEndpoint );
				System.out.println( "-----" );
				
				if ( sparqlEndpoint.contains( "http" ) && ! sparqlEndpoint.startsWith( "http" ) ) 
					sparqlEndpoint = sparqlEndpoint.substring( sparqlEndpoint.indexOf( "http" ), sparqlEndpoint.length() -1 );
				
				for ( String constraint : constraints ) {
					
					if ( ! constraint.endsWith( "(!)" ) ) {
						
						String queryString = "";
						
						if ( ( ! StringUtils.equals( limit, "" ) ) && ( ! StringUtils.equals( limit, "0" ) ) )
							queryString = new StringBuilder( 
								defaultNamespaceDeclarations ).append( "\r\n" ) 
								.append( "SELECT ?subject ?violationMessage ?violationSource ?severityLevel" ).append( "\r\n" ) 
								.append( "WHERE {" ).append( "\r\n" )
								.append( getQueryString( constraint ) ).append( "\r\n" )
								.append( "}" ).append( "\r\n" )
								.append( "LIMIT " ).append( limit ).append( "\n" )
								.toString();
						else
							queryString = new StringBuilder( 
								defaultNamespaceDeclarations ).append( "\r\n" ) 
								.append( "SELECT ?subject ?violationMessage ?violationSource ?severityLevel" ).append( "\r\n" ) 
								.append( "WHERE {" ).append( "\r\n" )
								.append( getQueryString( constraint ) ).append( "\r\n" )
								.append( "}" )
								.toString();
						
						// testing
						System.out.println( queryString );
						
						try {
							Query query = QueryFactory.create( queryString ) ;
							QueryExecution qexec = QueryExecutionFactory.sparqlService( sparqlEndpoint, query );
						    ResultSet results = qexec.execSelect() ;	    
						    for ( ; results.hasNext() ; ) {
						    	QuerySolution querySolution = results.nextSolution() ;  
						    	 
							    constraintViolation = new ConstraintViolation();
							    
							    // root
							    RDFNode root = querySolution.get( "subject" ) ;
							    if ( root != null ) {
							    	if ( root.isResource() )
							    		constraintViolation.setRoot( ( ( Resource ) root ).getURI() );
							    	else if ( root.isLiteral() )
							    		constraintViolation.setRoot( ( ( Literal ) root ).getLexicalForm() );
							    		
							    }
							    	
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
			// no endpoint selected
			else {
				// validation exception
				validationException = new ValidationException();
				validationException.setSource( "SPARQL endpoint" );
				validationException.setMessage( "no SPARQL endpoint selected!" );
			}
		}
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
		
		return queryStringBuffer.toString();
	}	
}
