--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file defines the hooks used

]]


-- strings computed from global strings
local HF_ERR_FRIEND_ADDED_S = "";
local HF_ERR_FRIEND_ALREADY_S = "";
local HF_ERR_FRIEND_REMOVED_S = "";

local HF_ERR_IGNORE_ADDED_S = "";
local HF_ERR_IGNORE_ALREADY_S = "";
local HF_ERR_IGNORE_REMOVED_S = "";

local HF_WHO_LIST_FORMAT = "";
local HF_WHO_LIST_GUILD_FORMAT = "";
HoloFriends_WHO_NUM_RESULTS = "";
local HF_DefaultNotFoundMsg = "";

-- saved hook
local HFF_FriendsFrame_OnEvent_Orig = nil;


-- Initialisation of the hooks
function HoloFriendsHooks_OnLoad()
	DropDownList1:HookScript("OnShow", HoloFriends_DropDownList1_OnShow);
	WhoFrameAddFriendButton:HookScript("OnClick", HoloFriends_WhoAddFriend);

	hooksecurefunc("UIDropDownMenu_Initialize",              HoloFriends_UIDropDownMenu_Initialize);
	hooksecurefunc("UnitPopup_OnClick",                      HoloFriends_UnitPopup_OnClick);
	hooksecurefunc("UnitPopup_OnUpdate",                     HoloFriends_UnitPopup_OnUpdate);
	hooksecurefunc("UnitPopup_HideButtons",                  HoloFriends_UnitPopup_HideButtons);

	hooksecurefunc("AutoComplete_Update",                    HoloFriends_AutoComplete_Update);
	hooksecurefunc("AutoCompleteEditBox_AddHighlightedText", HoloFriends_AutoCompleteEditBox_AddHighlightedText);
	hooksecurefunc("FriendsFrame_Update",                    HoloFriends_FriendsFrame_Update);

	-- Add a System Message Event Filter (replaces old hook methode)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", HoloFriends_ChatMsgSystem_EventFilter);

	-- Add event filter to ignore chat from players at the offline ignore list
	ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT",         HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND",        HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",             HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE",               HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD",               HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT",   HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER",             HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY",               HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER",        HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID",                HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER",         HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING",        HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY",                 HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE",          HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",             HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM",      HoloFriends_IgnoreChatMsg_EventFilter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL",                HoloFriends_IgnoreChatMsg_EventFilter);

	-- hook FriendsFrame_OnEvent to prevent who-frame popup
--	HFF_FriendsFrame_OnEvent_Orig = FriendsFrame_OnEvent;
--	FriendsFrame_OnEvent = HoloFriends_FriendsFrame_OnEvent;

	-- setup of some strings
	HF_ERR_FRIEND_ADDED_S   = string.gsub(ERR_FRIEND_ADDED_S,   "%%s", "%.%+");
	HF_ERR_FRIEND_ALREADY_S = string.gsub(ERR_FRIEND_ALREADY_S, "%%s", "%.%+");
	HF_ERR_FRIEND_REMOVED_S = string.gsub(ERR_FRIEND_REMOVED_S, "%%s", "%.%+");

	HF_ERR_IGNORE_ADDED_S   = string.gsub(ERR_IGNORE_ADDED_S,   "%%s", "%.%+");
	HF_ERR_IGNORE_ALREADY_S = string.gsub(ERR_IGNORE_ALREADY_S, "%%s", "%.%+");
	HF_ERR_IGNORE_REMOVED_S = string.gsub(ERR_IGNORE_REMOVED_S, "%%s", "%.%+");

	HF_WHO_LIST_FORMAT = string.gsub(WHO_LIST_FORMAT, "%%%d*%$?s", "%.%*");
	HF_WHO_LIST_FORMAT = string.gsub(HF_WHO_LIST_FORMAT, "%%%d*%$?d", "%%d%+");
	HF_WHO_LIST_FORMAT = string.gsub(HF_WHO_LIST_FORMAT, "%[", "%%%[");
	HF_WHO_LIST_FORMAT = string.gsub(HF_WHO_LIST_FORMAT, "%]", "%%%]");
	HF_WHO_LIST_FORMAT = string.gsub(HF_WHO_LIST_FORMAT, "%-", "%%%-");
	HF_WHO_LIST_GUILD_FORMAT = string.gsub(WHO_LIST_GUILD_FORMAT, "%%%d*%$?s", "%.%*");
	HF_WHO_LIST_GUILD_FORMAT = string.gsub(HF_WHO_LIST_GUILD_FORMAT, "%%%d*%$?d", "%%d%+");
	HF_WHO_LIST_GUILD_FORMAT = string.gsub(HF_WHO_LIST_GUILD_FORMAT, "%[", "%%%[");
	HF_WHO_LIST_GUILD_FORMAT = string.gsub(HF_WHO_LIST_GUILD_FORMAT, "%]", "%%%]");
	HF_WHO_LIST_GUILD_FORMAT = string.gsub(HF_WHO_LIST_GUILD_FORMAT, "%-", "%%%-");
	HoloFriends_WHO_NUM_RESULTS = string.gsub(WHO_NUM_RESULTS, "%%%d*%$?d", "%%d%+");

	HF_DefaultNotFoundMsg = strlower(format(ERR_CHAT_PLAYER_NOT_FOUND_S, "amcetestplayer"));
end


-- This makes all windows visible
function HoloFriends_FriendsFrame_Update()
	if ( FriendsFrame.selectedTab == 1 ) then
		-- show HoloFriends friends list
		if ( FriendsTabHeader.selectedTab == 1 ) then
			HoloFriends_ShowInGameIgnoreList = false;
			if ( not HoloFriends_ShowInGameFriendsList ) then
				if ( not HoloFriendsFrame:IsVisible() ) then
					local t1 = HoloFriends_FriendsFrameCloseTime;
					local t2 = GetTime() - HoloFriends_MaxFrameCloseTime;
					if ( t1 < t2 ) then
						HideUIPanel(FriendsFrame);
						HideUIPanel(HoloIgnoreFrame);
						ShowUIPanel(HoloFriendsFrame);
						HoloFriends_FrameShowTime = GetTime();
						return;
					else
						-- ship HoloFriends_List_Update() at hide of FriendsFrame
						HoloFriends_SkipListUpdate = true;
						HideUIPanel(FriendsFrame);
					end
				end
			else
				ShowUIPanel(FriendsFrame);
			end
		-- show HoloFriends ignore list
		elseif ( FriendsTabHeader.selectedTab == 2 ) then
			HoloFriends_ShowInGameFriendsList = false;
			if ( not HoloFriends_ShowInGameIgnoreList ) then
				if ( not HoloIgnoreFrame:IsVisible() ) then
					local t1 = HoloFriends_IgnoreFrameCloseTime;
					local t2 = GetTime() - HoloFriends_MaxFrameCloseTime;
					if ( t1 < t2 ) then
						HideUIPanel(FriendsFrame);
						HideUIPanel(HoloFriendsFrame);
						ShowUIPanel(HoloIgnoreFrame);
						return;
					else
						-- ship HoloIgnore_List_Update() at hide of IgnoreFrame
						HoloIgnore_SkipListUpdate = true;
						HideUIPanel(FriendsFrame);
					end
				end
			else
				ShowUIPanel(FriendsFrame);
			end
		else
			HoloFriends_ShowInGameFriendsList = false;
			HoloFriends_ShowInGameIgnoreList = false;
			ShowUIPanel(FriendsFrame);
		end
	end
	HideUIPanel(HoloFriendsFrame);
	HideUIPanel(HoloIgnoreFrame);
end


-- Add char names from the friends and faction list as hook to GetAutoCompleteResults, mainly for send mail
local HF_AddHighlightedText = false;
local function HFF_AutoComplete_Update(text, cursorpos, maxarg, args)
	local numFriends, name;
	local realm = GetRealmName();
	local player = UnitName("player");

	-- create an independend copy of args
	local numarg = #args;
	local namelist = {};
	if ( numarg > 0 ) then
		for idx = 1, numarg do
			namelist[idx] = args[idx];
		end
	end

	-- split text at cursor position
	local textlen = string.len(text);
	local subtxt1;
	if ( cursorpos > 0 ) then subtxt1 = string.sub(text, 1, cursorpos); end
	local subtxt2;
	if ( cursorpos < textlen ) then subtxt2 = string.sub(text, cursorpos + 1); end

	-- check local HoloFriends list
	local list = HoloFriends_GetList();
	numFriends = table.getn(list);
	if ( (numFriends > 0) and (numarg < maxarg) ) then
		for index = 1, numFriends do
			name = HoloFriendsLists_GetName(list, index);
			if ( name == "" ) then name = nil; end
			if ( name == player ) then name = nil; end
			if ( HoloFriendsLists_IsGroup(list, index) ) then name = nil; end
			-- check if player is in online friends list
			if ( HoloFriendsLists_GetNotify(list, index) ) then name = nil; end
			-- check if player is online (for whisper)
			if ( not HF_AddHighlightedText ) then
				if ( not HoloFriendsLists_IsConnected(list, index) ) then name = nil; end
			end
			-- check if player is in guild list
			if ( name ) then
				local fname = name.."-"..realm;
				for idx = 1, GetNumGuildMembers(true) do
					local gname = GetGuildRosterInfo(idx);
					if ( fname == gname) then name = nil; end
				end
			end
			-- check the name string
			if ( subtxt1 ) then
				-- subtxt1 has to start at first position in name
				if ( name and (strfind(strupper(name), strupper(subtxt1), 1, 1) == 1) ) then
					-- subtxt2 has to exist in name after the cursor position
					if ( subtxt2 and not strfind(strupper(name), strupper(subtxt2), cursorpos + 1, 1) ) then
						name = nil;
					end
				else
					name = nil;
				end
			else
				-- without subtxt1, only subtxt2 has to exist in name
				if ( name and not strfind(strupper(name), strupper(subtxt2), 1, 1) ) then
					name = nil;
				end
			end
			-- put valid name in next free argument upto maxarg is filled
			if ( name and (numarg < maxarg) ) then
				numarg = numarg + 1;
				namelist[numarg] = {name = name.."-"..realm, priority = 5};
			end
		end
	end

	-- check all your own chars at the local realm
	local faction = UnitFactionGroup("player");
	local clist = HoloFriendsFuncs_RealmGetOwnChars(true);
	numFriends = table.getn(clist);
	if ( (numFriends > 0) and HF_AddHighlightedText ) then
		for index = 1, numFriends do
			name = clist[index];
			if ( name == "" ) then name = nil; end
			if ( (name == player) or (name == faction) ) then name = nil; end
			-- check the name string
			if ( subtxt1 ) then
				-- subtxt1 has to start at first position in name
				if ( name and (strfind(strupper(name), strupper(subtxt1), 1, 1) == 1) ) then
					-- subtxt2 has to exist in name after the cursor position
					if ( subtxt2 and not strfind(strupper(name), strupper(subtxt2), cursorpos + 1, 1) ) then
						name = nil;
					end
				else
					name = nil;
				end
			else
				-- without subtxt1, only subtxt2 has to exist in name
				if (name and not strfind(strupper(name), strupper(subtxt2), 1, 1) ) then
					name = nil;
				end
			end
			if ( name ) then
				local inlist = false;
				-- check if own chars are in guild list
				local fname = name.."-"..realm;
				for idx = 1, GetNumGuildMembers(true) do
					local gname = GetGuildRosterInfo(idx);
					if ( fname == gname) then inlist = true; end
				end
				-- check if own chars are in friends list
				if ( HoloFriendsLists_ContainsPlayer(list, name) ) then inlist = true; end
				-- name possibly already in list -> remove
				if ( inlist ) then
					local found = false;
					for idx = 1, numarg - 1 do
						if ( namelist[idx].name == fname ) then found = true; end
						if ( found ) then
							namelist[idx] = namelist[idx+1];
						end
					end
					if ( namelist[numarg].name == fname ) then found = true; end
					if ( found ) then numarg = numarg - 1; end
				end
				-- put valid name in the first argument moving others downward
				if ( numarg < maxarg ) then numarg = numarg + 1; end
				for idx = numarg, 2, -1 do
					namelist[idx] = namelist[idx-1];
				end
				namelist[1] = {name = fname, priority = 5};
			end
		end
	end

	-- remove name of local realm
	for idx = 1, numarg do
		local pos = string.find(namelist[idx].name, "-"..realm);
		if ( pos ) then
			namelist[idx].name = string.sub(namelist[idx].name, 1, pos - 1);
		end
	end

	return namelist;
end


-- this hook changes the text in the address field
function HoloFriends_AutoCompleteEditBox_AddHighlightedText(editBox, text)
	if ( not editBox.autoCompleteParams ) then
		return;
	end
-- this line is added to the original function
	HF_AddHighlightedText = true;
-- this line is modified related to original function
	local editBoxText = text;
	local utf8Position = editBox:GetUTF8CursorPosition();
-- this line is modified related to original function
	local namelist = GetAutoCompleteResults(text, editBox.autoCompleteParams.include, editBox.autoCompleteParams.exclude, 1, utf8Position);
-- this line is added to the original function
	local nameInfo = HFF_AutoComplete_Update(text, utf8Position, AUTOCOMPLETE_MAX_BUTTONS+1, namelist)[1];

	if ( nameInfo and nameInfo.name ) then
		--We're going to be setting the text programatically which will clear the userInput flag on the editBox. So we want to manually update the dropdown before we change the text.
		AutoComplete_Update(editBox, editBoxText, utf8Position);
		local name = Ambiguate(nameInfo.name, editBox.autoCompleteContext or "all");
		local newText = string.gsub(editBoxText, AUTOCOMPLETE_SIMPLE_REGEX,
							string.format(AUTOCOMPLETE_SIMPLE_FORMAT_REGEX, name,
								string.match(editBoxText, AUTOCOMPLETE_SIMPLE_REGEX)),
								1)
		editBox:SetText(newText);
		editBox:HighlightText(strlen(editBoxText), strlen(newText));	--This won't work if there is more after the name, but we aren't enabling this for normal chat (yet). Please fix me when we do.
		editBox:SetCursorPosition(strlen(editBoxText));
	end
end


-- this hook changes the address list below the address field
function HoloFriends_AutoComplete_Update(parent, text, cursorPosition)
	local self = AutoCompleteBox;
	local attachPoint;
	if ( not parent.autoCompleteParams ) then
		return;
	end
	if ( not text or text == "" ) then
		AutoComplete_HideIfAttachedTo(parent);
		return;
	end
	if ( cursorPosition <= strlen(text) ) then
		self:SetParent(parent);
		if(self.parent ~= parent) then
			AutoComplete_SetSelectedIndex(self, 0);
			self.parentArrows = parent:GetAltArrowKeyMode();
		end
		parent:SetAltArrowKeyMode(false);
		
		if ( parent:GetBottom() - self.maxHeight <= (AUTOCOMPLETE_DEFAULT_Y_OFFSET + 10) ) then	--10 is a magic number from the offset of AutoCompleteButton1.
			attachPoint = "ABOVE";
		else
			attachPoint = "BELOW";
		end
		if ( (self.parent ~= parent) or (self.attachPoint ~= attachPoint) ) then
			if ( attachPoint == "ABOVE" ) then
				self:ClearAllPoints();
				self:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", parent.autoCompleteXOffset or 0, parent.autoCompleteYOffset or -AUTOCOMPLETE_DEFAULT_Y_OFFSET);
			elseif ( attachPoint == "BELOW" ) then
				self:ClearAllPoints();
				self:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", parent.autoCompleteXOffset or 0, parent.autoCompleteYOffset or AUTOCOMPLETE_DEFAULT_Y_OFFSET);
			end
			self.attachPoint = attachPoint;
		end
		
		self.parent = parent;
		--We ask for one more result than we need so that we know whether or not results are continued
		possibilities = GetAutoCompleteResults(text, parent.autoCompleteParams.include, parent.autoCompleteParams.exclude, AUTOCOMPLETE_MAX_BUTTONS+1, cursorPosition);
-- this line is an addition to original function
		possibilities = HFF_AutoComplete_Update(text, cursorPosition, AUTOCOMPLETE_MAX_BUTTONS+1, possibilities);
		if (not possibilities) then
			possibilities = {};
		end
		local realmStart = text:find("-", 1, true);
		if (realmStart) then
			local realms = {};
			GetAutoCompleteRealms(realms);
			local realm, subStart, subEnd;
			realmStart = text:sub(realmStart + 1) --get text after hyphen
			local index = #possibilities + 1;
			for i=1, #realms do
				realm = realms[i];
				subStart, subEnd = realm:lower():find(realmStart:lower(), 1, true) 
				if (subStart and subStart == 1) then
					if (subEnd > 0) then
						--if they started typing a known realm name, just append the rest of it
						realm = realm:sub(subEnd + 1); 
					end
					local entry = text..realm;
					if (not tContains(possibilities, entry)) then
						possibilities[index] = {name=entry, priority=LE_AUTOCOMPLETE_PRIORITY_OTHER};
					end
					index = index + 1
				end;
			end
		end
-- this line is modified related to original function
		AutoComplete_UpdateResults(self, possibilities);
	else
		AutoComplete_HideIfAttachedTo(parent);
	end
	HF_AddHighlightedText = false;
end


-- hook to the AddFriend button at the who-frame
function HoloFriends_WhoAddFriend()
	HoloFriends_AddFriend(WhoFrame.selectedName);
end


-- uppend buttons directly to the menus
function HoloFriends_DropDownList1_OnShow()
	if ( HoloFriends_MenuButtonCount == 0 ) then return; end

	local frame = DropDownList1;
	local fheight = frame:GetHeight();
	local fwidth = frame:GetWidth();
	local which = UIDROPDOWNMENU_INIT_MENU.which;
	local button, bname;

	for nb = 1, HoloFriends_MenuButtonCount do
		bname = "DropDownList1ButtonHF"..nb;
		btext = _G[bname.."NormalText"]:GetText();
		button = _G[bname];
		_G[bname.."Check"]:Hide();
		_G[bname.."UnCheck"]:Hide();
		local showIt = false;
		if ( (which == "PLAYER") and HOLOFRIENDS_OPTIONS.MenuModT ) then showIt = true; end
		if ( (which == "PARTY")  and HOLOFRIENDS_OPTIONS.MenuModP ) then showIt = true; end
		if ( (which == "RAID")   and HOLOFRIENDS_OPTIONS.MenuModR ) then showIt = true; end
		if ( (which == "FRIEND") and HOLOFRIENDS_OPTIONS.MenuModF and (btext ~= IGNORE_PLAYER) ) then showIt = true; end
		if ( showIt ) then
			if ( button.width > fwidth - 30  ) then
				fwidth = button.width + 30;
				frame:SetWidth(fwidth);
			end
			if ( nb == 1 ) then fheight = fheight + 11; else fheight = fheight + 16; end
			frame:SetHeight(fheight);
			button:SetWidth(fwidth - 30);
			button:ClearAllPoints();
			button:SetPoint("BOTTOMLEFT", "DropDownList1", "TOPLEFT", 15, 10 - fheight);
			button:Show();
		
		else
			button:Hide();
		end
	end
end


-- function to manage drop down menu background (initialized in HoloFriendsInit_OnLoadAll)
-- executed at every display of any pull down menu
function HoloFriends_UIDropDownMenu_Initialize(self)
	if ( HOLOFRIENDS_OPTIONS.ShowDropdownBG or HOLOFRIENDS_OPTIONS.ShowDropdownAllBG ) then
		if ( type(rawget(self, 0)) == "userdata" ) then
			local window = self:GetName();
			if ( (window and (strsub(window,1,4) == "Holo")) or HOLOFRIENDS_OPTIONS.ShowDropdownAllBG ) then

				-- Add a black background to the default pull down menu
				local listFrame = getglobal("DropDownList1");
				local tex = getglobal("DropDownList1_HoloFriendsBG");
				tex:SetTexture([[Interface\ChatFrame\ChatFrameBackground]]);
				tex:SetPoint("TOPLEFT",listFrame,"TOPLEFT",4,-5);
				tex:SetPoint("BOTTOMRIGHT",listFrame,"BOTTOMRIGHT",-4,5);
				tex:SetVertexColor(0.0, 0.0, 0.0);

				return;
			end
		end
	end

	-- remove background texture from default drop down menu
	getglobal("DropDownList1_HoloFriendsBG"):SetTexture(nil);
	getglobal("DropDownList1_HoloFriendsBG"):ClearAllPoints();
end


-- Process drop down menu click
function HoloFriends_UnitPopup_OnClick(self)
	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
	local button = self.value;
	local name = dropdownFrame.name;
	local id = dropdownFrame.userData;

	if ( button == "HOLOFRIENDS_WHISPER" ) then
		local list = HoloFriends_GetList();
		if ( HoloFriendsLists_IsRealID(list, id) ) then
			ChatFrame_SendSmartTell(list[id].bname, dropdownFrame.chatFrame);
		else
			ChatFrame_SendTell(name, dropdownFrame.chatFrame);
		end
	elseif ( button == "HOLOFRIENDS_INVITE" ) then
		local list = HoloFriends_GetList();
		if ( HoloFriendsLists_IsPlayer(list, id) ) then
			if ( HoloFriendsLists_IsRealID(list, id) ) then
				local tname = HoloFriendsLists_GetToon(list, id);
				if ( tname ) then InviteUnit(tname); end
			else
				InviteUnit(name);
			end
		elseif ( HoloFriendsLists_IsGroup(list, id) ) then
			local nOnline = list[id].numonline;
			if ( nOnline > 0 ) then
				local group = list[id].group;
				local dialog = StaticPopup_Show("HOLOFRIENDS_INVITEALLOFGROUP", tostring(nOnline), group);
				if ( dialog ) then dialog.data = group; end
			end
		end
	elseif ( button == "HOLOFRIENDS_ONWARNING" ) then
		if ( dropdownFrame == HoloFriendsDropDown ) then
			local list = HoloFriends_GetList();
			local index = HoloFriends_GetLastClickedIndex();
			list[index].remove = nil;
			if ( list[index].warn ) then
				list[index].warn = nil;
			else
				list[index].warn = true;
			end
			HoloFriends_List_Update();
		end
	elseif ( button == "HOLOFRIENDS_ADDCOMMENT" ) then
		if ( dropdownFrame == HoloFriendsDropDown ) then
			local list = HoloFriends_GetList();
			local index = HoloFriends_GetLastClickedIndex();
			list[index].remove = nil;
			StaticPopup_Show("HOLOFRIENDS_ADDCOMMENT", name);
		elseif ( dropdownFrame == HoloIgnoreDropDown ) then
			StaticPopup_Show("HOLOIGNORE_ADDCOMMENT", name);
		end
	elseif ( button == "HOLOFRIENDS_ADDFRIEND" ) then
		if ( dropdownFrame == HoloFriendsDropDown ) then
			local list = HoloFriends_GetList();
			local group = HoloFriendsLists_GetGroup(list, id);
			if ( group ~= SEARCH ) then
				HoloFriends_AddFriend(nil, nil, group);
			else
				HoloFriends_AddFriend();
			end
		else
			local server = dropdownFrame.server;
			if ( server and (server ~= "") ) then
				name = name.."-"..server;
			end
			HoloFriends_AddFriend(name);
		end
	elseif ( button == "HOLOFRIENDS_ADDIGNORE" ) then
		if ( dropdownFrame == HoloIgnoreDropDown ) then
			local list = HoloIgnore_GetList();
			local group = HoloFriendsLists_GetGroup(list, id);
			if ( group ~= SEARCH ) then
				HoloIgnore_AddIgnore(nil, nil, group);
			else
				HoloIgnore_AddIgnore();
			end
		else
			local server = dropdownFrame.server;
			if ( server and (server ~= "") ) then
				name = name.."-"..server;
			end
			HoloIgnore_AddIgnore(name);
		end
	elseif ( string.sub(button,1,17) == "HOLOFRIENDS_GROUP" ) then
		DropDownList1:Hide();
		if ( dropdownFrame == HoloFriendsDropDown ) then
			local list = HoloFriends_GetList();
			local newgroup = UnitPopupButtons[button].text;
			if ( newgroup ~= SEARCH ) then
				if ( name and string.sub(name,1,2) == "|K" ) then
					HoloFriends_SetSelectedEntry(id);
					if ( list[id].btag ) then
						StaticPopup_Show("HOLOFRIENDS_GETREALIDNAMEBTAG", name);
					elseif ( list[id].bnetid ) then
						StaticPopup_Show("HOLOFRIENDS_GETREALIDNAMEBNETID", name);
					end
					return;
				end
				list[id].group = newgroup;
				HoloFriends_DeselectEntry();
				HoloFriends_chat("HoloFriends_List_Update at button == HOLOFRIENDS_GROUPn", HF_DEBUG_OUTPUT);
				HoloFriends_List_Update();
				if ( HoloFriends_ShareFrame:IsVisible() ) then
					HoloFriendsShare_OnShow(HoloFriends_ShareFrame);
				end
			end
		elseif ( dropdownFrame == HoloIgnoreDropDown ) then
			local list = HoloIgnore_GetList();
			local newgroup = UnitPopupButtons[button].text;
			if ( newgroup ~= SEARCH ) then
				list[id].group = newgroup;
				HoloIgnore_DeselectEntry();
				HoloFriends_chat("HoloIgnore_List_Update at button == HOLOFRIENDS_GROUPn", HF_DEBUG_OUTPUT);
				HoloIgnore_List_Update();
				if ( HoloIgnore_ShareFrame:IsVisible() ) then
					HoloFriendsShare_OnShow(HoloIgnore_ShareFrame);
				end
			end
		end
	elseif ( button == "HOLOFRIENDS_ADDGROUP" ) then
		if ( dropdownFrame == HoloFriendsDropDown ) then
			StaticPopup_Show("HOLOFRIENDS_ADDGROUP");
		elseif ( dropdownFrame == HoloIgnoreDropDown ) then
			StaticPopup_Show("HOLOIGNORE_ADDGROUP");
		end
	elseif ( button == "HOLOFRIENDS_RENAMEGROUP" ) then
		if ( dropdownFrame == HoloFriendsDropDown ) then
			StaticPopup_Show("HOLOFRIENDS_RENAMEGROUP");
		elseif ( dropdownFrame == HoloIgnoreDropDown ) then
			StaticPopup_Show("HOLOIGNORE_RENAMEGROUP");
		end
	elseif ( button == "HOLOFRIENDS_REMOVEFRIEND" ) then
		HoloFriends_RemoveFriend(id);
	elseif ( button == "HOLOFRIENDS_REMOVEIGNORE" ) then
		HoloIgnore_RemoveIgnore(id);
	elseif ( button == "HOLOFRIENDS_REMOVEGROUP" ) then
		if ( dropdownFrame == HoloFriendsDropDown ) then
			HoloFriendsLists_RemoveGroup(HoloFriends_GetList(), id, FRIENDS);
			HoloFriends_DeselectEntry();
			HoloFriends_chat("HoloFriends_List_Update at button == HOLOFRIENDS_REMOVEGROUP", HF_DEBUG_OUTPUT);
			HoloFriends_List_Update();
			if ( HoloFriends_ShareFrame:IsVisible() ) then
				HoloFriendsShare_OnShow(HoloFriends_ShareFrame);
			end
		elseif ( dropdownFrame == HoloIgnoreDropDown ) then
			HoloFriendsLists_RemoveGroup(HoloIgnore_GetList(), id, IGNORE);
			HoloIgnore_DeselectEntry();
			HoloFriends_chat("HoloIgnore_List_Update at button == HOLOFRIENDS_REMOVEGROUP", HF_DEBUG_OUTPUT);
			HoloIgnore_List_Update();
			if ( HoloIgnore_ShareFrame:IsVisible() ) then
				HoloFriendsShare_OnShow(HoloIgnore_ShareFrame);
			end
		end
	elseif ( button == "HOLOFRIENDS_TURNINFO" ) then
		HOLOFRIENDS_TURNINFO = HOLOFRIENDS_TURNINFO + 1;
		if ( HOLOFRIENDS_TURNINFO > 2 ) then HOLOFRIENDS_TURNINFO = 0; end
		HoloFriends_chat("HoloFriends_List_Update from HoloFriendsDropDown[HOLOFRIENDS_TURNINFO]", HF_DEBUG_OUTPUT);
		HoloFriends_List_Update();
	elseif ( button == "HOLOFRIENDS_WHOREQUEST" ) then
		HoloFriendsFuncs_WhoCheckPlayer(name);
	end
end


local function HFF_ShowMenuButtonTooltip(index)
	local listFrame = _G["DropDownList1"];
	local listFrameName = listFrame:GetName();
	local buttonName = listFrameName.."Button"..index;
	local button = _G[buttonName]
	local invisibleButton = _G[buttonName.."InvisibleButton"];

	invisibleButton:Hide();
	button:Enable();
	button.tooltipTitle = HOLOFRIENDS_TOOLTIPDISABLEDMENUENTRYTITLE;
	button.tooltipText = HOLOFRIENDS_TOOLTIPDISABLEDMENUENTRYHINT;
	button.tooltipOnButton = 1;
	button.tooltipWhileDisabled = 1;
	button:Disable();
	invisibleButton:Show();
end

local function isFrame(frame)
	return type(frame) == "table" and type(rawget(frame, 0)) == "userdata" and type(rawget(frame, 'initialize')) == "function" and getmetatable(frame) and rawget(getmetatable(frame), '__index') and type(rawget(getmetatable(frame), '__index').GetFrameStrata) == "function"
end

-- Disable buttons in opend drop down menu
function HoloFriends_UnitPopup_OnUpdate(elapsed)
	if ( not DropDownList1:IsShown() ) then return; end
	if ( not UIDROPDOWNMENU_OPEN_MENU ) then return; end
	if ( not isFrame(UIDROPDOWNMENU_OPEN_MENU) ) then return; end

	local menuName = UIDROPDOWNMENU_OPEN_MENU:GetName();
	if ( not menuName ) then return; end

	-- If none of the unitpopup frames are visible then return
	for index, value in pairs(UnitPopupFrames) do
		if ( menuName == value ) then
			break;
		elseif ( index == #UnitPopupFrames ) then
			return;
		end
	end

	local dropdown = UIDROPDOWNMENU_OPEN_MENU;
	local which = OPEN_DROPDOWNMENUS[1].which;
	local player = dropdown.name;
	if ( not player ) then player = UnitName(dropdown.unit); end

	if ( which == "HOLOFRIENDS_LIST" ) then
		local list = HoloFriends_GetList();
		local id = dropdown.userData;
		local count = 0;
		for index, value in ipairs(UnitPopupMenus[which]) do
			if ( UnitPopupShown[1][index] == 1 ) then
				count = count + 1;

				-- for myself hide invite
				if ( HoloFriendsLists_GetName(list, id) == UnitName("player")) then
					if ( value == "HOLOFRIENDS_INVITE" ) then
						UIDropDownMenu_DisableButton(1, count + 1);
					end
				else
					-- hide the whisper, invite, and who buttons, if player offline
					if ( not HoloFriendsLists_IsConnected(list, id) ) then
						if ( value == "HOLOFRIENDS_WHISPER" ) then
							UIDropDownMenu_DisableButton(1, count + 1);
						end
						-- but show who button if automatic who scan is disabled
						if ( value == "HOLOFRIENDS_WHOREQUEST" ) then
							if ( not HOLOFRIENDS_OPTIONS.DisableWho ) then
									UIDropDownMenu_DisableButton(1, count + 1);
							else
								if ( HoloFriendsLists_GetNotify(list, HoloFriends_GetSelectedEntry()) ) then
										UIDropDownMenu_DisableButton(1, count + 1);
								end
							end
						end
						-- but show the invite button for groups
						if ( (value == "HOLOFRIENDS_INVITE") and not HoloFriendsLists_IsGroup(list, id) ) then
							UIDropDownMenu_DisableButton(1, count + 1);
						end
					end
				end

				-- hide the who and invite button, if different faction, or realm
				if ( HoloFriendsLists_IsRealID(list, id) ) then
					if ( not HoloFriendsLists_SameFaction(list, id) ) then
						if ( (value == "HOLOFRIENDS_INVITE") or (value == "HOLOFRIENDS_WHOREQUEST") ) then
							UIDropDownMenu_DisableButton(1, count + 1);
						end
					end
					if ( not HoloFriendsLists_SameRealm(list, id) ) then
						if ( value == "HOLOFRIENDS_WHOREQUEST" ) then
							UIDropDownMenu_DisableButton(1, count + 1);
						end
					end
				end

				-- hide the move to group and remove friend button for groups
				if ( HoloFriendsLists_IsGroup(list, id) ) then
					if ( (value == "HOLOFRIENDS_MOVETOGROUP") or (value == "HOLOFRIENDS_REMOVEFRIEND") ) then
						UIDropDownMenu_DisableButton(1, count + 1);
					end
					-- hide also the sub-menu
					if ( value == "HOLOFRIENDS_MOVETOGROUP" ) then
						local button = _G["DropDownList1Button"..count+1];
						_G[button:GetName().."ExpandArrow"]:Hide();
						button.hasArrow = nil;
					end
					-- hide the invite button for groups without online players
					if ( (value == "HOLOFRIENDS_INVITE") and (list[id].numonline == 0) ) then
						UIDropDownMenu_DisableButton(1, count + 1);
					end
				end

				-- hide the rename, and remove group button, if no group
				if ( not HoloFriendsLists_IsGroup(list, id) ) then
					if ( (value == "HOLOFRIENDS_RENAMEGROUP") or (value == "HOLOFRIENDS_REMOVEGROUP") ) then
						UIDropDownMenu_DisableButton(1, count + 1);
					end
				else
					-- hide the rename, and remove group button for the groups FRIENDS, and SEARCH
					if ( (HoloFriendsLists_GetGroup(list, id) == FRIENDS) or
						(HoloFriendsLists_GetGroup(list, id) == SEARCH) ) then
						if ( (value == "HOLOFRIENDS_RENAMEGROUP") or (value == "HOLOFRIENDS_REMOVEGROUP") ) then
							UIDropDownMenu_DisableButton(1, count + 1);
						end
					end
				end
			end
		end
	end

	if ( which == "HOLOIGNORE_LIST" ) then
		local list = HoloIgnore_GetList();
		local id = dropdown.userData;
		local count = 0;
		for index, value in ipairs(UnitPopupMenus[which]) do
			if ( UnitPopupShown[1][index] == 1 ) then
				count = count + 1;

				-- hide the move to group and remove ignore buttons for groups
				if ( HoloFriendsLists_IsGroup(list, id) ) then
					if ( (value == "HOLOFRIENDS_MOVETOGROUP") or (value == "HOLOFRIENDS_REMOVEIGNORE") ) then
						UIDropDownMenu_DisableButton(1, count + 1);
					end
					-- hide also the sub-menu
					if ( value == "HOLOFRIENDS_MOVETOGROUP" ) then
						local button = _G["DropDownList1Button"..count+1];
						_G[button:GetName().."ExpandArrow"]:Hide();
						button.hasArrow = nil;
					end
				end

				-- hide the rename, and remove group button, if no group
				if ( not HoloFriendsLists_IsGroup(list, id) ) then
					if ( (value == "HOLOFRIENDS_RENAMEGROUP") or (value == "HOLOFRIENDS_REMOVEGROUP") ) then
						UIDropDownMenu_DisableButton(1, count + 1);
					end
				else
					-- hide the rename, and remove group button for the groups IGNORE, and SEARCH
					if ( (HoloFriendsLists_GetGroup(list, id) == IGNORE) or
						(HoloFriendsLists_GetGroup(list, id) == SEARCH) ) then
						if ( (value == "HOLOFRIENDS_RENAMEGROUP") or (value == "HOLOFRIENDS_REMOVEGROUP") ) then
							UIDropDownMenu_DisableButton(1, count + 1);
						end
					end
				end
			end
		end
	end

	if ( HOLOFRIENDS_OPTIONS.MenuNoTaint ) then return; end
	if ( (which == "PARTY") or (which == "PLAYER") or (which == "RAID") or (which == "FRIEND") ) then
		local nameinignore = HoloFriendsLists_ContainsPlayer(HoloIgnore_GetList(),player);
		local nameinfriends = HoloFriendsLists_ContainsPlayer(HoloFriends_GetList(), player);
		local myname = UnitName("player");
		local count = 0;
		for index, value in ipairs(UnitPopupMenus[which]) do
			if ( UnitPopupShown[1][index] == 1 ) then
				count = count + 1;
				-- disable add player to list if it exist already at one of the lists
				if ( nameinignore or nameinfriends or (player == myname) ) then
					if ( (value == "HOLOFRIENDS_ADDIGNORE") or
					     (value == "HOLOFRIENDS_ADDFRIEND") )
					then
						UIDropDownMenu_DisableButton(1, count + 1);
					end
				end
				-- disable the protected function set focus for this tainted menu (gives en error)
				if ( (value == "SET_FOCUS") and (which == "PLAYER") and HoloFriends_MenuModTDone ) then
					HFF_ShowMenuButtonTooltip(count+1);
					UIDropDownMenu_DisableButton(1, count + 1);
				end
				if ( (value == "SET_FOCUS") and (which == "PARTY") and HoloFriends_MenuModPDone ) then
					HFF_ShowMenuButtonTooltip(count+1);
					UIDropDownMenu_DisableButton(1, count + 1);
				end
				if ( (value == "SET_FOCUS") and (which == "RAID") and HoloFriends_MenuModRDone ) then
					HFF_ShowMenuButtonTooltip(count+1);
					UIDropDownMenu_DisableButton(1, count + 1);
				end
				if ( (value == "RAID_MAINTANK") and (which == "RAID") and HoloFriends_MenuModRDone ) then
					HFF_ShowMenuButtonTooltip(count+1);
					UIDropDownMenu_DisableButton(1, count + 1);
				end
				if ( (value == "TARGET") and (which == "FRIEND") and HoloFriends_MenuModFDone ) then
					HFF_ShowMenuButtonTooltip(count+1);
					UIDropDownMenu_DisableButton(1, count + 1);
				end
			end
		end
	end
end


-- Remove original IGNORE-button in modified drop down menu
function HoloFriends_UnitPopup_HideButtons()
	local dropdownMenu = UIDROPDOWNMENU_INIT_MENU;
	local which = dropdownMenu.which;
	if ( which == "FRIEND" and HoloFriends_MenuModFDone ) then
		for index, value in ipairs(UnitPopupMenus[which]) do
			if ( value == "IGNORE" ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		end
	end
	if ( which == "PLAYER" and HoloFriends_MenuModTDone ) then
		for index, value in ipairs(UnitPopupMenus[which]) do
			if ( value == "ADD_FRIEND" ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
			if ( value == "ADD_FRIEND_MENU" ) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		end
	end
end


-- Filter to ignore messages for offline ignores
local HF_OldMsgID = "";
local HF_MsgID = "";
function HoloFriends_IgnoreChatMsg_EventFilter(self, event, msg, author)
	if ( not msg or (msg == "") ) then return; end
	local list = HoloIgnore_GetList();
	local index = HoloFriendsLists_ContainsPlayer(list, author);
	if ( index and (list[index].name == UnitName("player")) ) then index = nil; end -- prevent endless loop
	if ( index and not list[index].notify ) then
		if ( (event == "CHAT_MSG_WHISPER") and HOLOFRIENDS_OPTIONS.MsgIgnoredWhisper ) then
			HF_MsgID = author.."-"..msg;
			if ( HF_MsgID ~= HF_OldMsgID ) then
				local name = UnitName("player");
				local message = format(CHAT_IGNORED, name).." (HoloFriends)";
				SendChatMessage(message, "WHISPER", nil, author);
				HF_OldMsgID = HF_MsgID;
			end
		end
		return true;
	end
end


-- Event filter for CHAT_MSG_SYSTEM messages
-- This is called for every chat frame which displays system messages
-- msgNr seems to be a message counter, which is the same for the same message
local HF_OnlineTestTime = 0;
-- save the last message number to skip it in all message frames
local HF_LastSkippedMsg = 0;
function HoloFriends_ChatMsgSystem_EventFilter(self, event, msg,_,_,_,_,_,_,_,_,_, msgNr)
	if ( type(msg) ~= "string" ) then return; end
	if ( msgNr == HF_LastSkippedMsg ) then return true; end

	local skipmsg = false;

	-- friends handling

	if ( string.match(msg, HF_ERR_FRIEND_ADDED_S) ) then
		if ( HoloFriends_EventFlags.IgnoreAddSysMsg ) then
			HoloFriends_EventFlags.IgnoreAddSysMsg = false;
			skipmsg = true;
			if ( not HoloFriends_EventFlags.Quiet ) then
				local name = HoloFriends_EventFlags.Name;
				local HFmsg = format(HOLOFRIENDS_MSGFRIENDONLINEENABLED, name);
				HoloFriendsFuncs_SystemMessage(HFmsg);
			end
		end
	end

	if ( string.match(msg, HF_ERR_FRIEND_REMOVED_S) ) then
		if ( HoloFriends_EventFlags.IgnoreRemoveSysMsg ) then
			HoloFriends_EventFlags.IgnoreRemoveSysMsg = false;
			skipmsg = true;
			if ( not HoloFriends_EventFlags.Quiet ) then
				local name = HoloFriends_EventFlags.Name;
				local HFmsg = format(HOLOFRIENDS_MSGFRIENDONLINEDISABLED, name);
				HoloFriendsFuncs_SystemMessage(HFmsg);
			end
		end
	end

	--if ( string.match(msg, HF_ERR_FRIEND_ALREADY_S) ) then print("???"); end
	--if ( string.match(msg, ERR_FRIEND_LIST_FULL) ) then print("???"); end
	if ( string.match(msg, ERR_FRIEND_NOT_FOUND) ) then
		HoloFriendsFuncs_CheckRunListUpdate(HoloFriends_EventFlags); -- because, this give no UPDATEevent
	end
	if ( string.match(msg, ERR_FRIEND_SELF) ) then
		HoloFriendsFuncs_CheckRunListUpdate(HoloFriends_EventFlags); -- because, this give no UPDATEevent
	end
	if ( string.match(msg, ERR_FRIEND_WRONG_FACTION) ) then
		HoloFriendsFuncs_CheckRunListUpdate(HoloFriends_EventFlags); -- because, this give no UPDATEevent
	end

	-- ignoress handling

	if ( string.match(msg, HF_ERR_IGNORE_ADDED_S) ) then
		if ( HoloIgnore_EventFlags.IgnoreAddSysMsg ) then
			HoloIgnore_EventFlags.IgnoreAddSysMsg = false;
			skipmsg = true;
			if ( not HoloIgnore_EventFlags.Quiet ) then
				local name = HoloIgnore_EventFlags.Name;
				local HFmsg = format(HOLOFRIENDS_MSGIGNOREONLINEENABLED, name);
				HoloFriendsFuncs_SystemMessage(HFmsg);
			end
		end
	end

	if ( string.match(msg, HF_ERR_IGNORE_REMOVED_S) ) then
		if ( HoloIgnore_EventFlags.IgnoreRemoveSysMsg ) then
			HoloIgnore_EventFlags.IgnoreRemoveSysMsg = false;
			skipmsg = true;
			if ( not HoloIgnore_EventFlags.Quiet ) then
				local name = HoloIgnore_EventFlags.Name;
				local HFmsg = format(HOLOFRIENDS_MSGIGNOREONLINEDISABLED, name);
				HoloFriendsFuncs_SystemMessage(HFmsg);
			end
		end
	end

	--if ( string.match(msg, HF_ERR_IGNORE_ALREADY_S) ) then print("???"); end
	--if ( string.match(msg, ERR_IGNORE_FULL) ) then print("???"); end
	if ( string.match(msg, ERR_IGNORE_NOT_FOUND) ) then
		HoloFriendsFuncs_CheckRunListUpdate(HoloIgnore_EventFlags); -- because, this give no UPDATEevent
	end
	if ( string.match(msg, ERR_IGNORE_SELF) ) then
		HoloFriendsFuncs_CheckRunListUpdate(HoloIgnore_EventFlags); -- because, this give no UPDATEevent
	end

	-- handling of SendAddonMessage "WHISPER" player not found (test of online status)
	-- (directly after the player test follows a test of a none existing default player)

	local message = strlower(msg);
	if ( HoloFriends_queryingThisGuy ) then
		local playerNotFoundMsg = strlower(format(ERR_CHAT_PLAYER_NOT_FOUND_S, HoloFriends_queryingThisGuy));
		if ( message == playerNotFoundMsg ) then
			HF_OnlineTestTime = GetTime();
			skipmsg = true;
		end
	end
	-- expect the answer to the default player max. 2.5 seconds after the player
	-- (a who-check is done every 5.1 seconds)
	if ( message == HF_DefaultNotFoundMsg ) then
		if ( GetTime() > HF_OnlineTestTime + 2.5 ) then
			HoloFriendsFuncs_WhoCheckPlayer(HoloFriends_queryingThisGuy, HF_QUIET, true)
		end
		HF_OnlineTestTime = 0;
		skipmsg = true;
	end

	-- who-scan handling

	if ( GetTime() < HoloFriends_interceptWhoResults + HoloFriends_whoCheckInterval ) then
		if ( string.match(msg, HF_WHO_LIST_FORMAT) ) then
			HoloFriends_chat("Intercepted who result: "..msg, HF_DEBUG_OUTPUT);
			skipmsg = true;
		elseif ( string.match(msg, HF_WHO_LIST_GUILD_FORMAT) ) then
			HoloFriends_chat("Intercepted who result: "..msg, HF_DEBUG_OUTPUT);
			skipmsg = true;
		elseif ( string.match(msg, HoloFriends_WHO_NUM_RESULTS) ) then
			HoloFriends_chat("Intercepted who total: "..msg, HF_DEBUG_OUTPUT);
			HoloFriends_interceptWhoResults = 0;
			skipmsg = true;
		end
	else
		HoloFriends_interceptWhoResults = 0;
	end

	if ( skipmsg ) then
		HF_LastSkippedMsg = msgNr;
		return true;
	end

end


-- Prevent popup of who-window during scan in case of many who-results
--function HoloFriends_FriendsFrame_OnEvent(self, event, ...)
--	local skip = false;
--	if ( (event == "WHO_LIST_UPDATE") and 
--	     (GetTime() < HoloFriends_interceptWhoResults + HoloFriends_whoCheckInterval) )
--	then
--		skip = true;
--	end
--	if ( not skip ) then
--		HFF_FriendsFrame_OnEvent_Orig(self, event, ...);
--	end
--end
