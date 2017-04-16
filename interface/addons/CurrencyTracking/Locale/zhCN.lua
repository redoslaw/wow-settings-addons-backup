-- $Id: zhCN.lua 8 2016-05-24 08:23:52Z arith $

local L = LibStub("AceLocale-3.0"):NewLocale("CurrencyTracking", "zhCN", false)

if not L then return end

if L then
L["CT_ADDON_NOTES"] = "追踪所有获取的通货，并显示在游戏画面上"
L["CT_CAT_TRACKED_CURRENCY"] = "追踪的通货"
L["CT_CURRENCY_TO_TRACK"] = "在游戏画面上要追踪的通货："
L["CT_OPT_ALWAYSLOCK"] = "永远锁定通货信息窗口"
L["CT_OPT_ALWAYSLOCK_TIP"] = "启用则将不仅限于战斗中才锁定。停用则仅会于战斗中才锁定。"
L["CT_OPT_BGTRANSPARENCY"] = "通货信息的背景透明度"
L["CT_OPT_BREAKUPNUMBERS"] = "将数字加上本地化千分号"
L["CT_OPT_BTN_RESET"] = "重置位置"
L["CT_OPT_ICONPRIORTONUMBER"] = "先显示通货图标再显示其数量"
L["CT_OPT_SCALE"] = "通货信息的大小比例"
L["CT_OPT_SHOWMONEY"] = "在游戏画面上显示现金信息"
L["CT_OPT_SHOWONSCREEN"] = "在游戏画面上显示通货信息"
L["CT_OPT_TOOLTIPSCALE"] = "通货信息提示的大小比例"
L["CT_OPT_TOOLTIPTRANSPARENCY"] = "通货信息提示的透明度"
L["CT_OPT_TRANSPARENCY"] = "通货信息的透明度"
L["CT_OPTIONS"] = "选项"
L["CT_TITLE"] = "通货追踪"
end
