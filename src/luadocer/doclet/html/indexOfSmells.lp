<% luadoc.doclet.html.include("header.lp", {title="Project code quality", doc=doc, file_doc={name="dummy"}, location={{"Project metrics","index.html"}}, extra_javascript = {'highcharts-bar.js', 'jquery-ui.min.js'}, extra_css = {'jquery-ui-1.8.11.custom.css', 'indexOfFunctions.css'}}) %>

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
		<li><a href="#longMethod"><span>Long Method</span></a></li>
		<li><a href="#manyParameters"><span>Many Parameters</span></a></li>	
	</ul>

    	<div id="longMethod">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Metrics in Code Smells</h2>
					<div style="float:left; width: 330px;">
						<%=luadoc.doclet.html.include("smells/longMethodTable.lp", { smells = smells.longMethod })%>
					</div>
					<div style="clear:both;"></div>
					<br />
				<h2>Graphical representation</h2>
					<%=luadoc.doclet.html.include("smells/longMethodGraph.lp", { smells = smells })%>
					<br />
					<div style="clear: both;"></div>
			</div>
		</span>
	</div>
	<div id="manyParameters">
		<span class="tohide">
			<div class='metrics_wrapper'>
				<h2>Metrics in Code Smells</h2>
					<div style="float:left; width: 330px;"><%=luadoc.doclet.html.include("smells/manyParametersTable.lp", { smells = smells.manyParameters })%>
					</div>
					<div style="clear:both;"></div>
					<br />
				<h2>Graphical representation</h2>
					<%=luadoc.doclet.html.include("smells/manyParametersGraph.lp", { smells = smells })%>
					<br />
					<div style="clear: both;"></div>
			</div>
		</span>
	</div>	
</div>

<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>

