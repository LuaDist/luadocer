module("luadocer.taglet.standard.aliases",package.seeall);

---
--info deprecated, use (lua)comments module instead.
-- USER Tag aliases
-- @usage to specify tag aliases, modify the desired key-value pair, like: "author" = {"alias1", "alias2", "alias3"}
local aliases={
	  ["author"] = {"autor"}
	, ["class"] = nil
	, ["copyright"] = nil
	, ["description"] = {"popis"}
	, ["field"] = nil
	, ["name"] = nil
	, ["param"] = {"parameter","premenna"}
	, ["release"] = nil
	, ["return"] = {"vrati","vracia","returns"}
	, ["see"] = nil
	, ["usage"] = nil
	-- MOJEEEEEEEE
	,["uml"] = nil
}

---
-- function to get standard tag from alias or standard tag
-- @param alias current parsed tag
-- @return standard tag, if input passed is already a standard tag or is a defined standard tag's alias
-- @author Viliam Kubis
-- @usage when input is not a standard tag and also not a defined alias, returns nil
function get_tag(alias)
	for k,v in pairs(aliases) do
		if(k==alias) then
			return alias;
		end
		if(type(v)=="table") then
			for _,a in ipairs(v) do
				if(a==alias) then
					return k;
				end
			end
		end
	end
	return alias; --mozno standard tag
end
