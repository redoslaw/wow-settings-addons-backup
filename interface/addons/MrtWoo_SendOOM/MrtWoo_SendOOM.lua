--[[
	MrtWoo_SendOOM: Shows useful information on the status bar
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

local MrtWoo = MrtWoo;
local SendOOM = MrtWoo:NewModule("SendOOM", "AceEvent-3.0");
SendOOM.Version = "0.3.14.60100-release2";
local L = LibStub("AceLocale-3.0"):GetLocale("MrtWoo_SendOOM", true);

SendOOM.emoteTokenList = setmetatable({},{__mode="k"});

local opts = {
	oom_options = {
		type="group",
		name=L["SendOOM"],
		args={
			enable = {
				type = "toggle",
				name = L["Send OOM mesage to party/raid?"],
				get = function() return MrtWoo.db.profile.modules.oom_enable end,
				set = function() MrtWoo.db.profile.modules.oom_enable = not MrtWoo.db.profile.modules.oom_enable end,
				order=1,
			},

			oom_level = {
				type = "range",
				max = 100,
				min = 1,
				bigStep = 1,
				step = 1,
				name = L["Send a message stating that there is no more mana if its level is less than % ..."],
				get = function() return MrtWoo.db.profile.modules.oom_level end,
				set = function(info, input) MrtWoo.db.profile.modules.oom_level = input end,
				order=2,
			},

			oom_reset = {
				type = "range",
				max = 100,
				min = 1,
				bigStep = 1,
				step = 1,
				name = L["Reset if its mana level is more than % ..."],
				get = function() return MrtWoo.db.profile.modules.oom_reset end,
				set = function(info, input) MrtWoo.db.profile.modules.oom_reset = input end,
				order=3,
			},

			oom_line_1 = {
				type = "description",
				name = "",
				order=4,
			},

			oom_message_enable = {
				type = "toggle",
				name = L["Message"],
				get = function() return MrtWoo.db.profile.modules.oom_message_enable end,
				set = function() MrtWoo.db.profile.modules.oom_message_enable = not MrtWoo.db.profile.modules.oom_message_enable end,
				order=5,
			},

			oom_message = {
				type = "input",
				name = "",
				get = function() return MrtWoo.db.profile.modules.oom_message end,
				set = function(info, input) MrtWoo.db.profile.modules.oom_message = input end,
				order=6,
			},

			oom_line_2 = {
				type = "description",
				name = "",
				order=7,
			},

			oom_emotion_enable = {
				type = "toggle",
				name = L["Emotion"],
				get = function() return MrtWoo.db.profile.modules.oom_emotion_enable end,
				set = function() MrtWoo.db.profile.modules.oom_emotion_enable = not MrtWoo.db.profile.modules.oom_emotion_enable end,
				order=8,
			},

			oom_emotion_list = {
				values = SendOOM.emoteTokenList,
				type = "select",
				name = L[""],
				get = function() return MrtWoo.db.profile.modules.oom_emotion end,
				set = function(info, input) MrtWoo.db.profile.modules.oom_emotion = input; end,
				order=9,
			},

		},
	}
};

function SendOOM:SetDefaults()
	MrtWoo.defaults.profile.modules.oom_enable = false;
	MrtWoo.defaults.profile.modules.oom_level = 20;
	MrtWoo.defaults.profile.modules.oom_reset = 50;
	MrtWoo.defaults.profile.modules.oom_message = L["I have no mana!"];
	MrtWoo.defaults.profile.modules.oom_message_enable = true;
	MrtWoo.defaults.profile.modules.oom_emotion = 'OOM';
	MrtWoo.defaults.profile.modules.oom_emotion_enable = false;
end;

function SendOOM:OnInitialize()
	self.lowMana = nil;
	self:SetDefaults();

	table.insert(MrtWoo.options.plugins, opts)
end;

function SendOOM:OnEnable()
	for key, value in pairs(hash_EmoteTokenList) do
		self.emoteTokenList[value] = key;	-- add to hash
	end;
	self:RegisterEvent("UNIT_POWER", "ProcessPower");
end;

function SendOOM:OnDisable()
	self:UnregisterEvent("UNIT_POWER");
end;

function SendOOM:ProcessPower(event, arg1)
	if not MrtWoo.db.profile.modules.oom_enable or arg1 ~= "player" then
		return false;
	end;

	local powerType, powerTypeString = UnitPowerType(arg1);
	if powerTypeString == "MANA" then
		local mana = (UnitPower(arg1) / UnitPowerMax(arg1));
		if ( mana <= MrtWoo.db.profile.modules.oom_level/100 ) then
			if ( not SendOOM.lowMana ) then
				--MrtWoo:Print(MrtWoo.db.profile.modules.oom_message, COMBAT_TEXT_LOW_MANA_THRESHOLD);
				if not UnitIsDeadOrGhost(arg1) then
					if (MrtWoo.db.profile.modules.oom_message_enable) then
						if GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
							SendChatMessage(MrtWoo.db.profile.modules.oom_message, "RAID");
						elseif GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
							SendChatMessage(MrtWoo.db.profile.modules.oom_message, "PARTY");
						end;
					end;
					if (MrtWoo.db.profile.modules.oom_emotion_enable) then
						DoEmote(MrtWoo.db.profile.modules.oom_emotion);
					end;
				end;

				SendOOM.lowMana = 1;
			end
		elseif ( mana > MrtWoo.defaults.profile.modules.oom_reset/100 ) then
			SendOOM.lowMana = nil;
		end
	end;

end;