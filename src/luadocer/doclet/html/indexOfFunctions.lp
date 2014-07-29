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
			$("#tabs4").tabs();
			$("#tabs5").tabs();
			$(".tohide").hide();
			$(".myCheckbox").click(function() {
			    if($(this).is(":checked")) 
				{
					$(".tohide").show();
				}else			
				{
					$(".tohide").hide();
				}
			});
		});
		
		
	</script>

<h1>List of functions</h1>
<%local commonpath = doc.pathprefix(metrics.functionDefinitions)%>
<p>Indexed list of all functions in the files.</p>

	<form id="myform">
		<input type="checkbox" class="myCheckbox" />
			Show table-field functions and anonymous functions.
	</form>
<h2>Functions</h2>
<%
	local letterTable = {}

	for _, fun in ipairs(metrics.functionDefinitions) do
		local firstLetter = string.char(string.byte(fun.name))
		if(firstLetter~="#")then
			if (letterTable[firstLetter] == nil) then letterTable[firstLetter] = {} end
			table.insert(letterTable[firstLetter], fun)
		end
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
	--added by Peter Mendel 05/2014
	local partcommentedDIVstring=''
	local partcommentedULstring = ''
	local nostcommentedDIVstring=''
	local nostcommentedULstring = ''

	local lastfragmentnumberPartcomm  = -1
	local lastfragmentnumberNoStcomm  = -1
	--end Peter Mendel
	local lastfragmentnumberComm  = -1  -- checks if fragment is already in commented ul
	local lastfragmentnumberUncomm  = -1  -- checks if fragment is already in uncommented ul

	for fragment_number, key in ipairs(sortedTable) do	
		ULstring = ULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
		DIVstring = DIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		commentedDIVstring = commentedDIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		uncommentedDIVstring = uncommentedDIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		partcommentedDIVstring = partcommentedDIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		nostcommentedDIVstring = nostcommentedDIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		for _, fun in pairs(letterTable[key]) do
			if(fun.fcntype == 'table-field' or fun.fcntype=="anonymous")then
				DIVstring = DIVstring .. '<span class="tohide">'
			end
			DIVstring = DIVstring .. fun.fcntype
			
			if(fun.documented == 1) then
				if(fragment_number ~=lastfragmentnumberComm) then
					lastfragmentnumberComm = fragment_number
					commentedULstring = commentedULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
				end
				if(fun.fcntype == 'table-field' or fun.fcntype=="anonymous")then
				commentedDIVstring = commentedDIVstring .. '<span class="tohide">'				
				commentedDIVstring = commentedDIVstring .. fun.fcntype
				commentedDIVstring = commentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
				commentedDIVstring = commentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. '&emsp; ' .. doc.sh(fun.comment or '') .. ' <br/>\n </span>'
				else
					commentedDIVstring = commentedDIVstring .. fun.fcntype
					commentedDIVstring = commentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
					commentedDIVstring = commentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. '&emsp; ' .. doc.sh(fun.comment or '') .. ' <br/>\n'
				end			
			elseif(fun.documented == 0) then
				if(fragment_number ~=lastfragmentnumberUncomm) then
					lastfragmentnumberUncomm = fragment_number
					uncommentedULstring = uncommentedULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
				end
				if(fun.fcntype == 'table-field'or fun.fcntype=="anonymous")then
					uncommentedDIVstring = uncommentedDIVstring .. '<span class="tohide">'
					uncommentedDIVstring = uncommentedDIVstring .. fun.fcntype
					uncommentedDIVstring = uncommentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
					uncommentedDIVstring = uncommentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. ' <br />\n</span>'
				else
					uncommentedDIVstring = uncommentedDIVstring .. fun.fcntype
					uncommentedDIVstring = uncommentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
					uncommentedDIVstring = uncommentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. ' <br />\n'				
				end
				--added option fun.documented 2 and 3 to recognize partly documented and not standard documented
				--functions, by Peter Mendel 05/2014
			elseif(fun.documented == 2) then
				if(fragment_number ~=lastfragmentnumberPartcomm) then
					lastfragmentnumberPartcomm = fragment_number
					partcommentedULstring = partcommentedULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
				end
				if(fun.fcntype == 'table-field' or fun.fcntype=="anonymous")then
				partcommentedDIVstring = partcommentedDIVstring .. '<span class="tohide">'				
				partcommentedDIVstring = partcommentedDIVstring .. fun.fcntype
				partcommentedDIVstring = partcommentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
				partcommentedDIVstring = partcommentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. ' <br />\n</span>'
				else
					partcommentedDIVstring = partcommentedDIVstring .. fun.fcntype
					partcommentedDIVstring = partcommentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
					partcommentedDIVstring = partcommentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. ' <br />\n'
				end
			elseif(fun.documented == 3) then
				if(fragment_number ~=lastfragmentnumberNoStcomm) then
					lastfragmentnumberNoStcomm = fragment_number
					nostcommentedULstring = nostcommentedULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
				end
				if(fun.fcntype == 'table-field' or fun.fcntype=="anonymous")then
				nostcommentedDIVstring = nostcommentedDIVstring .. '<span class="tohide">'				
				nostcommentedDIVstring = nostcommentedDIVstring .. fun.fcntype
				nostcommentedDIVstring = nostcommentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
				nostcommentedDIVstring = nostcommentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. '&emsp; ' .. doc.sh(fun.comment or '') .. ' <br/>\n </span>'
				else
					nostcommentedDIVstring = nostcommentedDIVstring .. fun.fcntype
					nostcommentedDIVstring = nostcommentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
					nostcommentedDIVstring = nostcommentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. '&emsp; ' .. doc.sh(fun.comment or '') .. ' <br/>\n'
				end
				--end Peter Mendel
			end					
			
			DIVstring = DIVstring ..  '\t\t <a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#' .. fun.name .. '">' ..fun.name.. '</a>'
			--DIVstring = DIVstring ..  '(<a href="' .. luadoc.doclet.html.file_link(fun.path,"functionlist/index.html") .. '#src' .. fun.name .. '">src</a>)'
			DIVstring = DIVstring ..  ' - .' .. doc.pathsuffix(commonpath,fun.path) .. '&emsp;'  .. doc.sh(fun.comment or '') .. ' <br />\n'
			if(fun.fcntype == 'table-field' or fun.fcntype=="anonymous")then
				DIVstring = DIVstring .. '</span>'	
			end
	end
		DIVstring = DIVstring .. '\t</div>'
		commentedDIVstring = commentedDIVstring .. '\t</div>'
		uncommentedDIVstring = uncommentedDIVstring .. '\t</div>'
		partcommentedDIVstring = partcommentedDIVstring .. '\t</div>'
		nostcommentedDIVstring = nostcommentedDIVstring .. '\t</div>'

	end
%>
<%--  vseobecny zoznam
%>
<div id="tabs">
    <ul>
		<%=ULstring%>
        <li><a href="#fragment-<%=fragment_count+1%>"><span>Local</span></a></li>
        <li><a href="#fragment-<%=fragment_count+2%>"><span>Global</span></a></li>
        <li class="tohide"><a href="#fragment-<%=fragment_count+3%>"><span>Table-field</span></a></li>	
		<li class="tohide"><a href="#fragment-<%=fragment_count+4%>"><span>Anonymous</span></a></li>	
		<li><a href="#fragment-<%=fragment_count+5%>"><span>All</span></a></li>
        <li><a href="#fragment-<%=fragment_count+6%>"><span>Tree</span></a></li>
	
</ul>
<%-- locals
%>
    <%=DIVstring%>
    <div id="fragment-<%=fragment_count+1%>">
<%        for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'local' then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  .. (fInfo.comment or '')%> <br /> 
<%			end
		end%>
    </div>
<%-- globals
%>
    <div id="fragment-<%=fragment_count+2%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'global' then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
<%			end
		end%>

    </div>
<%-- table-fields
%>    
    <div class="tohide" id="fragment-<%=fragment_count+3%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'table-field' then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
<%			end
		end%>

    </div>

<%-- anonymous
%>    
    <div class="tohide" id="fragment-<%=fragment_count+4%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'anonymous' then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
<%			end
		end%>

    </div>


    
<%-- all (?)
%>
    <div id="fragment-<%=fragment_count+5%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'table-field'  or fInfo.fcntype=="anonymous" then %><span class="tohide"><%end%>
			<%=fInfo.fcntype%>
			<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
			  <%=' .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  ..(fInfo.comment or '')%> <br />
			<%if fInfo.fcntype == 'table-field'  or fInfo.fcntype=="anonymous" then %></span><%end%>
<%		end %>
    </div>
    <div id="fragment-<%=fragment_count+6%>">
    
		<%	function drawTree(node, filepath) %>
			<% for _ ,fun in pairs(node.metrics.functiontree) do	%>
				<li>
					<% if (#fun.metrics.functiontree > 0) then %>
						<a href="#" class='toggler' onclick="return menu_toggle(this);">[+]</a> 
					<% end %>
					<%=fun.fcntype%>
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

<%--documented functions     
%>

<%fragment_count = fragment_count + 6%>
	
<h2>Documented functions</h2>
<%if(commentedULstring~='') then%>
<div id="tabs2">
	<ul>
	
		<%=commentedULstring%>
        <li><a href="#fragment-<%=fragment_count+1%>"><span>Local</span></a></li>
        <li><a href="#fragment-<%=fragment_count+2%>"><span>Global</span></a></li>
        <li class="tohide"><a href="#fragment-<%=fragment_count+3%>"><span>Table-field</span></a></li>	
		<li class="tohide"><a href="#fragment-<%=fragment_count+4%>"><span>Anonymous</span></a></li>	
		<li><a href="#fragment-<%=fragment_count+5%>"><span>All</span></a></li>

	</ul>
    <%=commentedDIVstring%>
    
<%-- locals
%>
        <div id="fragment-<%=fragment_count+1%>">
		<%        for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'local' and fInfo.documented == 1 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  .. (fInfo.comment or '')%> <br /> 
		<%			end
			end%>
    </div>
<%-- globals
%>
        <div id="fragment-<%=fragment_count+2%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'global' and fInfo.documented == 1 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
		<%			end
				end%>

    </div>
<%-- table fields   -- is it possible to document these types of functions with luadoc(er) ?
%>
        <div class="tohide" id="fragment-<%=fragment_count+3%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'table-field'  and fInfo.documented == 1 then
		%>			<span class="tohide">
						<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br /></span>
		<%			end
				end%>
    </div>

<%-- anonymous
%>    
    <div class="tohide" id="fragment-<%=fragment_count+4%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'anonymous' and fInfo.documented==1 then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
<%			end
		end%>

    </div>


<%-- all
%>
    <div id="fragment-<%=fragment_count+5%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.documented == 1 then
						if fInfo.fcntype == 'table-field' or fInfo.fcntype=="anonymous" then %><span class="tohide"><%end%>
						<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						  <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  ..(fInfo.comment or '')%> <br />
						<%if fInfo.fcntype == 'table-field'  or fInfo.fcntype=="anonymous" then %></span><%end%>
		<%			end
				end %>
    </div>



    
</div>
<%else%>
<ul>There are no documented functions</ul>
<%end%>


<%-- not documented functions
%>
<%fragment_count = fragment_count + 5%>

<h2>NOT documented functions</h2>
<%if(uncommentedULstring~='') then%>
<div id="tabs3">
	<ul>
		<%=uncommentedULstring%>
        <li><a href="#fragment-<%=fragment_count+1%>"><span>Local</span></a></li>
        <li><a href="#fragment-<%=fragment_count+2%>"><span>Global</span></a></li>
        <li class="tohide"><a href="#fragment-<%=fragment_count+3%>"><span>Table-field</span></a></li>	
		<li class="tohide"><a href="#fragment-<%=fragment_count+4%>"><span>Anonymous</span></a></li>	
		<li><a href="#fragment-<%=fragment_count+5%>"><span>All</span></a></li>

</ul>
    <%=uncommentedDIVstring%>
<%-- locals
%>
    <div id="fragment-<%=fragment_count+1%>">
		<%        for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'local' and fInfo.documented == 0 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- ./' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  .. (fInfo.comment or '')%> <br /> 
		<%			end
			end%>
    </div>
<%-- globals
%>
    <div id="fragment-<%=fragment_count+2%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'global' and fInfo.documented == 0 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
		<%			end
				end%>

    </div>
<%-- table fields
%>
    <div class="tohide" id="fragment-<%=fragment_count+3%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'table-field'  and fInfo.documented == 0 then
		%>			<span class="tohide">	<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br /></span>
		<%			end
				end%>
    </div>
<%-- anonymous
%>    
    <div class="tohide" id="fragment-<%=fragment_count+4%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'anonymous' and fInfo.documented==nil then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
<%			end
		end%>

    </div>

<%-- all
%>
    <div id="fragment-<%=fragment_count+5%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.documented == 0  or fInfo.documented == nil then
						if fInfo.fcntype == 'table-field' or fInfo.fcntype=="anonymous" then %><span class="tohide"><%end%>
						<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						  <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  ..(fInfo.comment or '')%> <br />
						<%if fInfo.fcntype == 'table-field'  or fInfo.fcntype=="anonymous" then %></span><%end%>
		<%			end
				end %>
    </div>

</div>
<%else%>
<ul>There are no non-documented functions</ul>
<%end%>

<%--partly documented functions, added by Peter Mendel 05/2014     
%>

<%fragment_count = fragment_count +6%>
	
<h2>Partly documented functions</h2>
<%if(partcommentedULstring~='') then%>
<div id="tabs4">
	<ul>
	
		<%=partcommentedULstring%>
        <li><a href="#fragment-<%=fragment_count+1%>"><span>Local</span></a></li>
        <li><a href="#fragment-<%=fragment_count+2%>"><span>Global</span></a></li>
        <li class="tohide"><a href="#fragment-<%=fragment_count+3%>"><span>Table-field</span></a></li>	
		<li class="tohide"><a href="#fragment-<%=fragment_count+4%>"><span>Anonymous</span></a></li>	
		<li><a href="#fragment-<%=fragment_count+5%>"><span>All</span></a></li>

	</ul>
    <%=partcommentedDIVstring%>
    
<%-- locals
%>
        <div id="fragment-<%=fragment_count+1%>">
		<%        for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'local' and fInfo.documented == 2 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  .. ('')%> <br /> 
		<%			end
			end%>
    </div>
<%-- globals
%>
        <div id="fragment-<%=fragment_count+2%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'global' and fInfo.documented == 2 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. ('')%> <br />
		<%			end
				end%>

    </div>

        <div class="tohide" id="fragment-<%=fragment_count+3%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'table-field'  and fInfo.documented == 2 then
		%>			<span class="tohide">
						<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. ('')%> <br /></span>
		<%			end
				end%>
    </div>

<%-- anonymous
%>    
    <div class="tohide" id="fragment-<%=fragment_count+4%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'anonymous' and fInfo.documented==2 then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. ('')%> <br />
<%			end
		end%>

    </div>


<%-- all
%>
    <div id="fragment-<%=fragment_count+5%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.documented == 2 then
						if fInfo.fcntype == 'table-field' or fInfo.fcntype=="anonymous" then %><span class="tohide"><%end%>
						<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						  <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  ..('')%> <br />
						<%if fInfo.fcntype == 'table-field'  or fInfo.fcntype=="anonymous" then %></span><%end%>
		<%			end
				end %>
    </div>



    
</div>
<%else%>
<ul>There are no partly documented functions</ul>
<%end%>

<%--not standard documented functions, added by Peter Mendel 05/2014   
%>

<%fragment_count = fragment_count +7%>
	
<h2>NOT standardly documented functions</h2>
<%if(nostcommentedULstring~='') then%>
<div id="tabs5">
	<ul>
	
		<%=nostcommentedULstring%>
        <li><a href="#fragment-<%=fragment_count+1%>"><span>Local</span></a></li>
        <li><a href="#fragment-<%=fragment_count+2%>"><span>Global</span></a></li>
        <li class="tohide"><a href="#fragment-<%=fragment_count+3%>"><span>Table-field</span></a></li>	
		<li class="tohide"><a href="#fragment-<%=fragment_count+4%>"><span>Anonymous</span></a></li>	
		<li><a href="#fragment-<%=fragment_count+5%>"><span>All</span></a></li>

	</ul>
    <%=nostcommentedDIVstring%>
    
<%-- locals
%>
        <div id="fragment-<%=fragment_count+1%>">
		<%        for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'local' and fInfo.documented == 3 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  .. (fInfo.comment or '')%> <br /> 
		<%			end
			end%>
    </div>
<%-- globals
%>
        <div id="fragment-<%=fragment_count+2%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'global' and fInfo.documented == 3 then
		%>				<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
		<%			end
				end%>

    </div>

        <div class="tohide" id="fragment-<%=fragment_count+3%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.fcntype == 'table-field'  and fInfo.documented == 3 then
		%>			<span class="tohide">
						<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br /></span>
		<%			end
				end%>
    </div>

<%-- anonymous
%>    
    <div class="tohide" id="fragment-<%=fragment_count+4%>">
<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
			if fInfo.fcntype == 'anonymous' and fInfo.documented==3 then
%>				<%=fInfo.fcntype%>
				<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
				 <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;' .. (fInfo.comment or '')%> <br />
<%			end
		end%>

    </div>


<%-- all
%>
    <div id="fragment-<%=fragment_count+5%>">
		<%		for _, fInfo in ipairs(metrics.functionDefinitions) do
					if fInfo.documented == 3 then
						if fInfo.fcntype == 'table-field' or fInfo.fcntype=="anonymous" then %><span class="tohide"><%end%>
						<%=fInfo.fcntype%>
						<a href="<%=luadoc.doclet.html.file_link(fInfo.path,"functionlist/index.html")%>#<%=fInfo.name%>"> <%=fInfo.name%> </a>
						  <%='- .' .. doc.pathsuffix(commonpath,fInfo.path) .. '&emsp;'  ..(fInfo.comment or '')%> <br />
						<%if fInfo.fcntype == 'table-field'  or fInfo.fcntype=="anonymous" then %></span><%end%>
		<%			end
				end %>
    </div>



    
</div>
<%else%>
<ul>There are no NOT standardly documented functions</ul>
<%end%>
<%--end Peter Mendel
%>
<%--
%>


<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
