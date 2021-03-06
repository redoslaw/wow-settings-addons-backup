if ( GetLocale() ~= "koKR" ) then
	return;
end
local ns = select( 2, ... );
ns.L = {
	ALT_KEY = "Alt",
	ALWAYS_COLLAPSE = "항상 접어서 표시",
	CONFIG_BASIC = "기본 설정",
	CONFIG_CONFIRM_FLIGHT_AUTO = "자동으로 비행을 시작하기 전에 동의",
	CONFIG_CONFIRM_FLIGHT_MANUAL = "수동으로 비행을 시작하기 전에 동의",
	CONFIG_DONT_SHOW_UPLOAD = "2주 업로드 알리미 팝업 표시하지 않기",
	CONFIG_MODULES = "모듈",
	CONFIG_MODULES_HELP_CAPTION = "모듈 설정",
	CONFIG_MODULES_HELP_TEXT = "모듈을 활성/비활성한 후 변경 사항을 적용하려면 UI를 다시 불러와야 합니다.",
	CONFIG_MODULES_WMC_EXPLAIN = "세계 지도에서 클릭하면 다음 도착지를 클릭한 지점과 가장 가까운 비행 지점으로 설정하고 다음에 비행 조련사를 방문했을 때 자동으로 이동합니다.",
	CONFIG_MODULES_WMC_EXPLAIN2 = "선택한 비행 지점을 초기화하려면, 미니맵 버튼을 클릭하고 없음을 선택하세요",
	CONFIG_MOUDLES_MFM_EXPLAIN = "이 모듈은 세계 지도에 누락된 모든 비행 조련사를 표시합니다",
	CONFIRM_FLIGHT = "정말 %s|1으로;로; 비행할까요?",
	CTRL_KEY = "Ctrl",
	DETACH_ADDON_FRAME = "애드온 창 별도 사용",
	FLIGHT_FRAME_LOCK = "비행 지도 창 고정",
	FT_ACCURATE = "정확한",
	FT_BACKGROUND = "창 배경",
	FT_BORDER = "테두리",
	FT_CALCULATED = "계산된",
	FT_CANNOT_FIND_ID = "다음 id를 찾을 수 없습니다",
	FT_CANNOT_FIND_ID2 = "이 id를 보고해주세요",
	FT_CANNOT_FIND_ID_NEW = "%s|1을;를; 찾을 수 없습니다, 구 id는 %s이며 새 id는 %s입니다, 이것을 보고해주세요.",
	FT_COLOR = "비행 시간 색상",
	FT_COLOR_RECORDING = "비행 시간 색상 기록 중",
	FT_DEPLETE_BAR = "타이머 바 비우기",
	FT_END_POINT = "목적지 표시",
	FT_FONT = "글꼴",
	FT_FONT_SIZE = "글꼴 크기",
	FT_INFO = "두 옵션을 모두 사용하면 빠른 추적으로부터의 시간 대신 가능한 정확한 시간이 표시됩니다.",
	FT_MINUTE_SHORT = "분",
	FT_MISSING_HOPS = "누락된 탑승지",
	FT_MODUS = "방식",
	FT_MOVE = "Shift+왼쪽 클릭으로 창을 이동합니다.",
	FT_RECORDING = "기록 중",
	FT_REVERSE_BAR = "채우는 방향 반대로",
	FT_SECOND_SHORT = "초",
	FT_SHOW_ACCURATE_MAP = "정학한 비행 시간을 알고 있다면 비행 지도에 표시",
	FT_SHOW_TIME = "시간 표시",
	FT_SHOW_TIMER = "타이머 창을 표시합니다",
	FT_START_POINT = "출발점 표시",
	FT_TEXT_COLOR = "글자 색상",
	FT_TEXTURE = "상태바 무늬",
	FT_TIME_LEFT = "남은 시간",
	FT_USE_ACCURATE_TRACK = "정확한 추적",
	FT_USE_ACCURATE_TRACK_EXPLAIN = "활성화하면 정확한 시간으로 모든 가능한 비행 조합이 추적되지만 모든 가능한 조합을 기록하는데 오래 걸립니다. 같은 비행 경로를 비행하더라도 방향에 따라 다를 수 있고 수많은 조합이 있기 때문입니다.",
	FT_USE_FAST_TRACK = "빠른 추적",
	FT_USE_FAST_TRACK_EXPLAIN = "정확도 없이 중단시켜 비행 시간을 빠르게 추적합니다, 일반적으로 비행 지점을 그냥 통과하는 것과 비행을 끝내는 경우에서 생기는 차이때문에 정확하지 않지만 긴 비행 중 모든 경유지마다 추적하여 완료합니다",
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED = "빠른/느린 택시 추적하지 않기",
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED_EXPLAIN = "이 옵션과 빠른 추적이 활성화되어 있으면 대부분의 경우 느린/빠른 택시보다 더 정확한 일반 택시 속도로 시간만 추적합니다",
	LEFT_BUTTON = "왼쪽",
	LOCK_ADDON_FRAME = "애드온 창 고정",
	MFM_THE_ALDOR = "알도르 사제회",
	MFM_THE_SCRYERS = "점술가 길드",
	MIDDLE_BUTTON = "가운데",
	MODIFIER_KEY = "보조키",
	MOUSEBUTTON = "마우스 버튼",
	NEED_VISIT_FLIGHT_MASTER = "먼저 이 대륙의 비행 조련사를 방문해야 합니다",
	NEED_VISIT_FLIGHT_MASTER_MINIMAP = "이 기능을 사용하기 전에 이 대륙의 비행 지도를 한번 열어야 합니다",
	NEW_FLIGHT_PATH_DISCOVERED_HELP = "당신의 로컬 데이터베이스에 비행 경로 지점과(또는) 비행 시간이 있으나, 이것들은 아직 애드온 데이터베이스에 포함되지 않았습니다, 알려진 비행 경로 지점/비행 시간을 늘리기 위해 도와주세요, 당신의 데이터를 여기에 업로드 해주세요: ",
	NEW_FLIGHT_PATH_DISCOVERED_HELP_2 = "이 알리미는 오직 2주에 한번 새로운 시간을 발견했을 때만 나타나며, ctrl+c를 눌러 클립보드에 url을 복사할 수 있습니다|n 이 메시지를 보고싶지 않다면 설정에서 이 메시지를 끌 수 있습니다.",
	NEXT_FLIGHT_GOTO = "다음 비행 목적지: ",
	NO = "아니오",
	NO_FLIGHT_LOCATIONS_KNOWN = "지도에 알고 있는 비행 지점이 없습니다",
	NONE = "없음",
	RIGHT_BUTTON = "오른쪽",
	SHIFT_KEY = "Shift",
	SHOW_MINIMAP_BUTTON = "미니맵 버튼 표시",
	TOOLTIP_FLIGHTMAP_COLLAPSE = "체크하면 항상 모든 지역이 접힌 상태로 비행 지도가 열립니다",
	TOOLTIP_LINE1_MINIMAP = "미니맵 아이콘을 이동하려면 오른쪽 클릭",
	TOOLTIP_LINE2_MINIMAP = "다음 비행 도착지를 선택하려면 클릭",
	WMC_MODIFIER_SETTINGS = "가장 가까운 비행 지점을 선택하는 데 사용할 키와 마우스 조합을 선택하세요",
	WMC_QUEST_FLY = "퀘스트와 가장 가까운 비행 조련사로 비행할 수 있게 퀘스트 추적기에 추가합니다",
	WMC_SET_QUEST_FLY = "가장 가까운 비행 조련사로 비행하도록 설정",
	WMC_SHOW_ON_MINIMAP = "세계 지도에 클릭하면 당신의 현재 위치로부터 가장 가까운 비행 조련사를 미니맵에 표시합니다",
	YES = "네",
}


--[===[@debug@ 
{}
--@end-debug@]===]

