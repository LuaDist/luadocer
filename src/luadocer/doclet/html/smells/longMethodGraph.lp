<script type="text/javascript">
$(document).ready(function() {
	Highcharts.chart('bar_graph_container', {
		chart: {
			type: 'bar'
		},
		title: {
			text: 'Lines of code in functions'
		},
		subtitle: {
			text: '(Sorted descending)'
		},
		xAxis: {
			categories: [
				<% for _, n in pairs(smells.longMethod) do %>
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
			   	text: 'Lines of code',
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
			name: 'Total',
			data: [
				<% for _, n in pairs(smells.longMethod) do %>
					<%=n.LOC%>,
				<% end %>
			],
		}, {
			name: 'Source code',
			data: [
				<% for _, n in pairs(smells.longMethod) do %>
					<%=n.LOSC%>,
				<% end %>
			],
			zones: [{
	    			value: <%=(smells.maxLOSC-5) %>,
	    			color: 'green'
			},{
	    			value: <%=(smells.maxLOSC+5) %>,
	    			color: 'orange'
			},{
	    			color: 'red'
			}]
		}]
	});

	Highcharts.chart('bar_graph_container2', {
		chart: {
			type: 'bar'
		},
		title: {
			text: 'Cyclomatic complexity of functions'
		},
		subtitle: {
			text: '(Sorted descending)'
		},
		xAxis: {
			categories: [
				<% for _, n in pairs(smells.cyclomatic) do %>
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
			   	text: 'Cyclomatic complexity',
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
			name: 'Cyclomatic complexity',
			data: [
				<% for _, n in pairs(smells.cyclomatic) do %>
					<%=n.cyclomatic%>,
				<% end %>
			],
			zones: [{
	    			value: 4,
	    			color: 'green'
			},{
	    			value: 6,
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
<div id="bar_graph_container" style="width: 800px; height: <%=(smells.totalFunctions*20) %>px; min-height: 400px; margin: 0 auto"></div>
<br />
<div id="bar_graph_container2" style="width: 800px; height: <%=(smells.totalFunctions*20) %>px; min-height: 400px; margin: 0 auto"></div>
