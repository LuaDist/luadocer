<%
local location={{"Files",luadoc.doclet.html.link("list_of_files.html","files/"..fname.."/")}}
local cw=""
for w in fname:gmatch("[^/]+") do 
	cw=cw..w.."/";
	table.insert(location,{w,luadoc.doclet.html.link("files/"..cw:sub(0,-2).."/file_listing.lua.lua.lua.html","files//"..fname)});
end
 luadoc.doclet.html.include("header.lp", {title="Files in "..doc.sh(fname), doc=doc, file_doc={name=fname.."/"}, location=location}) %>

<h2>Files in <%= doc.sh(fname) %></h2>
<table class="file_list">
<% for _, filename in ipairs(hierarchy) do%>
	<tr>
		<td class="name"><a href="<%=doc.sh(luadoc.doclet.html.link(filename:gsub("%.lua$",".html"):gsub("%.luadoc$",".html"), ""))%>"><%=doc.sh(filename)%></a></td>
	</tr>
<%end%>
</table>

<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
