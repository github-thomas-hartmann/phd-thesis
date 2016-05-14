<form id="form-dsp-tab3" action="<@spring.url '/dsp/exmpgraph/tab3' />" style="padding-left: 25px" class="MISSY_round_right" >	

	<fieldset>
	
		<h3>Constraint Violations</h3> 
		<br/>

		<!--
		<#if dspValidationResult??>${dspValidationResult}<#else></#if>
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
		
	</fieldset>
	
	<hr/>
	<br/>
	
	<fieldset>
		
		<h3>Input RDF Graph</h3> 
		<br/>
		
		<pre><#if rdfGraph??>${rdfGraph}<#else></#if></pre>

	</fieldset>
	
	<br />
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_dsp-tab3" 
		  id="button_dsp-tab3" 
		  value="Check Further Constraints" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px"
		  onclick="location.reload(); return false;">
	</fieldset>

</form>