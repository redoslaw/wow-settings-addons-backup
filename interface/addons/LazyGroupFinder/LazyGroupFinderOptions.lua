LazyGroupFinderOptions = CreateFrame("Frame", "LazyGroupFinderOptions", InterefaceOptionsFramePanelContainer)
LazyGroupFinderOptions.name = "Lazy Group Finder"
LazyGroupFinderOptions:Hide()

local categoryStates = {"Questing", "Dungeons", "Raids"}
local activityStates = {}
local selectedNrOfActivities = 0

-- ADDON NAME
local addonNameText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
addonNameText:SetPoint("TOPLEFT", 32, -32)
addonNameText:SetText("Lazy Group Finder")

local addonAuthor = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontDisable")
addonAuthor:SetPoint("RIGHT", LazyGroupFinderOptions, "BOTTOMRIGHT", -32, 32)
addonAuthor:SetText("created by Luuci-Frostmane EU")

-- ACTIVITIES
local activityText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
activityText:SetPoint("TOPLEFT", 282, -55)
activityText:SetText("Activity:")

local activityStateMenu = CreateFrame("Button", "LazyGroupFinderActivityStateMenu", LazyGroupFinderOptions, "UIDropDownMenuTemplate")
activityStateMenu:SetPoint("TOPLEFT", activityText, "BOTTOMLEFT", 0, -5)
local function Initialize_ActivityStateMenu(self, level)
	local info = UIDropDownMenu_CreateInfo()
	selectedNrOfActivities = 0
	for k,v in pairs(activityStates) do
		local activityName,_,activityType,_,_,_,_,_,_,_ = C_LFGList.GetActivityInfo(k)
		info = UIDropDownMenu_CreateInfo()
		info.text = activityName
		info.value = k
		info.checked = v
		info.func = activityState_OnClick
		info.isNotRadio = true
		info.keepShownOnClick = true
		UIDropDownMenu_AddButton(info, level)
		if v then selectedNrOfActivities = selectedNrOfActivities + 1 end
	end
	UIDropDownMenu_SetText(activityStateMenu, "Filter (" .. selectedNrOfActivities .. ")")
end

function activityState_OnClick(self)
	LazyGroupFinderActivities[self.value] = not LazyGroupFinderActivities[self.value]
	activityStates[self.value] = LazyGroupFinderActivities[self.value]
	if activityStates[self.value] then selectedNrOfActivities = selectedNrOfActivities + 1 end
	if not activityStates[self.value] then selectedNrOfActivities = selectedNrOfActivities - 1 end
	UIDropDownMenu_SetText(activityStateMenu, "Filter (" .. selectedNrOfActivities .. ")")
end

UIDropDownMenu_SetWidth(activityStateMenu, 130)
UIDropDownMenu_SetButtonWidth(activityStateMenu, 130)
UIDropDownMenu_JustifyText(activityStateMenu, "CENTER")
UIDropDownMenu_Initialize(activityStateMenu, Initialize_ActivityStateMenu)

-- CATEGORY
local categoryText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
categoryText:SetPoint("TOPLEFT", 42, -55)
categoryText:SetText("Category:")

local categoryStateMenu = CreateFrame("Button", "LazyGroupFinderCategoryStateMenu", LazyGroupFinderOptions, "UIDropDownMenuTemplate")
categoryStateMenu:SetPoint("TOPLEFT", categoryText, "BOTTOMLEFT", 0, -5)
local function Initialize_CategoryStateMenu(self, level)
	local info = UIDropDownMenu_CreateInfo()
	for k,v in pairs(categoryStates) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = k
		info.func = categoryState_OnClick
		UIDropDownMenu_AddButton(info, level)
	end
end

function categoryState_OnClick(self)
	UIDropDownMenu_SetSelectedID(categoryStateMenu, self:GetID())
	LazyGroupFinderActivityType = self.value
	activityStates = {}
	local results = C_LFGList.GetAvailableActivities(LazyGroupFinderActivityType, nil, 1)
	for k,v in pairs(results) do
		if LazyGroupFinderActivities[v] == nil then LazyGroupFinderActivities[v] = false end
		activityStates[v] = LazyGroupFinderActivities[v]
	end
	Initialize_ActivityStateMenu()
end

UIDropDownMenu_SetWidth(categoryStateMenu, 130)
UIDropDownMenu_SetButtonWidth(categoryStateMenu, 130)
UIDropDownMenu_JustifyText(categoryStateMenu, "CENTER")
UIDropDownMenu_Initialize(categoryStateMenu, Initialize_CategoryStateMenu)

-- KEYWORDS
local keywordsText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
keywordsText:SetPoint("TOPLEFT", 42, -115)
keywordsText:SetText("Filter keywords:")

local keywordsDESCText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontDisable")
keywordsDESCText:SetPoint("LEFT", keywordsText, "RIGHT", 20, 0)
keywordsDESCText:SetText("for Name, Description or Leader (one must match)")

local keywordsEditBox = CreateFrame("EditBox", "LazyGroupFinderKeywordsEditBox", LazyGroupFinderOptions, "InputBoxTemplate")
keywordsEditBox:SetPoint("TOPLEFT", keywordsText, "BOTTOMLEFT", 20, -5)
keywordsEditBox:SetAutoFocus(false)
keywordsEditBox:SetSize(300, 25)
keywordsEditBox:SetText("")
keywordsEditBox:SetScript("OnTextChanged", function(self)
	LazyGroupFinderKeywords = keywordsEditBox:GetText()
end)

-- IGNORE WORDS
local bannedwordsText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
bannedwordsText:SetPoint("TOPLEFT", 42, -165)
bannedwordsText:SetText("Banned keywords:")

local bannedwordsDESCText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontDisable")
bannedwordsDESCText:SetPoint("LEFT", bannedwordsText, "RIGHT", 20, 0)
bannedwordsDESCText:SetText("for Name, Description or Leader (none can match)")

local bannedwordsEditBox = CreateFrame("EditBox", "LazyGroupFinderBannedwordsEditBox", LazyGroupFinderOptions, "InputBoxTemplate")
bannedwordsEditBox:SetPoint("TOPLEFT", bannedwordsText, "BOTTOMLEFT", 20, -5)
bannedwordsEditBox:SetAutoFocus(false)
bannedwordsEditBox:SetSize(300, 25)
bannedwordsEditBox:SetText("")
bannedwordsEditBox:SetScript("OnTextChanged", function(self)
	LazyGroupFinderBannedwords = bannedwordsEditBox:GetText()
end)

-- GROUP SETUP WORDS
local groupsetupText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
groupsetupText:SetPoint("TOPLEFT", 42, -215)
groupsetupText:SetText("Group setup:")

local groupsetupDESCText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontDisable")
groupsetupDESCText:SetPoint("LEFT", groupsetupText, "RIGHT", 20, 0)
groupsetupDESCText:SetText("(min - max) leave empty for no restriction")

local icontankText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
icontankText:SetPoint("TOPLEFT", groupsetupText, "BOTTOMLEFT", 20, -9)
icontankText:SetText("\124TInterface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES:18:18:0:-1:64:64:0:18:22:40\124t        -        ")

local mintankEditBox = CreateFrame("EditBox", nil, LazyGroupFinderOptions, "InputBoxTemplate")
mintankEditBox:SetPoint("TOPLEFT", groupsetupText, "BOTTOMLEFT", 45, -5)
mintankEditBox:SetAutoFocus(false)
mintankEditBox:SetSize(20, 25)
mintankEditBox:SetText("")
mintankEditBox:SetMaxLetters(2)
mintankEditBox:SetScript("OnTextChanged", function(self)
	if self:GetText() == "" then LazyGroupFinderMinTank = ""
	elseif tonumber(self:GetText()) ~= nil then LazyGroupFinderMinTank = self:GetText()
	else self:SetText("") end
end)

local maxtankEditBox = CreateFrame("EditBox", nil, LazyGroupFinderOptions, "InputBoxTemplate")
maxtankEditBox:SetPoint("TOPLEFT", groupsetupText, "BOTTOMLEFT", 85, -5)
maxtankEditBox:SetAutoFocus(false)
maxtankEditBox:SetSize(20, 25)
maxtankEditBox:SetText("")
maxtankEditBox:SetMaxLetters(2)
maxtankEditBox:SetScript("OnTextChanged", function(self)
	if self:GetText() == "" then LazyGroupFinderMaxTank = ""
	elseif tonumber(self:GetText()) ~= nil then LazyGroupFinderMaxTank = self:GetText()
	else self:SetText("") end
end)

local iconhealText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
iconhealText:SetPoint("TOPLEFT", groupsetupText, "BOTTOMLEFT", 125, -9)
iconhealText:SetText("\124TInterface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES:18:18:0:-1:64:64:20:38:1:19\124t        -        ")

local minhealEditBox = CreateFrame("EditBox", nil, LazyGroupFinderOptions, "InputBoxTemplate")
minhealEditBox:SetPoint("TOPLEFT", groupsetupText, "BOTTOMLEFT", 150, -5)
minhealEditBox:SetAutoFocus(false)
minhealEditBox:SetSize(20, 25)
minhealEditBox:SetText("")
minhealEditBox:SetMaxLetters(2)
minhealEditBox:SetScript("OnTextChanged", function(self)
	if self:GetText() == "" then LazyGroupFinderMinHeal = ""
	elseif tonumber(self:GetText()) ~= nil then LazyGroupFinderMinHeal = self:GetText()
	else self:SetText("") end
end)

local maxhealEditBox = CreateFrame("EditBox", nil, LazyGroupFinderOptions, "InputBoxTemplate")
maxhealEditBox:SetPoint("TOPLEFT", groupsetupText, "BOTTOMLEFT", 190, -5)
maxhealEditBox:SetAutoFocus(false)
maxhealEditBox:SetSize(20, 25)
maxhealEditBox:SetText("")
maxhealEditBox:SetMaxLetters(2)
maxhealEditBox:SetScript("OnTextChanged", function(self)
	if self:GetText() == "" then LazyGroupFinderMaxHeal = ""
	elseif tonumber(self:GetText()) ~= nil then LazyGroupFinderMaxHeal = self:GetText()
	else self:SetText("") end
end)

local icondpsText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
icondpsText:SetPoint("TOPLEFT", groupsetupText, "BOTTOMLEFT", 230, -9)
icondpsText:SetText("\124TInterface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES:18:18:0:-1:64:64:20:38:22:40\124t        -        ")

local mindpsEditBox = CreateFrame("EditBox", nil, LazyGroupFinderOptions, "InputBoxTemplate")
mindpsEditBox:SetPoint("TOPLEFT", groupsetupText, "BOTTOMLEFT", 255, -5)
mindpsEditBox:SetAutoFocus(false)
mindpsEditBox:SetSize(20, 25)
mindpsEditBox:SetText("")
mindpsEditBox:SetMaxLetters(2)
mindpsEditBox:SetScript("OnTextChanged", function(self)
	if self:GetText() == "" then LazyGroupFinderMinDps = ""
	elseif tonumber(self:GetText()) ~= nil then LazyGroupFinderMinDps = self:GetText()
	else self:SetText("") end
end)

local maxdpsEditBox = CreateFrame("EditBox", nil, LazyGroupFinderOptions, "InputBoxTemplate")
maxdpsEditBox:SetPoint("TOPLEFT", groupsetupText, "BOTTOMLEFT", 295, -5)
maxdpsEditBox:SetAutoFocus(false)
maxdpsEditBox:SetSize(20, 25)
maxdpsEditBox:SetText("")
maxdpsEditBox:SetMaxLetters(2)
maxdpsEditBox:SetScript("OnTextChanged", function(self)
	if self:GetText() == "" then LazyGroupFinderMaxDps = ""
	elseif tonumber(self:GetText()) ~= nil then LazyGroupFinderMaxDps = self:GetText()
	else self:SetText("") end
end)

-- ADDON SETTINGS NAME
local bonusNameText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
bonusNameText:SetPoint("TOPLEFT", 32, -282)
bonusNameText:SetText("Addon Settings")

-- ACHIEVEMENT ON WHISPER
local achievementButton = CreateFrame("CheckButton", "LazyGroupFinderAchievementCheckButton", LazyGroupFinderOptions, "OptionsCheckButtonTemplate")
achievementButton:SetSize(26, 26)
achievementButton:SetPoint("LEFT", bonusNameText, "TOPLEFT", 0, -33)
achievementButton:HookScript("OnClick", function(self)
	if self:GetChecked() then
		LazyGroupFinderAchievementOnApply = true
		PlaySound("igMainMenuOptionCheckBoxOn")
	else
		LazyGroupFinderAchievementOnApply = false
		PlaySound("igMainMenuOptionCheckBoxOff")
	end
end)

local achievementText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
achievementText:SetPoint("TOPLEFT", achievementButton, "TOPLEFT", 30, -7)
achievementText:SetText("Auto whisper achievement")

-- SOUND ANNOUNCEMENT
local soundButton = CreateFrame("CheckButton", "LazyGroupFinderSoundCheckButton", LazyGroupFinderOptions, "OptionsCheckButtonTemplate")
soundButton:SetSize(26, 26)
soundButton:SetPoint("LEFT", bonusNameText, "TOPLEFT", 0, -63)
soundButton:HookScript("OnClick", function(self)
	if self:GetChecked() then
		LazyGroupFinderSoundAnnouncement = true
		PlaySound("igMainMenuOptionCheckBoxOn")
	else
		LazyGroupFinderSoundAnnouncement = false
		PlaySound("igMainMenuOptionCheckBoxOff")
	end
end)

local soundText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
soundText:SetPoint("TOPLEFT", soundButton, "TOPLEFT", 30, -7)
soundText:SetText("Sound announcement")

-- CHAT ANNOUNCEMENT
local chatButton = CreateFrame("CheckButton", "LazyGroupFinderChatCheckButton", LazyGroupFinderOptions, "OptionsCheckButtonTemplate")
chatButton:SetSize(26, 26)
chatButton:SetPoint("LEFT", bonusNameText, "TOPLEFT", 0, -93)
chatButton:HookScript("OnClick", function(self)
	if self:GetChecked() then
		LazyGroupFinderChatAnnouncement = true
		PlaySound("igMainMenuOptionCheckBoxOn")
	else
		LazyGroupFinderChatAnnouncement = false
		PlaySound("igMainMenuOptionCheckBoxOff")
	end
end)

local chatText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
chatText:SetPoint("TOPLEFT", chatButton, "TOPLEFT", 30, -7)
chatText:SetText("Chat announcement")

-- MINIMAP HOVER ICON
local minimapHoverButton = CreateFrame("CheckButton", "LazyGroupFinderChatCheckButton", LazyGroupFinderOptions, "OptionsCheckButtonTemplate")
minimapHoverButton:SetSize(26, 26)
minimapHoverButton:SetPoint("LEFT", bonusNameText, "TOPLEFT", 0, -123)
minimapHoverButton:HookScript("OnClick", function(self)
	if self:GetChecked() then
		LazyGroupFinderMinimapIconHover = true
		LGFminimapIconButton:Hide()
		PlaySound("igMainMenuOptionCheckBoxOn")
	else
		LazyGroupFinderMinimapIconHover = false
		LGFminimapIconButton:Show()
		PlaySound("igMainMenuOptionCheckBoxOff")
	end
end)

local minimapHoverText = LazyGroupFinderOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
minimapHoverText:SetPoint("TOPLEFT", minimapHoverButton, "TOPLEFT", 30, -7)
minimapHoverText:SetText("Show only minimap icon on hover")

-- ON SHOW
LazyGroupFinderOptions:SetScript("OnShow", function(...)
	Initialize_CategoryStateMenu()
	UIDropDownMenu_SetSelectedName(categoryStateMenu, categoryStates[LazyGroupFinderActivityType])
	activityStates = {}
	local results = C_LFGList.GetAvailableActivities(LazyGroupFinderActivityType, nil, 1)
	for k,v in pairs(results) do
		if LazyGroupFinderActivities[v] == nil then LazyGroupFinderActivities[v] = false end
		activityStates[v] = LazyGroupFinderActivities[v]
	end
	Initialize_ActivityStateMenu()
	keywordsEditBox:SetText(LazyGroupFinderKeywords)
	bannedwordsEditBox:SetText(LazyGroupFinderBannedwords)
	achievementButton:SetChecked(LazyGroupFinderAchievementOnApply)
	soundButton:SetChecked(LazyGroupFinderSoundAnnouncement)
	chatButton:SetChecked(LazyGroupFinderChatAnnouncement)
	minimapHoverButton:SetChecked(LazyGroupFinderMinimapIconHover)
	mintankEditBox:SetText(LazyGroupFinderMinTank)
	maxtankEditBox:SetText(LazyGroupFinderMaxTank)
	minhealEditBox:SetText(LazyGroupFinderMinHeal)
	maxhealEditBox:SetText(LazyGroupFinderMaxHeal)
	mindpsEditBox:SetText(LazyGroupFinderMinDps)
	maxdpsEditBox:SetText(LazyGroupFinderMaxDps)
end)

InterfaceOptions_AddCategory(LazyGroupFinderOptions)
