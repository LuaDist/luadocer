-------------------------------------------------------------------------------
-- LuaDoc main function.
-- @release $Id: init.lua,v 1.4 2008/02/17 06:42:51 jasonsantos Exp $
-------------------------------------------------------------------------------

local require = require

local util = require "luadocer.util"

logger = {}

module ("luadocer")

-------------------------------------------------------------------------------
-- LuaDoc version number.

_COPYRIGHT = "Copyright (c) 2003-2007 The Kepler Project"
_DESCRIPTION = "Documentation Generator Tool for the Lua language, forked from LuaDoc"
_VERSION = "LuaDocer 1.0"

-------------------------------------------------------------------------------
-- Main function
-- @see luadoc.doclet.html, luadoc.doclet.formatter, luadoc.doclet.raw
-- @see luadoc.taglet.standard

function main (files, options)
	logger = util.loadlogengine(options)

	-- load config file
	if options.config ~= nil then
		-- load specified config file
		dofile(options.config)
	else
		-- load default config file
		require("luadocer.config")
	end
	
	local taglet = require(options.taglet)
	local doclet = require(options.doclet)

	-- analyze input
	taglet.options = options
	taglet.logger = logger
	local doc = taglet.start(files)

	-- generate output
	doclet.options = options
	doclet.logger = logger
	-- Viliam Kubis 19.04.2011 - added the charset option
	if(not options.charset) then
		options.charset="UTF-8";
	end
	doc.charset=options.charset;
	-- Viliam Kubis 19.04.2011 - added the project name option
	doc.project_name=options.project_name;
	
	doclet.start(doc)
end
