<% 

local defined_in_file = nil

for fileName, AST in pairs(globalMetrics.file_AST_list) do
	local done = nil
	for exec, moduleRef in pairs(AST.metrics.moduleDefinitions) do
		if (moduleRef.moduleName == module_doc.name) then
			defined_in_file = fileName
			defined_in_file = luadoc.doclet.html.cutPathToSources(defined_in_file)
			done = true
			break
		end
	end
	if done then break end
end 

local location={{"Modules",luadoc.doclet.html.link("list_of_modules.html","modules/")}}
local cw=""
for w in module_doc.name:gmatch("[^.]+") do 
	cw=cw..w..".";
	table.insert(location,{w,"../module_hierarchy/"..cw:sub(0,-2)..".html"});
end
location[#location][2]=module_doc.name..".html";
luadoc.doclet.html.include("header.lp", {title=module_doc.name, doc=doc, module_doc=module_doc, location=location, extra_javascript = {'highcharts.js'}}) %>

<% if(defined_in_file) then %>
<p style='font-size:small; font-style:italic; font-weight:normal; float:right; text-align:right; margin-top:17px;'>[ <a style='font-weight:inherit;' href='<%= luadoc.doclet.html.link("files/"..defined_in_file:gsub("%.lua$",".html"):gsub("%.ludoc$",".html"),"modules/") %>'><%= doc.sh(defined_in_file:match("[^\/]+$")) %></a> ]</p>
<% end %>
<h1>Module <code><%=doc.sh(module_doc.name)%></code></h1>

<p><%=doc.sh(module_doc.description)%></p>
<%if module_doc.author then%>
<p><b><%= #module_doc.author>1 and "Authors" or "Author" %>:</b>
<table class="authors_list">
<%for _, author in ipairs(module_doc.author) do%>
	<tr><td class="name"><%= doc.sh(author) %></td></tr>
<%end%>
</table>
</p>
<%end%>
<%if module_doc.copyright then%>
<p>Copyright&copy; <%=doc.sh(module_doc.copyright)%></p>
<%end%>
<%if module_doc.release then%>
<p><small><b>Release:</b> <%=doc.sh(module_doc.release)%></small></p>
<%end%>

<a href="#" class="toggle_source" onclick="$(this).next().slideToggle(); return false;">[ show / hide metrics ]</a>
<div class='metrics_wrapper'>
	<h2> Metrics </h2>
	<%=luadoc.doclet.html.include("metrics/metrics_module.lp", { globalMetrics = globalMetrics, currentModuleName = module_doc.name})%>
	<div style='clear:both;'></div>
	<a href="#" class="toggle_source" onclick="$(this).parent().slideToggle(); return false;">[ hide metrics ]</a>
</div>

<% luadoc.doclet.html.include("functions_and_tables.lp", {doc=doc, module_doc=module_doc, globalMetrics = globalMetrics, defined_in_file=defined_in_file}) %>

<script type='text/javascript'>
	$(document).ready(function(){
		$('#content .metrics_wrapper, #content dl.function, #content dl.table').hide();
	});
</script>

<% luadoc.doclet.html.include("footer.lp", {doc=doc, module_doc=module_doc}) %>
