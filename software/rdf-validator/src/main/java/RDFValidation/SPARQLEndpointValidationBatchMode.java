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

public class SPARQLEndpointValidationBatchMode {
	private String absolutePathConstraints = null;
	private String[] sparqlEndpoints = null;
	private String[] constraints = null;
	private String limit;
	
	// counts ( constraints grouped by constraint type )
	public int countInformations = 0;
	public int countWarnings = 0;
	public int countErrors = 0;
	
	// logging
	private boolean isLogging = false;
	private BufferedWriter logBufferedWriter = null;
	
	//
//	Hashtable<String,String> CountAndSeverityLevelByEndpointAndConstraint = new Hashtable<String,String>();
	
	public SPARQLEndpointValidationBatchMode( 
		String absolutePathConstraints, 
		String[] sparqlEndpoints, 
		String[] constraints,
		String limit,
		boolean isLogging ) {
		this.absolutePathConstraints = absolutePathConstraints;
		this.sparqlEndpoints = sparqlEndpoints;
		this.constraints = constraints;
		this.limit = limit;
		this.isLogging = isLogging;
		
		// counts ( constraints grouped by constraint type )
		countInformations = 0;
		countWarnings = 0;
		countErrors = 0;
		
		// log
		openLog();
	}

	public void validate() {
		
		// default namespace delarations
		String defaultNamespaceDeclarations = getQueryString( "default-namespace-declarations" );
		
		// SELECT
//		String select = "SELECT ?severityLevel ( COUNT ( ?subject ) AS ?count )";
		String select = "SELECT ( COUNT ( ?subject ) AS ?count )";
//		String select = "SELECT ?subject";
		
		// query suffix
//		String groupBy = "GROUP BY ?severityLevel ";
//		String groupBy = "GROUP BY ?subject ";
//		int limit = 1;
//		int offset = 0;
		
		String severityLevel = null;

		for ( String sparqlEndpoint : sparqlEndpoints ) {
			
			// endpoint selected
			if ( ! sparqlEndpoint.equals( "" ) ) {
				
				// testing
				System.out.println( "endpoint: " + sparqlEndpoint );
				System.out.println( "-----" );
				
				// log
				writeLog( sparqlEndpoint );
				writeLogNewLine();
//				writeLog( "LIMIT: " + limit );
//				writeLogNewLine();
				writeLog( "-----" );
				writeLogNewLine();
				
				if ( sparqlEndpoint.contains( "http" ) && ! sparqlEndpoint.startsWith( "http" ) ) 
					sparqlEndpoint = sparqlEndpoint.substring( sparqlEndpoint.indexOf( "http" ), sparqlEndpoint.length() -1 );
				
				for ( String constraint : constraints ) {
					
					if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {

						// start time
						long startTime = System.nanoTime();
						
						// log
						writeLog( constraint );	
					
						// query string
						String queryString = new StringBuilder( 
							defaultNamespaceDeclarations ).append( "\r\n" ) 
							.append( select ).append( "\r\n" ) 
							.append( getQueryString( constraint ) ).append( "\r\n" )
//							.append( groupBy ).append( "\r\n" )
//							.append( "LIMIT " ).append( limit ).append( "\r\n" )
//							.append( "OFFSET " ).append( offset ).append( "\r\n" )
							.toString();
						
						try {
							Query query = QueryFactory.create( queryString ) ;
							QueryExecution qexec = QueryExecutionFactory.sparqlService( sparqlEndpoint, query );
							qexec.setTimeout( 300000 ); // 5 min
						    ResultSet results = qexec.execSelect() ;
						    
						    for ( ; results.hasNext() ; ) {
						    	QuerySolution querySolution = results.nextSolution() ;  
							    
							    // count
							    RDFNode count = querySolution.get( "count" ) ;
							    if ( count != null ) {
							    	if ( count.isResource() )
							    		System.out.println( ( ( Resource ) count ).getURI() );
							    	else if ( count.isLiteral() )
							    		System.out.println( ( ( Literal ) count ).getLexicalForm() );	
							    	
							    	// log
									long endTime = System.nanoTime();
									long duration = (endTime - startTime) / 1000000000;
									writeLog( " ( constraint violations: " + count + " | duration: " + duration + " sec )" );	
									writeLogNewLine();
							    }
							    
//							    // severity level
//							    severityLevel = null;
//							    RDFNode sl = querySolution.get( "severityLevel" ) ;
//							    if ( sl != null && sl.isLiteral() )
//							    	System.out.println( severityLevel = ( ( Literal ) sl ).getLexicalForm() );
						    }
						}
						catch (Exception e) {
							// log
							if ( e.getMessage() != null ) 
								writeLog( " ( validation exception: " + e.getMessage().toString() + " )" );
							if ( e.getCause() != null ) 
								writeLog( e.getCause().toString() );
							if ( e.getStackTrace() != null ) {
								String stackTrace = null;
								for ( StackTraceElement ste : e.getStackTrace() ) {
									writeLog( stackTrace = stackTrace + ste.toString() );
								}
							}
							else
								writeLog( "validation exception" );
							writeLogNewLine();
							System.out.println( "validation exception" );
							System.out.println();
						}
						finally {}
						
//						// log
//						writeLog( " ( informations: " + countInformations + " | warnings: " + countWarnings + " | errors: " + countErrors + " )" );	
//						writeLogNewLine();
					}
					
					countInformations = 0;
					countWarnings = 0;
					countErrors = 0;
				}
				// log
				writeLogNewLine();
			}	
			// no endpoint selected
			else {
				// log
				writeLog( "validation exception: no SPARQL endpoint selected!" );
				writeLogNewLine();
			}
		}
		
		// log
		closeLog();
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
			if ( ( ! StringUtils.equals( limit, "" ) ) && ( ! StringUtils.equals( limit, "0" ) ) )
				queryStringBuffer.append( "LIMIT " ).append( limit ).append( "\n" );
 
		} catch (IOException e) {
			// validation in batch mode
			writeLog( "validation exception" );
			writeLogNewLine();
		} finally {
			try {
				if (br != null)br.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		
		// testing
//		System.out.println(queryStringBuffer.toString());
		
		return queryStringBuffer.toString();
	}
	
	private void writeLog( String text ) {
		if( isLogging ) {
			try {
				logBufferedWriter.write( text );
				logBufferedWriter.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	private void writeLogNewLine( ) {
		if( isLogging ) {
			try {
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
				String absolutePathResources = absolutePathConstraints.substring( 0, absolutePathConstraints.indexOf( "resources" ) + 9 );
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
	
}
