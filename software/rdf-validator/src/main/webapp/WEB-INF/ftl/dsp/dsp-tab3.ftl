<form style="padding-left: 25px"  id="form-dsp-tab3" action="<@spring.url '/dsp/ngraph/tab3' />" class="MISSY_round_right">

	<fieldset>

		<ul style="margin: 0;">
	    	<li style="list-style-type: disc;">please enter your data
	    	
	    	</li>
	    	<li style="list-style-type: disc;">please use W3C RDF turtle syntax</li>
	    </ul>
	    
	    <hr/>
	    
		<ul style="margin: 0;">
	    	<li style="list-style-type: disc;">you may upload a file containing data</li>
	    </ul>
	
		<table>
	        <tr style="background:transparent">
	            <td style="width:50%">
	            	<input id="fileupload3" style="width:100%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/dsp/upload' />" multiple />
				</td>
	            <td>
	            	<div id="progress3" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>
	    
	    <hr/>
	
		<#-- form onsite help -->
			<a href="#" class="MISSY_onsiteHelp" style="margin:0 0 0 ß0px;vertical-align:top;">
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
				<span style="width:350px;">
					<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
					<h4 class="MISSY_onsiteHelp">Constraints</h4>
					<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
				    <ul style="margin: 0;">
				    	<li style="list-style-type: disc;">you may adjust the height and the width of the textarea by dragging the small arrow at the right end of the textarea</li>
				    </ul>
				</span>
			</a>
			
	  	<div id="containerData"></div>	
	  	<input type="hidden" name="data" id="data" />
	 
	</fieldset>
	
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_dsp-tab3" 
		  id="button_dsp-tab3" 
		  value="Next: Inference Rules" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>
	
</form>

<script>
  	$jQ(function() {
    	$jQ("#text_output")
		  .wrap('<div/>')
		    .css({'overflow':'hidden'})
		      .parent()
		        .css({'display':'inline-block',
		              'overflow':'hidden',
		              'height':function(){return $jQ('#text_output',this).height();},
		              'width': '100%',
		              'paddingBottom':'12px',
		              'paddingRight':'12px'
		
		             }).resizable({
		             	grid: [10000, 1]
		             })
		                .find('#text_output')
		                  .css({overflow:'auto',
		                        width:'100%',
		                        height:'100%'});
		  	
		  	
  		<#-- show empty textarea -->
	    createRdfOwlView( "#containerData" , ""  , [] );
	    
	    <#-- file upload-->
	    
		$jQ('#fileupload3').fileupload({
	        dataType: 'json',
	 
	        done: function (e, data) {
	         	createRdfOwlView( "#containerData" , data.result.fileContent , [] );
	        },
	 
	        progressall: function (e, data) {
	            var progress = parseInt(data.loaded / data.total * 100, 10);
	            $jQ('#progress3 .bar').css('width', progress + '%').html( progress + '%');
	        	$jQ('#progress3').show();
	            if( progress == 100 )
	            	window.setTimeout( function(){$jQ('#progress3').fadeOut( "slow" ); } , 3000);
	        }
	    });
    });
 </script>