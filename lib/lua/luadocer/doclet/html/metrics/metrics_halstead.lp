<table class="metric_index">
		<tr>
			<th>Halstead metrics</th>
			<th>Value</th>
		</tr>
		<tr>
			<td class="name">Number of operators</td>
			<td><%=halstead.number_of_operators%></td>
		</tr>
		<tr>
			<td class="name">Number of operands</td>
			<td><%=halstead.number_of_operands%></td>
		</tr>
		<tr>
			<td class="name">Number of unique operators</td>
			<td><%=halstead.unique_operators%></td>
		</tr>
		<tr>
			<td class="name">Number of unique operands</td>
			<td><%=halstead.unique_operands%></td>
		</tr>
		<tr>
			<td class="name">LTH - Halstead length</td>
			<td><%=roundNumber(halstead.LTH)%></td>
		</tr>
		<tr>
			<td class="name">VOC - Halstead vocabulary</td>
			<td><%=roundNumber(halstead.VOC)%></td>
		</tr>
		<tr>
			<td class="name">DIF - Halstead difficulty</td>
			<td><%=roundNumber(halstead.DIF)%></td>
		</tr>
		<tr>
			<td class="name">VOL - Halstead volume</td>
			<td><%=roundNumber(halstead.VOL)%></td>
		</tr>
		<tr>
			<td class="name">EFF - Halstead Effort</td>
			<td><%=roundNumber(halstead.EFF)%></td>
		</tr>
		<tr>
			<td class="name">BUG - Halstead bugs</td>
			<td><%=roundNumber(halstead.BUG)%></td>
		</tr>
		<tr>
			<td class="name">Time - Halstead Time</td>
			<td><%=roundNumber(halstead.time)%></td>
		</tr>
	</table>	
