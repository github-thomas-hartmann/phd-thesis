package RDFValidation;

public class ConstraintViolationPerConstraint {
	private String violationMessage;
	private String violationSource;
	private String severityLevel;
	public String getViolationMessage() {
		return violationMessage;
	}
	public void setViolationMessage(String violationMessage) {
		this.violationMessage = violationMessage;
	}
	public String getViolationSource() {
		return violationSource;
	}
	public void setViolationSource(String violationSource) {
		this.violationSource = violationSource;
	}
	public String getSeverityLevel() {
		return severityLevel;
	}
	public void setSeverityLevel(String severityLevel) {
		this.severityLevel = severityLevel;
	}
}
