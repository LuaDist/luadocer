<%
local extra_javascript = {'jquery-ui.min.js'}
local extra_css = {'jquery-ui-1.8.11.custom.css','indexOfFunctions.css'}
%>

<% luadoc.doclet.html.include("header.lp", {title="List of functions", doc=doc, file_doc={name="dummy"}, location={{"List of functions","index.html"}}, extra_javascript= extra_javascript, extra_css= extra_css }) %>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#tabs").tabs();
			$("#tabs2").tabs();
			$("#tabs3").tabs();
		});
	</script>

<h1>List of functions</h1>
<%local commonpath = doc.pathprefix(metrics.functionDefinitions)%>
<p>Original directory of source files : <%=commonpath%></p>
<p>Indexed list of all functions in the files.</p>

<h2>Functions</h2>
<%
	local letterTable = {}

	for _, fun in ipairs(metrics.functionDefinitions) do
		local firstLetter = string.char(string.byte(fun.name))
		if (letterTable[firstLetter] == nil) then letterTable[firstLetter] = {} end
		table.insert(letterTable[firstLetter], fun)
	end

	local sortedTable = {}
	
	for key in pairs(letterTable) do table.insert(sortedTable, key) end
	table.sort(sortedTable)

	local ULstring = ''
	local DIVstring = ''
	local fragment_count = #sortedTable
	local commentedDIVstring=''
	local commentedULstring = ''
	local uncommentedDIVstring=''
	local uncommentedULstring = ''

	local lastfragmentnumberComm  = -1  -- checks if fragment is already in commented ul
	local lastfragmentnumberUncomm  = -1  -- checks if fragment is already in uncommented ul

	for fragment_number, key in ipairs(sortedTable) do	
		ULstring = ULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
		DIVstring = DIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		commentedDIVstring = commentedDIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		uncommentedDIVstring = uncommentedDIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		for _, fun in pairs(letterTable[key]) do
			DIVstring = DIVstring .. fun.fcntype
			
			if(fun.documented == 1) then
				if(fragment_number ~=lastfragmentnumberComm) then
					lastfragmentnumberComm = fragment_number
					commentedULstring = commentedULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
				end
				commentedDIVstring = commentedDIVstring .. fun.fcntype
				commentedDIVstring = commentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
				commentedDIVstring = commentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. '&emsp; ' .. doc.sh(fun.comment or '') .. ' <br/>\n'
				
			else
				if(fragment_number ~=lastfragmentnumberUncomm) then
					lastfragmentnumberUncomm = fragment_number
					uncommentedULstring = uncommentedULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
				end
				uncommentedDIVstring = uncommentedDIVstring .. fun.fcntype
				uncommentedDIVstring = uncommentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
				uncommentedDIVstring = uncommentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. ' <br />\n'
			end					
			
			DIVstring = DIVstring ..  '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
			--DIVstring = DIVstring ..  '(<a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#src' .. fun.name .. '">src</a>)'
			DIVstring = DIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. '&emsp;'  .. doc.sh(fun.comment or '') .. ' <br />\n'
		end
		DIVstring = DIVstring .. '\t</div>'
		commentedDIVstring = commentedDIVstring .. '\t</div>'
		uncommentedDIVstring = uncommentedDIVstring .. '\t</div>'

	end
%>
<div id="tabs">
    <ul>
		<%=ULstring%>
        <li><a href="#fragment-<%=fragment_count+1%>"><span>Local</span></a></li>
        <li><a href="#fragment-<%=fragment_count+2%>"><span>Global</span></a></li>
        <li><a href="#fragment-<%=fragment_count+3%>"><span>Anonymous</span></a></li>	
	<li><a href="#fragment-<%=fragment_count+4%>"><span>All</span></a></li>
        <li><a href="#fragment-<%=fragment_count+5%>"><span>Tree</span></a></li>
	
</ul>
    <%=DIVstring%>
    <div id="fragment-<%=fragment_count+1%>">
<%        for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'local' then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				- <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  .. (fInfo.comment or '')%> <br /> 
<%			end
		end%>
    </div>
    <div id="fragment-<%=fragment_count+2%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'global' then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				- <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
<%			end
		end%>

    </div>
    <div id="fragment-<%=fragment_count+3%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'anonymous' then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				- <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
<%			end
		end%>

    </div>
    
    
    <div id="fragment-<%=fragment_count+4%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
%>			<%=fInfo.fcntype%>
			<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
			 - <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  ..(fInfo.comment or '')%> <br />
<%		end %>
    </div>
    <div id="fragment-<%=fragment_count+5%>">
    
		<%	function drawTree(node, filepath) %>
			<% for _ ,fun in pairs(node.metrics.functiontree) do	%>
				<li>
					<% if (#fun.metrics.functiontree > 0) then %>
						<a href="#" class='toggler' onclick="return menu_toggle(this);">[+]</a> 
					<% end %>
					<% if (fun.isGlobal) then %> global <% elseif (fun.fcntype == 'anonymous') then %> anonymous <%else%> local <% end %>
					<a href="<%=luadoc.doclet.html.file_link(filepath,"functionlist/index.html")%>#<%=fun.name%>"> 
					<%=fun.name%> </a>
					<ul style="list-style-type: none;">	
						<% drawTree(fun, filepath) %>
					</ul>
				</li>
			<%	end
			end
		%>
    
        <div>
			<ul id="functiontree" class='menulist' style="list-style-type: none;">
			<%	for filename, AST in pairs(metrics.file_AST_list) do %>
				<li>
					<a href="#" class='toggler' onclick="return menu_toggle(this);">[+]</a> 
					<a href="<%=luadoc.doclet.html.file_link(filename,"functionlist/index.html")%>"><%=' .' .. doc.pathsuffix(commonpath,filename)%></a>
					<ul style="list-style-type: none;">
						<% drawTree(AST, filename) %>
					</ul>
				</li>	
			<%	end %>
			</ul>
		</div>
	</div>
</div>

<%                
                                                                                
							%>

<%fragment_count = fragment_count + 5%>
	
<h2>Documented functions</h2>
<%if(commentedULstring~='') then%>
<div id="tabs2">
	<ul>
	
		<%=commentedULstring%>
        <li><a href="#fragment-<%=fragment_count+1%>"><span>Local</span></a></li>
        <li><a href="#fragment-<%=fragment_count+2%>"><span>Global</span></a></li>
        <li><a href="#fragment-<%=fragment_count+3%>"><span>Anonymous</span></a></li>	
	<li><a href="#fragment-<%=fragment_count+4%>"><span>All</span></a></li>

	</ul>
    <%=commentedDIVstring%>
    
    
        <div id="fragment-<%=fragment_count+1%>">
		<%        for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'local' and fInfo.documented == 1 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						- <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  .. (fInfo.comment or '')%> <br /> 
		<%			end
			end%>
    </div>

        <div id="fragment-<%=fragment_count+2%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'global' and fInfo.documented == 1 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						- <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
		<%			end
				end%>

    </div>

        <div id="fragment-<%=fragment_count+3%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'anonymous'  and fInfo.documented == 1 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						- <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
		<%			end
				end%>
    </div>

    <div id="fragment-<%=fragment_count+4%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.documented == 1 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 - <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  ..(fInfo.comment or '')%> <br />
		<%			end
				end %>
    </div>



    
</div>
<%else%>
<ul>There are no documented functions</ul>
<%end%>






<%fragment_count = fragment_count + 4%>

<h2>NOT documented functions</h2>
<%if(uncommentedULstring~='') then%>
<div id="tabs3">
	<ul>
		<%=uncommentedULstring%>
        <li><a href="#fragment-<%=fragment_count+1%>"><span>Local</span></a></li>
        <li><a href="#fragment-<%=fragment_count+2%>"><span>Global</span></a></li>
        <li><a href="#fragment-<%=fragment_count+3%>"><span>Anonymous</span></a></li>	
	<li><a href="#fragment-<%=fragment_count+4%>"><span>All</span></a></li>

</ul>
    <%=uncommentedDIVstring%>
        <div id="fragment-<%=fragment_count+1%>">
		<%        for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'local' and fInfo.documented == 0 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						- <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  .. (fInfo.comment or '')%> <br /> 
		<%			end
			end%>
    </div>

        <div id="fragment-<%=fragment_count+2%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'global' and fInfo.documented == 0 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						- <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
		<%			end
				end%>

    </div>

        <div id="fragment-<%=fragment_count+3%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'anonymous'  and fInfo.documented == 0 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						- <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
		<%			end
				end%>
    </div>

    <div id="fragment-<%=fragment_count+4%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.documented == 0 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 - <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  ..(fInfo.comment or '')%> <br />
		<%			end
				end %>
    </div>

</div>
<%else%>
<ul>There are no non-documented functions</ul>
<%end%>


<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
