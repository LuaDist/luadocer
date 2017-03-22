<% luadoc.doclet.html.include("header.lp", {title="Project metrics", doc=doc, file_doc={name="dummy"}, location={{"Project metrics","index.html"}}, extra_javascript = {'highcharts-pie.js'}}) %>

<script type="text/javascript">
		$(document).ready(function() {	
			$('.rollVariable').click(toggler);
		});
	
		function toggler() {
			var rollable = $(this)
			var elem = $(rollable).next().next().next()
			if ($(elem).is(":hidden")) {
				$(elem).slideDown();
				rollable.text('[-]')
			} else {
				$(elem).slideUp();
				rollable.text('[+]')
			}
		}
		
	</script>
	
<h1>Project metrics </h1>

<p>Here are shown some metrics of the project</p>

<div class='metrics_wrapper'>
	<h2>Metrics</h2>
		<div style="float:left; width: 330px;">
			<%=luadoc.doclet.html.include("metrics/metrics_document.lp", { documentMetrics = metrics.documentMetrics})%>
			<br />	
			<%=luadoc.doclet.html.include("metrics/metrics_LOC.lp", { LOC = metrics.LOC, filenum = filenum, modulenum = modulenum })%>
			<br />
			<%=luadoc.doclet.html.include("metrics/metrics_halstead.lp", { halstead = metrics.halstead })%>
			<br />
			<%=luadoc.doclet.html.include("metrics/metrics_statements.lp", { statements = metrics.statements })%>
		</div>
		<%=luadoc.doclet.html.include("metrics/metrics_functions.lp", { metrics = metrics.functionDefinitions, file_AST_list = metrics.file_AST_list, filenum = filenum })%>
		<div style="clear:both;"></div>
		<br />
	<h2>Module dependency</h2>
		<div style="width: 1000px; background-color: #F0F0F0; text-align: center; font-size: 16px; font-weight: bold; margin-bottom: 15px;">
			Module
			<div style="width: 650px; float: right;">
				dependeds on module
				<div style="width: 300px; float: right;">
					function or variable - used n times
				</div>
				<div style="clear: right;"></div>
			</div>
			<div style="clear: right;"></div>
		</div>
			<% for filename, fileAST in pairs(metrics.file_AST_list) do %>
				<div style="width: 1000px; border-bottom: 1px #F0F0F0 solid; margin-bottom: 2px;">
					
					<% for exec, moduleDef in pairs(fileAST.metrics.moduleDefinitions) do 
						if  moduleDef.moduleName then
						%>
					
						<%=moduleDef.moduleName%>
						
						<div style="width: 650px; float: right; ">
						
						<%
						local modules = {}
						
						for moduleName in pairs(moduleDef.moduleCalls) do modules[moduleName] = true end
						for moduleName in pairs(moduleDef.moduleReferences) do modules[moduleName] = true end
						
					
						for moduleName in pairs(modules) do %>
						
							<div style="border-bottom: 1px #F0F0F0 solid;">
							<%=moduleName%>
						
							<div style="width: 300px; float: right;">
						
							<% for funName, count in pairs(moduleDef.moduleCalls[moduleName] or {}) do %>
								<span style="color: #bcbcbc;">function</span> <%=funName%> <div style="float: right;"><%=count%></div><br />
								<div style="clear: right;"></div>							
							<% end
							
							for varName, fullInfo in pairs(fileAST.metrics.moduleReferences[moduleName] or {}) do 
								
								local countAll = 0
								local divString = ''
								for fullname, count in pairs(fullInfo) do 
									countAll = countAll + count
										
									divString = divString .. '<div style="width: 245px; float:right;"> ' .. fullname .. ' <div style="float: right;">'.. count .. '</div></div>'
									divString = divString .. '<div style="clear: right;"></div>'
								 end %>
								<a class='rollVariable'>[+]</a> <span style="color: #bcbcbc;">variable</span> <%=varName%> <div style="float: right;"><%=countAll%></div>
								<div style="display: none;"><%=divString%></div>
								<div style="clear: right;"></div>
			
							<% end %>
							
							</div>
							<div style="clear: right;"></div>
							</div>
							
						<% end %>
						
						</div>
						<div style="clear: right;"></div>
						
						<% end 
					end %>
						
					
				</div>
			<% end %>
		<br />
	<div style="clear:both;"></div>
	
	<script type="text/javascript">
		$(document).ready(function() {
		new Highcharts.Chart({
		      chart: {
		         renderTo: '2',
		         plotBackgroundColor: null,
		         plotBorderWidth: null,
		         plotShadow: false,
		         width: 800
		      },
		      title: {
		         text: 'Module lengths'
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
					<% for _, moduleRef in pairs(metrics.moduleDefinitions) do %>
						['<%=moduleRef.moduleName%>', <%=moduleRef.LOC.lines%>],
					<% end %>
		         ]
		      }]
		   });
		new Highcharts.Chart({
		      chart: {
		         renderTo: '3',
		         plotBackgroundColor: null,
		         plotBorderWidth: null,
		         plotShadow: false,
		         width: 800
		      },
		      title: {
		         text: 'File lengths'
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
					<% for filename, AST in pairs(metrics.file_AST_list) do %>
						['<%=filename%>', <%=AST.metrics.LOC.lines%>],
					<% end %>
		         ]
		      }]
		   });
		});	   
	</script>

	<br />
	<hr/>
	<br />

	<div style="margin: 20px; float: left;" id="2"></div>
	<div style="margin: 20px; float: left;" id="3"></div>

	<div style="clear: both;"></div>
	
</div>
<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
