
<% if metricsAST then %>
<div>

	<div style="float:left; width:330px;">
		<%=luadoc.doclet.html.include("metrics/metrics_document.lp", { documentMetrics = metricsAST.metrics.documentMetrics })%>
		<br /> 
		<%=luadoc.doclet.html.include("metrics/metrics_LOC.lp", { LOC = metricsAST.metrics.LOC })%>
		<br /> 
		<%=luadoc.doclet.html.include("metrics/metrics_statements.lp", { statements = metricsAST.metrics.statements })%>
	</div>	
	<br />
	<%=luadoc.doclet.html.include("metrics/metrics_halstead.lp", { halstead = metricsAST.metrics.halstead })%>
	<br />
	<table class="metric_index">
			<tr>
				<th>Defines modules</th>
			</tr>
			
			<% for exec, moduleRef in pairs(metricsAST.metrics.moduleDefinitions) do 
				if (moduleRef.moduleName) then
				%>
				<tr><td><%=moduleRef.moduleName%></td></tr>
				<% end 
			end %>
		</table>
	<br />
	<table class="metric_index">
		<tr>
			<th>Requires modules</th>
		</tr>
		<% 
			local modules = {}
		for moduleName, callInfo in pairs(metricsAST.metrics.moduleCalls) do 
			modules[moduleName] = true
			%>
			<tr><td><%=moduleName%></td></tr>
		<% end
		for moduleName, callInfo in pairs(metricsAST.metrics.moduleReferences) do 
			if not modules[moduleName] then %>
				<tr><td><%=moduleName%></td></tr>
			<% end	
		end %>
		
	</table>
	<div style="clear:both;"></div>
	<%=luadoc.doclet.html.include("metrics/metrics_functions.lp", { metrics = metricsAST.metrics.blockdata.fundefs})%>	
	
	<%
		local file_count = 0
		local loc_stats = {}
		
		for filename, AST in pairs(globalMetrics.file_AST_list) do
			file_count = file_count + 1
			for name, count in pairs(AST.metrics.LOC) do
				if not loc_stats[name] then loc_stats[name] = 0 end
				loc_stats[name] = loc_stats[name] + count
			end
		end
	%>
	<%=luadoc.doclet.html.include("metrics/metrics_graphs.lp", { 
		functionlength = {
			current = metricsAST.metrics.LOC.lines,
			total = globalMetrics.LOC.lines,
			currentName = 'File',
			totalName = 'project'
		},
		statements = metricsAST.metrics.statements,
		lineAverage = {
			currentLOC = metricsAST.metrics.LOC,
			averageLOC = {
				lines 			= roundNumber(loc_stats.lines/file_count),
				lines_code		= roundNumber(loc_stats.lines_code/file_count),
				lines_comment	= roundNumber(loc_stats.lines_comment/file_count),
				lines_blank		= roundNumber(loc_stats.lines_blank/file_count),
				lines_nonempty	= roundNumber(loc_stats.lines_nonempty/file_count)
			},
			name = 'file'
		} 
	})%>
	
</div>
<% end %>
