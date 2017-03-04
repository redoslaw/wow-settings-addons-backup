LazyGroupFinderPopup = CreateFrame("Frame", nil, UIParent)
LazyGroupFinderPopup:SetBackdrop({bgFile = "Interface\\ENCOUNTERJOURNAL\\UI-EJ-BACKGROUND-DEFAULT",
	edgeFile = nil,
	tile = true, tileSize = 350, edgeSize = 32,
	insets = {left = 6, right = 6, top = 6, bottom = 6}}
)
LazyGroupFinderPopup:SetSize(350, 0)
LazyGroupFinderPopup:SetPoint("BOTTOM", UIParent, "CENTER", 0, 200)
LazyGroupFinderPopup:SetFrameStrata("HIGH")
LazyGroupFinderPopup:SetMovable(true)
LazyGroupFinderPopup:EnableMouse(true)
LazyGroupFinderPopup:RegisterForDrag("LeftButton")
LazyGroupFinderPopup:SetScript("OnDragStart", LazyGroupFinderPopup.StartMoving)
LazyGroupFinderPopup:SetScript("OnDragStop", LazyGroupFinderPopup.StopMovingOrSizing)
LazyGroupFinderPopup:Hide()

local frame = CreateFrame("Frame", nil, LazyGroupFinderPopup)
frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
	tile = true, tileSize = 350, edgeSize = 24,
	insets = {left = 6, right = 6, top = 6, bottom = 6}}
)
frame:SetSize(350, 1)
frame:SetPoint("TOP", LazyGroupFinderPopup, "TOP",0 , 0)

local bg2 = CreateFrame("Frame", nil, frame)
bg2:SetBackdrop({bgFile = "Interface\\COMMON\\bluemenu-goldborder-horiz",
	edgeFile = nil,
	tile = true, tileSize = 50, edgeSize = 32,
	insets = {left = 10, right = 10, top = -6, bottom = 10}}
)
bg2:SetSize(350, 50)
bg2:SetPoint("TOPLEFT", LazyGroupFinderPopup, "BOTTOMLEFT", 0, 0)

local popupID = nil
local _index = nil

local groupName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
groupName:SetPoint("TOPLEFT", LazyGroupFinderPopup, "TOPLEFT", 15, -15)
groupName:SetJustifyH("LEFT")
groupName:SetSize(340, 0)
groupName:SetText("GROUP NAME")

local instanceName = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
instanceName:SetPoint("TOPLEFT", groupName, "BOTTOMLEFT", 1, -4)
instanceName:SetJustifyH("LEFT")
instanceName:SetSize(0, 0)
instanceName:SetText("Instance NAME")

local groupComment = frame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
groupComment:SetPoint("TOPLEFT", instanceName, "BOTTOMLEFT", 0, -2)
groupComment:SetJustifyH("LEFT")
groupComment:SetSize(306, 0)
groupComment:SetText("desc")

local groupLeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
groupLeader:SetPoint("TOPLEFT", groupComment, "BOTTOMLEFT", 0, -2)
groupLeader:SetJustifyH("LEFT")
groupLeader:SetSize(0, 0)
groupLeader:SetText("leader")

local groupItemLevel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
groupItemLevel:SetPoint("TOPLEFT", groupLeader, "TOPRIGHT", 8, 0)
groupItemLevel:SetJustifyH("LEFT")
groupItemLevel:SetSize(0, 0)
groupItemLevel:SetText("")

local bossesDead = frame:CreateFontString(nil, "OVERLAY", "GameFontRed")
bossesDead:SetPoint("TOPLEFT", groupLeader, "BOTTOMLEFT", 0, -2)
bossesDead:SetJustifyH("LEFT")
bossesDead:SetSize(306, 0)
bossesDead:SetText("")

local close = CreateFrame("Button", nil, frame)
close:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
close:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
close:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
close:SetSize(32, 32)
close:SetPoint("TOPRIGHT", LazyGroupFinderPopup, "TOPRIGHT", -2, -2)
close:HookScript("OnClick", function(self)
	LazyGroupFinderPopup:Hide()
	local index = #LGFignoreGroups + 1
	LGFignoreGroups[index] = {}
	LGFignoreGroups[index].Activity = LGFcurrentActivity
	LGFignoreGroups[index].Leader = LGFcurrentLeader
	for k, v in pairs(LGFfoundGroups) do
		if LGFcurrentActivity == LGFfoundGroups[k].Activity and string.lower(LGFcurrentLeader) == string.lower(LGFfoundGroups[k].Leader) then
			table.remove(LGFfoundGroups, k)
			break
		end 
	end
	PlaySound("igMainMenuOptionCheckBoxOn")
end)

local signup = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
signup:SetSize(100, 25)
signup:SetPoint("BOTTOMRIGHT", -27, 17)
signup:SetText("Sign Up")
signup:HookScript("OnClick", function(self)
	LFGListApplicationDialog_Show(LFGListApplicationDialog, LGFcurrentID)
	LazyGroupFinderPopup:Hide()
	local index = #LGFignoreGroups + 1
	LGFignoreGroups[index] = {}
	LGFignoreGroups[index].Activity = LGFcurrentActivity
	LGFignoreGroups[index].Leader = LGFcurrentLeader
	for k, v in pairs(LGFfoundGroups) do
		if LGFcurrentActivity == LGFfoundGroups[k].Activity and string.lower(LGFcurrentLeader) == string.lower(LGFfoundGroups[k].Leader) then
			table.remove(LGFfoundGroups, k)
			break
		end 
	end
	PlaySound("igMainMenuOptionCheckBoxOn")
end)

local groupMembers = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
groupMembers:SetPoint("RIGHT", signup, "LEFT", -8, 0)
groupMembers:SetJustifyH("LEFT")
groupMembers:SetSize(0, 0)
groupMembers:SetText("")

function LazyGroupFinder_GroupPopup(groupID)
	popupID = groupID
	
	local id,activity,name,comment,_,ilvl,_,age,_,_,_,isDelisted,leader,members = C_LFGList.GetSearchResultInfo(popupID)
	LGFcurrentID = id
	LGFcurrentLeader = leader
	LGFcurrentActivity = activity
	local groupSetup = C_LFGList.GetSearchResultMemberCounts(id)
	local encounterInfo = C_LFGList.GetSearchResultEncounterInfo(id)
	local deadbosses = ""
	if encounterInfo ~= nil then
		for k, v in pairs(encounterInfo) do
			deadbosses = deadbosses .. "\n" .. v .. "  " 
		end
	end

	local activityName = C_LFGList.GetActivityInfo(activity)

	LazyGroupFinderPopup:SetBackdrop({bgFile = GetActivityBackground(activity),
		edgeFile = nil,
		tile = true, tileSize = 350, edgeSize = 32,
		insets = {left = 6, right = 6, top = 6, bottom = 6}}
	)
	
	if ilvl > 0 then 
		groupItemLevel:SetText("|cFF00FFFF" .. ilvl .. "+") 
	else
		groupItemLevel:SetText("")
	end
	
	groupName:SetText(name)
	
	instanceName:SetText(activityName)
	if comment ~= "" then groupComment:SetText("|cFFAAAAAA\"" .. comment .. "\"\n") else groupComment:SetText("") end
	groupLeader:SetText("|cFFFFFFFF" .. leader)
	groupMembers:SetText(groupSetup["TANK"] .. " \124TInterface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES:18:18:0:-1:64:64:0:18:22:40\124t  " .. groupSetup["HEALER"] .. " \124TInterface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES:18:18:0:-1:64:64:20:38:1:19\124t  " .. groupSetup["DAMAGER"] .. " \124TInterface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES:18:18:0:-1:64:64:20:38:22:40\124t  (" .. members .. ")")
	bossesDead:SetText(deadbosses)

	frame:SetSize(350, groupName:GetStringHeight() + instanceName:GetStringHeight() + groupComment:GetStringHeight() + groupLeader:GetStringHeight() + bossesDead:GetStringHeight() + 93)
	LazyGroupFinderPopup:SetSize(350, groupName:GetStringHeight() + instanceName:GetStringHeight() + groupComment:GetStringHeight() + groupLeader:GetStringHeight() + bossesDead:GetStringHeight() + 47)
	
	LazyGroupFinderPopup:Show()
end