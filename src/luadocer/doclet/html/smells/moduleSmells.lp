<h2>Maintainability index (MI)</h2>
<div style="float:left; display: block">
	<p>
		MI = 171 - 5.2ln(<b>aV</b>) - 0.23<b>aV(g')</b> - 16.2ln(<b>aLOC</b>) - 50sin[sqrt(2.4 - <b>perCM</b>)] <br />
		<ul>
			<li><b>aV</b> = average Halstead volume V per module</li>
			<li><b>aV(g')</b> = average cyclomatic complexity per module</li>
			<li><b>aLOC</b> = average count of lines of code (LOC) per module</li>
			<li><b>perCM</b> = average percent of lines of comments per module</li>
		</ul>
	</p>
	<p>
		<table class="smell_table" style="width:250px;">
			<tr>
				<% local color = ""
					if(smells.MI < 65) then
						color = "RED" 
					elseif(smells.MI < 85) then
						color = "ORANGE" 
					else 
						color = "GREEN"
					end
				%>
				<td class="name" style="width:200px;" nowrap>Maintainability index</td>
				<td class="value" style="width:50px;" bgcolor="<%=color%>"><center><%=smells.MI%></center></td>
			</tr>
		</table>
	</p>
	<table class="smell_table" style="width:300px;">
		<tr>
			<th>Maintainability</th>
			<th>Score</th>
		</tr>
		<tr>
			<td class="name">Highly maintainable</td>
			<td class="value" bgcolor="GREEN">>85</td>
		</tr>
		<tr>
			<td class="name">Moderately maintainable</td>
			<td class="value" bgcolor="ORANGE" nowrap>>85 and <65</td>
		</tr>
		<tr>
			<td class="name">Difficult to maintain</td>
			<td class="value" bgcolor="RED"><65</td>
		</tr>
	</table>
</div>
<div style="clear:both;"></div>
<br />