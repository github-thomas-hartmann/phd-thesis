<form id="form-disco-tab1" action="<@spring.url '/disco/onegraph/tab1' />" style="padding-left: 25px" class="MISSY_round_right">
	
	<script>
		$jQ( function(){
			$jQ( "#accordiondiscoTab1" ).accordion({
				collapsible:true,
				active: false,
				heightStyle:"content"
			});
		});
	</script>
	<fieldset>
	
		<div id="accordiondiscoTab1">
			<div id="accordion_head1" style="border: 1pt solid #aca690;">
				<h3 style="width:180px;float:left">
					Please select constraint
				</h3>
				
				 <#-- form onsite help -->
				<a href="#" class="MISSY_onsiteHelp" style="margin-top:0px; margin-left: 0; vertical-align:top; padding:0 !important">
					<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
					<span style="width:310px;">
						<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
						<h4 class="MISSY_onsiteHelp">Constraint</h4>
						<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
					    <ul style="margin: 0;">
					    	<li style="list-style-type: disc;">...</li>
					    </ul>
					</span>
				</a>
			</div>
			<div id="accordion_content1" style="border: 1pt solid #aca690;">
			
				<!--
				 <#if constraints??>
					<fieldset>
						<div class="checkbox_radio_block">
						    <#list constraints as constraint>
						  	<input type="checkbox" name="constraints[]" id="constraint_${constraint}" style="margin-left: 20px;" value="${constraint}"/>
						  	<label for="constraint_${constraint}">${constraint}</label><br />
						  	</#list>
						</div>
					</fieldset><br /><br />
				</#if>
				-->
				
				<#if constraintsByConstraintType??>
			    	<select id="constraint" name="constraint" style="margin-left: 20px; width:550px; max-width: 1000px">
					    <#list constraintsByConstraintType?keys as key>
					    	<optgroup label="${key}">
					    		<#list 0..constraintsByConstraintType[key]?size as i>
									<#if constraintsByConstraintType[key][i]??>
										<option value ="${constraintsByConstraintType[key][i]}">
											${constraintsByConstraintType[key][i]}</option>
									</#if>
								</#list>
						    </optgroup>
					    </#list>
					</select>
			    </#if>
				
			</div>
			
			<div id="accordion_head2" style="border: 1pt solid #aca690;">
				<h3 style="width:290px;float:left">
					Please select or enter SPARQL endpoint
				</h3>
				
				 <#-- form onsite help -->
				<a href="#" class="MISSY_onsiteHelp" style="margin-top:0px; margin-left: 0; vertical-align:top; padding:0 !important">
					<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
					<span style="width:310px;">
						<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
						<h4 class="MISSY_onsiteHelp">SPARQL endpoint</h4>
						<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
					    <ul style="margin: 0;">
					    	<li style="list-style-type: disc;">...</li>
					    </ul>
					</span>
				</a>
			</div>
			<div id="accordion_content2" style="border: 1pt solid #aca690;">
			
				<#if sparqlEndpoints??>
					<input id="sparqlEndpoint" name="sparqlEndpoint" list="sparqlEndpointsList" required="true" type="text" style="margin-left: 20px;"> 
				  	<datalist id="sparqlEndpointsList"> 
					  	<#list sparqlEndpoints as sparqlEndpoint>	  	
							<option label="${sparqlEndpoint}" value="${sparqlEndpoint}"></option> 
					  	</#list>
				  	</datalist>
				</#if>
			
				<!--
				<#if sparqlEndpoints??>
				    <select name="sparqlEndpoints" multiple style="margin-left: 20px; height:60px; max-height:1000px; width:550px; max-width: 1000px">
				    	<#list sparqlEndpoints as sparqlEndpoint>
					    <option name="sparqlEndpoints[]" id="sparqlEndpoint_${sparqlEndpoint}" value="${sparqlEndpoint}">${sparqlEndpoint}</option>
					    </#list>
					</select>
				</#if>
				-->
			    
			    <!--
			    <#if sparqlEndpoints??>
					<fieldset>
						<div class="checkbox_radio_block">
						    <#list sparqlEndpoints as sparqlEndpoint>
						  	<input type="checkbox" name="sparqlEndpoints[]" id="sparqlEndpoint_${sparqlEndpoint}" style="margin-left: 20px;" value="${sparqlEndpoint}"/>
						  	<label for="sparqlEndpoint_${sparqlEndpoint}">${sparqlEndpoint}</label><br />
						  	</#list>
						</div>
					</fieldset><br /><br />
				</#if>
				-->
				
				<!--
				<#if sparqlEndpoints??>
					<input id="sparqlEndpoint" name="sparqlEndpoint" list="sparqlEndpointsList" required="true" type="text" style="margin-left: 20px; width:550px; max-width: 1000px"> 
				  	<datalist id="sparqlEndpointsList"> 
					  	<#list sparqlEndpoints as sparqlEndpoint>	  	
							<option label="${sparqlEndpoint}" value="${sparqlEndpoint}"></option> 
					  	</#list>
				  	</datalist>
				</#if>
				-->
				
			</div>
			
			<div id="accordion_head3" style="border: 1pt solid #aca690;">
				<h3 style="width:240px;float:left">
					Limit number of results [optional]
				</h3>
				<a href="#" class="MISSY_onsiteHelp" style="margin-top:0px; margin-left: 0; vertical-align:top; padding:0 !important">
					<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
					<span style="width:310px;">
						<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
						<h4 class="MISSY_onsiteHelp">SPARQL endpoint</h4>
						<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
					    <ul style="margin: 0;">
					    	<li style="list-style-type: disc;">The limitation may increase performance.</li>
					    	<li style="list-style-type: disc;">Leave the input field empty to indicate no limitation.</li>
					    </ul>
					</span>
				</a>
			</div>
			<div id="accordion_content3" style="border: 1pt solid #aca690;">
				<input type="number" id="limit" name="limit" min="1" step="1" value="-" style="margin-left: 20px; width: 80px;">
			</div>
		</div>
	
		<br/>
		The SPARQL endpoint validation can be executed in <b>batch mode</b>, if the RDF Validator is installed as stand-alone application.
	
		<input type="hidden" name="constraintDescriptions" id="constraintDescriptions" />
	
	</fieldset>
	
</form>