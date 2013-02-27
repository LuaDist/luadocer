<%
local extra_javascript = {'jquery-ui.min.js'}
local extra_css = {'jquery-ui-1.8.11.custom.css','indexOfFunctions.css'}
%>

<% luadoc.doclet.html.include("header.lp", {title="List of functions", doc=doc, file_doc={name="dummy"}, location={{"List of functions","index.html"}}, extra_javascript= extra_javascript, extra_css= extra_css }) %>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#tabs").tabs();
		});
	</script>

<h1>List of functions</h1>

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
	
	for fragment_number, key in ipairs(sortedTable) do
		ULstring = ULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
		DIVstring = DIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		for _, fun in pairs(letterTable[key]) do
			DIVstring = DIVstring .. fun.fcntype
			DIVstring = DIVstring ..  '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
			--DIVstring = DIVstring ..  '(<a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#src' .. fun.name .. '">src</a>)'
			DIVstring = DIVstring ..  '- ' .. fun.path .. ' <br />\n'
		end
		DIVstring = DIVstring .. '\t</div>'
	end
%>

<div id="tabs">
    <ul>
		<%=ULstring%>
        <li><a href="#fragment-<%=fragment_count+1%>"><span>Local</span></a></li>
        <li><a href="#fragment-<%=fragment_count+2%>"><span>Global</span></a></li>
        <li><a href="#fragment-<%=fragment_count+3%>"><span>All</span></a></li>
        <li><a href="#fragment-<%=fragment_count+4%>"><span>Tree</span></a></li>
    </ul>
    <%=DIVstring%>
    <div id="fragment-<%=fragment_count+1%>">
<%        for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'local' then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				- <%=fInfo.path%> <br /> 
<%			end
		end%>
    </div>
    <div id="fragment-<%=fragment_count+2%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'global' then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				- <%=fInfo.path%> <br />
<%			end
		end%>

    </div>
    <div id="fragment-<%=fragment_count+3%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
%>			<%=fInfo.fcntype%>
			<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
			 - <%=fInfo.path%> <br />
<%		end %>
    </div>
    <div id="fragment-<%=fragment_count+4%>">
    
		<%	function drawTree(node, filepath) %>
			<% for _ ,fun in pairs(node.metrics.functiontree) do	%>
				<li>
					<% if (#fun.metrics.functiontree > 0) then %>
						<a href="#" class='toggler' onclick="return menu_toggle(this);">[+]</a> 
					<% end %>
					<% if (fun.isGlobal) then %> global <% else %> local <% end %>
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
					<a href="<%=luadoc.doclet.html.file_link(filename,"functionlist/index.html")%>"><%=filename%></a>
					<ul style="list-style-type: none;">
						<% drawTree(AST, filename) %>
					</ul>
				</li>	
			<%	end %>
			</ul>
		</div>
	</div>
</div>


<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
