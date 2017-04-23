<% luadoc.doclet.html.include("header.lp", {title="List of files", doc=doc, file_doc=file_doc, location={{"Files",luadoc.doclet.html.link("list_of_files.html","")}}}) %>

<%if not options.nofiles and #doc.files > 0 then%>
<h2>List of files</h2>
<table class="file_list">
<!--<tr><td colspan="2">Files</td></tr>-->
<%for _, filepath in ipairs(doc.files) do%>
	<tr>
		<td class="name" nowrap><a href="<%= doc.sh(luadoc.doclet.html.file_link(filepath))%>"><%=luadoc.doclet.html.cutPathToSources(doc.sh(filepath))%></a></td>
		<td class="summary"><%if doc.files[filepath].summary then%><%= doc.sh(doc.files[filepath].summary) %><%else%>&nbsp;<%end%></td>
	</tr>
<%end%>
</table>
<%end%>

<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
