package helper;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;

//ignore "bytes" when return json format
@JsonIgnoreProperties( { "bytes" } )
public class FileMeta
{
	private String fileName;
	private String fileSize;
	private String fileType;
	/* for text file */
	private String fileContent = "";

	/* for binary file */
	private byte[] bytes = null;

	// setters & getters
	public String getFileName()
	{
		return fileName;
	}

	public void setFileName( String fileName )
	{
		this.fileName = fileName;
	}

	public String getFileSize()
	{
		return fileSize;
	}

	public void setFileSize( String fileSize )
	{
		this.fileSize = fileSize;
	}

	public String getFileType()
	{
		return fileType;
	}

	public void setFileType( String fileType )
	{
		this.fileType = fileType;
	}

	public byte[] getBytes()
	{
		return bytes;
	}

	public void setBytes( byte[] bytes )
	{
		this.bytes = bytes;
	}

	public String getFileContent()
	{
		return fileContent;
	}

	public void setFileContent( String fileContent )
	{
		this.fileContent = fileContent;
	}
}
