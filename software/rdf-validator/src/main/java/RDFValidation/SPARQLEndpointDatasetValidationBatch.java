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

public class SPARQLEndpointDatasetValidationBatch {
	private String absolutePathConstraints = null;
	private String[] sparqlEndpoints = null;
	private String[] constraints = null;
	private String limit;
	
	// constraints on data sets
	private List<String> constraintsOnDataSets = null;
	
	public SPARQLEndpointDatasetValidationBatch( 
		String absolutePathConstraints, 
		String[] sparqlEndpoints, 
		String[] constraints,
		String limit ) {
		this.absolutePathConstraints = absolutePathConstraints;
		this.sparqlEndpoints = sparqlEndpoints;
		this.constraints = constraints;
		this.limit = limit;
		
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
	}

	public void validate() {
		List<String> dataSets = null;
		long startTime = 0; long endTime = 0; long duration = 0;
		long startTimeSPARQLEndpointValidation = 0; long endTimeSPARQLEndpointValidation = 0; long durationSPARQLEndpointValidation = 0;
		
		// default namespace declarations
		String defaultNamespaceDeclarations = getQueryString( "default-namespace-declarations" );

		// for each SPARQL endpoint
		for ( String sparqlEndpoint : sparqlEndpoints ) { 
			
			// SPARQL endpoint selected
			if ( ! sparqlEndpoint.equals( "" ) ) {
				
				// start time ( SPARQL endpoint validation )
				startTimeSPARQLEndpointValidation = System.nanoTime();
				
				if ( sparqlEndpoint.contains( "http" ) && ! sparqlEndpoint.startsWith( "http" ) ) 
					sparqlEndpoint = sparqlEndpoint.substring( sparqlEndpoint.indexOf( "http" ), sparqlEndpoint.length() -1 );
				
				// data sets ( of SPARQL endpoint )
				dataSets = getDataSets( defaultNamespaceDeclarations, sparqlEndpoint );
				for ( String dataSet : dataSets )
					System.out.println(dataSet);
				
				// constraint validation
				String constraintValidation = "";
			
				// constraint on individual data sets of SPARQL Endpoint
				if ( dataSets.size() > 0 ) {
					
					// constraint validation per data set and constraint
					Hashtable<String,String> validationPerDataSetAndConstraint = new Hashtable<String,String>();
					String dataSetConstraint = "";
					
					// for each data set ( of SPARQL Endpoint )
					for ( String dataSet : dataSets ) {
						
						// testing
						System.out.println();
						
						// for each constraint
						for ( String constraint : constraints ) {
							
							// constraint implemented
							if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {
								
								// constraint on data set
								if ( constraintsOnDataSets.contains( constraint ) ) {
									
									// testing
									startTime = System.nanoTime();
							
									// query string
									String queryString = new StringBuilder( 
										defaultNamespaceDeclarations )
										.append( "SELECT ( COUNT ( ?subject ) AS ?count )" ).append( "\r\n" ) 
										.append( "WHERE {" ).append( "\r\n" ) 
										.append( StringUtils.replace( getQueryString ( constraint + "_DataSet" ), "?dataSet", "<" + dataSet + ">" ) )
										.append( "}" )	
										.toString();
									
									// testing
									System.out.println( "endpoint: " + sparqlEndpoint );
									System.out.println( "data set: " + dataSet );
									System.out.println( "constraint: " + constraint );
									System.out.println( "-----" );
									System.out.println( StringUtils.replace( getQueryString ( constraint + "_DataSet" ), "?dataSet", "<" + dataSet + ">" ) );
									
									try {
										Query query = QueryFactory.create( queryString ) ;
										QueryExecution qexec = QueryExecutionFactory.sparqlService( sparqlEndpoint, query );
										qexec.setTimeout( 600000 ); // 10 min
									    ResultSet results = qexec.execSelect() ;
									    
									    for ( ; results.hasNext() ; ) {
									    	QuerySolution querySolution = results.nextSolution() ;  
										    
										    // count
										    RDFNode count = querySolution.get( "count" ) ;
										    if ( count != null && count.isLiteral() ) {
										    	
										    	// testing
												endTime = System.nanoTime();
												duration = (endTime - startTime) / 1000000000;
												System.out.println( "-----" );
												System.out.println( "count: " + Integer.parseInt( ( ( Literal ) count ).getLexicalForm() ) + " | duration: " + duration );
												System.out.println();
												
												// constraint validation ( count ) 
												constraintValidation = ( ( Literal ) count ).getLexicalForm();
										    }
									    }
									}
									catch (Exception e) {
										
										// testing
										endTime = System.nanoTime();
										duration = (endTime - startTime) / 1000000000;
										System.out.println( "ERROR ( " + duration + " sec )" );
										
										// constraint validation ( error )
										constraintValidation = "";
									}
									
									// constraint validation per data set and constraint
									dataSetConstraint = dataSet + "_" + constraint;
									validationPerDataSetAndConstraint.put( dataSetConstraint, constraintValidation );
								}
							}
						}
					}
					
					// constraints on whole SPARQL endpoint
					Hashtable<String,String> validationPerConstraint = new Hashtable<String,String>(); // constraint validations per constraint
					for ( String constraint : constraints ) {
						if ( ! constraintsOnDataSets.contains( constraint ) ) {	
							
							// constraint implemented
							if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {
								
								// query string
								String queryString = new StringBuilder( 
									defaultNamespaceDeclarations ).append( "\r\n" ) 
									.append( "SELECT ( COUNT ( ?subject ) AS ?count )" ).append( "\r\n" ) 
									.append( "WHERE {" ).append( "\r\n" )
									.append( getQueryString( constraint ) ).append( "\r\n" )
									.append( "}" )
									.toString();
								
								// testing
								startTime = System.nanoTime();
								System.out.println();
								System.out.println( "endpoint: " + sparqlEndpoint );
								System.out.println( "constraint: " + constraint );
								System.out.println( "-----" );
								System.out.println( getQueryString( constraint ) );
								
								try {
									Query query = QueryFactory.create( queryString ) ;
									QueryExecution qexec = QueryExecutionFactory.sparqlService( sparqlEndpoint, query );
									qexec.setTimeout( 600000 ); // 10 min
								    ResultSet results = qexec.execSelect() ;
								    
								    for ( ; results.hasNext() ; ) {
								    	QuerySolution querySolution = results.nextSolution() ;  
									    
									    // count
									    RDFNode count = querySolution.get( "count" ) ;
									    if ( count != null && count.isLiteral() ) {
									    	
									    	// testing
											endTime = System.nanoTime();
											duration = (endTime - startTime) / 1000000000;
											System.out.println( "-----" );
											System.out.println( "count: " + Integer.parseInt( ( ( Literal ) count ).getLexicalForm() ) + " | duration: " + duration );
											System.out.println();
											
											// constraint validation ( count ) 
											constraintValidation = ( ( Literal ) count ).getLexicalForm();
											
									    }
								    }
								}
								catch (Exception e) {
									
									// testing
									endTime = System.nanoTime();
									duration = (endTime - startTime) / 1000000000;
									System.out.println( "ERROR ( " + duration + " sec )" );
									
									// constraint validation ( error )
									constraintValidation = "";
								}
								// constraint validation per constraint
								validationPerConstraint.put( constraint, constraintValidation );
							}
						}
					}
					
					// generate latex ( data sets )
					generateLatexDataSets( sparqlEndpoint, dataSets, constraints, validationPerDataSetAndConstraint, validationPerConstraint, ( short ) 17 );
				}
				
				// constraint on whole SPARQL Endpoint
				else {
					
					// constraint validations per constraint
					Hashtable<String,String> validationPerConstraint = new Hashtable<String,String>();
					
					// for each constraint
					for ( String constraint : constraints ) {
						
						// constraint implemented
						if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {
							
							// query string
							String queryString = new StringBuilder( 
								defaultNamespaceDeclarations ).append( "\r\n" ) 
								.append( "SELECT ( COUNT ( ?subject ) AS ?count )" ).append( "\r\n" ) 
								.append( "WHERE {" ).append( "\r\n" )
								.append( getQueryString( constraint ) ).append( "\r\n" )
								.append( "}" )
								.toString();
							
							// testing
							startTime = System.nanoTime();
							System.out.println();
							System.out.println( "endpoint: " + sparqlEndpoint );
							System.out.println( "constraint: " + constraint );
							System.out.println( "-----" );
							System.out.println( getQueryString( constraint ) );
							
							try {
								Query query = QueryFactory.create( queryString ) ;
								QueryExecution qexec = QueryExecutionFactory.sparqlService( sparqlEndpoint, query );
								qexec.setTimeout( 600000 ); // 10 min
							    ResultSet results = qexec.execSelect() ;
							    
							    for ( ; results.hasNext() ; ) {
							    	QuerySolution querySolution = results.nextSolution() ;  
								    
								    // count
								    RDFNode count = querySolution.get( "count" ) ;
								    if ( count != null && count.isLiteral() ) {
								    	
								    	// testing
										endTime = System.nanoTime();
										duration = (endTime - startTime) / 1000000000;
										System.out.println( "-----" );
										System.out.println( "count: " + Integer.parseInt( ( ( Literal ) count ).getLexicalForm() ) + " | duration: " + duration );
										System.out.println();
										
										// constraint validation ( count ) 
										constraintValidation = ( ( Literal ) count ).getLexicalForm();
										
								    }
							    }
							}
							catch (Exception e) {
								
								// testing
								endTime = System.nanoTime();
								duration = (endTime - startTime) / 1000000000;
								System.out.println( "ERROR ( " + duration + " sec )" );
								
								// constraint validation ( error )
								constraintValidation = "";
							}
							// constraint validation per constraint
							validationPerConstraint.put( constraint, constraintValidation );
						}
					}
					// generate latex ( data sets )
					generateLatexSPARQLEndpoint( sparqlEndpoint, dataSets, constraints, validationPerConstraint, ( short ) 17 );
				}
				// duration ( SPARQL endpoint validation )
				endTimeSPARQLEndpointValidation = System.nanoTime();
				durationSPARQLEndpointValidation = (endTimeSPARQLEndpointValidation - startTimeSPARQLEndpointValidation) / 1000000000;
				System.out.println();
				System.out.println( "duration ( SPARQL endpoint validation ): " + durationSPARQLEndpointValidation + " sec" );
				System.out.println();
			}	
		}
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
 
		} 
		catch (IOException e) {} 
		finally {
			try {
				if (br != null)br.close();
			} 
			catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		
		return queryStringBuffer.toString();
	}
	
	private void generateLatexDataSets( 
		String sparqlEndpoint, List<String> dataSets, String[] constraints, 
		Hashtable<String,String> validationPerDataSetAndConstraint, Hashtable<String,String> validationPerConstraint, short maxCountRowsPerTable ) {
		try {
			String dataSetConstraint = "";
			
			// count tables
			int countTables = 0;
			if ( dataSets.size() < maxCountRowsPerTable )
				maxCountRowsPerTable = ( short ) dataSets.size();
			countTables = dataSets.size() / maxCountRowsPerTable;
			
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
				validationErrors = 0;
				
				// constraint on data set
				if ( constraintsOnDataSets.contains( constraints[c] ) ) {	
					
					// constraint not implemented
					if ( constraints[c].endsWith( "(not yet implemented!)" ) ) {
						rowSPARQLEndpointValidation += " & -";
					}
					
					// constraint implemented
					else {
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
						
						// validation errors for each data set for given constraint
						if ( validationErrors != dataSets.size() ) {
							// data set is valid according to constraint
							if ( constraintValidation == 0 )
								rowSPARQLEndpointValidation += " & $\\checkmark$";
							else
								rowSPARQLEndpointValidation += " & " + constraintValidation;
							
							// validation errors
							if ( validationErrors > 0 )
								rowSPARQLEndpointValidation += " (" + validationErrors + ")";
						}
						else {
							rowSPARQLEndpointValidation += " & \\ding{55}";
						}
					}
				}
				
				// constraint on whole SPARQL endpoint
				else {
					// constraint implemented
					if ( ! constraints[c].contains( "not yet implemented" ) ) {
						if ( validationPerConstraint.get( constraints[c] ) != null ) {
							
							// validation error
							if ( StringUtils.equals( validationPerConstraint.get( constraints[c] ), "" ) )
								validationErrors++;	
							
							// NO constraint violation 
							else if ( ( ! StringUtils.equals( validationPerConstraint.get( constraints[c] ), "0" ) ) )
								constraintValidation += Integer.valueOf( validationPerConstraint.get( constraints[c] ) );
						}
						
						// validation errors
						if ( validationErrors > 0 )
							rowSPARQLEndpointValidation += " & \\ding{55}";
						// NO validation errors
						else {
							// data is valid according to constraint
							if ( constraintValidation == 0 )
								rowSPARQLEndpointValidation += " & $\\checkmark$";
							else
								rowSPARQLEndpointValidation += " & " + constraintValidation;
						}
					}
					
					// constraint not implemented
					else {
						rowSPARQLEndpointValidation += " & -";
					}
				}
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
			
			// latex ( data sets )
			short countConstraintsOnDataSets = 0; // count ( constraints on data sets )
			for ( int c = 0; c < constraints.length; c++ ) {
				if ( constraintsOnDataSets.contains( constraints[c] ) )
					countConstraintsOnDataSets++;
			}
			if ( countConstraintsOnDataSets > 0 ) {
				
				// rows per table ( data sets )
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
							
							// constraint on data set
							if ( constraintsOnDataSets.contains( constraints[c] ) ) {	
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
							
							// constraint on SPARQL endpoint
							else {
								
							}
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
							
							// constraint on data set
							if ( constraintsOnDataSets.contains( constraints[c] ) ) {	
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
							
							// constraint on SPARQL endpoint
							else {
								
							}
						}
					}
				}
				
				// testing
				for ( int t = 0; t < countTables; t++ ) { 
					for ( String row : rowsPerTable.get( t ).split( "\\\\\\\\" ) )
						if ( row.length() != 0 )
							System.out.println ( "table " + t + ": " + row );
				}
				
				// write latex ( data sets )
				short countConstraintsOnDataSet = 0;
				for ( String constraint : constraints )
					if ( constraintsOnDataSets.contains( constraint ) )
						countConstraintsOnDataSet++;
				for ( int t = 0; t < countTables; t++ ) { // for each table
					latexBufferedWriter.write( "\\begin{table}[H]" ); latexBufferedWriter.newLine();
					latexBufferedWriter.write( "    \\begin{center}" ); latexBufferedWriter.newLine();
					latexBufferedWriter.write( "    \\begin{tabular}{@{}l" );
					
					for ( int c = 0; c < countConstraintsOnDataSet; c++ )
						latexBufferedWriter.write( "c" );
					latexBufferedWriter.write( "@{}}" ); latexBufferedWriter.newLine();
					latexBufferedWriter.write( "           & \\multicolumn{" + countConstraintsOnDataSet + "}{c}{\\textbf{Constraints}}" ); latexBufferedWriter.newLine();
					latexBufferedWriter.write( "    \\\\  \\cmidrule{2-" + ( countConstraintsOnDataSet + 1 ) + "}" ); latexBufferedWriter.newLine();
					
					latexBufferedWriter.write( "    \\\\       \\textbf{Data Sets}" ); latexBufferedWriter.newLine();
					for ( String constraint : constraints ) {
						
						// constraint on data set
						if ( constraintsOnDataSets.contains( constraint ) ) {
							// constraint implemented
							if ( ! constraint.endsWith( "(not yet implemented!)" ) ) {
								if ( constraint.contains( "DATA-CUBE-C-" ) )
									constraint = StringUtils.replace( constraint, "DATA-CUBE-C-", "" );
								latexBufferedWriter.write( "           & \\rot{\\emph{" + constraint + "}}" ); latexBufferedWriter.newLine();
							}
							// constraint not implemented
							else {
								if ( constraint.contains( "DATA-CUBE-C-" ) )
									constraint = StringUtils.replace( constraint, "DATA-CUBE-C-", "" );
								latexBufferedWriter.write( "           & \\rot{\\emph{" + StringUtils.replace( constraint, " (not yet implemented!)", " (!)" ) + "}}" ); latexBufferedWriter.newLine();	}
							}
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
			}
			
			// close latex
			latexBufferedWriter.flush();
			latexBufferedWriter.close();
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void generateLatexSPARQLEndpoint( String sparqlEndpoint, List<String> dataSets, String[] constraints, Hashtable<String,String> validationPerConstraint, short maxCountRowsPerTable ) {
		try {
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
				validationErrors = 0;
			
				// constraint implemented
				if ( ! constraints[c].contains( "not yet implemented" ) ) {
					if ( validationPerConstraint.get( constraints[c] ) != null ) {
						
						// validation error
						if ( StringUtils.equals( validationPerConstraint.get( constraints[c] ), "" ) )
							validationErrors++;	
						
						// NO constraint violation 
						else if ( ( ! StringUtils.equals( validationPerConstraint.get( constraints[c] ), "0" ) ) )
							constraintValidation += Integer.valueOf( validationPerConstraint.get( constraints[c] ) );
					}
					
					// data is valid according to constraint
					if ( constraintValidation == 0 )
						rowSPARQLEndpointValidation += " & $\\checkmark$";
					else
						rowSPARQLEndpointValidation += " & " + constraintValidation;
					
					// validation errors
					if ( validationErrors > 0 )
						rowSPARQLEndpointValidation += " (" + validationErrors + ")";
				}
				
				// constraint not implemented
				else {
					rowSPARQLEndpointValidation += " & -";
				}
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
			latexBufferedWriter.write( "\\end{table}" ); 
			
			// close latex
			latexBufferedWriter.flush();
			latexBufferedWriter.close();
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
	}
	
}
