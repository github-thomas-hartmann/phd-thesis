<h1>Multiple File Upload</h1>
<!-- the tabs -->
<div id="updateSpssTabContainer" class="tabContainer">
<ul style="height: 40px;">	
	<li><a class="tabElement" href="#phdd-upload-tab1" style="text-decoration:none;padding: 10px 15px;"><span>1.</span> Constraints and Data</a></li>
	<li id="phdd-upload-validation-tab"><a class="tabElement" href="#phdd-upload-tab2" style="text-decoration:none;padding: 10px 15px;"><span>2.</span> Validation</a></li>
</ul>

<div id="phdd-upload-tab1" style="padding:0 !important; border:none; float:left; width:100%">
	<#include "phdd-upload-tab1.ftl" />
</div>
<div id="phdd-upload-tab2" style="padding:0 !important;border:none;float:left; width:100%">
	<#include "phdd-upload-tab2.ftl" />
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
		$jQ( "#button_phdd-upload-validation" ).click( function()
		{
			<#-- validate inputs -->
			ajaxphddUploadValidation( "#phdd-validation-result" );
		} );
		
		<#-- on validation tab click collect input -->
		$jQ( "#phdd-upload-validation-tab" ).click( function(){
			getphddInputs( "#phdd-validation-inputs div" );
		} );
		
	}); // end of document ready
	
	<#-- collecting user inputs for preview in validation -->
	function getphddInputs( containerSelector ){
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
	function ajaxphddUploadValidation( containerResultSelector ){	
		<#-- disable validate button -->
		<!-- $jQ('#button_phdd-upload-validation').attr("disabled",true).addClass("buttonSubmitDissabled"); -->
		<#-- Add loading icon -->
		$jQ( containerResultSelector )
			.html( "" )
			.append( "<h3>Constraint Violations</h3> " )
			.append( '<div style="width:100%;text-align:center"><img src="<@spring.url '/resources/images/ajaxLoader.gif' />" /></div>' );
		
		$jQ.ajax( {
			type: "post",
			url: "<@spring.url '/phdd/upload/validation' />"
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