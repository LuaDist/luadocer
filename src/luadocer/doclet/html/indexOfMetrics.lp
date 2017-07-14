<% luadoc.doclet.html.include("header.lp", {title="Project metrics", doc=doc, file_doc={name="dummy"}, location={{"Project metrics","index.html"}}, extra_javascript = {'highcharts.js'}}) %>

<script type="text/javascript">
		$(document).ready(function() {	
			$('.rollVariable').click(toggler);
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
	
<h1>Project metrics </h1>

<p>Here are shown some metrics of the project</p>

<div class='metrics_wrapper'>

	<h2>Metrics</h2>

	<div style="float:left; width: 350px;">

		<%=docMetricsTable%>
		<%=LOCTable%>
		<%=halsteadTable%>
		<%=statementsTable%>
		
	</div>

	<%=functionsTable%>

	<div style="clear:both;"></div>

	<%=couplingTable%>

	<div style="clear:both;"></div>

	<hr />
	
	<%=moduleLenGraph%>
	
	<%=fileLenGraph%>

	<div style="clear: both;"></div>
	
</div>
<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
