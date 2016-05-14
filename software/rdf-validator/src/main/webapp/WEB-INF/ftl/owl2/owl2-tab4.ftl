<form id="form-owl2-tab4" action="<@spring.url '/owl2/tab4' />" style="padding-left: 25px" class="MISSY_round_right">

	<fieldset>
	  	
		<textarea 
		  name="inferenceRules" 
		  id="inferenceRules" 
		  class="mandatory MISSY_textarea_resize" 
		  cols="50" 
		  rows="20" 
		  style="width:63%"
		  onkeyup="adaptHeight( $jQ( this ) );"></textarea>
		  
		<#-- form onsite help -->
		<a href="#" class="MISSY_onsiteHelp" style="margin-top:-20px">
			<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
			<span>
				<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />">
				<h4 class="MISSY_onsiteHelp">Inference Rules</h4>
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
				Inference Rules
			</span>
		</a>
	  	
	</fieldset>
	
	<br />
	<hr />
	
	<fieldset>
		<input 
		  type="button" 
		  name="button_owl2-tab4" 
		  id="button_owl2-tab4" 
		  value="Next: Check Constraints" 
		  class="buttonSubmit MISSY_loginSubmit" 
		  style="float: right; margin-top: 10px">
	</fieldset>
	
</form>	

<script>

</script>