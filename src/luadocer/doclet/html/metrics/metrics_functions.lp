<%

	local funDefinitions = metrics

	count_all = #funDefinitions
	count_global = 0
	count_local = 0
	
	count_lines = 0
	count_lines_code = 0
	count_lines_comment = 0
	count_lines_blank = 0
	count_lines_nonempty = 0
	
	count_global_lines = 0
	count_global_lines_code = 0
	count_global_lines_comment = 0
	count_global_lines_blank = 0
	count_global_lines_nonempty = 0
	
	count_local_lines = 0
	count_local_lines_code = 0
	count_local_lines_comment = 0
	count_local_lines_blank = 0
	count_local_lines_nonempty = 0
		
	
	for _, fun in pairs(funDefinitions) do
		if (fun.tag == 'GlobalFunction' or fun.tag == 'LocalFunction') then 
			count_lines 		= count_lines 			+ fun.metrics.LOC.lines
			count_lines_code	= count_lines_code		+ fun.metrics.LOC.lines_code
			count_lines_comment = count_lines_comment	+ fun.metrics.LOC.lines_comment
			count_lines_blank	= count_lines_blank		+ fun.metrics.LOC.lines_blank
			count_lines_nonempty= count_lines_nonempty	+ fun.metrics.LOC.lines_nonempty
	
			if (fun.isGlobal) then 
				count_global = count_global + 1
				count_global_lines 			= count_global_lines 			+ fun.metrics.LOC.lines
				count_global_lines_code		= count_global_lines_code		+ fun.metrics.LOC.lines_code
				count_global_lines_comment 	= count_global_lines_comment	+ fun.metrics.LOC.lines_comment
				count_global_lines_blank	= count_global_lines_blank		+ fun.metrics.LOC.lines_blank
				count_global_lines_nonempty	= count_global_lines_nonempty	+ fun.metrics.LOC.lines_nonempty
			else 
				count_local = count_local + 1
				count_local_lines 			= count_local_lines 			+ fun.metrics.LOC.lines
				count_local_lines_code		= count_local_lines_code		+ fun.metrics.LOC.lines_code
				count_local_lines_comment 	= count_local_lines_comment	+ fun.metrics.LOC.lines_comment
				count_local_lines_blank		= count_local_lines_blank		+ fun.metrics.LOC.lines_blank
				count_local_lines_nonempty	= count_local_lines_nonempty	+ fun.metrics.LOC.lines_nonempty
			end
		end
	end
	
	
	if (file_AST_list) then -- which file has the most number of functions (and the least number)
		min_fun_in_modulem, max_fun_in_module = nil, nil
		for filename, AST in pairs(file_AST_list) do
			if (max_fun_in_module == nil) then max_fun_in_module = { AST.metrics.currentModuleName or filename, #AST.metrics.functionDefinitions } end
			if (min_fun_in_module == nil) then min_fun_in_module = { AST.metrics.currentModuleName or filename, #AST.metrics.functionDefinitions } end
			
			if (max_fun_in_module[2] <  #AST.metrics.functionDefinitions ) then
				max_fun_in_module = { AST.metrics.currentModuleName or filename,  #AST.metrics.functionDefinitions }
			end
			if (min_fun_in_module[2] >  #AST.metrics.functionDefinitions ) then
				min_fun_in_module = { AST.metrics.currentModuleName or filename,  #AST.metrics.functionDefinitions }
			end
			
		end
	end	
%>

<table class="metric_index" style="width: 579px;">
		<tr>
			<th>Function metrics</th>
			<th>Value</th>
		</tr>
		<tr>
			<td class="name">Number of all functions</td>
			<td><%=count_all%></td>
		</tr>
		<tr>
			<td class="name">Number of all global functions</td>
			<td><%=count_global%></td>
		</tr>
		<tr>
			<td class="name">Number of all local functions</td>
			<td><%=count_local%></td>
		</tr>
		
		<% if (filenum) then %>
		
			<tr>
				<td class="name">Average number of functions per file</td>
				<td><%=roundNumber(count_all / filenum)%></td>
			</tr>
			<tr>
				<td class="name">Average number of global function per file</td>
				<td><%=roundNumber(count_global / filenum)%></td>
			</tr>
			<tr>
				<td class="name">Average number of local functions per file</td>
				<td><%=roundNumber(count_local / filenum)%></td>
			</tr>
		
		<% end %>		
		<% if (count_all>0) then %>
		<tr>
			<td class="name">Average number of lines for function</td>
			<td><%=roundNumber(count_lines / count_all)%></td>
		</tr>
		<tr>
			<td class="name">Average number of code lines for function</td>
			<td><%=roundNumber(count_lines_code / count_all)%></td>
		</tr>
		<tr>
			<td class="name">Average number of comment lines for function</td>
			<td><%=roundNumber(count_lines_comment / count_all)%></td>
		</tr>
		<tr>
			<td class="name">Average number of blank lines for function</td>
			<td><%=roundNumber(count_lines_blank / count_all)%></td>
		</tr>
		<tr>
			<td class="name">Average number of nonempty lines for function</td>
			<td><%=roundNumber(count_lines_nonempty / count_all)%></td>
		</tr>
		<% end %>
		<% if count_global>0 then %>
		<tr>
			<td class="name">Average number of lines for global function</td>
			<td><%=roundNumber(count_global_lines / count_global)%></td>
		</tr>
		<tr>
			<td class="name">Average number of code lines for global function</td>
			<td><%=roundNumber(count_global_lines_code / count_global)%></td>
		</tr>
		<tr>
			<td class="name">Average number of comment lines for global function</td>
			<td><%=roundNumber(count_global_lines_comment / count_global)%></td>
		</tr>
		<tr>
			<td class="name">Average number of blank lines for global function</td>
			<td><%=roundNumber(count_global_lines_blank / count_global)%></td>
		</tr>
		<tr>
			<td class="name">Average number of nonempty lines for global function</td>
			<td><%=roundNumber(count_global_lines_nonempty / count_global)%></td>
		</tr>
		<% end %>
		<% if count_local>0 then %>
		<tr>
			<td class="name">Average number of lines for local function</td>
			<td><%=roundNumber(count_local_lines / count_local)%></td>
		</tr>
		<tr>
			<td class="name">Average number of code lines for local function</td>
			<td><%=roundNumber(count_local_lines_code / count_local)%></td>
		</tr>
		<tr>
			<td class="name">Average number of comment lines for local function</td>
			<td><%=roundNumber(count_local_lines_comment / count_local)%></td>
		</tr>
		<tr>
			<td class="name">Average number of blank lines for local function</td>
			<td><%=roundNumber(count_local_lines_blank / count_local)%></td>
		</tr>
		<tr>
			<td class="name">Average number of nonempty lines for local function</td>
			<td><%=roundNumber(count_local_lines_nonempty / count_local)%></td>
		</tr>
		<% end %>
		<% if (file_AST_list) then %>
			<tr>
				<td class="name">Maximum number of functions in module</td>
				<td><%=max_fun_in_module[1]%> <%=max_fun_in_module[2]%></td>
			</tr>
			<tr>
				<td class="name">Minimum number of functions in module</td>
				<td><%=min_fun_in_module[1]%> <%=min_fun_in_module[2]%></td>
			</tr>			
		<% end %>
		
</table>

	
