-------------------------------------------------------------------------------
-- Doclet that generates HTML output. This doclet generates a set of html files
-- based on a group of templates. The main templates are: 
-- <ul>
-- <li>index.lp: index of modules and files;</li>
-- <li>file.lp: documentation for a lua file;</li>
-- <li>module.lp: documentation for a lua module;</li>
-- <li>function.lp: documentation for a lua function. This is a 
-- sub-template used by the others.</li>
-- </ul>
--
-- @release $Id: html.lua,v 1.29 2007/12/21 17:50:48 tomas Exp $
-------------------------------------------------------------------------------

local print, package, require, assert, getfenv, ipairs, loadstring, pairs, setfenv, tostring, tonumber, type, os, pcall = print, package, require, assert, getfenv, ipairs, loadstring, pairs, setfenv, tostring, tonumber, type, os, pcall
module ("luadocer.doclet.html")

local io = require "io"
local lfs = require "lfs"
local lp = require "luadocer.lp"
local util = require "luadocer.util"
local luadoc = require "luadocer"
local string = require "string"
local table = require "table"


--MODIFICATION \\\
local highlighter = require ('luapretty.highlighter')
local formatter = require ('luapretty.formatter')
local ast_helper = require ('luapretty.ast_helper')
local pkio = require ('luadocer.io')

local metrics = require 'metrics.init'
local luaplantuml = require 'luaplantuml.init'
if (type(metrics) ~= 'table') then metrics = require 'metrics' end

-- MODIFIED BY: Michal Juranyi :: Added 2 modules
local literate = require 'literate'
local comments = require 'comments'

--MODIFIED BY: Martin Nagy :: Metrics module edit. Table templates added.
local template = require 'metrics.templates.init'
local docTemplates = require 'metrics.templates.docMetricsTemplates'
local smellTemplates = require 'metrics.templates.smellTemplates'
local funcTableTemplate = require 'metrics.templates.funcTableTemplates'

--MODIFIED BY: Martin Nagy :: Other templates.
local luadocerTemplates = require 'luadocer.doclet.templates'

--[[
local metrics_loader = loadstring('require("metrics")');
local metrics=pcall(metrics_loader);
if(not metrics) then
	metrics=require("metrics.init");
end
--]]

--- Function that takes path to source file and directory that contains these souce files and find the tree structure from directory, returns number where the tree structure begins or nil when pattern not found
-- @param sample Sample path to source file
-- @param pattern Path to root directory of analysed source files
-- @author Martin Nagy
-- @return start of the tree structure in sample string or nil when pattern not found
local function customStringFind(sample, pattern)
  local i = 1
  
  if(#pattern > #sample) then  --If path to root directory is longer than path to file
    return nil 
  end
  
  for i = 1, #pattern do --Looping trough paths and looking for match
    
    local sampleChar = string.sub(sample, i, i)
    local patternChar = string.sub(pattern, i, i)
    
    if(sampleChar ~= patternChar) then --If paths does not match
      return nil
    end
  end
  
  return (#pattern + 1) --If paths matches returns start of sample which is not included in pattern
  
end

--- Function takes path and returns that part of the path which is not contained in one of the files path
-- @param path Path to source file
-- @author Martin Nagy
-- @return subpart of the path when success, full path when directory substring not found
function cutPathToSources(path)
  
  for _, name in pairs(options.files) do

    local index = name:match('^.*()/') --Checks for last /
    name = string.sub(name, 0, index)

    local res = customStringFind(path, name)
    if(res ~= nil) then --If file is in directory
      
      return ('/' .. string.sub(path, res)) --Returns substring
      
    end
  end
  
  return path --If ndirectory does not contain file returns full path
  
end

--- Function takes template and create hypertext links to make documentation interactive
-- @param template Template to be enhanced
-- @author Martin Nagy
-- @return Template with working hypertext links
local function addLinksToTemplate(template)

	--Find sequence of chars representing link to another file in documentation and substitute for working link
	return string.gsub(template, "#|type=fileLink|to=([^|].-)|from=([^|].-)|#", function(a, b) return file_link(a, b) end)

end
	
--MODIFICATION ///
-------------------------------------------------------------------------------
-- Looks for a file `name' in given path. Removed from compat-5.1
-- @param path String with the path.
-- @param name String with the name to look for.
-- @return String with the complete path of the file found
--	or nil in case the file is not found.

local function search (path, name)

  for c in string.gfind(path, "[^;]+") do
    c = string.gsub(c, "%?", name)
    local f = io.open(c)
    if f then   -- file exist?
      f:close()
      return c
    end
  end
  return nil    -- file not found
end

------------------------------------------------------------------------------
-- Get identifier that is unique to the entire projects (for creating div ids)
-- @author Ivan Simko
local getUniqueId = (function()
	local id = 0
	return function()
		id = id + 1
		return id
	end
end)()

-------------------------------------------------------------------------------
-- Include the result of a lp template into the current stream.

function include (template, env)
	-- template_dir is relative to package.path
	local templatepath = options.template_dir .. template
	templatepath = templatepath:gsub("\/\/","\/")
	-- search using package.path (modified to search .lp instead of .lua
	local search_path = string.gsub(package.path, "%.lua", "")
	local templatepath = search(search_path, templatepath)

	assert(templatepath, string.format("template `%s' not found", template))

	env = env or {}
	env.table = table
	env.io = io
	env.lp = lp
	env.ipairs = ipairs
	env.pairs = pairs
	env.tonumber = tonumber
	env.tostring = tostring
	env.string = string
	env.type = type
	env.luadoc = luadoc
	env.options = options
	env.roundNumber = function(number)
		local index = string.find(number,'%.')
		if (index) then
			return string.sub(number, 1, index + 2)
		else
			return number
		end
	end
	env.getUniqueId = getUniqueId
	return lp.include(templatepath, env)
end

-------------------------------------------------------------------------------
-- Returns a link to a html file, appending "../" to the link to make it right.
-- @param html Name of the html file to link to
-- @return link to the html file

function link (html, from)
	html = html:gsub(lfs.currentdir(), "")
	local h = html
  
	from = from or ""
  
	string.gsub(from, "/", function () h = "../" .. h end)

	return h
end

-------------------------------------------------------------------------------
-- Returns the name of the html file to be generated from a module.
-- Files with "lua" or "luadoc" extensions are replaced by "html" extension.
-- @param modulename Name of the module to be processed, may be a .lua file or
-- a .luadoc file.
-- @return name of the generated html file for the module

function module_link (modulename, doc, from)
	-- TODO: replace "." by "/" to create directories?
	-- TODO: how to deal with module names with "/"?
	assert(modulename)
	assert(doc)
	from = from or ""
	
	if doc.modules[modulename] == nil then
--		logger:error(string.format("unresolved reference to module `%s'", modulename))
		return
	end
	
	local href = "modules/" .. modulename .. ".html"
	string.gsub(from, "/", function () href = "../" .. href end)
	return href
end

-------------------------------------------------------------------------------
-- Returns the name of the html file to be generated from a lua(doc) file.
-- Files with "lua" or "luadoc" extensions are replaced by "html" extension.
-- @param to Name of the file to be processed, may be a .lua file or
-- a .luadoc file.
-- @param from path of where am I, based on this we append ..'s to the
-- beginning of path
-- @return name of the generated html file

function file_link (to, from)
	to = to:gsub(lfs.currentdir(), "")
	assert(to)
	from = from or ""
	
  	to = cutPathToSources(to)
  
	local href = to
	
	href = string.gsub(href, "lua$", "html")
	href = string.gsub(href, "luadoc$", "html")
	href = "files/	" .. href
	string.gsub(from, "/", function () href = "../" .. href end)
	href = href:gsub(lfs.currentdir(), "")

	href = string.gsub(href, "\t", "")

	return href
end

-------------------------------------------------------------------------------
-- Returns a link to a function or to a table
-- @param fname name of the function or table to link to.
-- @param doc documentation table
-- @param kind String specying the kinf of element to link ("functions" or "tables").

function link_to (fname, doc, module_doc, file_doc, from, kind)
	assert(fname)
	assert(doc)
	from = from or ""
	kind = kind or "functions"
	if file_doc then
		for _, func_name in pairs(file_doc[kind]) do
			if func_name == fname then

				return file_link(file_doc.name, from) .. "#" .. fname
			end
		end
	end
	
	local _, _, modulename, fname = string.find(fname, "^(.-)[%.%:]?([^%.%:]*)$")
	assert(fname)

	-- if fname does not specify a module, use the module_doc
	if string.len(modulename) == 0 and module_doc then
		modulename = module_doc.name
	end

	local module_doc = doc.modules[modulename]
	if not module_doc then
--		logger:error(string.format("unresolved reference to function `%s': module `%s' not found", fname, modulename))
		return
	end
	
	for _, func_name in pairs(module_doc[kind]) do

		if func_name == fname then
			return module_link(modulename, doc, from) .. "#" .. fname
		end
	end
	
--	logger:error(string.format("unresolved reference to function `%s' of module `%s'", fname, modulename))
end

-------------------------------------------------------------------------------
-- Make a link to a file, module or function

function symbol_link (symbol, doc, module_doc, file_doc, from)
	assert(symbol)
	assert(doc)
	
	local href = 
--		file_link(symbol, from) or
		module_link(symbol, doc, from) or 
		link_to(symbol, doc, module_doc, file_doc, from, "functions") or
		link_to(symbol, doc, module_doc, file_doc, from, "tables")
	
	if not href then
		logger:error(string.format("unresolved reference to symbol `%s'", symbol))
	end
	
	return href or ""
end

-------------------------------------------------------------------------------
-- Assembly the output filename for an input file.
-- TODO: change the name of this function
function out_file (filename)
	local h = filename
	h = string.gsub(h, "lua$", "html")
	h = string.gsub(h, "luadoc$", "html")
	h = "files" .. h
--	h = options.output_dir .. string.gsub (h, "^.-([%w_]+%.html)$", "%1")
	h = options.output_dir .. h

	return h
end

-------------------------------------------------------------------------------
-- Assembly the output filename for function detail in given file.
-- @param unique_id unique integer for this function *in this file*
-- @param filename current filename being processed
-- @param func_name name of the function for which we are going to create it's detail page
-- @return unique file name for this function
-- @author Viliam Kubis
-- TODO: create a workaround if the target file name already exists, will happen for example if
-- the generated filename is lua_file4function_name.html, but the file lua_file4function_name.lua IS
-- a part of the project and is in the same directory as our file (out_file will generate
-- lua_file4function_name.html --> collision)
-- TODO: examine all possible scenarios for function names containing characters other than A-Za-Z0-9_ (is this even possible?)
function out_function (filename,func_name,unique_id)

	local h = filename:match("[^/\]+$");
	func_name=func_name:gsub("[^A-Za-z0-9_]","");
	h = string.gsub(h, "%.lua$", unique_id..func_name..".html")
	h = string.gsub(h, "%.luadoc$", unique_id..func_name..".html")
	return h
end

------------------------------------------------------------------------------
-- Copy the given file from the templates directory to current output directory. Include is not used anymore because we want to copy the file, not process it as a lua template file and hope there are no directives.
-- @param file filename to copy
-- @author Viliam Kubis
function file_copy(file)
	local  temp = options.template_dir..file
	temp = temp:gsub("\/\/","\/")

	local f = lfs.open(options.template_dir..file, "rb") --binary open is significant in windows systems
	
	local data=f:read("*all");
	f:close();
	f=lfs.open(options.output_dir..file, "wb")
	f:write(data);
	f:close();
end

-------------------------------------------------------------------------------
-- Assembly the output filename for a module.
-- TODO: change the name of this function
function out_module (modulename)
	local h = modulename .. ".html"
	h = "modules/" .. h
	h = options.output_dir .. h
	return h
end

local function print_table(tbl)
	for key,value in pairs(tbl) do
	--	print(key," ",value);
		if(type(value)=="table") then 
			print_table(value);
		end
	end
end

function strsplit(delimiter, text)
  local list = {}
  local pos = 1
  if string.find("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = string.find(text, delimiter, pos)
    if first then -- found?
    if(string.sub(text, pos, first-1) ~='')then
      table.insert(list, string.sub(text, pos, first-1))
     end 
      pos = last+1
    else
      table.insert(list, string.sub(text, pos))
      break
    end
  end
  return list
end

function check(string)
	local filepath_temp = {}
	if string ~= nil then
		for k,v in ipairs(string) do
			filepath_temp[k] = v:gsub(lfs.currentdir(), "")
      
      filepath_temp[k] = cutPathToSources(filepath_temp[k])
      
		end
	end
	return filepath_temp
end

-----------------------------------------------------------------
-- Generate the output.
-- @param doc Table with the structured documentation.

function start (doc)
	-- store global template helper functions in the doc object
	---------------
	-- Convert special charecters into HTML entities, this fixes MANY html-injection bugs on many pages
	-- @author Viliam Kubis
	doc.sh=function (text)

		if text~= nil then
			text = text:gsub(lfs.currentdir(), "")
		end
		if(text==nil) then
			return nil;
		end
		if(type(text)~="string") then
			return text;
		end
		text=text:gsub("&","&amp;");
	  	text=text:gsub("&#","&#38;&#35;");
		text=text:gsub("<","&lt;");
		text=text:gsub(">","&gt;");
		text=text:gsub("\"","&#34;");
		text=text:gsub("'","&#39;");
		return text;
	end;
--KOSA
---
-- Helper for indexOfFunctions/Tables
	doc.pathprefix=function(paths)
		local prefix
		local newpref=''
		for k,v in pairs(paths) do	
			v.path = v.path:gsub(lfs.currentdir(), "")
		--OKA
			if(prefix==nil)then
				
			elseif(prefix~=v.path)then
				local split1 = {}
				local split2 = {}
				for _,split in pairs(strsplit('/',prefix))do
					table.insert(split1,split)
				end
				for _,split in pairs(strsplit('/',v.path))do
					table.insert(split2,split)
				end
				if(#split1 > #split2)then
					for index,str in pairs(split2) do
						if(split1[index]==str)then
							if(newpref=='')then
								newpref = '/' .. str
							else
								newpref = newpref  .. '/' .. str							
							end
							
						else
							break
						end
					end
				else
					for index,str in pairs(split1) do
						if(split2[index]==str)then
							if(newpref=='')then
								newpref = '/' .. str
							else
								newpref = newpref  .. '/' ..  str
							end
						else
							break
						end
					end
				
				end
				prefix = newpref			
				newpref=''
			end
		end

		return prefix
	end;
---
-- Helper for indexOfFunctions/	
	doc.pathsuffix=function(common,full)
		local suffix
		if(full == common or common==nil)then
			return ''
		end
		suffix = string.sub(full,string.len(common)+1)
		return suffix
	end;
-------------------------------------------------------------------	
	-- Generate index file
	if (#doc.files > 0 or #doc.modules > 0) and (not options.noindexpage) then

		-- KARASEK
		if options.plantuml_path ~= nil then 
			doc.diagram = 1 					-- add 'UML diagrams' option to menu 
		end

		if options.syntax_check == "write" then
			doc.check = 1 					-- add 'Static analysis' option to menu 
		end
		
		local filename = options.output_dir.."index.html"
		logger:info(string.format("generating file `%s'", filename))
		local f = lfs.open(filename, "w")
		assert(f, string.format("could not open `%s' for writing", filename))
		io.output(f)
		include("index.lp", { doc = doc, os=os })
		f:close()
	end
	
	-- Generate list of modules (will not be accesible when nomodules=on)
	local filename = options.output_dir.."list_of_modules.html"
	logger:info(string.format("generating file `%s'", filename))
	local f = lfs.open(filename, "w")
	assert(f, string.format("could not open `%s' for writing", filename))
	io.output(f)
	include("list_of_modules.lp", { doc = doc })
	f:close()
	
	-- Generate list of files (will not be accesible when nofiles=on)
	local filename = options.output_dir.."list_of_files.html"
	logger:info(string.format("generating file `%s'", filename))
	local f = lfs.open(filename, "w")
	assert(f, string.format("could not open `%s' for writing", filename))
	io.output(f)
	include("list_of_files.lp", { doc = doc })
	f:close()

	-- generate module hierarchy
	local module_hierarchy={};
	for _, modulename in ipairs(doc.modules) do
		local last=modulename:gsub("%..+$","");
		if(last~=modulename) then --nazov s bodkou
			local key=modulename:match("(.+)%..+$");
			if(not module_hierarchy[key]) then
				module_hierarchy[key]={modulename:match("[^.]+$")};
			else
				table.insert(module_hierarchy[key],modulename:match("[^.]+$"));
			end
		end
	end
	for k,v in pairs(module_hierarchy) do
		local filename = options.output_dir.."module_hierarchy/"..k..".html" -- WARNING: might not be safe! Module name could contain special characters..
		logger:info(string.format("generating file `%s'", filename))
		local f = lfs.open(filename, "w")
		assert(f, string.format("could not open `%s' for writing", filename))
		io.output(f)
		include("module_hierarchy.lp", { doc = doc, modname=k, hierarchy=v })
		f:close()
	end
	module_hierarchy=nil;
	
	-- generate file listing for each subdirectory in the project
	local file_hierarchy={};
	for _, filename in ipairs(doc.files) do
		local last=filename:gsub("/.+$","");

		if(last~=filename) then --nazov v adresari
			local key=filename:match("(.+)/.+$");
			if(not file_hierarchy[key]) then
				file_hierarchy[key]={filename:match("[^/]+$")};
			else
				table.insert(file_hierarchy[key],filename:match("[^/]+$"));
			end
		end
	end
	
	for k,v in pairs(file_hierarchy) do
		k = k:gsub(lfs.currentdir(), "")
    k = cutPathToSources(k)
		local filename = options.output_dir.."files"..k.."/file_listing.lua.lua.lua.html";  -- NOT OK if the directory contains file named file_listing.lua.lua.lua.lua -> becomes file_listing.lua.lua.lua.html -> TODO: generate unique filename somehow or store in a different folder (e.g listings/)

		logger:info(string.format("generating file `%s'", filename))
		local f = lfs.open(filename, "w")
		assert(f, string.format("could not open `%s' for writing", filename))
		io.output(f)
		include("file_listing.lp", { doc = doc, fname=k, hierarchy=v })
		f:close()
	end

	-- KARASEK
	-- static check
	if options.syntax_check == "print" then  		-- if 'print' was on stdin then just print to stdout 
		print("Start syntax analysis...");

		for _, filepath in ipairs(doc.files) do	
			os.execute("luacheck " .. filepath)
		end
	end

	local analysis_results = {}
	if options.syntax_check == "write" then 
		io.stdout:write("Syntax analysis...\r")
		io.stdout:flush()
		
		for _, filepath in ipairs(doc.files) do

			local temp_file = filepath:gsub('.%w*$', '') .. "_checking" 			-- we need make temporary file of luacheck report
			os.execute("luacheck --no-color " .. filepath .. " > " .. temp_file) 	-- execute analysis
			
			local result = pkio.ReadFile(temp_file) 	-- add analysis to table
			analysis_results[#analysis_results+1] = {}
			
			if (string.match(result, "Failure")) then 						-- if we find "Failure" in result text it has warnings or errors
				analysis_results[#analysis_results].name = filepath:gsub(lfs.currentdir(), "")
				analysis_results[#analysis_results].status = 'Failure'
				
				local temp_result = result:gsub('^Checking(.+)Failure(.+)Total:(.+)', '%2')
				temp_result = temp_result:gsub(filepath .. ":", "")

				analysis_results[#analysis_results].result = temp_result:gsub("%s%s+",'\n')
				analysis_results[#analysis_results].info = result:gsub('^.+Total:', 'Total:')
			else -- if not then it's OK
				analysis_results[#analysis_results].name = filepath:gsub(lfs.currentdir(), "")
			end
			os.remove(temp_file) 													-- remove that temporary file
		end

		-- DEBUG PRINT
		-- for k,v in ipairs(analysis_results) do
		-- 	print(analysis_results[k])
		-- end
			
		io.stdout:write("Start syntax analysis...\tOK\n")
		io.stdout:flush()
	end

	-- generate diagrams
	local diagram_results = {}
	local settings = {}	

	if options.plantuml_path ~= nil then 
		io.stdout:write("Generating diagrams... \r")
		io.stdout:flush()

		for _, filepath in ipairs(doc.files) do	
			
			local text = pkio.ReadFile(filepath)
			settings.plantuml_path = options.plantuml_path .. " %s"
			settings.dir_path = util.getabsolutepath(options.output_dir) .. '/'
			settings.current_file = filepath
      
      settings.extended_path = cutPathToSources(filepath)
      
			-- parse extended_path
			settings.extended_path = settings.extended_path:gsub("^(.+)/.-$","%1/")
			settings.extended_path = settings.extended_path:gsub("^\/","")
			
			settings.file_format = "svg"
			diagram_results = luaplantuml.process_text(text, settings)
		end
		-- DEBUG PRINT
		-- for _, v in ipairs(diagram_results) do
		-- 	print(v.name .. ' CESTA: ' .. v.path .. '  STRING: ' .. v.uml_string)
		-- end
		io.stdout:write("Generating diagrams...\t\tOK\n")
		io.stdout:flush()
	end

	--MODIFICATION \\\ (Ivan Simko) pridane globalne metriky ... a metriky ulozene do kazdej file_doc tabulky
	io.stdout:write("Generating metrics...\r")
	io.stdout:flush()

	--MODIFIED BY: Martin Nagy - edited global metrics generation (through metrics.templates)
	local fileList = {} --Created file list to generate metrics

	for _, filepath in ipairs(doc.files) do
		table.insert(fileList, filepath)
	end

	--Generate metrics to globalMetrics
	local globalMetrics = template.createASTAndMerge(fileList, options.files)

	--Loop to extend AST with literate module
	for _, filepath in ipairs(doc.files) do
	    
	    local text = pkio.ReadFile(filepath)
	    local formatted_text = formatter.format_text(text);

	    -- potrebne nahradit windows newlines za unix newlines, inak dvojite nove riadky!! [LEG zoberie ako SPACE separatne \r aj \n, moderne browsery ciste \r interpretuju ako newline -> dvojite nove riadky]
	    formatted_text = formatted_text:gsub("\r\n","\n");
	    
	    local AST = globalMetrics.file_AST_list[cutPathToSources(filepath)] --Using generated AST instead of creating new one
      
	    local file_doc = doc.files[filepath]
	    file_doc.metricsAST = AST
	    file_doc.formatted_text = formatted_text;

	    comments.extendAST(AST) --MODIFIED BY: Michal Juranyi
	end
   
        --MODIFIED BY: Michal Juranyi
	--_ listOfFunctions is globalMetrics.functionDefinitions table converted to associative array
	local listOfFunctions = {}

	for _,fun in ipairs(globalMetrics.functionDefinitions) do
		fun.docstring = comments.findDocstring(fun)
		listOfFunctions[fun.name] = fun
	end

	literate.functions = listOfFunctions
        --END OF MODIFICATION BY MJ

	-- Process modules
	if not options.nomodules then
		for _, modulename in ipairs(doc.modules) do
			local module_doc = doc.modules[modulename]

			-- assembly the filename
			local filename = out_module(modulename)
			logger:info(string.format("generating file `%s'", filename))
			
			local f = lfs.open(filename, "w")
			assert(f, string.format("could not open `%s' for writing", filename))
			io.output(f)
			include("module.lp", { doc = doc, module_doc = module_doc, globalMetrics= globalMetrics} )
			f:close()
		end
		io.stdout:write("Generating metrics...\t\tOK\n")
		io.stdout:flush()
	end
	
	-- MODIF (Ivan Simko) - odstranene ! -> tableofFunctions a tableOfMetrics
	
	-- Process files
	if not options.nofiles then
		for _, filepath in ipairs(doc.files) do
			doc.files[filepath].name = doc.files[filepath].name:gsub(lfs.currentdir(), "")
			local file_doc = doc.files[filepath]
			file_doc.file_name=file_doc.name:match("[^/]+$");
			file_doc.name = file_doc.name:gsub(lfs.currentdir(), "")
      file_doc.name = cutPathToSources(file_doc.name)
			--MODIFICATION \\\ (Ivan Simko) -> variables formatted_text and metricsAST are taken from file_doc
			local highlighter_pt=nil;
			if(file_doc.formatted_text) then
				-- convert the metrics parse tree to highlighter-compatible parse tree and pass the result as the parse tree to use during the highlighting process
				file_doc.prettyprint, highlighter_pt = highlighter.highlight_text(file_doc.formatted_text,ast_helper.metrics_to_highlighter(file_doc.metricsAST)) -- set prettyprinted text of file_doc (the whole file)
				-- highlighter_pt now contains modified compatible parse-tree
				
				-- VYTVORIT PRETTYPRINT PRE KAZDU FUNKCIU SEPARATNE!
				-- crazy tabulka.. numericke kluce maju textove hodnoty, ktore su textove kluce do tej istej tabulky.. v ktorych je samotna dokumentacia funkcie
				-- tiez vytvorit separatnu dokumentacnu stranku pre kazdu funkciu!
				for pos, func_name in ipairs(file_doc.functions) do
					local functionNode = ast_helper.metrics_to_highlighter(file_doc.metricsAST.luaDoc_functions[func_name]) or {}
					--file_doc['functions'][func_name]['prettyprint']=highlighter.assemble_table(ast_helper.getfunctionnode(highlighter_pt,func_name) or {});
					file_doc['functions'][func_name]['prettyprint']=highlighter.assemble_table(functionNode);
					-- vygenerujeme unikatny nazov suboru pre tuto funkciu

					local filename = out_function(file_doc.name,func_name,pos);
					file_doc['functions'][func_name]['detail_link']=filename;

					-- KARASEK
					if options.plantuml_path ~= nil then 
						for _, v in ipairs(diagram_results) do

							if v.name == "global" then 		-- add global UML path
								file_doc.uml = v.path
							end
							if v.name == func_name then 	-- add function UML path
								file_doc['functions'][func_name]['uml']=v.path;
							end
						end
					end

					logger:info(string.format("generating function detail: file `%s'", filename))
      
					local f = lfs.open(options.output_dir:gsub("/+","/").."files"..file_doc.name:gsub("[^\/]+$","")..filename, "w")
					
					assert(f, string.format("could not open `%s' for writing", filename))
					io.output(f)

					include("function_detail.lp", { doc = doc, file_doc = file_doc, func=file_doc['functions'][func_name], metricsAST = file_doc.metricsAST, globalMetrics = globalMetrics} )
					f:close()
				end
			end

                        --MODIFIED BY:  Michal Juranyi
			literate.filename = file_doc.name
                        file_doc.literate = literate.literate(file_doc.metricsAST)
                        --END OF MODIFICATION BY MJ
			
			for _, funcinfo in pairs({}) do -- not working!! functionlister.getTableOfFunctions(text,true)) do		-- appendinf function informations to the tableOfFunctions
				funcinfo.path = filepath:gsub(lfs.currentdir(), "")													-- set path

				metricinfo.NOF = metricinfo.NOF + 1											-- set metrics about functions
				if funcinfo.fcntype == "global" then metricinfo.NOGF = metricinfo.NOGF + 1 end
				if funcinfo.fcntype == "local"  then metricinfo.NOLF = metricinfo.NOLF + 1 end
			end
			--print("processing: "..filepath) --TODO DELETE STATIC LOG PRINT
			--MODIFICATION ///
      
      local fname = cutPathToSources(file_doc.name)
			
			-- assembly the filename
			local filename = out_file(fname:gsub(lfs.currentdir(), ""))

			logger:info(string.format("generating file `%s'", filename))
      
			local f = lfs.open(filename, "w")
			assert(f, string.format("could not open `%s' for writing", filename))
			io.output(f)
			-- call the file template)
			include("file.lp", {doc = doc, file_doc = file_doc, globalMetrics = globalMetrics} )
			f:close()
		end
	end
	
	-- /// MODIFICATION \\\
	-- FUNCTIONS
	-- MODIF (Ivan Simko) - removed ! ->   table.sort(tableOfFunctions,functionlister.comparator)
	local functions = { name = "index.html" }
	local f = lfs.open(options.output_dir.."functionlist/index.html", "w")
	assert(f, string.format("could not open functionlist/index.html for writing"))
	io.output(f)

	--Create parameter list to make documentation (parameters represents templates)
	local functionsParam = {
		doc = doc,
		functionList = funcTableTemplate.createFunctionTableList(globalMetrics, "functionDefinitions", false),
		docFunctionList = funcTableTemplate.createDocumentedFunctionTableList(globalMetrics, "functionDefinitions", 1, false),
		nDocFunctionList = funcTableTemplate.createDocumentedFunctionTableList(globalMetrics, "functionDefinitions", 0, false)
	}

	--Adding links to templates to make documentation interactive
	functionsParam.functionList = addLinksToTemplate(functionsParam.functionList)
	functionsParam.docFunctionList = addLinksToTemplate(functionsParam.docFunctionList)
	functionsParam.nDocFunctionList = addLinksToTemplate(functionsParam.nDocFunctionList)

	include("indexOfFunctions.lp", functionsParam) -- -- MODIF (Ivan Simko) - added globalMetrics
	f:close()
	
	-- METRICS
	local metrics = { name = "index.html" }
	local f = lfs.open(options.output_dir.."metrics/index.html", "w")
	assert(f, string.format("could not open metrics/index.html for writing"))
	io.output(f)

	--Create parameter list to make documentation (parameters represents templates)
	local metricsParam = {
		doc = doc,
		LOCTable = docTemplates.createLOCTable(globalMetrics.LOC, globalMetrics.fileNum, globalMetrics.moduleNum),
		docMetricsTable = docTemplates.createDocMetricsTable(globalMetrics.documentMetrics),
		halsteadTable = docTemplates.createHalsteadTable(globalMetrics.halstead),
		statementsTable = docTemplates.createStatementsTable(globalMetrics.statements),
		functionsTable = docTemplates.createFunctionsTable(globalMetrics, globalMetrics.fileNum),
		moduleLenGraph = docTemplates.createModuleLenGraph(globalMetrics, false),
		fileLenGraph = docTemplates.createFileLenGraph(globalMetrics, false),
		couplingTable = docTemplates.createCouplingTable(globalMetrics)
	}

	include("indexOfMetrics.lp", metricsParam ) -- MODIF (Ivan Simko) - added globalMetrics
	f:close()
	-- \\\ MODIFICATION ///
  
  -- SMELLS - Martin Nagy  
	local f = lfs.open(options.output_dir.."smells/index.html", "w")
	assert(f, string.format("could not open smells/index.html for writing"))
	io.output(f)

	--Create parameter list to make documentation (parameters represents templates)
	local smellsParam = {
		doc = doc,
		longMethodTable = smellTemplates.createLongMethodTable(globalMetrics),
		cycloTable = smellTemplates.createCycloTable(globalMetrics),
		manyParamsTable = smellTemplates.createManyParamsTable(globalMetrics),
		moduleTables = smellTemplates.createModuleTables(globalMetrics),
		MITable = smellTemplates.createMITable(globalMetrics),
		longLinesTable = smellTemplates.createLongLinesTable(globalMetrics),
		tablesWithManyFieldsTable = smellTemplates.createTablesWithManyFieldsTable(globalMetrics),
		functionDepthTable = smellTemplates.createFunctionDepthTable(globalMetrics),
		tableDepthTable = smellTemplates.createTableDepthTable(globalMetrics),
		upvaluesTable = smellTemplates.createUpvaluesTable(globalMetrics),

		longMethodGraph = smellTemplates.createLongMethodGraph(globalMetrics, false),
		cycloGraph = smellTemplates.createCycloGraph(globalMetrics, false),
		manyParamsGraph = smellTemplates.createManyParamsGraph(globalMetrics, false),
		longLinesGraph = smellTemplates.createLongLinesGraph(globalMetrics, false),
		tablesWithManyFieldsGraph = smellTemplates.createTablesWithManyFieldsGraph(globalMetrics, false),
		functionDepthGraph = smellTemplates.createFunctionDepthGraph(globalMetrics, false),
		tableDepthGraph = smellTemplates.createTableDepthGraph(globalMetrics, false),
		upvaluesGraph = smellTemplates.createUpvaluesGraph(globalMetrics, false),
	}

	include("indexOfSmells.lp", smellsParam ) 
	f:close()
  -- END OF SMELLS


	-- /// MODIFICATION \\\
	-- TABLES
	local tables = { name = "index.html" }
	local f = lfs.open(options.output_dir.."tablelist/index.html", "w")
	assert(f, string.format("could not open tablelist/index.html for writing"))
	io.output(f)

	--Create parameter list to make documentation (parameters represents templates)
	local tableParam = {
		doc = doc,
		tableList = funcTableTemplate.createFunctionTableList(globalMetrics, "tables", false),
		docTableList = funcTableTemplate.createDocumentedFunctionTableList(globalMetrics, "tables", 1, false),
		nDocTableList = funcTableTemplate.createDocumentedFunctionTableList(globalMetrics, "tables", 0, false)
	} 

	tableParam.tableList = addLinksToTemplate(tableParam.tableList)
	tableParam.docTableList = addLinksToTemplate(tableParam.docTableList)
	tableParam.nDocTableList = addLinksToTemplate(tableParam.nDocTableList)

	include("indexOfTables.lp", tableParam)
	f:close()
	-- \\\ MODIFICATION ///

--KOSA
	-- custom comments
	local tables = { name = "customs.html" }
	local f = lfs.open(options.output_dir.."customcommentlist/customs.html", "w")
	assert(f, string.format("could not open customcommentlist/customs.html for writing"))
	io.output(f)

	--Create parameter list to make documentation (parameters represents templates)
	local customParam = {
		doc = doc,
		todoComments = luadocerTemplates.createCustomCommentList(doc, "todo", file_link),
		bugComments = luadocerTemplates.createCustomCommentList(doc, "bug", file_link),
		questionComments = luadocerTemplates.createCustomCommentList(doc, "question", file_link),
		fixmeComments = luadocerTemplates.createCustomCommentList(doc, "fixme", file_link),
		infoComments = luadocerTemplates.createCustomCommentList(doc, "info", file_link),
		howComments = luadocerTemplates.createCustomCommentList(doc, "how", file_link)
	}

	include("custom.lp", customParam)
	f:close()
	-- \\\ MODIFICATION ///

--KARASEK
	--CHECK
	local checks = { name = "index.html" }
	local f = lfs.open(options.output_dir.."check/index.html", "w")
	assert(f, string.format("could not open diagram/index.html for writing"))
	io.output(f)
	include("indexOfChecks.lp", { doc = doc, checks = analysis_results} ) -- -- MODIF (Ivan Simko) - added globalMetrics
	f:close()

	--DIAGRAMS
	local diagrams = { name = "index.html" }
	local f = lfs.open(options.output_dir.."diagram/index.html", "w")
	assert(f, string.format("could not open diagram/index.html for writing"))
	io.output(f)

	--Create parameter list to make documentation (parameters represents templates)
	local diagramParam = {
		doc = doc,
		globalDiagram = luadocerTemplates.createUMLDiagrams(diagram_results, true, link),
		functionDiagram = luadocerTemplates.createUMLDiagrams(diagram_results, false, link)
	}

	include("indexOfDiagrams.lp", diagramParam ) -- -- MODIF (Ivan Simko) - added globalMetrics
	f:close()


	-- copy extra files
	file_copy("literate.js") --MODIFIED BY: Michal Juranyi
	file_copy("luadoc.css");
	file_copy("jquery.js");
	file_copy("prettyprint.js");
	file_copy("menu.js");
	file_copy("highcharts.js")
	file_copy("jquery-ui.min.js")
	file_copy("indexOfFunctions.css")
	file_copy("jquery-ui-1.8.11.custom.css")	
	file_copy("fileIcon.jpg")	
end
