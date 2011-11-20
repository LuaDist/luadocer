<%
if module_doc then
	from = "modules/"..module_doc.name
elseif file_doc then
	from = "files/.."..file_doc.name
else
	from = ""
end
%>

<dt><%=func.private and "local " or ""%><% if(func.detail_link) then %><a href='<%= luadoc.doclet.html.link(func.detail_link,file_doc and "" or from) %>'><strong><%=func.name%></strong></a><% else %><strong><%=func.name%></strong><% end %>&nbsp;(<%=table.concat(func.param, ", ")%>)</dt>
<dd>
<%=doc.sh(func.description) or ""%>

<%if type(func.param) == "table" and #func.param > 0 then%>
<h3>Parameters</h3>
<ul>
	<%for p = 1, #func.param do%>
	<li>
	  <%=func.param[p]%>: <%=doc.sh(func.param[func.param[p]]) or ""%>
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
</dd>

<% if(func.prettyprint or (file_doc and file_doc.metricsAST)) then %>
	<div style='margin-bottom:5px;'>
<% end %>

<% if(func.prettyprint) then %>
	<a href='#' class='toggle_source' onclick="$(this).parent().next().slideToggle(); return false;">[ show / hide source ]</a>
<% end %>

<% if(file_doc and file_doc.metricsAST) then %>
	<a href='#' class='toggle_source' onclick="$(this).parent().next().next().slideToggle(); return false;">[ show / hide metrics ]</a>
<% end %>

<% if(func.prettyprint or (file_doc and file_doc.metricsAST)) then %>
	</div>
<% end %>

<% if(func.prettyprint) then %>
<div class='pretty_printer pretty_printer_snippet'>
<pre class='highlighted_code'>
<span class='whole_code'>
<%= func.prettyprint %>
</span>
</pre>
</div>
<% end %>

<% if(file_doc and file_doc.metricsAST) then %>
<div class='metrics_wrapper' style='display:none; padding-bottom:10px;'>
	<% luadoc.doclet.html.include("metrics/metrics_function.lp", { metricsAST = file_doc.metricsAST.luaDoc_functions[func.name], fileAST = file_doc.metricsAST, globalMetrics = globalMetrics, currentModuleName=file_doc.metricsAST.metrics.currentModuleName })%>
	<div style='clear:both;'></div>
	<a href='#' class='toggle_source' onclick="$(this).parent().slideToggle(); return false;">[ hide metrics ]</a>
</div>
<% end %>
