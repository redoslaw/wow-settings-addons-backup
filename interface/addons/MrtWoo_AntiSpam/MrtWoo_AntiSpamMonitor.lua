--[[
	MrtWoo_AntiSpam: Detects and blocks russian commercial spam and flud
	Copyright (C) 2010 Pavel Dudkovsky (mrtime@era.by)

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

-- locals are always faster than globals

local _G = _G;

local type = type;
local pairs = pairs;

local tbl_rm = table.remove;
local tbl_ins = table.insert;
local tbl_sort = table.sort;
local tbl_foreach = table.foreach;
local tbl_getn = table.getn;

local string = string;
local strlen = string.len;
local strgsub = string.gsub;
local strfind = string.find;
local strlower = string.lower;
local strformat = string.format;
local strmatch = strmatch;

local tonumber = tonumber;
local tostring = tostring;

local ReportPlayer = ReportPlayer;
local ComplainChat = ComplainChat;
local CanComplainChat = CanComplainChat;
local GetRealmName = GetRealmName;
local UnitName = UnitName;
local GetLocale = GetLocale;

-- //

local MrtWoo = MrtWoo;

local L = LibStub("AceLocale-3.0"):GetLocale("MrtWoo_AntiSpam", true);

local EXT_LFW_SEP_R = "_%$"
local EXT_LFW_PATTERN_R = "^"..EXT_LFW_SEP_R.."(%d+)([^%d]+)"..EXT_LFW_SEP_R.."(.+)"..EXT_LFW_SEP_R.."(%x%x%x%x%x%x)%$$"

MrtWoo_AntiSpamMonitor = {};
-- MrtWoo_AntiSpamMonitor.UInfo = {};

MrtWoo_AntiSpamMonitor.MSG_RESULT_OK = 0;
MrtWoo_AntiSpamMonitor.MSG_RESULT_SPAM = 1;
MrtWoo_AntiSpamMonitor.MSG_RESULT_FLOOD = 2;
MrtWoo_AntiSpamMonitor.MSG_RESULT_WAIT = 3;
MrtWoo_AntiSpamMonitor.MSG_RESULT_BLOCKED = 4;
MrtWoo_AntiSpamMonitor.MSG_RESULT_LVLFILTER = 5;

MrtWoo_AntiSpamMonitor.MSG_STATUS_WAIT_PROCESSING = 0;
MrtWoo_AntiSpamMonitor.MSG_STATUS_DONE = 100;

MrtWoo_AntiSpamMonitor.SMI_COUNT_OK = 0;
MrtWoo_AntiSpamMonitor.SMI_COUNT_FLOOD = 0;
MrtWoo_AntiSpamMonitor.SMI_COUNT_SPAM = 0;
MrtWoo_AntiSpamMonitor.SMI_COUNT_BLOCKED = 0;
MrtWoo_AntiSpamMonitor.SMI_COUNT_LVLFILTER = 0;
MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_ADD = 0;
MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_WAIT = 0;
MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_LAST = 0;
MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_MAX = 0;

MrtWoo_AntiSpamMonitor.WhiteList = {};
MrtWoo_AntiSpamMonitor.WhiteList[0] = {}; -- friends
MrtWoo_AntiSpamMonitor.WhiteList[1] = {}; -- guild
MrtWoo_AntiSpamMonitor.WhiteList[2] = {}; -- party
MrtWoo_AntiSpamMonitor.WhiteList[3] = {}; -- raid
MrtWoo_AntiSpamMonitor.WhiteList[4] = {}; -- self

MrtWoo_AntiSpamMonitor.oldGuildTotalMembers = 0;
MrtWoo_AntiSpamMonitor.oldNumFriends = 0;
MrtWoo_AntiSpamMonitor.oldNumRaidMembers = 0;

MrtWoo_AntiSpamMonitor.ReportTbl = {}
MrtWoo_AntiSpamMonitor.oldOnHyperlinkShow = false;

--MrtWoo_AntiSpamMonitor.Players = setmetatable({},{__mode="k"});

function MrtWoo_AntiSpamMonitor:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;

	LibStub:GetLibrary('AceEvent-3.0'):Embed(self);
	LibStub:GetLibrary("LibChatHandler-1.0"):Embed(self);

	o.lastProcessReportQueue = 0;
	o.ReportQueue = setmetatable({},{__mode="k"});
	o.Players = setmetatable({},{__mode="k"});
	o.MessagesQueue = setmetatable({},{__mode="k"});
	o.MessagesFilter = MrtWoo_AntiSpamFilter:new();
	o.BlockList = MrtWoo_AntiSpamBlockList:new();

	o.Who = LibStub:GetLibrary("LibWho-2.0");
	o.Who:RegisterCallback('WHOLIB_QUERY_RESULT', MrtWoo_AntiSpamMonitor.WhoLibCallback);

	self.Who = o.Who;
	self.Players = o.Players;
	self.MessagesFilter = o.MessagesFilter;
	self.BlockList = o.BlockList;
	self.MessagesQueue = o.MessagesQueue;
	self.ReportQueue = o.ReportQueue;
	self.lastProcessReportQueue = o.lastProcessReportQueue;

	-- CHAT_MSG_SAY
	-- CHAT_MSG_YELL
	-- CHAT_MSG_EMOTE
	-- CHAT_MSG_TEXT_EMOTE
	-- CHAT_MSG_CHANNEL
	-- CHAT_MSG_WHISPER
	-- CHAT_MSG_DND
	-- CHAT_MSG_AFK

	self:RegisterChatEvent("CHAT_MSG_CHANNEL");
	self:RegisterChatEvent("CHAT_MSG_SAY");
	self:RegisterChatEvent("CHAT_MSG_YELL");
	self:RegisterChatEvent("CHAT_MSG_TEXT_EMOTE");
	self:RegisterChatEvent("CHAT_MSG_WHISPER");
	self:RegisterChatEvent("CHAT_MSG_WHISPER_INFORM");

	self:RegisterChatEvent("CHAT_MSG_BATTLEGROUND");
	self:RegisterChatEvent("CHAT_MSG_BATTLEGROUND_LEADER");

	self:RegisterChatEvent("CHAT_MSG_RAID");
	self:RegisterChatEvent("CHAT_MSG_RAID_LEADER");
	self:RegisterChatEvent("CHAT_MSG_RAID_WARNING");

	self:RegisterChatEvent("CHAT_MSG_PARTY");
	self:RegisterChatEvent("CHAT_MSG_PARTY_LEADER");

	self.CHAT_MSG_CHANNEL_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;
	self.CHAT_MSG_SAY_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;
	self.CHAT_MSG_YELL_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;
	self.CHAT_MSG_TEXT_EMOTE_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;
	self.CHAT_MSG_WHISPER_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;
	self.CHAT_MSG_WHISPER_INFORM_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;

	self.CHAT_MSG_BATTLEGROUND_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;
	self.CHAT_MSG_BATTLEGROUND_LEADER_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;

	self.CHAT_MSG_RAID_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;
	self.CHAT_MSG_RAID_LEADER_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;
	self.CHAT_MSG_RAID_WARNING_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;

	self.CHAT_MSG_PARTY_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;
	self.CHAT_MSG_PARTY_LEADER_CONTROLLER = self.CHAT_MSG_GLOBAL_CONTROLLER;

	self:RegisterEvent("FRIENDLIST_SHOW", MrtWoo_AntiSpamMonitor.OnFriendListUpdate);
	self:RegisterEvent("FRIENDLIST_UPDATE", MrtWoo_AntiSpamMonitor.OnFriendListUpdate);
	self:RegisterEvent("GUILD_ROSTER_UPDATE", MrtWoo_AntiSpamMonitor.OnGuildRosterUpdate);
	self:RegisterEvent("GROUP_ROSTER_UPDATE",  MrtWoo_AntiSpamMonitor.OnGroupRosterUpdate);
	self:RegisterEvent("PLAYER_ENTERING_WORLD", MrtWoo_AntiSpamMonitor.OnPlayerEnteringWorld);

	MrtWoo:RegisterChatCommand("mrtwoo_whitelist", MrtWoo_AntiSpamMonitor.ShowWhiteList);
	MrtWoo:RegisterChatCommand("mrtwoo_show_spammers", MrtWoo_AntiSpamMonitor.ShowSpamers);

	MrtWoo_AntiSpamMonitor.oldOnHyperlinkShow = ChatFrame_OnHyperlinkShow;
	ChatFrame_OnHyperlinkShow = function(self, data, ...)
		local type, action, msgId, msgAuthor = strsplit(":", data)
		if type and action and type == "MrtWoo" then
			msgId = tonumber(msgId);
			msgAuthor = strlower(msgAuthor);

			local player = MrtWoo_AntiSpamMonitor.Players[msgAuthor];
			if player then
				local messages = player:GetMessages();
				local message = messages:GetMsg(msgId);
				if message then
					if (action == "report") then
						if CanComplainChat(msgId) and not MrtWoo_AntiSpamMonitor.ReportTbl[msgId] then
							MrtWoo_AntiSpamMonitor.ReportTbl[msgId] = true
							if ReportPlayer then
								if (MrtWoo.db.profile.modules.as_block_24h) then
									MrtWoo_AntiSpamMonitor.BlockList:Block(player:GetFullName(), 86400, message:GetValue());
								end;
								ReportPlayer(PLAYER_REPORT_TYPE_SPAM, msgId);
							else
								ComplainChat(msgId)
							end
						end
					else
						if msgAuthor and action == "show" then
							MrtWoo:Print(strformat(L["|Hplayer:%s|h[%s]|h: %s |cffC0FFFF|HMrtWoo:report:%d:%s|h[send report]|h|r"], player:GetName(), player:GetName(), message:GetValue(), msgId, player:GetFullName()));
						end;
					end;
				end;
			end;
			return
		end
		MrtWoo_AntiSpamMonitor.oldOnHyperlinkShow(self, data, ...)
	end;

	return o;
end

function MrtWoo_AntiSpamMonitor:OnPlayerEnteringWorld()
	MrtWoo_AntiSpamMonitor:OnFriendListUpdate();
	MrtWoo_AntiSpamMonitor:OnGuildRosterUpdate();
	MrtWoo_AntiSpamMonitor:OnPartyMembersChanged();
	MrtWoo_AntiSpamMonitor:OnRaidRosterUpdate();
end;

function MrtWoo_AntiSpamMonitor:OnFriendListUpdate()
	if (not MrtWoo.db.profile.modules.lf_enable) or (not MrtWoo.db.profile.modules.lf_whitelist_friends) then
		if MrtWoo.db.profile.modules.as_debug then
			MrtWoo:Print("call OnFriendListUpdate() => UP");
		end;
		MrtWoo_AntiSpamMonitor.WhiteList[0] = {};
		MrtWoo_AntiSpamMonitor.oldNumFriends = 0;
		return;
	end;

	local numFriends = GetNumFriends();
	if (MrtWoo_AntiSpamMonitor.oldNumFriends ~= numFriends) then
		if MrtWoo.db.profile.modules.as_debug then
			MrtWoo:Print("call OnFriendListUpdate() => UP");
		end;

		MrtWoo_AntiSpamMonitor.WhiteList[0] = {};

		if (numFriends > 0) and (numFriends < 51) then
			for i = 1, numFriends do
				local name, level, class, area, connected, note, status = GetFriendInfo(i);
				if (name ~= nil) then
					name = strlower(name .. "-" .. MrtWoo.MyRealm);
					MrtWoo_AntiSpamMonitor.WhiteList[0][name] = true;
				end;
			end;
		end;

		MrtWoo_AntiSpamMonitor.oldNumFriends = numFriends;

	end;
end;

function MrtWoo_AntiSpamMonitor:OnGuildRosterUpdate()
	if (not MrtWoo.db.profile.modules.lf_enable) or (not MrtWoo.db.profile.modules.lf_whitelist_guild) then
		if MrtWoo.db.profile.modules.as_debug then
			MrtWoo:Print("call OnGuildRosterUpdate() => UP");
		end;
		MrtWoo_AntiSpamMonitor.WhiteList[1] = {};
		MrtWoo_AntiSpamMonitor.oldGuildTotalMembers = 0;
		return;
	end;

	local totalMembers, onlineMembers = GetNumGuildMembers();

	if (MrtWoo_AntiSpamMonitor.oldGuildTotalMembers ~= totalMembers) then
		if MrtWoo.db.profile.modules.as_debug then
			MrtWoo:Print("call OnGuildRosterUpdate() => UP");
		end;

		MrtWoo_AntiSpamMonitor.WhiteList[1] = {};

		if (totalMembers > 0) then
			for i = 1, totalMembers do
				local name, rank, rankIndex, level, class, zone, note, officernote, online,
					status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(i);
				if (name ~= nil) then
					name = strlower(name .. "-" .. MrtWoo.MyRealm);
					MrtWoo_AntiSpamMonitor.WhiteList[1][name] = true;
				end;
			end;
		end;

		MrtWoo_AntiSpamMonitor.oldGuildTotalMembers = totalMembers;
	end;
end;

function MrtWoo_AntiSpamMonitor:OnGroupRosterUpdate()
	MrtWoo_AntiSpamMonitor:OnPartyMembersChanged();
	MrtWoo_AntiSpamMonitor:OnRaidRosterUpdate();
end;

function MrtWoo_AntiSpamMonitor:OnPartyMembersChanged()
	if (not MrtWoo.db.profile.modules.lf_enable) or (not MrtWoo.db.profile.modules.lf_whitelist_party) then
		if MrtWoo.db.profile.modules.as_debug then
			MrtWoo:Print("call OnPartyMembersChanged() => UP");
		end;
		MrtWoo_AntiSpamMonitor.WhiteList[2] = {};
		return;
	end;

	MrtWoo_AntiSpamMonitor.WhiteList[2] = {};

	local numPartyMembers = GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME);

	if (numPartyMembers == 0) then
		numPartyMembers = GetNumSubgroupMembers(LE_PARTY_CATEGORY_INSTANCE);
	end;

	if (numPartyMembers == 0) then
		return;
	end;

	if MrtWoo.db.profile.modules.as_debug then
		MrtWoo:Print("call OnPartyMembersChanged() => UP");
	end;

	for id = 1,MAX_PARTY_MEMBERS do
		local name, server = UnitName("party"..id);

		if ( server == nil or server == "" ) then
			server = MrtWoo.MyRealm;
		end;

		if (name ~= nil) then
			name = strlower(name .. "-" .. server);
			MrtWoo_AntiSpamMonitor.WhiteList[2][name] = true;
		end;
	end;
end;

function MrtWoo_AntiSpamMonitor:OnRaidRosterUpdate()
	if (not MrtWoo.db.profile.modules.lf_enable) or (not MrtWoo.db.profile.modules.lf_whitelist_raid) then
		if MrtWoo.db.profile.modules.as_debug then
			MrtWoo:Print("call OnRaidRosterUpdate() => UP");
		end;
		MrtWoo_AntiSpamMonitor.WhiteList[3] = {};
		MrtWoo_AntiSpamMonitor.oldNumRaidMembers = 0;
		return;
	end;

	local numRaidMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME);

	if (numRaidMembers == 0) then
		numRaidMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE);
	end;

	if (MrtWoo_AntiSpamMonitor.oldNumRaidMembers == numRaidMembers) then
		return;
	end;

	MrtWoo_AntiSpamMonitor.oldNumRaidMembers = numRaidMembers;

	if MrtWoo.db.profile.modules.as_debug then
		MrtWoo:Print("call OnRaidRosterUpdate() => UP");
	end;

	MrtWoo_AntiSpamMonitor.WhiteList[3] = {};

	if (numRaidMembers > 0) then
		for i=1, numRaidMembers do
			local name, rank, subgroup = GetRaidRosterInfo(i);
			if (name ~= nil) then
				local _name, server = strmatch(name, "^([^-]+)-(.*)");

				if (_name ~= nil and _name ~= "") then
					name = _name;
				end;

				if ( server == nil or server == "" ) then
					server = MrtWoo.MyRealm;
				end;

				name = strlower(name .. "-" .. server);
				MrtWoo_AntiSpamMonitor.WhiteList[3][name] = true;
			end;
		end;
	end;

end;

function MrtWoo_AntiSpamMonitor:ShowWhiteList(input)

	MrtWoo:Print("=== Friends ===");
	for name, _ in pairs(MrtWoo_AntiSpamMonitor.WhiteList[0]) do
		MrtWoo:Print(name);
	end;

	MrtWoo:Print("=== Guild ===");
	for name, _ in pairs(MrtWoo_AntiSpamMonitor.WhiteList[1]) do
		MrtWoo:Print(name);
	end;

	MrtWoo:Print("=== Party ===");
	for name, _ in pairs(MrtWoo_AntiSpamMonitor.WhiteList[2]) do
		MrtWoo:Print(name);
	end;

	MrtWoo:Print("=== Raid ===");
	for name, _ in pairs(MrtWoo_AntiSpamMonitor.WhiteList[3]) do
		MrtWoo:Print(name);
	end;

	MrtWoo:Print("=== Self ===");
	for name, _ in pairs(MrtWoo_AntiSpamMonitor.WhiteList[4]) do
		MrtWoo:Print(name);
	end;
end;

function MrtWoo_AntiSpamMonitor:IsWhiteListed(name)
	if (name == nil) then
		return false;
	end;

	name = strlower(name);
	return
		MrtWoo_AntiSpamMonitor.WhiteList[0][name] or
		MrtWoo_AntiSpamMonitor.WhiteList[1][name] or
		MrtWoo_AntiSpamMonitor.WhiteList[2][name] or
		MrtWoo_AntiSpamMonitor.WhiteList[3][name] or
		MrtWoo_AntiSpamMonitor.WhiteList[4][name] or
		false;
end;

function MrtWoo_AntiSpamMonitor:ShowSMI()
	MrtWoo:Print(
		  'QA:', MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_ADD,
		', QW:', MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_WAIT,
		', QL:', MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_LAST,
		', QM:', MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_MAX,
		', SO:', MrtWoo_AntiSpamMonitor.SMI_COUNT_OK,
		', SF:', MrtWoo_AntiSpamMonitor.SMI_COUNT_FLOOD,
		', SS:', MrtWoo_AntiSpamMonitor.SMI_COUNT_SPAM,
		', SB:', MrtWoo_AntiSpamMonitor.SMI_COUNT_BLOCKED,
		', LF:', MrtWoo_AntiSpamMonitor.SMI_COUNT_LVLFILTER
	);
end;

MrtWoo_AntiSpamMonitor.OldSMI = {0,0,0,0,0,0,0,0,0};

function MrtWoo_AntiSpamMonitor:SendSMI()
	local o = MrtWoo_AntiSpamMonitor.OldSMI;
	local v = {
		MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_ADD,
		MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_WAIT,
		MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_LAST,
		MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_MAX,
		MrtWoo_AntiSpamMonitor.SMI_COUNT_OK,
		MrtWoo_AntiSpamMonitor.SMI_COUNT_FLOOD,
		MrtWoo_AntiSpamMonitor.SMI_COUNT_SPAM,
		MrtWoo_AntiSpamMonitor.SMI_COUNT_BLOCKED,
		MrtWoo_AntiSpamMonitor.SMI_COUNT_LVLFILTER
	};

	if 	o[1] ~= v[1] or o[2] ~= v[2] or o[3] ~= v[3] or
		o[4] ~= v[4] or o[5] ~= v[5] or o[6] ~= v[6] or
		o[7] ~= v[7] or o[8] ~= v[8] or	o[9] ~= v[9] then
			self:SendMessage('MRTWOO_ASMON_SMI', v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9]);
			MrtWoo_AntiSpamMonitor.OldSMI = v;
	end;
end;

function MrtWoo_AntiSpamMonitor:AddMessageToQueue(eventController, msgId, ...)
	if self:GetMessage(msgId) or not eventController then
		return false;
	end;

	eventController:Suspend(MrtWoo_AntiSpamMonitor);

	local v = {};
	v.time = GetTime();
	v.allowWhoIs = true;

	MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_ADD = MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_ADD + 1;

	local playerName, playerRealm;

	local evtType = select(1, ...);
	local GUID = select(13, ...);
	if (evtType == "CHAT_MSG_WHISPER_INFORM") and (GUID == "") then
		playerName = select(3, ...);
	else
		_, _, _, _, _, playerName, playerRealm = _G.GetPlayerInfoByGUID(GUID);
	end
	
	local fullName = "";
	if (playerRealm ~= nil) and (playerRealm ~= "") then
		v.allowWhoIs = false;
		fullName = playerName .. "-" .. playerRealm;
	else
		fullName = playerName .. "-" .. MrtWoo.MyRealm;
	end;

	-- MrtWoo:Print(fullName);

	v.data = {...};
	v.name = fullName;
	v.status = MrtWoo_AntiSpamMonitor.MSG_STATUS_WAIT_PROCESSING;
	v.eventController = eventController;
	-- eventController.arg[1] = strgsub(eventController.arg[1], '%s+', '_');

	self.MessagesQueue[msgId] = v ;
	self:ProcessQueue();

	return true;
end;

function MrtWoo_AntiSpamMonitor:GetMessage(msgId)
	return self.MessagesQueue[msgId];
end;

MrtWoo_AntiSpamMonitor.ProcessQueueLock = false;

function MrtWoo_AntiSpamMonitor:ProcessQueue()
	--[[
	if MrtWoo.db.profile.modules.as_debug then
		MrtWoo:Print('=== MrtWoo_AntiSpamMonitor:ProcessQueue(): I ===');
	end;
	]]

	if (MrtWoo_AntiSpamMonitor.ProcessQueueLock ~= false) then
		-- MrtWoo:Print('=== MrtWoo_AntiSpamMonitor.ProcessQueueLock ===');
		return false;
	end;

	MrtWoo_AntiSpamMonitor.ProcessQueueLock = true;

	if (self.MessagesQueue == nil) then
		return false;
	end;

	local c_time = GetTime();

	MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_WAIT = 0;
	MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_LAST = 0;

	for k, v in pairs(self.MessagesQueue) do
		if v.status ~= MrtWoo_AntiSpamMonitor.MSG_STATUS_DONE then

			local type = v.data[1];
			local message = v.data[2];
			local author = v.data[3];

			local msgId = k; --v.data[12];
			local msgChannelName = v.data[10];

			if (msgChannelName and (strfind(msgChannelName, "LFGForwarder") or strfind(msgChannelName, "TCForwarder"))) then
				local _, _, _, name, msg, _ = strfind(message, EXT_LFW_PATTERN_R);

				type = "CHAT_MSG_LFGFORWARDER";

				v.name =  name .. "-" .. MrtWoo.MyRealm;

				author = name;
				message = msg;
			end;

			local msgStatus = MrtWoo_AntiSpamMonitor.MSG_RESULT_OK;

			--MrtWoo:Print(msgId, message, author, type);

			if (message ~= nil) and (author ~= nil) and (MrtWoo.MyName ~= author) then
				msgStatus = self:CheckMessage(msgId, message, author, type, v);
			end;

			if msgStatus == MrtWoo_AntiSpamMonitor.MSG_RESULT_OK then
				if (v.eventController) then
					v.eventController:Release(MrtWoo_AntiSpamMonitor);
				end;
				MrtWoo_AntiSpamMonitor.SMI_COUNT_OK = MrtWoo_AntiSpamMonitor.SMI_COUNT_OK + 1;
			end;

			if msgStatus ~= MrtWoo_AntiSpamMonitor.MSG_RESULT_WAIT then

				if msgStatus == MrtWoo_AntiSpamMonitor.MSG_RESULT_SPAM then
					MrtWoo_AntiSpamMonitor.SMI_COUNT_SPAM = MrtWoo_AntiSpamMonitor.SMI_COUNT_SPAM + 1;
				elseif msgStatus == MrtWoo_AntiSpamMonitor.MSG_RESULT_FLOOD then
					MrtWoo_AntiSpamMonitor.SMI_COUNT_FLOOD = MrtWoo_AntiSpamMonitor.SMI_COUNT_FLOOD + 1;
				elseif msgStatus == MrtWoo_AntiSpamMonitor.MSG_RESULT_BLOCKED then
					MrtWoo_AntiSpamMonitor.SMI_COUNT_BLOCKED = MrtWoo_AntiSpamMonitor.SMI_COUNT_BLOCKED + 1;
				elseif msgStatus == MrtWoo_AntiSpamMonitor.MSG_RESULT_LVLFILTER then
					MrtWoo_AntiSpamMonitor.SMI_COUNT_LVLFILTER = MrtWoo_AntiSpamMonitor.SMI_COUNT_LVLFILTER + 1;
				end;

				v.time = GetTime();
				v.status = MrtWoo_AntiSpamMonitor.MSG_STATUS_DONE;
				v.data = nil;

				if (v.eventController and msgStatus ~= MrtWoo_AntiSpamMonitor.MSG_RESULT_OK) then
					v.eventController:Block();
					v.eventController:BlockFromChatFrame();
					v.eventController:Release(MrtWoo_AntiSpamMonitor);
					v.eventController = nil;
				end;

				self.MessagesQueue[k] = v;
			else
				MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_WAIT = MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_WAIT + 1;
			end;
		else
			if c_time - v.time > MrtWoo.db.profile.modules.as_gc_message_lifetime then
				--[[
				if MrtWoo.db.profile.modules.as_debug then
					MrtWoo:Print('S REMOVE', k, c_time - v.time);
				end;
				]]
				self.MessagesQueue[k] = nil;
			end;

		end;

		MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_LAST = MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_LAST + 1;
	end

	if MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_MAX < MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_LAST then
		MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_MAX = MrtWoo_AntiSpamMonitor.SMI_COUNT_QUEUE_LAST;
	end;

	self:SendSMI();

	--[[
	if MrtWoo.db.profile.modules.as_debug then
		MrtWoo:Print('=== MrtWoo_AntiSpamMonitor:ProcessQueue(): O ===');
	end;
	]]

	MrtWoo_AntiSpamMonitor.ProcessQueueLock = false;

	return true;
end;

function MrtWoo_AntiSpamMonitor:WhoLibCallback(query, results, complete)
	if not complete then
		if MrtWoo.db.profile.modules.as_debug then
			MrtWoo:Print('There were more Players...');
		end;
	else
		for _,result in pairs(results) do
			local name = result.Name .. "-" .. MrtWoo.MyRealm;

			if MrtWoo.db.profile.modules.as_debug then
				MrtWoo:Print('Player: ' .. name .. ' , level: ' .. result.Level);
			end;

			local lwrName = strlower(name);

			local player = MrtWoo_AntiSpamMonitor.Players[lwrName];

			if not player then
				player = MrtWoo_AntiSpamPlayer:new();
				player:SetName(name);
				MrtWoo_AntiSpamMonitor.Players[lwrName] = player;
			end;

			player:SetInfo(result);
			player:UnLock();

		end;

		MrtWoo_AntiSpamMonitor:ProcessQueue();
	end;


end;

function MrtWoo_AntiSpamMonitor:GetUserInfo(player)

	local usrInfo = player:GetInfo();

	if usrInfo == nil then

		player:SetInfo(false);

		local options = {
			queue = self.Who.WHOLIB_QUERY_QUIET,
		};

		local query = '';
		if GetLocale() == "ruRU" then
			query = strformat('и-"%s"', player:GetShortName());
		else
			query = strformat('n-"%s"', player:GetShortName());
		end;

		self.Who:Who(query, options);

	elseif type(usrInfo) == 'table' then

		return usrInfo;

	end;

	return false;
end;

function MrtWoo_AntiSpamMonitor:RateUserInfo(player)
	local userInfo = MrtWoo_AntiSpamMonitor:GetUserInfo(player);

	if not userInfo then
		return nil;
	end;

	if userInfo.Level <= MrtWoo.db.profile.modules.as_spam_maxlvl then
		return MrtWoo.db.profile.modules.as_spam_ratelvl;
	end;

	return 0;
end;

function MrtWoo_AntiSpamMonitor:LfCheck(player)

	if MrtWoo_AntiSpamMonitor:IsWhiteListed(player:GetFullName()) then
		return true;
	end;

	if (MrtWoo.db.profile.modules.lf_max < MrtWoo.db.profile.modules.lf_min) then
		return false;
	end;

	local userInfo = MrtWoo_AntiSpamMonitor:GetUserInfo(player);

	if not userInfo then
		return nil;
	end;

	if (userInfo.Level >= MrtWoo.db.profile.modules.lf_min) and
		(userInfo.Level <= MrtWoo.db.profile.modules.lf_max) then
		return true;
	end;

	return false;
end;

function MrtWoo_AntiSpamMonitor:AddToReportQueue(msgId, msgAuthor)
	local _author = strlower(msgAuthor);
	self.ReportQueue[_author] = msgId;
end;

function MrtWoo_AntiSpamMonitor:ProcessReportQueue()
	local tNow = GetTime();

	if tNow - self.lastProcessReportQueue < 60 then
		return false;
	end;

	self.lastProcessReportQueue = tNow;

	for msgAuthor, msgId in pairs(self.ReportQueue) do
		local player = self.Players[msgAuthor];
		if player then
			local messages = player:GetMessages();
			local msg = messages:GetMsg(msgId);
			if (msg) then
				if MrtWoo.db.profile.modules.as_debug then
					MrtWoo:Print(strformat("SEND_REPORT: msgAuthor: %s", msgAuthor));
				end;
				msg:Report();
			end;
		end;
		self.ReportQueue[msgAuthor] = nil;
		return true;
	end;

	return true;
end;

function MrtWoo_AntiSpamMonitor:CheckMessage(msgId, msgVal, msgAuthor, type, data)
	self:SmartClean();

	local allowWhoIs = data.allowWhoIs;
	local eventController = data.eventController;
	local fullName = data.name;

	--MrtWoo:Print(msgAuthor);

	local _msgVal = msgVal;
	if (MrtWoo.db.profile.modules.as_f_smart_replace) then
		_msgVal = strgsub(_msgVal, "|c%w%w%w%w%w%w%w%w(.-)|r", " %1 ");
		_msgVal = strgsub(_msgVal, "|H.-|h(.-)|h", " %1 ");
		_msgVal = strgsub(_msgVal, "%d+", " %1 ");
		_msgVal = strgsub(_msgVal, '[%s%p%c]+', ' ');
		_msgVal = strlower(_msgVal);
		_msgVal = strtrim(_msgVal);

		if (strlen(_msgVal) == 0) then
			_msgVal = "--SMART-REPLACE-EMPRTY-MESSAGE--";
		end;

	end;

	local result = self.MSG_RESULT_OK;

	if (type == "CHAT_MSG_WHISPER_INFORM") then
		if (MrtWoo.db.profile.modules.lf_whitelist_autoreplay == msgVal) then
			result = self.MSG_RESULT_LVLFILTER;
		else
			if (fullName ~= nil) then
				local name = strlower(fullName);
				MrtWoo_AntiSpamMonitor.WhiteList[4][name] = true;
			end;
		end;
	elseif self.BlockList:IsBlocked(fullName) then
		if MrtWoo.db.profile.modules.as_debug then
			-- eventController.arg[1] = strformat("\124cFFFF0000%s\124r", _msgVal);
			MrtWoo:Print('msgAuthor:', fullName, '- IN BLOCKLIST...');
		end;
		result = self.MSG_RESULT_BLOCKED;
	else
		local _time = GetTime();

		local lwrName = strlower(fullName);
		local player = self.Players[lwrName];

		if not player then
			player = MrtWoo_AntiSpamPlayer:new();
			player:SetName(fullName);

			self.Players[lwrName] = player;
		end;

		local messages = player:GetMessages();

		local msgRate = 0;

		if not player:IsSpammer() and not player:IsLock() then

			-- MrtWoo:Print(fullName, messages);

			local _msg = messages:GetMsg(msgId);
			if not _msg then
				if MrtWoo.db.profile.modules.as_antiflud then

					local allowCheck = false;
					if type == "CHAT_MSG_SAY" and MrtWoo.db.profile.modules.as_f_check_say then
						allowCheck = true;
					elseif type == "CHAT_MSG_YELL" and MrtWoo.db.profile.modules.as_f_check_yell then
						allowCheck = true;
					elseif type == "CHAT_MSG_WHISPER" and MrtWoo.db.profile.modules.as_f_check_whisper then
						allowCheck = true;
					elseif (type == "CHAT_MSG_CHANNEL" or type == "CHAT_MSG_LFGFORWARDER") and MrtWoo.db.profile.modules.as_f_check_channel then
						allowCheck = true;
					elseif type == "CHAT_MSG_TEXT_EMOTE" and MrtWoo.db.profile.modules.as_f_check_emote then
						allowCheck = true;
					end;

					if allowCheck and (strlen(_msgVal) >= 10) then
						local _dup = messages:GetDup(_msgVal);

						if _dup then
							if ((_dup.t) == 0 or ((_time - _dup.t) <= MrtWoo.db.profile.modules.as_antiflud_time)) then
								if MrtWoo.db.profile.modules.as_f_debug then
									eventController.arg[1] = strformat("\124cFF808080%s\124r", _msgVal);
									-- MrtWoo:Print(strformat("%s, %g - BLOCK (FLOOD)", msgAuthor, (_time - _dup.t)));
								else
									result = self.MSG_RESULT_FLOOD;
								end;
							else
								if MrtWoo.db.profile.modules.as_debug then
									MrtWoo:Print(strformat("%s, %g - ALLOW", fullName, (_time - _dup.t)));
								end;
							end;
						end;
					else
						if MrtWoo.db.profile.modules.as_debug then
							MrtWoo:Print(strformat("%s - F_SKIP", fullName));
						end;
					end;
				end;

				_msg = messages:Add(msgId, _msgVal);

				if (result == self.MSG_RESULT_OK) then

					local allowCheck = false;
					if type == "CHAT_MSG_SAY" and MrtWoo.db.profile.modules.as_s_check_say then
						allowCheck = true;
					elseif type == "CHAT_MSG_YELL" and MrtWoo.db.profile.modules.as_s_check_yell then
						allowCheck = true;
					elseif type == "CHAT_MSG_WHISPER" and MrtWoo.db.profile.modules.as_s_check_whisper then
						allowCheck = true;
					elseif type == "CHAT_MSG_CHANNEL" and MrtWoo.db.profile.modules.as_s_check_channel then
						allowCheck = true;
					elseif type == "CHAT_MSG_TEXT_EMOTE" and MrtWoo.db.profile.modules.as_s_check_emote then
						allowCheck = true;
					end;

					if allowCheck then
						msgRate = self.MessagesFilter:RateTradeMessage(msgVal);
						_msg:SetRate(msgRate);
					else
						if MrtWoo.db.profile.modules.as_debug then
							MrtWoo:Print(strformat("%s - S_SKIP", fullName));
						end;
					end;
				end;

			else
				msgRate = _msg:GetRate();
			end;

			_msg:SetTime(_time);

			if (result == self.MSG_RESULT_OK) then

				if allowWhoIs and MrtWoo.db.profile.modules.as_spam_additional_checks and not player:IsLock() then
					-- if true then
					if  (msgRate >= MrtWoo.db.profile.modules.as_spamrate_needed_for_additional_checks) and
						(msgRate < MrtWoo.db.profile.modules.as_spamrate) then

						local userRate = MrtWoo_AntiSpamMonitor:RateUserInfo(player);
						if userRate == nil then
							if MrtWoo.db.profile.modules.as_debug then
								MrtWoo:Print(strformat("REQ_INFO: msgAuthor: %s", msgAuthor));
							end;
							player:Lock();
						else
							msgRate = msgRate + userRate;
						end;
					end;
				end;


				if MrtWoo.db.profile.modules.lf_enable and not player:IsLock()  then

					local allowCheck = false;

					if type == "CHAT_MSG_SAY" and MrtWoo.db.profile.modules.lf_check_say then
						allowCheck = true;
					elseif type == "CHAT_MSG_YELL" and MrtWoo.db.profile.modules.lf_check_yell then
						allowCheck = true;
					elseif type == "CHAT_MSG_WHISPER" and MrtWoo.db.profile.modules.lf_check_whisper then
						allowCheck = true;
					elseif type == "CHAT_MSG_CHANNEL" and MrtWoo.db.profile.modules.lf_check_channel then
						allowCheck = true;
					elseif type == "CHAT_MSG_TEXT_EMOTE" and MrtWoo.db.profile.modules.lf_check_emote then
						allowCheck = true;
					end;

					if allowWhoIs and allowCheck then
						local state = MrtWoo_AntiSpamMonitor:LfCheck(player);

						if state == nil then
							if MrtWoo.db.profile.modules.as_debug then
								MrtWoo:Print(strformat("REQ_INFO: msgAuthor: %s", msgAuthor));
							end;
							player:Lock();
						else
							if not state then
								if MrtWoo.db.profile.modules.as_debug then
									MrtWoo:Print(strformat("LVL_FILTR: msgAuthor: %s", msgAuthor));
								end;

								if (type == "CHAT_MSG_WHISPER") then
									SendChatMessage(MrtWoo.db.profile.modules.lf_whitelist_autoreplay, "WHISPER", nil, msgAuthor);
								end;

								result = self.MSG_RESULT_LVLFILTER;
							end;
						end;
					end;

				end;

				if (msgRate >= MrtWoo.db.profile.modules.as_hiderate) and (msgRate < MrtWoo.db.profile.modules.as_spamrate) then

					if not MrtWoo.db.profile.modules.as_silent or MrtWoo.db.profile.modules.as_debug then
						MrtWoo:Print(strformat(L["Message from the player %s hidden for a reason: suspicion of spam! Post rating: %i"], msgAuthor, msgRate));
					end;

					-- _msg:Spam();

					result = self.MSG_RESULT_SPAM;

				elseif (msgRate >= MrtWoo.db.profile.modules.as_spamrate) then
					player:Spammer();
					_msg:Spam();

					if not ReportPlayer then
						if not MrtWoo.db.profile.modules.as_silent or MrtWoo.db.profile.modules.as_debug then
							MrtWoo:Print(strformat(L["Messages from the player |Hplayer:%s|h[%s]|h blocked, reason: Spam! Post rating: %i, please be an awesome person and report it by clicking |cffC0FFFF|HMrtWoo:report:%d:%s|h[here]|h|r, for show message clicking |cffC0FFFF|HMrtWoo:show:%d:%s|h[here]|h|r"], player:GetName(), player:GetName(), msgRate, _msg:GetId(), player:GetFullName()));
						end;

						if (MrtWoo.db.profile.modules.as_block_24h) then
							self.BlockList:Block(fullName, 86400, _msg:GetValue());
						end;

						if (MrtWoo.db.profile.modules.as_report) and (not _msg:IsReported()) then
							if (MrtWoo.db.profile.modules.as_report_queue) then
								self:AddToReportQueue(_msg:GetId(), fullName);
							else
								if MrtWoo.db.profile.modules.as_debug then
									MrtWoo:Print(strformat("SEND_REPORT: msgAuthor: %s", fullName));
								end;
								_msg:Report();
							end;
						end;
					else
						if not MrtWoo.db.profile.modules.as_silent or MrtWoo.db.profile.modules.as_debug then
							MrtWoo:Print(strformat(L["Messages from the player |Hplayer:%s|h[%s]|h blocked, reason: Spam! Post rating: %i, please be an awesome person and report it by clicking |cffC0FFFF|HMrtWoo:report:%d:%s|h[here]|h|r, for show message clicking |cffC0FFFF|HMrtWoo:show:%d:%s|h[here]|h|r"], player:GetName(), player:GetName(), msgRate, _msg:GetId(), player:GetFullName(), _msg:GetId(), player:GetFullName()));
						end;
					end;
				end;
			end;
		end;

		if player:IsSpammer() then
			result = self.MSG_RESULT_SPAM;
		elseif player:IsLock() then
			result = self.MSG_RESULT_WAIT;
		end;

		if MrtWoo.db.profile.modules.as_debug and (result == self.MSG_RESULT_SPAM or result == self.MSG_RESULT_FLOOD) then
			MrtWoo:Print(strformat("!OK: msgId: %i, msgVal: %s, msgRate: %i, msgAuthor: %s", msgId, _msgVal, msgRate, fullName));
			--[[
			if (result == self.MSG_RESULT_SPAM) then
				eventController.arg[1] = strformat("\124cFFFF0000%s\124r", _msgVal2);
				result = self.MSG_RESULT_OK;
			end;
			]]
		end;

		if 	(result == self.MSG_RESULT_OK) or (result == self.MSG_RESULT_SPAM) then
			local _dup = messages:GetDup(_msgVal);
			if _dup then
				_dup.t = _time;
			end;

			-- _msgVal = strgsub(_msgVal, '%s+', '_');
			-- MrtWoo:Print(_msgVal);

		end;

	end;

	if (MrtWoo.db.profile.modules.as_report_queue) then
		self:ProcessReportQueue();
	end;

	return result;

end;

MrtWoo_AntiSpamMonitor.LastCleanTime = 0;

function MrtWoo_AntiSpamMonitor:SmartClean()
	local c_time = GetTime();
	if (c_time - MrtWoo_AntiSpamMonitor.LastCleanTime) > MrtWoo.db.profile.modules.as_gc_wait_time then

		tbl_foreach(self.Players,
			function(k, v)
				local m = v:GetMessages();
				m:SmartClean(MrtWoo.db.profile.modules.as_antiflud_time);
			end
		);

		MrtWoo_AntiSpamMonitor.LastCleanTime = c_time;
	end;
end;

function MrtWoo_AntiSpamMonitor:ShowSpamers()
	MrtWoo:Print("=== call ShowSpamers() ===");
	if (MrtWoo_AntiSpamMonitor.Players) then
		for _, p in pairs(MrtWoo_AntiSpamMonitor.Players) do
			-- if p:IsSpammer() then
				local msgs = p:GetMessages();
				for _, m in pairs(msgs.msg_ids) do
					if m:IsSpam() then
						MrtWoo:Print(strformat("%s: %s, rate: %i", p:GetFullName(), m:GetValue(), m:GetRate()));
					end;
				end;
			-- end;
		end;
	end;
end;

MrtWoo_AntiSpamMonitor.InternalMessageId = 0;

function MrtWoo_AntiSpamMonitor:CHAT_MSG_GLOBAL_CONTROLLER(eventController, message, from, ...)
	local event = eventController:GetEvent();
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg15, arg15 = eventController:GetArgs();

	local msgVal  = arg1;
	local msgAuthor = arg2;
	local msgChannelName = arg9;

	-- MrtWoo:Print(msgChannelName, msgAuthor, msgVal);

	if 	(strlen(msgVal) == 0) 
		or (strlen(msgAuthor) == 0) 
		or (
				msgChannelName 
				and (
					strfind(msgChannelName, "LFGForwarder") or strfind(msgChannelName, "TCForwarder")
				) 
				and (strfind(msgVal, "LFW_") == 2)
		) -- Don't check lfgforwarder or tcforwarder sys messagess
		or (msgChannelName and strfind(msgChannelName, "oqchannel"))
	then
		return;
	end;

	local msgId = arg11;

	if (msgId == 0) then
		MrtWoo_AntiSpamMonitor.InternalMessageId = MrtWoo_AntiSpamMonitor.InternalMessageId - 1;
		msgId = MrtWoo_AntiSpamMonitor.InternalMessageId;
	end;

	self:AddMessageToQueue(
		eventController,
		msgId, -- arg11
		event, -- strEvent
		arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg15, arg15 -- blizzMsgArgs
	);
end
