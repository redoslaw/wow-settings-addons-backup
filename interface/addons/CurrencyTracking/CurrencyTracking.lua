-- $Id: CurrencyTracking.lua 60 2017-04-05 15:50:17Z arith $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local pairs = _G.pairs
-- Libraries
local string = _G.string;
local floor, fmod = math.floor, math.fmod

local CurrencyTracking_Player = UnitName("player");
local CurrencyTracking_Server = GetRealmName();

--local CurrencyTracking_Version = GetAddOnMetadata("CurrencyTracking", "Version");
--local CurrencyTracking_Category = GetAddOnMetadata("CurrencyTracking", "X-Category");
local isInLockdown = false;
local CT_ORIG_GAMPTOOLTIP_SCALE = GameTooltip:GetScale();
local CT_CURRSTR = nil;
local CT_ICON = "Interface\\Icons\\timelesscoin";

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
	show_money = true,
	breakupnumbers = true,
	icon_first = false,
	always_lock = false,
	scale = 1,
	alpha = 1,
	bgalpha = 0.3,
	tooltip_alpha = 0.9,
	tooltip_scale = 1;
	currencies = {},
};

local LibStub = _G.LibStub;
local L = LibStub("AceLocale-3.0"):GetLocale("CurrencyTracking");
local LDB_CurrencyTracking = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("CurrencyTracking");
local options;

-- function to check if user has all the options parameter, 
-- if not (due to some might be newly added), then add it with default value
local function CurrencyTracking_UpdateOptions(player_options)
	for k, v in pairs(CT_DefaultOptions) do
		if (player_options[k] == nil) then
			player_options[k] = v;
		end
	end
end

-- codes adopted from Accountant_Classic
local function CurrencyTracking_GetFormattedValue(amount)
	--local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];

	local gold = floor(amount / (COPPER_PER_SILVER * SILVER_PER_GOLD));
	local goldDisplay = options.breakupnumbers and BreakUpLargeNumbers(gold) or gold;
	local silver = floor((amount - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
	local copper = fmod(amount, COPPER_PER_SILVER);
	
	local TMP_GOLD_AMOUNT_TEXTURE;
	local TMP_SILVER_AMOUNT_TEXTURE;
	local TMP_COPPER_AMOUNT_TEXTURE;

	if (options.icon_first) then
		TMP_GOLD_AMOUNT_TEXTURE 	= "|TInterface\\MoneyFrame\\UI-GoldIcon:%d:%d:2:0|t %s";
		TMP_SILVER_AMOUNT_TEXTURE 	= "|TInterface\\MoneyFrame\\UI-SilverIcon:%d:%d:2:0|t %02d";
		TMP_COPPER_AMOUNT_TEXTURE 	= "|TInterface\\MoneyFrame\\UI-CopperIcon:%d:%d:2:0|t %02d";
	else
		TMP_GOLD_AMOUNT_TEXTURE 	= "%s|TInterface\\MoneyFrame\\UI-GoldIcon:%d:%d:2:0|t";
		TMP_SILVER_AMOUNT_TEXTURE 	= "%02d|TInterface\\MoneyFrame\\UI-SilverIcon:%d:%d:2:0|t";
		TMP_COPPER_AMOUNT_TEXTURE 	= "%02d|TInterface\\MoneyFrame\\UI-CopperIcon:%d:%d:2:0|t";
	end

	if (options.icon_first) then
		if (gold >0) then
			return format("|cffffffff"..TMP_GOLD_AMOUNT_TEXTURE.." "..TMP_SILVER_AMOUNT_TEXTURE.." "..TMP_COPPER_AMOUNT_TEXTURE.."|r", 0, 0, goldDisplay, 0, 0, silver, 0, 0, copper);
		elseif (silver >0) then 
			return format("|cffffffff"..TMP_SILVER_AMOUNT_TEXTURE.." "..TMP_COPPER_AMOUNT_TEXTURE.."|r", 0, 0, silver, 0, 0, copper);
		elseif (copper >0) then
			return format("|cffffffff"..TMP_COPPER_AMOUNT_TEXTURE.."|r", 0, 0, copper);
		else
			return "";
		end
	else
		if (gold >0) then
			return format(" |cffffffff"..TMP_GOLD_AMOUNT_TEXTURE.." "..TMP_SILVER_AMOUNT_TEXTURE.." "..TMP_COPPER_AMOUNT_TEXTURE.."|r", goldDisplay, 0, 0, silver, 0, 0, copper, 0, 0);
		elseif (silver >0) then 
			return format(" |cffffffff"..SILVER_AMOUNT_TEXTURE.." "..TMP_COPPER_AMOUNT_TEXTURE.."|r", silver, 0, 0, copper, 0, 0);
		elseif (copper >0) then
			return format(" |cffffffff"..COPPER_AMOUNT_TEXTURE.."|r", copper, 0, 0);
		else
			return "";
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
	--local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];

	local numTokenTypes = GetCurrencyListSize();
	local name, isHeader, count, icon;
	local CT_CURRENCY_TEXTURE;
	for i=1, numTokenTypes do
		-- // GetCurrencyListInfo() syntax:
		-- // name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(index);
		name, isHeader, _, _, _, count, icon = GetCurrencyListInfo(i);
		if ((not isHeader) and options["currencies"][name] == true) then
			if (count >= 0) then
				if (count == 0) then 
					if (options.icon_first) then
						CT_CURRENCY_TEXTURE = "|T"..icon..":%d:%d:2:0|t |cffff0000%s|r ";
					else
						CT_CURRENCY_TEXTURE = " |cffff0000%s|r|T"..icon..":%d:%d:2:0|t ";
					end
				else
					if (options.icon_first) then
						CT_CURRENCY_TEXTURE = "|T"..icon..":%d:%d:2:0|t |cffffffff%s|r ";
					else
						CT_CURRENCY_TEXTURE = " |cffffffff%s|r|T"..icon..":%d:%d:2:0|t ";
					end
				end
				count = options.breakupnumbers and BreakUpLargeNumbers(count) or count;
				if (currencystr) then
					if (options.icon_first) then
						currencystr = currencystr..format(CT_CURRENCY_TEXTURE, 0, 0, count);
					else
						currencystr = currencystr..format(CT_CURRENCY_TEXTURE, count, 0, 0);
					end
				else
					if (options.icon_first) then
						currencystr = format(CT_CURRENCY_TEXTURE, 0, 0, count);
					else
						currencystr = format(CT_CURRENCY_TEXTURE, count, 0, 0);
					end
				end
			end
		end
	end
	-- return could be nil if no any currency being tracked
	return currencystr;
end

local function CurrencyTracking_GetButtonText()
	--local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];

	local currencystr = CurrencyTracking_CurrencyString_Update();

	if (currencystr) then 
		if (options.show_money) then
			currencystr = currencystr..CurrencyTracking_GetFormattedValue(GetMoney());
		end
	else
		if (options.show_money) then
			currencystr = CurrencyTracking_GetFormattedValue(GetMoney());
		else
			currencystr = L["CT_TITLE"];
		end
	end
	
	return currencystr;
end

-- Codes adopted from TitanCurrency and revised by arith
local function CurrencyTracking_GetTooltipText()
	local display = "";
	local tooltip = "";
	local name, isHeader, isUnused, count, icount, icon, cCount;
	--local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	cCount = GetCurrencyListSize();
	for i = 1, cCount do 
		-- // GetCurrencyListInfo() syntax:
		-- // name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(index);
		name, isHeader, _, isUnused, _, count, icon = GetCurrencyListInfo(i);
		if ( isHeader ) then
			tooltip = tooltip..name.."\n";
		elseif ( (count >= 0) and not isUnused ) then
			if (icon ~= nil) then
				icount = options.breakupnumbers and BreakUpLargeNumbers(count) or count;
				if (count == 0) then
					display = " - "..name.."\t|cffff0000"..icount.." |r|T"..icon..":16|t";
				else
					display = " - "..name.."\t|cffffffff"..icount.." |r|T"..icon..":16|t";
				end
			end
			-- trace(display)
			tooltip = strconcat(tooltip, display, "|r\n");
		end
	end 
	return tooltip;    
end

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
	
	options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	CurrencyTracking_UpdateOptions(options);
end

local function CurrencyTracking_Init()
	CurrencyTracking_InitOptions();

	if(options.show_currency == true) then
		CurrencyTrackingFrame:Show();
--[[
		if ( options.offsetx and options.offsety ) then
			CurrencyTrackingFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", options.offsetx, options.offsety);
		end
]]
		CurrencyTrackingFrame:SetAlpha(options.alpha); 
		CurrencyTrackingFrame.Texture:SetColorTexture(0, 0, 0, options.bgalpha); 
		CurrencyTrackingFrame:SetScale(options.scale); 

	else
		CurrencyTrackingFrame:Hide();
	end
end

function CurrencyTracking_OnLoad(self)
	-- Register the CurrencyTracking frame for the following events
        for key, value in pairs( CURRENCYTRACKING_EVENTS ) do
            self:RegisterEvent( value );
        end

	self:RegisterForDrag("LeftButton");

	-- LDB object setting up
	LDB_CurrencyTracking.type = "data source";
	LDB_CurrencyTracking.text = L["CT_TITLE"];
	LDB_CurrencyTracking.label = L["CT_TITLE"];
	LDB_CurrencyTracking.icon = CT_ICON;
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
		--local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
		GameTooltip:SetBackdropColor(0, 0, 0, options.tooltip_alpha);
		GameTooltip:SetText(L["CT_TITLE"], 1, 1, 1, nil, 1);
		if (tooltiptxt) then
			CurrencyTracking_AddTooltipText(tooltiptxt);
		end
		GameTooltip:SetScale(options.tooltip_scale);
	end);
	
	CurrencyTrackingFrame:SetBackdropBorderColor(0, 1.0, 0, 1);
	CurrencyTrackingFrame:SetBackdropColor(0, 0, 1.0, 1);
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
	
	if (event == "ADDON_LOADED" and arg1 == "Blizzard_TokenUI") then
		LDB_CurrencyTracking.text = CurrencyTracking_GetButtonText();
	end
end

--[[
function CurrencyTracking_OnClick()
	ToggleCharacter("TokenFrame");
end
]]

function CurrencyTracking_OnMouseDown(self, buttonName)    
	-- Prevent activation when in combat or when lock is set to true
	if (isInLockdown or options.always_lock) then
		return;
	end
	if(CurrencyTrackingFrame:IsVisible()) then
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

function CurrencyTracking_OnMouseUp(self, buttonName)
	if (isInLockdown or options.always_lock) then
		return;
	end
	if(CurrencyTrackingFrame:IsVisible()) then
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

function CurrencyTracking_OnUpdate()
	local currencystr = CurrencyTracking_GetButtonText();
	if (currencystr ~= CT_CURRSTR) then
		if (CurrencyTrackingFrame:IsShown()) then
			CurrencyTrackingText:SetText(currencystr);
		end
		LDB_CurrencyTracking.text = currencystr;
		CT_CURRSTR = currencystr;
	end
	if (CurrencyTrackingFrame:IsShown()) then
		local width = CurrencyTrackingText:GetStringWidth();
		CurrencyTrackingFrame:SetWidth(width + 12);
	end
end

function CurrencyTracking_OnEnter(self)
	if (isInLockdown) then
		return;
	end
	
	if(CurrencyTrackingFrame:IsVisible()) then
		--local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
		
		if (not GameTooltip:IsShown()) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -10, 0);
			GameTooltip:SetBackdropColor(0, 0, 0, options.tooltip_alpha);
			GameTooltip:SetText("|cFFFFFFFF"..L["CT_TITLE"], 1, 1, 1, nil, 1);
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

function CurrencyTracking_OnLeave(self)
	GameTooltip_Hide();
	GameTooltip:SetScale(CT_ORIG_GAMPTOOLTIP_SCALE);
end

