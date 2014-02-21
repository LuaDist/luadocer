<%
local extra_javascript = {'jquery-ui.min.js'}
local extra_css = {'jquery-ui-1.8.11.custom.css','indexOfFunctions.css'}
%>

<% luadoc.doclet.html.include("header.lp", {title="Info comments", doc=doc, file_doc={name="dummy"}, location={{"Info comments","custom.html"}}, extra_javascript= extra_javascript, extra_css= extra_css }) %>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#tabs").tabs();
		});
	</script>


<h1>Informational comments</h1>

<%
local todofiles='<ul>'
local bugfiles='<ul>'
local questionfiles='<ul>'
local fixmefiles = '<ul>'
local howfiles = '<ul>'
local infofiles = '<ul>'
local from="customcommentlist/custom.lp"

local metrics
local paths={}

for k,file in ipairs(doc.files)do
		paths[k]={path=file}
end



for k,file in pairs(doc.files)do
	if(type(file)=="table")then
		if(file.metricsAST)then
			--^ `todo comments`
			if(#file.metricsAST.metrics.documentMetrics.todos>0)then
				todofiles = todofiles .. '\n<li><a href="' .. doc.sh(luadoc.doclet.html.file_link(file.name,from)) .. '">.' .. (doc.pathsuffix(doc.pathprefix(paths),file.name )) .. "</a><br>"
				todofiles = todofiles .. "<ol>"		
				for k,v in pairs(file.metricsAST.metrics.documentMetrics)  do
				   	-- io.write(" key  ",k)
				   	if(k=="todos" and #v>0)then
				   		for i,todocomment in ipairs(v) do
				   			todofiles = todofiles .. "<li>" .."<a href='".. doc.sh(luadoc.doclet.html.file_link(file.name,from)).. "#TODO" .. i .. "'>" ..todocomment.parsed.text .. "</a></li>"
				   		end
				  	end
				end
				todofiles = todofiles .. "</ol>"		
				todofiles = todofiles .. "</li>"	
			end	
			--v
			--^ `bug comments`
			if(#file.metricsAST.metrics.documentMetrics.bugs>0)then
				bugfiles = bugfiles .. '\n<li><a href="' .. doc.sh(luadoc.doclet.html.file_link(file.name,from)) .. '">.' .. (doc.pathsuffix(doc.pathprefix(paths),file.name )) .. "</a><br>"
				bugfiles = bugfiles .. "<ol>"		
				for k,v in pairs(file.metricsAST.metrics.documentMetrics)  do
				   	-- io.write(" key  ",k)
				   	if(k=="bugs" and #v>0)then
				   		for i,bugcomment in ipairs(v) do
				   			bugfiles = bugfiles .. "<li>".."<a href='".. doc.sh(luadoc.doclet.html.file_link(file.name,from)).. "#bug" .. i .. "'>"  ..bugcomment.parsed.text .. "</a></li>"
				   		end
				  	end
				end
				bugfiles = bugfiles .. "</ol>"		
				bugfiles = bugfiles .. "</li>"	
			end	
			--v
			--^ `question comments`
			if(#file.metricsAST.metrics.documentMetrics.questions>0)then
				questionfiles = questionfiles .. '\n<li><a href="' .. doc.sh(luadoc.doclet.html.file_link(file.name,from)) .. '">.' .. (doc.pathsuffix(doc.pathprefix(paths),file.name )) .. "</a><br>"
				questionfiles = questionfiles .. "<ol>"		
				for k,v in pairs(file.metricsAST.metrics.documentMetrics)  do
				   	-- io.write(" key  ",k)
				   	if(k=="questions" and #v>0)then
				   		for i,questioncomment in ipairs(v) do
				   			questionfiles = questionfiles .. "<li>" .."<a href='".. doc.sh(luadoc.doclet.html.file_link(file.name,from)).. "#question" .. i .. "'>" ..questioncomment.parsed.text .. "</a></li>"
				   		end
				  	end
				end
				questionfiles = questionfiles .. "</ol>"		
				questionfiles = questionfiles .. "</li>"	
			end	
			--v
			--^ `fixme comments`
			if(#file.metricsAST.metrics.documentMetrics.fixmes>0)then
				fixmefiles = fixmefiles .. '\n<li><a href="' .. doc.sh(luadoc.doclet.html.file_link(file.name,from)) .. '">.' .. (doc.pathsuffix(doc.pathprefix(paths),file.name )) .. "</a><br>"
				fixmefiles = fixmefiles .. "<ol>"		
				for k,v in pairs(file.metricsAST.metrics.documentMetrics)  do
				   	-- io.write(" key  ",k)
				   	if(k=="fixmes" and #v>0)then
				   		for i,fixmecomment in ipairs(v) do
				   			fixmefiles = fixmefiles .. "<li>" .."<a href='".. doc.sh(luadoc.doclet.html.file_link(file.name,from)).. "#fixme" .. i .. "'>" ..fixmecomment.parsed.text .. "</a></li>"
				   		end
				  	end
				end
				fixmefiles = fixmefiles .. "</ol>"		
				fixmefiles = fixmefiles .. "</li>"	
			end	
			--v
			--^ `how comments`
			if(#file.metricsAST.metrics.documentMetrics.hows>0)then
				howfiles = howfiles .. '\n<li><a href="' .. doc.sh(luadoc.doclet.html.file_link(file.name,from)) .. '">.' .. (doc.pathsuffix(doc.pathprefix(paths),file.name )) .. "</a><br>"
				howfiles = howfiles .. "<ol>"		
				for k,v in pairs(file.metricsAST.metrics.documentMetrics)  do
				   	-- io.write(" key  ",k)
				   	if(k=="hows" and #v>0)then
				   		for i,howcomment in ipairs(v) do
				   			howfiles = howfiles .. "<li>" .."<a href='".. doc.sh(luadoc.doclet.html.file_link(file.name,from)).. "#how" .. i .. "'>" ..howcomment.parsed.text .. "</a></li>"
				   		end
				  	end
				end
				howfiles = howfiles .. "</ol>"		
				howfiles = howfiles .. "</li>"	
			end	
			--v
			--^ `info comments`
			if(#file.metricsAST.metrics.documentMetrics.infos>0)then
				infofiles = infofiles .. '\n<li><a href="' .. doc.sh(luadoc.doclet.html.file_link(file.name,from)) .. '">.' .. (doc.pathsuffix(doc.pathprefix(paths),file.name )) .. "</a><br>"
				infofiles = infofiles .. "<ol>"		
				for k,v in pairs(file.metricsAST.metrics.documentMetrics)  do
				   	-- io.write(" key  ",k)
				   	if(k=="infos" and #v>0)then
				   		for i,infocomment in ipairs(v) do
				   			infofiles = infofiles .. "<li>" .."<a href='".. doc.sh(luadoc.doclet.html.file_link(file.name,from)).. "#info" .. i .. "'>" ..infocomment.parsed.text .. "</a></li>"
				   		end
				  	end
				end
				infofiles = infofiles .. "</ol>"		
				infofiles = infofiles .. "</li>"	
			end	
			--v
		end
	end
end

todofiles= todofiles .. "</ul>"	
bugfiles = bugfiles .. "</ul>"	
questionfiles= questionfiles ..  '</ul>'
fixmefiles= fixmefiles ..  '</ul>'
howfiles= howfiles ..  '</ul>'
infofiles= infofiles ..  '</ul>'
%>

<div id="tabs">
	<ul>
		<li><a href="#tab1">What TODO?</a></li>
		<li><a href="#tab2">Here are BUGs:</a></li>
		<li><a href="#tab3">Some questions:</a></li>
		<li><a href="#tab4">Fix me please!</a></li>
		<li><a href="#tab5">Infos:</a></li>
		<li><a href="#tab6">How:</a></li>
	</ul>
	<div id="tab1">
		<%=todofiles%>
	</div>
	<div id="tab2">
		<%=bugfiles%>
	</div>
	<div id="tab3">
		<%=questionfiles%>
	</div>
	<div id="tab4">
		<%=fixmefiles%>
	</div>
	<div id="tab5">
			<%=infofiles%>
	</div>
	<div id="tab6">
			<%=howfiles%>
	</div>
</div>

<%= luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
