--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file defines the Latin American Spanish localisation data

]]

if( GetLocale() == "esMX" ) then

HOLOFRIENDS_LISTFEATURES0TITLE = "Características";

HOLOFRIENDS_HOMEPAGEAIM = "Este addon modifica la ventana de amigos de WoW ofreciendo una mejor manejo de la lista de amigos y de la lista de personajes ignorados."; -- Needs review
HOLOFRIENDS_HOMEPAGETITLE = "HoloFriends (continued) v0.435";

HOLOFRIENDS_INITADDONLOADED = "Holo's Friends Addon  v%.3f cargado"; -- Needs review
HOLOFRIENDS_INITINVALIDLISTVERSION = "Los datos de HoloFriends han sido escritos en una nueva version de HoloFriends (%s) para prevenir cualquier corrupcion de datos, ninguno de estos fueron guardados o cargados";

HOLOFRIENDS_WINDOWMAINADDCOMMENT = "Editar Comentario";
HOLOFRIENDS_WINDOWMAINADDGROUP = "Adicionar Grupo";
HOLOFRIENDS_WINDOWMAINBUTTONSCAN = "Escanear";
HOLOFRIENDS_WINDOWMAINBUTTONSTOP = "Detener escaneo";
HOLOFRIENDS_WINDOWMAINNUMBERONLINE = "Amigos en Línea:";
HOLOFRIENDS_WINDOWMAINREMOVEGROUP = "Remover Grupo";
HOLOFRIENDS_WINDOWMAINRENAMEGROUP = "Renombrar Grupo";
HOLOFRIENDS_WINDOWMAINSHOWOFFLINE = "Muestra los amigos desconectados";
HOLOFRIENDS_WINDOWMAINWHOREQUEST = "Quien Solicita";

HOLOFRIENDS_MSGDELETECHARDIALOG = "Esta seguro que desea borrar todos los datos de |cffffd200%s|r?";
HOLOFRIENDS_MSGDELETECHARDONE = "Datos de %s's borrados";
HOLOFRIENDS_MSGDELETECHARNOTFOUND = "%s no encontrado, por favor revise la escritura u ortografía";

HOLOFRIENDS_MSGFRIENDLIMITALERT = "Ud puede monitorear unicamente %d amigos!";
HOLOFRIENDS_MSGFRIENDONLINEDISABLED = "El monitoreo el línea de %s desabilitada"; -- Needs review
HOLOFRIENDS_MSGFRIENDONLINEENABLED = "Monitoreo en línea de %s habilitado"; -- Needs review

HOLOFRIENDS_MSGSCANDONE = "Escaneo terminado";
HOLOFRIENDS_MSGSCANSTART = "%d amigos fue escaneado. Tomara unos %f segundos en completarse. el comando /who no funcionara durante este tiempo"; -- Needs review
HOLOFRIENDS_MSGSCANSTOP = "Escaneo detenido";

HOLOFRIENDS_OPTIONS0LISTENTRY = "HoloFriends";
HOLOFRIENDS_OPTIONS0NEEDRELOAD = "Para hacer efecto, Ud necesita recargar el personaje!"; -- Needs review

HOLOFRIENDS_OPTIONS1SHOWCLASSCOLOR = "Muestra el nmbre de amigos con el color de su clase en la lista de amigos"; -- Needs review
HOLOFRIENDS_OPTIONS1SHOWCLASSCOLORTT = "Seleccionado, los nombre de los amigos se muestran con el color de su clase en la lista de amigos";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONS = "Muestra el un icono de la clase en la lista de amigos";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONSTT = "Seleccionado, los iconos de clase en la lista de nombres de amigos se esta mostrando";

HOLOFRIENDS_OPTIONS2MERGENOTES = "Fusiona los comentarios con los comentarios colocados en las notas de los amigos";
HOLOFRIENDS_OPTIONS2MERGENOTESTT = "Seleccionado, los comentarios de HoloFriends son cargados a las nots de los amigos en el juego o viceversa dependiendo de la prioridad ajustada";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFF = "Prioridad de las notas de amigos";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFFTT = "Seleccionado, el cambio de las notas de amigos podrian reemplazar los comentarios de HoloRiends siempre que deshaga los cambios en las notas de los amigos.  Los comentarios de HoloFriends se ajustan en ambos sentidos"; -- Needs review
HOLOFRIENDS_OPTIONS2NOTESPRIORITYON = "Las notas de los amigos son seguidas por los comentarios de HoloFriends";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYONTT = "Seleccionado, estopermite definir el orden de carga en las notas de amigos+ comentarios de HoloFriends +las notas de los amigos en el juego.  Se permite maximo 48 letras"; -- Needs review

HOLOFRIENDS_OPTIONS3MERGECOMMENTS = "Fusiona los comentarios de HoloFriends durante el proceso de compartir amigos."; -- Needs review
HOLOFRIENDS_OPTIONS3MERGECOMMENTSTT = "Seleccionado, los comentarios de HoloFriends son cargados a los comentarios existentes durante el proceso de compartir su lista de amigos con otros personajes";

HOLOFRIENDS_OPTIONS4MENUMODTT = "Seleccionado, las entradas a los menus en el jugador, grupo o ventanas de banda podrian permitir la adicion de el jugador seleccionado a la lista de amigos o lista de ignorados con un simple click"; -- Needs review
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBG = "Adicione un fondo opaco para todos los menus por defecto";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBGTT = "Seleccinado, todos los menus en el jueto que usan la plantilla por defecto usan fondo opaco";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBG = "Adiciona fondo opaco para todos los menus";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBGTT = "Seleccionado, todos los menus de HoloFriendes obtienen una adicion de color de color negro";

HOLOFRIENDS_SHAREFRIENDSWINDOWTITLE = "Compartir Amigos";
HOLOFRIENDS_SHAREWINDOWDELETENOTE = "NOTICIA: use |cffffd200/holofriends delete {name} [at {realm}]|r para borrar los datos de personajes no existentes"; -- Needs review
HOLOFRIENDS_SHAREWINDOWNOTE = "Proceso de compartir es completado inmediatamente despues de hacer click en los botones adicionar o actualizar";
HOLOFRIENDS_SHAREWINDOWSOURCE = "Seleccione amigos:";
HOLOFRIENDS_SHAREWINDOWTARGET = "Compartir con:";

HOLOFRIENDS_TOOLTIPDATEFORMAT = "%A %m.%d.%Y %I:%M%p";
HOLOFRIENDS_TOOLTIPLASTSEEN = "Ultimamente visto";
HOLOFRIENDS_TOOLTIPNEVERSEEN = "Jamas visto";
HOLOFRIENDS_TOOLTIPSHAREBUTTON = "Comparte la lista de amigos con otros personajes del juego"; -- Needs review
HOLOFRIENDS_TOOLTIPUNKNOWN = "?";

end
