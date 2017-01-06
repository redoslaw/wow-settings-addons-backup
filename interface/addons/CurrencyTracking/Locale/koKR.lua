-- $Id: koKR.lua 34 2016-12-23 08:35:30Z arith $

local L = LibStub("AceLocale-3.0"):NewLocale("CurrencyTracking", "koKR", false)

if not L then return end

if L then
L["ADDON_NOTES"] = "Currency Tracking은 획득한 화폐를 추적하고 화면 상단에 선택한 화폐를 표시해주는 애드온입니다."
L["CT_CURRENCY_TO_TRACK"] = "화면에 추적중인 화폐:"
L["OPT_BTN_Reset"] = "위치 초기화"
L["OPT_ShowOnScreen"] = "화면에 화폐 정보 표시"
L["OPT_TOOLTIPSCALE"] = "화폐 정보 툴팁의 크기 비율"
L["OPT_TRANSPARENCY"] = "화폐 정보 툴팁의 투명도"
L["Options"] = "설정"
L["TITLE"] = "Currency Tracking"
end
