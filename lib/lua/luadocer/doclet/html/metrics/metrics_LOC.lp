<table class="metric_index">
	<tr>
		<th>Lines of code</th>
		<th>Value</th>
	</tr>
	<% if (filenum and modulenum) then %>
		<tr>
			<td class="name" nowrap>Number of files</td>
			<td class="value"><%=filenum%></td>
		</tr>
		<tr>
			<td class="name" nowrap>Number of modules</td>
			<td class="value"><%=modulenum%></td>
		</tr>
		<tr>
	<% end %>
	<tr>
		<td class="name" nowrap>Lines Total</td>
		<td class="value"><%=LOC.lines%></td>
	</tr>
	<tr>
		<td class="name" nowrap>Executable code lines</td>
		<td class="value"><%=LOC.lines_code%></td>
	</tr>
	<tr>
		<td class="name" nowrap>Commented lines</td>
		<td class="value"><%=LOC.lines_comment%></td>
	</tr>
	<tr>
		<td class="name" nowrap>Blank lines</td>
		<td class="value"><%=LOC.lines_blank%></td>
	</tr>
	<tr>
		<td class="name" nowrap>Nonempty lines</td>
		<td class="value"><%=LOC.lines_nonempty%></td>
	</tr>
	<tr>
		<td class="name" nowrap>Comment percentage</td>
		<td class="value"><%=roundNumber(LOC.lines_comment / LOC.lines_code) * 100%>%</td>
	</tr>
</table>
