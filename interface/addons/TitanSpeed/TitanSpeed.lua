--[[
	TitanSpeed: A simple speedometer.
	Author: Trentin - > Quel -> tainted -> TotalPackage
--]]

local menutext = "Titan|cffffaa00Spe|r|cffff8800ed|r"
local buttonlabel = "Speed: "
local ID = "Speed"
local elap, speed, pitch, prevs, prevp = 0, 0, 0, -2, -2
local xonly, showpitch, showtenth = false, false, false
local GetUnitSpeed, GetUnitPitch, IsFlying, IsSwimming = GetUnitSpeed, GetUnitPitch, IsFlying, IsSwimming
local math_cos, floor = math.cos, floor

-- Main button frame and addon base
local f = CreateFrame("Button", "TitanPanelSpeedButton", CreateFrame("Frame", nil, UIParent), "TitanPanelComboTemplate")
f:SetFrameStrata("FULLSCREEN")
f:SetScript("OnEvent", function(this, event, ...) this[event](this, ...) end)
f:RegisterEvent("ADDON_LOADED")

---------------------------
function f:ADDON_LOADED(a1)
---------------------------
	if a1 ~= "TitanSpeed" then return end
	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
	
	self.registry = {
		id = ID,
		menuText = menutext,
		buttonTextFunction = "TitanPanelSpeedButton_GetButtonText",
		tooltipTitle = ID,
		tooltipTextFunction = "TitanPanelSpeedButton_GetTooltipText",
		frequency = 0.5,
		icon = "Interface\\Icons\\Ability_Rogue_Sprint.blp",
		iconWidth = 16,
		category = "Information",
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = false,
			ShowTenth = false,
			ShowPitch = 1,
			ShowOnlyX = false,
		},
	}
	self:SetScript("OnUpdate", function(this, a1)
		elap = elap + a1
		if elap < 0.8 then return end
		if not self.runonce then
			self.runonce = 1
			xonly, showpitch, showtenth = TitanGetVar(ID, "ShowOnlyX"), TitanGetVar(ID, "ShowPitch"), TitanGetVar(ID, "ShowTenth")
		end
		local dopitch = IsFlying() or IsSwimming()
		if xonly == 1 and dopitch then
			speed = math_cos(GetUnitPitch("player")) * GetUnitSpeed("player")
		else
			speed = GetUnitSpeed("player")
		end
		if showpitch == 1 and dopitch then
			pitch = format(" %d\194\186|r", floor((GetUnitPitch("player") * 180 / PI) + 0.5))
		else
			pitch = ""
		end
		if speed == prevs and pitch == prevp then return end
		prevs, prevp = speed, pitch
		TitanPanelButton_UpdateButton(ID)
		elap = 0
	end)

end

----------------------------------------------
function TitanPanelSpeedButton_GetButtonText()
----------------------------------------------
	local speedtext, pitchtext
	if not speed then
		speedtext = "|cffffffff??%%|r"
	else
		speedtext = speed / 0.07
		if TitanGetVar(ID, "ShowTenth") == 1 then
			speedtext = format("|cffffffff%.1f%%%s|r", speedtext, pitch)
		else
			speedtext = format("|cffffffff%d%%%s|r", floor(speedtext + 0.5), pitch)
		end
	end
	return buttonlabel, speedtext
end

-----------------------------------------------
function TitanPanelSpeedButton_GetTooltipText()
-----------------------------------------------
	return "Displays your moving speed as a \npercent (relative to your normal \nrunning speed) and pitch in degrees.\n|cff00ff00Use: Right-click for options.|r"
end


local function ToggleShowTenth()
	prevs = -2
	TitanToggleVar(ID, "ShowTenth")
	showtenth = TitanGetVar(ID, "ShowTenth")
end
local function ToggleShowPitch()
	prevp = -2
	TitanToggleVar(ID, "ShowPitch")
	showpitch = TitanGetVar(ID, "ShowPitch")
end
local function ToggleShowX()
	prevs = -2
	TitanToggleVar(ID, "ShowOnlyX")
	xonly = TitanGetVar(ID, "ShowOnlyX")
end
local temp = {}
local function UIDDM_Add(text, func, checked, keepShown)
	temp.text, temp.func, temp.checked, temp.keepShownOnClick = text, func, checked, keepShown
	UIDropDownMenu_AddButton(temp)
end
----------------------------------------------------
function TitanPanelRightClickMenu_PrepareSpeedMenu()
----------------------------------------------------
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[ID].menuText)
	
	UIDDM_Add("Show Tenths Digit", ToggleShowTenth, TitanGetVar(ID, "ShowTenth"), 1)
	UIDDM_Add("Show Pitch Angle", ToggleShowPitch, TitanGetVar(ID, "ShowPitch"), 1)
	UIDDM_Add("Show Only X Speed", ToggleShowX, TitanGetVar(ID, "ShowOnlyX"), 1)
	TitanPanelRightClickMenu_AddToggleIcon(ID)
	TitanPanelRightClickMenu_AddToggleLabelText(ID)
	TitanPanelRightClickMenu_AddSpacer()
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, ID, TITAN_PANEL_MENU_FUNC_HIDE)
end