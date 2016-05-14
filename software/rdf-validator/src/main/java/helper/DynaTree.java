package helper;

import java.util.ArrayList;
import java.util.List;

public class DynaTree
{
	/*
	 * Constructor is needed because jackson JSON library uses constructor
	 * instead of setter
	 */
	public DynaTree()
	{
	}

	public DynaTree( final String title, final String key, final boolean isFolder, final List<DynaTree> children )
	{
		this.title = title;
		this.key = key;
		this.isFolder = isFolder;
		this.children = children;
	}

	public DynaTree( final String title, final String key, final boolean isFolder, final String url, final List<DynaTree> children )
	{
		this.title = title;
		this.key = key;
		this.isFolder = isFolder;
		this.url = url;
		this.children = children;
	}

	/* attributes */
	private String title;
	private String key;
	private boolean isFolder;
	private String url;
	private List<DynaTree> children = null;

	/* getters & setters */
	public String getTitle()
	{
		return title;
	}

	public void setTitle( final String title )
	{
		this.title = title;
	}

	public String getKey()
	{
		return key;
	}

	public void setKey( final String key )
	{
		this.key = key;
	}

	public boolean isisFolder()
	{
		return isFolder;
	}

	public void setisFolder( final boolean isFolder )
	{
		this.isFolder = isFolder;
	}

	public List<DynaTree> getChildren()
	{
		if ( this.children == null )
		{
			return new ArrayList<DynaTree>();
		}
		return this.children;
	}

	public void setChildren( final List<DynaTree> children )
	{
		this.children = children;
	}

	public DynaTree addChild( DynaTree childNode )
	{
		if ( this.children == null )
			this.children = new ArrayList<DynaTree>();
		this.children.add( childNode );
		return this;
	}

	public boolean isFolder()
	{
		return isFolder;
	}

	public void setFolder( boolean isFolder )
	{
		this.isFolder = isFolder;
	}

	public String getUrl()
	{
		return url;
	}

	public void setUrl( String url )
	{
		this.url = url;
	}
}
