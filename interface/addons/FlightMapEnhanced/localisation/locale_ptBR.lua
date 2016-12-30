if ( GetLocale() ~= "ptBR" ) then
	return;
end
local ns = select( 2, ... );
ns.L = {
	ALT_KEY = "Alt", -- Needs review
	ALWAYS_COLLAPSE = "Sempre expandir ao mostrar", -- Needs review
	CONFIG_BASIC = "Opções Básicas", -- Needs review
	CONFIG_CONFIRM_FLIGHT_AUTO = "Confirmar ao realizar voo automaticamente", -- Needs review
	CONFIG_CONFIRM_FLIGHT_MANUAL = "Confirmar ao realizar voo manualmente", -- Needs review
	CONFIG_DONT_SHOW_UPLOAD = "Don't Show the 2 week upload reminder popup", -- Requires localization
	CONFIG_MODULES = "Módulos", -- Needs review
	CONFIG_MODULES_HELP_CAPTION = "Configurações dos Módulos", -- Needs review
	CONFIG_MODULES_HELP_TEXT = "Ao ativar/desativar um módulo é necessário recarregar a interface para que as mudanças sejam efetivadas.", -- Needs review
	CONFIG_MODULES_WMC_EXPLAIN = "Você pode clicar no Mapa-múndi e seu próximo destino será marcado no Mestre de Voo mais próximo daquele local e o voo será realizado automáticamente na próxima vez que você visitar um Mestre de Voo. ", -- Needs review
	CONFIG_MODULES_WMC_EXPLAIN2 = "Para resetar o local do voo, clique no botão do minimapa e escolha nenhum", -- Needs review
	CONFIG_MOUDLES_MFM_EXPLAIN = "Este módulo mostrará no Mapa-múndi todos os Mestres de Voo que ainda não foram destravados ", -- Needs review
	CONFIRM_FLIGHT = "Deseja mesmo voar para %s ?", -- Needs review
	CTRL_KEY = "Ctrl", -- Needs review
	DETACH_ADDON_FRAME = "Separar janela do addon", -- Needs review
	FLIGHT_FRAME_LOCK = "Travar janela de voo", -- Needs review
	FT_ACCURATE = "Preciso", -- Needs review
	FT_BACKGROUND = "Frame Background", -- Requires localization
	FT_BORDER = "Border", -- Requires localization
	FT_CALCULATED = "Calculado", -- Needs review
	FT_CANNOT_FIND_ID = "Não foi encontrado o seguinte id", -- Needs review
	FT_CANNOT_FIND_ID2 = "Por favor reporte este id", -- Needs review
	FT_CANNOT_FIND_ID_NEW = "Cannot find %s , old id is %s and new id is %s, please report this.", -- Requires localization
	FT_COLOR = "Flight Time Color", -- Requires localization
	FT_COLOR_RECORDING = "Flight Time Color Recording", -- Requires localization
	FT_DEPLETE_BAR = "Deplete the timer bar", -- Requires localization
	FT_END_POINT = "Show Destination", -- Requires localization
	FT_FONT = "Font", -- Requires localization
	FT_FONT_SIZE = "Font Size", -- Requires localization
	FT_INFO = "Ativando ambas as opções o tempo de rastreamento preciso será mostrado sempre que possivel, do contrário será mostrado o tempo de rastreamento rápido.", -- Needs review
	FT_MINUTE_SHORT = "m", -- Needs review
	FT_MISSING_HOPS = "Paradas perdidos", -- Needs review
	FT_MODUS = "Modus", -- Requires localization
	FT_MOVE = "Shift+Botão Esquerdo para mover a janela", -- Needs review
	FT_RECORDING = "Recording", -- Requires localization
	FT_REVERSE_BAR = "Reverse the filling direction", -- Requires localization
	FT_SECOND_SHORT = "s", -- Needs review
	FT_SHOW_ACCURATE_MAP = "Mostrar tempo de voo preciso se conhecido no mapa de vôo", -- Needs review
	FT_SHOW_TIME = "Show time", -- Requires localization
	FT_SHOW_TIMER = "Show the timer frame", -- Requires localization
	FT_START_POINT = "Show start", -- Requires localization
	FT_TEXT_COLOR = "Text Color", -- Requires localization
	FT_TEXTURE = "Statusbar Texture", -- Requires localization
	FT_TIME_LEFT = "Tempo Restante", -- Needs review
	FT_USE_ACCURATE_TRACK = "Rastreamento preciso", -- Needs review
	FT_USE_ACCURATE_TRACK_EXPLAIN = "Todas as combinações de voo serão rastreadas, resultando em tempos de voo precisos, mas irá demorar mais para gravar todas as combinações possiveis. Isso se dá ao fato de que mesmo realizando os mesmos voos indo e voltando a rota pode ser diferente resultando em muitas combinações.", -- Needs review
	FT_USE_FAST_TRACK = "Rastreamento rápido", -- Needs review
	FT_USE_FAST_TRACK_EXPLAIN = "Permite o que o rastreamento dos tempos de voo seja rápido, com a desvantagem de ser impreciso, isso acontece pois o rastreamento dos voos é feito entre as \"paradas\" que são feitas nos Mestres de Voo pelo caminho e o que torna impreciso é o fato de que os voos geralmente são diferentes se você passa por um \"ponto de voo\" oou termina o voo ali.", -- Needs review
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED = "Não rastrear voos rápidos/lentos", -- Needs review
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED_EXPLAIN = "Se o rastreamento rápido estiver ativado e tambem esta opção somente serão rastreados voos com velocidade normal resultando na maioria dos casos, em tempos mais precisos . Os voos lentos/rápidos são raros.", -- Needs review
	LEFT_BUTTON = "Esquerdo", -- Needs review
	LOCK_ADDON_FRAME = "Travar a janela do addon", -- Needs review
	MFM_THE_ALDOR = "Os Aldor", -- Needs review
	MFM_THE_SCRYERS = "Os Áugures", -- Needs review
	MIDDLE_BUTTON = "Meio", -- Needs review
	MODIFIER_KEY = "Modificador", -- Needs review
	MOUSEBUTTON = "Botão do Mouse", -- Needs review
	NEED_VISIT_FLIGHT_MASTER = "Você precisa visitar um Mestre de Voo neste continente primeiro", -- Needs review
	NEED_VISIT_FLIGHT_MASTER_MINIMAP = "Você precisa abrir o mapa de voo neste continente antes de poder usar este recurso", -- Needs review
	NEW_FLIGHT_PATH_DISCOVERED_HELP = "Você tem locais de voo e/ou tempos de voo no seu banco de dados pessoal e esses dados ainda não estão no banco de dados do addon, ajude a melhorar o addon fazendo upload dos seus dados em http://flightmap.wowuse.com/", -- Needs review
	NEW_FLIGHT_PATH_DISCOVERED_HELP_2 = "This reminder only comes every 2 weeks, if you discovered new times, you can simply press ctrl+c to copy the url to the clipboard|n If you dont want to see this message you can turn it off in the config.", -- Requires localization
	NEXT_FLIGHT_GOTO = "Próximo voo será para", -- Needs review
	NO = "Não", -- Needs review
	NO_FLIGHT_LOCATIONS_KNOWN = "Nenhum local de voo conhecido neste mapa", -- Needs review
	NONE = "Nenhum", -- Needs review
	RIGHT_BUTTON = "Direito", -- Needs review
	SHIFT_KEY = "Shift", -- Needs review
	SHOW_MINIMAP_BUTTON = "Mostrar botão do minimapa", -- Needs review
	TOOLTIP_FLIGHTMAP_COLLAPSE = "Se marcado sempre que o mapa de voo for aberto todas as zonas serão expandidas", -- Needs review
	TOOLTIP_LINE1_MINIMAP = "Clique direito para mover o icone do minimapa", -- Needs review
	TOOLTIP_LINE2_MINIMAP = "Clique esquerdo para escolher seu próximo destino", -- Needs review
	WMC_MODIFIER_SETTINGS = "Escolha um botão do mouse e um modificador para selecionar o local aproximado do destino", -- Needs review
	WMC_QUEST_FLY = "Adds to the questtracker context menu, to allow to fly to the closest flight master for that quest", -- Requires localization
	WMC_SET_QUEST_FLY = "Set flight to closest flight master", -- Requires localization
	WMC_SHOW_ON_MINIMAP = "Mostrar no Minimapa o Mestre de Voo mais próximo da sua posição atual se você clicar no Mapa-múndi", -- Needs review
	YES = "Sim", -- Needs review
}


--[===[@debug@ 
{}
--@end-debug@]===]