<h1>SPARQL Endpoint Validation</h1>
<!-- the tabs -->
<div id="dataCubeEndpointTabContainer" class="tabContainer">
	<ul style="height: 40px;">	
		<li><a class="tabElement" href="#datacube-endpoint-tab1" style="text-decoration:none;padding: 10px 15px;"><span>1.</span> Constraint and SPARQL Endpoint</a></li>
		<li id="datacube-endpoint-validation-tab"><a class="tabElement" href="#datacube-endpoint-tab2" style="text-decoration:none;padding: 10px 15px;"><span>2.</span> Validation</a></li>
	</ul>
	
	<div id="datacube-endpoint-tab1" style="padding:0 !important; border:none; float:left; width:100%">
		<#include "datacube-endpoint-tab1.ftl" />
	</div>
	<div id="datacube-endpoint-tab2" style="padding:0 !important;border:none;float:left; width:100%">
		<#include "datacube-endpoint-tab2.ftl" />
	</div>
</div>
			
<script>
	$jQ( function() // begin document ready
	{
		<#-- change the size of main content -->
		$jQ( "#col3" ).css( "margin", "0 0 0 15px");
	
		<#-- jQery tab for main content 'define study, define spss file, import -->
		$jQ( "#dataCubeEndpointTabContainer" ).tabs({ 
			active: 0, 
			activate : function(event, ui){
				if(ui.newPanel.selector == "#datacube-endpoint-tab2")
					<#-- validate inputs -->
					ajaxdatacubeendpointValidation( "#datacube-validation-result" );
			}
     	});
     	
		<#-- submit button validation pressed -->
		$jQ( "#button_datacube-endpoint-validation" ).click( function()
		{
			<#-- validate inputs -->
			ajaxdatacubeendpointValidation( "#datacube-validation-result" );
		} );

		
	}); // end of document ready
	
	<#-- collecting user inputs for preview in validation -->
	function getdatacubeInputs( containerSelector ){
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
	function ajaxdatacubeendpointValidation( containerResultSelector ){	
		$jQ.ajax( {
		    type: "post",
			url: "<@spring.url '/datacube/endpoint/validation/parameter' />",
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
	   $jQ.ajax( {
		    type: "post",
			url: "<@spring.url '/datacube/endpoint/validation' />",
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