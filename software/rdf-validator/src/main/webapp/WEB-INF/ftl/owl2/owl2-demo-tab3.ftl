<form style="padding-left: 25px"  id="form-owl2-demo-tab3" action="<@spring.url '/owl2/demo/tab3' />" class="MISSY_round_right">
	
	<fieldset>
	
		<#-- main direction -->
		<ul style="margin: 0;">
	    	<li style="list-style-type: disc;">please enter your data</li>
	    	<li style="list-style-type: disc;">please use W3C RDF turtle syntax</li>
	    </ul>
	    
	    <hr/>
	
		<#-- main onsite help -->
			<a href="#" class="MISSY_onsiteHelp" style="margin:10px 0 0 0;vertical-align:top;">
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
			
		<#-- syntax container -->
	  	<div id="containerData"></div>	 
	 
	</fieldset>
	
	<hr/>

	<fieldset>
		<#-- directory tree direction -->
		<ul style="margin: 0;">
	    	<li style="list-style-type: disc;">you may select a file containing example data</li>
	    </ul>
	    
	    <hr/>
	    
	  	<#-- directory tree onsite help -->
		<a href="#" class="MISSY_onsiteHelp" style="margin:0px;vertical-align:top">
			<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
			<span style="width:350px;">
				<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
				<h4 class="MISSY_onsiteHelp">Constraints</h4>
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
			    <ul style="margin: 0;">
			    	<li style="list-style-type: disc;">you may select a file containing example data</li>
			    	<li style="list-style-type: disc;">the content of the selected file will be pasted at the end of the textarea above</li>
			    </ul>
			</span>
		</a>
		
		<#-- directory tree container -->
		<div id="dirData"></div>
	  	
	</fieldset>
	
</form>

<script>

	$jQ(document).ready(function() {   
	    <#-- create the tree -->
	    createTree( "#dirData", "owl2", "#containerData", "/resources/rdfGraphs/OWL2/constraints and data" );
	    <#-- show empty textarea -->
	    createRdfOwlView( "#containerData" , ""  , [] );
	});
	
</script>