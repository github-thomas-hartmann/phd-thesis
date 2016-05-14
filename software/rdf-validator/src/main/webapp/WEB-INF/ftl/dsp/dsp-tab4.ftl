<form id="form-dsp-tab4" action="<@spring.url '/dsp/ngraph/tab4' />" style="padding-left: 25px" class="MISSY_round_right">

	<fieldset>
	
		<ul style="margin: 0;">
	    	<li style="list-style-type: disc;">you may enter inference rules
	    	</li>
	    	<li style="list-style-type: disc;">this step is optional</li>
	    	<li style="list-style-type: disc;">please use W3C RDF turtle syntax</li>
	    </ul>
	    
	    <hr/>
	
		<table>
	        <tr style="background:transparent">
	            <td style="width:50%">
	            	<input id="fileupload4" style="width:100%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/dsp/upload' />" multiple />
				</td>
	            <td>
	            	<div id="progress4" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>
	    
	    <hr/>
		  
		  <#-- form onsite help -->
			<a href="#" class="MISSY_onsiteHelp" style="margin:0;vertical-align:top;">
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
				<span style="width:350px;">
					<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
					<h4 class="MISSY_onsiteHelp">Data</h4>
					<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
				    <ul style="margin: 0;">
				    	<li style="list-style-type: disc;">you may adjust the height and the width of the textarea by dragging the small arrow at the right end of the textarea</li>
				    </ul>
				</span>
			</a>
		  <div id="containerInferenceRules"></div>	
	  	 <input type="hidden" name="inferenceRules" id="inferenceRules" />
	  	
	</fieldset>
	
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_dsp-tab4" 
		  id="button_dsp-tab4" 
		  value="Next: Check Constraints" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>
	
</form>	

<script>
	$jQ(document).ready(function() {
		<#-- show empty textarea -->
	    createRdfOwlView( "#containerInferenceRules" , ""  , [] );
	    
	    <#-- file upload-->
		$jQ('#fileupload4').fileupload({
	        dataType: 'json',
	 
	        done: function (e, data) {
	         	createRdfOwlView( "#containerInferenceRules" , data.result.fileContent , [] );
	        },
	 
	        progressall: function (e, data) {
	            var progress = parseInt(data.loaded / data.total * 100, 10);
	            $jQ('#progress4 .bar').css('width', progress + '%').html( progress + '%');
	        	$jQ('#progress4').show();
	            if( progress == 100 )
	            	window.setTimeout( function(){$jQ('#progress4').fadeOut( "slow" ); } , 3000);
	        }
        });
    });
</script>