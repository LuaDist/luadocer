-----------------------------------------------
-- LuaDoc launcher.
-- @release $Id: luadoc.lua,v 1.1 extended 2010/05/04 by Gabriel Duchon $
-------------------------------------------------------------------------------

require "luadocer.init"
local util=require("luadocer.util")
-------------------------------------------------------------------------------
-- Print version number.

local function print_version ()
	print (string.format("%s\n%s\n%s", 
		luadoc._VERSION, 
		luadoc._DESCRIPTION, 
		luadoc._COPYRIGHT))
end

-------------------------------------------------------------------------------
-- Print usage message.

local function print_help ()
	print ("Usage: "..arg[0]..[[ [options|files]
Generate documentation from files. Available options are:
  -d path                      output directory path
  -t path                      template directory path
  -u path 			generate UML diagrams with PlantUML
  				path to 'plantuml.jar'
  -s print/write 		static analysis of source codes (require luacheck)
  				'print' for output print, 'write' for add analysis to documentation
  -c charset                   source files encoding, defaults to UTF-8
  -p project name              project name, not displayed if left empty
  -h, --help                   print this help and exit
      --noindexpage            do not generate global index page
      --nofiles                do not generate documentation for files
      --nomodules              do not generate documentation for modules
      --doclet doclet_module   doclet module to generate output
      --taglet taglet_module   taglet module to parse input code
  -q, --quiet                  suppress all normal output
  -v, --version                print version information]])
end

local function off_messages (arg, i, options)
	options.verbose = nil
end

-------------------------------------------------------------------------------
-- Process options. TODO: use getopts.
-- @class table
-- @name OPTIONS

local OPTIONS = {
	d = function (arg, i, options)
		local dir = arg[i+1]
		if string.sub (dir, -2) ~= "/" then
			dir = dir..'/'
		end
		options.output_dir = dir
		return 1
	end,
	t = function (arg, i, options)
		local dir = arg[i+1]
		if string.sub (dir, -2) ~= "/" then
			dir = dir..'/'
		end
		options.template_dir = dir
		return 1
	end,
	-- Viliam Kubis, 19.04.2011 - added the charset option, defaults to UTF-8
	c=function(arg,i,options)
		local charset = arg[i+1];
		options.charset=charset;
		return 1;
	end,
	-- Viliam Kubis, 19.04.2011 - added project name
	p=function(arg,i,options)
		local pn = arg[i+1];
		options.project_name=pn;
		return 1;
	end,
	u=function(arg,i,options)
		local path = arg[i+1];
		options.plantuml_path=path;
		return 1;
	end,
	s=function(arg, i, options)
		options.syntax_check=arg[i+1];
		return 1;
	end,
	h = print_help,
	help = print_help,
	q = off_messages,
	quiet = off_messages,
	v = print_version,
	version = print_version,
	doclet = function (arg, i, options)
		options.doclet = arg[i+1]
		return 1
	end,
	taglet = function (arg, i, options)
		options.taglet = arg[i+1]
		return 1
	end,
}

-------------------------------------------------------------------------------

local function process_options (arg)
	local files = {}
	local options = require "luadocer.config"
	local i = 1
	while i < #arg or i == #arg do
		local argi = arg[i]
		if string.sub (argi, 1, 1) ~= '-' then
--KOSA
			table.insert (files, util.getabsolutepath(argi))
		else
			local opt = string.sub (argi, 2)
			if string.sub (opt, 1, 1) == '-' then
				opt = string.gsub (opt, "%-", "")
			end
			if OPTIONS[opt] then
				if OPTIONS[opt] (arg, i, options) then
					i = i + 1
				end
			else
				options[opt] = 1
			end
		end
		i = i+1
	end
	options.files = files
	return files, options
end 

-------------------------------------------------------------------------------
-- Main function. Process command-line parameters and call luadoc processor.

function main (arg)

	-- TODO test
	package.path = "/home/domco/Desktop/Skola/Repository/luametrics/src/?.lua;/home/domco/Desktop/Skola/Repository/luametrics/src//?/init.lua;" .. package.path
	--package.cpath = "/home/domco/Desktop/Skola/Repository/luametrics/src/?.so;/home/domco/Desktop/Skola/Repository/luametrics/src/?.dll;/home/domco/Desktop/Skola/Repository/luametrics/src/?/init.so" .. package.cpath

	-- Process options
	local argc = #arg
	if argc < 1 then
		print_help ()
		return
	end
	local files, options = process_options (arg)
	
	return luadocer.main(files, options)
end

main(arg)
