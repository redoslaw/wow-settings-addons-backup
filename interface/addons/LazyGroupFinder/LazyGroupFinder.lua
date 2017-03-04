--[[
	I've had alot of help building this addon by looking on code from:
	
	World Quest Group Finder https://mods.curse.com/addons/wow/worldquestgroupfinder
	Premade Group Finder https://mods.curse.com/addons/wow/premade-group-finder
	
	Thanks alot for you good work!
	
	Best regards,
	Anders Krüger / Luuci-Frostmane EU
]]

LGFfoundGroups = {}
LGFignoreGroups = {}

LGFcurrentID = 0
LGFcurrentLeader = ""
LGFcurrentActivity = 0

LGFtimeSinceLastUpdate = 0

LGFautoPause = false

local achievementIDs = {
	[457] = "11426 11394", -- Trial of valor (Heroic) 
	[456] = "11426 11394", -- Trial of valor (Normal)
	[414] = "11194 10820", -- Emerald Nightmare (Heroic)
	[413] = "11194 10820", -- Emerald Nightmare (Normal)
}

function GetActivityBackground(id)
	if id == 457 or id == 456 then
		return "Interface\\ENCOUNTERJOURNAL\\UI-EJ-BACKGROUND-TrialofValor"
	elseif id == 414 or id == 413 then
		return "Interface\\ENCOUNTERJOURNAL\\UI-EJ-BACKGROUND-TheEmeraldNightmare"
	else
		return "Interface\\ENCOUNTERJOURNAL\\UI-EJ-BACKGROUND-BrokenIsles"
	end
end

function IsKeywordsInWords(keywords, words)
	if keywords == "" then return true end
	for keyword in string.gmatch(string.lower(keywords), '([^ ]+)') do
		if string.match(string.lower(words), keyword) then
			return true
		end
	end
	return false
end

function IsKeywordsNotInWords(keywords, words)
	if keywords == "" then return true end
	for keyword in string.gmatch(string.lower(keywords), '([^ ]+)') do
		if string.match(string.lower(words), keyword) then
			return false
		end
	end
	return true
end

function ShowBestResult()
	if not LazyGroupFinderEnabled or LFGListFrame:IsVisible() then return end
	local HighestScoreID = nil
	local HighestScore = -10000000
	for k, v in pairs(LGFfoundGroups) do
		if LGFfoundGroups[k].Score > HighestScore then
			HighestScoreID = LGFfoundGroups[k].Id
			HighestScore = LGFfoundGroups[k].Score
		end
	end
	if HighestScoreID ~= nil then
		LazyGroupFinder_GroupPopup(HighestScoreID)
		if LazyGroupFinderSoundAnnouncement then PlaySound("ReadyCheck", "master") end
		FlashClientIcon()
	end
end

function LazyGroupFinderEnableAddon()
	LGFtimeSinceLastUpdate = 9
	LazyGroupFinderEnabled = true
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFFLazy Group Finder:|cFF00FF00 Enabled")
	LazyGroupFinder_MinimapButton_SetEnabled()
	PlaySound("PVPENTERQUEUE")
end

function LazyGroupFinderDisableAddon()
	LazyGroupFinderEnabled = false
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFFLazy Group Finder:|cFFFF0000 Disabled")
	LazyGroupFinder_MinimapButton_SetDisabled()
	LGFfoundGroups = {}
	LGFignoreGroups = {}
	LazyGroupFinderPopup:Hide()
end

local LazyGroupFinderAddon = CreateFrame("Frame", "LazyGroupFinderAddon", UIParent)
local RegisteredEvents = {}
LazyGroupFinderAddon:SetScript("OnEvent", function (self, event, ...) if (RegisteredEvents[event]) then return RegisteredEvents[event](self, event, ...) end end)

function RegisteredEvents:ADDON_LOADED(event, addon, ...)
	if addon ~= "LazyGroupFinder" then return end
	if LazyGroupFinderEnabled == nil then LazyGroupFinderEnabled = false end
	if LazyGroupFinderAchievementOnApply == nil then LazyGroupFinderAchievementOnApply = false end
	if LazyGroupFinderActivityType == nil then LazyGroupFinderActivityType = 3 end
	if LazyGroupFinderActivities == nil then LazyGroupFinderActivities = {} end
	if LazyGroupFinderKeywords == nil then LazyGroupFinderKeywords = "" end
	if LazyGroupFinderBannedwords == nil then LazyGroupFinderBannedwords = "WTS" end
	if LazyGroupFinderMinimapIconPoint == nil then LazyGroupFinderMinimapIconPoint = 180 end
	if LazyGroupFinderMinimapIconHover == nil then LazyGroupFinderMinimapIconHover = false end
	if LazyGroupFinderSoundAnnouncement == nil then LazyGroupFinderSoundAnnouncement = true end
	if LazyGroupFinderChatAnnouncement == nil then LazyGroupFinderChatAnnouncement = false end
	if LazyGroupFinderMinTank == nil then LazyGroupFinderMinTank = "" end
	if LazyGroupFinderMaxTank == nil then LazyGroupFinderMaxTank = "" end
	if LazyGroupFinderMinHeal == nil then LazyGroupFinderMinHeal = "" end
	if LazyGroupFinderMaxHeal == nil then LazyGroupFinderMaxHeal = "" end
	if LazyGroupFinderMinDps == nil then LazyGroupFinderMinDps = "" end
	if LazyGroupFinderMaxDps == nil then LazyGroupFinderMaxDps = "" end
	
	if not LazyGroupFinderMinimapIconHover then LGFminimapIconButton:Show() end
	
	if LazyGroupFinderEnabled then
		LazyGroupFinderEnableAddon()
	else
		LazyGroupFinderDisableAddon()
	end
	
	LazyGroupFinder_MinimapButton_SetPoint(LazyGroupFinderMinimapIconPoint)
end

function RegisteredEvents:LFG_LIST_SEARCH_RESULTS_RECEIVED(event)
	if not LazyGroupFinderEnabled then return end
	if LFGListFrame:IsVisible() then
		LazyGroupFinderDisableAddon()
		return
	end

	for k, v in pairs(LGFfoundGroups) do LGFfoundGroups[k] = nil end

	local numResults, results = C_LFGList.GetSearchResults()
	LFGListUtil_SortSearchResults(results)

	for k, v in pairs(results) do

		local id,activity,name,comment,_,ilvl,_,age,_,_,_,isDelisted,leader,members = C_LFGList.GetSearchResultInfo(results[k])

		if leader ~= nil then -- the group needs a leader
			local activityName,_,activityType,_,activityIlvl,_,_,_,_,_ = C_LFGList.GetActivityInfo(activity)

			local groupSetup = C_LFGList.GetSearchResultMemberCounts(id)
			local encounterInfo = C_LFGList.GetSearchResultEncounterInfo(id)
			
			if LazyGroupFinderActivities[activity] == nil then LazyGroupFinderActivities[activity] = false end

			if LazyGroupFinderActivities[activity] == true then
				local groupIgnored = false
				for k2, v2 in pairs(LGFignoreGroups) do
					if activity == LGFignoreGroups[k2].Activity and string.lower(leader) == string.lower(LGFignoreGroups[k2].Leader) then -- Some update
						groupIgnored = true
						break
					end
				end
				
				local goodGroupSetup = true
				if LazyGroupFinderMinTank ~= "" then
					if tonumber(groupSetup["TANK"]) < tonumber(LazyGroupFinderMinTank) then goodGroupSetup = false end
				end
				if LazyGroupFinderMaxTank ~= "" then
					if tonumber(groupSetup["TANK"]) > tonumber(LazyGroupFinderMaxTank) then goodGroupSetup = false end
				end
				if LazyGroupFinderMinHeal ~= "" then
					if tonumber(groupSetup["HEALER"]) < tonumber(LazyGroupFinderMinHeal) then goodGroupSetup = false end
				end
				if LazyGroupFinderMaxHeal ~= "" then
					if tonumber(groupSetup["HEALER"]) > tonumber(LazyGroupFinderMaxHeal) then goodGroupSetup = false end
				end
				if LazyGroupFinderMinDps ~= "" then
					if tonumber(groupSetup["DAMAGER"]) < tonumber(LazyGroupFinderMinDps) then goodGroupSetup = false end
				end
				if LazyGroupFinderMaxDps ~= "" then
					if tonumber(groupSetup["DAMAGER"]) > tonumber(LazyGroupFinderMaxDps) then goodGroupSetup = false end
				end
				
				if not groupIgnored and goodGroupSetup and IsKeywordsInWords(LazyGroupFinderKeywords, name .. " " .. comment .. " " .. leader) and IsKeywordsNotInWords(LazyGroupFinderBannedwords, name .. " " .. comment .. " " .. leader) then
					local index = #LGFfoundGroups + 1
					LGFfoundGroups[index] = {}
					LGFfoundGroups[index].Id = id
					LGFfoundGroups[index].Name = name
					LGFfoundGroups[index].Leader = leader
					LGFfoundGroups[index].Activity = activity
					LGFfoundGroups[index].Score = ilvl + members + math.abs(GetAverageItemLevel() - activityIlvl) * -1000
				end
			end
		end
	end
	if LazyGroupFinderChatAnnouncement then
		if #LGFfoundGroups == 1 then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFFLazy Group Finder:|cFFFFFF00 " .. #LGFfoundGroups .. " groups found.")
		end
		if #LGFfoundGroups > 1 then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFFLazy Group Finder:|cFFFFFF00 " .. #LGFfoundGroups .. " group found.")
		end
	end
	LazyGroupFinderPopup:Hide()
end

function RegisteredEvents:LFG_LIST_SEARCH_RESULT_UPDATED(event, resultsID)
	if not LazyGroupFinderEnabled then return end
	if LFGListFrame:IsVisible() then
		LazyGroupFinderDisableAddon()
		return
	end
	
	local id,activity,name,comment,_,ilvl,_,age,_,_,_,isDelisted,leader,members = C_LFGList.GetSearchResultInfo(resultsID)

	local activityName,_,activityType,_,activityIlvl,_,_,_,_,_ = C_LFGList.GetActivityInfo(activity)
	
	local groupSetup = C_LFGList.GetSearchResultMemberCounts(id)
	local encounterInfo = C_LFGList.GetSearchResultEncounterInfo(id)
	local deadbosses = " "
	if encounterInfo ~= nil then
		deadbosses = #encounterInfo .. ""
	end
	
	if age ~= nil then
		for k, v in pairs(LGFfoundGroups) do
			if string.lower(name) == string.lower(LGFfoundGroups[k].Name) and string.lower(leader) ~= string.lower(LGFfoundGroups[k].Leader) then --Leader has changed
				if LGFfoundGroups[k].Id == LGFcurrentID then
					LGFcurrentID = id
					LGFcurrentLeader = leader
				end
				LGFfoundGroups[k].Id = id
				LGFfoundGroups[k].Leader = leader
				LGFfoundGroups[k].Score = ilvl + members + math.abs(GetAverageItemLevel() - activityIlvl) * -1000
			elseif string.lower(name) ~= string.lower(LGFfoundGroups[k].Name) and string.lower(leader) == string.lower(LGFfoundGroups[k].Leader) then -- Name has changed
				if LGFfoundGroups[k].Id == LGFcurrentID then
					LGFcurrentID = id
				end
				LGFfoundGroups[k].Id = id
				LGFfoundGroups[k].Name = name
				LGFfoundGroups[k].Score = ilvl + members + math.abs(GetAverageItemLevel() - activityIlvl) * -1000
			elseif isDelisted and string.lower(name) == string.lower(LGFfoundGroups[k].Name) and string.lower(leader) == string.lower(LGFfoundGroups[k].Leader) then -- Group delisted
				if LGFfoundGroups[k].Id == LGFcurrentID then
					-- give new popup
				end
				LGFfoundGroups[k] = nil
			elseif string.lower(name) == string.lower(LGFfoundGroups[k].Name) and string.lower(leader) == string.lower(LGFfoundGroups[k].Leader) then -- Some update
				if LGFfoundGroups[k].Id == LGFcurrentID then
					LGFcurrentID = id
					LGFcurrentActivity = activity
				end
				LGFfoundGroups[k].Id = id
				LGFfoundGroups[k].Activity = activity
				LGFfoundGroups[k].Score = ilvl + members + math.abs(GetAverageItemLevel() - activityIlvl) * -1000
			end
		end
	end
end

function RegisteredEvents:LFG_LIST_APPLICATION_STATUS_UPDATED(event, applicationID, status)
	local _,activity,name,comment,_,ilvl,_,_,_,_,_,_,leader,members = C_LFGList.GetSearchResultInfo(applicationID)
    
	if (status == "applied") then
		if LazyGroupFinderAchievementOnApply then -- SEND ACHIEVEMNT TO LEADER
			if achievementIDs[activity] ~= nil then
				for achID in string.gmatch(achievementIDs[activity], '([^ ]+)') do
					local _,_,_,completed = GetAchievementInfo(tonumber(achID))
					if completed then
						SendChatMessage(GetAchievementLink(tonumber(achID)), "WHISPER", nil, leader)
						break
					end
				end
			end
		end
	end
end

for k, v in pairs(RegisteredEvents) do
	LazyGroupFinderAddon:RegisterEvent(k)
end

LazyGroupFinderAddon:SetScript("OnUpdate", function(self, elapsed)
	if not LFGListFrame:IsVisible() and not LazyGroupFinderOptions:IsVisible() and LGFautoPause then
		LGFautoPause = false
		LazyGroupFinderEnableAddon()
	end
	if not LazyGroupFinderEnabled then return end
	if LFGListFrame:IsVisible() or LazyGroupFinderOptions:IsVisible() then
		LGFautoPause = true
		LazyGroupFinderDisableAddon()
		return
	end
	
	LGFtimeSinceLastUpdate = LGFtimeSinceLastUpdate + elapsed
	if LGFtimeSinceLastUpdate >= 10 and not LFGListApplicationDialog:IsVisible() then
		LGFtimeSinceLastUpdate = 0
		C_LFGList.ClearSearchResults()
		C_LFGList.Search(LazyGroupFinderActivityType, "", 0, 4, C_LFGList.GetLanguageSearchFilter())
	end

	if not LazyGroupFinderPopup:IsVisible() and #LGFfoundGroups > 0 and not LFGListApplicationDialog:IsVisible() then
		ShowBestResult()
	end
end)