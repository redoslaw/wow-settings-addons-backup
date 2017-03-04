-- $Id: enUS.lua 43 2017-02-03 15:03:36Z arith $

local _G = getfenv(0);
local LibStub = _G.LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("CurrencyTracking", "enUS", true, true);

if L then
	L["CT_TITLE"] = "Currency Tracking";
	L["CT_ADDON_NOTES"] = "Currency Tracking is an addon to help you track the currencies you gained, showing the selected currency even on top of the game screen.";
	L["CT_OPTIONS"] = "Options";
	L["CT_OPT_SHOWONSCREEN"] = "Show currency info on screen";
	L["CT_OPT_BTN_RESET"] = "Reset position";
	L["CT_OPT_SCALE"] = "Currencies info's scale";
	L["CT_OPT_TRANSPARENCY"] = "Currencies info's transparency";
	L["CT_OPT_BGTRANSPARENCY"] = "Currencies info's background transparency";
	L["CT_OPT_TOOLTIPTRANSPARENCY"] = "Currencies info tooltip's transparency";
	L["CT_OPT_TOOLTIPSCALE"] = "Currencies info tooltip's scale";
	L["CT_OPT_BREAKUPNUMBERS"] = "Converts a number into a localized string, grouping digits as required."
	L["CT_CURRENCY_TO_TRACK"] = "Currencies to be tracked on screen:";
	L["CT_CAT_TRACKED_CURRENCY"] = "Tracked Currencies";
end
