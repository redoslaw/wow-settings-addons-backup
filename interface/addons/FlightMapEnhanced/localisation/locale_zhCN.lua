if ( GetLocale() ~= "zhCN" ) then
	return;
end
local ns = select( 2, ... );
ns.L = {
	ALT_KEY = "Alt", -- Requires localization
	ALWAYS_COLLAPSE = "显示总是衰减", -- Needs review
	CONFIG_BASIC = "Basic Options", -- Requires localization
	CONFIG_CONFIRM_FLIGHT_AUTO = "Confirm before a flight is automatic taken", -- Requires localization
	CONFIG_CONFIRM_FLIGHT_MANUAL = "Confirm before a flight is manually taken", -- Requires localization
	CONFIG_DONT_SHOW_UPLOAD = "Don't Show the 2 week upload reminder popup", -- Requires localization
	CONFIG_MODULES = "Modules", -- Requires localization
	CONFIG_MODULES_HELP_CAPTION = "Module Configuration", -- Requires localization
	CONFIG_MODULES_HELP_TEXT = "If you enable/disable a module you need to reload the UI to make the change active.", -- Requires localization
	CONFIG_MODULES_WMC_EXPLAIN = "You can click on the Worldmap and your next flight is set to the closest flight location and automatic taken when you visit next a Flightmaster.", -- Requires localization
	CONFIG_MODULES_WMC_EXPLAIN2 = "To reset the chosen flight location, click the minimap button and choose None", -- Requires localization
	CONFIG_MOUDLES_MFM_EXPLAIN = "This module will show you all missing Flight Master on the World Map", -- Requires localization
	CONFIRM_FLIGHT = "You really wanna flight to %s ?", -- Requires localization
	CTRL_KEY = "Ctrl", -- Requires localization
	DETACH_ADDON_FRAME = "分离框体", -- Needs review
	FLIGHT_FRAME_LOCK = "锁定飞行地图框体", -- Needs review
	FT_ACCURATE = "Accurate", -- Requires localization
	FT_BACKGROUND = "Frame Background", -- Requires localization
	FT_BORDER = "Border", -- Requires localization
	FT_CALCULATED = "Calculated", -- Requires localization
	FT_CANNOT_FIND_ID = "Cannot find the following id", -- Requires localization
	FT_CANNOT_FIND_ID2 = "Please report this id", -- Requires localization
	FT_CANNOT_FIND_ID_NEW = "Cannot find %s , old id is %s and new id is %s, please report this.", -- Requires localization
	FT_COLOR = "Flight Time Color", -- Requires localization
	FT_COLOR_RECORDING = "Flight Time Color Recording", -- Requires localization
	FT_DEPLETE_BAR = "Deplete the timer bar", -- Requires localization
	FT_END_POINT = "Show Destination", -- Requires localization
	FT_FONT = "Font", -- Requires localization
	FT_FONT_SIZE = "Font Size", -- Requires localization
	FT_INFO = "If you use both options if possible the accurate time will be shown otherwise the times from fast tracking.", -- Requires localization
	FT_MINUTE_SHORT = "m", -- Requires localization
	FT_MISSING_HOPS = "Missing hops", -- Requires localization
	FT_MODUS = "Modus", -- Requires localization
	FT_MOVE = "Shift+Left click to move the window", -- Requires localization
	FT_RECORDING = "Recording", -- Requires localization
	FT_REVERSE_BAR = "Reverse the filling direction", -- Requires localization
	FT_SECOND_SHORT = "s", -- Requires localization
	FT_SHOW_ACCURATE_MAP = "Show accurate flight times if known on the flight map", -- Requires localization
	FT_SHOW_TIME = "Show time", -- Requires localization
	FT_SHOW_TIMER = "Show the timer frame", -- Requires localization
	FT_START_POINT = "Show start", -- Requires localization
	FT_TEXT_COLOR = "Text Color", -- Requires localization
	FT_TEXTURE = "Statusbar Texture", -- Requires localization
	FT_TIME_LEFT = "Time left", -- Requires localization
	FT_USE_ACCURATE_TRACK = "Accurate tracking", -- Requires localization
	FT_USE_ACCURATE_TRACK_EXPLAIN = "With this enabled every possible flight combination will be tracked, resulting in accurate times, but will take long to record all possible combination. This is due even flying the same flight path forth and back can be different and there are just alot of combinations.", -- Requires localization
	FT_USE_FAST_TRACK = "Fast tracking", -- Requires localization
	FT_USE_FAST_TRACK_EXPLAIN = "This allows to track flight times fast, with the withdraw of not being accurate, this is done by tracking on longer flight every hop, that it wont be accurate is due the fact that the flight usually is different if you just pass a flight point or end the flight there", -- Requires localization
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED = "Do not track fast/slow taxis", -- Requires localization
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED_EXPLAIN = "If fast tracking is activated with this option on it will only track times with normal taxi speed resulting in more accurate times in most cases, the slow/fast taxis are very rare.", -- Requires localization
	LEFT_BUTTON = "Left", -- Requires localization
	LOCK_ADDON_FRAME = "锁定插件框体", -- Needs review
	MFM_THE_ALDOR = "The Aldor", -- Requires localization
	MFM_THE_SCRYERS = "The Scryers", -- Requires localization
	MIDDLE_BUTTON = "Middle", -- Requires localization
	MODIFIER_KEY = "Modifier Key", -- Requires localization
	MOUSEBUTTON = "Mouse Button", -- Requires localization
	NEED_VISIT_FLIGHT_MASTER = "需要先拜访一位本大陆飞行管理员", -- Needs review
	NEED_VISIT_FLIGHT_MASTER_MINIMAP = "使用本功能前需要先开启一次飞行地图",
	NEW_FLIGHT_PATH_DISCOVERED_HELP = "You have flight path location and/or flight times in your local database, which arent in the addon database yet, help to increase the known flight path locations/flight times and upload your data.", -- Requires localization
	NEW_FLIGHT_PATH_DISCOVERED_HELP_2 = "This reminder only comes every 2 weeks, if you discovered new times, you can simply press ctrl+c to copy the url to the clipboard|n If you dont want to see this message you can turn it off in the config.", -- Requires localization
	NEXT_FLIGHT_GOTO = "下一个飞行点将到达",
	NO = "No", -- Requires localization
	NO_FLIGHT_LOCATIONS_KNOWN = "此地图没有已知的飞行节点",
	NONE = "None", -- Requires localization
	RIGHT_BUTTON = "Right", -- Requires localization
	SHIFT_KEY = "Shift", -- Requires localization
	SHOW_MINIMAP_BUTTON = "显示小地图按钮",
	TOOLTIP_FLIGHTMAP_COLLAPSE = "减少每次检查全区飞行地图时间", -- Needs review
	TOOLTIP_LINE1_MINIMAP = "Right click to move the Minimap Icon around", -- Requires localization
	TOOLTIP_LINE2_MINIMAP = "Left click to choose your next flight destination", -- Requires localization
	WMC_MODIFIER_SETTINGS = "Choose the key and mouse combination to pick the closest flight location", -- Requires localization
	WMC_QUEST_FLY = "Adds to the questtracker context menu, to allow to fly to the closest flight master for that quest", -- Requires localization
	WMC_SET_QUEST_FLY = "Set flight to closest flight master", -- Requires localization
	WMC_SHOW_ON_MINIMAP = "Show the closest flight master on the Minimap from your current position if you click on the World Map", -- Requires localization
	YES = "Yes", -- Requires localization
}


--[===[@debug@ 
{}
--@end-debug@]===]