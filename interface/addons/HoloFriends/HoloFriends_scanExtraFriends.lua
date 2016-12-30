--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

local HF_debug = false;

HoloFriends_whoCheckInterval = 5.1;
HoloFriends_interceptWhoResults = 0;
HoloFriends_queryingThisGuy = nil;

local HF_scanningExtras = false;
local HF_lastScan = 0;
local HF_alreadyChecked = {};


local function HFF_ScanExtraFriends()
	local list = HoloFriends_GetList();
	local checkThisGuy;

	for k, entry in pairs(list) do
		local name = entry.name;
		if (name ~= "0" and name ~= "1" and not entry.notify) then
			if (not HF_alreadyChecked[name]) then
				HF_alreadyChecked[name] = true;
				checkThisGuy = name;
				break;
			end
		end
	end

	if (checkThisGuy) then
		HoloFriends_chat("Checking on extra friend: "..checkThisGuy, HF_DEBUG_OUTPUT);
		HoloFriendsFuncs_WhoCheckPlayer(checkThisGuy, HF_QUIET);
	else
		-- we've checked everybody, stop checking.
		HoloFriends_chat(HOLOFRIENDS_MSGSCANDONE);
		HF_scanningExtras = false;
		HF_alreadyChecked = {};
		HoloFriends_interceptWhoResults = 0;
		HoloFriends_queryingThisGuy = nil;
		HoloFriendsFrame_ScanExtrasButton:SetText(HOLOFRIENDS_WINDOWMAINBUTTONSCAN);
	end
end


function HoloFriendsScan_OnUpdate()
	if ( not HF_scanningExtras ) then return; end

	local now = GetTime();
	if ( now > (HF_lastScan + HoloFriends_whoCheckInterval) ) then
		HF_lastScan = now;
		HFF_ScanExtraFriends();
	end
end


function HoloFriendsScan_ClickScan()
	if ( not HF_scanningExtras ) then
		-- start scanning
		local list = HoloFriends_GetList();
		local extraCount = 0;
		for k, entry in pairs(list) do
			if ( not HoloFriendsLists_IsGroup(list, k) and (not entry.notify) ) then
				extraCount = extraCount + 1;
			end
		end
		local timeToFinish = HoloFriends_whoCheckInterval * extraCount;
		HoloFriends_chat(format(HOLOFRIENDS_MSGSCANSTART, extraCount, timeToFinish));
		HF_scanningExtras = true;
		HoloFriendsFrame_ScanExtrasButton:SetText(HOLOFRIENDS_WINDOWMAINBUTTONSTOP);
	else
		-- stop
		HoloFriends_chat(HOLOFRIENDS_MSGSCANSTOP);
		HF_scanningExtras = false;
		HoloFriendsFrame_ScanExtrasButton:SetText(HOLOFRIENDS_WINDOWMAINBUTTONSCAN);
	end
end


function HoloFriendsScan_CheckWhoListResult(list)
	local numWho = GetNumWhoResults();
	if ( numWho == 0 ) then
		local playerIndex = HoloFriendsLists_ContainsPlayer(list, HoloFriends_queryingThisGuy);
		local notify = HoloFriendsLists_GetNotify(list, playerIndex);
		if ( playerIndex and not notify ) then
			list[playerIndex].connected = nil;
			HoloFriends_List_Update();
		end
		if ( not HF_scanningExtras ) then
			HoloFriends_queryingThisGuy = nil;
		end
		return;
	else
		if ( not HF_scanningExtras ) then
			HoloFriends_queryingThisGuy = nil;
		end
	end

	local charname, guildname, level, race, lc_class, zone, class;

	for index = 1, numWho do
		charname, guildname, level, race, lc_class, zone, class = GetWhoInfo(index);
		local playerIndex = HoloFriendsLists_ContainsPlayer(list, charname);
		if ( playerIndex ) then
			if ( not HoloFriendsLists_GetNotify(list, playerIndex) ) then
				if ( level ~= 0 )          then list[playerIndex].level    = level; end
				if ( class ~= UNKNOWN )    then list[playerIndex].class    = class; end
				if ( lc_class ~= UNKNOWN ) then list[playerIndex].lc_class = lc_class; end
				if ( zone ~= UNKNOWN )     then list[playerIndex].area     = zone; end
				local connected = ( (level ~= 0) and (lc_class ~= UNKNOWN) and (zone ~= UNKNOWN) );
				if ( list[playerIndex].warn and connected and not list[playerIndex].connected ) then
					message(format(TEXT(ERR_FRIEND_ONLINE_SS),charname,charname));
				end
				list[playerIndex].connected = connected;
				list[playerIndex].lastSeen  = date("%Y-%m-%d %H:%M %w");
				if ( list[playerIndex].onstate ) then list[playerIndex].onstate = nil; end
			else
				if ( class ~= UNKNOWN )    then list[playerIndex].class    = class; end
			end
		end
	end
	HoloFriends_List_Update();
end


function HoloFriends_chat(msg, r, g, b)
	if ( not r ) then
		r = .8;
		g = .3;
		b = 1;
	end

	if ( not msg ) then
		msg = "";
	end

	if ( not b ) then
		if ( HF_debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("### HoloFriends: "..msg, .7, .2, .9);
		end
	
	else
		DEFAULT_CHAT_FRAME:AddMessage("## HoloFriends: "..msg, r, g, b);
	end
end
