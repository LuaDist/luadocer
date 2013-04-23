<%
local extra_javascript = {'highcharts.js', 'literate.js', 'jquery-ui.min.js'}
local extra_css = {'jquery-ui-1.8.11.custom.css','indexOfFunctions.css'}
local location={{"Files",luadoc.doclet.html.link("list_of_files.html","files/"..file_doc.name)}}
local cw=""
for w in file_doc.name:gmatch("[^/]+") do 
	cw=cw..w.."/";
	table.insert(location,{w,luadoc.doclet.html.link("files/"..cw:sub(0,-2).."/file_listing.lua.lua.lua.html","files/"..file_doc.name)});
end
location[#location][2]=file_doc.file_name:gsub("%.lua$",".html"):gsub("%.luadoc$",".html");
luadoc.doclet.html.include("header.lp", {title=file_doc.file_name, doc=doc, file_doc=file_doc, location=location, extra_javascript = extra_javascript, extra_css = extra_css}) %>
<h1>File <code><%=doc.sh(file_doc.name)%></code></h1>

<%if file_doc.description then%>
<p><%=doc.sh(file_doc.description)%></p>
<%end%>
<%if file_doc.author then%>
<p><b><%= #file_doc.author>1 and "Authors" or "Author" %>:</b>
<table class="authors_list">
<%for _, author in ipairs(file_doc.author) do%>
	<tr><td class="name"><%= doc.sh(author) %></td></tr>
<%end%>
</table>
</p>
<%end%>
<%if file_doc.copyright then%>
<p>Copyright &copy;<%=doc.sh(file_doc.copyright)%></p>
<%end%>
<%if file_doc.release then%>
<p><small><b>Release:</b> <%=doc.sh(file_doc.release)%></small></p>
<%end%>

<a href="#" class="toggle_source" onclick="$(this).next().slideToggle(); return false;">[ show / hide file metrics ]</a>
<div class='metrics_wrapper'>
	<h2>Metrics</h2>
	<%=luadoc.doclet.html.include("metrics/metrics_file.lp", { metricsAST = file_doc.metricsAST, globalMetrics = globalMetrics })%>
	<div style='clear:both;'></div>
	<a href="#" class="toggle_source" onclick="$(this).parent().slideToggle(); return false;">[ hide metrics ]</a>
</div>
<br />
<% luadoc.doclet.html.include("functions_and_tables.lp", {doc=doc, file_doc=file_doc, globalMetrics = globalMetrics}) %>
<br />
<div id="tabs">

	<ul>
		<li><a href="#fragment-1"><span>Literate</span></a></li>
        <li><a href="#fragment-2"><span>Pretty printed</span></a></li>
    </ul>

	<div id="fragment-1">
		<% if file_doc.literate then %>
		<div class='literate_doc'>
		<%=file_doc.literate%>
		</div>
		<% end %>
	</div>

	<!--<h2 class='summary'>Pretty printed <%= doc.sh(file_doc.name:match("[^\/]+$")) %></h2>-->
	<div id="fragment-2">
		<script type='text/javascript' src="<%=luadoc.doclet.html.link("prettyprint.js", "files/"..file_doc.name)%>"></script>
		<div class='pretty_printer'>
		<%=file_doc.prettyprint%>
		</div>
	</div>
</div>

<script type='text/javascript'>
	$(document).ready(function(){
		$('#content .metrics_wrapper, #content dl.function, #content dl.table').hide();
		$("#tabs").tabs();
	});
</script>

<% luadoc.doclet.html.include("footer.lp", {doc=doc, file_doc=file_doc}) %>
