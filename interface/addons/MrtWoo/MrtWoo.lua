--[[
	MrtWoo_Core: MrtWoo Core Module
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

-- //

MrtWoo = LibStub("AceAddon-3.0"):NewAddon("MrtWoo", "AceConsole-3.0", "AceComm-3.0", "AceEvent-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("MrtWoo", true);

MrtWoo.Revision = "314";
MrtWoo.Version = "0.3.14.60100-release2";

MrtWoo.IsNewVerExists = false;

MrtWoo.options = {
	name = "MrtWoo",
	handler = MrtWoo,
	type = 'group',
	plugins = {},
	args = {
		verinfo = {
			type = "description",
			name = function()
				local ver = MrtWoo.Version;
				if not string.find(MrtWoo.Version, "release") and not string.find(MrtWoo.Version, "beta") then
					ver = ver .. "(alpha)";
				end;
				return string.format(L["Current version of the addon: %s"], ver);
			end,
			order=1,
		},
		checknew = {
			type = "toggle",
			name = L["Check new versions?"],
			desc = L["If enabled, the addon will check for new versions of the guild / group"],
			get = function() return MrtWoo.db.profile.modules.core_checknew end,
			set = function() MrtWoo.db.profile.modules.core_checknew = not MrtWoo.db.profile.modules.core_checknew end,
			order=2,
		},
		minimap_icon_show = {
			type = "toggle",
			name = L["Show icon on minimap?"],
			desc = L["If enabled, on the minimap will display an icon for quick access to settings."],
			get = function() return not MrtWoo.db.profile.minimap.hide end,
			set = function()
				MrtWoo.db.profile.minimap.hide = not MrtWoo.db.profile.minimap.hide
				if MrtWoo.db.profile.minimap.hide then
					MrtWoo.icon:Hide("MrtWoo")
				else
					MrtWoo.icon:Show("MrtWoo")
				end
			end,
			order=3,
		},
	}
};

MrtWoo.defaults = {
	profile = {
		modules = {},
		minimap = {}
	}
}

function MrtWoo:OnInitialize()
	MrtWoo:Print(string.format(L["Hello from %s!"], "MrtWoo"));
	MrtWoo:RegisterChatCommand("mrtwoo", "CommandProcessor");

	-- DB
	self.db = LibStub("AceDB-3.0"):New("MrtWooDB", self.defaults, "Default")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MrtWoo", self.options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MrtWoo", "MrtWoo")

	-- Profiles
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MrtWoo-Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
	self.profilesFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MrtWoo-Profiles", L["Profiles"], "MrtWoo")

	-- LDB
	self.ldb = LibStub("LibDataBroker-1.1"):NewDataObject("MrtWoo", {
		type = "data source",
		text = "MrtWoo",
		icon = "Interface\\Addons\\MrtWoo\\Icons\\minimap",
		OnClick = function() InterfaceOptionsFrame_OpenToCategory("MrtWoo"); end
	})
	self.icon = LibStub("LibDBIcon-1.0");

	self:SetDefaults();

	self.MyName = MrtWoo:GetUnitName('player', false);
	self.MyRealm = strgsub(GetRealmName(), '[%s%p%c]+', '');
end;

function MrtWoo:GetVersionInfo(verStr)
	local verInfo = {string.find(verStr, "^(%d+).(%d+).(%d+).(%d+).(.*)$")};
	if verInfo[1] ~= nil then
			local verInfo2 = {string.find(verInfo[7], "^([a-z]+)(%d+)$")};
			if verInfo2[1] == nil then
				verInfo2 = {string.find(verInfo[7], "^([a-z]+)$")};
			end;
			local major = tonumber(verInfo[3] .. verInfo[4] .. verInfo[5]) or 0;
			local minor = tonumber(verInfo2[4]) or 0;
			local type = verInfo2[3] or "alpha"
			return major, minor, type;
	end;
	return 0, 0, "alpha"
end;

function MrtWoo:IsNewVer(mVerStr, rVerStr)
	-- MrtWoo:Print("=== MrtWoo:IsNewVer("..mVerStr..", "..rVerStr..") ===")
	local mMajor, mMinor, mType = self:GetVersionInfo(mVerStr);
	local rMajor, rMinor, rType = self:GetVersionInfo(rVerStr);

	if mMajor == 0 or rMajor == 0 then
		return false;
	end;

	if mType == "release" then
		mType = 1;
	elseif mType == "beta" then
		mType = 2;
	else
		mType = 3;
	end;

	if rType == "release" then
		rType = 1;
	elseif rType == "beta" then
		rType = 2;
	else
		rType = 3;
	end;

	-- MrtWoo:Print(mType, " -- ", rType);

	if mType < rType or rMajor < mMajor then
		return false;
	end;

	if rMajor == mMajor and mType == rType and rMinor <= mMinor then
		return false;
	end;

	-- MrtWoo:Print(mMajor, mMinor, mType, " -- ", rMajor, rMinor, rType);
	return true;

end;

function MrtWoo:SetDefaults()
	MrtWoo.defaults.profile.modules.core_checknew = true;
	MrtWoo.defaults.profile.minimap.hide = false;
end;

function MrtWoo:OnEnable()
	self:RegisterComm("MrtWooVer", "CheckVersionHandler");
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnZoneCchangedNewArea");
	self.icon:Register("MrtWoo", self.ldb, self.db.profile.minimap);
	self:SendVersionInfoToAll();
end;

function MrtWoo:OnDisable()
	self:UnregisterComm("MrtWooVer");
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA");
end;

MrtWoo.LastSendVerInfo = 0;

function MrtWoo:OnZoneCchangedNewArea()
	self.MyRealm = strgsub(GetRealmName(), '[%s%p%c]+', '');
	self:SendVersionInfoToAll();
end;

function MrtWoo:SendVersionInfoToAll()
	-- self:Print('=== MrtWoo:SendVersionInfo() ===');

	if not MrtWoo.db.profile.modules.core_checknew then
		return false;
	end;

	if GetTime() - self.LastSendVerInfo > 600 then
		local sRevision = tostring(tonumber(MrtWoo.Revision) or 0);

		if IsInGuild() then
			self:SendCommMessage("MrtWooVer", sRevision .. "_" .. MrtWoo.Version, "GUILD");
			self.LastSendVerInfo = GetTime();
		end;

		if GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
			self:SendCommMessage("MrtWooVer", sRevision .. "_" .. MrtWoo.Version, "RAID");
			self.LastSendVerInfo = GetTime();
		elseif GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
			self:SendCommMessage("MrtWooVer", sRevision .. "_" .. MrtWoo.Version, "PARTY");
			self.LastSendVerInfo = GetTime();
		end;

	end;
end;

MrtWoo.SendVerInfoStatus = {};

function MrtWoo:SendVersionInfoToTarget(target)
	-- self:Print('=== MrtWoo:SendVersionInfoTo() ===');

	if not MrtWoo.db.profile.modules.core_checknew then
		return false;
	end;

	local isSendVerInfo = self.SendVerInfoStatus[target];

	if isSendVerInfo then
		return true;
	end;

	local iRevision = tonumber(MrtWoo.Revision) or 0;
	local sRevision = tostring(iRevision);
	self:SendCommMessage("MrtWooVer", sRevision .. "_" .. MrtWoo.Version, "WHISPER", target);

	self.SendVerInfoStatus[target] = true;
end;

function MrtWoo:CheckVersionHandler(prefix, message, distribution, sender)
	-- self:Print('=== MrtWoo:CheckVersionHandler() ===');

	if not MrtWoo.db.profile.modules.core_checknew then
		return true
	end;

	local _,_,senderRevisionInt, senderVersionString = string.find(message, "^(%d+)_(.*)$")

	if not self.IsNewVerExists and self:IsNewVer(MrtWoo.Version, senderVersionString) then
		self:Print(L["New version of addon was found in your party/guild, it's recommended to update"])
		self.IsNewVerExists = true;
	elseif (self:IsNewVer(senderVersionString, MrtWoo.Version)) then
		self:SendVersionInfoToTarget(sender);
	end;

end;

function MrtWoo:CommandProcessor(input)
	InterfaceOptionsFrame_OpenToCategory("MrtWoo");
end;

function MrtWoo:GetUnitName(unit, showServerName)
	local name, server = UnitName(unit);
	if ( server and server ~= "" ) then
		if ( showServerName ) then
			return name.." - "..server;
		else
			return name..FOREIGN_SERVER_LABEL;
		end
	else
		return name;
	end
end
