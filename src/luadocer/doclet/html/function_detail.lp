<%
local location={{"Files",luadoc.doclet.html.link("list_of_files.html","files/"..file_doc.name)}}
local cw=""
for w in file_doc.name:gmatch("[^/]+") do 
	cw=cw..w.."/";
	table.insert(location,{w,luadoc.doclet.html.link("files/"..cw:sub(0,-2).."/file_listing.lua.lua.lua.html","files/"..file_doc.name)});
end
location[#location][2]=file_doc.file_name:gsub("%.lua$",".html"):gsub("%.luadoc$",".html");
table.insert(location,{func.name.."()","#"});

luadoc.doclet.html.include("header.lp", {title=func.name.."() ["..file_doc.file_name.."]", doc=doc, file_doc=file_doc, location=location, extra_javascript = {'highcharts.js'}}) %>

<div class='function_detail'>
<a href='<% local r=file_doc.file_name:gsub("%.lua$",".html"):gsub("%.luadoc$",".html") %><%= r %>'>&lt;&lt; Functions in <%= doc.sh(file_doc.file_name:match("[^/\]+$")) %></a>
<br /><br />

<h1><%=func.private and "local function "  or "function "%><strong><%=func.name%></strong>&nbsp;(<%=table.concat(func.param, ", ")%>)</h1>
<%=func.description and "<div style='margin-left:10px; font-style:italic;'><i>"..doc.sh(func.description).."</i></div>" or ""%>

<%if type(func.param) == "table" and #func.param > 0 then%>
<h3>Parameters</h3>
<ul>
	<%for p = 1, #func.param do%>
	<li>
	  <%=func.param[p]%>: 	  <%=doc.sh(func.param[func.param[p]]) or ""%>
		<%--KOSA EXPLUA param types
		if(func.types and func.types[func.param[p]])then
		local types="<b>Types: </b>"
			if(type(func.types[func.param[p]])=="table")then
				for _,tp in pairs(func.types[func.param[p]]) do
					types = types .. " ".. tp
				end
			else
			types = types ..  func.types[func.param[p]]
			end
			%>
			 </br><i> <%=types%> </i></br>
			
		<%end%>

	</li>
	<%end%>
</ul>
<%end%>


<%if type(func.usage) == "string" then%>
<h3>Usage:</h3>
<%=doc.sh(func.usage)%>
<%elseif type(func.usage) == "table" then%>
<h3>Usage</h3>
<ul>
	<%for _, usage in ipairs(func.usage) do%>
	<li><%= doc.sh(usage) %>
	<%end%>
</ul>
<%end%>

<%if type(func.ret) == "string" then%>
<h3>Return value:</h3>
<%=doc.sh(func.ret)%>
		<%--KOSA EXPLUA return types
		if(func.rettypes )then
		local rettypes="<b>Types: </b>"
			if(type(func.rettypes)=="table")then
				for k,v in pairs(func.rettypes) do
					rettypes = rettypes .. " ".. v
				end
			else
			rettypes = rettypes ..  func.rettypes
			end
			%>
			</br><i> <%=rettypes%> </i></br>
		<%end%>

<%elseif type(func.ret) == "table" then%>
<h3>Return values:</h3>
<ol>
	<%for _, ret in ipairs(func.ret) do%>
	<li><%= doc.sh(ret) %>
	<%end%>
</ol>
<%end%>

<%if type(func.see) == "string" then %>
<h3>See also:</h3>
	<a href="<%=func.see
	-- safe html maybe? what content is possible? 
	%>"><%=func.see%></a>
<%elseif type(func.see) == "table" and #func.see > 0 then %>
<h3>See also:</h3>
<ul>
	<%for i = 1, #func.see do%>
	<li><a href="<%=luadoc.doclet.html.symbol_link(func.see[i], doc, module_doc, file_doc, from)%>">
		<%=func.see[i]%>
	</a>
	<%end%>
</ul>
<%end%>
<br /><br />
<% if(func.uml) then %>
<a href='#' class='toggle_source' onclick="$(this).next().next().next().next().slideToggle(); return false;">[ show / hide diagram ]</a> 
<% end %>
<% if(func.prettyprint) then %>
<a href='#' class='toggle_source' onclick="$(this).next().next().next().next().slideToggle(); return false;">[ show / hide source ]</a> 
<% end %>
<a href="#" class="toggle_source" onclick="$(this).next().slideToggle(); return false;">[ show / hide metrics ]</a>

<div class='metrics_wrapper' style="padding-top:10px;">
	<h2>Metrics</h2>
	<%= luadoc.doclet.html.include("metrics/metrics_function.lp", {metricsAST = metricsAST.luaDoc_functions[func.name], fileAST = metricsAST , globalMetrics = globalMetrics, fileName = file_doc.name, functionName = func.name}) %>
	<div style='clear:both;'></div>
	<a href="#" class="toggle_source" onclick="$(this).parent().slideToggle(); return false;">[ hide metrics ]</a>
</div>


<div  style="display: none" id="uml2">
		<% if (func.uml) then %>
			<h3>UML Diagram for function <%= (func.name)%></h3>
			<ul>
				<a href = "<%=luadoc.doclet.html.link((func.uml:gsub("^/","../")),"files/"..file_doc.name)%>"><img src="<%=luadoc.doclet.html.link((func.uml:gsub("^/","../")),"files/"..file_doc.name)%>"> </a>
			</ul>
		<% end %>&nbsp;
		</div>

<% if(func.prettyprint) then %>
<div class='pretty_printer'>
<pre class='highlighted_code'>
<span class='whole_code'>
<%= func.prettyprint %>
</span>
</pre>
</div>
<% end %>

<script type='text/javascript' src="<%=luadoc.doclet.html.link("prettyprint.js", "files/"..file_doc.name)%>"></script>

<script type='text/javascript'>
	$('.pretty_printer, .metrics_wrapper').hide();
</script>
<%= luadoc.doclet.html.include("footer.lp", {doc=doc, file_doc=file_doc}) %>
