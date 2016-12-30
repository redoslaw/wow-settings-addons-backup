--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]


--[[

This file manages the initialisation of the addon.

]]


-- define some constants
HF_ONLINE = true;
HF_OFFLINE = nil;
HF_QUIET = true;
HF_UNQUIET = false;
HF_DISPLAY = true;
HF_DEBUG_OUTPUT = 1;
HF_HFLIST = true;
HF_HILIST = false;
HF_SHARE = true;

-- saved lists
HOLOFRIENDS_LIST = {};
HOLOIGNORE_LIST = {};
HOLOFRIENDS_FACTIONS = {};
HOLOFRIENDS_MYCHARS = {};

-- flags to show in-game friends or ignore list
HoloFriends_ShowInGameFriendsList = false;
HoloFriends_ShowInGameIgnoreList = false;

-- timer [s] to run the list update only once a time
HoloFriends_ListUpdateRefTime = time();
HoloFriends_EventFlags.ListUpdateStartTime = HoloFriends_ListUpdateRefTime;
HoloIgnore_EventFlags.ListUpdateStartTime = HoloFriends_ListUpdateRefTime;
HoloFriends_ListUpdateMaxDelay = 3;
HoloFriends_ListUpdateDelay = 2.0;
HoloFriends_ListUpdateMinDelay = 1.8;

-- show all online friends during login
HoloFriends_ShowOnlineChat = false;

-- Number of menu buttons for direct uppend to menus
HoloFriends_MenuButtonCount = 0;

-- The opening of the FriendsFrame automatically closes the HoloFriendsFrame first
-- max. time in seconds between close of HoloFriends frame and open of FriendsFrame
HoloFriends_MaxFrameCloseTime = 0.1;
-- helper to close the HoloFriends and HoloIgnore frame at opening of FriendsFrame
HoloFriends_FriendsFrameCloseTime = 0;
HoloFriends_IgnoreFrameCloseTime = 0;

HoloFriends_Loaded = false;

-- timer [ms] is set in HoloFriends_timer.xml
HoloFriends_Time = 0.0;


function HoloFriends_SlashCommand(msg)
	if ( not HoloFriends_Loaded ) then return; end

	local cmd, subCmd = HoloFriendsFuncs_SeparateFirstString(msg);

	if ( (cmd == "delete") and (subCmd ~= "") ) then
		local dialog = StaticPopup_Show("HOLOFRIENDS_DELETECHARDATA", subCmd);
		if ( dialog ) then
			dialog.data = subCmd;
		end
	end
end


-- this creates the friends and ignore list buttons, and
-- the text lines for the FAQ, with check buttons for the options
function HoloFriendsInit_CreateListButtons_OnLoad(self, type, IDstr, template, rframe, xoff, yoff, nbuttons)
	local Fname = self:GetName();
	for ID = 1, nbuttons do
		local name = Fname..IDstr..ID;
		local Aname = Fname..IDstr..ID-1;
		if ( ID == 1 ) then Aname = rframe; end
		frame = CreateFrame(type, name, self, template, ID);
		frame:SetID(ID);
		frame:ClearAllPoints();
		if ( ID == 1 ) then
			frame:SetPoint("TOPLEFT", Aname, "TOPLEFT", xoff, yoff);
		else
			frame:SetPoint("TOPLEFT", Aname, "BOTTOMLEFT", 0, 0);
		end
	end
end


--[[
  create a menu button for direct uppend to the menus
  @param text - str (button text)
  @param func - str (function name) / function definition (like: function() print("test"); end)
]]
local function HFF_CreateMenuButton(text, func)
	if ( not text or not func ) then return; end
	HoloFriends_MenuButtonCount = HoloFriends_MenuButtonCount + 1;
	local name = "DropDownList1ButtonHF"..HoloFriends_MenuButtonCount;
	local frame = _G["DropDownList1"];
	button = CreateFrame("Button", name, frame, "UIDropDownMenuButtonTemplate");
	button:SetID(HoloFriends_MenuButtonCount);
	_G[name.."NormalText"]:ClearAllPoints();
	_G[name.."NormalText"]:SetPoint("LEFT", button, "LEFT", 0, 0);
	_G[name.."NormalText"]:SetText(text);
	button.width = _G[name.."NormalText"]:GetWidth();
	if ( _G[func] ) then
		_G["HoloFriends_MenuButtonFunction"..HoloFriends_MenuButtonCount] = _G[func]
	else
		_G["HoloFriends_MenuButtonFunction"..HoloFriends_MenuButtonCount] = func
	end
	button:SetScript("OnClick", function(self)
		local ID = self:GetID();
		self:GetParent():Hide();
		func = _G["HoloFriends_MenuButtonFunction"..ID]
		func();
	end);
end


local function HFF_AddMenuButtons()
	local addMenu = false;
	if ( HOLOFRIENDS_OPTIONS.MenuModT ) then addMenu = true; end
	if ( HOLOFRIENDS_OPTIONS.MenuModP ) then addMenu = true; end
	if ( HOLOFRIENDS_OPTIONS.MenuModR ) then addMenu = true; end
	if ( HOLOFRIENDS_OPTIONS.MenuModF ) then addMenu = true; end
	if ( HOLOFRIENDS_OPTIONS.MenuNoTaint and addMenu ) then
		HFF_CreateMenuButton(ADD_FRIEND, function()
			local name = UIDROPDOWNMENU_INIT_MENU.name;
			local server = UIDROPDOWNMENU_INIT_MENU.server;
			if ( name and server and (server ~= "") ) then
				name = name.."-"..server;
			end
			if ( name ) then HoloFriends_AddFriend(name); end
		end);
		HFF_CreateMenuButton(IGNORE_PLAYER, function()
			local name = UIDROPDOWNMENU_INIT_MENU.name;
			local server = UIDROPDOWNMENU_INIT_MENU.server;
			if ( server and (server ~= "") ) then
				name = name.."-"..server;
			end
			HoloIgnore_AddIgnore(name);
		end);
		HFF_CreateMenuButton(HOLOFRIENDS_WINDOWMAINWHOREQUEST, function()
			local name = UIDROPDOWNMENU_INIT_MENU.name;
			if ( name ) then SendWho("n-"..name); end
		end);
	end
end


-- check the faction list
function HoloFriends_CheckFactionList()
	local realm = GetRealmName();
	local faction = UnitFactionGroup("player");
	local name = UnitName("player");

	local result = nil;
	local nlist = nil;
	local index = 0;

	-- create list if not existing
	result = HOLOFRIENDS_FACTIONS[realm];
	if ( not result ) then HOLOFRIENDS_FACTIONS[realm] = {}; end

	-- add faction if not existing
	result = HOLOFRIENDS_FACTIONS[realm][faction];
	if ( not result ) then HOLOFRIENDS_FACTIONS[realm][faction] = {}; end

	-- add list for chars with unknown faction if not existing
	result = HOLOFRIENDS_FACTIONS[realm]["unknown"];
	if ( not result ) then
		HOLOFRIENDS_FACTIONS[realm]["unknown"] = {};
		nlist = HOLOFRIENDS_FACTIONS[realm]["unknown"];
		-- add all chars of this realm to the "unknown" list
		local charList = HoloFriendsFuncs_RealmGetOwnChars(); 
		for key, pname in pairs(charList) do
			table.insert(nlist, pname);
		end
		table.sort(nlist, function (a,b) return a < b; end);
	end

	-- remove this char from "unknown" list, if included
	nlist = HOLOFRIENDS_FACTIONS[realm]["unknown"];
	index = 0;
	for idx = 1, table.getn(nlist) do
		if (nlist[idx] == name) then index = idx; end
	end
	if (index ~= 0) then table.remove(nlist, index); end

	-- remove this char from "Neutral" list, if included and has a faction
	if ( faction ~= "Neutral" ) then
		nlist = HOLOFRIENDS_FACTIONS[realm]["Neutral"];
		index = 0;
		if ( nlist ) then
			for idx = 1, table.getn(nlist) do
				if (nlist[idx] == name) then index = idx; end
			end
		end
		if (index ~= 0) then table.remove(nlist, index); end
	end

	-- add this char to faction list, if not included
	nlist = HOLOFRIENDS_FACTIONS[realm][faction];
	index = 0;
	if ( nlist ) then
		for idx = 1, table.getn(nlist) do
			if (nlist[idx] == name) then index = idx; end
		end
	end
	if (index == 0) then
		table.insert(nlist, name);
		table.sort(nlist, function (a,b) return a < b; end);
	end
end


-- check the mychars list
local function HFF_CheckMycharsList()
	local realm = GetRealmName();
	local name = UnitName("player");
	local result = nil;

	result = HOLOFRIENDS_MYCHARS[realm];
	if ( not result ) then HOLOFRIENDS_MYCHARS[realm] = {}; end
	result = HOLOFRIENDS_MYCHARS[realm][name];
	if ( not result ) then HOLOFRIENDS_MYCHARS[realm][name] = {}; end

	-- add data from MYCHARS list to the actual loaded HoloFriends list
	local list = HoloFriends_GetList();
	for char, _ in pairs(HOLOFRIENDS_MYCHARS[realm]) do
		local index = HoloFriendsLists_ContainsPlayer(list, char);
		if ( index ) then
			local centry = HOLOFRIENDS_MYCHARS[realm][char];
			local lentry = list[index];
			if ( centry.class ) then lentry.class = centry.class; end
			if ( centry.lc_class ) then lentry.lc_class = centry.lc_class; end
			if ( centry.level ) then lentry.level = centry.level; end
			if ( centry.area ) then lentry.area = centry.area; end
			if ( centry.lastSeen ) then lentry.lastSeen = centry.lastSeen; end
		end
	end
end


-- init friends list window
local function HFF_OnLoad()
	-- define the space of the frame
	UIPanelWindows["HoloFriendsFrame"] = { area = "left", pushable = 0, whileDead = 1, extraWidth = 32};

	-- init friends list drop down menu
	HoloFriends_InsertDropDown();

	-- modify the ADD_FRIEND popup
	StaticPopupDialogs["ADD_FRIEND"].OnAccept = function(self)
		HoloFriends_AddFriend(self.editBox:GetText());
	end
	StaticPopupDialogs["ADD_FRIEND"].EditBoxOnEnterPressed = function(self)
		HoloFriends_AddFriend(self:GetParent().editBox:GetText());
		self:GetParent():Hide();
	end

	-- modify the FRIEND command line commands
	SlashCmdList["FRIENDS"] = function(msg)
		local player, note = HoloFriendsFuncs_SeparateFirstString(msg);
		if ( (player ~= "") or (UnitIsPlayer("target") and UnitCanCooperate("player", "target")) ) then
			HoloFriends_AddFriend(player, note);
		else
			ToggleFriendsPanel();
		end
	end
	SlashCmdList["REMOVEFRIEND"] = function(msg)
		ToggleFriendsPanel();
	end

	-- hide the button on the drag item
	HoloFriendsFrameNameButtonDrag:SetNormalTexture("");
	HoloFriendsFrameNameButtonDragClassIcon:Hide();
	HoloFriendsFrameNameButtonDragServer:Hide();
	HoloFriendsFrameNameButtonDragName:SetPoint("TOPLEFT", "HoloFriendsFrameNameButtonDrag", "TOPLEFT", 20, 0);
	HoloFriendsFrameNameButtonDrag:Hide();

	-- set frame strata to high (higher as the friends frame)
--	HoloFriendsFrame:SetFrameStrata("HIGH");  -- maybe not required

	-- load the friends list
	HoloFriends_LoadList();
end


-- init friends list window
local function HIF_OnLoad()
	-- define the space of the frame
	UIPanelWindows["HoloIgnoreFrame"] = { area = "left", pushable = 0, whileDead = 1, extraWidth = 32};

	-- init ignore list drop down menu
	HoloIgnore_InsertDropDown();

	-- modify the ADD_IGNORE popup
	StaticPopupDialogs["ADD_IGNORE"].OnAccept = function(self)
		HoloIgnore_AddIgnore(self.editBox:GetText());
	end
	StaticPopupDialogs["ADD_IGNORE"].EditBoxOnEnterPressed = function(self)
		HoloIgnore_AddIgnore(self:GetParent().editBox:GetText());
		self:GetParent():Hide();
	end

	-- modify the IGNORE command line commands
	SlashCmdList["IGNORE"] = function(msg)
		local player, note = HoloFriendsFuncs_SeparateFirstString(msg);
		if ( (player ~= "") or UnitIsPlayer("target") ) then
			HoloIgnore_AddIgnore(player, note);
		else
			ToggleIgnorePanel();
		end
	end
	SlashCmdList["UNIGNORE"] = function(msg)
		ToggleIgnorePanel();
	end

	-- hide the button on the drag item
	HoloIgnoreFrameNameButtonDrag:SetNormalTexture("");
	HoloIgnoreFrameNameButtonDragServer:Hide();
	HoloIgnoreFrameNameButtonDragName:SetPoint("TOPLEFT", "HoloIgnoreFrameNameButtonDrag", "TOPLEFT", 20, 0);
	HoloIgnoreFrameNameButtonDrag:Hide();

	-- set frame strata to high (higher as the friends frame)
--	HoloIgnoreFrame:SetFrameStrata("HIGH");  -- maybe not required

	-- load the ignore list
	HoloIgnore_LoadList();
end


-- init all HoloFriends modules OnLoad
function HoloFriendsInit_OnLoadAll()
	-- add a background texture to the default pull down menus
	getglobal("DropDownList1"):CreateTexture("DropDownList1_HoloFriendsBG", "BACKGROUND");

	-- setup of the options
	HoloFriendsOptions_VariablesLoaded();
	HoloFriendsShare_VariablesLoaded();

	-- create the buttons for direct uppend to dropdown menus
	HFF_AddMenuButtons();

	-- hook functions
	HoloFriendsHooks_OnLoad();

	-- insert additions to the drop down menus
	HoloFriends_SetDropDownButtons();

	-- init friends list specific parts
	HFF_OnLoad();
	HIF_OnLoad();
	HoloFriends_Loaded = true;

	-- init the faction list
	HoloFriends_CheckFactionList();

	-- set own char entries from MYCHARS list
	HFF_CheckMycharsList();

	SlashCmdList["HOLOFRIENDS"] = HoloFriends_SlashCommand;
	SLASH_HOLOFRIENDS1 = "/holofriends";
	SLASH_HOLOFRIENDS2 = "/hfriends";

	if ( HOLOFRIENDS_OPTIONS.ShowOnlineAtLogin ) then
		HoloFriends_ShowOnlineChat = true;
		HoloFriends_chat("HoloFriends_List_Update at login", HF_DEBUG_OUTPUT);
		HoloFriends_List_Update();
	end
end
