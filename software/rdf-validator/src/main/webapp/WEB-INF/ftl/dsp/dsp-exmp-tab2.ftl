<form id="form-dsp-tab2" action="<@spring.url '/dsp/exmpgraph/tab2' />" style="padding-left: 25px" class="MISSY_round_right" >	

	<fieldset>
	
		<ul style="margin: 0;">
	    	<li style="list-style-type: disc;">
	    	this example file contains namespace declarations, constraints, and data
	    	</li>
	    	<li style="list-style-type: disc;">you may add namespace declarations, constraints, and data</li>
	    </ul>
	    
	    <hr/>
		  	
		<#-- form onsite help -->
			<a href="#" class="MISSY_onsiteHelp" style="margin-top:0px;vertical-align:top;">
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
				<span style="width:350px;">
					<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
					<h4 class="MISSY_onsiteHelp">Example File</h4>
					<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
				    <ul style="margin: 0;">
				    	<li style="list-style-type: disc;">you may adjust the height and the width of the textarea by dragging the small arrow at the right end of the textarea</li>
				    </ul>
				</span>
			</a>
			
	  	<div id="containerRdfGraph"></div>	
	  	<input type="hidden" name="rdfGraph" id="rdfGraph" />
	  	
	  	
	</fieldset>
	
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_dsp-tab2" 
		  id="button_dsp-tab2" 
		  value=" Next : Validate" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>

</form>
<script>
	$jQ(document).ready(function() {
	
		<#if filePath??>
		<#-- show RDF view with highlight  -->
		<#-- load default content -->
			getDocumentDetails( "<@spring.url '/dsp/file_details' />", "${filePath}", "#containerRdfGraph", "" );
		</#if>
	
	    // check username availability on focus lost
	    $jQ( '#form-dsp-tab2' ).on( "focus", 'input[type="text"]', function (){
	    	if( $jQ(this).hasClass( "form-error" ) ){
	    		$jQ(this).removeClass( "form-error" );
	    		$jQ(this).next( "div.errormsg" ).remove();
	    	}
	    });
	    
	});
</script>