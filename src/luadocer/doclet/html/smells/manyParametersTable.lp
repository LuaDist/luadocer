<table class="smell_table">
	<tr>
		<th>Function</th>
		<th>Number of Parameters</th>
	</tr>
	<% for _, n in pairs(smells) do %>
		<tr>
			<td class="name" nowrap><%=n.name%></td>
			<td class="value"><center><%=n.NOA%></center></td>
		</tr>
	<% end %>
</table>
