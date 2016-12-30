local _G = _G

-- addon name and namespace
local ADDON, NS = ...

-- local functions
local string_format = string.format
local tinsert       = table.insert
local pairs         = pairs
local tostring      = tostring

-- colors
NS.HexColors = {
	Blueish  = "04adcb",
	Brownish = "eda55f",
	GrayOut  = "888888",
	Green    = "00ff00",
	Magenta  = "ff00ff",
	Orange   = "e54100",
	Red      = "ff0000",
	White    = "ffffff",
	Yellow   = "ffff00",
	LightBlue= "9ee3ef",
}

-- utilities
local tablestack = setmetatable({}, {__mode = 'k'})

local cmdLinePattern = "^ *([^%s]+) *"

function NS:GetArgs(str)
   local ret = self:NewTable()
   local pos=0
   
   while true do
     local word
     _, pos, word=string.find(str, cmdLinePattern, pos+1)
	 
     if not word then
       break
     end
	 
     --word = string.lower(word)
     table.insert(ret, word)
   end
   
   return ret
end

function NS:Colorize(color, text)
    if not text then
	    return ""
	end

	if type(text) ~= "string" then
		text = tostring(text)
	end
	
	if NS.HexColors[color] then
		text = text:gsub("(.*)(|r)", "%1%2|cff" .. NS.HexColors[color])
		text = "|cff" .. NS.HexColors[color] .. tostring(text) .. "|r"
	end
	
	return text
end

function NS:ClearTable(tab)
	if type(tab) == "table" then
		for k in pairs(tab) do
			tab[k] = nil
		end
	end
end

function NS:NewTable(...)
	local tab = next(tablestack) or {...}
	
	if tablestack[tab] then
		for i = 1, select("#", ...) do
			tab[i] = select(i, ...)
		end
	end
	
	tablestack[tab] = nil
	
	return tab
end

function NS:ReleaseTable(tab)
	if type(tab) == "table" then
		self:ClearTable(tab)
		tablestack[tab] = true	
	end
end

function NS:FormatTime(stamp)
	stamp = type(stamp) == "number" and stamp or 0
	
	local days    = floor(stamp/86400)
	local hours   = floor((stamp - days * 86400) / 3600)
	local minutes = floor((stamp - days * 86400 - hours * 3600) / 60)
	local seconds = floor((stamp - days * 86400 - hours * 3600 - minutes * 60))

	return string_format("%02d:%02d:%02d", hours, minutes, seconds)
end

function NS:PrecisionTxt(input, digits)
    return string.format("%." .. digits .. "f", input) 
end

-- remove leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
function NS:LeftTrim(s)
	if type(s) ~= "string" then
		return s
	end

	return (s:gsub("^%s*", ""))
end
