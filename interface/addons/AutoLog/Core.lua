AutoLog = select(2, ...)
local _G = _G
local AutoLog = AutoLog
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale("AutoLog")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
LibStub("AceTimer-3.0"):Embed(AutoLog)
local GetMapNameByID, GetCurrentMapAreaID = GetMapNameByID, GetCurrentMapAreaID
local LoggingCombat = LoggingCombat
local pairs, string, select, print, format = pairs, string, select, print, format
local GetBindingKey, SetBinding, IsInInstance = GetBindingKey, SetBinding, IsInInstance
local GetRaidDifficultyID, IsInRaid, IsPartyLFG = GetRaidDifficultyID, IsInRaid, IsPartyLFG
local IsInLFGDungeon, GetDungeonDifficultyID = IsInLFGDungeon, GetDungeonDifficultyID
local UIFrameFade = UIFrameFade
local alm

--map IDs
local map_id_list = {
	["42BWD"] = 754, ["45BTW"] = 758, ["46TFW"] = 773, ["41BAH"] = 752, ["44FIR"] = 800, ["43DGS"] = 824, ["52MGS"] = 896, 
	["53TES"] = 886, ["51HOF"] = 897, ["54TOT"] = 930, ["55SOO"] = 953, ["61BRF"] = 988, ["62HGM"] = 994, ["63HFC"] = 1026,
	["71TEN"] = 1094, ["72TNH"] = 1088, ["73TOV"] = 1114
}

local raid_normal = {"42BWD", "45BTW", "46TFW", "41BAH", "44FIR", "43DGS", "52MGS", "53TES", "51HOF", "54TOT", "55SOO", "61BRF", "62HGM", "63HFC", "71TEN", "72TNH", "73TOV"}
local raid_heroic = {"42BWD", "45BTW", "46TFW", "44FIR", "43DGS", "52MGS", "53TES", "51HOF", "54TOT", "55SOO", "61BRF", "62HGM", "63HFC", "71TEN", "72TNH", "73TOV"}
local raid_lfr = {"43DGS", "52MGS", "53TES", "51HOF", "54TOT", "55SOO", "61BRF", "62HGM", "63HFC", "71TEN", "72TNH", "73TOV"}
local raid_mythic = {"55SOO", "61BRF", "62HGM", "63HFC", "71TEN", "72TNH", "73TOV"}

local function MakeList(raids)
	local list = {}
	local colours = {["4"] = "ff778899", ["5"] = "ff996633", ["6"] = "ff6e8b3d", ["7"] = "ffffd700"}
	--local expsettings = {["4"] = AutoLog.db.global.hidecat, ["5"] = AutoLog.db.global.hidemop, ["6"] = AutoLog.db.global.hidewod, ["7"] = AutoLog.db.global.hideleg}
	for _, r in pairs(raids) do 
		local exp = string.sub(r,1,1)
		--if not expsettings[exp] then
			local c = colours[exp]
			list[r] = "|c" .. c .. GetMapNameByID(map_id_list[r])
		--end
	end
	return list
end

local function fadeOut(AutoLog, elapsed)
	local fadetime = AutoLogFrame.fadetime + elapsed
	if fadetime < 2 then AutoLogFrame.fadetime = fadetime
	else
		local fadeInfo = {}
		AutoLogFrame:SetScript("OnUpdate", nil)
		AutoLogFrame:SetScript("OnUpdate", nil)
		fadeInfo.mode = "OUT"
		fadeInfo.timeToFade = 3
		fadeInfo.startAlpha = 1
		fadeInfo.endAlpha = 0
		fadeInfo.finishedFunc = 
			function()
				AutoLogFrame:SetScript("OnUpdate", nil)
				AutoLogFrame:SetScript("OnUpdate", nil)
			end
		UIFrameFade(AutoLogFrame, fadeInfo)
	end
end

local function setdobj()
	if not AutoLog.dobj then
		local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
		AutoLog.dobj = ldb:NewDataObject("AutoLog", {type = "data source", text = format("AutoLog: |cff4499ff%s|r", _G.UNKNOWN)})
	end
end

function AutoLog:eventHandler(this, event, arg1, ...)
	if event == "ADDON_LOADED" and arg1 == "AutoLog" then
		--configure binding
		_G.BINDING_HEADER_AUTOLOG = "AutoLog"
		_G.BINDING_NAME_AUTOLOG_TOGGLE = L["Start/Stop logging"]
		local defaults = {
			global = {
				enable = true,	curLogging = false, dungeons = false, osw = true,
				raids10 = nil, raids25 = nil, raids10h = nil, raids25h = nil, lfr = {["71TEN"] = true, ["72TNH"] = true}, flex = nil, mythic = {["71TEN"] = true, 
				["72TNH"] = true}, normal = {["71TEN"] = true, ["72TNH"] = true}, heroic = {["71TEN"] = true, ["72TNH"] = true}, challenge = false,
				mythicdungeons = false, warned = false
			},
		}
		AutoLog.db = LibStub("AceDB-3.0"):New("AutoLog_DB", defaults)
		_G.SLASH_AUTOLOG_CMD1 = "/" .. L["al"]
		_G.SLASH_AUTOLOG_CMD2 = "/" .. L["autolog"]
		_G.SlashCmdList["AUTOLOG_CMD"] = function(input) AutoLog:ChatCommand(input) end
	elseif event == "PLAYER_LOGIN" then
		AutoLogFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		--AutoLogFrame:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
		local options = {
			name = "AutoLog", handler = AutoLog, type = "group",
			args = {
				enable = { -- Global enable key
					type = "toggle",
					name = L["Enable auto logging"],
					desc = L["If unchecked, AutoLog will never enable Combat Logging"],
					get = function() return AutoLog.db.global.enable end,
					set = function(info, value) AutoLog.db.global.enable = value AutoLog:CheckLog() end,
					width = "full",
					order = 1,
				},
				allraids = { -- all raids
					type = "toggle",
					width = "full",
					name = L["Log all raids"],
					desc = L["Log all raids regardless of individual raid settings"],
					get = function() return AutoLog.db.global.allraids end,
					set = function(info, value) AutoLog.db.global.allraids = value AutoLog:CheckLog() end,
					order = 1.5,
				},
				dungeons = { -- Heroic dungeons
					type = "toggle",
					name = L["Log 5 player heroic instances"],
					get = function() return AutoLog.db.global.dungeons end,
					set = function(info, value) AutoLog.db.global.dungeons = value AutoLog:CheckLog() end,
					order = 2,
					width = "full",
				},
				mythicdungeons = { -- Mythic dungeons
					type = "toggle",
					name = L["Log 5 player mythic dungeons"],
					get = function() return AutoLog.db.global.mythicdungeons end,
					set = function(info, value) AutoLog.db.global.mythicdungeons = value AutoLog:CheckLog() end,
					order = 2.5,
					width = "full",
				},
				challenge = { -- Challenge mode dungeons
					type = "toggle",
					name = L["Log 5 player challenge mode instances"],
					get = function() return AutoLog.db.global.challenge end,
					set = function(info, value) AutoLog.db.global.challenge = value AutoLog:CheckLog() end,
					order = 3,
					width = "full",
				},
				--guildRuns = { -- Only log guild runs
					--	type = "toggle", name = L["Only log guild runs"], set = "SetGuildRun", get = "GetGuildRun", order = 3, width = "full",
				--},
				--[[
					hideCat = {	-- Lich king raids
					type = "toggle",
					name = L["Hide Cataclysm raids"],
					get = function() return AutoLog.db.global.hidecat end,
					set = function(info, value) AutoLog.db.global.hidecat = value end,
					order = 4,
					width = "full",
				},
				hideMop = {	-- Pandaria raids
					type = "toggle",
					name = L["Hide Mists of Pandaria raids"],
					get = function() return AutoLog.db.global.hidemop end,
					set = function(info, value) AutoLog.db.global.hidemop = value end,
					order = 5,
					width = "full",
				},
				hideWod = {	-- Draenor raids
					type = "toggle",
					name = L["Hide Warlords of Draenor raids"],
					get = function() return AutoLog.db.global.hidewod end,
					set = function(info, value) AutoLog.db.global.hidewod = value end,
					order = 6,
					width = "full",
				},
				hideLeg = { -- Legion raids
					type = "toggle",
					name = L["Hide Legion raids"],
					get = function() return AutoLog.db.global.hideleg end,
					set = function(info, value) AutoLog.db.global.hideleg = value end,
					order = 7,
					width = "full",
				},
				]]--
				osw = { -- on screen warning
					type = "toggle",
					name = L["Show combat log status on screen"],
					get = function() return AutoLog.db.global.osw end,
					set = function(info, value) AutoLog.db.global.osw = value end,
					order = 8,
					width = "full",
				},
				spacer0 = {
					order = 9,
					type = "description",
					name = "\n",
				},
				loggingOn = {
					type = "description",
					fontSize = "medium",
					name = L["Combat logging turned on"],
					hidden = function() return not AutoLog.db.global.curLogging  end,
					image = function() return "Interface\\RAIDFRAME\\ReadyCheck-Ready", 24, 24 end,
					order = 10,
				},
				loggingOff = {
					type = "description",
					fontSize = "medium",
					name = L["Combat logging turned off"],
					hidden = function() return AutoLog.db.global.curLogging end,
					image = function() return "Interface\\RAIDFRAME\\ReadyCheck-NotReady", 24, 24 end,
					order = 11,
				},
				spacer1 = {
					order = 12,
					type = "description",
					name = "\n",
				},
				kb = {
					type = "keybinding",
					name = _G.KEY_BINDING,
					get = function() return GetBindingKey("AUTOLOG_TOGGLE") end,
					set = function(info, binding) SetBinding(select(1,GetBindingKey("AUTOLOG_TOGGLE"))); SetBinding(binding, "AUTOLOG_TOGGLE") end,
					order = 13,
				},
				spacer2 = {
					order = 14,
					type = "description",
					name = "\n",
				},
				raidsn = { -- Normal raids select
					type = "multiselect",
					name = L["Normal Raids"],
					desc = L["Raid instances where you want to log combat"],
					values = MakeList(raid_normal),
					tristate = false,
					get = function(info, raid) return AutoLog:GetSetting("normal", raid) end,
					set = function(info, raid, value) AutoLog:SetSetting("normal", raid, value) end,
					order = 15,
				},
				raidsh = { -- Heroic raids select
					type = "multiselect",
					name = L["Heroic Raids"],
					desc = L["Raid instances where you want to log combat"],
					values = MakeList(raid_heroic),
					tristate = false,
					get = function(info, raid) return AutoLog:GetSetting("heroic", raid) end,
					set = function(info, raid, value) AutoLog:SetSetting("heroic", raid, value) end,
					order = 16,
				},
				mythic = { -- Mythic raids select
					type = "multiselect",
					name = L["Mythic Raids"],
					desc = L["Raid instances where you want to log combat"],
					values = MakeList(raid_mythic),
					tristate = false,
					get = function(info, raid) return AutoLog:GetSetting("mythic", raid) end,
					set = function(info, raid, value) AutoLog:SetSetting("mythic", raid, value) end,
					order = 17,
				},
				lfr = { -- LFR raids select
					type = "multiselect",
					name = L["LFR Raids"],
					desc = L["Raid finder instances where you want to log combat"],
					values = MakeList(raid_lfr),
					tristate = false,
					get = function(info, raid) return AutoLog:GetSetting("lfr", raid) end,
					set = function(info, raid, value) AutoLog:SetSetting("lfr", raid, value) end,
					order = 18,
				},
			},
		}
		AceConfig:RegisterOptionsTable("AutoLog", options)
		AutoLog.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AutoLog", "AutoLog")
		--if AutoLog.db.global.guildrun then AutoLog:RegisterEvent("GUILD_PARTY_STATE_UPDATED") end
		alm = AutoLogFrame:CreateFontString("AutoLogMsg", "ARTWORK", "GameFontNormalLarge")
		alm:SetFont("Fonts\\FRIZQT__.TTF",28)
		alm:SetPoint("CENTER", AutoLogFrame, "CENTER", 0, 0)
		--local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
		--AutoLog.dobj = ldb:NewDataObject("AutoLog", {type = "data source", text = format("AutoLog: |cff4499ff%s|r", _G.UNKNOWN)})
		setdobj()
		if not AutoLog.db.global.warned then
			StaticPopup_Show("AUTOLOG_WARNING")
			AutoLog.db.global.warned = true
		end
	elseif event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" or 
		event == "ENCOUNTER_START" or event == "PLAYER_REGEN_DISABLED" or event == "RAID_INSTANCE_WELCOME" or event == "ZONE_CHANGED_INDOORS" or
		event == "ZONE_CHANGED" then
		if not AutoLog.scheduled then AutoLog:CheckLog() end
--[[
	elseif event == "GUILD_PARTY_STATE_UPDATED" then
	
		local  inGroup, numGuildPresent, numGuildRequired, xpMultiplier = InGuildParty()
		print("inGroup",inGroup, "numPresent", numGuildPresent, "numReq", numGuildRequired, "xpMult", xpMultiplier)
]]--		
	end
end

--check for Fall of Deathwing component of Dragon Soul
--looks for a raid group in The Maelstrom
local function checkFOD(mid) return ((mid == 751) or (mid == 737)) end

--GetKey function :
--		- Returns the key name of the raid, if it exists, false otherwise
function AutoLog:GetKey()
	local k, v
	local rk = false
	local mid = GetCurrentMapAreaID()
	if checkFOD(mid) then rk = "43DGS"	
	else
		for k, v in pairs (map_id_list) do
			if v == mid then
				rk = k
				break
			end
		end
	end
	return rk
end

function AutoLog:IsInRaid()
	local isInstance, instanceType = IsInInstance()
	if isInstance and instanceType == "raid" then return true end
end

function AutoLog:GetDifficulty() 
	local rd = GetRaidDifficultyID()
	if IsInRaid() then 
		if IsPartyLFG() and IsInLFGDungeon() then rd = 99 end
	else
		rd = GetDungeonDifficultyID()
		if rd ~= nil then rd = rd + 20 end		
	end
	return rd
end

--CheckLog function :
--		- Called on event / option changes
--		- Checks whether combat logging should be enabled (or not)
function AutoLog:CheckLog()
	setdobj()
	if not AutoLog.db.global.enable then
		AutoLog.dobj.text = format("AutoLog: |cff4499ff%s|r", _G.VIDEO_OPTIONS_DISABLED)
		return
	else
		if AutoLog.db.global.curLogging then AutoLog.dobj.text = format("AutoLog: |cff4499ff%s|r", L["On"])
		else AutoLog.dobj.text = format("AutoLog: |cff4499ff%s|r", L["Off"]) end
	end
	if AutoLog.scheduled then return end
	AutoLog.scheduled = true
	AutoLog:ScheduleTimer(function() AutoLog:SetLogging() end, 5)
end

function AutoLog:SetLogging(override)
	local msg
	local currentState = LoggingCombat() or false
	local difficulty = AutoLog:GetDifficulty()
	if not difficulty and not override then return end
	local inInstance, instanceType = IsInInstance()
	local isLogging = LoggingCombat()
	local isDungeon = (instanceType == "party") and not C_Garrison:IsOnGarrisonMap()
	local raidKey, raidType
	local goLog = false
	local isMythicDungeon = (isDungeon and (difficulty == 43))
	raidKey = AutoLog:GetKey()
	if raidKey then
		if difficulty == 14 then raidType = "normal"
		elseif difficulty == 15 then raidType = "heroic"
		elseif difficulty == 16 then raidType = "mythic"
		elseif difficulty == 8 then raidType = "challenge"
		elseif difficulty == 99 then raidType = "lfr" end
		--elseif difficulty == 7 then raidType = "lfr"
		raidType = raidType or "normal"
		if not inInstance then goLog = false
		elseif raidKey then goLog = AutoLog.db.global[raidType][raidKey] end
	end
	if AutoLog.db.global.allraids and AutoLog:IsInRaid() then goLog = true end
	if AutoLog.db.global.dungeons and isDungeon and (not isMythicDungeon) then goLog = true end
	if AutoLog.db.global.mythicdungeons and isMythicDungeon then goLog = true end
	if AutoLog.db.global.challenge and isDungeon and difficulty == 28 then goLog = true end
	if override then goLog = not currentState end
	if currentState ~= goLog then
		if goLog then
			AutoLog.db.global.curLogging = LoggingCombat(true)
			if AutoLog.db.global.curLogging then
				msg = L["Combat logging turned on"]
				print(msg)
			end
		elseif not goLog then
			AutoLog.db.global.curLogging = LoggingCombat(false)
			if not AutoLog.db.global.curLogging then
				msg = L["Combat logging turned off"]
				print(msg)
			end
		end
	end
	if AutoLog.db.global.curLogging then AutoLog.dobj.text = format("AutoLog: |cff4499ff%s|r", L["On"])
	else AutoLog.dobj.text = format("AutoLog: |cff4499ff%s|r", L["Off"]) end
	if AutoLog.db.global.osw and msg then
		alm:SetText(msg)
		AutoLogFrame:Show()
		AutoLogFrame:SetScript("OnUpdate", fadeOut)
	end
	AutoLog.scheduled = nil
	AceConfigRegistry:NotifyChange("AutoLog")
end

function AutoLog:ChatCommand(input)
	if not input or input:trim() == "" then
		--handle annoying Blizzard bug that sometimes stops the correct frame being shown
		InterfaceOptionsFrame_OpenToCategory(AutoLog.optionsFrame)
		InterfaceOptionsFrame_OpenToCategory(AutoLog.optionsFrame)
	else LibStub("AceConfigCmd-3.0").HandleCommand(AutoLog, "autolog", "AutoLog", input) end
end

function AutoLog:GetSetting(settingtype, raid) return AutoLog.db.global[settingtype][raid] end
function AutoLog:SetSetting(settingtype, raid, settingvalue) AutoLog.db.global[settingtype][raid] = settingvalue; AutoLog:CheckLog() end
function AutoLog:ToggleLog() AutoLog:SetLogging(true) end

--untested code
--[[
function AutoLog:SetGuildRun(info, val)
	AutoLog.db.global.guildrun = val
	
	if val then
		AutoLog:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
		AutoLog:GUILD_PARTY_STATE_UPDATED()
	else
		AutoLog:UnregisterEvent("GUILD_PARTY_STATE_UPDATED")
	end
	
	AutoLog:CheckLog()
end

function AutoLog:GetGuildRun() return AutoLog.db.global.guildrun end
]]--

StaticPopupDialogs.AUTOLOG_WARNING = {
	text = L["AutoLog's settings have changed from character based to account based. Please check your settings now."],
	button1 = _G.OKAY,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1,
	showAlert = 1,
	OnAccept =
		function()
			InterfaceOptionsFrame_OpenToCategory(AutoLog.optionsFrame)
			InterfaceOptionsFrame_OpenToCategory(AutoLog.optionsFrame)
		end,
}

CreateFrame("Frame","AutoLogFrame",UIParent)
AutoLogFrame:Hide()
AutoLogFrame.fadetime = 0
AutoLogFrame.wait = 0
AutoLogFrame:SetFrameStrata("DIALOG")
AutoLogFrame:SetHeight(200)
AutoLogFrame:SetWidth(UIParent:GetWidth())
AutoLogFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
AutoLogFrame:RegisterEvent("ADDON_LOADED")
AutoLogFrame:RegisterEvent("PLAYER_LOGIN")
AutoLogFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
AutoLogFrame:RegisterEvent("PLAYER_ALIVE")
AutoLogFrame:RegisterEvent("PLAYER_UNGHOST")
AutoLogFrame:RegisterEvent("ENCOUNTER_START")
AutoLogFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
AutoLogFrame:RegisterEvent("RAID_INSTANCE_WELCOME")
AutoLogFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
AutoLogFrame:RegisterEvent("ZONE_CHANGED")
AutoLogFrame:SetScript("OnEvent", function(...) AutoLog:eventHandler(...) end)