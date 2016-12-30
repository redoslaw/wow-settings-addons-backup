--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file defines common functions for *_friends, *_ignore and *_share

]]

local HF_Version = tonumber(GetAddOnMetadata("HoloFriends", "Version"));

-- maximum number of merges of friends comment with blizz note without an edit of the comment
local HF_MaxMergeCount = 9;

local HF_MaxSecondsOfUnusedFactionsFriendsList = 2592000; -- 30 days

local HF_LibWhoCount = 0;


function HoloFriendsFuncs_Version()
	return HF_Version;
end

-- Check for LibWho with HoloFriends_OnUpdate() in HoloFriends_friends.lua
function HoloFriendsFuncs_CountLibWho(add)
	if ( add ) then
		HF_LibWhoCount = HF_LibWhoCount + 1;
	else
		HF_LibWhoCount = HF_LibWhoCount - 1;
	end
end


--[[
]]
function HoloFriendsFuncs_SeparateFirstString(msg)
	local a = "";
	local b = "";
	if ( msg and (msg ~= "") ) then
		-- find contiguous string of non-space characters
		a, b = strmatch(msg, "%s*([^%s]+)%s*(.*)");
		if ( not a ) then a = ""; end
		if ( not b ) then b = ""; end
	end
	return a, b;
end


--[[
  print a message in default chat with system colors
  @param msg - String
]]
function HoloFriendsFuncs_SystemMessage(msg)
	if ( not msg ) then return; end

	local info = ChatTypeInfo["SYSTEM"];
	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, info.r, info.g, info.b, info.id);
	end
end


--[[
  setup a who request to change the list entry of the given player
  @param name - str
  @param quiet - boolean
]]
local HF_LastWhoCheck = 0;
function HoloFriendsFuncs_WhoCheckPlayer(name0, quiet, who)
	if ( not name0 or name0 == "" ) then return; end
	if ( HOLOFRIENDS_OPTIONS.DisableWho ) then return; end

	-- check for space in name -> RealID -> get toon
	if ( string.find(name0, " ") ) then
		local list = HoloFriends_GetList();
		local index = HoloFriendsLists_ContainsPlayer(list, name0);
		if ( not index ) then return; end
		local name, client = HoloFriendsLists_GetToon(list, index);
		local notify = HoloFriendsLists_GetNotify(list, index);
		if ( not name or not notify or not (client == 'WoW') ) then
			return;
		end
	else
		name = name0;
	end

	-- test if the player is online for quiet requests and
	-- do the real who-check only if the player is online
	if ( quiet and not who ) then
		HoloFriends_queryingThisGuy = name;
		SendAddonMessage("amcetest", "", "WHISPER", name);
		SendAddonMessage("amcetest", "", "WHISPER", "amcetestplayer");
		return;
	end

	-- skip any who request if LibWho has a request in its pipeline
	-- Thats, because WIM is not checking if a Who()-result is of its own request.
	-- ##### HoloFriends takes no care of skiped who-requests for now,
	-- but this is only a problem with the WhoScan of offline friends
	if ( HF_LibWhoCount > 0 ) then return; end

	-- only one who-check every HoloFriends_whoCheckInterval
	if ( GetTime() < HF_LastWhoCheck + HoloFriends_whoCheckInterval ) then return; end
	HF_LastWhoCheck = GetTime();

	if ( quiet ) then
		HoloFriends_interceptWhoResults = GetTime();
		SetWhoToUI(false);
		HoloFriends_queryingThisGuy = name;
	end

	-- check for minus in name -> realm is given
	if ( string.find(name, "-") ) then
		SendWho('n-"'..name..'"');
	else
		-- else add the realm to limit the search results
		local realm = GetRealmName();
		SendWho('n-"'..name..'-'..realm..'"');
	end
end


--[[
  check and sync online note and list comment of friends list
  @param playerIndex - int
  @param onlineIndex - int
  @param note - str
]]
function HoloFriendsFuncs_CheckComment(playerIndex, onlineIndex, note)
	if ( not playerIndex ) then return; end

	local list = HoloFriends_GetList();
	if ( not list[playerIndex].notify ) then return; end

	local RealID = list[playerIndex].realid;

	if ( not onlineIndex ) then
		local name = list[playerIndex].name;
		local numNotifyFriends;
		if ( RealID ) then numNotifyFriends = BNGetNumFriends();
		              else numNotifyFriends = GetNumFriends(); end
		for inum = 1, numNotifyFriends do
			local iname;
			if ( RealID ) then
				_, iname = BNGetFriendInfo(inum);
			else
				iname = GetFriendInfo(inum);
			end
			if ( iname == name ) then
				onlineIndex = inum;
			end
		end
	end
	if ( not onlineIndex ) then return; end

	if ( not note ) then
		if ( RealID ) then _, _, _, _, _, _, _, _, _, _, _, _, note = BNGetFriendInfo(onlineIndex);
		              else _, _, _, _, _, _, note = GetFriendInfo(onlineIndex); end
	end

	local NotFaction = HoloFriendsFuncs_IsCharDataAvailable(HOLOFRIENDS_LIST, UnitName("player"));
	local NMerge = HOLOFRIENDS_OPTIONS.MergeNotes;
	if ( not NotFaction ) then NMerge = false; end
	local NPrior = HOLOFRIENDS_OPTIONS.NotesPriority;
	if ( RealID ) then NPrior = true; end

	local setNote = HoloFriendsFuncs_MergeComment(list[playerIndex], note, 0, NMerge, NPrior);
	if ( setNote ) then
		local comment = list[playerIndex].comment;
		if ( not comment ) then comment = ""; end
		if ( RealID ) then
			local pID = BNGetFriendInfo(onlineIndex);
			BNSetFriendNote(pID, comment);
		else
			HoloFriends_EventFlags.SetFriendNotes = true;
			SetFriendNotes(onlineIndex, comment);
		end
	end
end


--[[
  merge comment from list entry with note (return flag for changed note)
  @param entry - table
  @param note - str
  @param notecnt - int (merge count of the note)
  @param MergeNotes - bol
  @param NotesPriority - bol
]]
function HoloFriendsFuncs_MergeComment(entry, note, notecnt, MergeNotes, NotesPriority)
	if ( not entry ) then return; end

	if ( not entry.comment or (entry.comment == "") ) then
		if ( note and note ~= "" ) then
			if ( not MergeNotes and not NotesPriority ) then
				return true;
			else
				entry.comment = note;
			end
		end
		return false;
	end

	if ( not note or (note == "") ) then
		if ( not MergeNotes and NotesPriority ) then
			entry.comment = nil;
			return false;
		else
			return true;
		end
	end

	if ( string.sub(entry.comment,1,strlen(note)) == note ) then return false; end

	if ( not entry.mergecnt ) then entry.mergecnt = 0; end
	if ( not notecnt ) then notecnt = 0; end

	if ( MergeNotes ) then
		if ( entry.mergecnt + notecnt <= HF_MaxMergeCount ) then
			if ( NotesPriority ) then
				entry.comment = note.." ; "..entry.comment;
			else
				entry.comment = entry.comment.." ; "..note;
			end
			entry.mergecnt = entry.mergecnt + notecnt + 1;
			return true;
		end
	else
		if ( NotesPriority ) then
			entry.comment = note;
		else
			return true;
		end
	end

	return false;
end


--[[
  sorts players ascending after group and name
  @param a - Table (must have 'group' and 'name')
  @param b - Table (must have 'group' and 'name')
]]
function HoloFriendsFuncs_CompareEntry(a, b)
	local fa = a.search;
	local fb = b.search;
	if ( not fa ) then fa = "3"; end
	if ( not fb ) then fb = "3"; end
	local aname = a.name or " "
	local bname = b.name or " "
	local agroup = a.group or " ";
	local bgroup = b.group or " ";
	local ca = "1";
	local cb = "1";
	if ( HOLOFRIENDS_OPTIONS.SortOnline ) then
		if ( a.connected or (aname == "0") or (aname == "1") ) then ca = "0"; end
		if ( b.connected or (bname == "0") or (bname == "1") ) then cb = "0"; end
	end
	local len = math.max(string.len(agroup), string.len(bgroup));
	local sa = fa..string.format('%-'..len..'s',agroup)..ca..aname;
	local sb = fb..string.format('%-'..len..'s',bgroup)..cb..bname;
	return sa < sb;
end


--[[
  check the online friends list if the given friend is included
  @param friend - str (friends name)
]]
function HoloFriendsFuncs_IsFriendAtOnlineList(friend)
	if ( not friend ) then return; end

	-- check WoW friends list
	for idx = 1, GetNumFriends() do
		local name = GetFriendInfo(idx);
		if ( name == friend ) then return 1; end
	end

	-- check Bnet friends list
	-- (Problem: the name is no guaranteed return value)
	for idx = 1, BNGetNumFriends() do
		local _, name = BNGetFriendInfo(idx);
		if ( name ) then
			if ( name == friend ) then return 2; end
		end
	end

	return false;
end


--[[
  check the online ignore list if the given player is included
  @param ignore - str (player name)
]]
function HoloFriendsFuncs_IsIgnoreAtOnlineList(ignore)
	if ( not ignore ) then return; end

	for idx = 1, GetNumIgnores() do
		local name = GetIgnoreName(idx);
		if ( name == ignore ) then return true; end
	end
	return false;
end


--[[
  add the player to the friends or ignore server list
  @param flags - Table
  @param note - str
]]
function HoloFriendsFuncs_AddToServerList(flags, note)
	if ( not flags ) then return; end
	local name = flags.Name;
	if ( not name or (name == "") ) then return false; end

	local skip = true;
	if ( flags.Type == "FL" ) then
		if ( not string.find(name, "@") and not string.find(name, "#") ) then
			skip = HoloFriendsFuncs_IsFriendAtOnlineList(name);
		else
			skip = false;
		end
	end
	if ( flags.Type == "IL" ) then
		skip = HoloFriendsFuncs_IsIgnoreAtOnlineList(name);
	end

	if ( not skip ) then
		flags.SetNotify = true;
		flags.IgnoreAddSysMsg = true;
		if ( flags.Type == "FL" ) then 
			if ( string.find(name, "@") or string.find(name, "#") ) then
				if ( BNFeaturesEnabledAndConnected() ) then
					BNSendFriendInvite(name, note);
				end
				flags.SetNotify = false;
				flags.IgnoreAddSysMsg = false;
				return;
			else
				AddFriend(name);
				flags.TimeStep = time();
			end
		end
		if ( flags.Type == "IL" ) then
			AddIgnore(name);
			flags.TimeStep = time();
		end
		return true;
	end
	return false;
end


--[[
  remove the player from the friends or ignore server list
  @param flags - Table
]]
function HoloFriendsFuncs_RemoveFromServerList(flags)
	if ( not flags ) then return; end
	local name = flags.Name;
	if ( not name or (name == "") ) then return false; end

	local noskip = false;
	if ( flags.Type == "FL" ) then
		noskip = HoloFriendsFuncs_IsFriendAtOnlineList(name);
	end
	if ( flags.Type == "IL" ) then
		noskip = HoloFriendsFuncs_IsIgnoreAtOnlineList(name);
	end

	if ( noskip ) then
		flags.SetNotify = true;
		flags.IgnoreRemoveSysMsg = true;
		if ( flags.Type == "FL" ) then
			-- return value of "2" for BNet by HoloFriendsFuncs_IsFriendAtOnlineList
			if ( noskip == 2 ) then
				-- first check if BNet is available
				if ( not BNFeaturesEnabledAndConnected() ) then
					HoloFriendsFuncs_SystemMessage(HOLOFRIENDS_MSGFRIENDNOBNETNOREMOVE);
					return false;
				end
				local numFriends = BNGetNumFriends();
				local pID;
				for inum = 1, numFriends do
					local ID, iname = BNGetFriendInfo(inum);
					if ( iname == name ) then pID = ID; end
				end
				if ( not pID ) then return false; end
				BNRemoveFriend(pID);
			else
				RemoveFriend(name);
				flags.TimeStep = time();
			end
		end
		if ( flags.Type == "IL" ) then
			DelIgnore(name);
			flags.TimeStep = time();
		end
		return true;
	end
	return false;
end


--[[
  check and execute the RunListUpdate variable
  @param flags - Table
]]
function HoloFriendsFuncs_CheckRunListUpdate(flags)
	if ( not flags ) then return; end

	HoloFriends_chat("HoloFriendsFuncs_CheckRunListUpdate: "..flags.RunListUpdate, HF_DEBUG_OUTPUT);

	flags.SetNotify = false;

	if ( flags.RunListUpdate == "RunUpdate" ) then
		flags.RunListUpdate = "";
		if ( flags.Type == "FL" ) then HoloFriends_List_Update(); end
		if ( flags.Type == "IL" ) then HoloIgnore_List_Update(); end
		return;
	end
	if ( time() > flags.ListUpdateStartTime + HoloFriends_ListUpdateDelay ) then
		HoloFriends_chat("HoloFriendsFuncs_CheckRunListUpdate: timeout", HF_DEBUG_OUTPUT);
		flags.RunListUpdate = "";
	end
	if ( flags.RunListUpdate == "RunLocal" ) then
		flags.RunListUpdate = "";
		if ( flags.Type == "FL" ) then HoloFriends_CheckLocalList(); end
		if ( flags.Type == "IL" ) then HoloIgnore_CheckLocalList(); end
		return;
	end
	if ( flags.RunListUpdate == "RunServer" ) then
		flags.RunListUpdate = "";
		if ( flags.Type == "FL" ) then HoloFriends_CheckServerList(); end
		if ( flags.Type == "IL" ) then HoloIgnore_CheckServerList(); end
		return;
	end
	if ( flags.RunListUpdate == "RunShow" ) then
		flags.RunListUpdate = "";
		if ( flags.Type == "FL" ) then HoloFriends_UpdateFriendsList(); end
		if ( flags.Type == "IL" ) then HoloIgnore_UpdateIgnoreList(); end
	end
end


--[[
  check, if it is a temporary list and if it has to be removed
  @param completeList - Table
  @param list - Table (friends or ignore list of character = player)
  @param player - String (name of character)
]]
local function HFF_CheckToRemoveTempList(completeList, list, player, FLinit)
	local realm = GetRealmName();
	local is_temp_list = false;
	local remove_temp_list = false;

	local idx;
	if ( FLinit ) then
		idx = HoloFriendsLists_ContainsGroup(list, FRIENDS);
	else
		idx = HoloFriendsLists_ContainsGroup(list, IGNORE);
	end
	if ( not idx ) then return; end
	
	if ( list[idx].temporary ) then is_temp_list = true; end
	if ( list[idx].remove ) then remove_temp_list = true; end

	-- if still temporary list, but no remove flag, show dialog again
	if ( is_temp_list and not remove_temp_list ) then
		if ( FLinit ) then
			StaticPopup_Show("HOLOFRIENDS_LOADFACTIONSFRIENDSLIST");
		else
			StaticPopup_Show("HOLOFRIENDS_LOADFACTIONSIGNORELIST");
		end
	end

	-- if remove flag is set, remove this list
	if ( is_temp_list and remove_temp_list ) then
		completeList[realm][player] = nil;
	end
	return remove_temp_list;
end


--[[
  check, if this faction wide list was not used for a long time -> load temporary list
  @param completeList - Table
  @param list - Table (friends or ignore list of character = player)
  @param player - String (name of character)
]]
local function HFF_CheckTimeOfLastUse(completeList, list, player, FLinit)
	local realm = GetRealmName();
	local idx;

	if ( FLinit ) then
		idx = HoloFriendsLists_ContainsGroup(list, FRIENDS);
	else
		idx = HoloFriendsLists_ContainsGroup(list, IGNORE);
	end
	if ( not idx ) then return; end

	if ( idx ) then
		if ( list[idx].lastuse ) then
			local dt = time() - list[idx].lastuse;
			if ( dt > HF_MaxSecondsOfUnusedFactionsFriendsList ) then
				-- use empty list
				completeList[realm][player] = {};
				list = completeList[realm][player];
				-- mark as temporary in the FRIENDS-group entry
				local temp = {};
				temp.name = "1";
				temp.group = FRIENDS;
				temp.temporary = 1;
				table.insert(list, temp);
				-- start dialog to ask user if factions friends list should be used
				if ( FLinit ) then
					StaticPopup_Show("HOLOFRIENDS_LOADFACTIONSFRIENDSLIST");
				else
					StaticPopup_Show("HOLOFRIENDS_LOADFACTIONSIGNORELIST");
				end
				return true;
			end
		end
	end
	return false;
end


--[[
  load data from the char 'player' on the current realm
  @param completeList - Table
  @param player - String (name of character)
  @param FLinit - bol (flag for initialisation of friends list)
  @param share - bol (flag if called from share)
]]
function HoloFriendsFuncs_LoadList(completeList, player, FLinit, share)
	if ( not completeList or not player ) then return; end

	local listVersion = completeList.version;
	local realm = GetRealmName();
	local faction = UnitFactionGroup("player");
	local result = nil;
  
	if ( listVersion and listVersion > HF_Version ) then
		HoloFriendsFuncs_SystemMessage(format(HOLOFRIENDS_INITINVALIDLISTVERSION, listVersion));
		-- HOLOFRIENDS_LIST or HOLOIGNORE_LIST won't be used
		completeList = {};
		completeList.version = HF_Version;

		completeList[realm] = {};
		completeList[realm][player] = {};
		result = completeList[realm][player];
	else
		-- set version to latest
		completeList.version = HF_Version;

		-- get realm list
		result = completeList[realm];
		-- new realm?
		if ( not result ) then
			completeList[realm] = {};
			result = completeList[realm];
		end
		-- get player list
		result = completeList[realm][player];

		-- check temporary state of list (friends list only)
		local remove_temp_list = false;
		if ( result and not share ) then
			remove_temp_list = HFF_CheckToRemoveTempList(completeList, result, player, FLinit);
			if ( remove_temp_list ) then result = nil; end
		end

		-- load faction wide friends list if existing
		if ( not result ) then
			local factionchar = HoloFriendsFuncs_IsCharAtFactionList(player);
			-- char exist in faction list -> try to load faction data
			if ( factionchar ) then result = completeList[realm][faction]; end
			-- if remove_temp_list is set, user accepted the load of the faction wide friends list
			if ( result and not remove_temp_list and not share ) then
				-- check if this faction data were used the last HF_MaxSecondsOfUnusedFactionsFriendsList
				local istemp = HFF_CheckTimeOfLastUse(completeList, result, player, FLinit);
				if ( istemp ) then result = completeList[realm][player]; end
			end
		end
		-- start with an empty friends list for this char
		if ( not result ) then
			completeList[realm][player] = {};
			result = completeList[realm][player];
		end
	end

	return result;
end


--[[
  check, if the charName is at your own char list
  @param list - Table
  @param charName - String
]]
function HoloFriendsFuncs_IsCharDataAvailable(list, charName)
	if ( not list or not charName ) then return; end

	local result;
	local realm = GetRealmName();
	result = list[realm];
	if ( result ) then
		result = list[realm][charName];
		if ( result ) then
			return true;
		end
	end
	return false;
end


--[[
  returns all own chars from the current realm (no reference to the original data)
]]
function HoloFriendsFuncs_RealmGetOwnChars(InsideFactions)
	local realm = GetRealmName();
	local result = {};

	if ( InsideFactions and HOLOFRIENDS_FACTIONS and HOLOFRIENDS_FACTIONS[realm] ) then
		-- get names from HOLOFRIENDS_FACTIONS (has all the single names)
		for key, list in pairs(HOLOFRIENDS_FACTIONS[realm]) do
			for idx = 1, table.getn(list) do
				local name = list[idx];
				if ( name ~= "Horde" and name ~= "Neutral" and name ~= "Alliance" ) then
					table.insert(result, name);
				end
			end
		end
	else
		-- get names from HOLOFRIENDS_LIST (includes alliance and horde as name)
		local list = HOLOFRIENDS_LIST[realm];
		for key, entry in pairs(list) do
			table.insert(result, key);
		end
	end

	-- sort the result
	table.sort(result, function (a,b) return a < b; end);

	return result;
end


--[[
  check if this own char is at the realms faction list of your actual char
  @param name - String
]]
function HoloFriendsFuncs_IsCharAtFactionList(name)
	if ( not name ) then return; end

	local clist = HoloFriendsFuncs_RealmGetAllFactionChars(true);
	for idx = 1, table.getn(clist) do
		if ( clist[idx] == name ) then return true; end
	end
	return false;
end


--[[
  returns all chars of the players faction from the current realm (no reference to the original data)
]]
function HoloFriendsFuncs_RealmGetAllFactionChars(WithUnknown)
	local realm = GetRealmName();
	local faction = UnitFactionGroup("player");
	local result = {};
	local list;

	if ( not HOLOFRIENDS_FACTIONS or not HOLOFRIENDS_FACTIONS[realm] or
	     not HOLOFRIENDS_FACTIONS[realm][faction] ) then return result; end

	-- get faction list of the realm
	list = HOLOFRIENDS_FACTIONS[realm][faction];
	for idx = 1, table.getn(list) do
		table.insert(result, list[idx]);
	end

	if ( WithUnknown ) then
		-- get unknown list of the realm
		list = HOLOFRIENDS_FACTIONS[realm]["unknown"];
		for idx = 1, table.getn(list) do
			table.insert(result, list[idx]);
		end
	end

	-- sort the result
	table.sort(result, function (a,b) return a < b; end);

	return result;
end


--[[
  remove the char from the faction and MyChars list
  @param name - str
]]
local function HFF_FactionListRemove(name)
	if ( not name ) then return; end

	local realm = GetRealmName();
	local nlist = nil;
	index = 0;

	nlist = HOLOFRIENDS_FACTIONS[realm]["unknown"];
	if ( nlist ) then
		index = 0;
		for idx = 1, table.getn(nlist) do
			if (nlist[idx] == name) then index = idx; end
		end
		if (index ~= 0) then table.remove(nlist, index); end
	end

	nlist = HOLOFRIENDS_FACTIONS[realm]["Horde"];
	if ( nlist ) then
		index = 0;
		for idx = 1, table.getn(nlist) do
			if (nlist[idx] == name) then index = idx; end
		end
		if (index ~= 0) then table.remove(nlist, index); end
	end

	nlist = HOLOFRIENDS_FACTIONS[realm]["Alliance"];
	if ( nlist ) then
		index = 0;
		for idx = 1, table.getn(nlist) do
			if (nlist[idx] == name) then index = idx; end
		end
		if (index ~= 0) then table.remove(nlist, index); end
	end

	nlist = HOLOFRIENDS_FACTIONS[realm]["Neutral"];
	if ( nlist ) then
		index = 0;
		for idx = 1, table.getn(nlist) do
			if (nlist[idx] == name) then index = idx; end
		end
		if (index ~= 0) then table.remove(nlist, index); end
	end

	-- remove from MYCHARS list
	HOLOFRIENDS_MYCHARS[realm][name] = nil;
end


--[[
  delete all saved HoloFriends data of your given char
  @param charstring - str
]]
function HoloFriendsFuncs_DeleteChar(charstring)
	if ( not charstring or (charstring == "") ) then return; end
	local realm;

	local char, atrealm = HoloFriendsFuncs_SeparateFirstString(charstring);
	if ( char == "" ) then return; end
	local at, realm = HoloFriendsFuncs_SeparateFirstString(atrealm);
	if ( (at ~= "at") or (realm == "") ) then realm = GetRealmName(); end

	local faction, faction_lc = UnitFactionGroup("player");
	local fList = HOLOFRIENDS_LIST;
	local iList = HOLOIGNORE_LIST;

	if ( char == faction_lc ) then char = faction; end

	local fexists = fList[realm][char];
	local iexists = iList[realm][char];
	if ( (fexists == nil) and (iexists == nil) ) then
		local name = char;
		if ( name == faction ) then name = faction_lc; end
		HoloFriendsFuncs_SystemMessage(format(HOLOFRIENDS_MSGDELETECHARNOTFOUND, name));
		return;
	end

	fList[realm][char] = nil;
	iList[realm][char] = nil;

	HFF_FactionListRemove(char);

	-- if realm has no chars left, delete realm
	local count = 0;
	for _,_ in pairs(fList[realm]) do count = count + 1; end;
	if ( count == 0 ) then
		for _,_ in pairs(iList[realm]) do count = count + 1; end;
	end
	if ( count == 0 ) then
		fList[realm] = nil;
		iList[realm] = nil;
		HOLOFRIENDS_FACTIONS[realm] = nil;
		HoloFriends_chat("Holo*_List_Update from HoloFriendsFuncs_DeleteChar of "..realm, HF_DEBUG_OUTPUT);
	end

	-- deleted yourself ...
	if ( UnitName("player") == char ) then
		HoloFriends_chat("Holo*_List_Update from HoloFriendsFuncs_DeleteChar of "..char, HF_DEBUG_OUTPUT);
		HoloFriends_LoadList();
		HoloFriends_List_Update();
		HoloIgnore_LoadList();
		HoloIgnore_List_Update();
		HoloFriends_CheckFactionList();
	end

	--Share visible?
	if ( HoloFriends_ShareFrame:IsVisible() ) then
		HoloFriendsShare_OnShow(HoloFriends_ShareFrame);
	end
	if ( HoloIgnore_ShareFrame:IsVisible() ) then
		HoloFriendsShare_OnShow(HoloIgnore_ShareFrame);
	end

	local name = char;
	if ( name == faction ) then name = faction_lc; end
	HoloFriendsFuncs_SystemMessage(format(HOLOFRIENDS_MSGDELETECHARDONE, name));
end


--[[
  Return the date in the requested dateFormat
  @param isoDate - a date in iso format: %Y-%m-%d %H:%M %w
  @param dateFormat -  format of the return value (i.e. %a %d.%m.%Y %H:%M)
--]]
function HoloFriendsFuncs_GetDateString(isoDate, dateFormat)
	local Y = string.sub(isoDate, 1, 4);
	local m = string.sub(isoDate, 6, 7);
	local d = string.sub(isoDate, 9, 10);
	local H = string.sub(isoDate, 12, 13);
	local M = string.sub(isoDate, 15, 16);
	local w = string.sub(isoDate, 18, 18);

	local I = H;
	local p = "am";
	if ( tonumber(I) > 12 ) then
		I = tostring(tonumber(I) - 12);
		p = "pm";
	end
	local A = "";
	if ( w ) then
		if ( w == "1" ) then A = WEEKDAY_MONDAY; end
		if ( w == "2" ) then A = WEEKDAY_TUESDAY; end
		if ( w == "3" ) then A = WEEKDAY_WEDNESDAY; end
		if ( w == "4" ) then A = WEEKDAY_THURSDAY; end
		if ( w == "5" ) then A = WEEKDAY_FRIDAY; end
		if ( w == "6" ) then A = WEEKDAY_SATURDAY; end
		if ( w == "0" ) then A = WEEKDAY_SUNDAY; end
	end

	local retStr = dateFormat;
	retStr = string.gsub(retStr, "%%Y", Y);
	retStr = string.gsub(retStr, "%%m", m);
	retStr = string.gsub(retStr, "%%d", d);
	retStr = string.gsub(retStr, "%%H", H);
	retStr = string.gsub(retStr, "%%M", M);
	retStr = string.gsub(retStr, "%%I", I);
	retStr = string.gsub(retStr, "%%p", p);
	retStr = string.gsub(retStr, "%%A", A);

	return retStr;
end


--[[
  Return true if date1 < date2
  @param date1 - a date in iso format: %Y-%m-%d %H:%M %w
  @param date2 - a date in iso format: %Y-%m-%d %H:%M %w
--]]
function HoloFriendsFuncs_Date1ltDate2(date1, date2)
	if ( date1 == UNKNOWN ) then
		return true;
	else
		local lastseen = HoloFriendsFuncs_GetDateString(date1, "%Y%m%d%H%M");
		local lastseen1 = tonumber(lastseen);
		if ( date2 ~= UNKNOWN ) then
			lastseen = HoloFriendsFuncs_GetDateString(date2, "%Y%m%d%H%M");
			local lastseen2 = tonumber(lastseen);
			if ( lastseen1 < lastseen2 ) then return true; end
		end
	end
	return false;
end


--[[
  returns a table that lists all visible entries from the given list
  @param list - list to check all entries for visibility
  @param Displayed_Names - number of shown entries
  @param HFlist - flag for the FriendsList (the FL uses HOLOFRIENDS_OPTIONS.ShowOffFriends)
--]]
function HoloFriendsFuncs_ShownListTab(list, Displayed_Names, HFlist)
	if ( not list ) then return {}; end

	local n_list = table.getn(list);
	local ShownIndexTable = {};
	local expanded = true;
	local visible = true;
	local index = 0;
	local compact = ( not HOLOFRIENDS_OPTIONS.ShowOffFriends and HFlist and not HOLOFRIENDS_OPTIONS.ShowGroups );

	if ( compact ) then
		local group_idx, connected;
		local maxi = table.getn(list);
		for index = 1, maxi do
			if ( (list[index].name == "1") or (list[index].name == "0") ) then
				if ( group_idx ) then
					if ( connected ) then
						list[group_idx].connected = true;
					else
						list[group_idx].connected = nil;
					end
				end
				group_idx = index;
				connected = false;
			else
				if ( list[index].connected ) then connected = true; end
			end
		end
		if ( group_idx ) then
			if ( connected ) then
				list[group_idx].connected = true;
			else
				list[group_idx].connected = nil;
			end
		end
	end

	for k, entry in pairs(list) do
		index = index + 1;

		if ( not expanded ) then visible = false; end

		-- entry = group?
		if ( entry.name == "1" ) then
			expanded = true;
			visible = true;
			if ( compact and not entry.connected ) then
				visible = false;
			end
			entry.connected = nil;
		elseif ( entry.name == "0" ) then
			expanded = false;
			visible = true;
			if ( compact and not entry.connected ) then
				visible = false;
			end
			entry.connected = nil;
		-- entry = player .. on- or offline?
		elseif ( not HOLOFRIENDS_OPTIONS.ShowOffFriends and HFlist ) then
			if ( expanded and entry.connected ) then
				visible = true;
			else
				visible = false;
			end
		end

		if ( visible ) then table.insert(ShownIndexTable, index); end
	end

	-- fillup table
	local visibleCnt = table.getn(ShownIndexTable);
	if ( visibleCnt < Displayed_Names ) then
		for ii = visibleCnt + 1, Displayed_Names do
			table.insert(ShownIndexTable, n_list + 1);
		end
	end

	return ShownIndexTable;
end


--[[
  return the number of visible entries in the list window
  @param idxTab - Table, ShownIndexTable
  @param nlist - number of list elements (HF_list or HI_list)
  @param maxNum - max. number of elements in the list window
--]]
function HoloFriendsFuncs_GetNumVisibleListElements(idxTab, nlist, maxNum)
	if ( not idxTab ) then return; end

	local nTab = table.getn(idxTab);
	local visibleCnt = 0;
	if ( nTab > maxNum ) then
		visibleCnt = nTab;
	else
		for idx = 1, nTab do
			if ( idxTab[idx] <= nlist ) then
				visibleCnt = visibleCnt + 1;
			end
		end
	end
	return visibleCnt;
end
