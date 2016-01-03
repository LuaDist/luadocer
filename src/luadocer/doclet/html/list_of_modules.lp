<% luadoc.doclet.html.include("header.lp", {title="List of modules", doc=doc, module_doc=module_doc, location={{"Modules",luadoc.doclet.html.link("list_of_modules.html","")}}}) %>

<%if not options.nomodules and #doc.modules > 0 then%>

<h2>List of modules</h2>
<table class="module_list">

<% for _, modulename in ipairs(doc.modules) do%>
	<tr>
		<td class="name" nowrap><a href="<%=doc.sh(luadoc.doclet.html.module_link(modulename, doc))%>"><%=doc.sh(modulename)%></a></td>
		<td class="summary"><%=doc.sh(doc.modules[modulename].summary)%></td>
	</tr>
<%end%>
</table>
<%if(#doc.modules==0) then
	%>No modules in project.<%
end
end%>

<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
