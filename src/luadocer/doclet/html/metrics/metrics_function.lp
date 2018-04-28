
<% if metricsAST then %>

	<div style="float:left; width: 330px;">
		<%=luadoc.doclet.html.include("metrics/metrics_LOC.lp", { LOC = metricsAST.metrics.LOC })%>
		<br />
		<%=luadoc.doclet.html.include("metrics/metrics_statements.lp", { statements = metricsAST.metrics.statements })%>
		<br />
		
	</div>
	<div style="float:left; width: 330px;">
		<%=luadoc.doclet.html.include("metrics/metrics_cyclomatic.lp", { cyclomatic = metricsAST.metrics.cyclomatic })%>
		<br />
		<%=luadoc.doclet.html.include("metrics/metrics_halstead.lp", { halstead = metricsAST.metrics.halstead })%>
	</div>
	<div style="float:left; width: 330px;">
		<%=luadoc.doclet.html.include("metrics/metrics_variables.lp", { blockdata = metricsAST.metrics.blockdata })%>
		<br />
		<%=luadoc.doclet.html.include("metrics/metrics_infoflow.lp", { infoflow = metricsAST.metrics.infoflow })%>
	</div>

	<div style="float:left; width: 330px;">
		<table class="metric_index">
			<tr>
				<th>Upvalue</th>
				<th>Number of uses</th>
			</tr>
			<% ------- 
				for _, s in pairs(globalMetrics.documentSmells.smellsTable) do 
					if(s.file == fileName) then
						for k, v in pairs(s.upvalues.info) do
							if(v.functionName == functionName) then
			%>	
								<tr>
									<td class="name"><%= v.varName %></td>
									<td><%= v.usages %></td>
								</tr>
			<% -------
							end
						end
					end
				end
			%>
			
		</table>
	</div>
	
	<br />
	<div style="clear:both;"></div>
	<table class="metric_index">
		<tr>
			<th colspan=3>Depends on functions</th>
		</tr>
		<tr>
			<th>modulename</th>
			<th>function</th>
			<th>count</th>
		</tr>
		
		<%  for callName, node in pairs(metricsAST.metrics.blockdata.execs) do
				local writeme = false
				local moduleName = nil
				local functionName = nil
				for _, node in pairs(node) do
					if (node.metrics.module_functionCall) then
						writeme = true
						moduleName = node.metrics.module_functionCall.moduleName
						functionName = node.metrics.module_functionCall.functionName
						break
					end
				end
			
				if (writeme) then %>
				
				<tr>
					<td><%=moduleName%></td>
					<td><%=functionName%></td>
					<td><%=#node%></td>
				</tr>					
					
				<% end
			end	%>	
	</table>
	<br />
	
	<table class="metric_index">
		<tr>
			<th colspan=3>Depends on references</th>
		</tr>
		<tr>
			<th>modulename</th>
			<th>variable</th>
			<th>count</th>
		</tr>
		<%
		
		local variables = {}
		
		local dependency = {}
		
		for _, group in pairs(metricsAST.metrics.blockdata.locals_total) do
			for _, node in pairs(group) do
				if (node.metrics and node.metrics.module_reference) then
					local modulename = node.metrics.module_reference.moduleName
					local variableName = node.metrics.module_reference.referenceName
					
					if not dependency[modulename] then dependency[modulename] = {} end
					if not dependency[modulename][variableName] then 
						dependency[modulename][variableName] = 1
					else
						dependency[modulename][variableName] = dependency[modulename][variableName] + 1
					end
				end
			end
		end
		
		for name, nodes in pairs(metricsAST.metrics.blockdata.remotes) do
			for _, node in pairs(nodes) do
				if (node.metrics and node.metrics.module_reference) then
					local modulename = node.metrics.module_reference.moduleName
					local variableName = node.metrics.module_reference.referenceName
					
					if not dependency[modulename] then dependency[modulename] = {} end
					if not dependency[modulename][variableName] then 
						dependency[modulename][variableName] = 1
					else
						dependency[modulename][variableName] = dependency[modulename][variableName] + 1
					end
				end
			end
		end
		
		for modulename, moduleRef in pairs(dependency) do
			for varName, count in pairs(moduleRef) do
				%>
					<tr>
						<td><%=modulename%></td>
						<td><%=varName%></td>
						<td><%=count%></td>
					</tr>
				<%
			end
		end
		%>
	</table>
	<br />
	<table class="metric_index">
		<tr>
			<th colspan=2>Depended by</th>
		</tr>
		<tr>
			<th>modulename</th>
			<th>count</th>
		</tr>
		
		<% for filename, AST in pairs(globalMetrics.file_AST_list) do 	
		
			for exec, moduleRef in pairs(AST.metrics.moduleDefinitions) do
				if (moduleRef.moduleName ~= fileAST.currentModuleName) then
					for moduleName, funCall in pairs(moduleRef.moduleCalls) do
						for funName, count in pairs(funCall) do
							if (funName == metricsAST.name) then
								%>
								<tr>
									<td><%=moduleRef.moduleName%></td>
									<td><%=count%></td>
								</tr>	
								<%
							end
						end
					end
				end
			end
			
		end %>
		
	</table>
	<%
		local function_count = 0
		local loc_stats = {}
		
		for _, fun in pairs(globalMetrics.functionDefinitions) do
			function_count = function_count + 1
			for name, count in pairs(fun.metrics.LOC) do
				if not loc_stats[name] then loc_stats[name] = 0 end
				loc_stats[name] = loc_stats[name] + count
			end
		end
	%>
	<%=luadoc.doclet.html.include("metrics/metrics_graphs.lp", { 
		functionlength = {
			current = metricsAST.metrics.LOC.lines,
			total = fileAST.metrics.LOC.lines,
			currentName = 'Function',
			totalName = 'file'
		},
		statements = metricsAST.metrics.statements,
		lineAverage = {
			currentLOC = metricsAST.metrics.LOC,
			averageLOC = {
				lines 			= roundNumber(loc_stats.lines/function_count),
				lines_code		= roundNumber(loc_stats.lines_code/function_count),
				lines_comment	= roundNumber(loc_stats.lines_comment/function_count),
				lines_blank		= roundNumber(loc_stats.lines_blank/function_count),
				lines_nonempty	= roundNumber(loc_stats.lines_nonempty/function_count)
			},
			name = 'function'
		} 
	})%>
	
<% end %>

