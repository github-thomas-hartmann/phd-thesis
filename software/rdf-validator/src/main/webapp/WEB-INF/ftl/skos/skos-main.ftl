 <@layout.global>
 
 	<@content.left>
			<div id="col1_content" class="clearfix">
			
				<!--Tabs for switch between Study and Variable-level-->
				<div id="skosTabContainer" class="tabContainer">
					<ul>
						<li>
							<a class="tabElement" href="#study_tab" style="text-decoration:none;">SKOS</a>
						</li>
					</ul>
					
					<!-- tab contents -->
					<div id="study_tab" style="float:left;background:#ededed">
						<input type="button" name="studyGroupButton" value="demo" data-url="demo" class="MISSY_altButton MISSY_altButton_medium MISSY_toggableButton graphButton MISSY_altButton_active">
						<!--<input type="button" name="studyGroupButton" value="examples" data-url="exmpgraph"class="MISSY_altButton MISSY_altButton_medium MISSY_toggableButton graphButton">-->
						<input type="button" name="studyGroupButton" value="upload" data-url="upload" class="MISSY_altButton MISSY_altButton_medium MISSY_toggableButton graphButton">
						<!--<input type="button" name="studyGroupButton" value="detailed" data-url="ngraph"class="MISSY_altButton MISSY_altButton_medium MISSY_toggableButton graphButton">-->
						<input type="button" name="studyGroupButton" value="endpoint" data-url="endpoint" class="MISSY_altButton MISSY_altButton_medium MISSY_toggableButton graphButton">
					</div>
				</div>
				
				<!-- Text below menu -->
				<div class="textBelowMenu"></div>
				<!-- Links to partners -->
				<div class="partner">

			</div>
		<!-- End of col1_content --> 
		</div>
	</@content.left>
 	
 	<@content.main>

		<div id="MISSY_breadcrumb"></div>
		<div id="col3_content" class="clearfix">
			<div class="floatbox" id="main-content"> 
				<#include "skos-demo.ftl" />
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
	
     	<#-- jQery tab for left navigation menu -->
		$jQ( "#skosTabContainer" ).tabs({ active: 0 });
		$jQ( "#skosTabContainer" ).css( "margin-top", "66px");
		$jQ( "#skosTabContainer" ).css( "margin-left", "5px");
		$jQ( "#skosTabContainer" ).css( "margin-right", "5px");
		
		<#-- jQuery click for change main content  -->
		var currentNavButton = "demo";	
		$jQ(".graphButton").click( function(){
			<#-- get button value -->
			var selectedNav = $jQ( this ).attr( "data-url" );
			if( selectedNav != currentNavButton ){
				<#-- add loading icon for next tab -->
				<!-- createAjaxLoadingOnAjaxContainer( "#main-content" ); -->
				<#-- get ajax main content -->
				
				$jQ.ajax( {
					type: "get",
					url:  "<@spring.url '/skos/' />" + selectedNav
				    })
			    	.done( function( html ) {
			    		$jQ( "#main-content" ).html( html );
					})
			    	.fail( function() {})
			    	.always( function() {
			    		removeAjaxLoadingDiv();
			    	}); //end of ajax call
			
				currentNavButton = selectedNav;
			}
			
		});
		
	}); // end of document ready
</script>