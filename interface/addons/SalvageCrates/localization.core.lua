local addonName, L = ...; -- Let's use the private table passed to every .lua file to store our locale
local function defaultFunc(L, key)
 -- If this function was called, we have no localization for this key.
 -- We could complain loudly to allow localizers to see the error of their ways, 
 -- but, for now, just return the key as its own localization. This allows you to 
 -- avoid writing the default localization out explicitly.
 return key;
end
setmetatable(L, {__index=defaultFunc});

if GetLocale() == "ptBR" then
	L["Salvage Yard"] = "Depósito de Ferro-velho"
end
if GetLocale() == "enUS" then
	L["Salvage Yard"] = "Salvage Yard"
end
if GetLocale() == "frFR" then
	L["Salvage Yard"] = "Centre de tri"
end
if GetLocale() == "deDE" then
	L["Salvage Yard"] = "Wiederverwertung"
end
if GetLocale() == "itIT" then
	L["Salvage Yard"] = "Centro di Riciclaggio"
end
if GetLocale() == "koKR" then
	L["Salvage Yard"] = "재활용 처리장"
end
if GetLocale() == "esMX" then
	L["Salvage Yard"] = "Patio de rescate"
end
if GetLocale() == "ruRU" then
	L["Salvage Yard"] = "Склад утиля"
end
if GetLocale() == "zhCN" then
	L["Salvage Yard"] = "废品站"
end
if GetLocale() == "esES" then
	L["Salvage Yard"] = "Desguace"
end
if GetLocale() == "zhTW" then
	L["Salvage Yard"] = "回收場"
end