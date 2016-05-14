 <@layout.global>
 	
 	<@content.main>

		<div id="MISSY_breadcrumb"></div>
		<div id="col3_content" class="clearfix">
			<div class="floatbox"> 
			
				<h1>RDF Validation</h1>
			
				<hr/>
			
				<p>
				
					<h4>Validating constraint languages:</h4>
					<ul>
						<li><a href="http://www.w3.org/TR/owl2-syntax/">Web Ontology Language 2 (OWL 2)</a></li>
						<li><a href="http://dublincore.org/documents/2008/03/31/dc-dsp/">Description Set Profiles (DSP)</a></li>
					</ul>
				
				</p>
				
				<hr/>
				
				<p>
					<h4>Authors:</h4>
					<ul>
						<li><a href="http://boschthomas.blogspot.com/">Thomas Bosch (GESIS – Leibniz Institute for the Social Sciences, Mannheim, Germany; thomas.bosch@gesis.org)</a></li>
						<li><a href="http://dws.informatik.uni-mannheim.de/en/people/researchers/dr-kai-eckert/">Kai Eckert (Research Group Data and Web Science, University of Mannheim, Germany;  kai@informatik.uni-mannheim.de)</a></li>
					</ul>
				</p>
				
				<hr/>
				
				<p>
					<h4>Research paper about RDF validation:</h4>
					<ul>
						<li>
							<a 
							  href="https://github.com/boschthomas/PhD/tree/master/publications/Papers%20in%20Conference%20Proceedings">
							  Bosch, Eckert. Towards Description Set Profiles for RDF using SPARQL as Intermediate Language (DC 2014)
							</a>
						</li>
						<li>
							<a 
							  href="https://github.com/boschthomas/PhD/tree/master/publications/Papers%20in%20Conference%20Proceedings">
							  Bosch, Eckert. Requirements on RDF Constraint Formulation and Validation (DC 2014)
							</a>
						</li>
					</ul>
				</p>
				
				<hr/>
				
				<p>
					<h4>Constraint validation process:</h4>
					<img src="<@spring.url '/resources/images/constraint-validation-process.png' />" alt="Constraint Validation Process" style="">
				</p>
				
				<hr/>
				
				<p>
					<h4>SPIN mappings</h4>
					<ul>
						<li><a href="https://github.com/boschthomas/OWL2-SPIN-Mapping">Web Ontology Language 2 (OWL 2)</a></li>
						<li><a href="https://github.com/dcmi/DSP-SPIN-Mapping">Description Set Profiles (DSP)</a></li>
					</ul>
				</p>
				
				<hr/>
				
				<p>
					<h4>RDF validation requirements database</h4>
					<ul>
						<li><a href="http://purl.org/net/rdf-validation">http://purl.org/net/rdf-validation</a></li>
					</ul>
				</p>
				
				<hr/>
				
				<p>
					<h4>Links</h4>
					<ul>
						<li><a href="http://purl.org/net/rdf-validation">Database of Requirements on RDF Constraint Formulation and Validation</a></li>
						<li><a href="http://www.w3.org/2014/data-shapes/charter">W3C RDF Data Shapes Working Group Charter</a></li>
						<li><a href="http://wiki.dublincore.org/index.php/RDF-Application-Profiles">RDF Application Profiles Task Group</a></li>
					</ul>
				</p>
			
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
		$jQ( "#col3" ).css( "margin", "0 0 0 150px");
	}); // end of document ready
</script>