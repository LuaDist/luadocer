--- Function creates part of table with custom comments usage (eg. TO-DO, BUG, Question etc.) !USE ONLY WITH LUADOCER NOT FINISHED
-- @param doc Variable containing file information
-- @param commentType Comment type to add
-- @param fileLink Function creating hypertext links to documentation
-- @author Martin Nagy
-- @return subpart of the path when success, full path when directory substring not found
local function createCustomCommentList(doc, commentType, fileLink)
  
  local commentTable = "<ul>"
  local typeCompare = commentType .. "s"
  local from = "customcommentlist/custom.lp" --File from where links will be created

  for k,file in pairs(doc.files) do 

	if(type(file) == "table") then --Looping through file tables

	  if(file.metricsAST) then --For file AST list

		if(#file.metricsAST.metrics.documentMetrics[typeCompare] > 0) then --If custom comments exists in file

		  --Add link to file where comments appear
		  commentTable = commentTable .. "<li><a href='" .. doc.sh(fileLink(file.name,from)) .. "'>." ..
			file.name .. "</a><br><ol>"

		  for k,v in pairs(file.metricsAST.metrics.documentMetrics) do

			if(k == typeCompare and #v > 0)then

			  for i, comment in ipairs(v) do

				--Add all custom comments entries of type
				commentTable = commentTable .. "<li><a href='" .. doc.sh(fileLink(file.name,from)) ..
				  "#" .. commentType .. i .. "'>" .. comment.parsed.text .. "</a></li>"

			  end
			end
		  end

		  --Close table entry
		  commentTable = commentTable .. "</ol><br /></li>"

		end
	  end
	end
  end

  return commentTable .. "</ul>"

end

--- Function creates UML diagrams with links to pictures !USE ONLY WITH LUADOCER NOT FINISHED
-- @param diagrams Variable containing information about diagrams
-- @param global If UML diagram type is global
-- @param link Function creating hypertext links to documentation
-- @author Martin Nagy
-- @return UML diagrams with links to pictures
local function createUMLDiagrams(diagrams, global, link)
  
  local diagram = ""
  local globVal = nil --Default is not global

  if global then globVal = "global" end --If global is set overwrite value

  for _, v in ipairs(diagrams) do --For each entry in diagram list

	if (v.name:match("global") == globVal) then --If diagram is global or local (based to parameter)

		--Diagram CSS styles
		diagram = diagram .. "<pre style='text-decoration: underline;font-size: 150%;'>"

		--Add diagram title
		if v.name == "global" then
			diagram = diagram .. "Global diagram</pre>"
		else
			diagram = diagram .. "Function " .. v.name .. " diagram</pre>"
		end

		--Add diagram with link to picture
		diagram = diagram .. "<a href = '" .. link((v.path:gsub("^/","../")),"diagram/index.html") .. "'>" ..
			"<img src='" .. link((v.path:gsub("^/","../")),"diagram/index.html") .. "'  width=auto> </a><br>"

		--Add posibility to show PlantUML syntax
		diagram = diagram .. "<a href='#' class='toggle_source' " ..
			"onclick='$(this).next().slideToggle(); return false;'><h2>Show / Hide PlantUML syntax</h2>" ..
			"</a><div class='syntax' style='display: none'><pre>" .. v.uml_string .. "</pre></div><br>"

	end
  end

  --Return all local / global diagrams
  return diagram

end

return {
  createCustomCommentList = createCustomCommentList,
  createUMLDiagrams = createUMLDiagrams
}