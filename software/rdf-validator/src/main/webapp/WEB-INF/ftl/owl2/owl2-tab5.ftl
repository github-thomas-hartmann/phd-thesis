<form id="form-owl2-tab5" action="<@spring.url '/owl2/tab5' />" style="padding-left: 25px" class="MISSY_round_right">

	<fieldset>
	
		<h3>Constraint Violations</h3> 
		<br/>

		<!--
		<#if dspValidationResult??>${dspValidationResult}<#else></#if>
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
		
	</fieldset>
	
	<hr/>
	<br/>
	
	<fieldset>
		
		<h3>Validation Input Parameter</h3> 
		<br/>
		
		<table>
			<th>Namespace Declarations</th>
		    <tr>
		        <td><pre><#if namespaceDeclarations??>${namespaceDeclarations}<#else>-</#if></pre></td>
		    </tr>
		</table>  
		
		<br/>
		
		<table>
			<th>Constraints</th>
		    <tr>
		        <td><pre><#if constraints??>${constraints}<#else>-</#if></pre></td>
		    </tr>
		</table>  
		
		<br/>
		
		<table>
			<th>Data</th>
		    <tr>
		        <td><pre><#if data??>${data}<#else>-</#if></pre></td>
		    </tr>
		</table>  
		
		<br/>
		
		<table>
			<th>Inference Rules</th>
		    <tr>
		        <td><pre><#if inferenceRules??>${inferenceRules}<#else>-</#if></pre></td>
		    </tr>
		</table>
		
		<br/> 

	</fieldset>
	
	<br />
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_owl2-tab5" 
		  id="button_owl2-tab5" 
		  value="Check Further Constraints" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px"
		  onclick="location.reload(); return false;">
	</fieldset>
	
</form>