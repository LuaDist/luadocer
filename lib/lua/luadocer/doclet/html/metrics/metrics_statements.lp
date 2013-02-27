<table class="metric_index">
	<tr>
		<th>Statement usage</th>
		<th>count</th>
	</tr>
	
	<%	
	for name, stats in pairs(statements) do
		%>
			<tr>
				<td><%=name%></td>
				<td><%=#stats%></td>
			</tr>		
		<%
	end	
	%>
	
</table>
