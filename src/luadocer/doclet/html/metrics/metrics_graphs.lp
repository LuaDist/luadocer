
	<%
		--[[
		
			Function length
				functionlength.current
				functionlength.total
				functionlength,.currentName
				functionlength.totalName
			
			Statement usage
				statements table
			
			Line average
				currentLOC
				averageLOC
				name
				
		--]]
	
		local id = {}
	%>
	<script type="text/javascript">
		$(document).ready(function() {
			<% table.insert(id, getUniqueId()) %>
		   new Highcharts.Chart({
		      chart: {
		         renderTo: '<%=id[1]%>',
		         plotBackgroundColor: null,
		         plotBorderWidth: null,
		         plotShadow: false,
		         width: 350,
		         height: 200
		      },
		      title: {
		         text: '<%=functionlength.currentName%> length'
		      },
		      tooltip: {
		         formatter: function() {
		            return '<b>'+ this.point.name +'</b>: ' + this.y +' lines';
		         }
		      },
		      plotOptions: {
		         pie: {
		            allowPointSelect: true,
		            cursor: 'pointer',
		            dataLabels: {
		               enabled: true,
		               color: '#000000',
		               connectorColor: '#000000',
		               formatter: function() {
		                  return '<b>'+ this.point.name +'</b>' //+ this.y +' lines';
		               }
		            }
		         }
		      },
		       series: [{
		         type: 'pie',
		         name: '',
		         data: [
		            ['rest of <%=functionlength.totalName%>', <%=functionlength.total - functionlength.current%>],
		            ['<%=functionlength.currentName%>', <%=functionlength.current%>]
		         ]
		      }]
		   });
		
			<% table.insert(id, getUniqueId()) %>
			new Highcharts.Chart({
			      chart: {
			         renderTo: '<%=id[2]%>',
			         plotBackgroundColor: null,
			         plotBorderWidth: null,
			         plotShadow: false,
			         width: 350,
			         height: 200
			      },
			      title: {
			         text: 'Statement Usage'
			      },
			      tooltip: {
			         formatter: function() {
			            return '<b>'+ this.point.name +'</b>: ' + this.y +' lines';
			         }
			      },
			      plotOptions: {
			         pie: {
			            allowPointSelect: true,
			            cursor: 'pointer',
			            dataLabels: {
			               enabled: true,
			               color: '#000000',
			               connectorColor: '#000000',
			               formatter: function() {
			                  return '<b>'+ this.point.name +'</b>'; //+ this.y +' lines';
			               }
			            }
			         }
			      },
			       series: [{
			         type: 'pie',
			         name: 'Browser share',
			         data: [
						<% for name, stats in pairs(statements) do %>
							['<%=name%>', <%=#stats%>],
						<% end %>
			         ]
			      }]
			   });
			<% 
				if (lineAverage) then
				table.insert(id, getUniqueId()) %>
			<%
				
			%>
			new Highcharts.Chart({
		      chart: {
		         renderTo: '<%=id[3]%>',
		         defaultSeriesType: 'column',
		         width: 350,
			     height: 250
		      },
		      title: {
		         text: 'Comparison with average <%=lineAverage.name%>'
		      },
		      xAxis: {
		         categories: [
		            'Lines', 
		            'Commented lines', 
		            'Lines of code', 
		            'Nonempty lines', 
		            'Blank lines', 
		         ]
		      },
		      yAxis: {
		         min: 0,
		         title: {
		            text: 'Count'
		         }
		      },
		      legend: {
		         enabled: true,
		      },
		      tooltip: {
		         formatter: function() {
		            return ''+
		               this.x +': '+ this.y;
		         }
		      },
		      plotOptions: {
		         column: {
		            pointPadding: 0.2,
		            borderWidth: 0
		         }
		      },
		      series: [{
		         name: 'Current <%=lineAverage.name%>',
		         data: [
					<%=lineAverage.currentLOC.lines%>, 
					<%=lineAverage.currentLOC.lines_comment%>, 
					<%=lineAverage.currentLOC.lines_code%>, 
					<%=lineAverage.currentLOC.lines_nonempty%>, 
					<%=lineAverage.currentLOC.lines_blank%>
				] }, {
		         name: 'Average <%=lineAverage.name%>',
		         data: [
					<%=lineAverage.averageLOC.lines%>, 
					<%=lineAverage.averageLOC.lines_comment%>, 
					<%=lineAverage.averageLOC.lines_code%>, 
					<%=lineAverage.averageLOC.lines_nonempty%>, 
					<%=lineAverage.averageLOC.lines_blank%>
				]
		      }]	
		   });
		   <% end %>
		});		
	</script>
	<div style="clear: both;"></div>
	<br />
	<hr/>
	<br />
	<% for _, id in pairs(id) do %>
		<div style="margin: 20px; float: left;" id="<%=id%>"></div>
	<% end %>	
	<div style="clear: both;"></div>
