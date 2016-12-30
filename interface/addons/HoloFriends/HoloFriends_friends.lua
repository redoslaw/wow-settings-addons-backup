--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]


--[[

This file manages the friendslist, but also the initialisation of the addon.

]]


-- default config settings
HOLOFRIENDS_TURNINFO = 0;

-- flags to skip HoloFriends_List_Update()
HoloFriends_EventFlags = {};
HoloFriends_EventFlags.Type = "FL";
HoloFriends_EventFlags.Quiet = false;
HoloFriends_EventFlags.Name = "";
HoloFriends_EventFlags.RunListUpdate = "";
HoloFriends_EventFlags.TimeStep = 0;
HoloFriends_EventFlags.ListUpdateStartTime = 0;
HoloFriends_EventFlags.SetFriendNotes = false;
HoloFriends_EventFlags.SetNotify = false;
HoloFriends_EventFlags.IgnoreAddSysMsg = false;
HoloFriends_EventFlags.IgnoreRemoveSysMsg = false;

-- time the HoloFriends-Frame is shown to wait for the FRIENDLIST_UPDATE event
HoloFriends_FrameShowTime = 0.0;

-- flag to skip HoloFriends_List_Update() at hide of FriendsFrame
HoloFriends_SkipListUpdate = false;

-- flag to run every list update step seperately to prevent time out error
local HF_FriendListContinue = false;

-- flag to update the list again
local HF_Requested_List_Update = false;

local HF_Max_Server_Friends = 200;
HoloFriends_nDisplayedNames = 18;
HoloFriends_maxDisplayedNames = 21;

local HF_Friends_TmpAdd_Delay = 3;

local HF_AllGroupsShown = true;

local HF_IsGroupSelected = false;
local HF_SelectedEntry = -1;
local HF_LastClicked = -1;

local HF_list = {};
local HF_Moving_Friend = nil;
local HF_Target_Friend = nil;

local HF_List_Online_Template = "%s%s - |cffffffff%s|r";
local HF_List_Offline_Template = "|cff888888%s|r|cff888888%s|r - |cff666666%s|r";
local HF_Level_Template = "|cff999999"..string.gsub(FRIENDS_LEVEL_TEMPLATE, "%%1?%$?d", "%%1%$s").."|r";
local HF_Limit_Alert = string.gsub(HOLOFRIENDS_MSGFRIENDLIMITALERT, "%%d", HF_Max_Server_Friends);

-- Update background texture if window become visible
local HF_Window_Visible = false;

local HF_Class_Icon_Tcoords = {
	["WARRIOR"]     = {0, 0.25, 0, 0.25},
	["MAGE"]        = {0.25, 0.49609375, 0, 0.25},
	["ROGUE"]       = {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"]       = {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"]      = {0, 0.25, 0.25, 0.5},
	["SHAMAN"]      = {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"]      = {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"]     = {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"]     = {0, 0.25, 0.5, 0.75},
	["DEATHKNIGHT"] = {0.25, 0.5, 0.5, 0.75},
	["MONK"]        = {0.49609375, 0.7421875, 0.5, 0.75}
};


-- create and insert a new friend entry
local function HFF_InsertNewEntry(name, group, level, class, lc_class, area, note, connected, onstate, notify, realid, toon, realm, faction, client, bcast, bnetid, bname, btag)
	if ( not name or name == "" ) then return nil; end

	local temp = {};
	temp.name = name;
	if ( not group or group == "" ) then
		temp.group = FRIENDS;
	else
		temp.group = group;
	end
	if ( level    and (level    ~= 0) )       then temp.level     = level;     end
	if ( class    and (class    ~= UNKNOWN) ) then temp.class     = class;     end
	if ( lc_class and (lc_class ~= UNKNOWN) ) then temp.lc_class  = lc_class;  end
	if ( area     and (area     ~= UNKNOWN) ) then temp.area      = area;      end
	if ( connected or realid )                then temp.onstate   = onstate;   end
	if ( connected )                          then temp.connected = connected; end
	if ( notify )                             then temp.notify    = notify;    end
	if ( realid )                             then temp.realid    = realid;    end
	if ( bnetid )                             then temp.bnetid    = bnetid;    end
	if ( bname )                              then temp.bname     = bname;     end
	if ( btag )                               then temp.btag      = btag;      end
	if ( toon    and (toon ~= "") )           then temp.toon      = toon;      end
	if ( realm   and (realm ~= "") )          then temp.realm     = realm;     end
	if ( faction and (faction ~= -1) )        then temp.faction   = faction;   end
	if ( bcast   and (bcast ~= "") )          then temp.bcast     = bcast;     end
	if ( client )                             then temp.client    = client;    end

	-- get comment from ignore list if there is any
	local list = HoloIgnore_GetList();
	local wasIgnore = HoloFriendsLists_ContainsPlayer(list, name);
	local ignore_note;
	if ( wasIgnore ) then ignore_note = HoloFriendsLists_GetComment(list, wasIgnore); end

	-- set comment from ignore list if no note
	if ( note and (note ~= "") ) then temp.comment = note; end
	HoloFriendsFuncs_MergeComment(temp, ignore_note, 0, true, false);

	table.insert(HF_list, temp);
end


local function HFF_GetClassFromLCClass(lc_class, noclass)
	if ( not lc_class ) then return noclass; end

	local realm = GetRealmName();
	local charList = HoloFriendsFuncs_RealmGetOwnChars();
	for key, pname in pairs(charList) do
		local plist = HOLOFRIENDS_LIST[realm][pname];
		local maxi = table.getn(plist);
		for i = 1, maxi, 1 do
			local i_lc_class = plist[i].lc_class;
			local i_class    = plist[i].class;
			if ( i_class and i_lc_class and 
			     (i_class ~= UNKNOWN) and (i_lc_class ~= UNKNOWN) and
			     (i_lc_class == lc_class))
			then
				-- check if the class entry is valid
				if ( HF_Class_Icon_Tcoords[i_class] ) then
					return i_class;
				end
			end
		end
	end
	return noclass;
end


-- event handling

local HF_Realm = "";
local HF_Player = "";
function HoloFriends_OnEvent(self, event, ...)
	if ( event == "VARIABLES_LOADED" ) then
		self:UnregisterEvent("VARIABLES_LOADED");
		self:RegisterEvent("BN_FRIEND_INFO_CHANGED");
		self:RegisterEvent("BN_CUSTOM_MESSAGE_CHANGED");
		self:RegisterEvent("FRIENDLIST_UPDATE");
		self:RegisterEvent("WHO_LIST_UPDATE");
		self:RegisterEvent("CHAT_MSG_SYSTEM");
		self:RegisterEvent("PLAYER_LOGOUT");
		HoloFriendsInit_OnLoadAll();
		HF_Realm = GetRealmName();
		HF_Player = UnitName("player");
	end

	if ( event == "BN_FRIEND_INFO_CHANGED" ) then
		HoloFriends_chat("HoloFriends_List_Update on event BN_FRIEND_INFO_CHANGED", HF_DEBUG_OUTPUT);
		HoloFriends_List_Update();
	end

	if ( event == "BN_CUSTOM_MESSAGE_CHANGED" ) then
		local arg1 = ...;
		-- check, that its not our own msg that change
		if ( arg1 ) then
			HoloFriends_chat("HoloFriends_List_Update on event BN_FRIEND_INFO_CHANGED", HF_DEBUG_OUTPUT);
			HoloFriends_List_Update();
		end
	end

	if ( event == "FRIENDLIST_UPDATE" ) then
		if ( HoloFriends_EventFlags.SetFriendNotes or HoloFriends_EventFlags.SetNotify ) then
			if ( HoloFriends_EventFlags.SetFriendNotes ) then
				HoloFriends_EventFlags.SetFriendNotes = false;
				return;
			end

			if ( HoloFriends_EventFlags.RunListUpdate ~= "" ) then
				HoloFriendsFuncs_CheckRunListUpdate(HoloFriends_EventFlags);
				return;
			else
				HoloFriends_EventFlags.SetNotify = false;
			end
		end
		HoloFriends_chat("HoloFriends_List_Update on event FRIENDLIST_UPDATE", HF_DEBUG_OUTPUT);
		HoloFriends_List_Update();
	end

	if ( event == "WHO_LIST_UPDATE" ) then
		HoloFriendsScan_CheckWhoListResult(HF_list);
	end

	if ( event == "CHAT_MSG_SYSTEM" ) then
		local msg = ...;
		if ( string.match(msg, HoloFriends_WHO_NUM_RESULTS) ) then
			HoloFriendsScan_CheckWhoListResult(HF_list);
		end
	end

	if ( event == "PLAYER_LOGOUT" ) then
		local entry = HOLOFRIENDS_MYCHARS[HF_Realm][HF_Player];
		local lc_class, class = UnitClass("player");

		entry.class    = class;
		entry.lc_class = lc_class;
		entry.level    = UnitLevel("player");
		entry.area     = GetZoneText();
		entry.lastSeen = date("%Y-%m-%d %H:%M %w");
	end

	-- events for LibWho-2.0
	if ( event == "WHOLIB_QUERY_ADDED" ) then
		HoloFriendsFuncs_CountLibWho(true);
	end
	if ( event == "WHOLIB_QUERY_RESULT" ) then
		HoloFriendsFuncs_CountLibWho(false);
	end
end

-- ### short code to get the max. run time during combat
-- ### outside combat you get the number of loops per second
-- ### during combat you get the number of loops up to the time limit
-- ### result: during normal combat the time limit is 100ms
-- ### >>> this first test case is not working, because GetTime() is not counting
--[[
HF_Start = false;
local HF_t0 = 0;
local HF_c = 0;
local HF_nc = 0;
function HoloFriends_OnUpdate(elapsed)
	if ( HF_Start ) then
		if ( HF_t0 == 0.0 ) then
			HF_t0 = time();
			HF_nc = GetTime();
			while ( true ) do
				HF_c = GetTime();
				if ( HF_t0 < time()-3 ) then
					return;
				end
			end
		elseif ( HF_t0 < time()-4 ) then
			print(HF_c, HF_nc, GetTime());
			HF_Start = false;
			HF_t0 = 0;
			HF_c = 0;
			HF_nc = 0;
		end
		return;
	end
	if ( HF_Start ) then
		if ( HF_t0 == 0.0 ) then
			HF_t0 = time();
			local t0 = 0;
			local t = 0;
			local c1 = 0;
			local c0 = 0;
			while ( true ) do
				HF_c = HF_c + 1;
				t = time();
				if ( t - t0 ~= 0 ) then
					if ( c0 > 0 ) then
						c1 = c1 + (HF_c - c0);
						HF_nc = HF_nc + 1;
					end
					c0 = HF_c;
				end
				if ( t - HF_t0 > 4 ) then
					print(c1/HF_nc);
					return;
				end
				t0 = t;
			end
		elseif ( HF_t0 < time()-4 ) then
			if ( HF_nc < 2 ) then print(HF_c); end
			HF_Start = false;
			HF_t0 = 0;
			HF_c = 0;
			HF_nc = 0;
		end
		return;
	end
end
--]]

local HF_LibWhoScanTime = 0;
function HoloFriends_OnUpdate(self, elapsed)
	if( HF_Moving_Friend ) then
		local slot;
		HF_Target_Friend = nil;
		for index = 1, HoloFriends_nDisplayedNames, 1 do
			slot = getglobal("HoloFriendsFrameNameButton"..index);
			if ( MouseIsOver(slot) ) then
				slot:LockHighlight();
				HF_Target_Friend = slot;
				local pos = HoloFriendsFrameScrollFrame:GetVerticalScroll();
				if ( index == 1 and pos >= FRIENDS_FRAME_IGNORE_HEIGHT ) then
					HoloFriendsFrameScrollFrameScrollBar:SetValue(pos - FRIENDS_FRAME_IGNORE_HEIGHT);
				end
				if ( index == HoloFriends_nDisplayedNames and
				     (pos < FRIENDS_FRAME_IGNORE_HEIGHT*(table.getn(HF_list) - HoloFriends_nDisplayedNames)) )
				then
					HoloFriendsFrameScrollFrameScrollBar:SetValue(pos + FRIENDS_FRAME_IGNORE_HEIGHT);
				end
			else
				slot:UnlockHighlight();
			end
		end
		HF_Moving_Friend:UnlockHighlight();
	end

	-- set background texture (OnShow works not always)
	if ( not HF_Window_Visible ) then
		HF_Window_Visible = true;
		HoloFriends_chat("HoloFriends_List_Update from HoloFriends_OnUpdate", HF_DEBUG_OUTPUT);
	end

	-- check for LibWho-2.0 (but only for 10 minutes from load) and register the events
	if ( HF_LibWhoScanTime == 0 ) then HF_LibWhoScanTime = time(); end
	if ( time() - HF_LibWhoScanTime < 600 ) then
		if ( _G["LibWho-2.0"] ) then
			self:RegisterEvent("WHOLIB_QUERY_RESULT");
			self:RegisterEvent("WHOLIB_QUERY_ADDED");
			HF_LibWhoScanTime = HF_LibWhoScanTime - 600;
		end
	end
end

-- update called from allways running timer frame
function HoloFriends_FriendsOnUpdate()
	-- wait for the FRIENDLIST_UPDATE event for 2 seconds after HoloFriends friends frame is shown
	if ( HoloFriends_FrameShowTime > 0.0 ) then
		if ( GetTime() > HoloFriends_FrameShowTime + HoloFriends_ListUpdateDelay ) then
			HoloFriends_FrameShowTime = 0.0;
			HoloFriends_List_Update();
		end
	end

	-- execute next list update step as new process to prevent time out error
	if ( HF_FriendListContinue ) then
		HF_FriendListContinue = false;
		HoloFriendsFuncs_CheckRunListUpdate(HoloFriends_EventFlags);
		return;
	end

	-- in case of a missing FRIENDLIST_UPDATE event, call it after a delay of 2 seconds (< HoloFriends_ListUpdateMaxDelay) for ignore add or remove
	if ( HoloFriends_EventFlags.SetNotify ) then
		if ( (HoloFriends_EventFlags.TimeStep > 0) and (time() > HoloFriends_EventFlags.TimeStep + HoloFriends_ListUpdateDelay) ) then
			HoloFriends_EventFlags.TimeStep = 0;
			HoloFriends_OnEvent(nil, "FRIENDLIST_UPDATE");
		end
	end
end


function HoloFriends_OnHide()
	HoloFriends_DeselectEntry();

	-- mark visibility of friends window
	HF_Window_Visible = false;
end


-- add a friend
function HoloFriends_AddFriend(player, note, group)
	local name;
	if ( player and player ~= "" ) then
		name = player;
	elseif ( UnitIsPlayer("target") and UnitCanCooperate("player", "target") ) then
		name = GetUnitName("target", true);
	else
		local dialog = StaticPopup_Show("HOLOFRIENDS_ADDFRIEND");
		if ( dialog and group ) then dialog.data = group; end
		return;
	end

	-- check if there is a note behind the name
	local msg = note;
	if ( not msg or msg == "" ) then
		local pos = string.find(name, " ");
		if ( pos ) then
			msg = string.sub(name, pos + 1);
			name = string.sub(name, 1, pos - 1)
		end
	end

	if ( not HoloFriendsLists_ContainsPlayer(HF_list, name) ) then
		if ( string.find(name, "@") or string.find(name, "#") ) then
			-- check if BNet is available
			if ( not BNFeaturesEnabledAndConnected() ) then
				HoloFriendsFuncs_SystemMessage(HOLOFRIENDS_MSGFRIENDNOBNETNOFRIEND);
				return;
			end
			local _, battleTag, _, _, _, _, isRIDEnabled = BNGetInfo();
			if ( not isRIDEnabled and string.find(name, "@") ) then
				HoloFriendsFuncs_SystemMessage(HOLOFRIENDS_MSGFRIENDNOREALIDNOFRIEND);
				return;
			end
			if ( not battleTag and string.find(name, "#") ) then
				HoloFriendsFuncs_SystemMessage(HOLOFRIENDS_MSGFRIENDNOBTAGNOFRIEND);
				return;
			end
			-- Now send the friend invite
			HoloFriends_EventFlags.Name = name;
			HoloFriends_EventFlags.RunListUpdate = "";
			HoloFriends_EventFlags.Quiet = false;
			HoloFriendsFuncs_AddToServerList(HoloFriends_EventFlags, msg);
			return;
		else
			HFF_InsertNewEntry(name, group, nil, nil, nil, nil, msg);
			if ( (GetNumFriends() < HF_Max_Server_Friends) and (name ~= UnitName("player")) ) then
				local index = HoloFriendsLists_ContainsPlayer(HF_list, name);
				HoloFriendsLists_SetNotify(HF_list, index, HF_ONLINE, HF_UNQUIET, "RunUpdate", HoloFriends_EventFlags);
			else
				local msg = format(HOLOFRIENDS_MSGFRIENDONLINEDISABLED, name);
				HoloFriendsFuncs_SystemMessage(msg);
				HoloFriends_chat("HoloFriends_List_Update from HoloFriends_AddFriend", HF_DEBUG_OUTPUT);
				HoloFriends_List_Update();
			end
		end
	end

	-- update share window if open
	if ( HoloFriends_ShareFrame:IsVisible() ) then
		HoloFriendsShare_OnShow(HoloFriends_ShareFrame);
	end
end


-- remove the selected friend
function HoloFriends_RemoveFriend(index)
	if ( index ) then
		if ( type(index) ~= "number" ) then return; end
		HF_SelectedEntry = index;
		HF_IsGroupSelected = HoloFriendsLists_IsGroup(HF_list, index);
	end

	if ( HF_IsGroupSelected or not HoloFriends_IsSelectedEntryValid() ) then return; end

	local done = false;
	if ( HoloFriendsLists_GetNotify(HF_list, HF_SelectedEntry) ) then
		done = HoloFriendsLists_SetNotify(HF_list, HF_SelectedEntry, HF_OFFLINE, HF_UNQUIET, "RunUpdate", HoloFriends_EventFlags);
	end

	-- remove from our list
	table.remove(HF_list, HF_SelectedEntry);
	HoloFriends_DeselectEntry();

	-- to update list also for offline friends
	-- ("if" statement is important, because the friend could be still at the online list)
	if (not done) then
		HoloFriends_chat("HoloFriends_List_Update from HoloFriends_RemoveFriend", HF_DEBUG_OUTPUT);
		HoloFriends_List_Update();
	end

	-- update share window if open
	if ( HoloFriends_ShareFrame:IsVisible() ) then
		HoloFriendsShare_OnShow(HoloFriends_ShareFrame);
	end
end


-- BEGIN OF GETTERS

-- returns the id of the last clicked entry
function HoloFriends_GetLastClickedIndex()
	return HF_LastClicked;
end


-- returns the selected entry
function HoloFriends_GetSelectedEntry()
	return HF_SelectedEntry;
end


-- sets the selected entry
function HoloFriends_SetSelectedEntry(index)
	if ( type(index) ~= "number" ) then return; end
	if ( math.floor(index) ~= index ) then return; end
	HF_SelectedEntry = index;
end


-- returns true if the selected entry is valid
function HoloFriends_IsSelectedEntryValid()
	if ( not HoloFriends_Loaded ) then return false; end

	return HoloFriendsLists_IsListIndexValid(HF_list, HF_SelectedEntry);
end


function HoloFriends_DeselectEntry()
	HF_SelectedEntry = -1;
end


function HoloFriends_GetList()
	if ( not HoloFriends_Loaded ) then
		local list = {};
		return list;
	end

	return HF_list;
end


function HoloFriends_LoadList()
	-- get the correct list
	HF_list = HoloFriendsFuncs_LoadList(HOLOFRIENDS_LIST, UnitName("player"), HF_HFLIST);

	-- check if group "friends" is in our list
	if ( not HoloFriendsLists_ContainsGroup(HF_list, FRIENDS) ) then
		HFF_InsertNewEntry("1", FRIENDS);
	end

	-- check if group "search" is in our list
	if ( not HoloFriendsLists_ContainsGroup(HF_list, SEARCH) ) then
		HFF_InsertNewEntry("1", SEARCH);
		local index = HoloFriendsLists_ContainsGroup(HF_list, SEARCH);
		HF_list[index].search = "1";
	end

	-- set actual date in seconds to the friends group (indicator of last use)
	local idx = HoloFriendsLists_ContainsGroup(HF_list, FRIENDS);
	HF_list[idx].lastuse = time();

	-- check class in list (changed list entry with version 0.4)
	local maxi = table.getn(HF_list);
	for index = 1, maxi do
		local lc_class = HF_list[index].lc_class;
		local    class = HF_list[index].class;
		if ( class and not lc_class ) then
			HF_list[index].lc_class = class;
			HF_list[index].class = nil;
		end
	end
end

-- END OF GETTER


-- BEGIN OF ITEM TOOLTIP

function HoloFriends_NameButton_SetTooltip(self)
	local index = self:GetID();
	local name = HoloFriendsLists_GetName(HF_list, index, HF_DISPLAY);
	if ( not name ) then return; end

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");

	GameTooltip:SetText(name, 1.0, 1.0, 1.0);

	local realid = HoloFriendsLists_IsRealID(HF_list, index);
	if ( realid ) then
		local tname = HoloFriendsLists_GetToon(HF_list, index, true);
		if ( tname ) then GameTooltip:AddLine(tname, 1.0, 1.0, 1.0); end
	end

	if ( not HoloFriendsLists_IsGroup(HF_list, index) ) then
		local level = HoloFriendsLists_GetLevel(HF_list, index);
		local lc_class = HoloFriendsLists_GetLCClass(HF_list, index);
		local info = format(TEXT(HF_Level_Template), level, lc_class);
		GameTooltip:AddLine(info, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 0);
	end

	local note = HoloFriendsLists_GetComment(HF_list, index, HF_DISPLAY);
	if ( note ~= "" ) then
		GameTooltip:AddLine(note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	end

	if ( not HoloFriendsLists_IsGroup(HF_list, index) ) then
		local bcast = HoloFriendsLists_GetBCast(HF_list, index);
		if ( bcast ~= "" ) then
			GameTooltip:AddLine(HOLOFRIENDS_TOOLTIPBROADCAST, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
			GameTooltip:AddLine(bcast, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
		end

		local lastSeen = HoloFriendsLists_GetLastSeen(HF_list, index);
		if ( lastSeen == UNKNOWN ) then
			lastSeen = HOLOFRIENDS_TOOLTIPNEVERSEEN;
		else
			lastSeen = HoloFriendsFuncs_GetDateString(lastSeen, HOLOFRIENDS_OPTIONS.TTDateFormat);
			lastSeen = HOLOFRIENDS_TOOLTIPLASTSEEN..": "..lastSeen
		end
		GameTooltip:AddLine(lastSeen, 1.0, 1.0, 1.0, 0);

		local notify = HoloFriendsLists_GetNotify(HF_list, index);
		if ( realid and notify ) then
			local lastOnline = HoloFriendsLists_GetLastOnline(HF_list, index);
			if ( lastOnline == 0 ) then
				lastOnline = FRIENDS_LIST_ONLINE;
			else
				lastOnline = string.format(BNET_LAST_ONLINE_TIME, FriendsFrame_GetLastOnline(lastOnline));
			end
			GameTooltip:AddLine(lastOnline, 1.0, 1.0, 1.0, 0);
		end

		local area = HoloFriendsLists_GetArea(HF_list, index);
		if ( area and (area ~= "") ) then
			GameTooltip:AddLine(area, 1.0, 1.0, 1.0, 0);
		end
	end
	GameTooltip:Show();
end

-- END OF ITEM TOOLTIP


-- START OF GUI FUNCTIONS

-- drag and drop function
function HoloFriends_NameButton_OnDragStart(self)
	local index = self:GetID();

	local maxi = table.getn(HF_list);
	if ( index > maxi ) then return; end

	if ( HoloFriendsLists_IsGroup(HF_list, index) ) then return; end

	local name = HF_list[index].name;
	if ( name and string.sub(name,1,2) == "|K" ) then
		HF_SelectedEntry = index;
		if ( HF_list[index].btag ) then
			StaticPopup_Show("HOLOFRIENDS_GETREALIDNAMEBTAG", name);
		elseif ( HF_list[index].bnetid ) then
			StaticPopup_Show("HOLOFRIENDS_GETREALIDNAMEBNETID", name);
		end
		return;
	end

	HF_list[index].remove = nil;

	local cursorX, cursorY = GetCursorPosition();
	cursorX = cursorX / self:GetScale();
	cursorY = cursorY / self:GetScale();

	HF_Moving_Friend = HoloFriendsFrameNameButtonDrag;
	HF_Moving_Friend:SetID(index);
	HoloFriendsFrameNameButtonDragName:SetText(getglobal(self:GetName().."Name"):GetText());
	HF_Moving_Friend:ClearAllPoints();
	HF_Moving_Friend:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", cursorX+5, cursorY);
	HF_Moving_Friend:Show();
	HF_Moving_Friend:StartMoving();
end


-- drag and drop function
function HoloFriends_NameButton_OnDragStop()
	if ( not HF_Moving_Friend ) then return; end

	HF_Moving_Friend:StopMovingOrSizing();
	HF_Moving_Friend:Hide();
	HF_Moving_Friend:ClearAllPoints();

	if ( not HF_Target_Friend ) then return; end

	local targetIndex = HF_Target_Friend:GetID();
	if ( targetIndex > table.getn(HF_list) ) then
		targetIndex = table.getn(HF_list);
	end
	HF_list[HF_Moving_Friend:GetID()].group = HF_list[targetIndex].group;
	HF_Moving_Friend = nil;
	HoloFriends_chat("HoloFriends_List_Update from HoloFriends_NameButton_OnDragStop", HF_DEBUG_OUTPUT);
	HoloFriends_List_Update();

	-- update share window if open
	if ( HoloFriends_ShareFrame:IsVisible() ) then
		HoloFriendsShare_OnShow(HoloFriends_ShareFrame);
	end
end


-- if we clicked on a header, toggle state and select header, otherwise just select entry
function HoloFriends_NameButton_OnClick(self, button)
	HF_LastClicked = self:GetID();
	if ( not HF_LastClicked ) then return; end

	local maxi = table.getn(HF_list);
	if ( HF_LastClicked > maxi ) then return; end

	if ( button == "LeftButton" ) then
		HF_SelectedEntry = HF_LastClicked;
		-- group selected
		if ( HF_list[HF_SelectedEntry].name == "0" ) then
			HF_IsGroupSelected = true;
			HF_list[HF_SelectedEntry].name = "1";
		elseif ( HF_list[HF_SelectedEntry].name == "1" ) then
			HF_IsGroupSelected = true;
			HF_list[HF_SelectedEntry].name = "0";
		else
			-- player selected
			HF_IsGroupSelected = false;
			if ( not HoloFriendsLists_GetNotify(HF_list, HF_SelectedEntry) ) then
				local name = HoloFriendsLists_GetName(HF_list, HF_SelectedEntry);
				HoloFriendsFuncs_WhoCheckPlayer(name, HF_QUIET);
			end
		end
		HoloFriends_chat("HoloFriends_List_Update from HoloFriends_NameButton_OnClick", HF_DEBUG_OUTPUT);
		HoloFriends_List_Update();
	elseif ( button == "MiddleButton" ) then
		if ( HF_SelectedEntry == HF_LastClicked ) then
			HoloFriends_DeselectEntry();
			HF_IsGroupSelected = false;
		end
		if ( not HoloFriendsLists_GetNotify(HF_list, HF_LastClicked) ) then
			HF_list[HF_LastClicked].connected = nil;
		end
		HoloFriends_List_Update();
	else
		HoloFriends_ShowListDropdown(HF_LastClicked);
	end
end


function HoloFriends_CheckBox_OnClick(self)
	local index = self:GetParent():GetID();

	local maxi = table.getn(HF_list);
	if ( index > maxi ) then return; end

	-- RealID entries are always online checked, don't change
	if ( HF_list[index].realid ) then return; end

	if ( self:GetChecked() and GetNumFriends() == HF_Max_Server_Friends ) then
		self:SetChecked(nil);
		HoloFriendsFuncs_SystemMessage(HF_Limit_Alert);
	else
		if ( self:GetChecked() ) then
			PlaySound("igMainMenuOptionCheckBoxOff");
		else
			PlaySound("igMainMenuOptionCheckBoxOn");
		end
		HF_list[index].remove = nil;
		HoloFriendsLists_SetNotify(HF_list, index, self:GetChecked(), HF_UNQUIET, "RunUpdate", HoloFriends_EventFlags);
	end
end


function HoloFriends_ToggleButton_OnClick(self)
	if ( HF_AllGroupsShown ) then
		HF_AllGroupsShown = false;
		self:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	else
		HF_AllGroupsShown = true;
		self:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	end
	HoloFriendsLists_OpenAllGroups(HF_list, HF_AllGroupsShown);
	HoloFriends_List_Update();
end


-- start friends list update and check that it runs only once at time
function HoloFriends_List_Update()
	if ( not HoloFriends_Loaded ) then return; end

	-- skip HoloFriends_List_Update() at hide of FriendsFrame
	if ( HoloFriends_SkipListUpdate ) then
		HoloFriends_chat("HoloFriends_List_Update skipped (hide of FriendsFrame)", HF_DEBUG_OUTPUT);
		HoloFriends_SkipListUpdate = false;
		return;
	end

	-- request a new list update after a delay
	if ( HoloFriends_EventFlags.ListUpdateStartTime ~= HoloFriends_ListUpdateRefTime) then
		if ( time() < HoloFriends_EventFlags.ListUpdateStartTime + HoloFriends_ListUpdateMaxDelay ) then
			HF_Requested_List_Update = true;
			return;
		end
	end

	HoloFriends_chat("HoloFriends_List_Update start", HF_DEBUG_OUTPUT);

	HoloFriends_EventFlags.ListUpdateStartTime = time();

	-- remove all RealID friends without a clear name
	-- (real remove is done in HoloFriends_CheckLocalList)
	for index = 1, table.getn(HF_list) do
		local name = HF_list[index].name;
		if ( name and string.sub(name,1,2) == "|K" ) then
			HF_list[index].name = nil;
		end
	end

	-- if faction wide friends list is used, the server list needs to be cleared first, to add local entries (friends list limit)
	local NotFaction = HoloFriendsFuncs_IsCharDataAvailable(HOLOFRIENDS_LIST, UnitName("player"));
	HF_FriendListContinue = true;
	if ( NotFaction ) then
		HoloFriends_EventFlags.RunListUpdate = "RunLocal";
	else
		HoloFriends_EventFlags.RunListUpdate = "RunServer";
	end
end


-- check the local list
function HoloFriends_CheckLocalList()
	HoloFriends_chat("HoloFriends_CheckLocalList start", HF_DEBUG_OUTPUT);

	HoloFriends_EventFlags.ListUpdateStartTime = time();

	-- check if group "friends" is in our list
	if ( not HoloFriendsLists_ContainsGroup(HF_list, FRIENDS) ) then
		HFF_InsertNewEntry("1", FRIENDS);
	end

	local index = next(HF_list);
	while ( index and HF_list[index] ) do
		if ( not HF_list[index].name ) then
			table.remove(HF_list, index);
		else
			if ( not HF_list[index].group ) then
				HF_list[index].group = FRIENDS;
			end

			-- set friends online, which were added by sharing
			if ( HF_list[index].imported ) then
				HF_list[index].imported = nil;
				if ( HF_list[index].realid ) then
					-- RealID friends are only added to the friends list of a char if they are online
					HF_list[index].notify = nil;
				else
					local notify = (GetNumFriends() < HF_Max_Server_Friends);
					HoloFriendsLists_SetNotify(HF_list, index, notify, HF_UNQUIET, "RunLocal", HoloFriends_EventFlags);
					return;
				end
			end

			-- set note online, which were created by sharing
			if ( HF_list[index].setnote ) then
				HF_list[index].setnote = nil;
				local comment = HF_list[index].comment;
				HoloFriendsLists_SetComment(HF_list, index, comment, HF_HFLIST, HF_SHARE);
			end

			-- remove wrong level entries
			local level = HF_list[index].level;
			if ( level and (level == UNKNOWN or level == 0 or level == "") ) then
				HF_list[index].level = nil;
			end

			-- remove empty and UNKNOWN fields (some time area is an empty string and one can share old data)
			if ( HF_list[index].area == "" )          then HF_list[index].area     = nil; end
			if ( HF_list[index].area == UNKNOWN )     then HF_list[index].area     = nil; end
			if ( HF_list[index].lc_class == "" )      then HF_list[index].lc_class = nil; end
			if ( HF_list[index].lc_class == UNKNOWN ) then HF_list[index].lc_class = nil; end
			if ( HF_list[index].class == "" )         then HF_list[index].class    = nil; end
			if ( HF_list[index].class == UNKNOWN )    then HF_list[index].class    = nil; end

			-- check if the class entry is valid
			if ( HF_list[index].class ) then
				if ( not HF_Class_Icon_Tcoords[HF_list[index].class] ) then
					HF_list[index].class = nil;
					HF_list[index].lc_class = nil;
				end
			end

			-- try to set class from lc_class
			if ( HF_list[index].lc_class and not HF_list[index].class ) then
				HF_list[index].class = HFF_GetClassFromLCClass(HF_list[index].lc_class);
			end

			-- remove list entry of temporary added friend
			local tmpadd = HF_list[index].tmpadd;
			local tmpremove = false;
			if ( tmpadd and not HF_list[index].notify ) then
				if ( time() > tmpadd + HF_Friends_TmpAdd_Delay ) then tmpremove = true; end
			end
			if ( tmpremove ) then
				table.remove(HF_list, index);
			else
				index = next(HF_list, index);
			end
		end
	end

	-- set actual date in seconds to the friends group (indicator of last use)
	local index = HoloFriendsLists_ContainsGroup(HF_list, FRIENDS)
	HF_list[index].lastuse = time();

	local NotFaction = HoloFriendsFuncs_IsCharDataAvailable(HOLOFRIENDS_LIST, UnitName("player"));
	HF_FriendListContinue = true;
	if ( NotFaction ) then
		HoloFriends_EventFlags.RunListUpdate = "RunServer";
	else
		HoloFriends_EventFlags.RunListUpdate = "RunShow";
	end
end


-- check if all entries in server friendslist are in our list
local HF_ServerListStart = 1;
function HoloFriends_CheckServerList()
	HoloFriends_chat("HoloFriends_CheckServerList start", HF_DEBUG_OUTPUT);

	local start_time = HoloFriends_Time;
	HoloFriends_EventFlags.ListUpdateStartTime = time();

	local NotFaction = HoloFriendsFuncs_IsCharDataAvailable(HOLOFRIENDS_LIST, UnitName("player"));
	local numNotifyFriends = GetNumFriends();
	local numRealIDFriends = BNGetNumFriends();

	-- init the notify flag of all online friends (notify = 3 is friend check in progress)
	if ( HF_ServerListStart == 1 ) then
		local maxi = table.getn(HF_list);
		for index = 1, maxi do
			if ( HF_list[index].notify and (HF_list[index].notify ~= 3) ) then
				if ( not HF_list[index].realid ) then
					HF_list[index].notify = 2;
				else
					HF_list[index].notify = nil;
				end
			end
		end
	end

	-- init variables for data, which we get from the server
	local name, tname, client, rname, faction, level, lc_class, area, connected, realid;
	local onstate; -- AFK or DND
	local note; -- Friends note
	local bcast; -- RealFriends broadcast message
	local bnetid; -- bnetIDAccount = looks like a count of realID friends (not sure if this is a fixed ID)
	local bname; -- presenceName = battleNet real player name (realID friend)
	local btag; -- battleTag = battleTag name of the player (no realID friend)
	local playerIndex;

	-- check if all friends are in our list
	local idx1 = HF_ServerListStart;
	HF_ServerListStart = 1;
	for idx = idx1, numNotifyFriends + numRealIDFriends do
		local index = idx;
		if ( idx > numRealIDFriends ) then index = idx - numRealIDFriends; end
		local class = UNKNOWN;
		if ( idx <= numRealIDFriends ) then
			local isBattleTag, tID, lastOn, isAFK, isDND, isRIDFriend, msgTime, canSoR;
			bnetid, bname, btag, isBattleTag, tname, tID, client, connected, lastOn, isAFK, isDND, bcast, note, isRIDFriend, msgTime, canSoR = BNGetFriendInfo(index);
			if ( bname or btag ) then
				-- check if we have this RealID friend already in our list
				name = HoloFriendsLists_FindPresenceIDName(HF_list, btag, bnetid);
				if ( not name ) then name = bname; end
				if ( not name ) then name = btag; end
			else name = nil; end
			if     ( isAFK ) then onstate = "<AFK>";
			elseif ( isDND ) then onstate = "<DND>";
			else                  onstate = nil; end
			if ( not note ) then note = ""; end
			if ( client and (client == "S2") ) then client = "SC2"; end
			if ( connected ) then
				local hasFocus, toonName, client, realmID, race, guild, gameText;
				hasFocus, toonName, client, rname, realmID, faction, race, lc_class, guild, area, level, gameText = BNGetGameAccountInfo(tID);
				if ( faction == PLAYER_FACTION_GROUP[0]) then faction = 0; end
				if ( faction == PLAYER_FACTION_GROUP[1]) then faction = 1; end
				if ( faction and (type(faction) ~= "number" or ((faction ~= 0) and (faction ~= 1))) ) then faction = -1; end
				if ( level and (level == "") ) then level = nil; end
			else
				onstate = lastOn;
			end
			realid = true;
		else
			tname, client, rname, faction, lastOn, bcast, bnetid, bname, btag = nil, nil, nil, nil, nil, nil, nil, nil;
			realid = false;
			name, level, lc_class, area, connected, onstate, note = GetFriendInfo(index);
			if ( onstate and (onstate == "") ) then onstate = nil; end
			if ( not note ) then note = ""; end
		end

		if ( (connected == 1) or (connected == true) ) then connected = true; else connected = nil; end

		-- reset who-timer independet of message hook
		if ( GetTime() > HoloFriends_interceptWhoResults + HoloFriends_whoCheckInterval ) then
			HoloFriends_interceptWhoResults = 0;
		end

		-- check if player is already in our list or need to be added
		playerIndex = HoloFriendsLists_ContainsPlayer(HF_list, name);
		if ( playerIndex ) then
			if ( not (realid and connected) ) then class = HF_list[playerIndex].class; end
			if ( not class ) then class = UNKNOWN; end

			if ( not connected ) then lc_class = HF_list[playerIndex].lc_class; end
			if ( not lc_class ) then lc_class = UNKNOWN; end

			-- look for lc_class in list to set class
			if ( (lc_class ~= UNKNOWN) and (class == UNKNOWN) ) then
				class = HFF_GetClassFromLCClass(lc_class, UNKNOWN);
			end

			if ( not area ) then area = UNKNOWN; end

			if ( class    ~= UNKNOWN )       then HF_list[playerIndex].class    = class;    end
			if ( lc_class ~= UNKNOWN )       then HF_list[playerIndex].lc_class = lc_class; end
			if ( area     ~= UNKNOWN )       then HF_list[playerIndex].area     = area;     end
			if ( level   and (level ~= 0) )  then HF_list[playerIndex].level    = level;    end
			if ( tname   and (tname ~= "") ) then HF_list[playerIndex].toon     = tname;    end
			if ( rname   and (rname ~= "") ) then HF_list[playerIndex].realm    = rname;    end
			if ( faction )                   then HF_list[playerIndex].faction  = faction;  end
			if ( bcast   and (bcast ~= "") ) then HF_list[playerIndex].bcast    = bcast;
							 else HF_list[playerIndex].bcast    = nil;      end
			if ( client )                    then HF_list[playerIndex].client   = client;   end
			if ( realid )                    then HF_list[playerIndex].realid   = realid;   end
			if ( bname )                     then HF_list[playerIndex].bname    = bname;    end

			if ( HF_list[playerIndex].warn and connected and not HF_list[playerIndex].connected ) then
				message(format(TEXT(ERR_FRIEND_ONLINE_SS),name,name));
			end
			HF_list[playerIndex].connected = connected;
			if ( connected ) then
				HF_list[playerIndex].onstate = onstate;
				HF_list[playerIndex].lastSeen = date("%Y-%m-%d %H:%M %w");
			elseif ( realid ) then
				HF_list[playerIndex].onstate = onstate;
			else
				HF_list[playerIndex].onstate = nil;
			end

			if ( NotFaction ) then
				-- remove player scan mark and add friend permanent
				local tmpadd = HF_list[playerIndex].tmpadd;
				if ( tmpadd ) then
					if ( time() > tmpadd + HF_Friends_TmpAdd_Delay ) then
						HF_list[playerIndex].tmpadd = nil;
						tmpadd = false;
					end
				end

				if ( not tmpadd ) then
					-- setup a who request to get the class if still unknown
					if ( connected and (class == UNKNOWN) and not realid ) then
						HoloFriendsFuncs_WhoCheckPlayer(name, HF_QUIET);
					end

					if ( HF_list[playerIndex].notify and (HF_list[playerIndex].notify == 3) ) then
						HoloFriends_chat("HoloFriends_CheckServerList SetNotify 3", HF_DEBUG_OUTPUT);
						HoloFriendsLists_SetNotify(HF_list, playerIndex, HF_OFFLINE, HF_QUIET, "RunServer", HoloFriends_EventFlags);
						return;
					else
						HF_list[playerIndex].notify = HF_ONLINE;
					end
				end
			elseif ( not HF_list[playerIndex].notify and not realid ) then
				-- setup a who request to get the class if still unknown
				if ( connected and (class == UNKNOWN) ) then HoloFriendsFuncs_WhoCheckPlayer(name, HF_QUIET); end

				HoloFriends_chat("HoloFriends_CheckServerList SetNotify off", HF_DEBUG_OUTPUT);
				HoloFriendsLists_SetNotify(HF_list, playerIndex, HF_OFFLINE, HF_UNQUIET, "RunServer", HoloFriends_EventFlags);
				return;
			else
				-- setup a who request to get the class if still unknown
				if ( connected and (class == UNKNOWN) and not realid ) then
					HoloFriendsFuncs_WhoCheckPlayer(name, HF_QUIET);
				end

				HF_list[playerIndex].notify = HF_ONLINE; -- to change old list style entries from "1" to "true"
			end

			-- check and sync online note and list comment
			HoloFriendsFuncs_CheckComment(playerIndex, index, note);
		elseif ( name and (name ~= "") ) then
			if ( name == UNKNOWN ) then
				if ( not NotFaction ) then HF_Requested_List_Update = true; end
			elseif ( realid ) then
				-- lock for lc_class in list to set class
				if ( lc_class and (lc_class ~= UNKNOWN) and (class == UNKNOWN) ) then
					class = HFF_GetClassFromLCClass(lc_class, UNKNOWN);
				end

				HFF_InsertNewEntry(name, nil, level, class, lc_class, area, note, connected, onstate, HF_ONLINE, realid, tname, rname, faction, client, bcast, bnetid, bname, btag);
			elseif ( NotFaction ) then
				-- lock for lc_class in list to set class
				if ( lc_class and (lc_class ~= UNKNOWN) and (class == UNKNOWN) ) then
					class = HFF_GetClassFromLCClass(lc_class, UNKNOWN);
				end

				HFF_InsertNewEntry(name, nil, level, class, lc_class, area, note, connected, onstate, HF_ONLINE);

				-- temporary add timestamp in seconds
				-- to allow player scan by adding und removing from friends list by other addons
				playerIndex = HoloFriendsLists_ContainsPlayer(HF_list, name);
				if ( playerIndex ) then HF_list[playerIndex].tmpadd = time(); end
			else
				-- not added by HoloFriends, so remove entry from server list
				HoloFriends_EventFlags.Name = name;
				HoloFriends_EventFlags.RunListUpdate = "RunServer";
				HoloFriends_EventFlags.Quiet = HF_UNQUIET;
				local done = HoloFriendsFuncs_RemoveFromServerList(HoloFriends_EventFlags);
				if ( done ) then
					HoloFriends_chat("HoloFriends_CheckServerList RemoveFromServerList", HF_DEBUG_OUTPUT);
					return;
				end
			end
		end

		-- check run time to prevent time out error (max. run time in combat is 100ms)
		if ( HoloFriends_Time > start_time + 60 ) then
			HF_FriendListContinue = true;
			HoloFriends_EventFlags.RunListUpdate = "RunServer";
			HF_ServerListStart = idx + 1;
			HoloFriends_chat("HoloFriends_CheckServerList Re-submit", HF_DEBUG_OUTPUT);
			return;
		end
	end

	-- check if all online friends are still there
	local maxi = table.getn(HF_list);
	for index = 1, maxi do
		if ( HF_list[index].notify and (HF_list[index].notify == 3) ) then
			local HFmsg = format(TEXT(HOLOFRIENDS_MSGFRIENDMISSINGONLINE), HF_list[index].name);
			HoloFriendsFuncs_SystemMessage(HFmsg);
			HF_list[index].notify = HF_OFFLINE;
		end
		if ( HF_list[index].notify and (HF_list[index].notify == 2) ) then
			local silent = false;
			if ( NotFaction ) then silent = true; end
			HoloFriends_chat("HoloFriends_CheckServerList Re-add", HF_DEBUG_OUTPUT);
			HoloFriendsLists_SetNotify(HF_list, index, 3, silent, "RunServer", HoloFriends_EventFlags);
			return;
		end
	end

	-- sort the entries
	table.sort(HF_list, HoloFriendsFuncs_CompareEntry);

	HF_FriendListContinue = true;
	if ( NotFaction ) then
		HoloFriends_EventFlags.RunListUpdate = "RunShow";
	else
		HoloFriends_EventFlags.RunListUpdate = "RunLocal";
	end
end


-- the option can be true/false or a number from 1 to 4
local HF_bcount;
local function HFF_SetupButton(option, button, count)
	if ( option ) then
		count = count + 1;
		local posID;
		if ( type(option) == "boolean" ) then
			HF_bcount = HF_bcount + 1;
			posID = HF_bcount;
		else
			posID = option;
		end
		button:ClearAllPoints();
		if ( posID == 1 ) then button:SetPoint("TOPLEFT", HoloFriendsFrameOnline, "BOTTOMLEFT",  -6, -3); end
		if ( posID == 2 ) then button:SetPoint("TOPLEFT", HoloFriendsFrameOnline, "BOTTOMLEFT", 190, -3); end
		if ( posID == 3 ) then button:SetPoint("TOPLEFT", HoloFriendsFrameOnline, "BOTTOMLEFT",  -6, -28); end
		if ( posID == 4 ) then button:SetPoint("TOPLEFT", HoloFriendsFrameOnline, "BOTTOMLEFT", 190, -28); end
		button:Show();
	else
		button:Hide();
	end
	return count
end


local function HFF_SetLayout()
	HF_bcount = 0;
	-- count and show active buttons
	local bcount = 0;
	bcount = HFF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonFLWhisper,    HoloFriendsFrame_WhisperButton,      bcount)
	bcount = HFF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonFLInvite,     HoloFriendsFrame_InviteButton,       bcount)
	bcount = HFF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonFLAddComment, HoloFriendsFrameAddCommentButton,    bcount)
	bcount = HFF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonFLAddFriend,  HoloFriendsFrame_AddFriendButton,    bcount)
	bcount = HFF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonFLAddGroup,   HoloFriendsFrameAddGroupButton,      bcount)
	bcount = HFF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonFLRenGroup,   HoloFriendsFrameRenameGroupButton,   bcount)
	bcount = HFF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonFLRmFriend,   HoloFriendsFrame_RemoveFriendButton, bcount)
	bcount = HFF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonFLRmGroup,    HoloFriendsFrameRemoveGroupButton,   bcount)
	bcount = HFF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonFLWho,        HoloFriendsFrame_WhoButton,          bcount)

	-- setup the background layout
	local ltex = getglobal("HoloFriendsFrameBottomLeft");
	local rtex = getglobal("HoloFriendsFrameBottomRight");
	if ( bcount > 2 ) then
		ltex:SetTexture([[Interface\FriendsFrame\UI-FriendsFrame-BotLeft]]);
		rtex:SetTexture([[Interface\FriendsFrame\UI-FriendsFrame-BotRight]]);
	elseif ( bcount > 0 ) then
		ltex:SetTexture([[Interface\FriendsFrame\IgnoreFrame-BotLeft]]);
		rtex:SetTexture([[Interface\FriendsFrame\IgnoreFrame-BotRight]]);
	else  -- alternative use the TAXIFRAME\UI-TaxiFrame-BotLeft
		ltex:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-General-BottomLeft]]);
		rtex:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-General-BottomRight]]);
	end

	-- setup HoloFriendsFrameOnline, HoloFriendsFrame_TurnInfoButton, and HoloFriendsFrameShareButton
	if ( bcount > 2 ) then HoloFriendsFrameShareButton:Show(); else HoloFriendsFrameShareButton:Hide(); end
	if ( bcount > 0 ) then HoloFriendsFrame_TurnInfoButton:Show(); else HoloFriendsFrame_TurnInfoButton:Hide(); end
	HoloFriendsFrameOnline:ClearAllPoints();
	if ( bcount > 2 ) then
		HoloFriendsFrameOnline:SetPoint("TOPLEFT", HoloFriendsFrameTopLeft, "TopLEFT", 22, -367);
	elseif ( bcount > 0 ) then
		HoloFriendsFrameOnline:SetPoint("TOPLEFT", HoloFriendsFrameTopLeft, "TopLEFT", 22, -392);
	else
		HoloFriendsFrameOnline:SetPoint("TOPLEFT", HoloFriendsFrameTopLeft, "TopLEFT", 22, -417);
	end

	-- enable/disable buttons at bottom of friends of ignore list frame
	if ( HoloFriends_IsSelectedEntryValid() ) then
		if ( HoloFriendsLists_IsGroup(HF_list, HF_SelectedEntry) ) then
			if ( HoloFriendsLists_GetGroup(HF_list, HF_SelectedEntry) ~= FRIENDS ) then
				HoloFriendsFrameRenameGroupButton:Enable();
				HoloFriendsFrameRemoveGroupButton:Enable();
			else
				HoloFriendsFrameRenameGroupButton:Disable();
				HoloFriendsFrameRemoveGroupButton:Disable();
			end
			HoloFriendsFrame_RemoveFriendButton:Disable();
			HoloFriendsFrame_WhisperButton:Disable();
			HoloFriendsFrame_WhoButton:Disable();
		else
			HoloFriendsFrameRenameGroupButton:Disable();
			HoloFriendsFrameRemoveGroupButton:Disable();
			HoloFriendsFrame_RemoveFriendButton:Enable();
			if ( HoloFriendsLists_IsConnected(HF_list, HF_SelectedEntry) ) then
				HoloFriendsFrame_WhisperButton:Enable();
				HoloFriendsFrame_WhoButton:Enable();
			else
				HoloFriendsFrame_WhisperButton:Disable();
				if ( HOLOFRIENDS_OPTIONS.DisableWho and not HoloFriendsLists_GetNotify(HF_list, HF_SelectedEntry) ) then
					HoloFriendsFrame_WhoButton:Enable();
				else
					HoloFriendsFrame_WhoButton:Disable();
				end
			end
		end
		if ( HoloFriendsLists_IsConnected(HF_list, HF_SelectedEntry) or (HF_list[HF_SelectedEntry].numonline and HF_list[HF_SelectedEntry].numonline > 0) ) then
			HoloFriendsFrame_InviteButton:Enable();
		else
			HoloFriendsFrame_InviteButton:Disable();
		end
		HoloFriendsFrameAddCommentButton:Enable();
	else
		HoloFriendsFrame_WhisperButton:Disable();
		HoloFriendsFrame_InviteButton:Disable();
		HoloFriendsFrameAddCommentButton:Disable();
		HoloFriendsFrameRenameGroupButton:Disable();
		HoloFriendsFrameRemoveGroupButton:Disable();
		HoloFriendsFrame_RemoveFriendButton:Disable();
		HoloFriendsFrame_WhoButton:Disable();
	end

	return bcount;
end


-- update scrollframe & buttons
function HoloFriends_UpdateFriendsList()
	HoloFriends_EventFlags.ListUpdateStartTime = time();

	local maxi = table.getn(HF_list);
	if ( HoloFriends_ShowOnlineChat ) then
		HoloFriends_ShowOnlineChat = false;
		HoloFriends_chat(HOLOFRIENDS_INITSHOWONLINEATLOGIN, 0.0, 1.0, 1.0);
		for index = 1, maxi do
			if ( HF_list[index].connected ) then
				local name = HoloFriendsLists_GetName(HF_list, index, HF_DISPLAY);
				local level = HoloFriendsLists_GetLevel(HF_list, index);
				local lc_class = HoloFriendsLists_GetLCClass(HF_list, index);
				local msg = name.." "..format(TEXT(HF_Level_Template), level, lc_class);
				HoloFriends_chat(msg, 0.0, 1.0, 1.0);
			end
		end
	end

	-- run only, if window is visible
	if ( not HoloFriendsFrame:IsVisible() ) then
		HoloFriends_EventFlags.ListUpdateStartTime = HoloFriends_ListUpdateRefTime;
		if ( HF_Requested_List_Update ) then
			HF_Requested_List_Update = false;
			HoloFriends_List_Update();
		end
		return;
	end

	HoloFriends_chat("HoloFriends_UpdateFriendsList start", HF_DEBUG_OUTPUT);

	-- get some counter
	local notifyCounter = GetNumFriends() + BNGetNumFriends();
	local onlineCounter = 0;
	local sumCounter = 0;
	local groupIndex;
	for index = 1, maxi do
		if ( (HF_list[index].name ~= "0") and (HF_list[index].name ~= "1") ) then
			sumCounter = sumCounter + 1;
			if ( HF_list[index].connected ) then
				onlineCounter = onlineCounter + 1;
			end
		end
		if ( (HF_list[index].name == "0") or (HF_list[index].name == "1") ) then
			groupIndex = index;
			HF_list[groupIndex].numonline = 0;
		else
			if ( HF_list[index].connected ) then
				HF_list[groupIndex].numonline = HF_list[groupIndex].numonline + 1;
			end
		end
	end

	-- setup the buttons at the bottom of the friends frame
	local bcount = HFF_SetLayout();

	-- set the number of shown friends (hide unused buttons)
	if ( bcount > 2 ) then HoloFriends_nDisplayedNames = HoloFriends_maxDisplayedNames - 3;
	elseif ( bcount > 0 ) then HoloFriends_nDisplayedNames = HoloFriends_maxDisplayedNames - 2 ;
	else HoloFriends_nDisplayedNames = HoloFriends_maxDisplayedNames; end
	for n = HoloFriends_nDisplayedNames + 1, HoloFriends_maxDisplayedNames do
		getglobal("HoloFriendsFrameNameButton"..n):Hide();
	end

	-- get visible index table
	local ShownIndexTable = {};
	ShownIndexTable = HoloFriendsFuncs_ShownListTab(HF_list, HoloFriends_nDisplayedNames, HF_HFLIST);
	-- get counter of visible elements from index table
	local visibleCnt = HoloFriendsFuncs_GetNumVisibleListElements(ShownIndexTable, maxi, HoloFriends_nDisplayedNames);

	-- ScrollFrame stuff
	local ScrollBarSize = 0;
	if ( visibleCnt > HoloFriends_nDisplayedNames ) then ScrollBarSize = 20; end
	local ssize;
	if ( bcount > 2 ) then ssize = 304;
	elseif ( bcount > 0 ) then ssize = 329;
	else ssize = 354; end
	HoloFriendsFrameScrollFrame:SetHeight(ssize);
	FauxScrollFrame_Update(HoloFriendsFrameScrollFrame, visibleCnt, HoloFriends_nDisplayedNames, 16);
	-- scrollframe offset
	local offset = FauxScrollFrame_GetOffset(HoloFriendsFrameScrollFrame);

	-- button and textures
	local button, buttonText, buttonTextRemove, buttonIcon, buttonCheckBox;

	local entry = {};
	local line = 1;

	-- set values / textures for all buttons
	while ( line <= HoloFriends_nDisplayedNames ) do
		local index = ShownIndexTable[line + offset];

		entry = HF_list[index];

		button = getglobal("HoloFriendsFrameNameButton"..line);
		button:SetID(index);

		if ( line > visibleCnt ) then button:Hide();
					 else button:Show(); end

		if ( entry ) then
			if ( index == HF_SelectedEntry ) then button:LockHighlight();
							 else button:UnlockHighlight(); end

			-- get textfield, icon, and checkbox
			buttonText = getglobal("HoloFriendsFrameNameButton"..line.."Name");
			buttonTextRemove = getglobal("HoloFriendsFrameNameButton"..line.."NameRemove");
			buttonIcon = getglobal("HoloFriendsFrameNameButton"..line.."ClassIcon");
			buttonWait = getglobal("HoloFriendsFrameNameButton"..line.."WaitIcon");
			buttonCheckBox = getglobal("HoloFriendsFrameNameButton"..line.."Server");

			-- group entry ?
			if ( entry.name == "1" or entry.name == "0" ) then
				local name = HoloFriendsLists_GetName(HF_list, index, HF_DISPLAY);
				if ( HOLOFRIENDS_OPTIONS.GroupsShowOnline and (HF_list[index].numonline ~= 0) ) then
					name = name.." ("..HF_list[index].numonline..")"
				end
				buttonText:SetText(name);
				buttonTextRemove:SetText("");
				buttonText:ClearAllPoints();
				buttonText:SetPoint("TOPLEFT", "HoloFriendsFrameNameButton"..line, "TOPLEFT", 20, 0);
				buttonIcon:Hide();
				buttonCheckBox:Hide();

				if ( entry.name == "1" ) then
					button:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				else
					button:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				end
			else -- no, we got a player
				local textwidth;
				local showColor = HOLOFRIENDS_OPTIONS.ShowClassColor;
				local showToon  = HOLOFRIENDS_OPTIONS.BNShowCharName;
				local name = HoloFriendsLists_GetName(HF_list, index, HF_DISPLAY, showColor, showToon);
				local level = "";
				if ( HOLOFRIENDS_OPTIONS.ShowLevel ) then
					level = " ("..HoloFriendsLists_GetLevel(HF_list, index)..")";
				end
				local area = HoloFriendsLists_GetArea(HF_list, index, true);
				local note = HoloFriendsLists_GetComment(HF_list, index, HF_DISPLAY);
				local bcast = HoloFriendsLists_GetBCast(HF_list, index);
				local info;
				if     ( HOLOFRIENDS_TURNINFO == 0 ) then info = area;
				elseif ( HOLOFRIENDS_TURNINFO == 1 ) then info = note;
				else				          info = bcast; end
				if ( entry.remove ) then
					buttonText:SetText(name);
					textwidth = buttonText:GetStringWidth();
				end
				if ( entry.connected ) then
					buttonText:SetText(format(TEXT(HF_List_Online_Template), name, level, info));
				else
					buttonText:SetText(format(TEXT(HF_List_Offline_Template), name, level, info));
				end
				if ( entry.remove ) then
					buttonTextRemove:SetText("|cffffffff_____________________________________|r");
					buttonTextRemove:SetWidth(textwidth + 10);
				else
					buttonTextRemove:SetText("");
				end
				button:SetNormalTexture("");
				buttonCheckBox:Show();
				buttonCheckBox:SetChecked(entry.notify);
				if ( entry.warn ) then
					buttonWait:Show();
				else
					buttonWait:Hide();
				end
				local class = entry.class;
				if ( HOLOFRIENDS_OPTIONS.ShowClassIcons ) then
					local coords;
					if ( class and (class ~= UNKNOWN) ) then
						coords = HF_Class_Icon_Tcoords[class];
					end
					if ( coords ) then
						buttonIcon:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
					else
						buttonIcon:SetTexCoord(0.5, 0.75, 0.5, 0.75);
					end
					buttonIcon:Show();
					buttonText:ClearAllPoints();
					buttonText:SetPoint("LEFT", buttonIcon:GetName(), "RIGHT", 3, 0);
				else
					buttonText:ClearAllPoints();
					buttonText:SetPoint("TOPLEFT", "HoloFriendsFrameNameButton"..line, "TOPLEFT", 36, 0);
					buttonIcon:Hide();
				end
			end

			-- Set the button text with
			button:SetWidth(315 - ScrollBarSize);
			if ( buttonIcon:IsShown() ) then buttonText:SetWidth(260 - ScrollBarSize);
						    else buttonText:SetWidth(276 - ScrollBarSize); end
		end

		line = line + 1;
	end

	HoloFriendsFrameOnline:SetText(format("%s %d / %d (%d)", HOLOFRIENDS_WINDOWMAINNUMBERONLINE, onlineCounter, sumCounter, notifyCounter));

	HoloFriends_chat("HoloFriends_UpdateFriendsList end", HF_DEBUG_OUTPUT);

	HoloFriends_EventFlags.ListUpdateStartTime = HoloFriends_ListUpdateRefTime;
	if ( HF_Requested_List_Update ) then
		HF_Requested_List_Update = false;
		HoloFriends_List_Update();
	end
end

-- END OF GUI FUNCTIONS
