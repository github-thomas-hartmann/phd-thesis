<form id="form-owl2-tab2" action="<@spring.url '/owl2/tab2' />" style="padding-left: 25px" class="MISSY_round_right" >	

	<fieldset>
	
		<table>
	        <tr style="background:transparent">
	            <td style="width:70%">
	            	<span style="margin-top:5px;">Multiple File Upload : </span>
	            	<input id="fileupload" style="width:60%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/owl2/upload' />" data-remove-url="<@spring.url '/owl2/deleteFile' />" multiple />
				</td>
	            <td>
	            	<div id="progress" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>
	    
	    <div id="constraints" name="constraints" style="width:100%"></div>	
	
	  	<div id="accordion_result_area">
	  		
	  	</div>
	  	
	</fieldset>
	
	<br />
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_owl2-tab2" 
		  id="button_owl2-tab2" 
		  value="Next: Data" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>

</form>
<script>
	$jQ(function() {
		<#-- populate uploaded files -->
    	getUploadedDocument( "#accordion_result_area" , "<@spring.url '/owl2/getuploaded' />" ,  "<@spring.url '/owl2/deleteFile' />");
    	
    	<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $jQ( '#fileupload' ), $jQ( '#progress' ) , "#accordion_result_area" );
	});	
	
</script>
