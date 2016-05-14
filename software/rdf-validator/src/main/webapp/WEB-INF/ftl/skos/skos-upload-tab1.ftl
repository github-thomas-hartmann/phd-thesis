<form id="form-skos-tab1" action="<@spring.url '/skos/onegraph/tab1' />" style="padding-left: 25px" class="MISSY_round_right">
	
	<fieldset>
	
	<h3>Constraints</h3>
	<p style="margin-left: 0;">
		Please select the constraints to validate against
	</p>
	<hr />
	
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
	
		<!--
		<table>
	        <tr style="background:transparent">
	            <td style="width:50%">
	            	<input id="fileupload" style="width:100%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/skos/upload' />" multiple />
				</td>
	            <td>
	            	<div id="progress" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>
	    -->
	    
	    <h3>Upload File</h3>
		<hr />
	    
	    <ul style="margin: 0;">
	    	<li style="list-style-type: disc;">please select a file containing the data and needed namespace declarations</li>
	    	<li>predefined namespace declarations are added automatically</li>
	    	<li style="list-style-type: disc;">files must conform to the W3C RDF turtle syntax</li>
	    </ul>
	    
		<hr />
	    
		<table>
	        <tr style="background:transparent">
	            <td style="width:50%">
	            	<span style="margin-top:5px;">File Upload : </span>
	            	<input id="fileupload" style="width:60%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/skos/multiple-file-upload' />" data-remove-url="<@spring.url '/owl2/deleteFile' />" multiple />
				</td>
				<td>
				    <#-- form onsite help -->
					<a href="#" class="MISSY_onsiteHelp" style="margin-top:6px;vertical-align:top;">
						<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
						<span style="width:310px;">
							<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
							<h4 class="MISSY_onsiteHelp">File Upload</h4>
							<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
						    <ul style="margin: 0;">
						    	<li style="list-style-type: disc;">predefined namespace declarations: xsd, rdf, rdfs, owl, dcterms, skos, foaf, dcam, dsp, swrc, : (default namespace)</li>
						    </ul>
						</span>
					</a>
				</td>
	            <td>
	            	<div id="progress" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>
	    
	    <hr />
	
	  	<div id="accordion_result_area">
	  		
	  	</div>
    
    	<!--
	  	<textarea name="rdfGraph" id="rdfGraph" cols="50" rows="20"></textarea>	
	  	-->
	  	
	</fieldset>
	
	<#--<fieldset>
		<input 
		  type="button" 
		  name="button_skos-tab1" 
		  id="button_skos-tab1" 
		  value="Next: Validate" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>-->
	
</form>
<script>
	$jQ(function() {
		<#-- populate uploaded files -->
    	<#--getUploadedDocument( "#accordion_result_area" , "<@spring.url '/skos/getuploaded' />" ,  "<@spring.url '/skos/deleteFile' />");-->
    	
    	<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $jQ( '#fileupload' ), $jQ( '#progress' ) , "#accordion_result_area" );
	});	
	
</script>