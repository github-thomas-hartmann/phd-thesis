
<#macro left>
	<!-- Column 1 Side menu -->
	<div id="col1"> 
		<#nested />
	<!-- End of col1 --> 
	</div>
</#macro>

<#macro right style="">
	<!-- Column 2 right -->
	<div id="col2">
		<#nested />
	<!-- End of col2 --> 
	</div>
</#macro>

<#macro main style="">
	<!-- Column 3 main content middle -->
	<div id="col3">
		<#nested />
	<!-- End of col3 --> 
	</div>
</#macro>