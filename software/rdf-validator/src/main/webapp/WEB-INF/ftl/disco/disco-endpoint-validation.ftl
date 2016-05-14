<#if validationException??>

	<h3>Validation Error</h3> 
	
		<br/>
	
		<table class="datatable">
				<tr>
					<td><b>source</b></td>
					<td>${validationException.getSource()}</td>
				</tr>
				<#if validationException.message??>
				<tr>
					<td><b>message</b></td>
					<td>${validationException.getMessage()}</td>
				</tr>
				<#else></#if>
				<#if validationException.cause??>
				<tr>
					<td><b>cause</b></td>
					<td>${validationException.cause}</td>
				</tr>
				<#else></#if>
				<#if validationException.stackTrace??>
				<tr>
					<td><b>cause</b></td>
					<td>${validationException.stackTrace}</td>
				</tr>
				<#else></#if>
	  	    	<tr><td><br/></td><td><br/></td></tr>
		</table>
		
	<hr/>
	<br/>

<#else>

<h3>Validation Parameter</h3>
    <hr/>
	<ul style="margin-top:0px; margin-left: 0; vertical-align:top;">
		<li><div title="${(constraintDescriptions['${constraint}'])!''}"><b>constraint:</b> ${constraint}</div></li>
		<li><b>SPARQL endpoint:</b> ${sparqlEndpoint}</li>
		<li><b>limit:</b> ${limit}</li>
	</ul>
	<hr/>

<h3>Constraint Violations Summary</h3>
<hr/>
<#if constraintViolationList??>
<b>constraint violations: ${constraintViolationList?size}</b>
(
<span style="color:blue"><b>informations: <#if countInformations??>${countInformations}</#if></b></span> | 
<span style="color:orange"><b>warnings: <#if countWarnings??>${countWarnings}</#if></b></span> | 
<span style="color:red"><b>errors: <#if countErrors??>${countErrors}</#if></b></span> )
<br/>
</#if> 

<#if (constraintViolationList?size > 0) >

<hr/>

<h3>Constraint Violations</h3> 
	<hr/>
	<br/>

	<!--
	<#if discoValidationResult??>${discoValidationResult}<#else></#if>
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
					<td><#if constraintViolation.message??>${constraintViolation.message}<#else></#if></td>
				</tr>
				<tr>
					<td><b>source</b></td>
					<td><#if constraintViolation.source??>${constraintViolation.source}<#else></#if></td>
				</tr>
				<#if constraintViolation.paths?? && (constraintViolation.paths?size > 0)>
				<#list constraintViolation.paths as constraintViolationPath>
					<#if (constraintViolationPath?length > 0)>
					<tr>
						<td><b>path</b></td>
						<td>${constraintViolationPath}</td>
					</tr>
					</#if>  
	  	    	</#list>
	  	    	</#if>  
	  	    	<#if constraintViolation.fixes?? && (constraintViolation.fixes?size > 0)>
	  	    	<#list constraintViolation.fixes as constraintViolationFix>
	  	    		<#if (constraintViolationFix?length > 0)>
					<tr>
						<td><b>fix</b></td>
						<td>${constraintViolationFix}</td>
					</tr>
					</#if>  
	  	    	</#list>
	  	    	</#if>  
	  	    	<#if constraintViolation.severityLevel??>
	  	    	<#if constraintViolation.severityLevel == 'INFO'>
					<tr>
						<td><span style="color:blue"><b>severity</b></span></td>
						<td><span style="color:blue">${constraintViolation.severityLevel}</span></td>
					</tr>
				</#if>  
	  	    	<#if constraintViolation.severityLevel == 'WARNING'>
					<tr>
						<td><span style="color:orange"><b>severity</b></span></td>
						<td><span style="color:orange">${constraintViolation.severityLevel}</span></td>
					</tr>
				</#if>  
				<#if constraintViolation.severityLevel == 'ERROR'>
					<tr>
						<td><span style="color:red"><b>severity</b></span></td>
						<td><span style="color:red">${constraintViolation.severityLevel}</span></td>
					</tr>
				</#if>  
	  	    	<#else>
	  	    	</#if>
	  	    	<tr><td><br/></td><td><br/></td></tr>
	    	</#list>
		</table>
	  
	<#else>
	</#if>
	
<hr/>
<br/>

<#else>
<br/>
<h1 style="margin-left: 20px; color:green">The data is valid!</h1>


</#if>

</#if>