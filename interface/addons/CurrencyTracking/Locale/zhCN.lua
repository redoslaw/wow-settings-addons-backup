-- $Id: zhCN.lua 8 2016-05-24 08:23:52Z arith $

local L = LibStub("AceLocale-3.0"):NewLocale("CurrencyTracking", "zhCN", false)

if not L then return end

if L then
L["ADDON_NOTES"] = "追踪所有获取的通货，并显示在游戏画面上"
L["OPT_BTN_Reset"] = "重置位置"
L["OPT_ShowOnScreen"] = "在游戏画面上显示通货信息"
L["OPT_TOOLTIPSCALE"] = "通货信息提示的大小比例"
L["OPT_TRANSPARENCY"] = "通货信息提示的透明度"
L["Options"] = "选项"
L["TITLE"] = "通货追踪"
end
