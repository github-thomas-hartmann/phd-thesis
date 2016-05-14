<#-- <#assign security=JspTaglibs["http://www.springframework.org/security/tags"] /> -->

<div id="topnav">
	<#--
	<#if rc.locale == "de_DE">
		<img src="<@spring.url '/resources/images/gs_flag_${rc.locale}.gif' />" alt="de" />
		<a class="language" href="?lang=en_UK">
			<img src="<@spring.url '/resources/images/gs_inv_flag_${rc.locale}_dark.gif' />" alt="en" style="margin-right: 20px;"/>
		</a>
	<#else>
		<a class="language" href="?lang=de_DE">
			<img src="<@spring.url '/resources/images/gs_inv_flag_${rc.locale}_dark.gif' />" alt="de"/>
		</a>
		<img src="<@spring.url '/resources/images/gs_flag_${rc.locale}.gif' />" alt="en" style="margin-right: 20px;"/>
	</#if>
	-->
	
	<#--
	<@security.authorize access="isAuthenticated()">
		<span style="margin-right: 13px;">${study.userName}</span><a class="link" href="<@spring.url '/logout' />">Logout</a>
	</@security.authorize>
	
	<@security.authorize access="isAnonymous()">
		<a class="link" href="login">Login</a>
	</@security.authorize>
	-->
</div>	

<!-- GESIS logo with link to main-homepage --> 
<a href="http://www.gesis.org">
	<!--
	<img class="headImg1" width="420" height="50" border="0" title="Gesis" alt="" src="<@spring.url '/resources/images/gs_logo_microsite.jpg' />" />
	-->
</a> 

<#--include session warning alert /-->

<#-- <#include "sessionTimeOut.ftl" /> -->