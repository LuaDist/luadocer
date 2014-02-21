<%
local extra_javascript = {'jquery-ui.min.js'}
local extra_css = {'jquery-ui-1.8.11.custom.css','indexOfFunctions.css'}
%>

<% luadoc.doclet.html.include("header.lp", {title="List of tables", doc=doc, file_doc={name="dummy"}, location={{"List of tables","index.html"}}, extra_javascript= extra_javascript, extra_css= extra_css }) %>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#tabs").tabs();
			$("#tabs2").tabs();
			$("#tabs3").tabs();
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

<h1>List of tables</h1>
<%local commonpath = doc.pathprefix(metrics.tables)%>
<p>Indexed list of all tables in the files.</p>
<form id="myform">
		<input type="checkbox" class="myCheckbox" />
			Show table-field tables and anonymous tables.
</form>
<%	local letterTable = {}
	for k, v in pairs(metrics.tables) do
		local firstLetter = string.char(string.byte(v.name))
		if(firstLetter~="#")then
			if (letterTable[firstLetter] == nil) then letterTable[firstLetter] = {} end
			table.insert(letterTable[firstLetter], v)
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

	local lastfragmentnumberComm  = -1  -- checks if fragment is already in commented ul
	local lastfragmentnumberUncomm  = -1  -- checks if fragment is already in uncommented ul

for fragment_number, key in ipairs(sortedTable) do	
		ULstring = ULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
		DIVstring = DIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		commentedDIVstring = commentedDIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		uncommentedDIVstring = uncommentedDIVstring .. '\t<div id="fragment-'.. fragment_number ..'">\n'
		for k, table in pairs(letterTable[key]) do
			if(table.ttype == 'table-field' or table.ttype=="anonymous")then
				DIVstring = DIVstring .. '<span class="tohide">'
			end
			if(table.documented == 1) then
				if(fragment_number ~=lastfragmentnumberComm) then
					lastfragmentnumberComm = fragment_number
					commentedULstring = commentedULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
				end
				if(table.ttype=='table-field' or table.ttype=="anonymous")then  
					commentedDIVstring = commentedDIVstring .. '<span class="tohide">'
					commentedDIVstring = commentedDIVstring .. (table.ttype )
					commentedDIVstring = commentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(table.path,"tablelist/index.html") .. '#' .. table.name .. '">' ..table.name .. '</a>'
					commentedDIVstring = commentedDIVstring ..  ' - ./' .. doc.pathsuffix(commonpath,table.path) .. '&emsp; ' .. doc.sh(table.comment or '') ..' <br />\n'
					commentedDIVstring = commentedDIVstring ..'</span>'
				else 
					commentedDIVstring = commentedDIVstring .. (table.ttype )
					commentedDIVstring = commentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(table.path,"tablelist/index.html") .. '#' .. table.name .. '">' ..table.name .. '</a>'
					commentedDIVstring = commentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp; ' .. doc.sh(table.comment or '') ..' <br />\n'
				end
			else
				if(fragment_number ~=lastfragmentnumberUncomm) then
					lastfragmentnumberUncomm = fragment_number
					uncommentedULstring = uncommentedULstring .. '<li><a href="#fragment-' .. fragment_number ..'"><span>'..key..'</span></a></li>\n'
				end
				if(table.ttype=='table-field'or table.ttype=="anonymous")then  
					uncommentedDIVstring = uncommentedDIVstring .. '<span class="tohide">'
					uncommentedDIVstring = uncommentedDIVstring .. (table.ttype )
					uncommentedDIVstring = uncommentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(table.path,"tablelist/index.html") .. '#' .. table.name  .. '">' ..table.name .. '</a>'
					uncommentedDIVstring = uncommentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,table.path) .. ' <br />\n'
					uncommentedDIVstring = uncommentedDIVstring .. '</span>'
				else 
					uncommentedDIVstring = uncommentedDIVstring .. (table.ttype )
					uncommentedDIVstring = uncommentedDIVstring .. '\t\t <a href="' .. luadoc.doclet.html.file_link(table.path,"tablelist/index.html") .. '#' .. table.name  .. '">' ..table.name .. '</a>'
					uncommentedDIVstring = uncommentedDIVstring ..  ' - .' .. doc.pathsuffix(commonpath,table.path) .. ' <br />\n'
				end
			end					
			DIVstring = DIVstring .. table.ttype 
			DIVstring = DIVstring ..  '\t\t <a href="' .. luadoc.doclet.html.file_link(table.path,"tablelist/index.html") .. '#' .. table.name  .. '">'  .. table.name .. '</a>'
			DIVstring = DIVstring ..  ' - .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  .. doc.sh(table.comment or '') .. ' <br />\n'
			if(table.ttype == 'table-field'or table.ttype=="anonymous")then
					DIVstring = DIVstring .. '</span>'
			end
		end
		DIVstring = DIVstring .. '\t</div>'
		commentedDIVstring = commentedDIVstring .. '\t</div>'
		uncommentedDIVstring = uncommentedDIVstring .. '\t</div>'
		
	end

table.sort(metrics.tables, function(a,b) return a.name<b.name end)
%>

<% --all
%>
<h2>Tables</h2>
<div id="tabs">
	<ul>
	<%=ULstring%>
		<li class="tohide"><a href="#fragment-<%=fragment_count+1%>"><span>Table-field</span></a></li>	
		<li class="tohide"><a href="#fragment-<%=fragment_count+2%>"><span>Anonymous</span></a></li>	
		<li><a href="#fragment-<%=fragment_count+3%>"><span>All</span></a></li>
	</ul>
	<%=DIVstring%>
 <div id="fragment-<%=fragment_count+1%>">
<%		for k, table in pairs(metrics.tables) do
			if table.ttype == 'table-field' then %>
				<span class="tohide">
				<%=table.ttype%>
				<a href="<%=luadoc.doclet.html.file_link(table.path,"tablelist/index.html")%>#<%=table.name%>"> <%=table.name%> </a>
				  <%='- .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  ..(table.comment or '')%> <br />
				</span>
			<%end%>
		<%end%>
    </div>
     <div id="fragment-<%=fragment_count+2%>">
<%		for k, table in pairs(metrics.tables) do
			if  table.ttype=="anonymous" then %>
				<span class="tohide">
				<%=table.ttype%>
				<a href="<%=luadoc.doclet.html.file_link(table.path,"tablelist/index.html")%>#<%=table.name%>"> <%=table.name%> </a>
				  <%='- .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  ..(table.comment or '')%> <br />
				</span>
			<%end%>
<%		end %>
    </div>

	 <div id="fragment-<%=fragment_count+3%>">
<%		for k, table in pairs(metrics.tables) do
			if table.ttype == 'table-field' or table.ttype=="anonymous" then %><span class="tohide"><%end%>
			<%=table.ttype%>
			<a href="<%=luadoc.doclet.html.file_link(table.path,"tablelist/index.html")%>#<%=table.name%>"> <%=table.name%> </a>
			  <%='- .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  ..(table.comment or '')%> <br />
			<%if table.ttype == 'table-field' or table.ttype=="anonymous" then %></span><%end%>
<%		end %>
    </div>
	
</div>


<%fragment_count = fragment_count + 3%>

<% --documented
%>
<h2>Documented tables</h2>

<%if(commentedULstring~='') then%>
<div id="tabs2">
	<ul>
		<%=commentedULstring%>
		<li class="tohide"><a href="#fragment-<%=fragment_count+1%>"><span>Table-field</span></a></li>	
		<li class="tohide"><a href="#fragment-<%=fragment_count+2%>"><span>Anonymous</span></a></li>	
		<li><a href="#fragment-<%=fragment_count+3%>"><span>All</span></a></li>
	</ul>
    <%=commentedDIVstring%>
 <div id="fragment-<%=fragment_count+1%>">
<%		for k, table in pairs(metrics.tables) do
			if table.ttype == 'table-field'and table.documented==1 then %>
				<span class="tohide">
				<%=table.ttype%>
				<a href="<%=luadoc.doclet.html.file_link(table.path,"tablelist/index.html")%>#<%=table.name%>"> <%=table.name%> </a>
				  <%='- .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  ..(table.comment or '')%> <br />
				</span>
			<%end%>
		<%end%>
    </div>
     <div id="fragment-<%=fragment_count+2%>">
<%		for k, table in pairs(metrics.tables) do
			if  table.ttype=="anonymous" and table.documented==1 then %>
				<span class="tohide">
				<%=table.ttype%>
				<a href="<%=luadoc.doclet.html.file_link(table.path,"tablelist/index.html")%>#<%=table.name%>"> <%=table.name%> </a>
				  <%='- .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  ..(table.comment or '')%> <br />
				</span>
			<%end%>
<%		end %>
    </div>

	 <div id="fragment-<%=fragment_count+3%>">
<%		for k, table in pairs(metrics.tables) do %>
<%			if(table.documented==1)then
			%>
<%				if table.ttype == 'table-field' or table.ttype=="anonymous" then %><span class="tohide"><%end%>
				<%=table.ttype%>
				<a href="<%=luadoc.doclet.html.file_link(table.path,"tablelist/index.html")%>#<%=table.name%>"> <%=table.name%> </a>
				  <%='- .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  ..(table.comment or '')%> <br />
				<%if table.ttype == 'table-field' or table.ttype=="anonymous" then %></span><%end%>
<%	end	end %>
    </div>

</div>


<%else%>
<ul>There are no documented tables</ul>
<%end%>

<%fragment_count = fragment_count + 3%>

<% --not documented
%>
<h2>NOT documented tables</h2>
<%if(uncommentedULstring~='') then%>
<div id="tabs3">
	<ul>
		<%=uncommentedULstring%>
		<li class="tohide"><a href="#fragment-<%=fragment_count+1%>"><span>Table-field</span></a></li>	
		<li class="tohide"><a href="#fragment-<%=fragment_count+2%>"><span>Anonymous</span></a></li>	
		<li><a href="#fragment-<%=fragment_count+3%>"><span>All</span></a></li>
</ul>
    <%=uncommentedDIVstring%>
 <div id="fragment-<%=fragment_count+1%>">
<%		for k, table in pairs(metrics.tables) do
			if table.ttype == 'table-field'and (table.documented==0 or table.documented==nil) then %>
				<span class="tohide">
				<%=table.ttype%>
				<a href="<%=luadoc.doclet.html.file_link(table.path,"tablelist/index.html")%>#<%=table.name%>"> <%=table.name%> </a>
				  <%='- .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  ..(table.comment or '')%> <br />
				</span>
			<%end%>
		<%end%>
    </div>
     <div id="fragment-<%=fragment_count+2%>">
<%		for k, table in pairs(metrics.tables) do
			if  table.ttype=="anonymous" and (table.documented==0 or table.documented==nil) then %>
				<span class="tohide">
				<%=table.ttype%>
				<a href="<%=luadoc.doclet.html.file_link(table.path,"tablelist/index.html")%>#<%=table.name%>"> <%=table.name%> </a>
				  <%='- .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  ..(table.comment or '')%> <br />
				</span>
			<%end%>
<%		end %>
    </div>


     <div id="fragment-<%=fragment_count+3%>">
<%		for k, table in pairs(metrics.tables) do
			if(table.documented==0  or table.documented==nil)then
			%>
			<%	if table.ttype == 'table-field'or table.ttype=="anonymous" then %><span class="tohide"><%end%>
			<%=table.ttype%>
			<a href="<%=luadoc.doclet.html.file_link(table.path,"tablelist/index.html")%>#<%=table.name%>"> <%=table.name%> </a>
			  <%='- .' .. doc.pathsuffix(commonpath,table.path) .. '&emsp;'  ..(table.comment or '')%> <br />
			 <%if table.ttype == 'table-field'or table.ttype=="anonymous" then %></span><%end%>
<%	end	end %>
    </div>
    
</div>
<%else%>
<ul>There are no non-documented tables</ul>
<%end%>


<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
