local function createCustomCommentList(doc, commentType, fileLink)
  
  local commentTable = "<ul>"
  local typeCompare = commentType .. "s"
  local from = "customcommentlist/custom.lp"

  for k,file in pairs(doc.files) do

    if(type(file) == "table") then

      if(file.metricsAST) then

        if(#file.metricsAST.metrics.documentMetrics[typeCompare] > 0) then

          commentTable = commentTable .. "<li><a href='" .. doc.sh(fileLink(file.name,from)) .. "'>." ..
            file.name .. "</a><br><ol>"

          for k,v in pairs(file.metricsAST.metrics.documentMetrics) do

            if(k == typeCompare and #v > 0)then

              for i, comment in ipairs(v) do

                commentTable = commentTable .. "<li><a href='" .. doc.sh(fileLink(file.name,from)) ..
                  "#" .. commentType .. i .. "'>" .. comment.parsed.text .. "</a></li>"

              end
            end
          end

          commentTable = commentTable .. "</ol><br /></li>"

        end
      end
    end
  end

  return commentTable .. "</ul>"

end

local function createUMLDiagrams(diagrams, global, link)
  
  local diagram = ""
  local globVal = nil

  if global then globVal = "global" end

  for _, v in ipairs(diagrams) do

    if (v.name:match("global") == globVal) then

      diagram = diagram .. "<pre style='text-decoration: underline;font-size: 150%;'>"

      if v.name == "global" then
        diagram = diagram .. "Global diagram</pre>"
      else
        diagram = diagram .. "Function " .. v.name .. " diagram</pre>"
      end

      diagram = diagram .. "<a href = '" .. link((v.path:gsub("^/","../")),"diagram/index.html") .. "'>" ..
        "<img src='" .. link((v.path:gsub("^/","../")),"diagram/index.html") .. "'  width=auto> </a><br>"

      diagram = diagram .. "<a href='#' class='toggle_source' " ..
        "onclick='$(this).next().slideToggle(); return false;'><h2>Show / Hide PlantUML syntax</h2>" ..
        "</a><div class='syntax' style='display: none'><pre>" .. v.uml_string .. "</pre></div><br>"

    end
  end

  return diagram

end

return {
  createCustomCommentList = createCustomCommentList,
  createUMLDiagrams = createUMLDiagrams
}