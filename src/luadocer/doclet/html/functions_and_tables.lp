<%
	local my_doc=file_doc and file_doc or module_doc;
%>

<%if #my_doc.functions > 0 then%>
<h2 class='summary'>Functions <a href='#' onclick="$(this).parent().next().next().next().slideToggle(); return false;" class='toggle_source'>[ show / hide details ]</a></h2>
<table class="function_list">
<%for _, func_name in ipairs(my_doc.functions) do
  local func_data	 = my_doc.functions[func_name]%>
	<tr>
	<td class="name"><a name="<%=func_data.name%>"></a><%=func_data.private and "local " or ""%><a href="<%= luadoc.doclet.html.link(func_data.detail_link and func_data.detail_link or (defined_in_file and "files/"..defined_in_file:gsub("%.lua$",".html"):gsub("%.ludoc$",".html").."#"..doc.sh(func_name) or ""),file_doc and "" or "modules/") %>"><%=func_name%></a>&nbsp;(<%=table.concat(func_data.param, ", ")%>)</td>
	<td class="summary">

		<%=doc.sh(func_data.summary)%>
	</td>
	</tr>
<%end%>
</table>

<a name="functions"></a>
<dl class="function">
<%for _, func_name in ipairs(my_doc.functions) do%>
<div class='function'>
<%=luadoc.doclet.html.include("function.lp", { doc=doc, file_doc=file_doc, module_doc=module_doc, func=my_doc.functions[func_name], globalMetrics=globalMetrics })%>
</div>
<%end%>
</dl>
<%end%>

<%if #my_doc.tables > 0 then%>
<h2 class='summary'>Tables <a href='#' onclick="$(this).parent().next().next().next().slideToggle(); return false;" class='toggle_source'>[ show / hide details ]</a></h2>
<table class="table_list">
<%for _, tab_name in ipairs(my_doc.tables) do%>
	<tr>
	<td class="name"><a name="<%=tab_name%>"></a><a href="<%= defined_in_file and luadoc.doclet.html.link("files/"..defined_in_file:gsub("%.lua$",".html"):gsub("%.ludoc$",".html").."#"..doc.sh(tab_name),"modules/") or "#"..tab_name %>"><%=tab_name%></a></td>
	<td class="summary"><%=doc.sh(my_doc.tables[tab_name].summary)%></td>
	</tr>
<%end%>
</table>

<a name="tables"></a>
<dl class="table">
<%for _, tab_name in ipairs(my_doc.tables) do%>
<div class='table'>
	<%=luadoc.doclet.html.include("table.lp", { doc=doc, file_doc=file_doc, module_doc=module_doc, tab=my_doc.tables[tab_name]})%>
</div>
<%end%>
</dl>
<%end%>
