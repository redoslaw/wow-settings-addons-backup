AnnounceIt = LibStub("AceAddon-3.0"):NewAddon("AnnounceIt", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("AnnounceIt")
AnnounceIt:RegisterChatCommand("announceit", "OpenOptions")

-- Hook for linking hyperlinks as a backup to easier methods
--   Will need to look into other means for glyphs and quests as
--   API does not provide general lookup based on actual ids
-- Need to fix Professions
local AI_OnHyperlinkClick = function(...)
	local _, link = ...
	local finalid = ""
	local hyperLink = ""
	if ( AnnounceItSetMessage:IsShown() and IsModifiedClick("CHATLINK") ) then
		if ( link ) then
			linkType = string.sub(link,1,(string.find(link,":")-1))
			hyperLink = nil
			if linkType == "item" then
				_, hyperLink = GetItemInfo(link)
				AnnounceIt:InsertHyperLink(hyperLink)
			elseif linkType == "spell" then
				finalid = string.sub(link,(string.find(link,":")+1))
				hyperLink = GetSpellLink(finalid)
				AnnounceIt:InsertHyperLink(hyperLink)
			elseif linkType == "enchant" then
				finalid = string.sub(link,(string.find(link,":")+1))
				hyperLink = GetTradeSkillItemLink(finalid)
				AnnounceIt:InsertHyperLink(hyperLink)
			elseif linkType == "achievement" then
				finalid = string.sub(link,(string.find(link,":")+1))
				finalid = string.sub(finalid,1,(string.find(finalid,":")-1))
				hyperLink = GetAchievementLink(finalid)
				AnnounceIt:InsertHyperLink(hyperLink)
			end
		end
	end
end
for i = 1, NUM_CHAT_WINDOWS do
	local chat = _G["ChatFrame"..i]
	chat:HookScript("OnHyperlinkClick", AI_OnHyperlinkClick)
end

-- Hook for linking achievements
function AnnounceIt:ADDON_LOADED(eventName, addon)
	if (addon == "Blizzard_AchievementUI") then
		local orig_AchievementButton_OnClick = AchievementButton_OnClick
		AchievementButton_OnClick = function(...)
			local self, button, down, ignoreModifiers = ...
			if ( AnnounceItSetMessage:IsShown() and IsModifiedClick("CHATLINK") and not ignoreModifiers ) then
				local achievementLink = GetAchievementLink(self.id)
				if ( achievementLink ) then
					for i = 1,5 do 
						if ( _G["AnnounceItSetMessage_Text"..i]:HasFocus() ) then
							_G["AnnounceItSetMessage_Text"..i]:Insert(achievementLink)
						end
					end
				end
				return
			else
				return orig_AchievementButton_OnClick(...);
			end
		end
	end
end

AnnounceIt:RegisterEvent("ADDON_LOADED")
AnnounceIt.version = GetAddOnMetadata("AnnounceIt", "Version")
AnnounceIt.versionstring = "AnnounceIt "..GetAddOnMetadata("AnnounceIt", "Version")

local aiLDB = LibStub("LibDataBroker-1.1"):NewDataObject("AnnounceIt", {
	type = "launcher",
	text = "AnnounceIt",
	icon = "Interface\\Addons\\AnnounceIt\\icon",
	OnClick = function(_, msg)
		if msg == "LeftButton" then
			AnnounceIt:LastMessage()
		end
		if msg == "RightButton" then
			AnnounceIt:InitMenu()
		end
	end,
	OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then return end
		tooltip:AddLine("AnnounceIt |cffffff00" .. AnnounceIt.version .. "|r")
		tooltip:AddLine("|cffffff00" .. "Right-click|r for menu")
	end,
})
local icon = LibStub("LibDBIcon-1.0")

-- variables and constants
local pname = UnitName("player")
local prace = UnitRace("player")
local pclass = UnitClass("player")
local plevel
local pilevel
local pspec
local pgearscore
local pguild
local curprofile
local channelid
local aiprofilelist = {}
local aimenuitems = { }
local info = { }
local aiconstants = {
	["fieldlimit"] = 5,
	["chattypes"] = {
		["TEST"] = true,
		["GROUP"] = false,
		["GUILD"] = false,
		["WHISPER"] = false,
		["RECRUIT"] = false,
		["SAY"] = false,
		["YELL"] = false,
		["BATTLEGROUND"] = false,
		["TRADE"] = false,
		["LFG"] = false,
		["OFFICER"] = false,
		["RAID_WARNING"] = false
	},
	["chattypeslocale"] = {
		["TEST"] = L["TEST"],
		["GROUP"] = L["GROUP"],
		["GUILD"] = L["GUILD"],
		["WHISPER"] = L["WHISPER"],
		["RECRUIT"] = L["RECRUIT"],
		["SAY"] = L["SAY"],
		["YELL"] = L["YELL"],
		["BATTLEGROUND"] = L["BATTLEGROUND"],
		["TRADE"] = L["TRADE"],
		["LFG"] = L["LFG"],
		["OFFICER"] = L["OFFICER"],
		["RAID_WARNING"] = L["RAID_WARNING"]
	},
}

-- defaults
local defaults = {
	profile = {
		messages = { },
		last = {
			enable = false,
		},
		minimap = {
			hide = false,
			minimapPos = 230,
			radius = 80,
		},
		quicksend = {
			disable = false,
		},
	},
}

function AnnounceIt:LastMessage()
	if (self.db.profile.quicksend.disable == false) then
		if (self.db.profile.lastmessage) then
			messageid = self.db.profile.lastmessage["message"]
			channelid = self.db.profile.lastmessage["chan"]
			channeltype = self.db.profile.lastmessage["type"]
			self:SendMessage(messageid, channelid, channeltype)
		else
			DEFAULT_CHAT_FRAME:AddMessage(L["You have not previously sent any messages!"], 1.0, 0.0, 0.0)
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(L["You have the quick send feature disabled"], 1.0, 0.0, 0.0)
	end
end

function AnnounceIt:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("aiDB", defaults, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

	icon:Register("AnnounceItButton", aiLDB, self.db.profile.minimap)

	aiprofilelist = {}
	curprofile = self.db:GetCurrentProfile()
	for _,v in ipairs(self.db:GetProfiles()) do
		if (curprofile ~= v) then
			if (aiDB.profiles[v].messages) then
				aiprofilelist[v] = {}
				aiprofilelist[v].name = v
				aiprofilelist[v].type = "group"
				aiprofilelist[v].args = {}
				for ii,vv in pairs(aiDB.profiles[v].messages) do
					aiprofilelist[v].args[ii] = {}
					aiprofilelist[v].args[ii].name = ii
					aiprofilelist[v].args[ii].desc = L["Copy this message to the current profile"]
					aiprofilelist[v].args[ii].type = "execute"
					aiprofilelist[v].args[ii].func = function() AnnounceIt:Copy(v,ii) end
				end
			end
		end
	end

	aitags = {
		example1 = {
			name = "|cFFFFCC00"..L["Message Tags"],
			type = "description",
			order = 1,
			fontSize = "medium"
		},
		example2 = {
			name = "|cFFBBBBBB"..L["Use these tags to insert information that you want to use. This way you can use the same message on various toons. You can also use custom tags for whatever you desire."],
			type = "description",
			order = 2,
			fontSize = "small"
		},
		spacer1 = {
			name = " ",
			type = "description",
			order = 3
		},
		example3 = {
			name = "|cFFFFCC00"..L["Example:"],
			type = "description",
			order = 4,
			fontSize = "medium"
		},
		example4 = {
			name = "|cFFBBBBBB"..L["My name is [NAME]. I am a [RACE] [CLASS] in the [GUILD] guild."].."|r",
			type = "description",
			order = 5,
			fontSize = "small"
		},
		spacer2 = {
			name = "|cFFFFFFFF ",
			type = "description",
			order = 9
		},
		head10 = {
			name = L["Preset Tags"],
			type = "header",
			order = 10
		},
		tag10 = {
			name = "|cFF00CC00[GUILD] |cFFBBBBBB- "..L["Your guild name if you are in a guild"],
			type = "description",
			order = 20
		},
		tag20 = {
			name = "|cFF00CC00[LEVEL] |cFFBBBBBB- "..L["Your current level"],
			type = "description",
			order = 30
		},
		tag30 = {
			name = "|cFF00CC00[NAME] |cFFBBBBBB- "..L["Your name"],
			type = "description",
			order = 40
		},
		tag40 = {
			name = "|cFF00CC00[RACE] |cFFBBBBBB- "..L["Your race"],
			type = "description",
			order = 50
		},
		tag50 = {
			name = "|cFF00CC00[CLASS] |cFFBBBBBB- "..L["Your class"],
			type = "description",
			order = 60
		},
		tag50 = {
			name = "|cFF00CC00[SPEC] |cFFBBBBBB- "..L["Your current spec"],
			type = "description",
			order = 60
		},
		tag60 = {
			name = "|cFF00CC00[ILEVEL] |cFFBBBBBB- "..L["Your average ilevel"],
			type = "description",
			order = 62
		},
		spacer10 = {
			name = " ",
			type = "description",
			order = 65,
		},
		head20 = {
			name = L["Custom Tags"],
			type = "header",
			order = 70,
		},
		custtag10 = {
			name = "|cFFBBBBBB- "..L["Coming Soon"],
			type = "description",
			order = 80
		},
	}

	local aioptions = {
		name = "AnnounceIt",
		type = "group",
		childGroups = "tab",
		args = {
			hideMiniMapButton = {
				name = L["Hide Minimap Button"],
				desc = L["Toggles the AnnounceIt minimap button"],
				type = "toggle",
				set = function(info,val) AnnounceIt:togglemmb() end,
				get = function(info) return self.db.profile.minimap.hide end,
			},
			disableQuickResend = {
				name = L["Disable Quick Resend"],
				desc = L["Disables the left click option for resending last message."],
				type = "toggle",
				set = function(info,val) AnnounceIt:togglequicksend() end,
				get = function(info) return self.db.profile.quicksend.disable end,
			},
			settings = {
				name = L["Messages and Profiles"],
				type = "header",
			},
			copies = {
				name = L["Copy Messages"],
				desc = L["Copy messages from other profiles to current profile."],
				type = "group",
				args = aiprofilelist
			},
			tags = {
				name = L["Message Tags"],
				desc = L["Text replacements for messages"],
				type = "group",
				args = aitags
			},
			profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
		},
	}

	LibStub("AceConfig-3.0"):RegisterOptionsTable("AnnounceIt", aioptions)

	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AnnounceIt")
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AnnounceIt", "Copies", "AnnounceIt", "copies") 
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AnnounceIt", "Profiles", "AnnounceIt", "profiles") 

	if (self.db.profile.minimap.hide) then
		icon:Hide("AnnounceItButton")
	else
		icon:Show("AnnounceItButton")
	end

	-- set UI interface locales up
	AnnounceItSetMessage_ChanTESTText:SetText( L["TEST"])
	AnnounceItSetMessage_ChanGROUPText:SetText(L["GROUP"])
	AnnounceItSetMessage_ChanGUILDText:SetText(L["GUILD"])
	AnnounceItSetMessage_ChanWHISPERText:SetText(L["WHISPER"])
	AnnounceItSetMessage_ChanRECRUITText:SetText(L["RECRUIT"])
	AnnounceItSetMessage_ChanSAYText:SetText(L["SAY"])
	AnnounceItSetMessage_ChanYELLText:SetText(L["YELL"])
	AnnounceItSetMessage_ChanBATTLEGROUNDText:SetText(L["BATTLEGROUND"])
	AnnounceItSetMessage_ChanTRADEText:SetText(L["TRADE"])
	AnnounceItSetMessage_ChanLFGText:SetText(L["LFG"])
	AnnounceItSetMessage_ChanOFFICERText:SetText(L["OFFICER"])
	AnnounceItSetMessage_ChanRAID_WARNINGText:SetText(L["RAID_WARNING"])
	AnnounceItSetMessage_Header:SetText(L["Message"]..":")
	AnnounceItSetMessage_Header2:SetText(L["Title"]..":")
	AnnounceItSetMessage_Header3:SetText(L["Channels"]..":")
	AnnounceItSetMessage_Header5:SetText(L["Custom"])
	AnnounceItSetMessage_Header6:SetText(L["Channels"]..":")
	AnnounceItSetMessageApply:SetText(L["Apply"])
	AnnounceItSetMessageReset:SetText(L["Cancel"])

	
	
	--	version check
	if (self.db.global.version == AnnounceIt.version) then
		return
	else
		-- 3.1.0 --> remove version check from profiles and add to global settings
		for _,v in ipairs(self.db:GetProfiles()) do
			if (aiDB.profiles[v].version) then
				aiDB.profiles[v].version = nil
			end
		end
		self.db.global.version = AnnounceIt.version
		---------------------------------------------------------------------------
	end
end


function AnnounceIt:RefreshConfig()
	aimenuitems = { }
end

StaticPopupDialogs["AISaveError"] = {
	text = L["Your message title was not unique, please enter a unique title."],
	button1 = L["OK"],
	OnAccept = function()
		return
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}
StaticPopupDialogs["AIDuplicateName"] = {
	text = "|n |cFFFF5511"..L["Oops!|r|n|n The name |cFF00BB00%s|r already exists in the current profile. You will need to rename one of the messages before you can copy."],
	button1 = L["OK"],
	showAlert = true,
	OnAccept = function()
		return
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}
StaticPopupDialogs["AICopyCompleted"] = {
	text = "|cFF88CC88"..L["Copy Successful!|r|n|nMessage |cFF00BB00%s|r from the |cFF00BB00%s|r profile has successfully been copied."],
	button1 = L["OK"],
	OnAccept = function()
		return
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

function AnnounceIt:InitMenu()
	for z,value in pairs(self.db.profile.messages) do
		aimenuitems[z] = { }
		aimenuitems[z].channel = { }
		for sendchannel,senditemvalue in pairs(self.db.profile.messages[z].chan) do
			aimenuitems[z].channel[sendchannel] = "regular"
		end
		for sendcchannel,sendcitemvalue in pairs(self.db.profile.messages[z].custom) do
			if (self.db.profile.messages[z].custom[sendcchannel] ~= "") then
				aimenuitems[z].channel[sendcitemvalue] = "custom"
			end
		end
	end
	if not self.aimenu then
		self.aimenu = CreateFrame("Frame", "AnnounceItMenu")
	end
	local aimenu = self.aimenu
	aimenu.displayMode = "MENU"
	aimenu.initialize = function(self, level)
		if not (level) then
			return
		end

		wipe(info)

		level = level or 1
		if (level == 1) then
			info.isTitle = true
			info.text = AnnounceIt.versionstring
			info.notCheckable = true
			UIDropDownMenu_AddButton(info, level)
	
			wipe(info)
		
			for message, value in pairsByKeys(aimenuitems) do
				info.hasArrow = true
				info.notCheckable = true
				info.text = message
				info.value = {
					["messagekey"] = message
				}
				UIDropDownMenu_AddButton(info, level)
			end

			wipe(info)
			info.disabled = 1
			UIDropDownMenu_AddButton(info, level)
			info.disabled = nil

			info.value = nil
			info.hasArrow = false
			info.notCheckable = true
			info.text = L["New Message"]
			info.func = function() AnnounceIt:NewMessage() end
			UIDropDownMenu_AddButton(info, level)

			info.notCheckable = true
			info.value = nil
			info.hasArrow = false
			info.text = L["Options"]
			info.func = function() InterfaceOptionsFrame_OpenToCategory("AnnounceIt") end
			UIDropDownMenu_AddButton(info, level)
		end
		if (level == 2) then
			-- getting values of first menu
			local messageid = UIDROPDOWNMENU_MENU_VALUE["messagekey"]
			channellist = aimenuitems[messageid].channel

			info.isTitle = true
			info.text = messageid
			info.notCheckable = true
			UIDropDownMenu_AddButton(info, level)

			info.disabled = nil
			info.isTitle = nil

			for channelid, channeltype in pairs(channellist) do
				info.hasArrow = false
				info.notCheckable = true
				if (channeltype=="regular") then
					for index,value in pairs(aiconstants.chattypeslocale) do
						if (channelid == index) then
							info.text = value
						end
					end
				else
					info.text = channelid
				end
				info.func = function() AnnounceIt:SendMessage(messageid,channelid,channeltype) end
				info.value = {
					["messagekey"] = messageid,
					["channelkey"] = channelid,
				}
				UIDropDownMenu_AddButton(info, level)
			end

			wipe(info)
			info.disabled = 1
			UIDropDownMenu_AddButton(info, level)
			info.disabled = nil
	
			info.hasArrow = nil
			info.notCheckable = true
			info.text = "Edit"
			info.func = function() AnnounceIt:EditMessage(messageid) end
			UIDropDownMenu_AddButton(info, level)

			info.hasArrow = false
			info.notCheckable = true
			info.text = "Delete"
			info.func = function() AnnounceIt:DeleteMessage(messageid) end
			UIDropDownMenu_AddButton(info, level)
		end
	end
	local x,y = GetCursorPosition(UIParent);
	ToggleDropDownMenu(1, nil, aimenu, "UIParent", x / UIParent:GetEffectiveScale() , y / UIParent:GetEffectiveScale())
end

-- create a new message and edit it
function AnnounceIt:NewMessage()
	for index,value in pairs(aiconstants.chattypes) do
		_G["AnnounceItSetMessage_Chan"..index]:SetChecked(false)
	end
	for i=1,aiconstants.fieldlimit,1 do
		_G["AnnounceItSetMessage_Text"..i]:SetText("")
	end
	for i=1,4,1 do
		_G["AnnounceItSetMessage_CustomChan"..i]:SetText("")
	end
	AnnounceItSetMessage_Label:SetText(L["New Message"])
	active_message_id = L["New"]
	AnnounceItSetMessage_Header4:SetText(AnnounceIt.versionstring)
	AnnounceItSetMessage:Show()
end

-- populate and open the edit box with the selected message
function AnnounceIt:EditMessage(messageID)
	for index,value in pairs(aiconstants.chattypes) do
		_G["AnnounceItSetMessage_Chan"..index]:SetChecked(false)
	end
	for index,value in pairs(self.db.profile.messages[messageID].chan) do
		_G["AnnounceItSetMessage_Chan"..index]:SetChecked(true)
	end
	
	for i=1,aiconstants.fieldlimit,1 do
		_G["AnnounceItSetMessage_Text"..i]:SetText(self.db.profile.messages[messageID].text[i])
	end
	for i,v in pairs(self.db.profile.messages[messageID].custom) do
		_G["AnnounceItSetMessage_CustomChan"..i]:SetText(v)
	end
	AnnounceItSetMessage_Label:SetText(messageID)
	active_message_id = messageID
	AnnounceItSetMessage_Header4:SetText(AnnounceIt.versionstring)
	AnnounceItSetMessage:Show()
end

-- Take the message and send it
function AnnounceIt:SendMessage(selectedmessage, selectedchannel, customchannel)

	if (selectedchannel == "TEST") then
		DEFAULT_CHAT_FRAME:AddMessage("> "..L["Testing"]..": "..selectedmessage, 1.0, 0.0, 0.0)
		for index,value in pairs(self.db.profile.messages[selectedmessage].text) do
			if (self.db.profile.messages[selectedmessage].text[index] ~= "") then
				messagetext = AnnounceIt:ParseText(self.db.profile.messages[selectedmessage].text[index])
				DEFAULT_CHAT_FRAME:AddMessage("> "..messagetext, 0.7, 0.3, 0.0)
			end
			self.db.profile.lastmessage = { }
			self.db.profile.lastmessage["message"] = selectedmessage
			self.db.profile.lastmessage["chan"] = selectedchannel
			self.db.profile.lastmessage["type"] = customchannel
		end
	else
		channelid = nil
		local errormessage = nil
		local messagechannel = selectedchannel
		if (selectedchannel == "RECRUIT") then
			channelid = GetChannelName("GuildRecruitment - City")
			messagechannel = "CHANNEL"
		elseif (selectedchannel == "WHISPER") then
			local chatwindow = ChatEdit_GetActiveWindow();
			if (chatwindow) then
				channelType = chatwindow:GetAttribute("chatType")
				if (channelType == "REPLY") then
					channelid = ChatEdit_GetLastTellTarget(activeWindow)
				elseif (channelType == "WHISPER") then
					channelid = chatwindow:GetAttribute("tellTarget")
				else
					errormessage = L["You are not in whisper or reply mode."]
				end
			else
				errormessage = L["You are not in whisper or reply mode."]
			end
		elseif (selectedchannel == "GROUP") then
			if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
				messagechannel = "INSTANCE_CHAT"
			elseif (IsInRaid() == true) then
				messagechannel = "RAID"
			elseif (GetNumSubgroupMembers() > 0) then
				messagechannel = "PARTY"
			else
				errormessage = L["You are not in a party or raid."]
			end
		elseif (selectedchannel == "TRADE") then
			-- ToDo: Really need to add check here for availability of channel
			channelid = GetChannelName("Trade - City")
			if not (channelid) then
				errormessage = L["You are not in a city for trade."]
			else
				messagechannel = "CHANNEL"
			end
		elseif (selectedchannel == "LFG") then
			channelid = GetChannelName("LookingForGroup")
			if not (channelid) then
				errormessage = L["You do not belong to the LFG channel."]
			else
				messagechannel = "CHANNEL"
			end
		elseif (customchannel == "custom") then
			channelid = GetChannelName(selectedchannel)
			if (channelid == 0) then
				errormessage = L["You do not seem to belong this custom channel right now"]..": "..selectedchannel
			else
				messagechannel = "CHANNEL"
			end
		end
		if (errormessage) then
			DEFAULT_CHAT_FRAME:AddMessage(L["AnnounceIt Error"]..": "..errormessage, 1.0, 0.0, 0.0)
			errormessage = nil
		else
			if (messagechannel == "RAID_WARNING") then
				messagetext = self.db.profile.messages[selectedmessage].text[1]
				messagetext = AnnounceIt:ParseText(messagetext)
				SendChatMessage(messagetext, messagechannel, nil, channelid)
			else
				for index,value in pairs(self.db.profile.messages[selectedmessage].text) do
					messagetext = self.db.profile.messages[selectedmessage].text[index]
					messagetext = AnnounceIt:ParseText(messagetext)
					SendChatMessage(messagetext, messagechannel, nil, channelid)
				end
			end
			self.db.profile.lastmessage = { }
			self.db.profile.lastmessage["message"] = selectedmessage
			self.db.profile.lastmessage["chan"] = selectedchannel
			self.db.profile.lastmessage["type"] = customchannel
		end
	end
end

function AnnounceIt:ParseText(text)
	-- define vars that can change mid game
	pguild = GetGuildInfo("player")
	if not pguild then
		pguild = "Dwarfs Rule"
	end
	if (GS_Data) then
		if (GS_Data[GetRealmName()].Players[UnitName("player")].GearScore) then
			pgearscore = GS_Data[GetRealmName()].Players[UnitName("player")].GearScore
		else
			pgearscore = ""
		end
	else
		pgearscore = ""
	end
	plevel = UnitLevel("player")
	pilevel = string.format("%.2f", GetAverageItemLevel())
	if (GetSpecialization()) then
		_, pspec = GetSpecializationInfo(GetSpecialization())
	else
		pspec = "no current spec"
	end
	-- replace tags in text
	text = string.gsub(text, "%[GUILD%]", pguild)
	text = string.gsub(text, "%[LEVEL%]", plevel)
	text = string.gsub(text, "%[NAME%]", pname)
	text = string.gsub(text, "%[RACE%]", prace)
	text = string.gsub(text, "%[CLASS%]", pclass)
	text = string.gsub(text, "%[ILEVEL%]", pilevel)
	text = string.gsub(text, "%[GEARSCORE%]", pgearscore)
	text = string.gsub(text, "%[SPEC%]", pspec)

	-- release function assigned vars
	pguild = nil
	return text
end

-- save the edit box values to the addon variables
function AnnounceIt:Save()
	if (AnnounceItSetMessage_Label:GetText() == L["New Message"]) then
		StaticPopup_Show ("AISaveError")
		return
	end
	for index,value in pairs (self.db.profile.messages) do
		if (AnnounceItSetMessage_Label:GetText() == index and AnnounceItSetMessage_Label:GetText() ~= active_message_id) then
			StaticPopup_Show ("AISaveError")
			return
		end
	end
	self.db.profile.messages[active_message_id] = nil
	aimenuitems[active_message_id] = nil
	active_message_id = AnnounceItSetMessage_Label:GetText()
	self.db.profile.messages[active_message_id] = { }
	self.db.profile.messages[active_message_id].chan = {}
	self.db.profile.messages[active_message_id].custom = {}
	for index,value in pairs(aiconstants.chattypes) do
		if (_G["AnnounceItSetMessage_Chan"..index]:GetChecked()) then	
			self.db.profile.messages[active_message_id].chan[index] = true
		end
	end
	for cust=1, 4, 1 do
		customname = _G["AnnounceItSetMessage_CustomChan"..cust]:GetText()
		self.db.profile.messages[active_message_id].custom[cust] = customname
	end
	self.db.profile.messages[active_message_id].text = {}
	for i=1,aiconstants.fieldlimit,1 do
		self.db.profile.messages[active_message_id].text[i] = _G["AnnounceItSetMessage_Text"..i]:GetText()
	end 
	active_message_id = nil
	AnnounceItSetMessage:Hide()
end

-- copy message across profiles
function AnnounceIt:Copy(profileid, messageid)
	-- check to see if message title already exists in current profile
	for index,value in pairs (self.db.profile.messages) do
		if (messageid == index) then
			StaticPopup_Show ("AIDuplicateName", messageid)
			return
		end
	end

	-- save message to current profile
	self.db.profile.messages[messageid] = { }
	if (aiDB.profiles[profileid].messages[messageid].chan) then
		self.db.profile.messages[messageid].chan = {}
		for i,v in pairs(aiDB.profiles[profileid].messages[messageid].chan) do
			self.db.profile.messages[messageid].chan[i] = true
		end
	end
	if (aiDB.profiles[profileid].messages[messageid].custom) then
		self.db.profile.messages[messageid].custom = {}
		for i=1, 4, 1 do
			customname = aiDB.profiles[profileid].messages[messageid].custom[i]
			self.db.profile.messages[messageid].custom[i] = customname
		end
	end

	self.db.profile.messages[messageid].text = {}
	for i=1,aiconstants.fieldlimit,1 do
		self.db.profile.messages[messageid].text[i] = aiDB.profiles[profileid].messages[messageid].text[i]
	end
	StaticPopup_Show ("AICopyCompleted", messageid, profileid)
end

-- simple deletion of a message
function AnnounceIt:DeleteMessage(deleteid)
	self.db.profile.messages[deleteid] = nil
	aimenuitems[deleteid] = nil
	AnnounceIt:InitMenu()
end

-- simply open the Blizzard options frame to this addons options
function AnnounceIt:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory("AnnounceIt")
end

-- toggle minimap button
function AnnounceIt:togglemmb()
	if (self.db.profile.minimap.hide) then
		self.db.profile.minimap.hide = false
		icon:Show("AnnounceItButton")
	else
		self.db.profile.minimap.hide = true
		icon:Hide("AnnounceItButton")
	end
end

-- toggle minimap button
function AnnounceIt:togglequicksend()
	if (self.db.profile.quicksend.disable) then
		self.db.profile.quicksend.disable = false
	else
		self.db.profile.quicksend.disable = true
	end
end

-- thanks to oming101 for this function for links
function AnnounceIt:AddLink(index)
	local itemType, itemID, itemLink = GetCursorInfo()
	if itemType == "item" then
		_G["AnnounceItSetMessage_Text"..index]:Insert(itemLink)
	elseif itemType == "spell" then
		local spellLink = GetSpellLink(itemID,"")
		_G["AnnounceItSetMessage_Text"..index]:Insert(spellLink)
	end
	ClearCursor()
	local tradeLink = C_TradeSkillUI.GetTradeSkillListLink()
	_G["AnnounceItSetMessage_Text"..index]:Insert(tradeLink)
end

-- sorting
function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do 
		table.insert(a, n)
	end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then 
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	return iter
end

-- insert links into edit windows
function AnnounceIt:InsertHyperLink(hyperLink)
	for i = 1,5 do 
		if ( _G["AnnounceItSetMessage_Text"..i]:HasFocus() ) then
			_G["AnnounceItSetMessage_Text"..i]:Insert(hyperLink)
		end
	end
end
