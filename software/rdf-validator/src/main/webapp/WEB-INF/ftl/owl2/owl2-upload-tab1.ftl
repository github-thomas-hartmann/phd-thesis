<form id="form-owl2-tab1" action="<@spring.url '/owl2/upload/tab1' />" style="padding-left: 25px" class="MISSY_round_right">
	
	<fieldset>
	
		<!--
		<table>
	        <tr style="background:transparent">
	            <td style="width:50%">
	            	<input id="fileupload" style="width:100%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/owl2/upload' />" multiple />
				</td>
	            <td>
	            	<div id="progress" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>
	    -->
	    
	    <ul style="margin: 0;">
	    	<li style="list-style-type: disc;">please select a file / multiple files containing constraints and data</li>
	    	<li style="list-style-type: disc;">files must contain: constraints, data</li>
	    	<li style="list-style-type: disc;">files may contain: additional namespace declarations, inference rules</li>
	    	<li>predefined namespace declarations are added automatically</li>
	    	<li style="list-style-type: disc;">files must be written using W3C RDF turtle syntax</li>
	    </ul>
	    
		<hr />
	    
		<table>
	        <tr style="background:transparent">
	            <td style="width:50%">
	            	<span style="margin-top:5px;">Multiple File Upload : </span>
	            	<input id="fileupload" style="width:60%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/owl2/multiple-file-upload' />" data-remove-url="<@spring.url '/owl2/deleteFile' />" multiple />
				</td>
				<td>
				    <#-- form onsite help -->
					<a href="#" class="MISSY_onsiteHelp" style="margin-top:6px;vertical-align:top;">
						<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
						<span style="width:310px;">
							<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
							<h4 class="MISSY_onsiteHelp">Multiple File Upload</h4>
							<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
						    <ul style="margin: 0;">
						    	<li style="list-style-type: disc;">predefined namespace declarations: xsd, rdf, rdfs, owl, dcterms, skos, foaf, : (default namespace)</li>
						    	<li style="list-style-type: disc;">please view the file contents by clicking on the file name below the browse button</li>
						    	<li style="list-style-type: disc;">hide file contents by clicking on the file name</li>
			    				<li style="list-style-type: disc;">you may adjust the height and the width of the textarea by dragging the small arrow at the right end of the textarea</li>
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
		  name="button_owl2-tab1" 
		  id="button_owl2-tab1" 
		  value="Next: Validate" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>-->
	
</form>
<script>
	$jQ(function() {
		<#-- populate uploaded files -->
    	getUploadedDocument( "#accordion_result_area" , "<@spring.url '/owl2/getuploaded' />" ,  "<@spring.url '/owl2/deleteFile' />");
    	
    	<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $jQ( '#fileupload' ), $jQ( '#progress' ) , "#accordion_result_area" );
	});	
	
</script>