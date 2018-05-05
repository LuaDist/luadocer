<% luadoc.doclet.html.include("header.lp", {title="Project code quality", doc=doc, file_doc={name="dummy"}, location={{"Project metrics","index.html"}}, extra_javascript = {'highcharts.js', 'jquery-ui.min.js'}, extra_css = {'jquery-ui-1.8.11.custom.css', 'indexOfFunctions.css'}}) %>

	<script type="text/javascript">
		$(document).ready(function() {	
			$('.rollVariable').click(toggler);
			$("#tabs").tabs();
		});
	
		function toggler() {
			var rollable = $(this)
			var elem = $(rollable).next().next().next()
			if ($(elem).is(":hidden")) {
				$(elem).slideDown();
				rollable.text('[-]')
			} else {
				$(elem).slideUp();
				rollable.text('[+]')
			}
		}
		
	</script>
	
<h1>Project code quality </h1>

<p>Metrics used to determine the quality of the source code</p>


<div id="tabs">
	<ul>
		<li><a href="#moduleSmells"><span>Module Smells</span></a></li>
		<li><a href="#longMethod"><span>Long Method</span></a></li>
		<li><a href="#manyParameters"><span>Many Parameters</span></a></li>	
		<li><a href="#longLines"><span>Long lines</span></a></li>	
		<li><a href="#tablesWithManyFields"><span>Table with many fields</span></a></li>	
		<li><a href="#functionDepth"><span>Function depth</span></a></li>	
		<li><a href="#tableDepth"><span>Table depth</span></a></li>	
		<li><a href="#upvaluesTable"><span>Upvalues</span></a></li>			
	</ul>

    <div id="moduleSmells">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Maintainability index (MI)</h2>
				<div style="float:left; display: block">
					<p>
						MI = 171 - 5.2ln(<b>aV</b>) - 0.23<b>aV(g')</b> - 16.2ln(<b>aLOC</b>) - 50sin[sqrt(2.4 - <b>perCM</b>)] <br />
						<ul>
							<li><b>aV</b> = average Halstead volume V per module</li>
							<li><b>aV(g')</b> = average cyclomatic complexity per module</li>
							<li><b>aLOC</b> = average count of lines of code (LOC) per module</li>
							<li><b>perCM</b> = average percent of lines of comments per module</li>
						</ul>
					</p>
					<%=MITable%>
				</div>
				<div style="clear:both;"></div>
				<h2>Code flagged and investigated for possible refactoring</h2>
				<div style="float:left; display: block; width: 500px">
					<p>
						In 1999, Rosenberg et al. of NASA published guidelines specifying that any class that meets at least two of the following criteria needs to be flagged and investigated for possible refactoring:
						<ul>
							<li><b>Response for module</b> > 100</li>
							<li><b>Coupling between modules</b> > 5</li>
							<li><b>Response for module</b> > 5 times the <b>number of methods</b> in the module</li>
							<li><b>Weighted methods per module</b> > 100</li>
							<li><b>Number of methods</b> > 40</li>
							<li><b>Number of long lines</b> > 10</li>
							<li><b>Number of tables with many fields</b> > 1</li>
							<li><b>Number of function with high nesting level</b> > 1</li>
							<li><b>Number of tables with high nesting level</b> > 1</li>
							<li><b>Number of upvalues</b> > 5</li>
						</ul>
					</p>
					<%=moduleTables%>
				</div>
				<div style="clear:both;"></div>
			</div>
		</span>
	</div>

	<div id="longMethod">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Metrics in Code Smells</h2>
					<div style="float:left; width: 330px;">
						<%=longMethodTable%>
						<%=cycloTable%>
					</div>
					<div style="clear:both;"></div>
				<h2>Graphical representation</h2>
					<hr/>
					<p>Criteria for detecting long method code smell:</p>
					<p>Lines of source code</p>
					<ul>
						<li><b><45 lines of source code:</b> No smell detected <font color="green">(Green)</font></li>
						<li><b><55 but >45 lines of source code:</b> Code smell detected <font color="orange">(Orange)</font></li>
						<li><b>>55 lines of source code:</b> Serious code smell detected <font color="red">(Red)</font></li>
					</ul>
					<p>Cyclomatic complexity</p>
					<ul>
						<li><b>1 - 4:</b> A simple procedure <font color="green">(Green)</font></li>
						<li><b>5 - 10:</b> A well-structured and stable procedure <font color="green">(Green)</font></li>
						<li><b>11 - 20:</b> A more complex procedure <font color="orange">(Orange)</font></li>
						<li><b>21 - 50:</b> A complex procedure, worrisome <font color="red">(Red)</font></li>
						<li><b>>50:</b>	An error-prone, extremely troublesome, untestable procedure <font color="red">(Red)</font></li>
					</ul>
					<%=longMethodGraph%>
					<%=cycloGraph%>
					<div style="clear: both;"></div>
			</div>
		</span>
	</div>

	<div id="manyParameters">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Metrics in Code Smells</h2>
					<div style="float:left; width: 330px;">
						<%=manyParamsTable%>
					</div>
					<div style="clear:both;"></div>
					<br />
				<h2>Graphical representation</h2>
					<hr/>
					<p>Criteria for detecting many parameters code smell</p>
					<ul>
						<li><b><5 parameters:</b> No smell detected <font color="green">(Green)</font></li>
						<li><b><10 but >5 parameters:</b> Code smell detected <font color="orange">(Orange)</font></li>
						<li><b>>10 parameters:</b> Serious code smell detected <font color="red">(Red)</font></li>
					</ul>
					<%=manyParamsGraph%>
					<div style="clear: both;"></div>
			</div>
		</span>
	</div>	

	<div id="longLines">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Metrics in Code Smells</h2>
					<div style="float:left; width: 330px;">
						<%=longLinesTable%>
					</div>
					<div style="clear:both;"></div>
					<br />
				<h2>Graphical representation</h2>
					<hr/>
					<p>Criteria for detecting long lines code smell</p>
					<ul>
						<li><b><2 long lines:</b> Code smell detected <font color="green">(Green)</font></li>
						<li><b><7 but >2 long lines:</b> Medium code smell detected <font color="orange">(Orange)</font></li>
						<li><b>>7 long lines:</b> Serious code smell detected <font color="red">(Red)</font></li>
					</ul>
					<%=longLinesGraph%>
					<div style="clear: both;"></div>
			</div>
		</span>
	</div>	

	<div id="tablesWithManyFields">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Metrics in Code Smells</h2>
					<div style="float:left; width: 330px;">
						<%=tablesWithManyFieldsTable%>
					</div>
					<div style="clear:both;"></div>
					<br />
				<h2>Graphical representation</h2>
					<hr/>
					<p>Criteria for detecting table with many fields code smell</p>
					<ul>
						<li><b><2 tables:</b> Code smell detected <font color="green">(Green)</font></li>
						<li><b><7 but >2 tables:</b> Medium code smell detected <font color="orange">(Orange)</font></li>
						<li><b>>7 tables:</b> Serious code smell detected <font color="red">(Red)</font></li>
					</ul>
					<%=tablesWithManyFieldsGraph%>
					<div style="clear: both;"></div>
			</div>
		</span>
	</div>	

	<div id="functionDepth">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Metrics in Code Smells</h2>
					<div style="float:left; width: 330px;">
						<%=functionDepthTable%>
					</div>
					<div style="clear:both;"></div>
					<br />
				<h2>Graphical representation</h2>
					<hr/>
					<p>Criteria for detecting function depth code smell</p>
					<ul>
						<li><b><2 functions:</b> Code smell detected <font color="green">(Green)</font></li>
						<li><b><7 but >2 functions:</b> Medium code smell detected <font color="orange">(Orange)</font></li>
						<li><b>>7 functions:</b> Serious code smell detected <font color="red">(Red)</font></li>
					</ul>
					<%=functionDepthGraph%>
					<div style="clear: both;"></div>
			</div>
		</span>
	</div>	

	<div id="tableDepth">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Metrics in Code Smells</h2>
					<div style="float:left; width: 330px;">
						<%=tableDepthTable%>
					</div>
					<div style="clear:both;"></div>
					<br />
				<h2>Graphical representation</h2>
					<hr/>
					<p>Criteria for detecting table depth code smell</p>
					<ul>
						<li><b><2 tables:</b> Code smell detected <font color="green">(Green)</font></li>
						<li><b><7 but >2 tables:</b> Medium code smell detected <font color="orange">(Orange)</font></li>
						<li><b>>7 tables:</b> Serious code smell detected <font color="red">(Red)</font></li>
					</ul>
					<%=tableDepthGraph%>
					<div style="clear: both;"></div>
			</div>
		</span>
	</div>	

	<div id="upvaluesTable">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Metrics in Code Smells</h2>
					<div style="float:left; width: 330px;">
						<%=upvaluesTable%>
					</div>
					<div style="clear:both;"></div>
					<br />
				<h2>Graphical representation</h2>
					<hr/>
					<p>Criteria for detecting upvalues code smell</p>
					<ul>
						<li><b><5 variables:</b> Small code smell detected <font color="green">(Green)</font></li>
						<li><b><10 but >5 variables:</b> Medium code smell detected <font color="orange">(Orange)</font></li>
						<li><b>>10 variables:</b> Serious code smell detected <font color="red">(Red)</font></li>
					</ul>
					<%=upvaluesGraph%>
					<div style="clear: both;"></div>
			</div>
		</span>
	</div>	

</div>

<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>

