package RDFValidation;

import java.util.List;

public class ConstraintViolation 
{
	String source = null;
	String root = null;
	String message = null;
	List<String> paths = null;
	List<String> fixes = null;
//	enum SeverityLevel {INFO, OPTIONAL, RECOMMENDED, MAY, SHOULD, MUST, WARNING, ERROR, FATALERROR};
	String severityLevel = null;
	
	public String getSeverityLevel() {
		return severityLevel;
	}
	public void setSeverityLevel(String severityLevel) {
		this.severityLevel = severityLevel;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getRoot() {
		return root;
	}
	public void setRoot(String root) {
		this.root = root;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public List<String> getPaths() {
		return paths;
	}
	public void setPaths(List<String> paths) {
		this.paths = paths;
	}
	public List<String> getFixes() {
		return fixes;
	}
	public void setFixes(List<String> fixes) {
		this.fixes = fixes;
	}
}
