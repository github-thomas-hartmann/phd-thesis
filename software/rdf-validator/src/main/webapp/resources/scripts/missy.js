// jQuery document ready
$jQ(function(){
	
	// change normal text inside <span> to be editable, by transform the span into <textarea>.
	// need 2 element <span class="editableText" data-input-id="X" /> and
	// input hidden element <input type="hidden" name="X" id="X" />
	//$jQ( "span.editableText" ).click(editableTextClicked);
	
	// fixing the position of tooltip when hovered, also applied from the content rendered from ajax call
	$jQ( document ).on({
	    mouseenter: function () {
	    	adjustHelpTooltipPosition($jQ(this));
	    	
	    },
	    mouseleave: function () {
	    	resetHelpTooltipPosition($jQ(this));
	    }
	}, "a.MISSY_onsiteHelp" );
	
	// pop up saving alert f the user leaving page without saving changes.
	// only bind the event on 'a tags' on specific page, and exclude the
	// 'a tags' with class 'tabElement'
	if( typeof changesIsSaved != 'undefined' ){
		$jQ( 'a' ).not( '.tabElement, .variable_item, .buttonSubmit' ).click(function(){
			// if hasn't been saved
		    if(!changesIsSaved){
		    	// Grab the link's href
			    var href = this.href;
			    // if the link is a special link that needs to be added with some URI segments before redirected to it..
			    if( $jQ(this).is( "#doVariableDetailsLink, #doSeriesDetailsLink, #doChooseVariables, #doDocumentsLink" ) ){
			    	var href = href +"/"+ $jQ( "#study" ).val();
					var year = $jQ( "#year" );
					var dataset = $jQ( "#dataset" );
					var filetype = $jQ( "#filetype" );
					
					if ( year.length > 0 && year.val() != "" )
						href += "/"+ year.val();
					if ( dataset.length > 0 && dataset.val() != "" )
						href += "/"+ dataset.val();
					if ( filetype.length > 0 && filetype.val() != "" )
						href += "/" + filetype.val();
			    }
			    // check if there are changes in values
				if(isThereAnyInputChanges()){
					valuesChanged = true;
					// if there is a change, pop up dialog box
					$jQ( "#saveAlertPopUp" ).dialog({
						modal: true,
						position: 'center',
						autoOpen: true,
						width: 480,
						open: function( event, ui ) {
							var tabLabel = $jQ( "#" + tabContainerSelector + " ul li.ui-tabs-active a" ).text();
							$jQ("#saveAlertPopUp_Text").html("Do you want to save the changes you made to " + 
							tabLabel );
						},
						buttons: 
						{
							"Save": function() 
							{
								// get form, based on visible tab panel
								var targetForm = $jQ( "#" + tabContainerSelector + " div.ui-tabs-panel:visible form" );

								// call ajax save function
								$jQ.ajax( {
									type: "post",
									url: targetForm.attr( 'action' ),
									data: targetForm.serialize()
								    })
							    	.done( function() {
							    		location.href = href;
									})
							    	.fail( function() {})
							    	.always( function() {
							    	}); //end of ajax call
							    	
								$jQ( this ).dialog( "close" );
							},
							"Don't save": function()
							{
								$jQ( this ).dialog( "close" );
								location.href = href;
							}
						}
					});
				} else {
					return true;
				}
			} else {
				return true;
			}
			// Prevent the default action of the link
		    return false;
		});
	}

	// fixing button inside of anchor link doesn't work on IE
	$jQ( document ).on( 'click' , 'a > :button' , function() { 
	    location.href = $jQ(this).closest("a").attr("href");
	}); 
	
	// make page animate scroll to top when element with class
	// "scroll-to-top" is clicked
	$jQ( document ).on( 'click' , '.scroll-to-top' , function() { 
		$jQ('html, body').animate({scrollTop:0}, 'slow');
	}); 
	
	// every time ajax call is made reset the session counter
	$jQ( document ).ajaxComplete(function() {
		startTimer();
	});
	
	startTimer();
	
});
// end jQuery document ready

//==global variable configuration for timer==
// the length of session time
var sessionLength;
// the remaining time before warning pop up shows
var sessionAlertPopUp;
// timer running flag
var timmerRunning = true;
// flag check if user click hide session warning
var isHideSessionWarningClicked = false;
// the timer object
var timerID = null

function startTimer(){
	var now = new Date()
    now = now.getTime()
    
    sessionLength = now +  ( 120 * 60 * 1000 );	// (120 minutes)the session length in milisecond (hour * minute(60) * second(60))
    sessionAlertPopUp = now + ( 110 * 60 * 1000); // (110 minutes) the time before session alert pop up in milisecond (hour * minute(60) * second(60))
	
	isHideSessionWarningClicked = false;
	timmerRunning = true;
	
	clearTimeout(timerID);
	$jQ( "#timeoutPopup" ).hide();
	$jQ( "#session-warning-overlay" ).hide();
	$jQ( "#session-warning-overlay" ).css({ 'width': $jQ(document).width()+'px' , 
											'height': $jQ(document).height()+'px'});
	
    showCountDown();
}

function showCountDown(){
	var now = new Date();
    now = now.getTime();

    //if (now - sessionAlertPopUp < 0) // for testing (before warning pop up)
    	//console.log("Pop up in in " + ( sessionAlertPopUp - now ));
    if (now - sessionAlertPopUp >= 0) {	// show session warning
    	var sessionRemainingTime = new Date(sessionLength - now)
        var theMin = sessionRemainingTime.getMinutes()
        var theSec = sessionRemainingTime.getSeconds()
        var theTime = theMin
        theTime += ((theSec < 10) ? ":0" : ":") + theSec
    	console.log("Logout in " + theTime + " Minutes");
    	
    	if(isHideSessionWarningClicked){
    		$jQ( "#timeoutPopup" ).hide();
    		$jQ( "#session-warning-overlay" ).hide();
    	}
    	else{
	    	// show warning pop up
	    	$jQ( "#timeoutPopup" ).show();
	    	$jQ( "#session-warning-overlay" ).show();
	    	// put the counter
	    	$jQ( "#SessionTimeCount" ).html("Logout in " + theTime );
    	}
     } 
    if(now - sessionAlertPopUp >= sessionLength - sessionAlertPopUp) {	// show session is expired
    	 clearTimeout(timerID)
    	 timmerRunning = false;
    	 $jQ( "#TextWarning" ).addClass("MISSY_invisible", 1 );
   	   	 $jQ( "#TextLogout" ).removeClass("MISSY_invisible", 1 );
   	   	 // show warning pop up
	    $jQ( "#timeoutPopup" ).show();
     }
     if(timmerRunning){
	     timerID = setTimeout( "showCountDown()" , 1000);
	     //console.log("click");
     }
}

// this method is called when the the user click button for hiding session warning
function hideSessionWarning(){
	isHideSessionWarningClicked = true;
}

// Convert textarea to tinymce richtext
// @param the selector on area on page that have textareas with 'tinymce' class.
// to adjust with missy style the textarea must have this property "class='tinymce' style='width:40?px;display:inline-block;'"
function convertTextareasIntoRichText(areaSelector){
	$jQ( areaSelector ).find( 'textarea.tinymce' ).each( function(){
		// adjust missy onsite help style
		$jQ( this ).next( 'a.MISSY_onsiteHelp' ).find( 'img:first' ).css( 'margin-top', '-40px' );
		// convert textarea to tinymce rich text
		$jQ( this ).tinymce({
			// Location of TinyMCE script
			script_url : basepath + "/resources/scripts/tiny_mce.js",
			// General options "already fixed, can not be changed"
			theme:"advanced",skin :"o2k7",skin_variant:"silver",
			theme_advanced_resizing_min_height : 30,
	        theme_advanced_resize_horizontal : false,
			// Theme options
			theme_advanced_buttons1 : "bold,italic,underline,|,bullist,numlist,|,undo,redo,|",
			theme_advanced_toolbar_location : "external",
			theme_advanced_toolbar_align : "left",
			theme_advanced_statusbar_location : "bottom",
	        theme_advanced_path : false,
			theme_advanced_resizing : true,
			setup : function(ed) {
				ed.onInit.add(function(ed, evt) {
	  				// adjust table element
	  				var elem = document.getElementById(ed.id + '_tbl');
	  				elem.style.height = '30px';
					// adjust iframe element
					var iframe = document.getElementById(ed.id + '_ifr');
						iframe.style.height = '30px';
						tinyMCE.dom.Event.add(tinyMCE.getInstanceById(ed.id).getWin(), "blur", function(){
							var formatSelectMenu = document.getElementById('menu_'+ed.id+'_'+ed.id+'_formatselect_menu');
							var fontSizeSelectMenu = document.getElementById('menu_'+ed.id+'_'+ed.id+'_fontsizeselect_menu');
							document.getElementById(ed.id+'_external').style.display='none';
							if(formatSelectMenu != null && formatSelectMenu.style.display ==='block'){
								document.getElementById(ed.id+'_external').style.display='block';
							}
							if(fontSizeSelectMenu != null && fontSizeSelectMenu.style.display ==='block'){
								document.getElementById(ed.id+'_external').style.display='block';
							}
	                });
				});
			}
		});
	} );
}

//adjust the position of tooltip based on the the size of document
function adjustHelpTooltipPosition($jQhoveredElem){
	var documentWidth 		= $jQ(document).width(); //retrieve current document width
	var currentPositionX 	= $jQhoveredElem.offset().left; // get the left position of element relative to document
	var tooltipWidthSize	= $jQhoveredElem.find( "span:first" ).width();
	if(documentWidth <= currentPositionX + tooltipWidthSize + 60){
		// get relative parent width
		var parentWidth = $jQhoveredElem.parent().width();
		// change the left atribute of the span
		$jQhoveredElem
		.find( "span:first" ).css({left: (parentWidth - 15)+ "px" }).end()
		.find( "img.MISSY_onsiteHelpCallout" ).attr('src', basepath + '/resources/images/onsiteHelpCalloutReverse.gif').addClass( "MISSY_onsiteHelpCalloutReverse" );
	}
}

function resetHelpTooltipPosition($jQhoveredElem){
	// reset back all changes from mousehover
	$jQhoveredElem.find( "span:first" ).css({left: "" }).end()
	.find( "img.MISSY_onsiteHelpCallout" ).attr('src', basepath + '/resources/images/onsiteHelpCallout.gif').removeClass( "MISSY_onsiteHelpCalloutReverse" );
}

// create editable text from span to textarea
function editableTextClicked() {
    var textContent = $jQ(this).html();
    var height = $jQ(this).height(); 
    var width = $jQ(this).parent().width();
    var inputId = $jQ(this).attr( "data-input-id" );
    var editableTextarea = $jQ("<textarea />",{ "data-input-id" : inputId,
    			"style" : "margin:0;padding:0 2px;max-width:none;max-height:none;width:" + 
    			width + "px;height:" + (height+4) + "px"});
    editableTextarea.val(textContent);
    // replace the span with textarea
    $jQ(this).replaceWith(editableTextarea);
    editableTextarea.focus();
    //ajust the size of textarea based on the content
    editableTextarea.keyup(ajustTextareaSize);
    // setup the blur event for new textarea
    editableTextarea.blur(editableTextBlurred);
}

// transform back editable text from textarea to static text on span
function editableTextBlurred() {
    var textContent = $jQ(this).val();
    var inputId = $jQ(this).attr( "data-input-id" );
    var spanText = $jQ("<span />",{ "data-input-id" : inputId }).addClass( "editableText" );
    spanText.html(textContent);
    // replace the textarea with span
    $jQ(this).replaceWith(spanText);
    // assign new value to the input hidden
    $jQ( "input[type=hidden]#" +inputId  ).val(textContent);
    // setup the click event for this new div
    spanText.click(editableTextClicked);
}

//run the currently selected effect
function runSaveEffect(infoText) {
	// get effect type from
	var selectedEffect = "scale";
	//var selectedEffect = $( "#effectTypes" ).val();
	// most effect types need no options passed by default
	var options = {};
	// some effects have required parameters
	if ( selectedEffect === "scale" ) {
		options = { percent: 100 };
	} else if ( selectedEffect === "size" ) {
		options = { to: { width: 280, height: 185 } };
	}
	// create the element
	var $jQelem = $jQ('<div/>', {
		    'html': '<h3>' + infoText + '</h3>'//<img src="' + basepath + '/resources/images/Check.png" />
		}).addClass('effect effectSave');
	// run the effect
	$jQelem.appendTo('body').show( selectedEffect, options, 100, effectSaveCallback($jQelem) );
}

//callback function to bring a hidden box back
function effectSaveCallback($jQelem) {
	setTimeout(function() {
		$jQelem.removeAttr( "style" ).fadeOut(1000, function(){
			$jQelem.remove();
		});
	}, 1000 );
}

// adjust the height of textarea based on the content on keyup
function ajustTextareaSize() {
	var scrollHeight = $jQ(this)[0].scrollHeight + 2;
	$jQ(this).css({ "height" : (scrollHeight) + "px"});
}

// sets the value-property for the given field
function setFieldValue( fieldId, value ) 
{
	if ( fieldId == undefined || fieldId == "" )
		return;

	var field = document.getElementById(fieldId);

	if (field == undefined)
		return;

	field.value = value;
}

/**
 * toggles the buttons, i.e. sets the <i>activeButton</i>-element on active and
 * deactives all buttons with the name <i>buttonGroupName</i>.
 * 
 * @param currentButton
 * @param buttonGroupName
 */
function toggleButtons( currentButton, buttonGroupName, cssClassname )
{
	if ( buttonGroupName == undefined || buttonGroupName.value == "" )
		return;
	
	if ( cssClassname == undefined || cssClassname == "" )
		// set default classname if neccessary
		cssClassname = "MISSY_altButton MISSY_altButton_medium MISSY_toggableButton";

	// finds all buttons that are activated
	var prevActive = $jQ( "input:button[class*='MISSY_altButton_active'][name='"+ buttonGroupName +"']:not([disabled])" );

	// reset all buttons in group, but do not reset if previous button equals current button
	if ( prevActive.length > 0 && prevActive[0] != currentButton )
		prevActive.toggleClass( 'MISSY_altButton_active' );

	// now activate the current button
	$jQ( currentButton ).toggleClass( 'MISSY_altButton_active' );
	
	// set hidden field for currentButton
	if ( $jQ( currentButton ).hasClass( 'MISSY_altButton_active' ) )
		updateValueOfButtonGroupHiddenField( buttonGroupName, currentButton.getAttribute( "value" ) );
	else
		updateValueOfButtonGroupHiddenField( buttonGroupName, "" );
		
}

/**
 * 
 */
function updateValueOfButtonGroupHiddenField( buttonGroupName, value ) 
{
	if ( buttonGroupName == null || buttonGroupName == undefined )
		return;
	
	var elementId = buttonGroupName.split("Button");
	
	if ( elementId.length == 0 )
		return;
	
	$jQ( "#"+ elementId[0] ).val( value );
}

function toggleButton(button, cssClassname) 
{
	if (button == undefined)
		return;

	if ( cssClassname == undefined || cssClassname == "" )
		cssClassname = "MISSY_altButton MISSY_altButton_medium";
	
	if (button.getAttribute("class") == cssClassname) 
	{
		button.setAttribute("class", cssClassname +" MISSY_altButton_active");
		button.setAttribute("className", cssClassname +" MISSY_altButton_active");
	} else 
	{
		button.setAttribute("class", cssClassname);
		button.setAttribute("className", cssClassname);
	}
}

/*
* This method toggles the service column (hides it if visible and shows it if hidden) 
* in the main content area.
*/
function toggleServiceColumn(toggleElement, toggleButton) {
	var toggleElement = $jQ(toggleElement);
	toggleElement.toggle();
	
	if ( toggleElement.visible() ) {
		$('contentMain').removeClassName('content_main_wide');
		$('contentMain').addClassName('content_main');
		
		$('contentRight').removeClassName('content_right_narrow');
		$('contentRight').addClassName('content_right');
	} else {
		$('contentMain').removeClassName('content_main');
		$('contentMain').addClassName('content_main_wide');
		
		$('contentRight').removeClassName('content_right');
		$('contentRight').addClassName('content_right_narrow');
	}
	
	$(toggleButton).setValue( toggleElement.visible() ? '>' : '<' );
}

// toggles the buttons and sends an ajax request to the backend to additional
// property settings
function showAttributes(study, level) 
{
	if ( study == undefined )
		return;
	
	if ( level == undefined )
		level = "";

	$jQ.ajax( {
		url: getContextPath() + "getAttributes",
		data: { attr: study, level: level },
		success: function( response, status, xhr ) 
		{
			if ( sessionInvalidated(xhr) ) return;
				
			$jQ( "#datasetDiv" ).html(response);
		}
	});
}

/**
 * Sends an ajax-request to /documentation/datapoints/
 * 
 * @param study
 */
function getDatapointInformation( element, studyGroup, study, dataSet )
{
	if ( studyGroup == undefined )
		return;
	
	$jQ( element ).parent().append( '<span class="data-point-loading"></span>' );
	
	var datapointPath = studyGroup;
	
	if ( study != undefined )
		datapointPath += "/"+ study;
	
	if ( dataSet != undefined )
		datapointPath += "/"+ dataSet;
	
	var level = $jQ( element ).attr( 'level' );
	
	$jQ.ajax( {
		url: getContextPath() + "documentation/datapoints/"+ datapointPath,
		data: { level: !!level ? level : '' },
	
		success: function( response, status, xhr ) 
		{
			if ( sessionInvalidated(xhr) ) return;
			
			if ( study != undefined )
				$jQ( "#dataSets" ).html(response);
			
			else
				$jQ( "#studies" ).html(response);
		}, 
		complete: function(){
			$jQ( "span.data-point-loading" ).remove();
		}
		
	});
}

var sessionInvalidated = function(xhr)
{
	// checking for response body
	if ( xhr.getResponseHeader("SESSION_INVALID") == "yes" ) 
	{
		alert("Where have you been?\n\nYour session has been expired. You will be redirected to login page.");
	
		window.location.href = getContextPath() + "login";
		return true;
	}
	
	return false;
};

function getContextPath() {
	var contextPathArr = window.location.pathname.split("/");
	
	if ( contextPathArr == undefined )
		return "/";
	
	if ( contextPathArr.length > 0 )
		return "/" + contextPathArr[1] + "/" + contextPathArr[2] + "/";
}

//used for creating loading impression on the variable details tab
// everytime the ajax call is executed
function createAjaxLoadingDiv( $divElement )
{
	// get the position of variable details tab
	var divPosition = $divElement.position();
	
	//create a div on top of tab element
	$jQ('<div/>', {
          id: 'ajax-load-background'
      }).addClass('ajax-loading-background')
      .css({'top':(divPosition.top+40) + 'px',
      		'left':divPosition.left + 'px',
      		'width':$divElement.width() + 'px',
      		'height':$divElement.height() + 'px'})
      .appendTo('body');
      
    $jQ('<div/>', {
          id: 'ajax-load-image'
      }).addClass('ajax-loading-image')
      .css({'top':(divPosition.top+40) + 'px',
      		'left':divPosition.left + 'px',
      		'width':$divElement.width() + 'px',
      		'height':$divElement.height() + 'px'})
      .appendTo('body');
}

// this function has a function for removing the loading div, after ajax call
function removeAjaxLoadingDiv(){
	$jQ('#ajax-load-image').remove();
	$jQ('#ajax-load-background').remove();
}

//used for creating loading impression on the variable details tab
//everytime the ajax call is executed
//elemSelector must have width and height
function createAjaxLoadingOnAjaxContainer( elemSelector )
{
	var $elem = $jQ( elemSelector );
	var elemOffset = $elem.offset();
	$jQ('<div/>', {
       id: 'ajax-load-background'
   }).addClass('ajax-loading-background')
   .css({'width': $elem.outerWidth() + 'px',
 		'height': $elem.outerHeight() + 'px',
  		'top': elemOffset.top + 'px',
  		'left': elemOffset.left + 'px'
  		})
   .appendTo( 'body' );
   
 $jQ('<div/>', {
       id: 'ajax-load-image'
   }).addClass('ajax-loading-image')
   .css({'width': $elem.outerWidth() + 'px',
 		'height': $elem.outerHeight() + 'px',
  		'top': elemOffset.top + 'px',
  		'left': elemOffset.left + 'px'})
   .appendTo( 'body' );
}

function alertDialogBox(
		targetSelector, textSelector, dialogText, 
		firstButtonLabel, firstFunction, 
		secondButtonLabel, secondFunction){
	$jQ( targetSelector ).dialog({
		modal: true,
		position: 'center',
		autoOpen: true,
		width: 580,
		open: function( event, ui ) {
			$jQ( textSelector ).html(dialogText);
		},
		buttons: [
		     {
		    	 text : firstButtonLabel,
		    	 click : firstFunction
		     },
		     {
		    	 text : secondButtonLabel,
		    	 click : secondFunction
		     }
		]
	});
}

/* this function check and add http:// to input string "linkUrl"
 * and then set the href of 'linkElem' when the link element is clicked
 * */
function checkAndAddHttpToUrl(linkElem, linkUrl){
	var pattern = /^((http|https|ftp):\/\/)/;

	if(!pattern.test(linkUrl)) {
		linkUrl = "http://" + linkUrl;
	}
	
	$jQ(linkElem).attr( "href" , linkUrl);
	return true;
}

/* showing then hiding an element for defined time */
function timeoutElementVisible($elem, timeSeconds){
	$elem.slideDown();
    setTimeout(function() {
    	$elem.slideUp();
    }, timeSeconds * 1000);
}
	
// ##### paste entries functionality

// handler for clicking 'Check All' in paste entries dialog
$jQ( document ).on( 'click', '#paste_entries_check_all', function()
{
	if ( $jQ(this).is(':checked') ) 
	{
		$jQ( '.referrencedField' ).each( function()
		{
			$jQ(this).prop( 'checked', true );
		});
		
		$jQ(this).next().text( 'Uncheck all' );
	}
	else 
	{
		$jQ( '.referrencedField' ).each( function()
		{
			$jQ(this).prop( 'checked', false );
		});
		
		$jQ(this).next().text( 'Check all' );
	}
});

/**
 * 
 */
var getPasteEntriesContent = function ( level, seriesName, country )
{
	createAjaxLoadingOnAjaxContainer( '#ajax_pasteEntries_'+ level );
	var pasteFromYear = $jQ( '#pasteEntries_year_'+ level ).val();
	
	if ( pasteFromYear == undefined || pasteFromYear == "null" ) 
	{
		$jQ('#ajax_paste_entries').html( "<div style='padding: 23px;'>No other years to paste from available.</div>" );
		return;
	}
	
	var url = getContextPath() +"getPasteEntriesFromContent/"+ level +"/"+ seriesName +"/"+ pasteFromYear + ( country != undefined ? "/"+ country : "" );
			
	$jQ.ajax( url )
  		.done(function(html) {
   			// succesfully request the content
   			$jQ( '#ajax_pasteEntries_'+ level ).html(html);
		})
	    .fail(function() {})
	    .always(function() {}); 
	//end of ajax call
};

/**
 * 
 */
var pasteEntries = function( level ) 
{
	var url = getContextPath() + "pasteEntriesFrom/"+ level;
	
	var pasteToAll = false;
	var selectedFields = '';
	var selectedYear = $jQ( '#pasteEntries_year_'+ level ).val();
	
	$jQ( '#ajax_pasteEntries_'+ level ).find( 'input:checked' ).each( function(){
		if( $jQ(this).val() !== 'on' )
			selectedFields += $jQ(this).val()+ ',';
	});
	
	if(selectedFields.length > 0 ) // remove last comma
		selectedFields = selectedFields.substring(0, selectedFields.length - 1);
		
	if($jQ('input#paste_entries_import_all').is(':checked')){
		pasteToAll = true;
	}
	
	// call ajax save function
	$jQ.ajax( {
		type: "post",
		url: url,
		data:{
			 fields : selectedFields,
			 selectedYear : selectedYear,
			 all	: pasteToAll
			}
	    })
    	.done( function() 
    	{
    		// reload content when finished
    		if ( level === "study" )
    			ajaxGetStudyGeneralDesc();
    		else if ( level === "study_csi" )
    			ajaxGetStudyCountrySpec();
		})
    	.fail( function() {})
    	.always( function() {}); //end of ajax call
};

$jQ( function()
{ 	//START JQUERY DOCUMENT READY
	
	// global function for toggable buttons
	$jQ( document ).on( 'click', '.MISSY_toggableButton', function()
	{
		toggleButtons( this, $jQ( this ).attr( 'name' ) );
	});
	
	// click on studyGroup button
	$jQ( document ).on( 'click', '.datapoint_studyGroup_button', function()
	{
		getDatapointInformation( this, this.value );
	});
	
	// click on study select-option list
	$jQ( document ).on( 'change', '#study', function()
	{
		var studyGroup = $jQ( "input:button[name='studyGroupButton'][class*='MISSY_altButton_active']" ).val();
		
		getDatapointInformation( this, studyGroup, this.value );
	});
	
	// click on dataset button
	$jQ( document ).on( 'click', '.datapoint_dataset_button', function()
	{
		var studyGroup = $jQ( "input:button[name='studyGroupButton'][class*='MISSY_altButton_active']" ).val();
		var study = $jQ( "#study" ).val();
		
		getDatapointInformation( this, studyGroup, study, this.value );
	});
	
	//build up the "semantic" link from documentation_selectionVariableDetails.ftl
	$jQ( "#button" ).click( function()
	{
		// validate field values first
		if ( validateDatapoint )
			if ( !validatationOfDatasetSucceed() )
				return false;
		
		var action = $jQ( this ).attr( "href" );
		var newAction = action +"/"+ $jQ( "#studyGroup" ).val();
		
		var year = $jQ( "#study" );
		var dataset = $jQ( "#dataSet" );
		var filetype = $jQ( "#dataFile" );
		
		if ( year.length > 0 && year.val() != "" )
			 newAction += "/"+ year.val();
		if ( dataset.length > 0 && dataset.val() != "" )
			 newAction += "/"+ dataset.val();
		if ( filetype.length > 0 && filetype.val() != "" )
			newAction += "/" + filetype.val();

		$jQ( this ).attr( "href", newAction );
		
		return true;
	});
	
	/**
	 * 
	 */
	validatationOfDatasetSucceed = function() 
	{
		var withoutErrors = true; 
		
		var study = $jQ( "#studyGroup" ).val();
		var dataset = $jQ( "#dataSet" ).val();
		var filetype = $jQ( "#dataFile" ).val();
		var agencyId = $jQ( "#agencyId" ).val();
		
		var elementId = "";
		
		if ( study == "" || study == "undefined" ) 
		{
			elementId = "#errorSpan_noStudy";
			withoutErrors = false;
		}
		
		if ( $jQ( "#dataSet" ).length > 0 && ( dataset == "" || dataset == "undefined" ) ) 
		{
			elementId = "#errorSpan_noDataset";
			withoutErrors = false;
		}
		
		if ( $jQ( "#dataFile" ).length > 0 && ( filetype == "" || filetype == "undefined" ) ) 
		{
			elementId = "#errorSpan_noFiletype";
			withoutErrors = false;
		}
		
		if ( $jQ( "#agencyId" ).length > 0 && ( agencyId == "" || agencyId == "undefined" ) ) 
		{
			elementId = "#errorSpan_noAgencyId";
			withoutErrors = false;
		}

		if ( !withoutErrors ) 
		{
			$jQ( elementId ).html( "Please do not miss to specify this value!" );
			$jQ( elementId ).effect( "pulsate" );
		}
		
		return withoutErrors;
	};
	
	
}); //END JQUERY DOCUMENT READY

function validateForm( $formElement ){
	var isValid = true;
	var $errorDiv = null;
	/*find input text with mandatory class*/
	$formElement.find( 'input[type="text"]' ).each(function () {
       	if ( ( $jQ(this).hasClass( "mandatory" ) && $jQ(this).val() === "") || $jQ(this).hasClass( "form-error" ) ) {
       		if( $jQ(this).val() === "" ){
       			$jQ(this).addClass( "form-error" );
       			if( $jQ(this).next( "div.errormsg" ).length == 0)
       				$jQ(this).after( '<div class="errormsg" style="margin-left:210px;display:inline-block">This field is mandatory.</div>' );
       		}	
       		isValid = false;
	 	}
    });
	
	/* check radio group button with mandatory class*/
	$formElement.find( 'input[type="radio"]' ).each(function () {
		
		if ( $jQ(this).hasClass( "mandatory" ) ) {
       		if( $jQ( ":radio[name=" + $jQ( this ).attr("name") + "]:checked").length == 0 ){
       			isValid = false;
       			$errorDiv = $jQ( '<div class="errormsg" style="margin-left:210px;display:inline-block">Please choose the options!!.</div>' );
       		}
	 	}
	});
	
	if( $errorDiv != null && $jQ( "div.errormsg" ).length == 0 )
		$formElement.append( $errorDiv );
	
	$jQ( "div.errormsg" ).effect( "pulsate" );
	
	return isValid;
}

/* NEW CODES FOR RDF-VALIDATION */

/** Get the details of file on the system
 *  
 */
function getDocumentDetails( url, filePath, $containerSelector, additionalPath){
	var $container = null;
	if ($containerSelector instanceof jQuery)
		$container = $containerSelector;
	else
		$container = $jQ( $containerSelector );
	
	// get previous content from textarea
	var previousSyntaxValue = "";
	/* if extended option not empty e.g. scroll textarea when new syntax added */
	var otherOptions = [];
	if( $container.find( "textarea.edit-syntax" ).length > 0){
		previousSyntaxValue = $container.find( "textarea.edit-syntax" ).val();
		$container.find( "div.highlight-syntax" ).hide();
		$container.find( "textarea.edit-syntax" ).show();
		var textareaScrollPosition = $container.find( "textarea.edit-syntax" )[0].scrollHeight - 60;
		if( textareaScrollPosition <= $container.find( "textarea.edit-syntax" ).height() - 60)
			textareaScrollPosition = 0;
		$container.find( "textarea.edit-syntax" ).hide();
		$container.find( "div.highlight-syntax" ).show();
		var highlightScrollPosition = $container.find( "div.highlight-syntax" )[0].scrollHeight - 60;
		if( highlightScrollPosition <= $container.find( "div.highlight-syntax" ).height() - 60)
			highlightScrollPosition = 0;
		otherOptions = [{ "option" : "scroll" , "params" : {"textareaScrollPosition" : textareaScrollPosition , "highlightScrollPosition" :  highlightScrollPosition } }];
	}
	
	if( additionalPath == "" ){
		$jQ.post( url, 
				{ filePath: filePath }
		).done(function( data) {
			if( $container.is( ":input" ))// if textarea
				$container.val( previousSyntaxValue + data.fileContent );
			else// if a div
				 createRdfOwlView( $container , previousSyntaxValue + data.fileContent , otherOptions);
	    });
	} else {
		$jQ.post( url, 
				{ filePath: filePath, additionalPath : additionalPath }
		).done(function( data) {
			if( $container.is( ":input" ))// if textarea
				$container.val( previousSyntaxValue + data.fileContent );
			else// if a div
				 createRdfOwlView( $container , previousSyntaxValue + data.fileContent , otherOptions);
	    });
	}
}

/**
 * Convert any input type files into jquery multiple file upload
 * $fileSelector - required - the input files must be jquery object
 * $progressSelector - required - the progress bar must be jquery object
 */
function convertToAjaxMultipleFileUpload( $inputFile, $progressBar , $resultContainer){
	var $container = null;
	if ($resultContainer instanceof jQuery)
		$container = $resultContainer;
	else
		$container = $jQ( $resultContainer );
	
	// get remove files url from input emelent attribute "data-remove-url"
	var fileRemoveUrl = $inputFile.attr( "data-remove-url" );
	
	$inputFile.fileupload({
        sequentialUploads: true,
        done: function (e, data) {
				//printUploadedFiles( $container, data.result , [{'option':'delete' ,'params' : {'url': fileRemoveUrl}}]);
        	$jQ( "#accordion_result_area" ).html( data.result );
        },
 
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $progressBar.find('.bar').css('width', progress + '%').html( progress + '%');
            $progressBar.show();
            if( progress == 100 )
            	window.setTimeout( function(){$progressBar.fadeOut( "slow" ); } , 3000);
        }
    });
}

/**
 * Get uploaded files (on memory) into jQuery accordion via ajax json
 * @param $containerSelector - required - the container, either jquery object or jquery selector
 * @param fileUrl - required - the get files url controller
 * @param fileUrl - required - the delete files url from controller
 */
function getUploadedDocument( $containerSelector, fileUrl, fileRemoveUrl ){
	var $container = null;
	if ($containerSelector instanceof jQuery)
		$container = $containerSelector;
	else
		$container = $jQ( $containerSelector );
	
	$jQ.ajax({
	  	url: fileUrl,
	  	dataType: 'json'
	}).done(function( data ) {
		if( data.length > 0 )
	 		printUploadedFiles( $container, data , [{'option':'delete' ,'params' : {'url': fileRemoveUrl}}]);
	});
}

/**
 * remove uploaded document from on memory file list and file itself
 */
function removeUploadedDocument( url, filename){
	$jQ.post( url, 
			{ filename: filename }
	).done(function( data) {
	    console.log( "file removed status : " + data );
    });
}

/**
 * Print uploaded files (on memory) into jQuery accordion
 * @param $containerSelector - required - the container, either jquery object or jquery selector
 * @param data - required - list of files in json
 * @param addedOptions - inJsonArrayFormat - default [] (empty json array)
 *        - structure e.g. [{
 *        						"option" : "delete"
 *        						"params" : {
 *        									"url" : "someurl"
 *        									}
 *        					}]
 */
function printUploadedFiles( $containerSelector, data , addedOptions){
	var $container = null;
	if ($containerSelector instanceof jQuery)
		$container = $containerSelector;
	else
		$container = $jQ( $containerSelector );
	
	$container.html("");
	
	/* if extended option not empty e.g. delete file option */
	var otherOptions = [];
		
	$jQ.each( data , function (index, file) {
 		// create the accordion & container 
		$container
        .append( 
        	$jQ('<h3/>').text( "- " + file.fileName).attr({ id:'header' + index }).css('cursor', 'pointer').on("click", function(){ $jQ( this ).next().slideToggle(); }) )
        .append(  $jQ('<div/>').attr({ id :'content' + index }).css('display', 'none') );
		
		// if other addedOptions not empty
		$jQ.each( addedOptions, function (i, item){
			if( item.option == "delete")
				otherOptions = [{ "option" : "delete" , "params" : {"url" : item.params.url , "fileName" :  file.fileName, "accordionHeaderId": "header" + index , "accordionContentId":  "content" + index } }];
		});
        // create the content
        createRdfOwlView( "#content" + index , file.fileContent , otherOptions );
    });
}

/**
 * Creating view (resizeable syntax editor textarea and syntax highlightor)
 * @param $containerSelector - required - the container, either jquery object or jquery selector
 * @param rdfOwlSyntax - required - (Notation 3, Turtle, N-Triples, TriG, N-Quads, SPARQL Query and SPARQL Update)
 * @param otherOptions - inJsonArrayFormat - default [] (empty json array)
 *        - structure e.g. [{
 *        						"option" : "delete",
 *        						"params" : {
 *        									"url" : "someurl",
 *        									"filePath" : "filePath"
 *        									}
 *        					}]
 */
function createRdfOwlView( $containerSelector , rdfOwlSyntax , otherOptions){
	var $container = null;
	if ($containerSelector instanceof jQuery)
		$container = $containerSelector;
	else
		$container = $jQ( $containerSelector );
	
	/* container for the content*/
	$htmlContent = $jQ('<div/>').css('width','100%');
	
	/*pop onsite help before filling container */
	 //check whether there is missy onsite help
	if( $container.find( "a.MISSY_onsiteHelp" ).length > 0){
		$container.before( $container.find( "a.MISSY_onsiteHelp" ) );
	}
	
	/* put into the parent  container*/
	$jQ( $container ).html( $htmlContent );
	
	$htmlContent
		.append(
				$jQ('<div />')
				.css({ 'width' : '100%' })
				.addClass( 'menuHeader' )
				.append(
					$jQ('<input/>').attr({ type: 'button' , value: 'Edit' })
					.addClass( 'buttonSubmit MISSY_loginSubmit editButton' )
					.css({ 'margin' : '0'})
					.on ( 'click', function () {
						var highlightScrollTop = $container.find( "div.highlight-syntax" )[0].scrollTop;
						$jQ( this ).parent().parent().find( "div.highlight-syntax" ).hide();
						$jQ( this ).parent().parent().find( "textarea.edit-syntax" ).show();
						$jQ( this ).parent().parent().find( "textarea.edit-syntax" ).scrollTop( highlightScrollTop );
						$jQ( this ).parent().parent().find( "input.viewButton" ).show();
						$jQ( this ).hide();
					})
				)
				.append(
					$jQ('<input/>').attr({ type: 'button' , value: 'View' })
					.addClass( 'buttonSubmit MISSY_loginSubmit viewButton' )
					.css({ 'margin' : '0'})
					.on ( 'click', function () {					
						var textareaScrollTop =  $container.find( "textarea.edit-syntax" )[0].scrollTop;
						$jQ( this ).parent().parent().find( "textarea.edit-syntax" ).hide();
						$jQ( this ).parent().parent().find( "div.highlight-syntax" ).show();
						hightlightRdfOwl( $jQ( this ).parent().parent().find( "div.highlight-syntax" ), $jQ( this ).parent().parent().find( "textarea.edit-syntax" ).val(), false , textareaScrollTop);
						$jQ( this ).parent().parent().find( "input.editButton" ).show();
						$jQ( this ).hide();
					})
				)
		)
		.append(
				$jQ('<div />')
				.css({'width': '100%', 'height' : '425px', 'min-height':'200px'})
				.addClass( 'syntaxBody' )
				.append(
						$jQ('<textarea/>').addClass( 'edit-syntax' ).val( rdfOwlSyntax )
						.css({'width': '99%', 'height' : "410px", 'resize' : ' none', 'padding' : '0.1em 0 0 0.1em' , 'line-height': '1.5em', 'font-family': 'monospace'})
						)
				.append(
						$jQ('<div/>').addClass('highlight-syntax')
						.css({'width': '99%', 'height' : "410px", 'display': 'none', 'background-color': '#fefefe','overflow':'auto','margin':'5px 0px', 'border': '1px solid #AAA','float':'left'})
						)
				.resizable({
					  resize: function( event, ui ) {
						  $jQ( this ).find( "textarea.edit-syntax" )
						  .css({ 'width' : (ui.element.width() - 8 ) + 'px' , 'height' : (ui.element.height() - 15 ) + 'px' });
						  $jQ( this ).find( "div.highlight-syntax" )
						  .css({ 'width' : (ui.element.width() - 8 ) + 'px' , 'height' : (ui.element.height() - 15 ) + 'px' });
						  $container.find( "div.menuHeader" )
		        	 	  .css({ 'width' : (ui.element.width() - 8 ) + 'px' });
					  }
				})	
			);
		
	// highlight scroll height
	var highlightScrollHeight = 0;
	
	// check whether otherOptions are available
	$jQ.each( otherOptions, function (i, item){
		// for delete file options
		if( item.option == "delete"){
			// get delete parameter
		
			$htmlContent.find( "div.menuHeader" ).prepend(
		    				$jQ('<input/>').attr({ type: 'button' , value: 'Delete' })
		    				.addClass( 'buttonSubmit MISSY_loginSubmit' )
		    				.css({ 'margin' : '0 20px 0 0', 'color': '#f00', 'float':'right'})
		    				.on ( 'click', function () {
		    					if( confirm("Delete " + item.params.fileName + "?") ){
		    					// remove accordion header
		    					$jQ( "#" + item.params.accordionHeaderId ).remove();
		    					// remove accordion body
		    					$jQ( "#" + item.params.accordionContentId ).remove();
		    					// delete via ajax post
		    					removeUploadedDocument(item.params.url, item.params.fileName);
		    					}
		    				})
	    				);
			
		}
		
		// for scroll options
		if( item.option == "scroll"){
			$container.find( "textarea.edit-syntax" ).scrollTop( item.params.textareaScrollPosition );
			highlightScrollHeight = item.params.highlightScrollPosition;
		}
	});
	
	 //check whether there is missy onsite help
	if( $htmlContent.parent().prev( "a.MISSY_onsiteHelp" ).length > 0){
		$htmlContent.parent().prev( "a.MISSY_onsiteHelp" ).css("float", "right").prependTo( $htmlContent.find( "div.menuHeader" ) );
	}
	
	// is syntay not empty - show preview
	if( rdfOwlSyntax != "" ){
		$elem = $container.find( "div.highlight-syntax" );
		//var w = $container.width() + "px";
		//$elem.css( 'width' , $container.find( "textarea.edit-syntax" ).width() + "px");
		hightlightRdfOwl( $elem , rdfOwlSyntax , true , highlightScrollHeight);
		$container.find( "input.viewButton" ).hide();
	} else {
		$container.find( "input.editButton" ).hide();
	}
}

/**
 * Create directory tree
 */
function createTree( $containerSelector, sectionType, syntaxContainerSelector, relativeDirectory ){
	var $container = null;
	if ($containerSelector instanceof jQuery)
		$container = $containerSelector;
	else
		$container = $jQ( $containerSelector );
	
	var containerId = $container.attr( "id" );
	
	$jQ.post( basepath + "/" + sectionType  +"/resource_structure" ,{ specificDirectory : relativeDirectory }, function( data ) {
				
			$container
			.append(
					$jQ('<div />')
					.css({ 'width' : '100%' })
					.addClass( 'menuHeader' )
					.append(
							$jQ('<input />')
							.attr({ type: 'checkbox', id: 'tree-toggle' + containerId })
							.css({ 'width' : '14px' , 'margin' : '0' })
							.change(function() {
								unfoldToggle( this, 'tree' + containerId);
							})
							)
					.append(
							"Unfold All"
							)
					)
			.append(
				$jQ('<div/>')
				.attr({ id: 'tree' + containerId })
				.css({ 'width' : '99%' , 'height' : '200px', 'min-height':'140px' })
				.addClass( 'tree-container' )
				.dynatree( 
				{
					selectMode: 2,
					children: data,
					onActivate: function(node) {
						if(!node.data.isFolder){
						 	getDocumentDetails( basepath + "/" + sectionType  +"/file_details", node.data.url, syntaxContainerSelector, relativeDirectory );
					 	}
		          	}
		         })
		         .resizable({
	        	 	resize: function( event, ui ) {
	        	 		$container.find( "div.menuHeader" )
	        	 		.css({ 'width' : (ui.element.width() ) + 'px' });
	        	 	}
		         })
			)
			.css({'width': '100%', 'height' : "240px", 'min-height':'180px'});
			
			 //check whether there is missy onsite help
			if( $container.prev( "a.MISSY_onsiteHelp" ).length > 0){
				$container.prev( "a.MISSY_onsiteHelp" ).css("float", "right").prependTo( $container.find( "div.menuHeader" ) );
			}
			
			// 500ms delay before automatically sort the tree ascending
			// this sort functionality should be activated by default in dynatree
			// resorted because of bug report - task dynatree not sorted remote
			setTimeout( 
				function(){
					var treeRoot = $jQ("#tree" + containerId).dynatree("getRoot");
					treeRoot.sortChildren(null, true);
				}
			, 500 );
			
	}, "json").fail(function(){}).always(function(){});
}


/**
 * toggle tree shrink and collapse when checkbox is checked
 */
function unfoldToggle(checkbox, treeId){
    if (checkbox.checked == true) {
        $jQ("#" + treeId).dynatree("getRoot").visit(function(node){
            node.expand(true);
        });
        return false;
    } else {
        $jQ("#" + treeId).dynatree("getRoot").visit(function(node){
            node.expand(false);
        });
        return false;
    }
}


/**
 *  Add highlight to these following syntax automatically
 *  Notation 3, Turtle, N-Triples, TriG, N-Quads, SPARQL Query and SPARQL Update
 *  This function only works iff there is an internet connection or you run the PHP locally in your system
 *  @param $elem - required - the container a jquery object
 *  @param rdfOwlSyntax - required - (Notation 3, Turtle, N-Triples, TriG, N-Quads, SPARQL Query and SPARQL Update)
 **/
function hightlightRdfOwl( $elem, rdfOwlSyntax , showAsMainView, highlightScrollHeight){
	// maximum number of character allowed per request
	var allowedCharacterLength = 7000;
	 
	var numberOfCharacter = 0;
	// split the textarea based on line break
	 var syntaxArray = rdfOwlSyntax.split( "\n" );

	 var syntaxForAjaxRequest = "";
	 var syntaxForAjaxRequestArray = [];
	 for( var i = 0; i < syntaxArray.length ; i++ ){
		 var numberOfCharacterInOneLine = encodeURI( syntaxArray[i] ).length;
		 numberOfCharacter += numberOfCharacterInOneLine;
		 if( numberOfCharacter < allowedCharacterLength ){
			 syntaxForAjaxRequest +=  syntaxArray[i] + "\n";
		 } else {
			 syntaxForAjaxRequestArray.push( syntaxForAjaxRequest );
			 syntaxForAjaxRequest = syntaxArray[i] + "\n";
			 numberOfCharacter = numberOfCharacterInOneLine;
		 }
		 // add the end of loop push
		 if( i == syntaxArray.length - 1 ){
			 syntaxForAjaxRequestArray.push( syntaxForAjaxRequest );
		 }
	 }
	 // clear the container
	 $elem
	  .html( "" );
	  //.css( "width" , ($elem.parent().width() - 7) + "px");
	 
	 // highlight syntax via ajax
	 highlightSplittedSyntax( $elem, syntaxForAjaxRequestArray , showAsMainView, 0 ,highlightScrollHeight);
	 
}

// get the syntax highlighted syncrounously by call it recursively
function highlightSplittedSyntax( $elem, syntaxForAjaxRequestArray , showAsMainView, arrayIndex , highlightScrollHeight){
	var jsonpUrl = "http://n3edit.eu01.aws.af.cm/ajax-highlight.php?callback=?";
	// you also can run the PHP files for hignlighting the syntax locally.
	// install XAMPP/WAMPP and put and run the n3edit project into your local server
	// test whether is it running or not and uncomment this new URL
	// jsonpUrl = "http://localhost/n3edit/ajax-highlight.php?callback=?";
	
	// JSONP cross domain ajax call
	$jQ.getJSON( jsonpUrl, {
	    input: syntaxForAjaxRequestArray[ arrayIndex ],
	    format: "jsonp"
	  })
	  .done(function( data ) {
		  // append highlighted syntax
		  //$elem.append( (data.html).replace(new RegExp("\n", "gi"), '<span class="lh15">&nbsp;</span>\n') );
		  $elem.append( data.html );
		  
		  if( showAsMainView && arrayIndex == 0 ){
			  $elem.siblings( "textarea.edit-syntax" ).hide();
			  $elem.css( "width" , ($elem.parent().parent().parent().parent().width() - 7) + "px");
			  $elem.show();
			  // scroll to new input
			  if( highlightScrollHeight > 0 )
				  $elem.animate({ scrollTop: highlightScrollHeight }, 1000);
		  }
		  
		  if( !showAsMainView && arrayIndex == syntaxForAjaxRequestArray.length - 1 )
			  $elem.scrollTop( highlightScrollHeight );
			  
		  // call method recursively
		  if( arrayIndex + 1 < syntaxForAjaxRequestArray.length ){
			  highlightSplittedSyntax( $elem, syntaxForAjaxRequestArray , showAsMainView, arrayIndex + 1 , highlightScrollHeight);
		  }
	  }).fail(function() {
		  $elem.html( "<span style='color:#f00'>Error - no internet connection!</span>" );
	  });
}

