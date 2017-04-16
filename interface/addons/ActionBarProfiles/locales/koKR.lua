local addonName = ...

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "koKR", false)
if not L then return end

L["cfg_minimap_icon"] = "미니맵 아이콘"
L["charframe_tab"] = "행동 단축바"
L["confirm_delete"] = "정말로 행동 단축바 프로필 %s|1을;를; 삭제 하시겠습니까?"
L["confirm_overwrite"] = "이미 %s|1이라는;라는; 이름의 행동 단축바 프로필을 가지고 있습니다. 덮어 쓰시겠습니까?"
L["confirm_save"] = "행동 단축바 프로필 %s|1을;를; 저장하시겠습니까?"
L["confirm_use"] = "이 프로필의 %s(%s개 중)개의 행동 단축바를 현재 캐릭터가 사용할 수 없습니다. 이 프로필을 사용하시겠습니까?"
L["error_exists"] = "그 이름을 가진 행동 단축바 프로필이 이미 존재합니다."
L["gui_new_profile"] = "새 프로필"
L["gui_profile_name"] = "프로필 이름 입력 (최대 16자):"
L["gui_profile_options"] = "프로필 저장:"
L["option_bindings"] = "단축키"
L["option_empty_slots"] = "빈 행동 단축바"
L["option_macros"] = "매크로"
L["option_pet_actions"] = "소환수 또는 악마 행동 단축바"
L["tooltip_list"] = "사용 가능한 프로필:"
