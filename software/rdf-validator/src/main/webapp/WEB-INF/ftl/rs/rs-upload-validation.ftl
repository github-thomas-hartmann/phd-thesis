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
	<#if rsValidationResult??>${rsValidationResult}<#else></#if>
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
					<td>${constraintViolation.root}</td>
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
	
<hr/>
<br/>