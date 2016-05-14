package RDFValidation;

import java.io.File;
import java.io.IOException;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.config.RepositoryConfigException;
import org.openrdf.repository.http.HTTPRepository;
import org.openrdf.repository.manager.RepositoryProvider;
import org.openrdf.rio.RDFFormat;
import org.openrdf.rio.RDFParseException;

public class Sesame {

	public static void main(String[] args) {
		long startTime = 0; long endTime = 0; long duration = 0;
	    String serverUrl = "http://localhost:8081/openrdf-sesame";
	    String repositoryID ="missy"; 
	    try {
			RepositoryProvider.getRepositoryManager(serverUrl);
			Repository myRepository =new HTTPRepository(serverUrl,repositoryID);
		    myRepository.initialize();
		    RepositoryConnection conn = myRepository.getConnection();
		    
		    String path = "C:\\Daten\\Git\\rdf-validation\\data\\Disco\\resources-subset-latest\\";
		    File directory = new File(path);
		    File[] files = directory.listFiles();
		    for (File file: files) {
		    	String fileName = file.getAbsolutePath();
		    	
		    	System.out.println( "start uploading file '" + fileName );
		    	System.out.println( "-----" );
		    	startTime = System.nanoTime();
		    	
		    	conn.add(file, "file://" + fileName, RDFFormat.forFileName(fileName));
		    	
		    	endTime = System.nanoTime();
				duration = (endTime - startTime) / 1000000000;
				System.out.println( "duration: " + duration + " sec" );
				System.out.println();
		    }
		    conn.close();
		} catch ( Exception e ) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	    finally {
	    	
	    }
	}

}
