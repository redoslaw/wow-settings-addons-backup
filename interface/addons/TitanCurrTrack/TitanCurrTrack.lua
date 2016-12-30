-- globals
TITCURRTRACK_ID =  "CurrencyTracker"
TITCURRTRACK_VERSION = GetAddOnMetadata("TitanCurrTrack", "Version") or "Unknown Verson"
TITCURRTRACK_TITLE = GetAddOnMetadata("TitanCurrTrack", "Title") or "UnKnown Title"
TITCURRTRACK_BUTTON_TEXT = "CurrencyTracker"
TITCURRTRACK_ICON = "Interface\\ICONS\\INV_Misc_Token_ArgentDawn"

if(IsAddOnLoaded("Glamour")) then
	local min_version = 1.2
	local major, minor, _ = strsplit(".", Glamour_VERSION)
	local glam_ver = tonumber(major.."."..minor)

	if (glam_ver < min_version) then
		StaticPopupDialogs["! ! ! Glamour Outdated ! ! !"] = {
			  text = "An outdated version of Glamour has been detected. Running an older version of Glamour can have undesired effects on Glamour enabled addons.\n\n"..
		  		"Reporting Addon:\n"..TITCURRTRACK_TITLE.." v"..TITCURRTRACK_VERSION.."\n\n"..
				"Glamour Version Detected: "..Glamour_VERSION.."\nGlamour Version Required: "..min_version.."\n\n",
			  button1 = "Ok",
			  timeout = 0,
			  whileDead = true,
			  hideOnEscape = true,
		}
		StaticPopup_Show ("! ! ! Glamour Outdated ! ! !")
	end
end

-- labels
local TITCURRTRACK_SHOW_ANNOUNCE = "Show Raid Warning Announcement"
local TITCURRTRACK_SHOW_LOG = "Show Announcement in Log"
local TITCURRTRACK_SHOW_Glamour = "Show Glamour Announcement"
local TITCURRTRACK_SHORT_Glamour = "Use Lesser Glamour Announcement"
local TITCURRTRACK_SHOW_SUMMARY = "Show Session Summary in Tooltip"
local TITCURRTRACK_SHOW_CHANGED = "Color Changed Tokens"
local TITCURRTRACK_APPEND_CHANGED = "Append Session Gains"
local TITCURRTRACK_SHOW_ALT_SUMMARY = "Show Alt Charaters in Tooltip"
local TITCURRTRACK_SHOW_ALT_SUMMARY_SPACE = "Use Extra Space in Tooltip"
local TITCURRTRACK_SHOW_CAP = "Show the Currency Cap in Tooltip."
local TITCURRTRACK_SHOW_CAPALERT = "Alert when the cap is reached."
local TITCURRTRACK_SHOW_CAPWARN75 = "Warn when over 80% of cap."
local TITCURRTRACK_SHOW_CAPWARN90 = "Warn when over 90% of cap."
local _ = ""

TITCURRTRACK_TokenIDs = {
		["pvecurrency-valor"] = 396,
		["PVPCurrency-Honor-Horde"] = 392,
		["PVPCurrency-Honor-Alliance"] = 392,
		["pvecurrency-justice"] = 395,
		["PVPCurrency-Conquest-Horde"] = 390,
		["PVPCurrency-Conquest-Alliance"] = 390,
	}

if(not TitanCurrTrackData) then
	TitanCurrTrackData = {}
end

local TitanCurrTrack_cname, TitanCurrTrack_crealm = UnitName("player")
if(not crealm) then
	TitanCurrTrack_crealm = GetRealmName()
end

-- local
local TITCURRTRACK_TOOLTIP_TEXT = ""
local TITCURRTRACK_TTS = {}
local TITCURRTRACK_TIME = GetTime()
local TITCURRTRACK_VALUES = {}
local TITCURRTRACK_VSIZE = 0
local TITCURRTRACK_CAP = 4000


-- initializing
function TitanPanelCurrencyTrackerButton_OnLoad(self)
	self.registry = {
		id = TITCURRTRACK_ID,
		menuText = TITCURRTRACK_ID, 
		version = TITCURRTRACK_VERSION,
		buttonTextFunction = "TitanPanelCurrencyTracker_GetButtonText", 
		tooltipCustomFunction = TitanPanelCurrencyTracker_localGetToolTipText, 		
		category = "Information",
		savedVariables = {
			ShowAnnounce = false, 
			ShowGlamourAnnounce = 1, 
			ShortGlamourAnnounce = false, 
			ShowChanged = 1,
			AppendChanged = 1,
			ShowLog = false,
			ShowSummary = 1,
			ShowAltSummary = 1,
			ShowAltSummarySpace = false,
			ShowCAP = 1,
			ShowCAP_Alert = 1,
			ShowCAP_Warn75 = 1,
			ShowCAP_Warn90 = 1,
			IconSize = 16,
			TipIconSize = 12,
			BarIconSize = 20,
			TokenHeaders = { "" }
		}
	}	
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
end

-- event handling
function TitanPanelCurrencyTrackerButton_OnClick(self, button)
     if (button == "LeftButton") then
	     ToggleCharacter("TokenFrame")
     end
     if (button == "RightButton") then
	     TitanPanelRightClickMenu_PrepareCurrencyTrackerMenu(self)
     end
end

function TitanPanelCurrencyTrackerButton_OnEvent(self, event, ...)	
	TitanPanelButton_UpdateTooltip()
	TitanPanelButton_UpdateButton(TITCURRTRACK_ID)
end

-- for titan to get the displayed text
function TitanPanelCurrencyTracker_GetButtonText(id)
	TitanPanelCurrencyTracker_Refresh()
	return TITCURRTRACK_BUTTON_TEXT
end

function pairsByKeys(t, f)
	local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
	return iter
end


function TitanCurrTrack_AddTooltipText(text)
	if ( text ) then
		-- Append a "\n" to the end 
		if ( string.sub(text, -1, -1) ~= "\n" ) then
			text = text.."\n"
		end
		
		-- See if the string is intended for a double column
		for text1, text2 in string.gmatch(text, "([^\t\n]*)\t?([^\t\n]*)\n") do
			if ( text2 ~= "" ) then
				-- Add as double wide
				GameTooltip:AddDoubleLine(text1, text2)
			elseif ( text1 ~= "" ) then
				-- Add single column line
				GameTooltip:AddLine(text1)
			else
				-- Assume a blank line
				GameTooltip:AddLine("\n")
			end			
		end
	end
end


-- for titan tool tip text building
function TitanPanelCurrencyTracker_localGetToolTipText(self)
	local tleft = "|T"..TITCURRTRACK_ICON..":24|t "..TITCURRTRACK_TITLE
	local tright = "v"..TITCURRTRACK_VERSION.." |T"..TITCURRTRACK_ICON..":24|t"
	GameTooltip:AddDoubleLine(tleft, tright, 
		HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 
		HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)	
	TitanCurrTrack_AddTooltipText(TitanPanelCurrencyTracker_GetToolTipText())
	GameTooltip:Show()
end



function TitanPanelCurrencyTracker_GetToolTipText()
	local display=""
	local tooltip=""

	if(TitanGetVar(TITCURRTRACK_ID, "ShowCAP") == 1) then
		tooltip=TitanUtils_GetHighlightText("Currency Cap").."\t"..TitanUtils_GetHighlightText(TITCURRTRACK_CAP).."\n\n"
	else
		tooltip="\n"
	end

	cCount = GetCurrencyListSize()
	for index=1, cCount do 

		-- I can't for the life of me figout out WHY THE FUCK would blizzard not include the itemID here, when ALL other currency functions depend on it.
		local name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, unknown  = GetCurrencyListInfo(index)

		if icon then
			icon2 = gsub(icon,"Interface\\Icons\\","") 
		else
			icon2 = nil
		end

		if (isHeader) then
			tooltip = tooltip..TitanUtils_GetHighlightText(name)..":\n"
		else
			if not maximum then 
				maximum = "" 
			end
			
			-- Extra Checks cuz blizzard is retarded and doesn't know how to follow a standard which forces extra work arounds and hard-coding limits
			-- Using Icon as an Identifier as to not break non-english clients
			if icon2 == "PVPCurrency-Honor-Horde" or
				icon2 == "PVPCurrency-Conquest-Horde" or
				icon2 == "PVPCurrency-Honor-Alliance" or
				icon2 == "PVPCurrency-Conquest-Alliance" then
				maximum = 4000
			end

			-- Adding these now for when blizzard decides to bring these currencies back and tout it as something "new and improved", limit will prob change too just to fuck with me.
			if icon2 == "pvecurrency-justice" or
				icon2 == "pvecurrency-valor" then 
				maximum = 3000
			end

			TITCURRTRACK_CAP = maximum

			if (count~=0 and maximum) then
				if(TitanGetVar(TITCURRTRACK_ID, "ShowAltSummarySpace") == 1 and index < cCount) then
					tooltip = tooltip.."\n"
				end
				
				local tcount = "x"..count
				if TITCURRTRACK_CAP == 0 then
					tcount=strconcat("  [ ",tcount," ]")
					tcount=TitanUtils_GetColoredText(tcount,{r=0.25,g=0.75,b=0.25})
				else
					tcount=strconcat("  [ ",tcount," / ",TITCURRTRACK_CAP," ]")
					if(count >= TITCURRTRACK_CAP) then
						if(TitanGetVar(TITCURRTRACK_ID, "ShowCAP_Alert") == 1) then
							GameTooltip:AddDoubleLine("!!CAP ALERT!!", strupper(name), 1, 0 ,0 , 1, 0, 0)
							name = TitanUtils_GetRedText(strupper(name))
							tcount = TitanUtils_GetRedText(tcount)
						end
					elseif(count >= TITCURRTRACK_CAP * .90) then
						if(TitanGetVar(TITCURRTRACK_ID, "ShowCAP_Warn90") == 1) then
							GameTooltip:AddDoubleLine("!!90% Cap Warning!!", name, 1, .25 , .25, 1, .25, .25)
							name = TitanUtils_GetColoredText(strupper(name),{r=1,g=.25,b=.25})
							tcount= TitanUtils_GetColoredText(tcount,{r=1,g=.25,b=.25})
						end
					elseif(count >= TITCURRTRACK_CAP * .75) then
						if(TitanGetVar(TITCURRTRACK_ID, "ShowCAP_Warn75") == 1) then
							GameTooltip:AddDoubleLine("!!75% Cap Warning!!", name, 1, .49 , .04, 1, .49, .04)
							name = TitanUtils_GetColoredText(strupper(name),{r=1,g=0.49,b=0.04})
							tcount= TitanUtils_GetColoredText(tcount,{r=1,g=0.49,b=0.04})
						end
					else	
						tcount=TitanUtils_GetColoredText(tcount,{r=0.2,g=0.6,b=0.2})
					end
				end
				display=strconcat("   |T",icon,":" , TitanGetVar(TITCURRTRACK_ID, "TipIconSize"),"|t ",name,tcount)
				tooltip=strconcat(tooltip,display,"|r\n")
			end
		end
	end 

	if(TitanGetVar(TITCURRTRACK_ID, "ShowAltSummary") == 1) then
		if(TitanCurrTrackData) then
			tooltip = tooltip.."\n"..TitanUtils_GetHighlightText("Alternate Character Tokens:")
			for crn, cicon in pairsByKeys(TitanCurrTrackData) do
				if(TitanCurrTrack_crealm.."-"..TitanCurrTrack_cname ~= crn and cicon ~= "") then
					local crealm, cname = strsplit("-",crn)
					cicon, _ = gsub(cicon,":20|t",":" .. TitanGetVar(TITCURRTRACK_ID, "TipIconSize") .. "|t")
					cicon, _ = gsub(cicon,":SIZE|t",":" .. TitanGetVar(TITCURRTRACK_ID, "TipIconSize") .. "|t")
					if(crealm ~= TitanCurrTrack_crealm) then
						tooltip = tooltip.."\n"..crn.."\t"..cicon
					else
						tooltip = tooltip.."\n"..cname.."\t"..cicon
					end
					if(TitanGetVar(TITCURRTRACK_ID, "ShowAltSummarySpace") == 1) then
						tooltip = tooltip.."\n"
					end
				end
			end
		end
		if(not TitanGetVar(TITCURRTRACK_ID, "ShowAltSummarySpace")) then
			tooltip = tooltip.."\n"
		end
	end
	if(TitanGetVar(TITCURRTRACK_ID, "ShowSummary") == 1) then
		local timeonline =  GetTime() -	TITCURRTRACK_TIME
		local humantime = ""

		if (timeonline < 60) then
			humantime = "< 1 Mn"
		else 
			humantime = floor(timeonline / 60)
			if(humantime < 60) then
				humantime = humantime.." Mn"
			else
				local hours = floor(humantime / 60)
				local mins = floor((timeonline - (hours * 60 * 60)) / 60)
				humantime = hours.." Hr "..mins.." Mn"
			end
		end
		tooltip = tooltip.."\n"..TitanUtils_GetHighlightText("Session Summary:")
		tooltip = tooltip.."\t"..TitanUtils_GetNormalText("Duration: "..humantime)

		for f, v in pairs(TITCURRTRACK_TTS) do
			local TPH = floor(v / (timeonline / 60 / 60))
			if(TPH > 0) then
				tooltip = tooltip.."\n "..f.." : "..TitanUtils_GetGreenText(TPH).." perHour\t Total: "..TitanUtils_GetGreenText(v)
			else
				tooltip = tooltip.."\n "..f.." : "..TitanUtils_GetRedText(TPH).." perHour\t Total: "..TitanUtils_GetRedText(v)
			end
		end
	end
	
	final_tooltip=tooltip
	return ""..final_tooltip    	
end

function TitanPanelRightClickMenu_AddTitle2(title, level)
	if (title) then
		local info = {}
		info.text = title
		info.notClickable = 1
		info.isTitle = 1
       		info.notCheckable = true
		UIDropDownMenu_AddButton(info, level)
	end
end


function TitanPanelRightClickMenu_AddToggleVar2(text, id, var, toggleTable)
	local info = {}
	info.text = text
	info.value = {id, var, toggleTable}
	info.func = function()
		TitanPanelRightClickMenu_ToggleVar({id, var, toggleTable})
	end
	info.checked = TitanGetVar(id, var)
	info.keepShownOnClick = 1
	UIDropDownMenu_AddButton(info, 2)
end

function TitanPanelRightClickMenu_AddToggleIcon2(id)
	TitanPanelRightClickMenu_AddToggleVar2("Show Icon", id, "ShowIcon")
end

function TitanPanelRightClickMenu_AddSpacer2(level)
	local info = {}
	info.disabled = 1
       	info.notCheckable = true
	UIDropDownMenu_AddButton(info, level)
end


-- this method builds the right-click menus
function TitanPanelRightClickMenu_PrepareCurrencyTrackerMenu()
	-- level 2 menus
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		TitanPanelRightClickMenu_AddTitle2(UIDROPDOWNMENU_MENU_VALUE, UIDROPDOWNMENU_MENU_LEVEL)
		TitanPanelCurrencyTracker_GatherTokens(TitanPanelCurrencyTracker_BuildTokenSubMenu)
		if UIDROPDOWNMENU_MENU_VALUE == "Options" then
			if(IsAddOnLoaded("Glamour")) then
				TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_Glamour, TITCURRTRACK_ID, "ShowGlamourAnnounce")	
				TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHORT_Glamour, TITCURRTRACK_ID, "ShortGlamourAnnounce")	
			end
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_ANNOUNCE, TITCURRTRACK_ID, "ShowAnnounce")	
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_LOG, TITCURRTRACK_ID, "ShowLog")	
			TitanPanelRightClickMenu_AddSpacer2(2)
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_CHANGED, TITCURRTRACK_ID, "ShowChanged")	
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_APPEND_CHANGED, TITCURRTRACK_ID, "AppendChanged")	
			TitanPanelRightClickMenu_AddSpacer2(2)
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_ALT_SUMMARY, TITCURRTRACK_ID, "ShowAltSummary")	
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_ALT_SUMMARY_SPACE, TITCURRTRACK_ID, "ShowAltSummarySpace")	
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_SUMMARY, TITCURRTRACK_ID, "ShowSummary")	
			TitanPanelRightClickMenu_AddSpacer2(2)
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_CAP, TITCURRTRACK_ID, "ShowCAP")	
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_CAPALERT, TITCURRTRACK_ID, "ShowCAP_Alert")	
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_CAPWARN90, TITCURRTRACK_ID, "ShowCAP_Warn90")	
			TitanPanelRightClickMenu_AddToggleVar2(TITCURRTRACK_SHOW_CAPWARN75, TITCURRTRACK_ID, "ShowCAP_Warn75")	
			TitanPanelRightClickMenu_AddSpacer2(2)
			local command = {}
			command.text = "Reset All Character Data"
			command.value = "Reset All Character Data"
			command.hasArrow = false
			command.notCheckable = true
			command.func = function() 
				wipe(TitanCurrTrackData)
				print("CurrencyTracker Character Data Reset!")
			end
			UIDropDownMenu_AddButton(command,2)
		end
		return
	end
	-- level 1 menu
	TitanPanelRightClickMenu_AddTitle2(TitanPlugins[TITCURRTRACK_ID].menuText.." v"..TITCURRTRACK_VERSION)
	TitanPanelRightClickMenu_AddSpacer2()
	TitanPanelCurrencyTracker_GatherTokens(TitanPanelCurrencyTracker_BuildRightClickMenu)
	TitanPanelRightClickMenu_AddSpacer2()
	local info = {}
       	info.hasArrow = true 
       	info.notCheckable = true
       	info.text = "Options"
       	info.value = "Options"
	UIDropDownMenu_AddButton(info, 1)			
	TitanPanelRightClickMenu_AddSpacer2()
	info.text = "Close Menu"
	info.value = "Close Menu"
	info.hasArrow = false
	UIDropDownMenu_AddButton(info, 1)

end

function TitanCurrTrackHeaderTokenToggle(name)
	local value = ""
	local found = false
	local array = TitanGetVar(TITCURRTRACK_ID, "TokenHeaders")
	for index, value in ipairs(array) do
		if (value == name) then
			found = index
		end
	end
	if(found) then 
		tremove(array,found)		
	else
		tinsert(array,name)		
	end
	TitanSetVar(TITCURRTRACK_ID, "TokenHeaders", array)
	return
end

function TitanPanelCurrencyTracker_BuildRightClickMenu(name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, itemID, parentName)
	if(not isInactive) then
		if(isHeader and not isCollapsed) then
			command = {}
			command.text = name
			command.value = name
			command.hasArrow = 1
			command.keepShownOnClick = 1
			command.checked = function() if (tContains(TitanGetVar(TITCURRTRACK_ID, "TokenHeaders"), name)) then return nil else return true end end
			command.func = function() 
				TitanCurrTrackHeaderTokenToggle(name) 
				TitanPanelButton_UpdateButton(TITCURRTRACK_ID)
			end
			UIDropDownMenu_AddButton(command)
		end
	end
end

function TitanPanelCurrencyTracker_BuildTokenSubMenu(name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, itemID, parentName)
	if(parentName == UIDROPDOWNMENU_MENU_VALUE and (not isHeader)) then
		command = {}
		command.text = " |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "TipIconSize") .. "|t "..name.." ("..count..")"
		command.value = name
		command.checked = function() if (tContains(TitanGetVar(TITCURRTRACK_ID, "TokenHeaders"), name)) then return nil else return true end end
		command.func = function() 
			TitanCurrTrackHeaderTokenToggle(name) 
			TitanPanelButton_UpdateButton(TITCURRTRACK_ID)
		end
		UIDropDownMenu_AddButton(command, UIDROPDOWNMENU_MENU_LEVEL)
	end
end

function TitanPanelCurrencyTracker_Refresh()
	local parentName = ""
	local changed = ""
	local all = ""
	local CharData = ""
	local name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, itemID, cCount
	cCount = GetCurrencyListSize()
	for index=1, cCount do 
		name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, itemID = GetCurrencyListInfo(index)
		if (isHeader) then
			parentName = name
		else
			local icon2, tid, weeklyMax, _
			local earnedThisWeek = ""
			if icon then
				icon2 = gsub(icon,"Interface\\Icons\\","") 
			else
				icon2 = nil
			end
			if TITCURRTRACK_TokenIDs[icon2] then      
				tid = TITCURRTRACK_TokenIDs[icon2]
      				if tid == 396 or tid == 390 then
         				_, _, _, earnedThisWeek, weeklyMax, _, _ = GetCurrencyInfo(tid)
					if earnedThisWeek == 0 then
						earnedThisWeek = ""
					elseif earnedThisWeek == (weeklyMax / 100) then
						earnedThisWeek = TitanUtils_GetColoredText("*",{r=0,g=1,b=0})
					else
						earnedThisWeek = "/"..TitanUtils_GetColoredText(earnedThisWeek,{r=1,g=1,b=0})
					end
      				end      
			end

			if(not TITCURRTRACK_VALUES[name]) then
				TITCURRTRACK_VALUES[name] = count
			end
			if (not tContains(TitanGetVar(TITCURRTRACK_ID, "TokenHeaders"), parentName) and
				not tContains(TitanGetVar(TITCURRTRACK_ID, "TokenHeaders"), name)) then 
				local append = ""
				if(TITCURRTRACK_VALUES[name] ~= count) then
					local diff = count - TITCURRTRACK_VALUES[name]
					if(TITCURRTRACK_TTS[name]) then
						TITCURRTRACK_TTS[name] = TITCURRTRACK_TTS[name] + diff
					else
						TITCURRTRACK_TTS[name] = diff
					end
					local msg = ""
					local points , _ = gsub(diff,"-","")
					if (diff > 0) then
						points = TitanUtils_GetGreenText(points)
						changed = TitanUtils_GetGreenText("(+"..diff..")")
						msg = "|T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "IconSize") .. "|t "..name.." "..changed.." (Total: "..TitanUtils_GetGreenText(count)..")"
					else
						points = TitanUtils_GetRedText(points)
						changed = TitanUtils_GetRedText("("..diff..")")
						msg = "|T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "IconSize") .. "|t "..name.." "..changed.." (Total: "..TitanUtils_GetRedText(count)..")"
					end
					if name == "Honor Points" and diff < 10 then
						HonorThrottle = true
					else
						HonorThrottle = false
					end
					if(TitanGetVar(TITCURRTRACK_ID, "ShowGlamourAnnounce")) and not HonorThrottle then
						if(IsAddOnLoaded("Glamour")) then
							local MyData = { }
							MyData.Text = name..changed
	 						MyData.Icon = icon
							local green = {r=0,g=1,b=0}
							local red = {r=1,g=0,b=0}
							local size = 1
							if (strlen(name..changed) > 20) then
								size = 300 + (strlen(name..changed) * 2)
							end
							local color
							if (diff >= 0) then
	 							MyData.Title = "Token Earned"
								color = green
							else
	 							MyData.Title = "Token Lost"
								color = red
							end
							if(TitanGetVar(TITCURRTRACK_ID, "ShortGlamourAnnounce")) then
								MyData.ShieldHide = true
								MyData.ShieldText = changed
								MyData.FrameStyle = "GuildAchievement"
								MyData.bTitle = count
								MyData.Text = ""
	 							MyData.Title = ""
								MyData.HideShine = true
								size = 140
							else
								MyData.ShieldText = count
							end
							MyData.BannerColor = color
							GlamourShowAlert(size, MyData, color, color)
							AlertFrame_FixAnchors()
						end
					end
					TITCURRTRACK_VALUES[name] = count
					if(TitanGetVar(TITCURRTRACK_ID, "AppendChanged") == 1) then
						if(TITCURRTRACK_TTS[name]) then
							if(TITCURRTRACK_TTS[name] > 0) then
								append = TitanUtils_GetGreenText("(+"..TITCURRTRACK_TTS[name]..")")
							elseif(TITCURRTRACK_TTS[name] < 0) then 
								append = TitanUtils_GetRedText("("..TITCURRTRACK_TTS[name]..")")
							end
						end
					end
					if(TitanGetVar(TITCURRTRACK_ID, "ShowChanged") == 1) then
						if(TITCURRTRACK_TTS[name]) then
							if(TITCURRTRACK_TTS[name] >= 0) then
								all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..TitanUtils_GetGreenText(count)..earnedThisWeek..append.." "
							elseif(TITCURRTRACK_TTS[name] < 0) then
								all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..TitanUtils_GetRedText(count)..earnedThisWeek..append.." "
							else
								all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..count..earnedThisWeek..append.." "
							end
						else
							all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..count..earnedThisWeek..append.." "
						end
					else 
						all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..count..earnedThisWeek..append.." "
					end
					if(TitanGetVar(TITCURRTRACK_ID, "ShowAnnounce")) then
						UIErrorsFrame:AddMessage(msg, 2.0, 2.0, 0.0, 53, 5)
					end
					if(TitanGetVar(TITCURRTRACK_ID, "ShowLog")) then
						print(msg)
					end
				else
					if(TitanGetVar(TITCURRTRACK_ID, "AppendChanged") == 1) then
						if(TITCURRTRACK_TTS[name]) then
							if(TITCURRTRACK_TTS[name] > 0) then
								append = TitanUtils_GetGreenText("(+"..TITCURRTRACK_TTS[name]..")")
							elseif(TITCURRTRACK_TTS[name] < 0) then
								append = TitanUtils_GetRedText("("..TITCURRTRACK_TTS[name]..")")
							end
						end
					end
					if(TitanGetVar(TITCURRTRACK_ID, "ShowChanged") == 1) then
						if(TITCURRTRACK_TTS[name]) then
							if(TITCURRTRACK_TTS[name] > 0) then
								all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..TitanUtils_GetGreenText(count)..earnedThisWeek..append.." "
							elseif(TITCURRTRACK_TTS[name] < 0) then
								all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..TitanUtils_GetRedText(count)..earnedThisWeek..append.." "
							else
								all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..count..earnedThisWeek..append.." "
							end
						else
							all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..count..earnedThisWeek..append.." "
						end
					else
						all = all.." |T"..icon..":" .. TitanGetVar(TITCURRTRACK_ID, "BarIconSize") .. "|t"..count..earnedThisWeek..append.." "
					end
				end
			end
			if(count) then
				if(count > 0) then
					CharData = CharData.." |T"..icon..":SIZE|t"..count..earnedThisWeek.." "
				end
			end
		end
	end
	if(all == "") then
		all = "CurrencyTracker"
	end
	TitanCurrTrackData[TitanCurrTrack_crealm.."-"..TitanCurrTrack_cname] = CharData
	TITCURRTRACK_BUTTON_TEXT = all
end

function TitanPanelCurrencyTracker_GatherTokens(method)
		local cCount = GetCurrencyListSize()
		local done = false
		local index = 1
		local parentName = ""
		while(not done)do
			local name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, itemID = GetCurrencyListInfo(index)
			local value
			-- Normalize values
			if(isHeader) then parentName = name end
			method(name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, itemID, parentName )
			index = index+1
			if(index>cCount) then done = true end
		end		
end
