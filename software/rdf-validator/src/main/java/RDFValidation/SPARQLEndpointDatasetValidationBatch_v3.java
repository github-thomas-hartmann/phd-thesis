package RDFValidation;

import gnu.trove.map.TIntObjectMap;
import gnu.trove.map.hash.TIntObjectHashMap;
import gnu.trove.set.TIntSet;
import gnu.trove.set.hash.THashSet;
import gnu.trove.set.hash.TIntHashSet;

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
import java.util.Set;
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

public class SPARQLEndpointDatasetValidationBatch_v3 {
	private String absolutePathConstraints = null;
	private String[] sparqlEndpoints = null;
	private String[] constraints = null;
	private String limit;
	
	// constraints on data sets
	private List<String> constraintsOnDataSets = null;
	
	// logging
	private boolean isLogging = false;
	private BufferedWriter logBufferedWriter = null;
	
	public SPARQLEndpointDatasetValidationBatch_v3( 
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
		
		// constraints on data sets
		constraintsOnDataSets = new ArrayList<String>(1);
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-01" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-02" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-03" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-04" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-05" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-06" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-07" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-08" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-09" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-10 (not yet implemented!)" );
		constraintsOnDataSets.add( "DATA-CUBE-C-DATA-MODEL-CONSISTENCY-11" );
		constraintsOnDataSets.add( "DATA-CUBE-C-MAXIMUM-QUALIFIED-CARDINALITY-RESTRICTIONS-01" );
		
		// log
		openLog();
	}

	public void validate() {
		List<String> dataSets = null;
		String defaultNamespaceDeclarations = getQueryString( "default-namespace-declarations" );
		String select = "SELECT ( COUNT ( ?subject ) AS ?count )";

		// for each SPARQL endpoint
		for ( String sparqlEndpoint : sparqlEndpoints ) { 
			
			// SPARQL endpoint selected
			if ( ! sparqlEndpoint.equals( "" ) ) {
				
				// testing
				System.out.println( "endpoint: " + sparqlEndpoint );
				System.out.println( "-----" );
				
				// log
//				writeLog( sparqlEndpoint );
//				writeLogNewLine();
//				writeLog( "LIMIT: " + limit );
//				writeLogNewLine();
//				writeLog( "-----" );
//				writeLogNewLine();
				
				if ( sparqlEndpoint.contains( "http" ) && ! sparqlEndpoint.startsWith( "http" ) ) 
					sparqlEndpoint = sparqlEndpoint.substring( sparqlEndpoint.indexOf( "http" ), sparqlEndpoint.length() -1 );
				
				// data sets ( of SPARQL endpoint )
				dataSets = getDataSets( defaultNamespaceDeclarations, sparqlEndpoint );
				for ( String dataSet : dataSets )
					System.out.println(dataSet);
				
				// constraint validation per data set and constraint
//				Hashtable<String,String> constraintValidationPerDataSet = new Hashtable<String,String>( dataSets.size() );
				Hashtable<String,String> validationPerDataSetAndConstraint = new Hashtable<String,String>();
				String dataSetConstraint = "";
				String constraintValidation = "";
				
//				for ( String constraint : constraints ) {
//					
//					if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {

						// start time
						long startTime = System.nanoTime();
					
						// constraint on individual data sets of SPARQL Endpoint
						if ( dataSets.size() > 0 ) {
							
							// for each data set ( of SPARQL Endpoint )
							for ( String dataSet : dataSets ) {
								
								System.out.println();
								System.out.println();
								
								// start time
								startTime = System.nanoTime();
								
								for ( String constraint : constraints ) {
									
									if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {
										
										// constraint on data set ?
										if ( constraintsOnDataSets.contains( constraint ) ) {
											
											writeLog( dataSet + " ( " + constraint + " ): " ); 
//											writeLog( "-----" ); writeLogNewLine();
									
											// query string
											String queryString = new StringBuilder( 
												defaultNamespaceDeclarations )
												.append( "SELECT ( COUNT ( ?subject ) AS ?count )" ).append( "\r\n" ) 
			//									.append( "SELECT ?subject" ).append( "\r\n" ) 
												.append( "WHERE {" ).append( "\r\n" ) 
			//									.append( "    ?subject qb:dataSet <" + dataSet + "> ." ).append( "\r\n" ) 
			//									.append( "    FILTER ( ?dataSet = <" + dataSet + "> ) ." ).append( "\r\n" ) 
												.append( StringUtils.replace( getQueryString ( constraint ), "?dataSet", "<" + dataSet + ">" ) )
												.append( "}" )
			//									.append( "\r\n" )
			//									.append( "LIMIT 1" ) 		
												.toString();
											System.out.println( "data set: " + dataSet );
											System.out.println( "constraint: " + constraint );
											System.out.println();
											System.out.println( queryString );
											System.out.println();
											
											try {
												Query query = QueryFactory.create( queryString ) ;
												QueryExecution qexec = QueryExecutionFactory.sparqlService( sparqlEndpoint, query );
												qexec.setTimeout( 600000 ); // 10 min
											    ResultSet results = qexec.execSelect() ;
											    
											    for ( ; results.hasNext() ; ) {
											    	QuerySolution querySolution = results.nextSolution() ;  
												    
												    // count
												    RDFNode count = querySolution.get( "count" ) ;
			//								    	RDFNode count = querySolution.get( "subject" ) ;
												    if ( count != null && count.isLiteral() ) {
												    		
												    	
												    	
														long endTime = System.nanoTime();
														long duration = (endTime - startTime) / 1000000000;
														
														System.out.println( "count: " + Integer.parseInt( ( ( Literal ) count ).getLexicalForm() ) + " | duration: " + duration );
														System.out.println();
														writeLog( ( ( Literal ) count ).getLexicalForm() + " ( " + duration + " sec )" ); writeLogNewLine();
														
														// constraint validation
														constraintValidation = ( ( Literal ) count ).getLexicalForm();
//														if ( StringUtils.equals( ( ( Literal ) count ).getLexicalForm(), "0" ) )
//															constraintValidation += " & $\\checkmark$";
//														else
//															constraintValidation += " & " + ( ( Literal ) count ).getLexicalForm();
												    }
											    }
											}
											catch (Exception e) {
			//									// log
			//									if ( e.getMessage() != null ) 
			//										writeLog( " ( validation exception: " + e.getMessage().toString() + " )" );
			//									if ( e.getCause() != null ) 
			//										writeLog( e.getCause().toString() );
			//									if ( e.getStackTrace() != null ) {
			//										String stackTrace = null;
			//										for ( StackTraceElement ste : e.getStackTrace() ) {
			//											writeLog( stackTrace = stackTrace + ste.toString() );
			//										}
			//									}
			//									else
			//										writeLog( "validation exception" );
			//									writeLogNewLine();
												
												
												long endTime = System.nanoTime();
												long duration = (endTime - startTime) / 1000000000;
												System.out.println( " ERROR ( " + duration + " sec )" );
												writeLog( " ERROR ( " + duration + " sec )" ); writeLogNewLine();
												
												// constraint validation
//												constraintValidation += " & \\ding{55}";
												constraintValidation = "";
											}
											
											// constraint validation per data set and constraint
//											constraintValidationPerDataSet.put( dataSet, constraintValidation );
											dataSetConstraint = dataSet + "_" + constraint;
											validationPerDataSetAndConstraint.put( dataSetConstraint, constraintValidation );
										}
									}
								}
							}
							
							// generate latex 
							generateLatex( sparqlEndpoint, dataSets, constraints, validationPerDataSetAndConstraint, ( short ) 17 );
						}
						
						// constraint on whole SPARQL Endpoint
						else {
							
							for ( String constraint : constraints ) {
								
								if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {
							
									// query string
									String queryString = new StringBuilder( 
										defaultNamespaceDeclarations ).append( "\r\n" ) 
										.append( select ).append( "\r\n" ) 
										.append( "WHERE {" ).append( "\r\n" )
										.append( getQueryString( constraint ) ).append( "\r\n" )
										.append( "}" )
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
								}
							}
						}
//					}
//				}
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
	
	public List<String> getDataSets( 
		String defaultNamespaceDeclarations, 
		String sparqlEndpoint ) {
		
		List<String> dataSets = new ArrayList<String>();
		
		// query string
		String queryString = new StringBuilder( 
			defaultNamespaceDeclarations ).append( "\r\n" ) 
			.append( getQueryString( "data-sets" ) )
			.toString();

		try {
		Query query = QueryFactory.create( queryString ) ;
		QueryExecution qexec = QueryExecutionFactory.sparqlService( sparqlEndpoint, query );
		qexec.setTimeout( 300000 );
	    ResultSet results = qexec.execSelect() ;
	    
	    for ( ; results.hasNext() ; ) {
	    	QuerySolution querySolution = results.nextSolution() ;  
		    
		    RDFNode subject = querySolution.get( "subject" ) ;
		    if ( subject != null && subject.isResource() )
		    	dataSets.add( ( ( Resource ) subject ).getURI() );
	    }
	}
	catch (Exception e) {
		System.out.println( "validation exception: get datasets" );
	}
	finally {}
		
		return dataSets;
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
	
	private void generateLatex( String sparqlEndpoint, List<String> dataSets, String[] constraints, Hashtable<String,String> validationPerDataSetAndConstraint, short maxCountRowsPerTable ) {
		try {
			// count tables
			int countTables = 0;
			if ( dataSets.size() < maxCountRowsPerTable )
				maxCountRowsPerTable = ( short ) dataSets.size();
			countTables = dataSets.size() / maxCountRowsPerTable;
			
			// rows per table
			String dataSetConstraint = "";
			String currentRow = "";
			TIntObjectMap<String> rowsPerTable = new TIntObjectHashMap<String>();
			String dataSetCleaned = "";
			for ( int t = 0; t < countTables; t++ ) {				
				for ( int d = ( t * maxCountRowsPerTable ); d < ( ( t * maxCountRowsPerTable ) + maxCountRowsPerTable ); d++ ) {
					
					dataSetCleaned = StringUtils.replace( dataSets.get( d ), sparqlEndpoint.substring( 0, StringUtils.replace( sparqlEndpoint, "http://", "" ).indexOf( "/" ) + 7 ), "" );
					if ( dataSetCleaned.startsWith( "/" ) )
						dataSetCleaned = dataSetCleaned.substring( 1, dataSetCleaned.length() );
					dataSetCleaned = StringUtils.replace( dataSetCleaned, "_", "$\\_$" );
					dataSetCleaned = StringUtils.replace( dataSetCleaned, "dataset/", "" );
					currentRow += "    \\emph{" + dataSetCleaned + "}";
					
					for ( int c = 0; c < constraints.length; c++ ) {
						dataSetConstraint = dataSets.get( d ) + "_" + constraints[c];
						if ( validationPerDataSetAndConstraint.get( dataSetConstraint ) != null ) {
							if ( StringUtils.equals( validationPerDataSetAndConstraint.get( dataSetConstraint ), "" ) )
								currentRow += " & " + "\\ding{55}";
							else if ( StringUtils.equals( validationPerDataSetAndConstraint.get( dataSetConstraint ), "0" ) )
								currentRow += " & " + "$\\checkmark$";
							else
								currentRow += " & " + validationPerDataSetAndConstraint.get( dataSetConstraint );
						}
						else
							currentRow += " & -";
					}
					currentRow += "  \\\\";
				}
				rowsPerTable.put( t, currentRow );
				currentRow = "";
			}
			
			// remaining data sets in own new table
			short countRemainingDataSets = ( short ) ( dataSets.size() - ( countTables * maxCountRowsPerTable ) ); 
			if ( countRemainingDataSets != 0 ) {
				countTables++;
				short indexFirstRemainingDataSet = ( short ) ( dataSets.size() - countRemainingDataSets );
				for ( short d = indexFirstRemainingDataSet; d < dataSets.size(); d++ ) {
					
					// current row
					dataSetCleaned = StringUtils.replace( dataSets.get( d ), sparqlEndpoint.substring( 0, StringUtils.replace( sparqlEndpoint, "http://", "" ).indexOf( "/" ) + 7 ), "" );
					if ( dataSetCleaned.startsWith( "/" ) )
						dataSetCleaned = dataSetCleaned.substring( 1, dataSetCleaned.length() );
					dataSetCleaned = StringUtils.replace( dataSetCleaned, "_", "$\\_$" );
					dataSetCleaned = StringUtils.replace( dataSetCleaned, "dataset/", "" );
					currentRow += "    \\emph{" + dataSetCleaned + "}";
					
					for ( int c = 0; c < constraints.length; c++ ) {
						dataSetConstraint = dataSets.get( d ) + "_" + constraints[c];
						if ( validationPerDataSetAndConstraint.get( dataSetConstraint ) != null ) {
							if ( StringUtils.equals( validationPerDataSetAndConstraint.get( dataSetConstraint ), "" ) )
								currentRow += " & " + "\\ding{55}";
							else if ( StringUtils.equals( validationPerDataSetAndConstraint.get( dataSetConstraint ), "0" ) )
								currentRow += " & " + "$\\checkmark$";
							else
								currentRow += " & " + validationPerDataSetAndConstraint.get( dataSetConstraint );
						}
						else
							currentRow += " & -";
						currentRow += "  \\\\";
						rowsPerTable.put( countTables - 1, currentRow );
					}
				}
			}
			
			// testing
			for ( int t = 0; t < countTables; t++ ) { 
				for ( String row : rowsPerTable.get( t ).split( "\\\\\\\\" ) )
					if ( row.length() != 0 )
						System.out.println ( "table " + t + ": " + row );
			}
			
			// open latex
			BufferedWriter latexBufferedWriter = null;
			String absolutePathResources = absolutePathConstraints.substring( 0, absolutePathConstraints.indexOf( "resources" ) + 9 );
			String sparqlEndpointCleaned = StringUtils.replace( sparqlEndpoint, "http://", "" );
			sparqlEndpointCleaned = StringUtils.replace( sparqlEndpointCleaned, "/", "-" );
			sparqlEndpointCleaned = StringUtils.replace( sparqlEndpointCleaned, ":", "-" );
			File file = new File( absolutePathResources + "\\latex\\" + sparqlEndpointCleaned );
		    file.createNewFile(); 
			latexBufferedWriter = new BufferedWriter( new FileWriter( file ) );
			
			// SPARQL Endpoint Validation
			String rowSPARQLEndpointValidation = "    \\emph{" + sparqlEndpoint + "}";
			int constraintValidation = 0;
			int validationErrors = 0;
			for ( int c = 0; c < constraints.length; c++ ) {
				constraintValidation = 0;
				for ( int d = 0; d < dataSets.size(); d++ ) {
					dataSetConstraint = dataSets.get( d ) + "_" + constraints[c];
					if ( validationPerDataSetAndConstraint.get( dataSetConstraint ) != null ) {
						
						// validation error
						if ( StringUtils.equals( validationPerDataSetAndConstraint.get( dataSetConstraint ), "" ) )
							validationErrors++;	
						
						// NO constraint violation 
						else if ( ( ! StringUtils.equals( validationPerDataSetAndConstraint.get( dataSetConstraint ), "0" ) ) )
							constraintValidation += Integer.valueOf( validationPerDataSetAndConstraint.get( dataSetConstraint ) );
					}
				}
				rowSPARQLEndpointValidation += " & " + constraintValidation;
				
				// validation errors
				if ( validationErrors > 0 )
					rowSPARQLEndpointValidation += " (" + validationErrors + ")";
			}
			rowSPARQLEndpointValidation += "  \\\\";
			
			// write latex ( SPARQL Endpoint Validation )
			latexBufferedWriter.write( "\\begin{table}[H]" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "    \\begin{center}" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "    \\begin{tabular}{@{}l" );
			
			for ( int c = 0; c < constraints.length; c++ )
				latexBufferedWriter.write( "c" );
			latexBufferedWriter.write( "@{}}" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "           & \\multicolumn{" + constraints.length + "}{c}{\\textbf{Constraints}}" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "    \\\\  \\cmidrule{2-" + ( constraints.length + 1 ) + "}" ); latexBufferedWriter.newLine();
			
			latexBufferedWriter.write( "    \\\\       \\textbf{Data Sets}" ); latexBufferedWriter.newLine();
			for ( String constraint : constraints ) {
				if ( constraint.contains( "DATA-CUBE-C-" ) )
					constraint = StringUtils.replace( constraint, "DATA-CUBE-C-", "" );
				if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {
					latexBufferedWriter.write( "           & \\rot{\\emph{" + constraint + "}}" ); latexBufferedWriter.newLine();
				}
				else {
					latexBufferedWriter.write( "           & \\rot{\\emph{" + StringUtils.replace( constraint, " (not yet implemented!)", " (!)" ) + "}}" ); latexBufferedWriter.newLine();	}
			}
			latexBufferedWriter.write( "	\\\\ \\midrule" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( rowSPARQLEndpointValidation ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "    \\bottomrule" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "    \\end{tabular}" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "    \\caption{Evaluation of \\emph{" + sparqlEndpoint + "}}" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "    \\label{tab:evaluation-" + sparqlEndpointCleaned + "}" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "    \\end{center}" ); latexBufferedWriter.newLine();
			latexBufferedWriter.write( "\\end{table}" ); latexBufferedWriter.newLine(); latexBufferedWriter.newLine();
			
			// write latex ( data sets )
			for ( int t = 0; t < countTables; t++ ) { // for each table
				latexBufferedWriter.write( "\\begin{table}[H]" ); latexBufferedWriter.newLine();
				latexBufferedWriter.write( "    \\begin{center}" ); latexBufferedWriter.newLine();
				latexBufferedWriter.write( "    \\begin{tabular}{@{}l" );
				
				for ( int c = 0; c < constraints.length; c++ )
					latexBufferedWriter.write( "c" );
				latexBufferedWriter.write( "@{}}" ); latexBufferedWriter.newLine();
				latexBufferedWriter.write( "           & \\multicolumn{" + constraints.length + "}{c}{\\textbf{Constraints}}" ); latexBufferedWriter.newLine();
				latexBufferedWriter.write( "    \\\\  \\cmidrule{2-" + ( constraints.length + 1 ) + "}" ); latexBufferedWriter.newLine();
				
				latexBufferedWriter.write( "    \\\\       \\textbf{Data Sets}" ); latexBufferedWriter.newLine();
				for ( String constraint : constraints ) {
					if ( constraint.contains( "DATA-CUBE-C-" ) )
						constraint = StringUtils.replace( constraint, "DATA-CUBE-C-", "" );
					if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {
						latexBufferedWriter.write( "           & \\rot{\\emph{" + constraint + "}}" ); latexBufferedWriter.newLine();
					}
					else {
						latexBufferedWriter.write( "           & \\rot{\\emph{" + StringUtils.replace( constraint, " (not yet implemented!)", " (!)" ) + "}}" ); latexBufferedWriter.newLine();	}
				}
				latexBufferedWriter.write( "	\\\\ \\midrule" ); latexBufferedWriter.newLine();
				for ( String row : rowsPerTable.get( t ).split( "\\\\\\\\" ) ) {
					if ( row.length() != 0 )
						latexBufferedWriter.write( row + "\\\\" ); latexBufferedWriter.newLine();
				}
				latexBufferedWriter.write( "    \\bottomrule" ); latexBufferedWriter.newLine();
				latexBufferedWriter.write( "    \\end{tabular}" ); latexBufferedWriter.newLine();
				latexBufferedWriter.write( "    \\caption{Evaluation of \\emph{" + sparqlEndpoint + "}} Data Sets" ); latexBufferedWriter.newLine();
				latexBufferedWriter.write( "    \\label{tab:evaluation-" + t + "-" + sparqlEndpointCleaned + "}" ); latexBufferedWriter.newLine();
				latexBufferedWriter.write( "    \\end{center}" ); latexBufferedWriter.newLine();
				latexBufferedWriter.write( "\\end{table}" ); latexBufferedWriter.newLine(); latexBufferedWriter.newLine();
			}
			
			// close latex
			latexBufferedWriter.flush();
			latexBufferedWriter.close();
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
	}
	
}
