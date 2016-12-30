-- $Id: zhTW.lua 34 2016-12-23 08:35:30Z arith $

local L = LibStub("AceLocale-3.0"):NewLocale("CurrencyTracking", "zhTW", false)

if not L then return end

if L then
L["ADDON_NOTES"] = "追蹤所有獲取的通貨，並顯示在遊戲畫面上"
L["CT_CURRENCY_TO_TRACK"] = "在遊戲畫面上要追蹤的通貨："
L["OPT_BTN_Reset"] = "重置位置"
L["OPT_ShowOnScreen"] = "在遊戲畫面上顯示通貨資訊"
L["OPT_TOOLTIPSCALE"] = "通貨資訊提示的大小比例"
L["OPT_TRANSPARENCY"] = "通貨資訊提示的透明度"
L["Options"] = "選項"
L["TITLE"] = "通貨追蹤"
end
