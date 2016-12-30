--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file defines the French localisation data

]]

if( GetLocale() == "frFR" ) then

HOLOFRIENDS_DIALOGDATEFORMAT = [=[Format de date de l'infobulle :
(%%Y=année, %%m=mois, %%d=jour du mois, %%H=heure {max. 24}, %%I=heure {max. 12}, %%M=minute, %%p=am or pm, %%A=nom du jour)]=]; -- Needs review

HOLOFRIENDS_FAQ000TITLE = "FAQ HoloFriends"; -- Needs review
HOLOFRIENDS_FAQ041QUESTION = "Pourquoi \"Définir la focalisation\" est désactivé dans certains menu déroulants ?";

HOLOFRIENDS_LISTFEATURES0TITLE = "Fonctionnalités";
HOLOFRIENDS_LISTFEATURES16 = "affiche un message si quelqu'un disparaît de votre liste d'amis ou d'ignorés";
HOLOFRIENDS_LISTFEATURES37 = "enregistre et affiche les données de vos persos (si présents dans la liste d'amis)"; -- Needs review
HOLOFRIENDS_LISTFEATURES38 = "affiche le nombre de connectés/déconnectés de vos liste d'amis et d'ignorés"; -- Needs review

HOLOFRIENDS_LISTFEATURES63 = "substitue tous les noms de vos amis et de vos persos dans les zones de saisie"; -- Needs review
HOLOFRIENDS_INITADDONLOADED = "HoloFriends v%.3f chargé";
HOLOFRIENDS_INITINVALIDLISTVERSION = "Les données de HoloFriends ont été écrites par une version plus récente de l'addon (%s) ; pour éviter toute corruption des données, rien ne sera sauvegardé ou chargé";

HOLOFRIENDS_WINDOWMAINADDCOMMENT = "Editer la note";
HOLOFRIENDS_WINDOWMAINADDGROUP = "Ajouter groupe";
HOLOFRIENDS_WINDOWMAINBUTTONSTOP = "Arrêt du scan";
HOLOFRIENDS_WINDOWMAINIGNOREONLINE = "Ignorés connectés :";
HOLOFRIENDS_WINDOWMAINNUMBERONLINE = "Amis connectés :";
HOLOFRIENDS_WINDOWMAINREMOVEGROUP = "Supprimer groupe";
HOLOFRIENDS_WINDOWMAINRENAMEGROUP = "Renommer groupe";
HOLOFRIENDS_WINDOWMAINSHOWOFFLINE = "Afficher les amis déconnectés";

HOLOFRIENDS_MSGDELETECHARDIALOG = "Voulez-vous vraiment supprimer toutes les données de |cffffd200%s|r ?";
HOLOFRIENDS_MSGDELETECHARDONE = "Données de %s supprimées";
HOLOFRIENDS_MSGDELETECHARNOTFOUND = "%s introuvable, vérifiez l'orthographe";

HOLOFRIENDS_MSGFRIENDLIMITALERT = "Seulement %d amis peuvent être gérés !";
HOLOFRIENDS_MSGFRIENDMISSINGONLINE = "Votre ami %s a disparu du jeu."; -- Needs review
HOLOFRIENDS_MSGFRIENDONLINEDISABLED = "Monitoring de l'ami %s désactivé."; -- Needs review
HOLOFRIENDS_MSGFRIENDONLINEENABLED = "Monitoring de l'ami %s activé."; -- Needs review

HOLOFRIENDS_MSGIGNOREDUEL = "Duel annulé - %s est dans votre liste d'ignorés"; -- Needs review
HOLOFRIENDS_MSGIGNOREINVITEGUILD = "Invitation de guilde annulée - %s est dans votre liste d'ignorés"; -- Needs review
HOLOFRIENDS_MSGIGNORELIMITALERT = "Vous ne pouvez gérer que %d ignorés !";
HOLOFRIENDS_MSGIGNOREMISSINGONLINE = "Le joueur ignoré %s a disparu du jeu."; -- Needs review
HOLOFRIENDS_MSGIGNOREONLINEDISABLED = "Monitoring de l'ignoré %s désactivé."; -- Needs review
HOLOFRIENDS_MSGIGNOREONLINEENABLED = "Monitoring de l'ignoré %s activé."; -- Needs review
HOLOFRIENDS_MSGIGNOREPARTY = "Invitation de groupe annulée - %s est dans votre liste d'ignorés"; -- Needs review
HOLOFRIENDS_MSGIGNORESIGNGUILD = "Signature de charte de guilde annulée - %s est dans votre liste d'ignorés"; -- Needs review

HOLOFRIENDS_MSGSCANDONE = "Scan de la liste d'amis terminé.";
HOLOFRIENDS_MSGSCANSTART = "%d amis seront scannés. Cela prendra environ %f secondes. Les requêtes /who ne fonctionneront pas durant ce temps.";
HOLOFRIENDS_MSGSCANSTOP = "Scan arrêté";

HOLOFRIENDS_OPTIONS0LISTENTRY = "HoloFriends";
HOLOFRIENDS_OPTIONS0NEEDACCEPT = "Vous devez accepter les options pour que les modifications prennent effet !";
HOLOFRIENDS_OPTIONS0NEEDRELOAD = "Vous devez recharger l'UI pour que les modifications prennent effet";
HOLOFRIENDS_OPTIONS0WINDOWTITLE = "Options HoloFriends";

HOLOFRIENDS_OPTIONS1SECTIONFLW = "Fenêtre de liste d'amis";
HOLOFRIENDS_OPTIONS1SETDATEFORMAT = "Changer le format de date et heure par défaut";
HOLOFRIENDS_OPTIONS1SHOWCLASSCOLOR = "Afficher les couleurs de classe dans la liste d'amis";
HOLOFRIENDS_OPTIONS1SHOWCLASSCOLORTT = "Si coché, les noms des amis seront affichés avec leur couleur de classe dans la liste.";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONS = "Afficher les icônes de classe dans la liste d'amis";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONSTT = "Si coché, les icônes de classe seront affichées devant les noms des amis dans la liste.";
HOLOFRIENDS_OPTIONS1SHOWGROUPS = "Afficher aussi les groupes vides dans la liste d'amis compacte";
HOLOFRIENDS_OPTIONS1SHOWLEVEL = "Afficher le niveau de vos amis dans la liste d'amis";
HOLOFRIENDS_OPTIONS1SORTONLINE = "Placer les amis connectés en haut de la liste"; -- Needs review

HOLOFRIENDS_OPTIONS2MERGENOTES = "Fusionne les commentaires HoloFriends avec les notes du jeu";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFF = "Priorité aux notes du jeu";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYON = "Notes du jeu suivies des commentaires Holofriends";
HOLOFRIENDS_OPTIONS2SECTIONNOTES = "Gestion des notes du jeu";

HOLOFRIENDS_OPTIONS3MERGECOMMENTS = "Fusionne les commentaires HoloFriends lors du partage des amis";
HOLOFRIENDS_OPTIONS3SECTIONSHARE = "Fenêtre de partage";

HOLOFRIENDS_OPTIONS4MENUMODF = "Modifier les menus déroulants des différentes frames d'amis (discussion, qui, ...)";
HOLOFRIENDS_OPTIONS4MENUMODP = "Modifier les menus déroulants des frames de groupe";
HOLOFRIENDS_OPTIONS4MENUMODR = "Modifier les menus déroulants des frames de raid";
HOLOFRIENDS_OPTIONS4MENUMODT = "Modifier les menus déroulants des frames de cible";
HOLOFRIENDS_OPTIONS4SECTIONMENU = "Modification des menus déroulants";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBG = "Ajouter un fond opaque à toutes les listes déroulantes par défaut"; -- Needs review
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBG = "Ajouter un fond opaque aux listes déroulantes de HoloFriends";

HOLOFRIENDS_OPTIONS5SECTIONSTART = "Modifications au démarrage";
HOLOFRIENDS_OPTIONS5SHOWONLINEATLOGIN = "Afficher les amis connectés lors de la connexion";

HOLOFRIENDS_OPTIONS6SECTIONIGNORE = "Joueurs ignorés"; -- Needs review

HOLOFRIENDS_SHAREFRIENDSWINDOWTITLE = "Partager la liste d'amis";
HOLOFRIENDS_SHAREIGNOREWINDOWTITLE = "Partager les ignorés";
HOLOFRIENDS_SHAREWINDOWDELETENOTE = "INFO: utilisez |cffffd200/holofriends delete {nom} [at {royaume}]|r pour supprimer les données de joueurs inexistants";
HOLOFRIENDS_SHAREWINDOWFACTIONNOTEADD = "Sélectionner un personnage pour l'ajouter"; -- Needs review
HOLOFRIENDS_SHAREWINDOWNOTE = "Le partage est fait immédiatement après clic sur le bouton \"Ajouter\" ou \"Mettre à jour\"";
HOLOFRIENDS_SHAREWINDOWSOURCE = "Sélectionner les amis :";
HOLOFRIENDS_SHAREWINDOWTARGET = "Partager avec :";

HOLOFRIENDS_TOOLTIPDATEFORMAT = "%A %d.%m.%Y %H:%M";
HOLOFRIENDS_TOOLTIPLASTSEEN = "Vu pour la dernière fois";
HOLOFRIENDS_TOOLTIPNEVERSEEN = "Jamais vu";
HOLOFRIENDS_TOOLTIPTURNINFOTEXT = "Change les infos affichées à côté du nom des amis : commentaire/zone";
HOLOFRIENDS_TOOLTIPTURNINFOTITLE = "Changer infos";
HOLOFRIENDS_TOOLTIPUNKNOWN = "?";

end
