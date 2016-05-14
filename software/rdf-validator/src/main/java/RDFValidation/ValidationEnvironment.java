package RDFValidation;

public class ValidationEnvironment 
{
	public String namespaceDeclarations = null;
	public String constraints = null;
	public String data = null;
	public String inferenceRules = null;
	
	public String getConstraints() {
		return constraints;
	}
	public void setConstraints(String constraints) {
		this.constraints = constraints;
	}
	public String getData() {
		return data;
	}
	public void setData(String data) {
		this.data = data;
	}
	public String getNamespaceDeclarations() {
		return namespaceDeclarations;
	}
	public void setNamespaceDeclarations(String namespaceDeclarations) {
		this.namespaceDeclarations = namespaceDeclarations;
	}
	public String getInferenceRules() {
		return inferenceRules;
	}
	public void setInferenceRules(String inferenceRules) {
		this.inferenceRules = inferenceRules;
	}
}