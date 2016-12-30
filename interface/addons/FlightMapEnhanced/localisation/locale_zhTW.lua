if ( GetLocale() ~= "zhTW" ) then
	return;
end
local ns = select( 2, ... );
ns.L = {
	ALT_KEY = "Alt", -- Needs review
	ALWAYS_COLLAPSE = "Always collapse on show", -- Requires localization
	CONFIG_BASIC = "基本選項", -- Needs review
	CONFIG_CONFIRM_FLIGHT_AUTO = "Confirm before a flight is automatic taken", -- Requires localization
	CONFIG_CONFIRM_FLIGHT_MANUAL = "Confirm before a flight is manually taken", -- Requires localization
	CONFIG_DONT_SHOW_UPLOAD = "Don't Show the 2 week upload reminder popup", -- Requires localization
	CONFIG_MODULES = "模組", -- Needs review
	CONFIG_MODULES_HELP_CAPTION = "模組設置", -- Needs review
	CONFIG_MODULES_HELP_TEXT = "假如你 啟用/停用 一個模組，你必須重新載入UI來確保更改生效。", -- Needs review
	CONFIG_MODULES_WMC_EXPLAIN = "You can click on the Worldmap and your next flight is set to the closest flight location and automatic taken when you visit next a Flightmaster.", -- Requires localization
	CONFIG_MODULES_WMC_EXPLAIN2 = "To reset the chosen flight location, click the minimap button and choose None", -- Requires localization
	CONFIG_MOUDLES_MFM_EXPLAIN = "This module will show you all missing Flight Master on the World Map", -- Requires localization
	CONFIRM_FLIGHT = "你真的想要飛行到 %s ?", -- Needs review
	CTRL_KEY = "Ctrl", -- Needs review
	DETACH_ADDON_FRAME = "Detach Addon Frame", -- Requires localization
	FLIGHT_FRAME_LOCK = "鎖定Flight Map視窗", -- Needs review
	FT_ACCURATE = "Accurate", -- Requires localization
	FT_BACKGROUND = "Frame Background", -- Requires localization
	FT_BORDER = "Border", -- Requires localization
	FT_CALCULATED = "Calculated", -- Requires localization
	FT_CANNOT_FIND_ID = "Cannot find the following id", -- Requires localization
	FT_CANNOT_FIND_ID2 = "Please report this id", -- Requires localization
	FT_CANNOT_FIND_ID_NEW = "無法發現 %s , 舊id是 %s , 新ID是 %s, 請回報此問題.", -- Needs review
	FT_COLOR = "Flight Time Color", -- Requires localization
	FT_COLOR_RECORDING = "Flight Time Color Recording", -- Requires localization
	FT_DEPLETE_BAR = "Deplete the timer bar", -- Requires localization
	FT_END_POINT = "Show Destination", -- Requires localization
	FT_FONT = "Font", -- Requires localization
	FT_FONT_SIZE = "Font Size", -- Requires localization
	FT_INFO = "If you use both options if possible the accurate time will be shown otherwise the times from fast tracking.", -- Requires localization
	FT_MINUTE_SHORT = "分", -- Needs review
	FT_MISSING_HOPS = "Missing hops", -- Requires localization
	FT_MODUS = "Modus", -- Requires localization
	FT_MOVE = "Shift+左鍵點擊 移動視窗", -- Needs review
	FT_RECORDING = "紀錄中", -- Needs review
	FT_REVERSE_BAR = "Reverse the filling direction", -- Requires localization
	FT_SECOND_SHORT = "秒", -- Needs review
	FT_SHOW_ACCURATE_MAP = "Show accurate flight times if known on the flight map", -- Requires localization
	FT_SHOW_TIME = "Show time", -- Requires localization
	FT_SHOW_TIMER = "Show the timer frame", -- Requires localization
	FT_START_POINT = "Show start", -- Requires localization
	FT_TEXT_COLOR = "Text Color", -- Requires localization
	FT_TEXTURE = "Statusbar Texture", -- Requires localization
	FT_TIME_LEFT = "剩餘時間", -- Needs review
	FT_USE_ACCURATE_TRACK = "Accurate tracking", -- Requires localization
	FT_USE_ACCURATE_TRACK_EXPLAIN = "With this enabled every possible flight combination will be tracked, resulting in accurate times, but will take long to record all possible combination. This is due even flying the same flight path forth and back can be different and there are just alot of combinations.", -- Requires localization
	FT_USE_FAST_TRACK = "Fast tracking", -- Requires localization
	FT_USE_FAST_TRACK_EXPLAIN = "This allows to track flight times fast, with the withdraw of not being accurate, this is done by tracking on longer flight every hop, that it wont be accurate is due the fact that the flight usually is different if you just pass a flight point or end the flight there", -- Requires localization
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED = "Do not track fast/slow taxis", -- Requires localization
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED_EXPLAIN = "If fast tracking is activated with this option on it will only track times with normal taxi speed resulting in more accurate times in most cases, the slow/fast taxis are very rare.", -- Requires localization
	LEFT_BUTTON = "左", -- Needs review
	LOCK_ADDON_FRAME = "鎖定插件視窗", -- Needs review
	MFM_THE_ALDOR = "奧多爾",
	MFM_THE_SCRYERS = "占卜者",
	MIDDLE_BUTTON = "中", -- Needs review
	MODIFIER_KEY = "Modifier Key", -- Requires localization
	MOUSEBUTTON = "Mouse Button", -- Requires localization
	NEED_VISIT_FLIGHT_MASTER = "You need to visit a Flight Master for this continent first", -- Requires localization
	NEED_VISIT_FLIGHT_MASTER_MINIMAP = "You need to open the flight map once for this continent before you can use this feature", -- Requires localization
	NEW_FLIGHT_PATH_DISCOVERED_HELP = "You have flight path location and/or flight times in your local database, which arent in the addon database yet, help to increase the known flight path locations/flight times and upload your data.", -- Requires localization
	NEW_FLIGHT_PATH_DISCOVERED_HELP_2 = "This reminder only comes every 2 weeks, if you discovered new times, you can simply press ctrl+c to copy the url to the clipboard|n If you dont want to see this message you can turn it off in the config.", -- Requires localization
	NEXT_FLIGHT_GOTO = "Next fly will goto", -- Requires localization
	NO = "否", -- Needs review
	NO_FLIGHT_LOCATIONS_KNOWN = "No known flight location for the map", -- Requires localization
	NONE = "無", -- Needs review
	RIGHT_BUTTON = "右", -- Needs review
	SHIFT_KEY = "Shift", -- Needs review
	SHOW_MINIMAP_BUTTON = "顯示小地圖按鈕", -- Needs review
	TOOLTIP_FLIGHTMAP_COLLAPSE = "If checked every time the Flight Map is opened all zones will be collapsed", -- Requires localization
	TOOLTIP_LINE1_MINIMAP = "Right click to move the Minimap Icon around", -- Requires localization
	TOOLTIP_LINE2_MINIMAP = "Left click to choose your next flight destination", -- Requires localization
	WMC_MODIFIER_SETTINGS = "Choose the key and mouse combination to pick the closest flight location", -- Requires localization
	WMC_QUEST_FLY = "Adds to the questtracker context menu, to allow to fly to the closest flight master for that quest", -- Requires localization
	WMC_SET_QUEST_FLY = "Set flight to closest flight master", -- Requires localization
	WMC_SHOW_ON_MINIMAP = "Show the closest flight master on the Minimap from your current position if you click on the World Map", -- Requires localization
	YES = "是", -- Needs review
}


--[===[@debug@ 
{}
--@end-debug@]===]
