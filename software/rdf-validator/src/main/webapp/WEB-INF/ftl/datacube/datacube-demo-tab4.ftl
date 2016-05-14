<form id="form-datacube-demo-tab2" action="<@spring.url '/datacube/demo/tab2' />" style="padding-left: 25px" class="MISSY_round_right" >	

	<fieldset>
		<#-- syntax direction -->
		<ul style="margin:0;width:90%">
	    	<li style="list-style-type: disc;">
	    		please enter your Inference Rules
	    	</li>
	    	<li style="list-style-type: disc;">please use W3C RDF turtle syntax</li>
	    </ul>
	    
	    <hr/>
	
		<#-- syntax onsite help -->
		<a href="#" class="MISSY_onsiteHelp" style="margin:10px 0 0 0;vertical-align:top;">
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
		
		<#-- syntax container -->
		<div id="containerInferenceRules"></div>	
				
	</fieldset>

	<hr/>

	<fieldset>
		<#-- directory tree direction -->
		<ul style="margin: 0;">
	    	<li style="list-style-type: disc;">you may select a file containing example of Inference Rules</li>
	    </ul>
	    
	    <hr/>
	    
	  	<#-- directory tree onsite help -->
		<a href="#" class="MISSY_onsiteHelp">
			<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
			<span style="width:350px;">
				<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
				<h4 class="MISSY_onsiteHelp">Constraints</h4>
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
			    <ul style="margin: 0;">
			    	<li style="list-style-type: disc;">you may select a file containing example Inference Rules</li>
			    	<li style="list-style-type: disc;">the content of the selected file will be pasted at the end of the textarea above</li>
			    </ul>
			</span>
		</a>
		
		<#-- directory tree container -->
		<div id="dirInferenceRules"></div>
	  	
	</fieldset>
	
</form>
<script>

	$jQ(document).ready(function() {   
	    <#-- create the tree -->
	    createTree( "#dirInferenceRules", "datacube","#containerInferenceRules", "/resources/rdfGraphs/datacube/inferenceRules" );
	    <#-- show empty textarea -->
	    createRdfOwlView( "#containerInferenceRules" , ""  , [] );
	});
	
</script>
