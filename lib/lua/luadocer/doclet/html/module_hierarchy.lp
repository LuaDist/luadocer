<%
local location={{"Modules",luadoc.doclet.html.link("list_of_modules.html","modules/")}}
local cw=""
for w in modname:gmatch("[^.]+") do 
	cw=cw..w..".";
	table.insert(location,{w,cw:sub(0,-2)..".html"});
end
 luadoc.doclet.html.include("header.lp", {title="Modules in "..doc.sh(modname), doc=doc, module_doc={name="doesnt_matter"}, location=location}) %>

<h2>Modules in <%= doc.sh(modname) %></h2>
<table class="module_list">
<% for _, modulename in ipairs(hierarchy) do%>
	<tr>
		<td class="name"><a href="<%=doc.sh(luadoc.doclet.html.link("../modules/"..modname.."."..modulename..".html", ""))%>"><%=doc.sh(modulename)%></a></td>
	</tr>
<%end%>
</table>

<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
