<#macro global>
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>RDF Validator</title>
	<#include "libsNstyles.ftl" />
</head>

<body>

	<div class="page_margins" id="page_margins">
		<div class="page" id="page"> 
			<!-- Header -->
			<div id="header">
				<#include "header.ftl" />
			</div>
			
			<!-- Banner for microsite -->
			<div id="microsite" style="background-image: url(<@spring.url '/resources/images/missy_ms_ImpApp.png' />);">
				<span id="micrositeClaim" style="color: #000">
					<!--MSG: microsite.header-->
					RDF Validator
				</span>
			<!-- End of banner --> 
			</div>
			
			<!-- Main Navigation -->
			 <div id="nav">
			 	<a id="navigation" name="navigation"></a>
				<#include "mainNavigation.ftl" />
			</div>
			
			<!-- Main Content -->
			<div id="main">
				<#nested />
			</div>
		</div>
	</div>

</body>

</html>

</#macro>