<% 
if ((documentMetrics.nondocumentedTablesCounter + documentMetrics.documentedTablesCounter) ~= 0) then
	commTablePercentage = roundNumber(documentMetrics.documentedTablesCounter/(documentMetrics.nondocumentedTablesCounter + documentMetrics.documentedTablesCounter))*100 
else
	commTablePercentage = 0
end
if((documentMetrics.nondocumentedFunctionsCounter + documentMetrics.documentedFunctionsCounter)~=0)then
	commFunctionPercentage = roundNumber(documentMetrics.documentedFunctionsCounter/(documentMetrics.nondocumentedFunctionsCounter + documentMetrics.documentedFunctionsCounter))*100
else
	commFunctionPercentage = 0
end
 %>

<table class="metric_index">
	<tr>
		<th>Document metrics</th>
		<th>Value</th>
	</tr>
	
	<tr>
		<td>Number of all documented functions</td>
		<td><%=documentMetrics.documentedFunctionsCounter%></td>
	</tr>
	<tr>
		<td>Number of all nondocumented functions</td>
		<td><%=documentMetrics.nondocumentedFunctionsCounter%></td>
	</tr>
	<tr>
		<td>Documented function percentage</td>
		<td><%=commFunctionPercentage%>%</td>
	</tr>
	<tr>
		<td>Number of all documented tables</td>
		<td><%=documentMetrics.documentedTablesCounter%></td>
	</tr>
	<tr>
		<td>Number of all nondocumented tables</td>
		<td><%=documentMetrics.nondocumentedTablesCounter%></td>
	</tr>	
	<tr>
		<td>Documented table percentage</td>
		<td><%=commTablePercentage%>%</td>
	</tr>
	<tr>
		<td>Number of TODO comments</td>
		<td><%  =#documentMetrics.todos%></td> 
	</tr>
	<tr>
		<td>Number of bug comments</td>
		<td><%  =#documentMetrics.bugs%></td> 
	</tr>
	<tr>
		<td>Number of question comments</td>
		<td><%  =#documentMetrics.questions%></td> 
	</tr>
	<tr>
		<td>Number of fixme comments</td>
		<td><%  =#documentMetrics.fixmes%></td> 
	</tr>
	<tr>
		<td>Number of how comments</td>
		<td><%  =#documentMetrics.hows%></td> 
	</tr>
	<tr>
		<td>Number of info comments</td>
		<td><%  =#documentMetrics.infos%></td> 
	</tr>

</table>
