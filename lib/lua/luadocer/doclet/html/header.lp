<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
if module_doc then
	from = "modules/"..module_doc.name
elseif file_doc then
	from = "files/.."..file_doc.name
elseif functions then
	from = "functions/"..functions.name
else
	from = ""
end
%>
<meta http-equiv="Content-Type" content="text/html; charset=<%= doc.charset %>" />
<meta name="description" content="LuaDoc documentation" />
<meta name="keywords" content="documentation" />
<meta name="robots" content="index,follow" />
<title><%= (doc.project_name and (title and doc.sh(title).." | "..doc.sh(doc.project_name) or doc.sh(doc.project_name)) or (title and doc.sh(title) or "Project documentation")) %></title>

<% for _, name in ipairs(extra_css or {}) do %>
	<link rel="stylesheet" href="<%=luadoc.doclet.html.link(name, (file_doc and "doesnt_matter/"..file_doc.name or (module_doc and "doesnt_matter/"..module_doc.name or "")))%>" type="text/css" />
<% end %>
	<link rel="stylesheet" href="<%=luadoc.doclet.html.link('luadoc.css',(file_doc and "doesnt_matter/"..file_doc.name or (module_doc and "doesnt_matter/"..module_doc.name or "")))%>" type="text/css" />


	<script type='text/javascript' src="<%=luadoc.doclet.html.link("jquery.js", from)%>"></script>
<% for _, name in ipairs(extra_javascript or {}) do %>
	<script type='text/javascript' src="<%=luadoc.doclet.html.link(name, from)%>"></script>
<% end %>

</head>

<body>
<div id="container">

<div id="main_navigation">
	<a href='<%= luadoc.doclet.html.link("index.html",from) %>'><%= doc.sh(doc.project_name) or "Home" %></a>
	<% if(location and type(location)=="table") then
		for _,loc in ipairs(location) do
			%> &raquo; <a href='<%= loc[2] %>'><%= doc.sh(loc[1]) %></a> <%
		end
	end%>
</div>

<div id="main">

<div id="navigation">
<%=luadoc.doclet.html.include("menu.lp", {doc=doc, file_doc=file_doc, module_doc=module_doc })%>

</div> <!-- id="navigation" -->

<div id="content">
