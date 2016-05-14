<form style="padding-left: 25px"  id="form-owl2-tab3" action="<@spring.url '/owl2/tab3' />" class="MISSY_round_right">

	
	<fieldset>
	
	  	<textarea name="data" cols="50" rows="20"></textarea>	 
	  	
		<#-- form onsite help -->
		<a href="#" class="MISSY_onsiteHelp" style="margin-top:-20px">
			<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
			<span>
				<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
				<h4 class="MISSY_onsiteHelp">Data</h4>
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
				Data
			</span>
		</a>
	 
	</fieldset>
	
	<br />
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_owl2-tab3" 
		  id="button_owl2-tab3" 
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
		  	});
 </script>