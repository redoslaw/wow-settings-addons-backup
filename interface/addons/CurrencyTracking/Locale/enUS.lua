-- $Id: enUS.lua 60 2017-04-05 15:50:17Z arith $

local _G = getfenv(0);
local LibStub = _G.LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("CurrencyTracking", "enUS", true, true);

if L then
	L["CT_TITLE"] = "Currency Tracking";
	L["CT_ADDON_NOTES"] = "Currency Tracking is an addon to help you track the currencies you gained, showing the selected currency even on top of the game screen.";
	L["CT_OPTIONS"] = "Options";
	L["CT_OPT_SHOWONSCREEN"] = "Show currency info on screen";
	L["CT_OPT_SHOWMONEY"] = "Show money info on screen";
	L["CT_OPT_BTN_RESET"] = "Reset position";
	L["CT_OPT_SCALE"] = "Currencies info's scale";
	L["CT_OPT_TRANSPARENCY"] = "Currencies info's transparency";
	L["CT_OPT_BGTRANSPARENCY"] = "Currencies info's background transparency";
	L["CT_OPT_TOOLTIPTRANSPARENCY"] = "Currencies info tooltip's transparency";
	L["CT_OPT_TOOLTIPSCALE"] = "Currencies info tooltip's scale";
	L["CT_OPT_BREAKUPNUMBERS"] = "Converts a number into a localized string, grouping digits as required."
	L["CT_OPT_ICONPRIORTONUMBER"] = "Put currency icon prior to its amount";
	L["CT_OPT_ALWAYSLOCK"] = "Always lock the currency info frame";
	L["CT_OPT_ALWAYSLOCK_TIP"] = "Enable to always lock the frame even not in combat. Disable to only lock the frame while in combat. ";
	L["CT_CURRENCY_TO_TRACK"] = "Currencies to be tracked on screen:";
	L["CT_CAT_TRACKED_CURRENCY"] = "Tracked Currencies";
end
