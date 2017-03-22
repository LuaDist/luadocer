<script type="text/javascript">
$(document).ready(function() {
	Highcharts.chart('bar_graph_container_params', {
		chart: {
			type: 'bar'
		},
		title: {
			text: 'Number of parameters in functions'
		},
		subtitle: {
			text: '(Sorted descending)'
		},
		xAxis: {
			categories: [
				<% for _, n in pairs(smells.manyParameters) do %>
					['<%=n.name%>'],
				<% end %>
			],
			title: {
		    		text: null
			}
		},
		yAxis: {
			min: 0,
			title: {
			   	text: 'Number of Parameters',
			    	align: 'high'
			},
			labels: {
			    	overflow: 'justify'
			}
		},
		plotOptions: {
			bar: {
		    		dataLabels: {
					enabled: true
		    		}
			}
		},
		legend: {
			layout: 'vertical',
			align: 'right',
			verticalAlign: 'top',
			x: -40,
			y: 80,
			floating: true,
			borderWidth: 1,
			backgroundColor: '#FFFFFF',
			shadow: true
		},
		credits: {
			enabled: false
		},
		series: [{
			name: 'Number of Parameters',
			data: [
				<% for _, n in pairs(smells.manyParameters) do %>
					<%=n.NOA%>,
				<% end %>
			],
			zones: [{
	    			value: <%=(smells.maxNOA / 2)%>,
	    			color: 'green'
			},{
	    			value: <%=smells.maxNOA%>,
	    			color: 'orange'
			},{
	    			color: 'red'
			}]
		}]
	});
});
</script>

<br />
<hr/>
<div id="bar_graph_container_params" style="width: 800px; height: <%=(smells.totalFunctions*20) %>px; min-height: 400px; margin: 0 auto"></div>
