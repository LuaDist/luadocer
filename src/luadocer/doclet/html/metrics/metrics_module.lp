<%	
if globalMetrics then
	
	local moduleNode = nil
	local definedFile = nil
	
	for fileName, AST in pairs(globalMetrics.file_AST_list) do
		local found = nil
		for exec, moduleRef in pairs(AST.metrics.moduleDefinitions) do
			if (moduleRef.moduleName == currentModuleName) then
				moduleNode = moduleRef
				definedFile = {filename, AST}
				found = true
				break
			end
		end
		if found then break end
	end
	
	if (moduleNode) then%>
		<div style="float: left; width: 330px;">
			<%--[[=luadoc.doclet.html.include("metrics/metrics_document.lp", { documentMetrics = moduleNode.documentMetrics})]]%>
			<%=luadoc.doclet.html.include("metrics/metrics_LOC.lp", { LOC = moduleNode.LOC })%>
			<br />
			<table class="metric_index">
				<tr>
					<th colspan=2>Module coupling</th>
				</tr>
				<tr>
					<td>Afferent coupling</td>
					<td><%=definedFile[2].metrics.coupling.afferent_coupling%></td>
				</tr>
				<tr>
					<td>Efferent coupling</td>
					<td><%=definedFile[2].metrics.coupling.efferent_coupling%></td>
				</tr>
				<tr>
					<td>Module instability</td>
					<td><%=roundNumber(definedFile[2].metrics.coupling.instability)%>%</td>
				</tr>
			</table>
		</div>
		<%=luadoc.doclet.html.include("metrics/metrics_halstead.lp", { halstead = moduleNode.halstead })%>		
		<br />
		<%=luadoc.doclet.html.include("metrics/metrics_statements.lp", { statements = moduleNode.statements })%>
		<br />
	<% end %>
	
	<br />
	<div style="clear:both;"></div>
	<table class="metric_index">
		<tr>
			<th colspan=3>Depended by functions</th>
		</tr>
		<tr>
			<th>ModuleName</th>
			<th>Function name</th>
			<th>count</th>
		</tr>
		
		<% 
	
		for fileName, AST in pairs(globalMetrics.file_AST_list) do
			for moduleName, funCall in pairs(AST.metrics.moduleCalls) do
				if (moduleName == currentModuleName) then
					for funName, count in pairs(funCall) do	%>
						<tr>
							<td><%=(AST.metrics.currentModuleName or fileName)%></td>
							<td><%=funName%></td>
							<td><%=count%></td>
						</tr>	
					<% end
				end
			end
		end
		%>
		
	</table>
	<br />
	<table class="metric_index">
		<tr>
			<th colspan=3>Depended by references</th>
		</tr>
		<tr>
			<th>ModuleName</th>
			<th>Variable name</th>
			<th>count</th>
		</tr>
		
		<%
		for fileName, AST in pairs(globalMetrics.file_AST_list) do
			for ref_moduleName, refInfo in pairs(AST.metrics.moduleReferences) do 
				if (ref_moduleName == currentModuleName) then
					for varName, fullInfo in pairs(refInfo) do 
					
						local countAll = 0
						for fullname, count in pairs(fullInfo) do 
							countAll = countAll + count
						end
					%>
						<tr>
							<td><%=AST.metrics.currentModuleName or fileName%></td>
							<td><%=varName%></td>
							<td><%=countAll%></td>
						</tr>
					<%
					end
				end
			end
		end
		%>
	</table>
	<br />
	<div style="clear:both;"></div>
	
	<% if moduleNode then %>
	
	<table class="metric_index">
		<tr>
			<th colspan=3>Depends on functions</th>
		</tr>
		<tr>
			<th>ModuleName</th>
			<th>Function name</th>
			<th>count</th>
		</tr>
		
		<% 
		
		for moduleName, funCall in pairs(moduleNode.moduleCalls) do			
			for funName, count in pairs(funCall) do	%>
				<tr>
					<td><%=moduleName%></td>
					<td><%=funName%></td>
					<td><%=count%></td>
				</tr>
			<% end					
		end
		%>
		
	</table>
	<br />
	<table class="metric_index">
		<tr>
			<th colspan=3>Depends on references</th>
		</tr>
		<tr>
			<th>ModuleName</th>
			<th>Variable name</th>
			<th>count</th>
		</tr>
		
		<%
		for ref_moduleName, refInfo in pairs(moduleNode.moduleReferences or {}) do 
			for varName, fullInfo in pairs(refInfo) do 
				local countAll = 0
				for fullname, count in pairs(fullInfo) do 
					countAll = countAll + count
				end
			%>
				<tr>
					<td><%=ref_moduleName%></td>
					<td><%=varName%></td>
					<td><%=countAll%></td>
				</tr>
			<%
			end
		end
		%>
	</table>
	
	<%
		if (globalMetrics.moduleDefinitions) then 
	
		local module_count = 0
		local loc_stats = {}
		
		for _, mod in pairs(globalMetrics.moduleDefinitions) do
			module_count = module_count + 1
			for name, count in pairs(mod.LOC) do
				if not loc_stats[name] then loc_stats[name] = 0 end
				loc_stats[name] = loc_stats[name] + count
			end
		end
	%>
	<%=luadoc.doclet.html.include("metrics/metrics_graphs.lp", { 
		functionlength = {
			current = moduleNode.LOC.lines,
			total = globalMetrics.LOC.lines,
			currentName = 'Module',
			totalName = 'project'
		},
		statements = moduleNode.statements,
		lineAverage = {
			currentLOC = moduleNode.LOC,
			averageLOC = {
				lines 			= roundNumber(loc_stats.lines/module_count),
				lines_code		= roundNumber(loc_stats.lines_code/module_count),
				lines_comment	= roundNumber(loc_stats.lines_comment/module_count),
				lines_blank		= roundNumber(loc_stats.lines_blank/module_count),
				lines_nonempty	= roundNumber(loc_stats.lines_nonempty/module_count)
			},
			name = 'module'
		} 
		})%>
	<% end
	end 
end	
%>
	
