--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file defines pop-up-menus for *_friends and *_ignore

]]

HoloFriends_MenuModTDone = false;
HoloFriends_MenuModPDone = false;
HoloFriends_MenuModRDone = false;
HoloFriends_MenuModFDone = false;


-- BEGIN OF LIST WITH DROP DOWN MENU BUTTONS

function HoloFriends_SetDropDownButtons()
	-- list drop down
	UnitPopupButtons["HOLOFRIENDS_WHISPER"]      = { text = TEXT(WHISPER),                           dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_INVITE"]       = { text = TEXT(INVITE),                            dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_ONWARNING"]    = { text = TEXT(HOLOFRIENDS_WINDOWMAINONWARNING),   dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_ADDCOMMENT"]   = { text = TEXT(HOLOFRIENDS_WINDOWMAINADDCOMMENT),  dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_ADDFRIEND"]    = { text = TEXT(ADD_FRIEND),                        dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_ADDIGNORE"]    = { text = TEXT(IGNORE_PLAYER),                     dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_MOVETOGROUP"]  = { text = TEXT(HOLOFRIENDS_WINDOWMAINMOVETOGROUP), dist = 0, nested = 1 };
	UnitPopupButtons["HOLOFRIENDS_ADDGROUP"]     = { text = TEXT(HOLOFRIENDS_WINDOWMAINADDGROUP),    dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_RENAMEGROUP"]  = { text = TEXT(HOLOFRIENDS_WINDOWMAINRENAMEGROUP), dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_REMOVEFRIEND"] = { text = TEXT(REMOVE_FRIEND),                     dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_REMOVEIGNORE"] = { text = TEXT(STOP_IGNORE),                       dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_REMOVEGROUP"]  = { text = TEXT(HOLOFRIENDS_WINDOWMAINREMOVEGROUP), dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_TURNINFO"]     = { text = TEXT(HOLOFRIENDS_TOOLTIPTURNINFOTITLE),  dist = 0 };
	UnitPopupButtons["HOLOFRIENDS_WHOREQUEST"]   = { text = TEXT(HOLOFRIENDS_WINDOWMAINWHOREQUEST),  dist = 0 };

	--extend the existing drop down menus
	if ( HOLOFRIENDS_OPTIONS.MenuModT and not HOLOFRIENDS_OPTIONS.MenuNoTaint ) then
		HoloFriends_MenuModTDone = true;
		HoloFriends_ExtendDropdown(UnitPopupMenus["PLAYER"]);
	end
	if ( HOLOFRIENDS_OPTIONS.MenuModP and not HOLOFRIENDS_OPTIONS.MenuNoTaint ) then
		HoloFriends_MenuModPDone = true;
		HoloFriends_ExtendDropdown(UnitPopupMenus["PARTY"]);
	end
	if ( HOLOFRIENDS_OPTIONS.MenuModR and not HOLOFRIENDS_OPTIONS.MenuNoTaint ) then
		HoloFriends_MenuModRDone = true;
		HoloFriends_ExtendDropdown(UnitPopupMenus["RAID"]);
	end
	if ( HOLOFRIENDS_OPTIONS.MenuModF and not HOLOFRIENDS_OPTIONS.MenuNoTaint ) then
		HoloFriends_MenuModFDone = true;
		HoloFriends_ExtendDropdown(UnitPopupMenus["FRIEND"]);
	end

	-- define empty menu for the group list
	UnitPopupMenus["HOLOFRIENDS_MOVETOGROUP"] = {};
end


function HoloFriends_ExtendDropdown(dropdown)
	if ( not (dropdown and type(dropdown) == "table") ) then
		return;
	end

	table.insert(dropdown, table.getn(dropdown), "HOLOFRIENDS_ADDFRIEND");
	table.insert(dropdown, table.getn(dropdown), "HOLOFRIENDS_ADDIGNORE");
	table.insert(dropdown, table.getn(dropdown), "HOLOFRIENDS_WHOREQUEST");
end


function HoloFriends_InsertDropDown()
	UnitPopupMenus["HOLOFRIENDS_LIST"] = {	"HOLOFRIENDS_WHISPER",
						"HOLOFRIENDS_INVITE",
						"HOLOFRIENDS_ONWARNING",
						"HOLOFRIENDS_ADDCOMMENT",
						"HOLOFRIENDS_ADDFRIEND",
						"HOLOFRIENDS_MOVETOGROUP",
						"HOLOFRIENDS_ADDGROUP",
						"HOLOFRIENDS_RENAMEGROUP",
						"HOLOFRIENDS_REMOVEFRIEND",
						"HOLOFRIENDS_REMOVEGROUP",
						"HOLOFRIENDS_TURNINFO",
						"HOLOFRIENDS_WHOREQUEST",
						"CANCEL" };
end


function HoloIgnore_InsertDropDown()
	UnitPopupMenus["HOLOIGNORE_LIST"] = {	"HOLOFRIENDS_ADDCOMMENT",
						"HOLOFRIENDS_ADDIGNORE",
						"HOLOFRIENDS_MOVETOGROUP",
						"HOLOFRIENDS_ADDGROUP",
						"HOLOFRIENDS_RENAMEGROUP",
						"HOLOFRIENDS_REMOVEIGNORE",
						"HOLOFRIENDS_REMOVEGROUP",
						"CANCEL" };
end

-- END OF LIST WITH DROP DOWN MENU BUTTONS


-- HoloFriends specific functions

function HoloFriends_ListDropDown_Initialize()
	local list = HoloFriends_GetList();
	local tab = UnitPopupMenus["HOLOFRIENDS_MOVETOGROUP"];
	HoloFriendsLists_FillTableWithGroups(list, tab);
	UnitPopup_ShowMenu(UIDROPDOWNMENU_OPEN_MENU,
			   "HOLOFRIENDS_LIST",
			   nil,
			   HoloFriendsDropDown.name,
			   HoloFriendsDropDown.userData);
end


table.insert(UnitPopupFrames, "HoloFriendsDropDown");

function HoloFriends_ShowListDropdown(id)
	local list = HoloFriends_GetList();

	HideDropDownMenu(1);

	HoloFriendsDropDown.initialize = HoloFriends_ListDropDown_Initialize;
	HoloFriendsDropDown.displayMode = "MENU";
	HoloFriendsDropDown.name = HoloFriendsLists_GetName(list, id, HF_DISPLAY);
	HoloFriendsDropDown.userData = id;
	if ( HoloFriendsLists_IsRealID(list, id) ) then HoloFriendsDropDown.bnetIDAccount = 1; end
	ToggleDropDownMenu(1, nil, HoloFriendsDropDown, "cursor");
end

-- end of HoloFriends specific functions


-- HoloIgnore specific functions

function HoloIgnore_ListDropDown_Initialize()
	local list = HoloIgnore_GetList();
	local tab = UnitPopupMenus["HOLOFRIENDS_MOVETOGROUP"];
	HoloFriendsLists_FillTableWithGroups(list, tab);
	UnitPopup_ShowMenu(UIDROPDOWNMENU_OPEN_MENU,
			   "HOLOIGNORE_LIST",
			   nil,
			   HoloIgnoreDropDown.name,
			   HoloIgnoreDropDown.userData);
end


table.insert(UnitPopupFrames, "HoloIgnoreDropDown");

function HoloIgnore_ShowListDropdown(id)
	local list = HoloIgnore_GetList();

	HideDropDownMenu(1);

	HoloIgnoreDropDown.initialize = HoloIgnore_ListDropDown_Initialize;
	HoloIgnoreDropDown.displayMode = "MENU";
	HoloIgnoreDropDown.name = HoloFriendsLists_GetName(list, id, HF_DISPLAY);
	HoloIgnoreDropDown.userData = id;
	ToggleDropDownMenu(1, nil, HoloIgnoreDropDown, "cursor");
end

-- end of HoloFriends specific functions
