<form id="form-dsp-tab2" action="<@spring.url '/dsp/ngraph/tab2' />" style="padding-left: 25px" class="MISSY_round_right" >	

	<fieldset>
	
		<ul style="margin: 0;">
	    	<li style="list-style-type: disc;">
	    	please enter your constraints
		
	    	</li>
	    	<li style="list-style-type: disc;">please use W3C RDF turtle syntax</li>
	    </ul>
	    
	    <hr/>
	    
		<ul style="margin: 0;">
	    	<li style="list-style-type: disc;">you may upload a file containing constraints</li>
	    </ul>
	
		<table>
	        <tr style="background:transparent">
	            <td style="width:50%">
	            	<input id="fileupload2" style="width:100%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/dsp/upload' />" multiple />
				</td>
	            <td>
	            	<div id="progress2" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>
	    
	    <hr/>
	
		<#-- form onsite help -->
			<a href="#" class="MISSY_onsiteHelp" style="margin-top:0px;vertical-align:top;">
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
				<span style="width:350px;">
					<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
					<h4 class="MISSY_onsiteHelp">Constraints</h4>
					<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
				    <ul style="margin: 0;">
				    	<li style="list-style-type: disc;">you may adjust the height and the width of the textarea by dragging the small arrow at the right end of the textarea</li>
				    </ul>
				</span>
			</a>
			
	  	<div id="containerConstraints"></div>	
	  	<input type="hidden" name="constraints" id="constraints" />
		
	  	
	</fieldset>
	
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_dsp-tab2" 
		  id="button_dsp-tab2" 
		  value="Next: Data" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>

</form>

<script>
$jQ(document).ready(function() {
		<#-- show empty textarea -->
	    createRdfOwlView( "#containerConstraints" , ""  , [] );
	    
	    <#-- file upload-->
		$jQ('#fileupload2').fileupload({
	        dataType: 'json',
	 
	        done: function (e, data) {
	         	createRdfOwlView( "#containerConstraints" , data.result.fileContent , [] );
	        },
	 
	        progressall: function (e, data) {
	            var progress = parseInt(data.loaded / data.total * 100, 10);
	            $jQ('#progress2 .bar').css('width', progress + '%').html( progress + '%');
	        	$jQ('#progress2').show();
	            if( progress == 100 )
	            	window.setTimeout( function(){$jQ('#progress2').fadeOut( "slow" ); } , 3000);
	        }
	    });
     });
</script>