
<#macro createButton value="Button" class="simpleButton" name="button" onClick="" style="">
	<#nested />
	<input type="button" class="${class}" onClick="${onClick}" value="${value}" name="${name}" style="${style}" />
</#macro>

<#macro createToggledButton value="Button" valueCurrent="" valueWhenActive="" class="simpleButton" name="button" onClick="" style="" addClass="">
	
	<#if valueCurrent = valueWhenActive>
		<#assign newClass = class + " MISSY_altButton_active">
	<#else>
		<#assign newClass = class>
	</#if>
	
	<#if addClass != "">
		<#assign newClass = newClass +" "+ addClass> 
	</#if>

	<@createButton value newClass name onClick style />
</#macro>

<#macro createSubmitButton name="submit" id="${name}" value="Button" class="simpleButton" style="">
	<input type="submit" class="${class}" value="${value}" name="${name}" style="${style}" />
</#macro>

<#macro createTextfield name="" value="" class="textfield" style="">
	<input type="text" class="${class}" value="${value}" name="${name}" id="${name}" style="${style}" />
</#macro>

<#macro createPasswordTextfield name="" class="textfield" style="">
	<input type="password" class="${class}" value="" name="${name}" id="${name}" style="${style}" />
</#macro>

<#macro createTextarea name="" id="${name}" class="textarea" rows="3" style="">
	<textarea name="${name}" id="${id}" class="${class}" rows="${rows}" style="${style}"></textarea>
</#macro>

<#macro createDropDownBox id="default" name="" options=[] values=[] onChange="" selectedValue="" blankEntry=false size="1" class="">
	<#nested />

	<#if !name??>
		<#assign name = id>
	</#if>
	
	<select id="${id}" name="${name}" size="${size}" onChange="${onChange}" class="${class}">
		<#if blankEntry == true>
			<option value=""></option>
		</#if>
		
		<#list options as option>
			<#assign value = "${values[option_index]}" >
			
			<#if value == selectedValue>
				<#assign selected = "selected='selected'">
			<#else>
				<#assign selected = "">
			</#if>
				
			<option value="${value}" ${selected}>${option}</option>
		</#list>
	</select> 
	
</#macro>

<#macro createCheckbox name="checkbox" checked="" value="" style="">
	<#if checked != "">
		<input type="checkbox" name="${name}" value="${value}" checked="${checked}" style="${style}" />
	<#else>
		<input type="checkbox" name="${name}" value="${value}" style="${style}" />
	</#if>		
</#macro>

<#macro insertBindingFor name="" showErrors=true>
	<@spring.bind "${name}" />
	
	<#if showErrors>
		<#if spring.status.error>
			<span class="requiredFieldMissing">
				<@spring.showErrors "" /> 
			</span>
		</#if>
	</#if>
</#macro>

<#macro createHiddenField id="" value="">
	<input type="hidden" id="${id}" name="${id}" value="${value}" />
</#macro>

<#--
	Creates an <a href=".."> and a invisible layer so that with mouseover the onsitehelp is shown. 
-->
<#macro createFormOnsiteHelp title helpText="">
	<#if helpText != "">
		<#assign text >
			<@spring.message "${helpText}"/>
		</#assign>
		<a href="#" class="MISSY_onsiteHelp">
			<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_iconOnsitehelp" />
			<span> 
				<img class="MISSY_onsiteHelpCallout" src="<@spring.url '/resources/images/onsiteHelpCallout.gif' />"> 
				<h4 class="MISSY_onsiteHelp">${title}</h4>
				<img src="<@spring.url '/resources/images/gs_icon.question_blue.png' />" class="MISSY_onsiteHelpHeaderIcon" /><br clear="all">
				${text}
			</span>
		</a>
	</#if>
</#macro>

