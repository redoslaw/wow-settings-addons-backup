-- $Id: zhTW.lua 60 2017-04-05 15:50:17Z arith $

local L = LibStub("AceLocale-3.0"):NewLocale("CurrencyTracking", "zhTW", false)

if not L then return end

if L then
L["CT_ADDON_NOTES"] = "追蹤所有獲取的通貨，並顯示在遊戲畫面上"
L["CT_CAT_TRACKED_CURRENCY"] = "追蹤的通貨"
L["CT_CURRENCY_TO_TRACK"] = "在遊戲畫面上要追蹤的通貨："
L["CT_OPT_ALWAYSLOCK"] = "永遠鎖定通貨資訊視窗"
L["CT_OPT_ALWAYSLOCK_TIP"] = "啟用則將不僅限於戰鬥中才鎖定。停用則僅會於戰鬥中才鎖定。"
L["CT_OPT_BGTRANSPARENCY"] = "通貨資訊的背景透明度"
L["CT_OPT_BREAKUPNUMBERS"] = "將數字加上本地化千分號"
L["CT_OPT_BTN_RESET"] = "重置位置"
L["CT_OPT_ICONPRIORTONUMBER"] = "先顯示通貨圖示再顯示其數量"
L["CT_OPT_SCALE"] = "通貨資訊的大小比例"
L["CT_OPT_SHOWMONEY"] = "在遊戲畫面上顯示現金資訊"
L["CT_OPT_SHOWONSCREEN"] = "在遊戲畫面上顯示通貨資訊"
L["CT_OPT_TOOLTIPSCALE"] = "通貨資訊提示的大小比例"
L["CT_OPT_TOOLTIPTRANSPARENCY"] = "通貨資訊提示的透明度"
L["CT_OPT_TRANSPARENCY"] = "通貨資訊的透明度"
L["CT_OPTIONS"] = "選項"
L["CT_TITLE"] = "通貨追蹤"
end
