<table class="smell_table">
	<tr>
		<th>Function</th>
		<th>Number of Parameters</th>
	</tr>
	<% for _, n in pairs(smells) do %>
		<tr>
			<% local color = ""
			if(n.NOA > 10) then color = "RED" elseif(n.NOA >= 5) then color = "ORANGE" else color = "GREEN" end
			%>
			<td class="name" nowrap><%=n.name%></td>
			<td class="value" bgcolor="<%=color%>"><center><%=n.NOA%></center></td>
		</tr>
	<% end %>
</table>
