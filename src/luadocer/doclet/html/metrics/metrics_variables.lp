<%

count_global = 0
count_global_read = 0
count_global_write = 0

for name, vars in pairs(blockdata.remotes) do
	count_global = count_global + 1
	for _, node in pairs(vars) do
		if (node.isRead) then
			count_global_read = count_global_read + 1
		end
		if (node.isWritten) then
			count_global_write = count_global_write + 1
		end
	end
end

count_unused = 0
for _, group in pairs(blockdata.locals) do
	if (#group[2]==1) then count_unused = count_unused + 1 end
end

count_unused_total = 0
for _, group in pairs(blockdata.locals_total) do
	if (#group[2]==1) then count_unused_total = count_unused_total + 1 end
end

%>	
<table class="metric_index">
	<tr>
		<th>Variable metrics</th>
		<th>Value</th>
	</tr>
	<tr>
		<td>referenced global variables</td>
		<td><%=count_global%></td>
	</tr>
	<tr>
		<td>read from global variables</td>
		<td><%=count_global_read%></td>
	</tr>
	<tr>
		<td>written to global variables</td>
		<td><%=count_global_write%></td>
	</tr>
	<tr>
		<td>local variables in current block</td>
		<td><%=#blockdata.locals%></td>
	</tr>
	<tr>
		<td>local variables in all nested blocks</td>
		<td><%=#blockdata.locals_total%></td>
	</tr>
	<tr>
		<td>unused variables in current block</td>
		<td><%=count_unused%></td>
	</tr>
	<tr>
		<td>unused variables in all nested blocks</td>
		<td><%=count_unused_total%></td>
	</tr>
</table>	
