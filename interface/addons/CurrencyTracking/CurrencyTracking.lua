-- $Id: CurrencyTracking.lua 37 2017-01-04 09:41:12Z arith $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
local _G = getfenv(0)

-- Functions
local ipairs = _G.ipairs
local pairs = _G.pairs
local CurrencyTracking_Player = UnitName("player");
local CurrencyTracking_Server = GetRealmName();

local CurrencyTracking_Version = GetAddOnMetadata("CurrencyTracking", "Version");
local CurrencyTracking_Category = GetAddOnMetadata("CurrencyTracking", "X-Category");
local isInLockdown = false;
local CT_ORIG_GAMPTOOLTIP_SCALE = GameTooltip:GetScale();
local CT_CURRSTR = nil;

local CURRENCYTRACKING_EVENTS = {
	"ADDON_LOADED",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_LEAVING_WORLD",
	"PLAYER_LOGIN",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_REGEN_DISABLED",
};

local CT_DefaultOptions = {
	offsetx = 150,
	offsety = -80,
	show_currency = true,
	tooltip_alpha = 0.9,
	tooltip_scale = 1;
	currencies = {},
};

local LibStub = _G.LibStub;
local L = LibStub("AceLocale-3.0"):GetLocale("CurrencyTracking");
local LDB_CurrencyTracking = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("CurrencyTracking");

-- function to check if user has all the options parameter, 
-- if not (due to some might be newly added), then add it with default value
local function CurrencyTracking_UpdateOptions(player_options)
	for k, v in pairs(CT_DefaultOptions) do
		if (player_options[k] == nil) then
			player_options[k] = v;
		end
	end
end

-- Codes adopted from TitanPanel
local function CurrencyTracking_AddTooltipText(text)
	if ( text ) then
		-- Append a "\n" to the end 
		if ( string.sub(text, -1, -1) ~= "\n" ) then
			text = text.."\n";
		end
		
		-- See if the string is intended for a double column
		for text1, text2 in string.gmatch(text, "([^\t\n]*)\t?([^\t\n]*)\n") do
			if ( text2 ~= "" ) then
				-- Add as double wide
				GameTooltip:AddDoubleLine(text1, text2);
			elseif ( text1 ~= "" ) then
				-- Add single column line
				GameTooltip:AddLine(text1);
			else
				-- Assume a blank line
				GameTooltip:AddLine("\n");
			end			
		end
	end
end

local function CurrencyTracking_CurrencyString_Update()
	local name, currencyID;
	local currencystr;

	local numTokenTypes = GetCurrencyListSize();
	local name, isHeader, count, icon;
	for i=1, numTokenTypes do
		-- // GetCurrencyListInfo() syntax:
		-- // name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(index);
		name, isHeader, _, _, _, count, icon = GetCurrencyListInfo(i);
		if ((not isHeader) and CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"]["currencies"][name] == true) then
			if (count >0) then
				local CURRENCY_TEXTURE = " %s|T"..icon..":%d:%d:2:0|t ";
				if (currencystr) then
					currencystr = currencystr..format(CURRENCY_TEXTURE, BreakUpLargeNumbers(count), 0, 0);
				else
					currencystr = format(CURRENCY_TEXTURE, BreakUpLargeNumbers(count), 0, 0);
				end
			end
		end
	end
	-- return could be nil if no any currency being tracked
	return currencystr;
end

local function CurrencyTracking_GetButtonText()
	--local currencystr = CurrencyTracking_BackpackTokenFrame_Update();
	local currencystr = CurrencyTracking_CurrencyString_Update();

	if (currencystr) then 
		currencystr = "|cFFFFFFFF"..currencystr;
	else
		currencystr = L["TITLE"];
	end

	return currencystr;
end

-- Codes adopted from TitanCurrency and revised by arith
local function CurrencyTracking_GetTooltipText()
	local display = "";
	local tooltip = "";
	local name, isHeader, isUnused, count, icon, cCount;
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	cCount = GetCurrencyListSize();
	for i = 1, cCount do 
		-- // GetCurrencyListInfo() syntax:
		-- // name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(index);
		name, isHeader, _, isUnused, _, count, icon = GetCurrencyListInfo(i);
		if ( isHeader ) then
			tooltip = tooltip..name.."\n";
		elseif ( (count ~= 0) and not isUnused ) then
			if (icon ~= nil) then
				display = " - "..name.."\t"..BreakUpLargeNumbers(count).." |T"..icon..":16|t"
			end
			-- trace(display)
			tooltip = strconcat(tooltip, display,"|r\n");
		end
	end 
	return tooltip;    
end

local function CurrencyTracking_InitOptions()
	if ( CurrencyTrackingDB == nil ) then
		CurrencyTrackingDB = { };
	end
	if ( CurrencyTrackingDB[CurrencyTracking_Server] == nil ) then
		CurrencyTrackingDB[CurrencyTracking_Server] = { };
	end
	if ( CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player] == nil ) then
		CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player] = { };
		CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"] = CT_DefaultOptions;
	end
	
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	CurrencyTracking_UpdateOptions(options);
--[[	if (options.tooltip_alpha == nil) then
		options.tooltip_alpha = 0.9;
	end
	if (options.tooltip_scale == nil) then
		options.tooltip_scale = 1;
	end
	if (options.currencies == nil) then
		options.currencies = {};
	end]]
end

local function CurrencyTracking_Init()
	CurrencyTracking_InitOptions();
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];

	if(options.show_currency == true) then
		CurrencyTrackingInfoFrame:Show();
--[[
		if ( options.offsetx and options.offsety ) then
			CurrencyTrackingFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", options.offsetx, options.offsety);
		end
]]
	else
		CurrencyTrackingInfoFrame:Hide();
	end
end

function CurrencyTracking_OnLoad(self)
	-- Register the CurrencyTracking frame for the following events
        for key, value in pairs( CURRENCYTRACKING_EVENTS ) do
            self:RegisterEvent( value );
        end

	self:RegisterForDrag("LeftButton");

	-- LDB object setting up
	LDB_CurrencyTracking.type = "data source"
	LDB_CurrencyTracking.text = L["TITLE"]
	LDB_CurrencyTracking.label = L["TITLE"]
	LDB_CurrencyTracking.icon = "Interface\\Icons\\timelesscoin"
	LDB_CurrencyTracking.OnClick = (function(self, button)
		if button == "LeftButton" then
			--CurrencyTracking_OnClick();
			CurrencyTrackingOptions_Toggle();
		elseif button == "RightButton" then
			--CurrencyTrackingOptions_Toggle();
		end
	end);
	LDB_CurrencyTracking.OnTooltipShow = (function(tooltip)
		if not tooltip or not tooltip.AddLine then return end
		local tooltiptxt = CurrencyTracking_GetTooltipText();
		local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
		
		GameTooltip:SetBackdropColor(0, 0, 0, options.tooltip_alpha);
		GameTooltip:SetText(L["TITLE"], 1, 1, 1, nil, 1);
		if (tooltiptxt) then
			CurrencyTracking_AddTooltipText(tooltiptxt);
		end
		GameTooltip:SetScale(options.tooltip_scale);
	end);
end

function CurrencyTracking_OnEvent(self, event, ...)
	local arg1 = ...;
	if (event == "ADDON_LOADED" and arg1 == "CurrencyTracking") then
		CurrencyTracking_Init();
	end
	-- for combact lockdown
	if (event == "PLAYER_REGEN_DISABLED") then
		isInLockdown = true;
	elseif (event == "PLAYER_REGEN_ENABLED") then
		isInLockdown = false;
	end
	
	LDB_CurrencyTracking.text = CurrencyTracking_GetButtonText();
end

--[[
function CurrencyTracking_OnClick()
	ToggleCharacter("TokenFrame");
end
]]

--[[
function CurrencyTracking_GetFormattedCurrency(currencyID)
	local _, amount, icon = GetCurrencyInfo(currencyID);
	
	if (amount >0) then
		local CURRENCY_TEXTURE = "%s|T"..icon..":%d:%d:2:0|t";
		return format(CURRENCY_TEXTURE, BreakUpLargeNumbers(amount), 0, 0);
	else
		return "";
	end
end
]]

--[[
function CurrencyTracking_BackpackTokenFrame_Update()
	local name, currencyID;
	local currencystr;

	for i=1, MAX_WATCHED_TOKENS do
		name, _, _, currencyID = GetBackpackCurrencyInfo(i);
		-- Update watched tokens
		if ( name ) then
			if (currencystr) then
				currencystr = currencystr..CurrencyTracking_GetFormattedCurrency(currencyID).." ";
			else
				currencystr = CurrencyTracking_GetFormattedCurrency(currencyID).." ";
			end
		end
	end
	-- return could be nil if no any currency being tracked
	return currencystr;
end
]]

function CurrencyTracking_Frame_Update()
	local currencystr = CurrencyTracking_GetButtonText();
	if (currencystr ~= CT_CURRSTR) then
		CurrencyTrackingText:SetText(currencystr);
		LDB_CurrencyTracking.text = currencystr;
		CT_CURRSTR = currencystr;
	end
end

function CurrencyTracking_Frame_HandleMouseDown(self, buttonName)    
	-- Prevent activation when in combat
	if (isInLockdown) then
		return;
	end
	if(CurrencyTrackingInfoFrame:IsVisible()) then
		-- Handle left button clicks
		if (buttonName == "LeftButton") then
			-- Hide tooltip while draging
			GameTooltip:Hide();
			CurrencyTrackingFrame:StartMoving();
		elseif (buttonName == "RightButton") then
			CurrencyTrackingOptions_Toggle();
			--CurrencyTracking_OnClick();
			GameTooltip_Hide();
		end
	end
end

function CurrencyTracking_Frame_HandleMouseUp(self, buttonName)
	if(CurrencyTrackingInfoFrame:IsVisible()) then
		CurrencyTrackingFrame:StopMovingOrSizing();
	end
--[[
	local x, y;
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	_, _, _, x, y = CurrencyTrackingFrame:GetPoint();
	options.offsetx = x;
	options.offsety = y;
]]
end

function CurrencyTracking_Frame_OnEnter(self)
	if (isInLockdown) then
		return;
	end
	
	if(CurrencyTrackingInfoFrame:IsVisible()) then
		local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
		
		if (not GameTooltip:IsShown()) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -10, 0);
			GameTooltip:SetBackdropColor(0, 0, 0, options.tooltip_alpha);
			GameTooltip:SetText("|cFFFFFFFF"..L["TITLE"], 1, 1, 1, nil, 1);
			local tooltip = CurrencyTracking_GetTooltipText();
			if (tooltip) then
				CurrencyTracking_AddTooltipText(tooltip);
			end
			GameTooltip:SetScale(options.tooltip_scale);
			GameTooltip:Show();
		else
			GameTooltip:Hide();
		end
	end
end

function CurrencyTracking_Frame_OnLeave(self)
	GameTooltip_Hide();
	GameTooltip:SetScale(CT_ORIG_GAMPTOOLTIP_SCALE);
end

