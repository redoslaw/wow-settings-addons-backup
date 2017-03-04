-- $Id: koKR.lua 34 2016-12-23 08:35:30Z arith $

local L = LibStub("AceLocale-3.0"):NewLocale("CurrencyTracking", "koKR", false)

if not L then return end

if L then
L["CT_ADDON_NOTES"] = "Currency Tracking은 획득한 화폐를 추적하고 화면 상단에 선택한 화폐를 표시해주는 애드온입니다."
L["CT_CAT_TRACKED_CURRENCY"] = "추적중인 화폐"
L["CT_CURRENCY_TO_TRACK"] = "화면에 추적중인 화폐:"
L["CT_OPT_BGTRANSPARENCY"] = "화폐 정보 배경 투명도"
L["CT_OPT_BREAKUPNUMBERS"] = "화폐의 천단위 구분자를 표시"
L["CT_OPT_BTN_RESET"] = "위치 초기화"
L["CT_OPT_SCALE"] = "화폐 정보 크기"
L["CT_OPT_SHOWONSCREEN"] = "화면에 화폐 정보 표시"
L["CT_OPT_TOOLTIPSCALE"] = "화폐 정보 툴팁의 크기 비율"
L["CT_OPT_TOOLTIPTRANSPARENCY"] = "화폐 정보 툴팁의 투명도"
L["CT_OPT_TRANSPARENCY"] = "화폐 정보의 투명도"
L["CT_OPTIONS"] = "설정"
L["CT_TITLE"] = "Currency Tracking"
end
