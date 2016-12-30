if ( GetLocale() ~= "deDE" ) then
	return;
end
local ns = select( 2, ... );
ns.L = {
	ALT_KEY = "Alt",
	ALWAYS_COLLAPSE = "Immer einklappen beim Anzeigen",
	CONFIG_BASIC = "Basisoptionen",
	CONFIG_CONFIRM_FLIGHT_AUTO = "Automatische Flüge vorher bestätigten",
	CONFIG_CONFIRM_FLIGHT_MANUAL = "Manuelle Flüge vorher bestätigen",
	CONFIG_DONT_SHOW_UPLOAD = "Don't Show the 2 week upload reminder popup", -- Requires localization
	CONFIG_MODULES = "Module",
	CONFIG_MODULES_HELP_CAPTION = "Modulkonfiguration",
	CONFIG_MODULES_HELP_TEXT = "Wenn du ein Modul aktivierst/deaktivierst musst du das UI neu laden, damit die Änderungen wirksam werden.",
	CONFIG_MODULES_WMC_EXPLAIN = "Du kannst auf die Weltkarte klicken und dein nächstes Flugziel ist der naheste Flugpunkt und wird automatisch angeflogen beim nächsten Besuch eines Flugmeisters.",
	CONFIG_MODULES_WMC_EXPLAIN2 = "Um den ausgewählten Flugpunkt zurückzusetzen, klicke auf den Minikartenbutton und wähle Keinen.",
	CONFIG_MOUDLES_MFM_EXPLAIN = "Dieses Modul zeigt auf der Weltkarte alle Flugmeister, die dir noch fehlen",
	CONFIRM_FLIGHT = "Willst du wirklich nach %s fliegen?",
	CTRL_KEY = "Strg",
	DETACH_ADDON_FRAME = "Addonfenster lösen",
	FLIGHT_FRAME_LOCK = "Flugkartenfenster sperren",
	FT_ACCURATE = "Akkurat",
	FT_BACKGROUND = "Frame Background", -- Requires localization
	FT_BORDER = "Border", -- Requires localization
	FT_CALCULATED = "Berechnet",
	FT_CANNOT_FIND_ID = "Kann die folgende ID nicht finden",
	FT_CANNOT_FIND_ID2 = "Bitte melde diese ID",
	FT_CANNOT_FIND_ID_NEW = "Kann %s nicht finden, alte ID ist %s und neue ID ist %s, bitte melden.",
	FT_COLOR = "Flight Time Color", -- Requires localization
	FT_COLOR_RECORDING = "Flight Time Color Recording", -- Requires localization
	FT_DEPLETE_BAR = "Deplete the timer bar", -- Requires localization
	FT_END_POINT = "Show Destination", -- Requires localization
	FT_FONT = "Font", -- Requires localization
	FT_FONT_SIZE = "Font Size", -- Requires localization
	FT_INFO = "Wenn du beide Optionen nutzt wird wenn möglich die akkurate Zeit angegeben, wenn nicht wird Zeit vom schnellen Tracking genutzt.",
	FT_MINUTE_SHORT = "m",
	FT_MISSING_HOPS = "Fehlende Hops", -- Needs review
	FT_MODUS = "Modus",
	FT_MOVE = "Shift+Linksklick, um das Fenster zu bewegen",
	FT_RECORDING = "Aufnahme", -- Needs review
	FT_REVERSE_BAR = "Reverse the filling direction", -- Requires localization
	FT_SECOND_SHORT = "s",
	FT_SHOW_ACCURATE_MAP = "Zeige akkurate Flugzeiten, wenn bekannt, auf der Flugkarte an", -- Needs review
	FT_SHOW_TIME = "Show time", -- Requires localization
	FT_SHOW_TIMER = "Show the timer frame", -- Requires localization
	FT_START_POINT = "Show start", -- Requires localization
	FT_TEXT_COLOR = "Text Color", -- Requires localization
	FT_TEXTURE = "Statusbar Texture", -- Requires localization
	FT_TIME_LEFT = "Verbleibende Zeit",
	FT_USE_ACCURATE_TRACK = "Akkurates Tracking",
	FT_USE_ACCURATE_TRACK_EXPLAIN = "Wenn aktiviert, wird jede mögliche Flugkombination aufgezeichnet, was in akkurate Zeiten resultiert, jedoch lange dauert, um alle möglichen Kombinationen aufzuzeichnen. Der Grund ist, dass Hin- und Rückflug des gleichen Flugpfades unterschiedlich sein können und es viele Kombinationen gibt.",
	FT_USE_FAST_TRACK = "Schnelles Tracking",
	FT_USE_FAST_TRACK_EXPLAIN = "This allows to track flight times fast, with the withdraw of not being accurate, this is done by tracking on longer flight every hop, that it wont be accurate is due the fact that the flight usually is different if you just pass a flight point or end the flight there", -- Requires localization
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED = "Schnelle/Langsame Taxis nicht tracken",
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED_EXPLAIN = "If fast tracking is activated with this option on it will only track times with normal taxi speed resulting in more accurate times in most cases, the slow/fast taxis are very rare.", -- Requires localization
	LEFT_BUTTON = "Links",
	LOCK_ADDON_FRAME = "Addonfenster fixieren",
	MFM_THE_ALDOR = "Die Aldor",
	MFM_THE_SCRYERS = "Die Seher",
	MIDDLE_BUTTON = "Mittlere",
	MODIFIER_KEY = "Modifikatortaste",
	MOUSEBUTTON = "Maustaste",
	NEED_VISIT_FLIGHT_MASTER = "Du musst erst einen Flugmeister auf diesem Kontinent besuchen",
	NEED_VISIT_FLIGHT_MASTER_MINIMAP = "Du musst erst einmal die Flugkarte auf diesem Kontinent öffnen, bevor du die Funktion nutzen kannst",
	NEW_FLIGHT_PATH_DISCOVERED_HELP = "Du hast gerade einen Flugpunkt entdeckt der noch nicht in der Addondatenbank vorhanden ist. Hilf dabei die bekannten Flugpunktkoordinaten zu vervollständigen, indem du deine Daten auf http://flightmap.wowuse.com/ hochlädst.",
	NEW_FLIGHT_PATH_DISCOVERED_HELP_2 = "This reminder only comes every 2 weeks, if you discovered new times, you can simply press ctrl+c to copy the url to the clipboard|n If you dont want to see this message you can turn it off in the config.", -- Requires localization
	NEXT_FLIGHT_GOTO = "Nächster Flug geht nach",
	NO = "Nein",
	NO_FLIGHT_LOCATIONS_KNOWN = "Keine bekannten Flugpunkte für diese Karte",
	NONE = "Keinen",
	RIGHT_BUTTON = "Rechts",
	SHIFT_KEY = "Shift",
	SHOW_MINIMAP_BUTTON = "Minikartenbutton zeigen",
	TOOLTIP_FLIGHTMAP_COLLAPSE = "Wenn ausgewählt, werden alle Zonen beim Öffnen der Flugkarte eingeklappt",
	TOOLTIP_LINE1_MINIMAP = "Rechtsklick, um den Minikartenbutton zu bewegen",
	TOOLTIP_LINE2_MINIMAP = "Linksklick, um das nächste Flugziel auszuwählen",
	WMC_MODIFIER_SETTINGS = "Wähle die Tasten- und Mauskombination aus mit der du den nächstgelegensten Flugpunkt zu wählen",
	WMC_QUEST_FLY = "Adds to the questtracker context menu, to allow to fly to the closest flight master for that quest", -- Requires localization
	WMC_SET_QUEST_FLY = "Setze Flug zum nächstgelegensten Flugmeister",
	WMC_SHOW_ON_MINIMAP = "Zeige beim Klicken auf die Weltkarte den nächsten Flugmeister auf der Minikarte von deiner aktuellen Position aus an",
	YES = "Ja",
}


--[===[@debug@ 
{}
--@end-debug@]===]

