 <@layout.global>
 	
 	<@content.main>

		<div id="MISSY_breadcrumb"></div>
		<div id="col3_content" class="clearfix">
			<div class="floatbox"> 
				<h1>Web Ontology Language 2 (OWL 2)</h1>
				<!-- the tabs -->
				<div id="updateSpssTabContainer" class="tabContainer">
					<ul style="height: 40px;">	
						<li><a class="tabElement" href="#owl2-tab1" style="text-decoration:none;padding: 10px 15px;"><span>1.</span> Namespace Declarations</a></li>
						<li><a class="tabElement" href="#owl2-tab2" style="text-decoration:none;padding: 10px 15px;"><span>2.</span> Constraints</a></li>
						<li><a class="tabElement" href="#owl2-tab3" style="text-decoration:none;padding: 10px 15px;"><span>3.</span> Data</a></li>
						<li><a class="tabElement" href="#owl2-tab4" style="text-decoration:none;padding: 10px 15px;"><span>4.</span> Inference Rules</a></li>
						<li><a class="tabElement" href="#owl2-tab5" style="text-decoration:none;padding: 10px 15px;"><span>5.</span> Validation Results</a></li>
					</ul>
				
					<div id="owl2-tab1" style="padding:0 !important; border:none; float:left; width:100%">
						<#include "owl2-tab1.ftl" />
					</div>
					<div id="owl2-tab2" style="padding:0 !important;border:none;float:left; width:100%">
						<#-- ajax content here -->
						<#include "owl2-tab2.ftl" />
					</div>
					<div id="owl2-tab3" style="padding:0 !important;border:none;float:left; width:100%">
						<#-- ajax content here -->
						<#include "owl2-tab3.ftl" />
					</div>
					<div id="owl2-tab4" style="padding:0 !important;border:none;float:left; width:100%">
						<#-- ajax content here -->
						<#include "owl2-tab4.ftl" />
					</div>
					<div id="owl2-tab5" style="padding:0 !important;border:none;float:left; width:100%">
						<#-- ajax content here -->
						<#include "owl2-tab5.ftl" />
					</div>
					
				</div>
			</div>
 		</div>
		<!-- IE clearing - important! -->
		<div id="ie_clearing">&nbsp;</div>
 	</@content.main>
 	
</@layout.global>

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
     	


		<#-- submit button on tab 1 pressed -->
		$jQ( "#button_owl2-tab1" ).click( function()
		{
			// validate field values first
			//if ( validateDatapoint )
			//	if ( !validatationOfDatasetSucceed() )
			//		return false;
		
			changeTabCondition( 1 );
			
			<#--  submit the first form via ajax post and get the second tab content-->
			ajaxSpssImportFrequenciesTabContent( "#form-owl2-tab1", "#owl2-tab2" );
		} );
		
		<#-- submit button on tab 2 pressed -->
		$jQ( "#owl2-tab2" ).on( "click", "#button_owl2-tab2", function(){
			
			// validate form first
			//if ( !validateForm( $jQ( "form#form-dsp-tab2" ) ) )
			//	return false;
			
			changeTabCondition( 2 );
			<#--  submit the second form via ajax post and get the third tab content-->
			ajaxSpssImportFrequenciesTabContent( "#form-owl2-tab2", "#owl2-tab3" );
		} );
		
		<#-- submit button on tab 3 pressed -->
		$jQ( "#owl2-tab3" ).on( "click", "#button_owl2-tab3", function(){
			
			// validate form first
			//if ( !validateForm( $jQ( "form#form-dsp-tab3" ) ) )
			//	return false;
			
			changeTabCondition( 3 );
			<#--  submit the second form via ajax post and get the third tab content-->
			ajaxSpssImportFrequenciesTabContent( "#form-owl2-tab3", "#owl2-tab4" );
		} );
		
		<#-- submit button on tab 4 pressed -->
		$jQ( "#owl2-tab4" ).on( "click", "#button_owl2-tab4", function(){
			
			// validate form first
			//if ( !validateForm( $jQ( "form#form-dsp-tab4" ) ) )
			//	return false;
			
			changeTabCondition( 4 );
			
			<#-- add loading icon for next tab -->
			createAjaxLoadingOnAjaxContainer( "#form-owl2-tab5" );
			
			<#--  submit the second form via ajax post and get the third tab content-->
			ajaxSpssImportFrequenciesTabContent( "#form-owl2-tab4", "#owl2-tab5" );
		} );
		
		<#-- submit button on tab 5 pressed -->
		$jQ( "#owl2-tab5" ).on( "click", "#button_owl2-tab5", function(){
			
			changeTabCondition( 5 );
			<#--  submit the second form via ajax post and get the third tab content-->
			ajaxSpssImportFrequenciesTabContent( "#form-owl2-tab5", "#owl2" );
		} );
		
	}); // end of document ready
	
	<#-- 
	ajax call for saving user inputs in spss import Frequencies on first or second tab
	and get the second or third tab content via ajax
	@param selectorForm     : jquery selector for form submit
	@param selectorCallback : jquery selector for callback content from ajax call
	-->
	function ajaxSpssImportFrequenciesTabContent( selectorForm, selectorCallback ){		
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
	
	<#-- function for polling -->
	var refreshIntervalId = null; 	<#-- run condition for traditional polling -->
	
	var loadingTradTimeOut = null;
	
	var tradLineNumber = 0;
	
	function getContentFromFileViaTraditionalPooling( ){
		$jQ('#buttonFrequencyImportDataset')
		.attr( "disabled" , true )
		.removeClass( "buttonSubmit" )
		.addClass( "buttonSubmitDissabled" );
		
		var url = "<@spring.url '/polling/' />" + tradLineNumber;
			
		$jQ.ajax( {
			type: "get",
			url: url
		})
	    .done( function( text ) {
	    	var textSplit = text.split("_#_");
	    	if( text != "" ){
	    		tradLineNumber += textSplit.length;
	    		removeDotLoading( "#text_output" );
	    	}
	    	$jQ.each( textSplit , function( i, val ){
	    		if( val != "" )
	    			$jQ( "#text_output" ).append( '<span class="stat">' + val + "</span>" );
	    		
	    		var divTarea = document.getElementById('text_output');
				divTarea.scrollTop = divTarea.scrollHeight
				
				if( i == textSplit.length - 1 && text != "")
					animateDotLoading( 5, 1000 , "#text_output" );
				
				if( val == "-END-" )
				{
					clearInterval( refreshIntervalId );
					
					removeDotLoading( "#text_output" );
					
					$jQ('#buttonFrequencyImportDataset')
					.attr( "disabled" , false )
					.removeClass( "buttonSubmitDissabled" )
					.addClass( "buttonSubmit" );
				}
	    	});
	    	
		}); //end of ajax call
	}
	
	function animateDotLoading( numberOfDots, timeout, parentSelector ){
		$jQ( parentSelector ).append( '<span class="loading">&nbsp;</span>' );
		$jQ( parentSelector )[0].scrollTop = $jQ( parentSelector )[0].scrollHeight;
		
		var numberOfDotsTrad = numberOfDots;
		$spanElem = $jQ( parentSelector + " .loading");
		
		loadingTradTimeOut = setInterval( function(){
			$spanElem.append( "." );
			numberOfDotsTrad--;

			if( numberOfDotsTrad == 0 ){
				$spanElem.html( "&nbsp;" );
				numberOfDotsTrad = numberOfDots;
			}
		} , timeout );

	}
	
	function removeDotLoading( parentSelector ){
		$jQ( parentSelector + " .loading").remove();
		clearInterval( loadingTradTimeOut );
	}
</script>