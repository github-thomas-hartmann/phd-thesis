<form id="form-shex-tab5" action="<@spring.url '/shex/onegraph/tab5' />" style="padding-left: 25px" class="MISSY_round_right">

	<fieldset>
		<input 
		  type="button" 
		  name="button_shex-upload-validation" 
		  id="button_shex-upload-validation" 
		  value="Validate" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>
	
	<fieldset id="shex-validation-result">
		<#-- ajax content here -->
	</fieldset>

	
	<fieldset id="shex-validation-inputs">
		
		<h3>Input RDF Graphs</h3> 
		<br/>
		
		<!--
		<pre><#if rdfGraph??>${rdfGraph}<#else></#if></pre>
		-->
		<div>
		<#if fileInputGraphList??>
			
			<#list fileInputGraphList as fileInputGraph>
				<table class="datatable">
				    <tr>
				    	<td>file</td>
				        <td><#if fileInputGraph.filename??>${fileInputGraph.filename}<#else></#if></td>
				    </tr>
				</table>
				<table class="datatable">
				    <tr>
				    	<td>input graph</td>
				        <td><pre><#if fileInputGraph.inputGraph??>${fileInputGraph.inputGraph}<#else></#if></pre></td>
				    </tr>
				</table>
				<br/>
				<hr/>
				<br/>
			</#list> 
		  
		<#else>
		</#if>
		</div>

	</fieldset>
	
	
</form>