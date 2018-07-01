<% luadoc.doclet.html.include("header.lp", {doc=doc}) %>
<h1><%= doc.project_name and doc.sh(doc.project_name) or "LuaDoc documentation" %></h1>
Generated <%= os.date("%d.%m.%Y %H:%M:%S") %> by LuaDoc
<h2>Browse...</h2>
<ul>
<%if not options.nomodules and #doc.modules > 0 then%>
<li><a href='list_of_modules.html'>Modules</a></li>
<%end%>

<%if not options.nofiles and #doc.files > 0 then%>
<li><a href='list_of_files.html'>Files</a></li>
<%end%>

<li><a href='functionlist/index.html'>Functions</a></li>
<li><a href='tablelist/index.html'>Tables</a></li>
<li><a href='metrics/index.html'>Project metrics</a></li>
<li><a href='smells/index.html'>Project code quality</a></li>
<li><a href='customcommentlist/customs.html'>Informational comments</a></li>

<%if doc.check then%>
<li><a href="<%=luadoc.doclet.html.link("check/index.html",from)%>">Static analysis</a></li>
<%end%>
<%if doc.diagram then%>
<li><a href="<%=luadoc.doclet.html.link("diagram/index.html",from)%>">UML diagrams</a></li>
<%end%>

<%= luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
