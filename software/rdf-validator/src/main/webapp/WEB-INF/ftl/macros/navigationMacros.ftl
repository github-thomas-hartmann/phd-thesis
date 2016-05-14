<#macro insertImportSpssNavigation>
	<!-- Column 1 Content -->
	<div id="col1_content" class="clearfix">
		<ul id="submenu">
			<li>
			<#if navItem?? & navItem == 'variables'>
				<a href="<@spring.url '/spss/variables/import' />" style="padding:0; border: none">
					<strong>Import a Variable List</strong>
				</a>
			<#else>
				<a href="<@spring.url '/spss/variables/import' />">
					Import a Variable List
				</a>
			</#if>
			</li>
			<li>
			<#if navItem?? & navItem == 'frequencies'>
				<a href="<@spring.url '/spss/frequencies/import' />" style="padding:0; border: none">
					<strong>Frequency Import (initial)</strong>
				</a>
			<#else>
				<a href="<@spring.url '/spss/frequencies/import' />">
				Frequency Import (initial)
				</a>
			</#if>
			</li>
		</ul>
	</div>
	<!-- End of col1_content --> 
</#macro>