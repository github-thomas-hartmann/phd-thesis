<form id="form-owl2-demo-tab4" action="<@spring.url '/owl2/demo/tab4' />" style="padding-left: 25px" class="MISSY_round_right">

	<fieldset>
		<input 
		  type="button" 
		  name="button_owl2-demo-validation" 
		  id="button_owl2-demo-validation" 
		  value="Validate" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>
	

	<fieldset id="owl2-validation-result">
		<#-- ajax content here -->
	</fieldset>
	
	
	
	<fieldset>
		
		<h3>Input RDF Graphs</h3> 
		<br/>
		
		<table>
			<th>Namespace Declarations</th>
		    <tr>
		        <td><pre id="namespaceDeclarationsPre"><#if namespaceDeclarations??>${namespaceDeclarations}<#else></#if></pre></td>
		    </tr>
		</table>  
		
		<br/>
		
		<table>
			<th>Constraints</th>
		    <tr>
		        <td><pre id="constraintsPre"><#if constraints??>${constraints}<#else></#if></pre></td>
		    </tr>
		</table>  
		
		<br/>
		
		<table>
			<th>Data</th>
		    <tr>
		        <td><pre id="dataPre"><#if data??>${data}<#else></#if></pre></td>
		    </tr>
		</table>  
		
		<br/>
		
		<table>
			<th>Inference Rules</th>
		    <tr>
		        <td><pre id="inferenceRulesPre"><#if inferenceRules??>${inferenceRules}<#else></#if></pre></td>
		    </tr>
		</table>
		
		<br/> 

	</fieldset>
	
</form>