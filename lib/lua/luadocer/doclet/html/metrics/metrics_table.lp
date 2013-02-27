
<% if metrics then %>
	<%=luadoc.doclet.html.include("metrics/metrics_LOC.lp", { LOC = metrics.LOC })%>
	<br />
	<%=luadoc.doclet.html.include("metrics/metrics_halstead.lp", { halstead = metrics.halstead })%>
	<br />
	<%=luadoc.doclet.html.include("metrics/metrics_statements.lp", { statements = metrics.statements })%>

	<%=luadoc.doclet.html.include("metrics/metrics_graphs.lp", { 
		functionlength = {
			current = metrics.LOC.lines,
			total = fileMetrics.metrics.LOC.lines,
			currentName = 'Table',
			totalName = 'file'
		},
		statements = metrics.statements,
		lineAverage = nil
	})%>
	
<% end %>
