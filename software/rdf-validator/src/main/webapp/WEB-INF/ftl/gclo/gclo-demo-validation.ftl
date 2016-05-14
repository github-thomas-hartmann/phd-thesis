<#if spinException??>

	<h3>Validation Error</h3> 
	
		<br/>
	
		<table class="datatable">
				<tr>
					<td><b>source</b></td>
					<td>${spinException.getSource()}</td>
				</tr>
				<tr>
					<td><b>message</b></td>
					<td>${spinException.getMessage()}</td>
				</tr>
	  	    	<tr><td><br/></td><td><br/></td></tr>
		</table>
		
	<hr/>
	<br/>

<#else>
</#if>

<h3>Constraint Violations</h3> 
	<br/>

	<!--
	<#if gcloValidationResult??>${gcloValidationResult}<#else></#if>
	-->
	
	<!-- debugging -->
	<!--
	<#if debugging??>${debugging}<#else></#if>
	-->

	<#if constraintViolationList??>
	  
		<table class="datatable">
			<#list constraintViolationList as constraintViolation>
				<tr>
					<td><b>root</b></td>
					<td><#if constraintViolation.root??>${constraintViolation.root}<#else></#if></td>
				</tr>
				<tr>
					<td><b>message</b></td>
					<td>${constraintViolation.message}</td>
				</tr>
				<tr>
					<td><b>source</b></td>
					<td>${constraintViolation.source}</td>
				</tr>
				<#list constraintViolation.paths as constraintViolationPath>
					<tr>
						<td><b>path</b></td>
						<td>${constraintViolationPath}</td>
					</tr>
	  	    	</#list>
	  	    	<#list constraintViolation.fixes as constraintViolationFix>
					<tr>
						<td><b>fix</b></td>
						<td>${constraintViolationFix}</td>
					</tr>
	  	    	</#list>
	  	    	<tr><td><br/></td><td><br/></td></tr>
	    	</#list>
		</table>
	  
	<#else>
	</#if>
	
<!-- inferred RDF graph -->
<#if rdfGraphInferred??>

	<hr/>
	<br/>
	
	<fieldset>
		
		<h3>Inferred RDF Graph</h3> 
		<br/>
		
		<pre id="rdfGraphInferredPre"><#if rdfGraphInferred??>${rdfGraphInferred}<#else></#if></pre>
		
		<br/>
	
	</fieldset>

	<br/>

<#else>
</#if>
	
<hr/>
<br/>