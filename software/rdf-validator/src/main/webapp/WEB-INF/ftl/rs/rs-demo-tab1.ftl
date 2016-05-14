<form id="form-rs-demo-tab1" action="<@spring.url '/rs/demo/tab1' />" style="padding-left: 25px" class="MISSY_round_right" >	

	
	    <ul style="margin: 0;">
	    	<li style="list-style-type: disc;">
	    	predefined namespace declarations are added automatically
	    	</li>
	    	<li style="list-style-type: disc;">please add additional namespace declarations</li>
	    </ul>
	    
	    <hr/>
	    
	    <a href="#" class="MISSY_onsiteHelp" style="margin:10px 0 0 0;vertical-align:top;">
			<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
			<span style="width:350px;">
				<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
				<h4 class="MISSY_onsiteHelp">Namespace Declarations</h4>
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
			    <ul style="margin: 0;">
			    	<li style="list-style-type: disc;">predefined namespace declarations: xsd, rdf, rdfs, owl, dcterms, skos, foaf, dcam, dsp, swrc, : (default namespace)</li>
			    	<li style="list-style-type: disc;">you may adjust the height and the width of the textarea by dragging the small arrow at the right end of the textarea</li>
			    </ul>
			</span>
		</a>
	
	  	<div id="containerNamespaceDeclarations"></div>	
	  	<input type="hidden" name="namespaceDeclarations" id="namespaceDeclarations" />
	
	<!--
	
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_rs-demo-tab1" 
		  id="button_rs-demo-tab1" 
		  value="Next: Constraints" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>
	
	-->

</form>

<script>
$jQ( function(){
	<#-- load default content -->
	getDocumentDetails( "<@spring.url '/rs/file_details' />", "defaultNamespaceDeclarations.ttl", "#containerNamespaceDeclarations", "resources/rdfGraphs/RS/" );
	
	<#-- file upload -->
	<#--$jQ('#fileupload2').fileupload({
        dataType: 'json',
 
        done: function (e, data) {
         	$jQ('#constraints').val( data.result.fileContent );
        },
 
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $jQ('#progress2 .bar').css('width', progress + '%').html( progress + '%');
        	$jQ('#progress2').show();
            if( progress == 100 )
            	window.setTimeout( function(){$jQ('#progress2').fadeOut( "slow" ); } , 3000);
        }
    });-->
});
</script>