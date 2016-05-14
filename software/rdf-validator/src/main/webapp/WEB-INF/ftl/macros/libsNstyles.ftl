	<!-- MISSY CSS DEFINITION -->
	<!-- general gesis css definition -->
	<link rel="stylesheet" href="<@spring.url '/resources/styles/gs_styles.css' />" />
	<link rel="stylesheet" href="<@spring.url '/resources/styles/default.css' />" />
	<!-- internal missy css definition -->
	<link rel="stylesheet" href="<@spring.url '/resources/styles/import.css' />" />
	<link rel="stylesheet" href="<@spring.url '/resources/styles/jquery-ui.css' />" />
	<!-- css ( RDF-Validation ) -->
	<link rel="stylesheet" href="<@spring.url '/resources/styles/RDFValidation.css' />" />
	<link rel="stylesheet" href="<@spring.url '/resources/styles/n3.css' />" />
	
	<!-- external -->
	<!-- simplifies javascript programming -->
	<script src="<@spring.url '/resources/scripts/prototype.js' />"></script>
	<script src="<@spring.url '/resources/scripts/jquery-1.8.2.js' />"></script>
	<script src="<@spring.url '/resources/scripts/jquery-ui-1.9.2.custom.js' />"></script>
	
	<!-- used for the tree -->
	<link rel="stylesheet" href="<@spring.url '/resources/styles/ui.dynatree.css' />" />
	<script src="<@spring.url '/resources/scripts/jquery.dynatree.js' />"></script>
	
	<!-- used for sorting table -->
	<script src="<@spring.url '/resources/scripts/jquery.tablesorter.min.js' />"></script>
	
	<!-- used for undo and redo changes in dynatree -->
	<script src="<@spring.url '/resources/scripts/jquery.undoable.js' />"></script>
	
	<!-- used for the tinymce -->
	<script src="<@spring.url '/resources/scripts/jquery.tinymce.js' />"></script>
	
	<#-- used for uploading file via ajax, etc-->
	<script src="<@spring.url '/resources/scripts/jquery.fileupload.js' />"></script>
	
	<script>
		<!-- this is to prevent conflicts with prototype and jquerytools -->
		$jQ = jQuery.noConflict();
		<#-- get the basepath of the project, that will be used in javascript file -->
		var basepath = "<@spring.url '' />";
	</script>
	<script type="text/javascript" src="<@spring.url '/resources/scripts/missy.js' />"></script>