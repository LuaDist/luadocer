<table class="smell_table">
	<tr>
		<th>File path</th>
		<th>Function</th>
		<th>Lines of code</th>
		<th>Lines of source code</th>
	</tr>
	<% for _, n in pairs(smells.longMethod) do %>
		<tr>
			<% local color = ""
			if(n.LOSC > 55) then color = "RED" elseif(n.LOSC >= 45) then color = "ORANGE" else color = "GREEN" end
			%>
			<td class="file">
				<a href="file://<%=n.file%>">
					<img src="../fileIcon.jpg" title="<%=n.file%>" />
				</a>
			</td>
			<td class="name" nowrap><%=n.name%></td>
			<td class="value"><%=n.LOC%></td>
			<td class="value" bgcolor="<%=color%>"><%=n.LOSC%></td>
		</tr>
	<% end %>
</table>
<table class="smell_table">
	<tr>
		<th>File path</th>
		<th>Function</th>
		<th>Cyclomatic complexity</th>
	</tr>
	<% for _, n in pairs(smells.cyclomatic) do %>
		<tr>
			<% local color = ""
			if(n.cyclomatic > 6) then color = "RED" elseif(n.cyclomatic >= 4) then color = "ORANGE" else color = "GREEN" end
			%>
			<td class="file">
				<a href="file://<%=n.file%>">
					<img src="../fileIcon.jpg" title="<%=n.file%>" />
				</a>
			</td>
			<td class="name" nowrap><%=n.name%></td>
			<td class="value" bgcolor="<%=color%>"><%=n.cyclomatic%></td>
		</tr>
	<% end %>
</table>
