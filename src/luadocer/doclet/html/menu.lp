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

local function in_array(tbl,a)
	for _,v in ipairs(tbl) do
		if(v==a) then
			return true;
		end
	end
	return false;
end

local function get_parts(name,symbol)
	local parts={}
	local last_pos=1
	for pos in name:gmatch("()%"..symbol) do
		table.insert(parts,name:sub(last_pos,pos-1))
		last_pos=pos+1
	end
	if(#parts==0) then
		table.insert(parts,name)
	else
		table.insert(parts,name:sub(last_pos))
	end
	return parts
end

local function print_name(doc_obj,myname,displayname,module)
	if doc_obj and doc_obj.name == myname then%>
		<strong class='active_menu'><%=displayname%></strong>
	<%else%>
		<a href="<%if(module) then%><%=luadoc.doclet.html.module_link(myname, doc, from)%><%else%><%=luadoc.doclet.html.file_link(myname, from)%><%end%>"><%=displayname%></a>
	<%end
end

local function print_table(t)
	for k,v in ipairs(t) do
		%><br />
		KEY="<%=k%>" VAL="<%=v%>"<%
	end
	%><br />
	<%
end

local function hierarchy_menu(doc_obj,collection,symbol,is_module)
	
	local parents_printed={}
	local parents={}
	
	for _, modulename in ipairs(collection) do
		local parts=get_parts(modulename,symbol)
		local parent=""
		for k,v in ipairs(parts) do
			parent=parent..(k>1 and symbol or "")..v;

			if(not parents[v]) then
				if(k~=#parts) then
					parents[parent]=1;
				else
					parents[parent]=2;
				end
			else
				parents[parent]=1;
			end
		end
	end

	local last_level=0;
	for _, modulename in ipairs(collection) do
		local parts=get_parts(modulename,symbol)
		local parent=""
		for k,v in ipairs(parts) do
			parent=parent..(k>1 and symbol or "")..v;
			if(not in_array(parents_printed,parent)) then
				if(k<=last_level) then
					for i=k,last_level do
						%></ul></li><%
					end
				end
				table.insert(parents_printed,parent);
				last_level=k
				%><li><%if(parents[parent]==1) then%><a href="#" class='toggler' onclick="return menu_toggle(this);">[+]</a> <%end print_name(doc_obj,modulename,v,is_module);%><ul>
				<%
			elseif(k>=last_level) then
				%><li><%print_name(doc_obj,modulename,v,is_module);%></li><%
			end
		end
	end
	if(last_level>0) then
		for i=1,last_level do
			%></ul></li><%
		end
	end
end
%>
<script type='text/javascript' src="<%=luadoc.doclet.html.link("menu.js", from)%>"></script>
<h1>LuaDoc</h1>
<ul>
	<li><a href="<%=luadoc.doclet.html.link("index.html", from)%>">Index</a></li>
	<li><a href="<%=luadoc.doclet.html.link("functionlist/index.html", from)%>">List of functions</a></li>
	<li><a href="<%=luadoc.doclet.html.link("tablelist/index.html", from)%>">List of tables</a></li>
	<li><a href="<%=luadoc.doclet.html.link("metrics/index.html", from)%>">Project metrics</a></li>
	<li><a href="<%=luadoc.doclet.html.link("smells/index.html", from)%>">Project code quality</a></li>
	<li><a href="<%=luadoc.doclet.html.link("customcommentlist/customs.html",from)%>">Informational comments</a></li>
	<%if doc.check then%>
	<li><a href="<%=luadoc.doclet.html.link("check/index.html",from)%>">Static analysis</a></li>
	<%end%>
	<%if doc.diagram then%>
	<li><a href="<%=luadoc.doclet.html.link("diagram/index.html",from)%>">UML diagrams</a></li>
	<%end%>
</ul>


<!-- Module list -->
<%if not options.nomodules and #doc.modules > 0 then%>
<h1><a href='<%= luadoc.doclet.html.link("list_of_modules.html",from) %>'>Modules</a></h1>
<ul class='menulist'>
<%hierarchy_menu(module_doc,doc.modules,".",1);%>
</ul>
<%end%>


<!-- File list -->
<%if not options.nofiles and #doc.files > 0 then%>
<h1><a href='<%= luadoc.doclet.html.link("list_of_files.html",from) %>'>Files</a></h1>
<ul class='menulist'>
<%
local temp = luadoc.doclet.html.check(doc.files)

hierarchy_menu(file_doc,temp,"/",nil);%>
</ul>
<%end%>


