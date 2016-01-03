<% luadoc.doclet.html.include("header.lp", {title="UML diagrams", doc=doc, diagrams=diagram_results, file_doc={name="dummy"}, location={{"UML diagrams","index.html"}}}) %>


<h1>UML diagrams of Lua source codes </h1>
<% for _, v in ipairs(diagrams) do %>
	<%if v.name == "global" then%>
		<pre style="text-decoration: underline;font-size: 150%;">Global diagram</pre>

		<a href = "<%=luadoc.doclet.html.link((v.path:gsub("^/","../")),"diagram/index.html")%>"><img src="<%=luadoc.doclet.html.link((v.path:gsub("^/","../")),"diagram/index.html")%>"  width=auto> </a><br>

		<a href='#' class='toggle_source' onclick="$(this).next().slideToggle(); return false;"><h2>Show / Hide PlantUML syntax</h2></a> 
		<div  class="syntax" style="display: none">
			<pre><%=v.uml_string%></pre>
		</div>
		<br>
	<%end%>
<%end%>

<% for _, v in ipairs(diagrams) do %>
	<%if v.name ~= "global" then%>
		<pre style="text-decoration: underline;font-size: 150%;">Function <%=v.name%> diagram</pre>
		<a href = "<%=luadoc.doclet.html.link((v.path:gsub("^/","../")),"diagram/index.html")%>"><img src="<%=luadoc.doclet.html.link((v.path:gsub("^/","../")),"diagram/index.html")%>"  width=auto> </a><br>

		<a href='#' class='toggle_source' onclick="$(this).next().slideToggle(); return false;"><h2>Show / Hide PlantUML syntax</h2></a> 
		<div  class="syntax" style="display: none">
			<pre><%=v.uml_string%></pre>
		</div>
		<br>
	<%end%>	
<%end%>