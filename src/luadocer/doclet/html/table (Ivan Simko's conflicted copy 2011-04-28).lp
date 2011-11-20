<dt><strong><%=tab.name%></strong></dt>
<dd><%=tab.description%>

<%if type(tab.field) == "table" and #tab.field > 0 then%>
<em>Fields</em>
<ul>
	<%for p = 1, #tab.field do%>
	<li>
	  <%=tab.field[p]%>: <%=tab.field[tab.field[p]] or ""%>
	</li>
	<%end%>
</ul>
<%end%>
</dd>

<% if(file_doc and file_doc.metricsAST) then %>
<a href='#' class='toggle_source' onclick="$(this).next().slideToggle(); return false;">[ show / hide metrics ]</a>
<div class='metrics_wrapper'>
	<%=luadoc.doclet.html.include("metrics/metrics_table.lp", { metrics = file_doc.metricsAST.luaDoc_tables[tab.name].metrics })%>
	<div style='clear:both;'></div>
	<a href='#' class='toggle_source' onclick="$(this).parent().slideToggle(); return false;">[hide metrics ]</a>
<% end %>
