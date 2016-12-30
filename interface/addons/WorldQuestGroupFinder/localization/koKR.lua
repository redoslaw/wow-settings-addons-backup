local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "koKR") 
if not L then return end 

L["WQGF_ADDON_DESCRIPTION"] = "그룹 찾기 도구를 사용하여 손쉽게 전역 퀘스트 그룹을 찾을 수 있습니다."
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "당신이 이미 해당 전역 퀘스트를 위한 그룹에 속해있습니다."
L["WQGF_ALREADY_QUEUED_BG"] = "현재 전장 대기열에 등록되어 있습니다. 대기열을 나가서 다시 시도하십시오."
L["WQGF_ALREADY_QUEUED_DF"] = "현재 던전 찾기 대기열에 등록되어 있습니다. 대기열을 나가 다시 시도하십시오."
L["WQGF_ALREADY_QUEUED_RF"] = "현재 공격대 찾기 대기열에 등록되어 있습니다. 대기열을 나가 다시 시도하십시오."
L["WQGF_APPLIED_TO_GROUPS"] = "|c00bfffff%s|c00ffffff 전역 퀘스트를 위한 |c00bfffff%d|c00ffffff 그룹에 신청되었습니다."
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[전역 퀘스트를 완료했으며 %d 초 뒤에 그룹을 떠납니다.

파티원에게 작별인사를 하세요!]=]
L["WQGF_CANCEL"] = "취소"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "이 전역 퀘스트는 그룹으로 수행할 수 없습니다."
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "이러한 유형의 전역 퀘스트는 그룹으로 수행할 수 없습니다."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "전투 중이 아닐 경우 WQGF 그룹이 보내는 초대를 자동으로 수락합니다."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "전투 중이 아닐 경우 초대를 자동으로 수락합니다."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "그룹으로의 초대 자동 수락"
L["WQGF_CONFIG_AUTOINVITE"] = "자동 초대"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "모두 자동 초대"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "모든 신청자는 최대 5명까지 자동으로 그룹에 초대됩니다."
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "WQGF 사용자는 자동으로 초대합니다."
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "World Quest Group Finder 사용자를 자동으로 그룹에 초대합니다."
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "아무 언어 그룹이나 검색하기 (그룹 찾기 도구의 언어 선택 무시)"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "언어에 관계없이 항상 활성화 되있는 모든 그룹을 검색합니다."
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "그룹 검색 언어 필터"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "WQGF 로그인 메시지"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "로그인 시 WQGF 시작 메시지 숨기기"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "더 이상 로그인 할 때 WQGF 메시지를 표시하지 않습니다."
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "그룹이 아닐 경우 자동으로 검색 시작"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "새로운 전역 퀘스트 지역에 들어가면 자동으로 그룹을 검색합니다."
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "새로운 전역 퀘스트 지역 감지를 사용"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "새로운 전역 퀘스트 지역에 들어갔을때 그룹을 검색할지 묻는 메시지가 나타납니다."
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "이미 다른 전역 퀘스트를 위한 그룹에 있다면 묻지 않습니다."
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "처음으로 해당 전역 퀘스트 지역에 들어갈 경우 그룹 검색을 할지 묻습니다."
L["WQGF_CONFIG_PAGE_CREDITS"] = "Robou, EU-Hyjal이 만들었습니다."
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "파티 알림 사용"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "전역 퀘스트가 완료되면 메시지가 파티에 전송됩니다."
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "전역 퀘스트가 완료되면 그룹에 알립니다."
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "PvP 서버의 그룹으로의 참가 신청 방지"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "PvP 서버에서 생성된 그룹에 들어가는 것을 피합니다. (이 기능의 경우 PvP 서버의 캐릭터에게는 무시됩니다.)"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "PvP 서버"
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "침묵 모드 사용"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "침묵 모드가 활성화되면 중요한 WQGF 메시지만 표시됩니다."
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "침묵 모드"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "10초 후 자동으로 그룹에서 나갑니다."
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "전역 퀘스트가 완료되면 10초 후에 자동으로 그룹을 나갑니다."
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "전역 퀘스트 종료 대화상자 사용"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "전역 퀘스트가 완료되면 그룹을 나가거나 파티 등록 취소를 할지 묻습니다."
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "전역 퀘스트가 완료되면 그룹에서 나가기위한 대화상자 표시"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "해당 캐릭터 설정 :"
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "현재 전역 퀘스트 ID는 |c00bfffff%s|c00ffffff 입니다."
L["WQGF_DEBUG_MODE_DISABLED"] = "현재 디버그 모드가 비활성화 되었습니다."
L["WQGF_DEBUG_MODE_ENABLED"] = "현재 디버그 모드가 활성화 되었습니다."
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "현재 전역 퀘스트 없음."
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "전역 퀘스트 지역이 이 세션에 들어왔습니다 :"
L["WQGF_DELIST"] = "파티 등록 취소"
L["WQGF_GLOBAL_CONFIGURATION"] = "공통 설정 :"
L["WQGF_GROUP_CREATION_ERROR"] = "새 그룹을 만들려고 할 때 오류가 발생했습니다. 다시 시도하십시오."
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "당신의 그룹은 더 이상 |c00bfffff%s|c00ffffff 전역 퀘스트를 수행하지 않습니다."
L["WQGF_GROUP_NOW_DOING_WQ"] = "당신의 그룹은 현재 |c00bfffff%s|c00ffffff 전역 퀘스트를 수행 중입니다."
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "당신의 그룹은 현재 |c00bfffff%s|c00ffffff 전역 퀘스트를 수행 중입니다. 당신은 이미 해당 전역 퀘스트를 완료하였습니다."
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "당신의 그룹은 현재 |c00bfffff%s|c00ffffff 전역 퀘스트를 수행 중입니다. 당신은 해당 전역 퀘스트를 수행 할 자격이 없습니다."
L["WQGF_INIT_MSG"] = "임무창의 전역 퀘스트를 가운데 마우스 버튼으로 클릭하여 그룹을 검색하십시오."
L["WQGF_JOINED_WQ_GROUP"] = "|c00bfffff%s|c00ffffff 을(를) 위한 |c00bfffff%s|c00ffffff 그룹에 들어왔습니다. 즐기세요!"
L["WQGF_LEADERS_BL_CLEARED"] = "파티장 블랙리스트가 정리되었습니다."
L["WQGF_LEAVE"] = "떠나기"
L["WQGF_NEW_ENTRY_CREATED"] = "|c00bfffff%s|c00ffffff 을(를) 위한 새 그룹 |c00bfffff%s|c00ffffff 이  생성되었습니다."
L["WQGF_NO"] = "아니요"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "|c00bfffff%s|c00ffffff 을(를) 위한 당신의 신청 중 어떠한 것도 응답이 없었습니다. 새 그룹을 찾고 있습니다..."
L["WQGF_NO_APPLY_BLACKLIST"] = "해당 파티장이 블랙리스트에 있기 때문에 %d 개 그룹에 신청되지 않았습니다. |c00bfffff/wqgf unbl |c00ffffff 을 입력하여 블랙리스트를 정리할 수 있습니다."
L["WQGF_PLAYER_IS_NOT_LEADER"] = "당신은 파티장이 아닙니다."
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffff경고:|c00ffffff 이 그룹은 공격대 그룹이므로 전역 퀘스트를 완료할 수 없습니다. 당신은 파티장에게 파티 그룹으로 전환하도록 요청해야합니다. 당신이 리더가 되면 파티 그룹으로 자동 전환됩니다."
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "그룹 찾기 또는 만들기"
L["WQGF_SEARCHING_FOR_GROUP"] = "|c00bfffff%s|c00ffffff 전역 퀘스트 그룹 찾는 중..."
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffff슬래시 명령어 (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : 애드온 설정 열기"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : 파티장 블랙리스트 정리"
L["WQGF_START_ANOTHER_WQ_DIALOG"] = [=[현재 다른 전역 퀘스트를 위한 그룹에 속해 있습니다.

정말로 또 다른 전역 퀘스트를 위한 그룹을 시작하시겠습니까?]=]
L["WQGF_STAY"] = "머물기"
L["WQGF_TRANSLATION_INFO"] = "Mieow, NA-Tichondrius에 의해 한국어로 번역되었습니다."
L["WQGF_USER_JOINED"] = "World Quest Group Finder 사용자가 그룹에 들어왔습니다!"
L["WQGF_USERS_JOINED"] = "World Quest Group Finder 사용자들이 그룹에 들어왔습니다!"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[새로운 전역 퀘스트 지역에 들어왔지만, 현재 다른 전역 퀘스트 그룹에 속해있습니다.

현재 그룹을 떠나고 "%s" 그룹을 찾으시겠습니까?]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[새로운 전역 퀘스트 지역에 들어왔습니다.

"%s" 그룹을 찾으시겠습니까?]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[전역 퀘스트를 완료하였습니다.

그룹을 떠나시겠습니까?]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[전역 퀘스트를 완료했습니다.

그룹을 떠나거나 파티 등록 취소를 하시겠습니까?]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "|c00bfffff%s|c00ffffff 을(를) 위한 |c00bfffff%s|c00ffffff 그룹 신청을 취소했습니다. 다시 로그인하거나 파티장 블랙리스트를 정리하기 전까지 WQGF는 더이상 이 그룹에 재신청을 하지 않습니다."
L["WQGF_WQ_GROUP_DESCRIPTION"] = "%s 에서 \"%s\" 전역 퀘스트를 하고 있습니다. World Quest Group Finder %s 에 의해 자동 생성 되었습니다."
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "당신은 이 전역 퀘스트를 위한 올바른 지역에 있지 않습니다."
L["WQGF_YES"] = "예"