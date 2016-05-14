<h1>Multiple File Upload</h1>
<!-- the tabs -->
<div id="updateSpssTabContainer" class="tabContainer">
<ul style="height: 40px;">	
	<li><a class="tabElement" href="#owl2-upload-tab1" style="text-decoration:none;padding: 10px 15px;"><span>1.</span> Constraints and Data</a></li>
	<li id="owl2-upload-validation-tab"><a class="tabElement" href="#owl2-upload-tab2" style="text-decoration:none;padding: 10px 15px;"><span>2.</span> Validation</a></li>
</ul>

<div id="owl2-upload-tab1" style="padding:0 !important; border:none; float:left; width:100%">
	<#include "owl2-upload-tab1.ftl" />
</div>
<div id="owl2-upload-tab2" style="padding:0 !important;border:none;float:left; width:100%">
	<#include "owl2-upload-tab2.ftl" />
</div>
					
<script>
	$jQ( function() // begin document ready
	{
		<#-- change the size of main content -->
		$jQ( "#col3" ).css( "margin", "0 0 0 15px");
	
		<#-- jQery tab for main content 'define study, define spss file, import -->
		$jQ( "#updateSpssTabContainer" ).tabs({ 
			active: 0
     	});
     	
		<#-- submit button validation pressed -->
		$jQ( "#button_owl2-upload-validation" ).click( function()
		{
			<#-- validate inputs -->
			ajaxOwl2UploadValidation( "#owl2-validation-result" );
		} );
		
		<#-- on validation tab click collect input -->
		$jQ( "#owl2-upload-validation-tab" ).click( function(){
			getOwl2Inputs( "#owl2-validation-inputs div" );
		} );
		
	}); // end of document ready
	
	<#-- collecting user inputs for preview in validation -->
	function getOwl2Inputs( containerSelector ){
		<#-- clear -->
		$jQ( containerSelector ).html( "" );
		<#-- append new content -->
		$jQ( "#accordion_result_area h3" )
		.each( function(){
			var $contentHeader =
				$jQ( '<table/>' ).addClass( 'datatable' )
				.append( 
				$jQ( '<tr/>' )
					.append( '<td>file</td>' )
					.append( '<td>' + ($jQ( this ).text()).substring(1, ($jQ( this ).text()).length ) + '</td>' )
				);

			var $contentBody =
				$jQ( '<table/>' ).addClass( 'datatable' )
				.append( 
				$jQ( '<tr/>' )
					.append( '<td>input graph</td>' )
					.append( $jQ( '<tr/>' )
						.append( $jQ('<pre/>').text( $jQ( this ).next().find( "textarea.edit-syntax" ).val() ) ) 
					)
				);
				
			$jQ( containerSelector )
			.append( $contentHeader )
			.append( $contentBody );
				
		});
	}
	
	<#-- 
	ajax call for collecting user inputs and validate
	-->
	function ajaxOwl2UploadValidation( containerResultSelector ){	
		<#-- disable validate button -->
		<!-- $jQ('#button_owl2-upload-validation').attr("disabled",true).addClass("buttonSubmitDissabled"); -->
		<#-- Add loading icon -->
		$jQ( containerResultSelector )
			.html( "" )
			.append( "<h3>Constraint Violations</h3> " )
			.append( '<div style="width:100%;text-align:center"><img src="<@spring.url '/resources/images/ajaxLoader.gif' />" /></div>' );
		
		$jQ.ajax( {
			type: "post",
			url: "<@spring.url '/owl2/upload/validation' />"
		    })
	    	.done( function( html ) {
	    		$jQ( containerResultSelector ).html( html );
			})
	    	.fail( function() {})
	    	.always( function() {
	    		removeAjaxLoadingDiv();
	    	}); //end of ajax call
	}
</script>