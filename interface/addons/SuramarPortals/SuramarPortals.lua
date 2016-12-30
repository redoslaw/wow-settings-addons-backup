-- Disclaimer!
-- Don't judge me for my poor coding! I just needed something to help me out with my lack of memory (WHERE IS THE RIGHT PORTAL?!)
-- Thanks to Branduril, Daidari (Zirkel des Cenarius - Verdammte Horde) and DimasDSF for the localization and testing! I like them very much!

local L = {}
if GetLocale() == "enUS" or GetLocale == "enGB" then
	L["Portal to Felsoul Hold"] = "Portal to Felsoul Hold";
	L["Portal to Falanaar"] = "Portal to Falanaar";
	L["Portal to Moon Guard Stronghold"] = "Portal to Moon Guard Stronghold";
	L["Portal to Lunastre Estate"] = "Portal to Lunastre Estate";
	L["Portal to Ruins of Elune'eth"] = "Portal to Ruins of Elune'eth";
	L["Portal to Evermoon Terrace"] = "Portal to Evermoon Terrace";
	L["Portal to Sanctum of Order"] = "Portal to Sanctum of Order";
	L["Portal to Tel'anor"] = "Portal to Tel'anor";
	L["Portal to Twilight Vineyards"] = "Portal to Twilight Vineyards";
	L["Portal to Astravar Harbor"] = "Portal to Astravar Harbor";
elseif GetLocale() == "deDE" then
	L["Portal to Felsoul Hold"] = "Portal zur Teufelsseelenbastion";
	L["Portal to Falanaar"] = "Portal nach Falanaar";
	L["Portal to Moon Guard Stronghold"] = "Portal zur Mondwachenfestung";
	L["Portal to Lunastre Estate"] = "Portal zum Anwesen der Lunastres";
	L["Portal to Ruins of Elune'eth"] = "Portal zu den Ruinen von Elune'eth";
	L["Portal to Evermoon Terrace"] = "Portal zur Immermondterrasse";
	L["Portal to Sanctum of Order"] = "Portal zum Sanktum der Ordnung";
	L["Portal to Tel'anor"] = "Portal nach Tel'anor";
	L["Portal to Twilight Vineyards"] = "Portal zu den Zwielichtrebg\195\164rten";
	L["Portal to Astravar Harbor"] = "Portal zum Hafen der Astravar";
elseif GetLocale() == "frFR" then
	L["Portal to Felsoul Hold"] = "Portail vers le bastion Gangrâme";
	L["Portal to Falanaar"] = "Portail vers Falanaar";
	L["Portal to Moon Guard Stronghold"] = "Portail vers le bastion de la garde de la Lune";
	L["Portal to Lunastre Estate"] = "Portail vers le domaine Lunastre";
	L["Portal to Ruins of Elune'eth"] = "Portail vers les ruines d’\195\137lune’eth";
	L["Portal to Evermoon Terrace"] = "Portail vers la terrasse de Sempiterlune";
	L["Portal to Sanctum of Order"] = "Portail vers le sanctum de l’Ordre";
	L["Portal to Tel'anor"] = "Portail vers Tel’anor";
	L["Portal to Twilight Vineyards"] = "Portail vers les vignobles du Crépuscule";
	L["Portal to Astravar Harbor"] = "Portail vers le port d'Astravar";
elseif GetLocale() == "esES" then
	L["Portal to Felsoul Hold"] = "Portal al Bastión Alma Vil";
	L["Portal to Falanaar"] = "Portal a Falanaar";
	L["Portal to Moon Guard Stronghold"] = "Portal al Bastión de la Guardia Lunar";
	L["Portal to Lunastre Estate"] = "Portal a Finca de Lunastre";
	L["Portal to Ruins of Elune'eth"] = "Portal a las Ruinas de Elune'eth";
	L["Portal to Evermoon Terrace"] = "Portal a la Terraza Lunaeterna";
	L["Portal to Sanctum of Order"] = "Portal al Santuario del Orden";
	L["Portal to Tel'anor"] = "Portal a Tel'anor";
	L["Portal to Twilight Vineyards"] = "Portal a Viñedos Crepusculares";
	L["Portal to Astravar Harbor"] = "Portal al Puerto de los Astravar";
elseif GetLocale() == "ruRU" then
	L["Portal to Felsoul Hold"] = "Портал в оплот Оскверненной Души";
	L["Portal to Falanaar"] = "Портал в Фаланаар";
	L["Portal to Moon Guard Stronghold"] = "Портал в цитадель Лунных стражей";
	L["Portal to Lunastre Estate"] = "Портал в поместье Лунархов";
	L["Portal to Ruins of Elune'eth"] = "Портал в руины Элун'ета";
		L["Portal to Evermoon Terrace"] = 'Портал к "Лунному полумраку"';
	L["Portal to Sanctum of Order"] = "Портал в Святилище Порядка";
	L["Portal to Tel'anor"] = "Портал в Тел'анор";
	L["Portal to Twilight Vineyards"] = "Портал в Сумеречные виноградники";
		L["Portal to Astravar Harbor"] = "Portal to Astravar Harbor";
elseif GetLocale() == "itIT" then
	L["Portal to Felsoul Hold"] = "Portale per il Forte Vilanima";
	L["Portal to Falanaar"] = "Portale per Falanaar";
	L["Portal to Moon Guard Stronghold"] = "Portale per il Forte delle Guardie della Luna";
	L["Portal to Lunastre Estate"] = "Portale per la Tenuta dei Lunastra";
	L["Portal to Ruins of Elune'eth"] = "Portale per le Rovine di Elune'eth";
	L["Portal to Evermoon Terrace"] = "Portale per la Terrazza di Lunavespro";
	L["Portal to Sanctum of Order"] = "Portale per il Santuario dell'Ordine";
	L["Portal to Tel'anor"] = "Portale per Tel'anor";
	L["Portal to Twilight Vineyards"] = "Portale per le Vigne del Crepuscolo";
	L["Portal to Astravar Harbor"] = "Portale per il Porto di Astravar";
end


local xPos = 0
local yPos = 0
local inConfig = false


-- UI Elements
-- SRPHeader
local SRPHeader = CreateFrame("Frame","SRPHeader",UIParent)
SRPHeader:SetFrameStrata("BACKGROUND")
SRPHeader:SetWidth(400)
SRPHeader:SetHeight(400)

SRPHeader.texture = SRPHeader:CreateTexture()
SRPHeader.texture:SetAllPoints(SRPHeader)
SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_allportals")

SRPHeader:SetMovable(true)
SRPHeader:EnableMouse(true)
SRPHeader:RegisterForDrag("LeftButton")
SRPHeader:SetScript("OnDragStart", function()
	SRPHeader:StartMoving()
end)
SRPHeader:SetScript("OnDragStop", function()
	SRPHeader:StopMovingOrSizing()
end)
SRPHeader:SetScript("OnHide", function()
	--SRPHeaderToggled=0
end)
SRPHeader:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and yuloadsomuch == false then
		if SP == nil then
			SP = {
				["xPos"] = 0,
				["yPos"] = - 50,
				["scale"] = 1
				}
		end
		SRPHeader:SetPoint("CENTER", UIParent, xPos, yPos)
		yuloadsomuch = true -- why the F* does this fire more than once?!
	end
end)
SRPHeader:SetPoint("CENTER",0,0)
SRPHeader:Hide()

local SRPHeaderText = SRPHeader:CreateFontString(nil, "OVERLAY", "GameFontNormal")
SRPHeaderText:SetPoint("CENTER", SRPHeader, "TOP", 110, -10)
SRPHeaderText:SetText("SuramarPortals")
SRPHeaderText:Hide()

local closeButton = CreateFrame("Button", "closeButton", SRPHeader, "UIPanelButtonTemplate")
closeButton:SetSize(25,25)
closeButton:SetText("X")
closeButton:SetPoint("TOPRIGHT",0,0)
closeButton:SetScript("OnClick", function()
	SRPHeader:Hide()
	inConfig = false
end)
closeButton:Hide()


local yuloadsomuch = false
SRPHeader:RegisterEvent("ADDON_LOADED")
SRPHeader:RegisterEvent("PLAYER_LOGOUT")
SRPHeader:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
SRPHeader:RegisterEvent("ITEM_TEXT_BEGIN")
SRPHeader:RegisterEvent("ITEM_TEXT_CLOSED")
SRPHeader:RegisterEvent("ITEM_TEXT_READY")
SRPHeader:RegisterEvent("CURSOR_UPDATE")


local function onUpdate(self, elapsed)
	portalName = GameTooltipTextLeft1:GetText()
	if portalName == L["Portal to Lunastre Estate"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_lunastreestate")
		end
	elseif portalName == L["Portal to Felsoul Hold"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_felsoulhold")
		end
			elseif portalName == L["Portal to Falanaar"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_falanaar")
		end
			elseif portalName == L["Portal to Moon Guard Stronghold"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_moonguardstronghold")
		end
			elseif portalName == L["Portal to Ruins of Elune'eth"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_ruinsofeluneeth")
		end
			elseif portalName == L["Portal to Evermoon Terrace"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_evermoonterrace")
		end
			elseif portalName == L["Portal to Sanctum of Order"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_sanctumoforder")
		end
			elseif portalName == L["Portal to Tel'anor"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_telanor")
		end
			elseif portalName == L["Portal to Twilight Vineyards"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_twilightvineyard")
		end
		
		elseif portalName == L["Portal to Astravar Harbor"] then
		if inConfig == false then
		SRPHeader:EnableMouse(false)
		SRPHeader:Show()
		SRPHeaderText:Hide()
		closeButton:Hide()
		SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_astravarharbor")
		end
	else
		if inConfig == false then
		SRPHeader:EnableMouse(true)
		SRPHeader:Hide()
		end
	end
end

local f = CreateFrame("frame")
f:SetScript("OnUpdate", onUpdate)

-- /UI Elements

-- slash command
SLASH_SuramarPortals1, SLASH_SuramarPortals2, SLASH_SuramarPortals3 = '/SuramarPortals', '/suramar', '/srp';
local function handler(msg, editbox)
	if msg == "config" then
		--config:Show()
	else
		if SRPHeader:IsShown() then
			SRPHeader:Hide()
			SRPHeaderText:Hide()
			closeButton:Hide()
			inConfig = false
		else
			SRPHeader:EnableMouse(true)
			SRPHeader.texture:SetTexture("Interface\\AddOns\\SuramarPortals\\gfx\\map_cut_allportals")
			SRPHeader:Show()
			SRPHeaderText:Show()
			closeButton:Show()
			inConfig = true
		end
	end
end
SlashCmdList["SuramarPortals"] = handler;
-- /slash command