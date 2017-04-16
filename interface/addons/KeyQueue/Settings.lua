-- GLOBAL SETTINGS

KQ_settings = {}
KQ_settings[1] = true -- Show Character namess
KQ_settings[2] = true -- Show ilvl and class from premade

-- Local variables
local checkboxes = {}
local checkboxText = {"Show applicant names", "Show ilvl and class from premade"}
local numOfCheckboxes = 2

-- UI
--Background
local UIMAINSETTINGS = CreateFrame("Frame", nil, UIParrent)
UIMAINSETTINGS:SetSize(250, 150)
UIMAINSETTINGS:SetPoint("CENTER", UIParrent, "CENTER")
UIMAINSETTINGS:SetFrameStrata("HIGH")
UIMAINSETTINGS:SetMovable(true)
UIMAINSETTINGS:EnableMouse(true)
UIMAINSETTINGS:RegisterForDrag("LeftButton")
UIMAINSETTINGS:SetScript("OnDragStart", UIMAINSETTINGS.StartMoving)
UIMAINSETTINGS:SetScript("OnDragStop", UIMAINSETTINGS.StopMovingOrSizing)
UIMAINSETTINGS:SetClampedToScreen(true)
local UIMSFrameTexture = UIMAINSETTINGS:CreateTexture("ARTWORK")
UIMSFrameTexture:SetColorTexture(0.1, 0.1, 0.1, 1)
UIMSFrameTexture:SetAllPoints(UIMAINSETTINGS)

-- Headline text
local headline = UIMAINSETTINGS:CreateFontString(nil, "ARTWORK", "GameFontNormal")
headline:SetPoint("TOP", UIMAINSETTINGS, "TOP", 0, -5)
headline:SetText("Settings")

-- Checkboxes

for index = 1, numOfCheckboxes do
	checkboxes[index] = {}
	checkboxes[index][1] = CreateFrame("CheckButton", nil, UIMAINSETTINGS, "UICheckButtonTemplate")
	if index == 1 then
		checkboxes[index][1]:SetPoint("TOPLEFT", UIMAINSETTINGS, "TOPLEFT", 5, -30)
	else
		checkboxes[index][1]:SetPoint("TOP", checkboxes[index-1][1], "BOTTOM", 0, -5)
	end
	checkboxes[index][1]:SetSize(25, 25)
	checkboxes[index][1]:SetScript("OnClick", function(self)
		KQ_settings[index] = not KQ_settings[index]
		KQ_UpdateApplicants(0)
	end)
	
	checkboxes[index][2] = checkboxes[index][1]:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	checkboxes[index][2]:SetPoint("LEFT", checkboxes[index][1], "RIGHT", 5, 0)
	checkboxes[index][2]:SetText(checkboxText[index])
end


-- Close button
local closeButton = CreateFrame("Button", nil, UIMAINSETTINGS, "UIPanelButtonTemplate")
closeButton:SetPoint("BOTTOM", UIMAINSETTINGS, "BOTTOM", 0, 5)
closeButton:SetSize(50,20)
closeButton:SetText("Close")


-- LOGIC LOCAL FUNCTIONS

	-- Update checkboxes
local function updateCheckboxes()
	for index = 1, numOfCheckboxes do
		checkboxes[index][1]:SetChecked(KQ_settings[index])
	end
end

-- LOGIC GLOBAL FUNCTIONS

	-- Show settings
function KQ_showSettings()
	UIMAINSETTINGS:Show()
	updateCheckboxes()
end

	-- Hide settings
function KQ_hideSettings()
	UIMAINSETTINGS:Hide()
end

-- LOGIC BEHAVIOUR

	-- Close button
closeButton:SetScript("OnClick", function(self)
	KQ_hideSettings()
end)

-- INITIALIZATION
UIMAINSETTINGS:Hide()
KQ_applicantSlider:SetValue(0)