--| luadocer.io module

module("luadocer.io", package.seeall)

--%	The ReadFile function.
---	Read the whole contents of a file in _sText mode.
--@	_sFileName	(string)	name of the file with path
--:	sData_	(string)	file contents
function ReadFile(_sFileName)
	local f = io.input(_sFileName)
	local sData_ = f:read("*a")
	f:close()
	return sData_
end

--%	The ReadFileLines2Table function.
---	Reads file by lines and returns them in a table.
--@	_sFileName	(string)	name of the file with path
--:	tLines_	(table)		table with lines of the file
function ReadFileLines2Table(_sFileName)
	local tLines_ = {}
	for sLine in io.lines(_sFileName) do
		table.insert(tLines_,sLine)
	end
	return tLines_
end

--%	The ReadFiles function.
---	Reads multiple files and returns their merged content.
--@	_tFiles	(table)		table with the files to read
--:	sText_	(string)	the merged content in one string
function ReadFiles(_tFiles)
	local sText_ = ''
	for _,v in _tFiles do
		sText_ = sText_ .. ReadFile(v) ..'\n'
	end
	return sText_
end

--%	The WriteFile function.
---	Writes _sText to a file.
--@	_sFileName	(string)	name with path to write to
--@	_sText	(string)	the _sText to write
function WriteFile(_sFileName,sText)
	local f = io.output(_sFileName)
	f:write(sText)
	f:flush()
	f:close()
end

--~ function AppendToFile(_sFileName,_sText)
--~ 	local f = io.open(_sFileName,"a")
--~ 	return f:write(_sText)
--~ end

--+ TESTING +--
--[[
x = ReadFile2Table("0.2 io.lua")

for k,v in x do
	print(k,v)
end
--]]
