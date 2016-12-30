--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file manages the ignorelist

]]


-- flags to skip HoloIgnore_List_Update()
HoloIgnore_EventFlags = {};
HoloIgnore_EventFlags.Type = "IL";
HoloIgnore_EventFlags.Quiet = false;
HoloIgnore_EventFlags.Name = "";
HoloIgnore_EventFlags.RunListUpdate = "";
HoloIgnore_EventFlags.TimeStep = 0;
HoloIgnore_EventFlags.ListUpdateStartTime = 0;
HoloIgnore_EventFlags.SetNotify = false;
HoloIgnore_EventFlags.IgnoreAddSysMsg = false;
HoloIgnore_EventFlags.IgnoreRemoveSysMsg = false;

-- flag to skip HoloIgnore_List_Update() at hide of IgnoreFrame
HoloIgnore_SkipListUpdate = false;

-- flag to run every list update step seperately to prevent time out error
local HI_IgnoreListContinue = false;

-- flag to update the list again
local HI_Requested_List_Update = false;

local HI_Max_Server_Ignore = 50;
HoloIgnore_nDisplayedNames = 18;
HoloIgnore_maxDisplayedNames = 21;

local HI_AllGroupsShown = true;

local HI_IsGroupSelected = false;
local HI_SelectedEntry = -1;
local HI_LastClicked = -1;

local HI_list = {};
local HI_Moving_Ignore = nil;
local HI_Target_Ignore = nil;

local HI_List_Template = "%1$s: |cffffffff%2$s|r";
local HI_Limit_Alert = string.gsub(HOLOFRIENDS_MSGIGNORELIMITALERT, "%%d", HI_Max_Server_Ignore);

-- Update background texture if window become visible
local HI_Window_Visible = false;


-- create and insert a new ignore entry
local function HIF_InsertNewEntry(name, group, note, notify)
	if ( not name or name == "" ) then return nil; end

	local temp = {};
	temp.name = name;
	if ( not group or group == "" ) then
		temp.group = IGNORE;
	else
		temp.group = group;
	end
	if ( notify ) then temp.notify = notify; end

	-- get comment from friends list if there is any
	local list = HoloFriends_GetList();
	local wasFriend = HoloFriendsLists_ContainsPlayer(list, name);
	local friends_note;
	if ( wasFriend ) then friends_note = HoloFriendsLists_GetComment(list, wasFriend); end

	-- set comment from ignore list if no note
	if ( note and (note ~= "") ) then temp.comment = note; end
	HoloFriendsFuncs_MergeComment(temp, friends_note, 0, true, false);

	table.insert(HI_list, temp);
end


-- event handling

local function HI_SearchWindowToHide(window)
	for index = 1, STATICPOPUP_NUMDIALOGS do
		local frame = getglobal("StaticPopup"..index);
		if ( frame:IsVisible() and (frame.which == window) ) then
			frame:Hide();
		end
	end
end

function HoloIgnore_OnEvent(self, event, ...)
	if ( event == "VARIABLES_LOADED" ) then
		self:UnregisterEvent("VARIABLES_LOADED");
		self:RegisterEvent("IGNORELIST_UPDATE");
		self:RegisterEvent("DUEL_REQUESTED");
		self:RegisterEvent("GUILD_INVITE_REQUEST");
		self:RegisterEvent("PETITION_SHOW");
		self:RegisterEvent("PARTY_INVITE_REQUEST");
	end

	if ( event == "IGNORELIST_UPDATE" ) then
		if ( HoloIgnore_EventFlags.SetNotify ) then
			if ( HoloIgnore_EventFlags.RunListUpdate ~= "" ) then
				HoloFriendsFuncs_CheckRunListUpdate(HoloIgnore_EventFlags);
				return;
			else
				HoloIgnore_EventFlags.SetNotify = false;
			end

		end
		HoloFriends_chat("HoloIgnore_List_Update on event IGNORELIST_UPDATE", HF_DEBUG_OUTPUT);
		HoloIgnore_List_Update();
	end

	-- Filter to ignore some requests from offline ignores
	if ( event == "DUEL_REQUESTED" ) then
		local name = ...
		local index = HoloFriendsLists_ContainsPlayer(HI_list, name);
		if ( index and not HI_list[index].notify ) then
			CancelDuel();
			HI_SearchWindowToHide("DUEL_REQUESTED");
			HoloFriends_chat(format(HOLOFRIENDS_MSGIGNOREDUEL, name));
		end
	end

	if ( event == "GUILD_INVITE_REQUEST" ) then
		local name = ...
		local index = HoloFriendsLists_ContainsPlayer(HI_list, name);
		if ( index and not HI_list[index].notify ) then
			DeclineGuild();
			HI_SearchWindowToHide("GUILD_INVITE");
			HoloFriends_chat(format(HOLOFRIENDS_MSGIGNOREINVITEGUILD, name));
		end
	end

	if ( event == "PETITION_SHOW" ) then
		local type, _, _, _, name  = GetPetitionInfo();
		if ( petitionType == "guild" ) then
			local index = HoloFriendsLists_ContainsPlayer(HI_list, name);
			if ( index and not HI_list[index].notify ) then
				ClosePetition();
				HoloFriends_chat(format(HOLOFRIENDS_MSGIGNORESIGNGUILD, name));
			end
		end
	end

	if ( event == "PARTY_INVITE_REQUEST" ) then
		local name = ...
		local index = HoloFriendsLists_ContainsPlayer(HI_list, name);
		if ( index and not HI_list[index].notify ) then
			DeclineGroup();
			HI_SearchWindowToHide("PARTY_INVITE");
			HoloFriends_chat(format(HOLOFRIENDS_MSGIGNOREPARTY, name));
		end
	end
end


function HoloIgnore_OnUpdate()
	if ( HI_Moving_Ignore ) then
		local slot;
		HI_Target_Ignore = nil;
		for index = 1, HoloIgnore_nDisplayedNames, 1 do
			slot = getglobal("HoloIgnoreFrameNameButton"..index);
			if ( MouseIsOver(slot) ) then
				slot:LockHighlight();
				HI_Target_Ignore = slot;
				local pos = HoloIgnoreFrameScrollFrame:GetVerticalScroll();
				if ( index == 1 and pos >= FRIENDS_FRAME_IGNORE_HEIGHT ) then
					HoloIgnoreFrameScrollFrameScrollBar:SetValue(pos - FRIENDS_FRAME_IGNORE_HEIGHT);
				end
				if ( index == HoloIgnore_nDisplayedNames and
				     (pos < FRIENDS_FRAME_IGNORE_HEIGHT*(table.getn(HI_list) - HoloIgnore_nDisplayedNames)) )
				then
					HoloIgnoreFrameScrollFrameScrollBar:SetValue(pos + FRIENDS_FRAME_IGNORE_HEIGHT);
				end
			else
				slot:UnlockHighlight();
			end
		end
		HI_Moving_Ignore:UnlockHighlight();
	end

	-- set background texture and call List_Update (OnShow works not always)
	if ( not HI_Window_Visible ) then
		HI_Window_Visible = true;
		HoloFriends_chat("HoloIgnore_List_Update from HoloIgnore_OnUpdate", HF_DEBUG_OUTPUT);
		HoloIgnore_List_Update();
	end
end

-- update called from allways running timer frame
function HoloIgnore_IgnoreOnUpdate()
	-- execute next list update step as new process to prevent time out error
	if ( HI_IgnoreListContinue ) then
		HI_IgnoreListContinue = false;
		HoloFriendsFuncs_CheckRunListUpdate(HoloIgnore_EventFlags);
		return;
	end

	-- in case of a missing IGNORELIST_UPDATE event, call it after a delay of 2 seconds (< HoloFriends_ListUpdateMaxDelay) for ignore add or remove
	if ( HoloIgnore_EventFlags.SetNotify ) then
		if ( (HoloIgnore_EventFlags.TimeStep > 0) and (time() > HoloIgnore_EventFlags.TimeStep + HoloFriends_ListUpdateDelay) ) then
			HoloIgnore_EventFlags.TimeStep = 0;
			HoloIgnore_OnEvent(nil, "IGNORELIST_UPDATE")
		end
	end
end


function HoloIgnore_OnHide()
	HoloIgnore_DeselectEntry();

	-- mark visibility of ignore window
	HI_Window_Visible = false;
end


-- add an ignore
function HoloIgnore_AddIgnore(player, note, group)
	local name;
	if ( player and player ~= "" ) then
		name = player;
	elseif ( UnitIsPlayer("target") ) then
		name = GetUnitName("target", true);
	else
		local dialog = StaticPopup_Show("HOLOIGNORE_ADDIGNORE");
		if ( dialog and group ) then dialog.data = group; end
		return;
	end

	if ( not HoloFriendsLists_ContainsPlayer(HI_list, name) ) then
		HIF_InsertNewEntry(name, group, note);
		if ( (GetNumIgnores() < HI_Max_Server_Ignore) and (name ~= UnitName("player")) ) then
			local index = HoloFriendsLists_ContainsPlayer(HI_list, name);
			HoloFriendsLists_SetNotify(HI_list, index, HF_ONLINE, HF_UNQUIET, "RunUpdate", HoloIgnore_EventFlags);
		else
			local msg = format(HOLOFRIENDS_MSGIGNOREONLINEDISABLED, name);
			HoloFriendsFuncs_SystemMessage(msg);
			HoloFriends_chat("HoloIgnore_List_Update from HoloIgnore_AddIgnore", HF_DEBUG_OUTPUT);
			HoloIgnore_List_Update();
		end
	end

	-- update share window if open
	if ( HoloIgnore_ShareFrame:IsVisible() ) then
		HoloFriendsShare_OnShow(HoloIgnore_ShareFrame);
	end
end


-- remove the selected ignore
function HoloIgnore_RemoveIgnore(index)
	if ( index ) then
		if ( type(index) ~= "number" ) then return; end
		HI_SelectedEntry = index;
		HI_IsGroupSelected = HoloFriendsLists_IsGroup(HI_list, index);
	end

	if ( HI_IsGroupSelected or not HoloIgnore_IsSelectedEntryValid() ) then return; end

	local done = false;
	if ( HoloFriendsLists_GetNotify(HI_list, HI_SelectedEntry) ) then
		done = HoloFriendsLists_SetNotify(HI_list, HI_SelectedEntry, HF_OFFLINE, HF_UNQUIET, "RunUpdate", HoloIgnore_EventFlags);
	end

	-- remove from our list
	table.remove(HI_list, HI_SelectedEntry);
	HoloIgnore_DeselectEntry();

	-- to update list also for offline ignores
	-- ("if" statement is important, because the ignore could be still at the online list)
	if (not done) then
		HoloFriends_chat("HoloIgnore_List_Update from HoloIgnore_RemoveIgnore", HF_DEBUG_OUTPUT);
		HoloIgnore_List_Update();
	end

	-- update share window if open
	if ( HoloIgnore_ShareFrame:IsVisible() ) then
		HoloFriendsShare_OnShow(HoloIgnore_ShareFrame);
	end
end


-- BEGIN OF GETTERS

-- returns the id of the last clicked entry
function HoloIgnore_GetLastClickedIndex()
	return HI_LastClicked;
end


-- returns the selected entry
function HoloIgnore_GetSelectedEntry()
	return HI_SelectedEntry;
end


-- returns true if the selected entry is valid
function HoloIgnore_IsSelectedEntryValid()
	if ( not HoloFriends_Loaded ) then return false; end

	return HoloFriendsLists_IsListIndexValid(HI_list, HI_SelectedEntry);
end


function HoloIgnore_DeselectEntry()
	HI_SelectedEntry = -1;
end


function HoloIgnore_GetList()
	if ( not HoloFriends_Loaded ) then
		local list = {};
		return list;
	end

	return HI_list;
end


function HoloIgnore_LoadList()
	-- get the correct list
	HI_list = HoloFriendsFuncs_LoadList(HOLOIGNORE_LIST, UnitName("player"), HF_HILIST);

	-- check if group "ignore" is in our list
	if ( not HoloFriendsLists_ContainsGroup(HI_list, IGNORE) ) then
		HIF_InsertNewEntry("1", IGNORE);
	end

	-- check if group "search" is in our list
	if ( not HoloFriendsLists_ContainsGroup(HI_list, SEARCH) ) then
		HIF_InsertNewEntry("1", SEARCH);
		local index = HoloFriendsLists_ContainsGroup(HI_list, SEARCH);
		HI_list[index].search = "1";
	end

	-- set actual date in seconds to the ignore group (indicator of last use)
	local idx = HoloFriendsLists_ContainsGroup(HI_list, IGNORE);
	HI_list[idx].lastuse = time();
end

-- END OF GETTER


-- BEGIN OF ITEM TOOLTIP

function HoloIgnore_NameButton_SetTooltip(self)
	local index = self:GetID();

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:SetText(HoloFriendsLists_GetName(HI_list, index, HF_DISPLAY), 1.0, 1.0, 1.0);
	local note = HoloFriendsLists_GetComment(HI_list, index, HF_DISPLAY);
	if ( note ~= "" ) then
		GameTooltip:AddLine(note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	end
	GameTooltip:Show();
end

-- END OF ITEM TOOLTIP


-- START OF GUI FUNCTIONS

-- drag and drop function
function HoloIgnore_NameButton_OnDragStart(self)
	local index = self:GetID();

	local maxi = table.getn(HI_list);
	if ( index > maxi ) then return; end

	if ( HoloFriendsLists_IsGroup(HI_list, index) ) then return; end
	HI_list[index].remove = nil;

	local cursorX, cursorY = GetCursorPosition();
	cursorX = cursorX / self:GetScale();
	cursorY = cursorY / self:GetScale();

	HI_Moving_Ignore = HoloIgnoreFrameNameButtonDrag;
	HI_Moving_Ignore:SetID(index);
	HoloIgnoreFrameNameButtonDragName:SetText(getglobal(self:GetName().."Name"):GetText());
	HI_Moving_Ignore:ClearAllPoints();
	HI_Moving_Ignore:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", cursorX+5, cursorY);
	HI_Moving_Ignore:Show();
	HI_Moving_Ignore:StartMoving();
end


-- drag and drop function
function HoloIgnore_NameButton_OnDragStop()
	if ( not HI_Moving_Ignore ) then return; end

	HI_Moving_Ignore:StopMovingOrSizing();
	HI_Moving_Ignore:Hide();
	HI_Moving_Ignore:ClearAllPoints();

	if ( not HI_Target_Ignore ) then return; end

	local targetIndex = HI_Target_Ignore:GetID();
	if ( targetIndex > table.getn(HI_list) ) then
		targetIndex = table.getn(HI_list);
	end
	HI_list[HI_Moving_Ignore:GetID()].group = HI_list[targetIndex].group;
	HI_Moving_Ignore = nil;
	HoloFriends_chat("HoloIgnore_List_Update from HoloIgnore_NameButton_OnDragStop", HF_DEBUG_OUTPUT);
	HoloIgnore_List_Update();

	-- update share window if open
	if ( HoloIgnore_ShareFrame:IsVisible() ) then
		HoloFriendsShare_OnShow(HoloIgnore_ShareFrame);
	end
end


-- if we clicked on a header, toggle state and select header, otherwise just select entry
function HoloIgnore_NameButton_OnClick(self, button)
	HI_LastClicked = self:GetID();
	if ( not HI_LastClicked ) then return; end

	local maxi = table.getn(HI_list);
	if ( HI_LastClicked > maxi ) then return; end

	if ( button == "LeftButton" ) then
		HI_SelectedEntry = HI_LastClicked;
		-- group selected
		if ( HI_list[HI_SelectedEntry].name == "0" ) then
			HI_IsGroupSelected = true;
			HI_list[HI_SelectedEntry].name = "1";
		elseif ( HI_list[HI_SelectedEntry].name == "1" ) then
			HI_IsGroupSelected = true;
			HI_list[HI_SelectedEntry].name = "0";
		else
			-- player selected
			HI_IsGroupSelected = false;
		end
		HoloFriends_chat("HoloIgnore_List_Update from HoloIgnore_NameButton_OnClick", HF_DEBUG_OUTPUT);
		HoloIgnore_List_Update();
	else
		HoloIgnore_ShowListDropdown(HI_LastClicked);
	end
end


function HoloIgnore_CheckBox_OnClick(self)
	local index = self:GetParent():GetID();

	local maxi = table.getn(HI_list);
	if ( index > maxi ) then return; end

	if ( self:GetChecked() and GetNumIgnores() == HI_Max_Server_Ignore ) then
		self:SetChecked(nil);
		HoloFriendsFuncs_SystemMessage(HI_Limit_Alert);
	else
		if ( self:GetChecked() ) then
			PlaySound("igMainMenuOptionCheckBoxOff");
		else
			PlaySound("igMainMenuOptionCheckBoxOn");
		end
		HI_list[index].remove = nil;
		HoloFriendsLists_SetNotify(HI_list, index, self:GetChecked(), HF_UNQUIET, "RunUpdate", HoloIgnore_EventFlags);
	end
end


function HoloIgnore_ToggleButton_OnClick(self)
	if ( HI_AllGroupsShown ) then
		HI_AllGroupsShown = false;
		self:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	else
		HI_AllGroupsShown = true;
		self:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	end
	HoloFriendsLists_OpenAllGroups(HI_list, HI_AllGroupsShown);
	HoloIgnore_List_Update();
end


-- start ignore list update and check that it runs only once at time
function HoloIgnore_List_Update()
	if ( not HoloFriends_Loaded ) then return; end

	-- skip HoloIgnore_List_Update() at hide of IgnoreFrame
	if ( HoloIgnore_SkipListUpdate ) then
		HoloFriends_chat("HoloIgnore_List_Update skipped (hide of FriendsFrame)", HF_DEBUG_OUTPUT);
		HoloIgnore_SkipListUpdate = false;
		return;
	end

	-- request a new list update after a delay
	if ( HoloIgnore_EventFlags.ListUpdateStartTime ~= HoloFriends_ListUpdateRefTime) then
		if ( time() < HoloIgnore_EventFlags.ListUpdateStartTime + HoloFriends_ListUpdateMaxDelay ) then
			HI_Requested_List_Update = true;
			return;
		end
	end

	HoloFriends_chat("HoloIgnore_List_Update start", HF_DEBUG_OUTPUT);

	HoloIgnore_EventFlags.ListUpdateStartTime = time();

	-- if faction wide ignore list is used, the server list need to be cleared first, to add local entries (ignore list limit)
	local NotFaction = HoloFriendsFuncs_IsCharDataAvailable(HOLOIGNORE_LIST, UnitName("player"));
	HI_IgnoreListContinue = true;
	if ( NotFaction ) then
		HoloIgnore_EventFlags.RunListUpdate = "RunLocal";
	else
		HoloIgnore_EventFlags.RunListUpdate = "RunServer";
	end
end


-- check the local list
function HoloIgnore_CheckLocalList()
	HoloFriends_chat("HoloIgnore_CheckLocalList start", HF_DEBUG_OUTPUT);

	HoloIgnore_EventFlags.ListUpdateStartTime = time();
	local index = next(HI_list);
	while ( index and HI_list[index] ) do
		if ( not HI_list[index].name or not HI_list[index].group ) then
			table.remove(HI_list, index);
		else
			-- set ignores online, which were added by sharing
			if ( HI_list[index].imported ) then
				HI_list[index].imported = nil;
				local notify = (GetNumIgnores() < HI_Max_Server_Ignore);
				HoloFriendsLists_SetNotify(HI_list, index, notify, HF_UNQUIET, "RunLocal", HoloIgnore_EventFlags);
				return;
			end

			index = next(HI_list, index);
		end
	end

	-- check if group "ignore" is in our list
	if ( not HoloFriendsLists_ContainsGroup(HI_list, IGNORE) ) then
		HIF_InsertNewEntry("1", IGNORE);
	end

	-- set actual date in seconds to the ignore group (indicator of last use)
	local index = HoloFriendsLists_ContainsGroup(HI_list, IGNORE)
	HI_list[index].lastuse = time();

	local NotFaction = HoloFriendsFuncs_IsCharDataAvailable(HOLOIGNORE_LIST, UnitName("player"));
	HI_IgnoreListContinue = true;
	if ( NotFaction ) then
		HoloIgnore_EventFlags.RunListUpdate = "RunServer";
	else
		HoloIgnore_EventFlags.RunListUpdate = "RunShow";
	end
end


-- check if all entries in server ignore list are in our list
local HI_ServerListStart = 1;
function HoloIgnore_CheckServerList()
	HoloFriends_chat("HoloIgnore_CheckServerList start", HF_DEBUG_OUTPUT);

	local start_time = HoloFriends_Time;
	HoloIgnore_EventFlags.ListUpdateStartTime = time();

	local NotFaction = HoloFriendsFuncs_IsCharDataAvailable(HOLOIGNORE_LIST, UnitName("player"));
	local numNotifyIgnore = GetNumIgnores();

	-- init the notify flag of all online ignores (notify = 3 is ignore check in progress)
	if ( HI_ServerListStart == 1 ) then
		local maxi = table.getn(HI_list);
		for index = 1, maxi do
			if ( HI_list[index].notify and (HI_list[index].notify ~= 3) ) then HI_list[index].notify = 2; end
		end
	end

	-- init variables for data, which we get from the server
	local name;
	local playerIndex;

	-- check if all ignores are in our list
	local idx1 = HI_ServerListStart;
	HI_ServerListStart = 1;
	for idx = idx1, numNotifyIgnore do
		name = GetIgnoreName(idx);

		-- check if player is already in our list or need to be added
		playerIndex = HoloFriendsLists_ContainsPlayer(HI_list, name);
		if ( playerIndex ) then
			if ( NotFaction ) then
				if ( HI_list[playerIndex].notify and (HI_list[playerIndex].notify == 3) ) then
					HoloFriendsLists_SetNotify(HI_list, playerIndex, HF_OFFLINE, HF_QUIET, "RunServer", HoloIgnore_EventFlags);
					return;
				else
					HI_list[playerIndex].notify = HF_ONLINE;
				end
			elseif ( not HI_list[playerIndex].notify ) then
				HoloFriendsLists_SetNotify(HI_list, playerIndex, HF_OFFLINE, HF_UNQUIET, "RunServer", HoloIgnore_EventFlags);
				return;
			else
				HI_list[playerIndex].notify = HF_ONLINE; -- to change old list style entries from "1" to "true"
			end
		elseif ( name and (name ~= "") ) then
			if ( name == UNKNOWN ) then
				if ( not NotFaction ) then HI_Requested_List_Update = true; end
			elseif ( NotFaction ) then
				HIF_InsertNewEntry(name, nil, note, HF_ONLINE);
			else
				-- not added by HoloFriends, so remove entry from server list
				HoloIgnore_EventFlags.Name = name;
				HoloIgnore_EventFlags.RunListUpdate = "RunServer";
				HoloIgnore_EventFlags.Quiet = HF_UNQUIET;
				local done = HoloFriendsFuncs_RemoveFromServerList(HoloIgnore_EventFlags);
				if ( done ) then return; end
			end
		end

		-- check run time to prevent time out error (max. run time in combat is 100ms)
		if ( HoloFriends_Time > start_time + 60 ) then
			HI_IgnoreListContinue = true;
			HoloIgnore_EventFlags.RunListUpdate = "RunServer";
			HI_ServerListStart = idx + 1;
			HoloFriends_chat("HoloIgnore_CheckServerList Re-submit", HF_DEBUG_OUTPUT);
			return;
		end
	end

	-- check if all online ignores are still there
	local maxi = table.getn(HI_list);
	for index = 1, maxi do
		if ( HI_list[index].notify and (HI_list[index].notify == 3) ) then
			local msg = format(TEXT(HOLOFRIENDS_MSGIGNOREMISSINGONLINE), HI_list[index].name);
			HoloFriendsFuncs_SystemMessage(msg);
			HI_list[index].notify = HF_OFFLINE;
		end
		if ( HI_list[index].notify and (HI_list[index].notify == 2) ) then
			local silent = false;
			if ( NotFaction ) then silent = true; end
			HoloFriendsLists_SetNotify(HI_list, index, 3, silent, "RunServer", HoloIgnore_EventFlags);
			return;
		end
	end

	--sort the entries
	table.sort(HI_list, HoloFriendsFuncs_CompareEntry);

	HI_IgnoreListContinue = true;
	if ( NotFaction ) then
		HoloIgnore_EventFlags.RunListUpdate = "RunShow";
	else
		HoloIgnore_EventFlags.RunListUpdate = "RunLocal";
	end
end


-- the option can be true/false or a number from 1 to 4
local HI_bcount;
local function HIF_SetupButton(option, button, count)
	if ( option ) then
		count = count + 1;
		local posID;
		if ( type(option) == "boolean" ) then
			HI_bcount = HI_bcount + 1;
			posID = HI_bcount;
		else
			posID = option;
		end
		button:ClearAllPoints();
		if ( posID == 1 ) then button:SetPoint("TOPLEFT", HoloIgnoreFrameOnline, "BOTTOMLEFT",  -6,  -3); end
		if ( posID == 2 ) then button:SetPoint("TOPLEFT", HoloIgnoreFrameOnline, "BOTTOMLEFT", 190,  -3); end
		if ( posID == 3 ) then button:SetPoint("TOPLEFT", HoloIgnoreFrameOnline, "BOTTOMLEFT",  -6, -28); end
		if ( posID == 4 ) then button:SetPoint("TOPLEFT", HoloIgnoreFrameOnline, "BOTTOMLEFT", 190, -28); end
		button:Show();
	else
		button:Hide();
	end
	return count
end


local function HIF_SetLayout()
	HI_bcount = 0;
	-- count and show active buttons
	local bcount = 0;
	bcount = HIF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonILAddComment, HoloIgnoreFrameAddCommentButton,    bcount)
	bcount = HIF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonILAddIgnore,  HoloIgnoreFrame_AddIgnoreButton,    bcount)
	bcount = HIF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonILAddGroup,   HoloIgnoreFrameAddGroupButton,      bcount)
	bcount = HIF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonILRenGroup,   HoloIgnoreFrameRenameGroupButton,   bcount)
	bcount = HIF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonILRmIgnore,   HoloIgnoreFrame_RemoveIgnoreButton, bcount)
	bcount = HIF_SetupButton(HOLOFRIENDS_OPTIONS.ButtonILRmGroup,    HoloIgnoreFrameRemoveGroupButton,   bcount)

	-- setup the background layout
	local ltex = getglobal("HoloIgnoreFrameBottomLeft");
	local rtex = getglobal("HoloIgnoreFrameBottomRight");
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

	-- setup HoloIgnoreFrameOnline, and HoloIgnoreFrameShareButton
	if ( bcount > 2 ) then HoloIgnoreFrameShareButton:Show(); else HoloIgnoreFrameShareButton:Hide(); end
	HoloIgnoreFrameOnline:ClearAllPoints();
	if ( bcount > 2 ) then
		HoloIgnoreFrameOnline:SetPoint("TOPLEFT", HoloIgnoreFrameTopLeft, "TopLEFT", 22, -367);
	elseif ( bcount > 0 ) then
		HoloIgnoreFrameOnline:SetPoint("TOPLEFT", HoloIgnoreFrameTopLeft, "TopLEFT", 22, -392);
	else
		HoloIgnoreFrameOnline:SetPoint("TOPLEFT", HoloIgnoreFrameTopLeft, "TopLEFT", 22, -417);
	end

	-- enable/disable buttons
	if ( HoloIgnore_IsSelectedEntryValid() ) then
		if ( HoloFriendsLists_IsGroup(HI_list, HI_SelectedEntry) ) then
			if ( HoloFriendsLists_GetGroup(HI_list, HI_SelectedEntry) ~= IGNORE ) then
				HoloIgnoreFrameRenameGroupButton:Enable();
				HoloIgnoreFrameRemoveGroupButton:Enable();
			else
				HoloIgnoreFrameRenameGroupButton:Disable();
				HoloIgnoreFrameRemoveGroupButton:Disable();
			end
			HoloIgnoreFrame_RemoveIgnoreButton:Disable();
		else
			HoloIgnoreFrameRenameGroupButton:Disable();
			HoloIgnoreFrameRemoveGroupButton:Disable();
			HoloIgnoreFrame_RemoveIgnoreButton:Enable();
		end
		HoloIgnoreFrameAddCommentButton:Enable();
	else
		HoloIgnoreFrameAddCommentButton:Disable();
		HoloIgnoreFrameRenameGroupButton:Disable();
		HoloIgnoreFrameRemoveGroupButton:Disable();
		HoloIgnoreFrame_RemoveIgnoreButton:Disable();
	end

	return bcount;
end


-- update scrollframe & buttons
function HoloIgnore_UpdateIgnoreList()
	-- run only, if window is visible
	if ( not HoloIgnoreFrame:IsVisible() ) then
		HoloIgnore_EventFlags.ListUpdateStartTime = HoloFriends_ListUpdateRefTime;
		if ( HI_Requested_List_Update ) then
			HI_Requested_List_Update = false;
			HoloIgnore_List_Update();
		end
		return;
	end

	HoloIgnore_EventFlags.ListUpdateStartTime = time();

	HoloFriends_chat("HoloIgnore_UpdateIgnoreList start", HF_DEBUG_OUTPUT);

	-- get some counter
	local notifyCounter = GetNumIgnores();
	local sumCounter = 0;
	local maxi = table.getn(HI_list);
	for index = 1, maxi do
		if ( (HI_list[index].name ~= "0") and (HI_list[index].name ~= "1") ) then
			sumCounter = sumCounter + 1;
		end
	end

	-- setup the buttons at the bottom of the ignore frame
	local bcount = HIF_SetLayout();

	-- set the number of shown ignore (hide unused buttons)
	if ( bcount > 2 ) then HoloIgnore_nDisplayedNames = HoloIgnore_maxDisplayedNames - 3;
	elseif ( bcount > 0 ) then HoloIgnore_nDisplayedNames = HoloIgnore_maxDisplayedNames - 2 ;
	else HoloIgnore_nDisplayedNames = HoloIgnore_maxDisplayedNames; end
	for n = HoloIgnore_nDisplayedNames + 1, HoloIgnore_maxDisplayedNames do
		getglobal("HoloIgnoreFrameNameButton"..n):Hide();
	end

	-- get visible index table
	local ShownIndexTable = {};
	ShownIndexTable = HoloFriendsFuncs_ShownListTab(HI_list, HoloIgnore_nDisplayedNames, HF_HILIST);
	-- get counter of visible elements from index table
	local visibleCnt = HoloFriendsFuncs_GetNumVisibleListElements(ShownIndexTable, maxi, HoloIgnore_nDisplayedNames);

	-- ScrollFrame stuff
	local ScrollBarSize = 0;
	if ( visibleCnt > HoloIgnore_nDisplayedNames ) then ScrollBarSize = 20; end 
	local ssize;
	if ( bcount > 2 ) then ssize = 304;
	elseif ( bcount > 0 ) then ssize = 329;
	else ssize = 354; end
	HoloIgnoreFrameScrollFrame:SetHeight(ssize);
	FauxScrollFrame_Update(HoloIgnoreFrameScrollFrame, visibleCnt, HoloIgnore_nDisplayedNames, 16);
	-- scrollframe offset
	local offset = FauxScrollFrame_GetOffset(HoloIgnoreFrameScrollFrame);

	-- button and textures
	local button, buttonText, buttonTextRemove, buttonCheckBox;

	local entry = {};
	local line = 1;

	-- set values / textures for all buttons
	while ( line <= HoloIgnore_nDisplayedNames ) do
		local index = ShownIndexTable[line + offset];

		entry = HI_list[index];

		button = getglobal("HoloIgnoreFrameNameButton"..line);
		button:SetID(index);

		if ( line > visibleCnt ) then
			button:Hide();
		else
			button:Show();
		end

		if ( entry ) then
			if ( index == HI_SelectedEntry ) then
				button:LockHighlight();
			else
				button:UnlockHighlight();
			end

			-- get textfield, and checkbox
			buttonText = getglobal("HoloIgnoreFrameNameButton"..line.."Name");
			buttonTextRemove = getglobal("HoloIgnoreFrameNameButton"..line.."NameRemove");
			buttonWait = getglobal("HoloIgnoreFrameNameButton"..line.."WaitIcon");
			buttonCheckBox = getglobal("HoloIgnoreFrameNameButton"..line.."Server");

			-- group entry ?
			if ( entry.name == "1" or entry.name == "0" ) then
				local name = HoloFriendsLists_GetName(HI_list, index, HF_DISPLAY);
				buttonText:SetText(name);
				buttonTextRemove:SetText("");
				buttonText:ClearAllPoints();
				buttonText:SetPoint("TOPLEFT", "HoloIgnoreFrameNameButton"..line, "TOPLEFT", 20, 0);
				buttonCheckBox:Hide();

				if ( entry.name == "1" ) then
					button:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				else
					button:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				end
			else -- no, we got a player
				local textwidth;
				local name = HoloFriendsLists_GetName(HI_list, index, HF_DISPLAY);
				local note = HoloFriendsLists_GetComment(HI_list, index, HF_DISPLAY);
				if ( entry.remove ) then
					buttonText:SetText(name);
					textwidth = buttonText:GetStringWidth();
				end
				buttonText:SetText(format(TEXT(HI_List_Template), name, note));
				if ( entry.remove ) then
					buttonTextRemove:SetText("|cffffffff_____________________________________|r");
					buttonTextRemove:SetWidth(textwidth + 10);
				else
					buttonTextRemove:SetText("");
				end
				button:SetNormalTexture("");
				buttonCheckBox:Show();
				buttonCheckBox:SetChecked(entry.notify);
				buttonWait:Hide();
				buttonText:ClearAllPoints();
				buttonText:SetPoint("TOPLEFT", "HoloIgnoreFrameNameButton"..line, "TOPLEFT", 36, 0);
			end

			-- Set the button text with
			button:SetWidth(315 - ScrollBarSize);
			buttonText:SetWidth(276 - ScrollBarSize);
		end

		line = line + 1;
	end

	HoloIgnoreFrameOnline:SetText(format("%s %d / %d", HOLOFRIENDS_WINDOWMAINIGNOREONLINE, notifyCounter, sumCounter));

	HoloFriends_chat("HoloIgnore_UpdateIgnoreList end", HF_DEBUG_OUTPUT);

	HoloIgnore_EventFlags.ListUpdateStartTime = HoloFriends_ListUpdateRefTime;
	if ( HI_Requested_List_Update ) then
		HI_Requested_List_Update = false;
		HoloIgnore_List_Update();
	end
end

-- END OF GUI FUNCTIONS
