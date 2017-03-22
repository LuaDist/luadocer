<table class="smell_table">
	<tr>
		<th>Function</th>
		<th>Lines of code</th>
		<th>Lines of source code</th>
	</tr>
	<% for _, n in pairs(smells) do %>
		<tr>
			<td class="name" nowrap><%=n.name%></td>
			<td class="value"><%=n.LOC%></td>
			<td class="value"><%=n.LOSC%></td>
		</tr>
	<% end %>
</table>
