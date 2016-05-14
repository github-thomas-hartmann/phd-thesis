<h1>Detailed</h1>
<!-- the tabs -->
<div id="updateSpssTabContainer" class="tabContainer">
	<ul style="height: 40px;">	
		<li><a class="tabElement" href="#dsp2-tab1" style="text-decoration:none;padding: 10px 15px;"><span>1.</span> Namespace Declarations</a></li>
		<li><a class="tabElement" href="#dsp2-tab2" style="text-decoration:none;padding: 10px 15px;"><span>2.</span> Constraints</a></li>
		<li><a class="tabElement" href="#dsp2-tab3" style="text-decoration:none;padding: 10px 15px;"><span>3.</span> Data</a></li>
		<li><a class="tabElement" href="#dsp2-tab4" style="text-decoration:none;padding: 10px 15px;"><span>4.</span> Inference Rules</a></li>
		<li><a class="tabElement" href="#dsp2-tab5" style="text-decoration:none;padding: 10px 15px;"><span>5.</span> Validation Results</a></li>
	</ul>

	<div id="dsp2-tab1" style="padding:0 !important; border:none; float:left; width:100%">
		<#include "dsp2-tab1.ftl" />
	</div>
	<div id="dsp2-tab2" style="padding:0 !important;border:none;float:left; width:100%">
		<#-- ajax content here -->
		<#include "dsp2-tab2.ftl" />
	</div>
	<div id="dsp2-tab3" style="padding:0 !important;border:none;float:left; width:100%">
		<#-- ajax content here -->
		<#include "dsp2-tab3.ftl" />
	</div>
	<div id="dsp2-tab4" style="padding:0 !important;border:none;float:left; width:100%">
		<#-- ajax content here -->
		<#include "dsp2-tab4.ftl" />
	</div>
	<div id="dsp2-tab5" style="padding:0 !important;border:none;float:left; width:100%">
		<#-- ajax content here -->
		<#include "dsp2-tab5.ftl" />
	</div>


<script>
	$jQ( function() // begin document ready
	{
		<#-- change the size of main content -->
		$jQ( "#col3" ).css( "margin", "0 0 0 15px");
		// global variable to indicate validation requirements
		validateDatapoint = true;
	
		<#-- jQery tab for main content 'define study, define spss file, import -->
		$jQ( "#updateSpssTabContainer" ).tabs({ 
			active: 0,
			disabled: [1,2,3,4]
     	});
     	
		$jQ( "#graphTabContainer" ).tabs({ active: 0 });

		<#-- submit button on tab 1 pressed -->
		$jQ( "#button_dsp2-tab1" ).click( function()
		{
			// validate field values first
			//if ( validateDatapoint )
			//	if ( !validatationOfDatasetSucceed() )
			//		return false;
			
			<#-- put texatea value to hidden input -->
			$jQ( "#namespaceDeclarations" ).val( $jQ( "#containerNamespaceDeclarations" ).find("textarea").val() );
		
			changeTabCondition( 1 );
			
			<#--  submit the first form via ajax post and get the second tab content-->
			ajaxDspFrequenciesTabContent( "#form-dsp2-tab1", "#dsp2-tab2" );
		} );
		
		<#-- submit button on tab 2 pressed -->
		$jQ( "#dsp2-tab2" ).on( "click", "#button_dsp2-tab2", function(){
			
			// validate form first
			//if ( !validateForm( $jQ( "form#form-dsp2-tab2" ) ) )
			//	return false;
			
			<#-- put texatea value to hidden input -->
			$jQ( "#constraints" ).val( $jQ( "#containerConstraints" ).find("textarea").val() );
			
			changeTabCondition( 2 );
			<#--  submit the second form via ajax post and get the third tab content-->
			ajaxDspFrequenciesTabContent( "#form-dsp2-tab2", "#dsp2-tab3" );
		} );
		
		<#-- submit button on tab 3 pressed -->
		$jQ( "#dsp2-tab3" ).on( "click", "#button_dsp2-tab3", function(){
			
			// validate form first
			//if ( !validateForm( $jQ( "form#form-dsp2-tab3" ) ) )
			//	return false;
			
			<#-- put texatea value to hidden input -->
			$jQ( "#data" ).val( $jQ( "#containerData" ).find("textarea").val() );
			
			changeTabCondition( 3 );
			<#--  submit the second form via ajax post and get the third tab content-->
			ajaxDspFrequenciesTabContent( "#form-dsp2-tab3", "#dsp2-tab4" );
		} );
		
		<#-- submit button on tab 4 pressed -->
		$jQ( "#dsp2-tab4" ).on( "click", "#button_dsp2-tab4", function(){
			
			// validate form first
			//if ( !validateForm( $jQ( "form#form-dsp2-tab4" ) ) )
			//	return false;
			
			<#-- put texatea value to hidden input -->
			$jQ( "#inferenceRules" ).val( $jQ( "#containerInferenceRules" ).find("textarea").val() );
			
			changeTabCondition( 4 );
			
			<#-- ajax loading -->
			createAjaxLoadingOnAjaxContainer( "#form-dsp2-tab5" );
			
			<#--  submit the second form via ajax post and get the third tab content-->
			ajaxDspFrequenciesTabContent( "#form-dsp2-tab4", "#dsp2-tab5" );
		} );
	}); // end of document ready
	
	<#-- 
	ajax call for saving user inputs in spss import Frequencies on first or second tab
	and get the second or third tab content via ajax
	@param selectorForm     : jquery selector for form submit
	@param selectorCallback : jquery selector for callback content from ajax call
	-->
	function ajaxDspFrequenciesTabContent( selectorForm, selectorCallback ){		
		$jQ.ajax( {
			type: "post",
			url: $jQ( selectorForm ).attr( 'action' ),
			data: $jQ( selectorForm ).serializeArray()
		    })
	    	.done( function( html ) {
	    		$jQ( selectorCallback ).html( html );
			})
	    	.fail( function() {})
	    	.always( function() {
	    		removeAjaxLoadingDiv();
	    	}); //end of ajax call
	}
	
	function changeTabCondition( tabIndex ){
	<#-- the pipeline of the process always move forward -->
		<#-- enable next tab -->
		$jQ( "#updateSpssTabContainer" ).tabs( "enable",  tabIndex );
		$jQ( "#updateSpssTabContainer" ).tabs( { active: tabIndex } );
     	<#-- set previously tab checked -->
     	$jQ( "#updateSpssTabContainer ul li:nth-child(" + tabIndex + ") a span" )
     	.html('<img src="<@spring.url '/resources/images/check_black.png' />" class="checkedTab">');
     	
	}
</script>