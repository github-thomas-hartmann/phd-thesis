<h1>SPARQL Endpoint Validation</h1>
<!-- the tabs -->
<div id="dcatEndpointTabContainer" class="tabContainer">
	<ul style="height: 40px;">	
		<li><a class="tabElement" href="#dcat-endpoint-tab1" style="text-decoration:none;padding: 10px 15px;"><span>1.</span> Constraint and SPARQL Endpoint</a></li>
		<li id="dcat-endpoint-validation-tab"><a class="tabElement" href="#dcat-endpoint-tab2" style="text-decoration:none;padding: 10px 15px;"><span>2.</span> Validation</a></li>
	</ul>
	
	<div id="dcat-endpoint-tab1" style="padding:0 !important; border:none; float:left; width:100%">
		<#include "dcat-endpoint-tab1.ftl" />
	</div>
	<div id="dcat-endpoint-tab2" style="padding:0 !important;border:none;float:left; width:100%">
		<#include "dcat-endpoint-tab2.ftl" />
	</div>
</div>
			
<script>
	$jQ( function() // begin document ready
	{
		<#-- change the size of main content -->
		$jQ( "#col3" ).css( "margin", "0 0 0 15px");
	
		<#-- jQery tab for main content 'define study, define spss file, import -->
		$jQ( "#dcatEndpointTabContainer" ).tabs({ 
			active: 0, 
			activate : function(event, ui){
				if(ui.newPanel.selector == "#dcat-endpoint-tab2")
					<#-- validate inputs -->
					ajaxdcatendpointValidation( "#dcat-validation-result" );
			}
     	});
     	
		<#-- submit button validation pressed -->
		$jQ( "#button_dcat-endpoint-validation" ).click( function()
		{
			<#-- validate inputs -->
			ajaxdcatendpointValidation( "#dcat-validation-result" );
		} );

		
	}); // end of document ready
	
	<#-- collecting user inputs for preview in validation -->
	function getdcatInputs( containerSelector ){
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
	function ajaxdcatendpointValidation( containerResultSelector ){	
		<#-- disable validate button -->
		<!-- $jQ('#button_dcat-endpoint-validation').attr("disabled",true).addClass("buttonSubmitDissabled"); -->
		<#-- Add loading icon -->
		<#--var constraintDescription = $("#constraintDescriptions['DATA-CUBE-C-DATA-MODEL-CONSISTENCY-05']").val();-->
		$jQ( containerResultSelector )
			.html( "" )
			.append( "<h3>Validation Parameter</h3>" )
			.append( "<hr/>" )
			.append( "<ul>" )
			.append( "<li><div title='" + $jQ( "#constraintDescriptions[DATA-CUBE-C-DATA-MODEL-CONSISTENCY-05]" ).val() + "'><b>constraint:</b> " + $jQ( "#constraint" ).val() + "</div></li>" )
			.append( "<li><div><b>SPARQL endpoint:</b> " + $jQ( "#sparqlEndpoint" ).val() + "</div></li>" )
			.append( "<li><div><b>limit:</b> " + $jQ( "#limit" ).val() + "</div></li>" )
			.append( "</ul>" )
			.append( "<hr/>" )
			.append( "<h3>The validation process may take some time...</h3> " )
			.append( '<div style="width:100%;text-align:center"><img src="<@spring.url '/resources/images/ajaxLoader.gif' />" /></div>' );
		
		$jQ.ajax( {
		    type: "post",
			url: "<@spring.url '/dcat/endpoint/validation' />",
			data: {
			    sparqlEndpoint: $jQ( "#sparqlEndpoint" ).val(),
			    constraint: $jQ( "#constraint" ).val(),
				limit: $jQ( "#limit" ).val()
				}
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