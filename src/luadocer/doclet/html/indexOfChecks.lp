<% luadoc.doclet.html.include("header.lp", {title="Static check", doc=doc, checks=analysis_results,file_doc={name="dummy"}, location={{"Static check","index.html"}}}) %>

<h1>Static analysis of Lua source codes </h1>
<% for _, v in ipairs(checks) do %>
	<%v.name = v.name:gsub('^/','') %>
	<% if v.status == "Failure" then %>
	
	<h4>File: '<%=v.name%>' <font color="red">FAIL</font></h4>
	<a href='#' class='toggle_source' onclick="$(this).next().slideToggle(); return false;"><pre><%=v.info%></pre></a> 
	<div  class="syntax" style="display: none">
		<pre><%=v.result%></pre>
	</div>
	<br>
	<%else%>
	<h4>File '<%=v.name%>' <font color="green">OK</font></h4>
	<%end%>
<%end%>
