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
local GetRealmName = GetRealmName;
local UnitName = UnitName;

-- //

local MrtWoo = MrtWoo;

local AntiSpam = MrtWoo:NewModule("AntiSpam", "AceEvent-3.0");
AntiSpam.Version = "0.3.14.60100-release2";
local L = LibStub("AceLocale-3.0"):GetLocale("MrtWoo_AntiSpam", true);

local AntiSpam_U2S_DB = {};
local MrtWoo_AntiSpamDefaultDB = MrtWoo_AntiSpamDefaultDB;

local opts = {
	as_options = {
		type="group",
		name=L["AntiSpam"],
		args={
			silent = {
				type = "toggle",
				name = L["Quiet mode"] ,
				desc = L["Do not display messages when blocking spam"],
				get = function() return MrtWoo.db.profile.modules.as_silent end,
				set = function() MrtWoo.db.profile.modules.as_silent = not MrtWoo.db.profile.modules.as_silent end,
				order=2,
			},

			report = {
				type = "toggle",
				name = L["Send reports of spam"],
				desc = L["If enabled, the addon will automatically send reports of spam"],
				get = function()
					if (ReportPlayer ~= nil) then
						MrtWoo.db.profile.modules.as_report = false;
					end;
					return MrtWoo.db.profile.modules.as_report
				end,
				set = function() MrtWoo.db.profile.modules.as_report = not MrtWoo.db.profile.modules.as_report end,
				disabled = ReportPlayer ~= nil,
				order=1,
			},

			report_q = {
				type = "toggle",
				name = L["Use report queue"],
				desc = L["If enabled, the addon use report queue"],
				get = function()
					if (ReportPlayer ~= nil) then
						MrtWoo.db.profile.modules.as_report_queue = false;
					end;
					return MrtWoo.db.profile.modules.as_report_queue
				end,
				set = function() MrtWoo.db.profile.modules.as_report_queue = not MrtWoo.db.profile.modules.as_report_queue end,
				disabled = ReportPlayer ~= nil,
				order=2,
			},

			block_24h = {
				type = "toggle",
				name = L["Add to blacklist on 24h"],
				desc = L["If enabled, the addon adds user to the blacklist on 24 hours"],
				get = function() return MrtWoo.db.profile.modules.as_block_24h end,
				set = function() MrtWoo.db.profile.modules.as_block_24h = not MrtWoo.db.profile.modules.as_block_24h end,
				order=3,
			},


			s_check = {
				type = "description",
				name = L["What types of messages to check?"],
				order=4,
			},

			s_check_say = {
				type = "toggle",
				name = L["Say"],
				desc = L["Check the say?"],
				get = function() return MrtWoo.db.profile.modules.as_s_check_say end,
				set = function() MrtWoo.db.profile.modules.as_s_check_say = not MrtWoo.db.profile.modules.as_s_check_say end,
				order=5,
			},

			s_check_yell = {
				type = "toggle",
				name = L["Yell"],
				desc = L["Check the yell?"],
				get = function() return MrtWoo.db.profile.modules.as_s_check_yell end,
				set = function() MrtWoo.db.profile.modules.as_s_check_yell = not MrtWoo.db.profile.modules.as_s_check_yell end,
				order=6,
			},

			s_check_emote = {
				type = "toggle",
				name = L["Emote"],
				desc = L["Check the emote?"],
				get = function() return MrtWoo.db.profile.modules.as_s_check_emote end,
				set = function() MrtWoo.db.profile.modules.as_s_check_emote = not MrtWoo.db.profile.modules.as_s_check_emote end,
				order=7,
			},

			s_check_whisper = {
				type = "toggle",
				name = L["Whisper"],
				desc = L["Check the whisper?"],
				get = function() return MrtWoo.db.profile.modules.as_s_check_whisper end,
				set = function() MrtWoo.db.profile.modules.as_s_check_whisper = not MrtWoo.db.profile.modules.as_s_check_whisper end,
				order=8,
			},

			s_check_channel = {
				type = "toggle",
				name = L["Channels"],
				desc = L["Check the channels?"],
				get = function() return MrtWoo.db.profile.modules.as_s_check_channel end,
				set = function() MrtWoo.db.profile.modules.as_s_check_channel = not MrtWoo.db.profile.modules.as_s_check_channel end,
				order=9,
			},

			hide_rate = {
				type = "range",
				max = 500,
				min = 1,
				bigStep = 1,
				step = 1,
				name = L["Maximum rating of the message after which it will be hidden"],
				desc = L["After receiving the messages are scanned for spam and given a rating, usually a normal message is not spam has a rating of 0-75 ... If the message rating exceeds a predetermined threshold, then the message will be treated as suspicious and will be hidden."],
				get = function() return MrtWoo.db.profile.modules.as_hiderate end,
				set = function(info, input) MrtWoo.db.profile.modules.as_hiderate = input end,
				order=11,
			},

			spam_rate = {
				type = "range",
				max = 500,
				min = 1,
				bigStep = 1,
				step = 1,
				name = L["Maximum rating of the message after which it will be blocked"],
				desc = L["After receiving the message is scanned for spam and it is assigned a rating, usually a normal message is not spam has a rating of 0-75 ... If the message rating exceeds a given threshold of the lock, then the message will be seen as spam and all messages from this user will be freezing."],
				get = function() return MrtWoo.db.profile.modules.as_spamrate end,
				set = function(info, input) MrtWoo.db.profile.modules.as_spamrate = input end,
				order=12,
			},

			spam_additional_checks = {
				type = "toggle",
				name = L["Perform additional checks?"],
				desc = L["It often happens that the scan only messages are not enough ... so sometimes you need to check the level of character, his nickname ..."],
				get = function() return MrtWoo.db.profile.modules.as_spam_additional_checks end,
				set = function() MrtWoo.db.profile.modules.as_spam_additional_checks = not MrtWoo.db.profile.modules.as_spam_additional_checks end,
				order=13,
			},

			spam_rate_needed_for_additional_checks = {
				type = "range",
				max = 500,
				min = 1,
				bigStep = 1,
				step = 1,
				name = L["Rating posts required for the additional checks"],
				desc = L["This value must be less than the rating of the lock, or additional tests will not meet"],
				get = function() return MrtWoo.db.profile.modules.as_spamrate_needed_for_additional_checks end,
				set = function(info, input) MrtWoo.db.profile.modules.as_spamrate_needed_for_additional_checks = input end,
				disabled = function() return MrtWoo.db.profile.modules.as_spam_additional_checks == false end,
				order=14,
			},

			spam_maxlvl = {
				type = "range",
				max = 100,
				min = 1,
				bigStep = 1,
				step = 1,
				name = L["Max is not a reliable player level"],
				desc = L["Spammers usually do not get the level higher than 15 ..."],
				get = function() return MrtWoo.db.profile.modules.as_spam_maxlvl end,
				set = function(info, input) MrtWoo.db.profile.modules.as_spam_maxlvl = input end,
				disabled = function() return MrtWoo.db.profile.modules.as_spam_additional_checks == false end,
				order=15,
			},

			spam_ratelvl = {
				type = "range",
				max = 500,
				min = 1,
				bigStep = 1,
				step = 1,
				name = L["Extra rating posts if the author is not a reliable level"],
				desc = L["Specify additional rating messages, it will be added to the rating message that was received after checking the contents ... if the total rating reports exceed the threshold of the lock, then the message will be seen as spam and all messages from this user will be freezing"],
				get = function() return MrtWoo.db.profile.modules.as_spam_ratelvl end,
				set = function(info, input) MrtWoo.db.profile.modules.as_spam_ratelvl = input end,
				disabled = function() return MrtWoo.db.profile.modules.as_spam_additional_checks == false end,
				order=16,
			},

			gc_wait_time = {
				type = "range",
				max = 600,
				min = 1,
				bigStep = 1,
				step = 1,
				name = L["Garbage collection interval (sec)"],
				desc = L["This value affects how often will occur trying to remove unnecessary data from memory"],
				get = function() return MrtWoo.db.profile.modules.as_gc_wait_time end,
				set = function(info, input) MrtWoo.db.profile.modules.as_gc_wait_time = input end,
				order=17,
			},

			debug = {
				type = "toggle",
				name = L["Debug"],
				desc = L["It makes sense to enable in the search errors (displays additional information during the addon)"],
				get = function() return MrtWoo.db.profile.modules.as_debug end,
				set = function() MrtWoo.db.profile.modules.as_debug = not MrtWoo.db.profile.modules.as_debug end,
				order=18,
			},

			lf_options = {
				type="group",
				name=L["LevelFilter"],
				order=2,
				args={

					lf_enable = {
						type = "toggle",
						name = L["Enable Level filter"],
						desc = L["If enabled, messages from players whose level is not included in the range will not be displayed"],
						get = function() return MrtWoo.db.profile.modules.lf_enable end,
						set = function()
							MrtWoo.db.profile.modules.lf_enable = not MrtWoo.db.profile.modules.lf_enable
							MrtWoo_AntiSpamMonitor:OnPlayerEnteringWorld();
						end,
						order=1,
					},

					lf_min = {
						type = "range",
						max = 100,
						min = 1,
						bigStep = 1,
						step = 1,
						name = L["Minimum level"],
						--desc = "...",
						get = function() return MrtWoo.db.profile.modules.lf_min end,
						set = function(info, input) MrtWoo.db.profile.modules.lf_min = input end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=3,
					},

					lf_max = {
						type = "range",
						max = 100,
						min = 1,
						bigStep = 1,
						step = 1,
						name = L["Maximum level"],
						--desc = "...",
						get = function() return MrtWoo.db.profile.modules.lf_max end,
						set = function(info, input) MrtWoo.db.profile.modules.lf_max = input end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=4,
					},

					lf_whitelist_autoreplay = {
						type = "input",
						name = L["Auto replay"],
						get = function() return MrtWoo.db.profile.modules.lf_whitelist_autoreplay end,
						set = function(info, input) MrtWoo.db.profile.modules.lf_whitelist_autoreplay = input end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=5,
					},

					lf_check = {
						type = "description",
						name = L["What types of messages to check?"],
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=6,
					},

					lf_check_say = {
						type = "toggle",
						name = L["Say"],
						desc = L["Check the say?"],
						get = function() return MrtWoo.db.profile.modules.lf_check_say end,
						set = function() MrtWoo.db.profile.modules.lf_check_say = not MrtWoo.db.profile.modules.lf_check_say end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=7,
					},

					lf_check_yell = {
						type = "toggle",
						name = L["Yell"],
						desc = L["Check the yell?"],
						get = function() return MrtWoo.db.profile.modules.lf_check_yell end,
						set = function() MrtWoo.db.profile.modules.lf_check_yell = not MrtWoo.db.profile.modules.lf_check_yell end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=8,
					},

					lf_check_emote = {
						type = "toggle",
						name = L["Emote"],
						desc = L["Check the emote?"],
						get = function() return MrtWoo.db.profile.modules.lf_check_emote end,
						set = function() MrtWoo.db.profile.modules.lf_check_emote = not MrtWoo.db.profile.modules.lf_check_emote end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=9,
					},

					lf_check_whisper = {
						type = "toggle",
						name = L["Whisper"],
						desc = L["Check the whisper?"],
						get = function() return MrtWoo.db.profile.modules.lf_check_whisper end,
						set = function() MrtWoo.db.profile.modules.lf_check_whisper = not MrtWoo.db.profile.modules.lf_check_whisper end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=10,
					},

					lf_check_channel = {
						type = "toggle",
						name = L["Channels"],
						desc = L["Check the channels?"],
						get = function() return MrtWoo.db.profile.modules.lf_check_channel end,
						set = function() MrtWoo.db.profile.modules.lf_check_channel = not MrtWoo.db.profile.modules.lf_check_channel end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=11,
					},

					lf_whitelist = {
						type = "description",
						name = L["White list"],
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=12,
					},

					lf_whitelist_friends = {
						type = "toggle",
						name = L["Friends"],
						-- desc = L["Check the whisper?"],
						get = function() return MrtWoo.db.profile.modules.lf_whitelist_friends end,
						set = function()
							MrtWoo.db.profile.modules.lf_whitelist_friends = not MrtWoo.db.profile.modules.lf_whitelist_friends;
							MrtWoo_AntiSpamMonitor:OnFriendListUpdate();
						end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=13,
					},

					lf_whitelist_guild = {
						type = "toggle",
						name = L["Guild"],
						-- desc = L["Check the channels?"],
						get = function() return MrtWoo.db.profile.modules.lf_whitelist_guild end,
						set = function()
							MrtWoo.db.profile.modules.lf_whitelist_guild = not MrtWoo.db.profile.modules.lf_whitelist_guild;
							MrtWoo_AntiSpamMonitor:OnGuildRosterUpdate();
						end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=14,
					},

					lf_whitelist_party = {
						type = "toggle",
						name = L["Party"],
						-- desc = L["Check the channels?"],
						get = function() return MrtWoo.db.profile.modules.lf_whitelist_party end,
						set = function()
							MrtWoo.db.profile.modules.lf_whitelist_party = not MrtWoo.db.profile.modules.lf_whitelist_party;
							MrtWoo_AntiSpamMonitor:OnPartyMembersChanged();
						end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=15,
					},

					lf_whitelist_raid = {
						type = "toggle",
						name = L["Raid"],
						-- desc = L["Check the channels?"],
						get = function() return MrtWoo.db.profile.modules.lf_whitelist_raid end,
						set = function()
							MrtWoo.db.profile.modules.lf_whitelist_raid = not MrtWoo.db.profile.modules.lf_whitelist_raid;
							MrtWoo_AntiSpamMonitor:OnRaidRosterUpdate();
						end,
						disabled = function() return MrtWoo.db.profile.modules.lf_enable == false end,
						order=16,
					},

				}
			},
			af_options = {
				type="group",
				name=L["Anti-Flud"],
				order=1,
				args={

					antiflud = {
						type = "toggle",
						name = L["Anti-Flud"],
						desc = L["Enable Anti-flud filters"],
						get = function() return MrtWoo.db.profile.modules.as_antiflud end,
						set = function() MrtWoo.db.profile.modules.as_antiflud = not MrtWoo.db.profile.modules.as_antiflud end,
						order=1,
					},

					antiflud_time = {
						type = "range",
						max = 1200,
						min = 1,
						bigStep = 1,
						step = 1,
						name = L["How often is allowed to send the same message?"],
						desc = L["The larger this value, the less will appear the same message"],
						get = function() return MrtWoo.db.profile.modules.as_antiflud_time end,
						set = function(info, input) MrtWoo.db.profile.modules.as_antiflud_time = input end,
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=2,
					},

					f_smart_replace = {
						type = "toggle",
						name = L["Normalize messages"],
						desc = L["Test without special characters, spaces, etc."],
						get = function() return MrtWoo.db.profile.modules.as_f_smart_replace end,
						set = function() MrtWoo.db.profile.modules.as_f_smart_replace = not MrtWoo.db.profile.modules.as_f_smart_replace end,
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=2,
					},

					f_check = {
						type = "description",
						name = L["What types of messages to check?"],
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=3,
					},

					f_check_say = {
						type = "toggle",
						name = L["Say"],
						desc = L["Check the say?"],
						get = function() return MrtWoo.db.profile.modules.as_f_check_say end,
						set = function() MrtWoo.db.profile.modules.as_f_check_say = not MrtWoo.db.profile.modules.as_f_check_say end,
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=4,
					},

					f_check_yell = {
						type = "toggle",
						name = L["Yell"],
						desc = L["Check the yell?"],
						get = function() return MrtWoo.db.profile.modules.as_f_check_yell end,
						set = function() MrtWoo.db.profile.modules.as_f_check_yell = not MrtWoo.db.profile.modules.as_f_check_yell end,
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=5,
					},

					f_check_emote = {
						type = "toggle",
						name = L["Emote"],
						desc = L["Check the emote?"],
						get = function() return MrtWoo.db.profile.modules.as_f_check_emote end,
						set = function() MrtWoo.db.profile.modules.as_f_check_emote = not MrtWoo.db.profile.modules.as_f_check_emote end,
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=6,
					},

					f_check_whisper = {
						type = "toggle",
						name = L["Whisper"],
						desc = L["Check the whisper?"],
						get = function() return MrtWoo.db.profile.modules.as_f_check_whisper end,
						set = function() MrtWoo.db.profile.modules.as_f_check_whisper = not MrtWoo.db.profile.modules.as_f_check_whisper end,
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=7,
					},

					f_check_channel = {
						type = "toggle",
						name = L["Channels"],
						desc = L["Check the channels?"],
						get = function() return MrtWoo.db.profile.modules.as_f_check_channel end,
						set = function() MrtWoo.db.profile.modules.as_f_check_channel = not MrtWoo.db.profile.modules.as_f_check_channel end,
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=8,
					},

					f_line = {
						type = "description",
						name = "",
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=9,
					},

					f_debug = {
						type = "toggle",
						name = L["Debug"],
						desc = L["It makes sense to enable in the search errors (displays additional information during the addon)"],
						get = function() return MrtWoo.db.profile.modules.as_f_debug end,
						set = function() MrtWoo.db.profile.modules.as_f_debug = not MrtWoo.db.profile.modules.as_f_debug end,
						disabled = function() return MrtWoo.db.profile.modules.as_antiflud == false end,
						order=10,
					},
				},
			},
			db_options = {
				type="group",
				name=L["Database"],
				order=3,
				args={

					db_allow_update = {
						type = "toggle",
						name = L["Allow update local copy database?"],
						desc = L["If enabled, allows to update a local database of keywords."],
						get = function() return MrtWoo.db.profile.modules.as_db_allow_update end,
						set = function() MrtWoo.db.profile.modules.as_db_allow_update = not MrtWoo.db.profile.modules.as_db_allow_update end,
						order=1,
					},

					db_allow_update_without_confirm = {
						type = "toggle",
						name = L["Allow update without confirmation?"],
						desc = L["If enabled, you can update a local database of keywords, without confirmation."],
						get = function() return MrtWoo.db.profile.modules.as_db_allow_update_without_confirm end,
						set = function() MrtWoo.db.profile.modules.as_db_allow_update_without_confirm = not MrtWoo.db.profile.modules.as_db_allow_update_without_confirm end,
						disabled = function() return MrtWoo.db.profile.modules.as_db_allow_update == false end,
						order=2,
					},

					patterns_editor = {
						type = "execute",
						name = L["Patterns Editor"],
						desc = L["Show Patterns Editor"],
						func = function(info, input) AntiSpam:ShowPatternsEditor(nil); end,
						order=10,
					},

					blocklist_editor = {
						type = "execute",
						name = L["BlockList Editor"],
						desc = L["Show BlockList Editor"],
						func = function(info, input) AntiSpam:ShowBlockListEditor(nil); end,
						order=11,
					},

				}
			}
		}
	},
};

function AntiSpam:SetDefaults()
	MrtWoo.defaults.profile.modules.as_silent = true;
	MrtWoo.defaults.profile.modules.as_debug = false;
	MrtWoo.defaults.profile.modules.as_antiflud = true;
	MrtWoo.defaults.profile.modules.as_report = false;
	MrtWoo.defaults.profile.modules.as_report_queue = false;
	MrtWoo.defaults.profile.modules.as_block_24h = true;
	MrtWoo.defaults.profile.modules.as_antiflud_time = 300;
	MrtWoo.defaults.profile.modules.as_spam_additional_checks = true;
	MrtWoo.defaults.profile.modules.as_spam_maxlvl = 15;
	MrtWoo.defaults.profile.modules.as_spam_ratelvl = 50;
	MrtWoo.defaults.profile.modules.as_hiderate = 100;
	MrtWoo.defaults.profile.modules.as_spamrate = 150;
	MrtWoo.defaults.profile.modules.as_spamrate_needed_for_additional_checks = 50;
	MrtWoo.defaults.profile.modules.as_gc_wait_time = 500;
	MrtWoo.defaults.profile.modules.as_gc_message_lifetime = 60;
	MrtWoo.defaults.profile.modules.as_gc_checkinfo_lifetime = 600;
	MrtWoo.defaults.profile.modules.as_filters = false;
	MrtWoo.defaults.profile.modules.as_blocklist = false;

	MrtWoo.defaults.profile.modules.as_f_check_say = true;
	MrtWoo.defaults.profile.modules.as_f_check_yell = true;
	MrtWoo.defaults.profile.modules.as_f_check_whisper = false;
	MrtWoo.defaults.profile.modules.as_f_check_channel = true;
	MrtWoo.defaults.profile.modules.as_f_check_emote = true;
	MrtWoo.defaults.profile.modules.as_f_smart_replace = true;

	MrtWoo.defaults.profile.modules.as_s_check_say = true;
	MrtWoo.defaults.profile.modules.as_s_check_yell = true;
	MrtWoo.defaults.profile.modules.as_s_check_whisper = false;
	MrtWoo.defaults.profile.modules.as_s_check_channel = true;
	MrtWoo.defaults.profile.modules.as_s_check_emote = true;

	MrtWoo.defaults.profile.modules.lf_enable = false;
	MrtWoo.defaults.profile.modules.lf_min = 20;
	MrtWoo.defaults.profile.modules.lf_max = 100;
	MrtWoo.defaults.profile.modules.lf_check_say = false;
	MrtWoo.defaults.profile.modules.lf_check_yell = false;
	MrtWoo.defaults.profile.modules.lf_check_emote = false;
	MrtWoo.defaults.profile.modules.lf_check_whisper = true;
	MrtWoo.defaults.profile.modules.lf_check_channel = false;

	MrtWoo.defaults.profile.modules.lf_whitelist_autoreplay = L["Sorry, but I do not want to receive messages from low-level players..."];
	MrtWoo.defaults.profile.modules.lf_whitelist_friends = true;
	MrtWoo.defaults.profile.modules.lf_whitelist_guild = true;
	MrtWoo.defaults.profile.modules.lf_whitelist_party = true;
	MrtWoo.defaults.profile.modules.lf_whitelist_raid = true;

	MrtWoo.defaults.profile.modules.as_db_allow_update = true;
	MrtWoo.defaults.profile.modules.as_db_allow_update_without_confirm = false;

	MrtWoo.defaults.profile.modules.as_dbsnapshot = false;
	MrtWoo.defaults.profile.modules.as_dbver = 0;

end;

function AntiSpam:OnInitialize()
	self:SetDefaults();
	tbl_ins(MrtWoo.options.plugins, opts);

	MrtWoo:RegisterChatCommand("mrtwoo_show_smi", AntiSpam.ShowSpamMonInfo);
	MrtWoo:RegisterChatCommand("mrtwoo_patterns", AntiSpam.ShowPatternsEditor);
	MrtWoo:RegisterChatCommand("mrtwoo_blocklist", AntiSpam.ShowBlockListEditor);
	MrtWoo:RegisterChatCommand("mrtwoo_test", AntiSpam.AsTest);

	AntiSpam_U2S_DB = {};
end;

function AntiSpam:OnClosePatternsEditor()
	-- MrtWoo:Print("=== AntiSpam:OnClosePatternsEditor() ===");
	MrtWoo.db.profile.modules.as_filters = MrtWoo_AntiSpamFilterGUI.Words;
	MrtWoo_AntiSpamFilter.Words = MrtWoo_AntiSpamFilterGUI.Words;
	AntiSpam.Monitor.MessagesFilter:ReloadWords();
end;

function AntiSpam:ShowSpamMonInfo(input)
	-- AntiSpam.MsgsQueue:Show();
	AntiSpam.Monitor:ShowSMI();
end;

function AntiSpam:ShowPatternsEditor(input)
	local FilterGUI = MrtWoo_AntiSpamFilterGUI:new();
	FilterGUI:CreateFrame();
	FilterGUI:Show();
end;

function AntiSpam:AsTest(input)

end;

function AntiSpam:ShowBlockListEditor(input)
	local BlockListGUI = MrtWoo_AntiSpamBlockListGUI:new();
	BlockListGUI:CreateFrame();
	BlockListGUI:Show();
end;

function AntiSpam_UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData, ...)
	if (not AntiSpam_U2S_DB[name]) then
		local server = MrtWoo.MyRealm;

		if ( unit ) then
			name, server = UnitName(unit);
		elseif ( name ) then
			local n, s = strmatch(name, "^([^-]+)-(.*)");
			if ( n ) then
				name = n;
				server = s;
			end
		end;

		AntiSpam_U2S_DB[name] = server;
	end;

	for i=1, UIDROPDOWNMENU_MAXBUTTONS do
		local button = _G["DropDownList"..UIDROPDOWNMENU_MENU_LEVEL.."Button"..i];
		if (button ~= nil) then
			local v = tostring(button.value);
			if (v ~= nil and strfind(v, "MRTWOO_BLOCK_") ~= nil) then
				button.func = UnitPopupButtons[v].func;
				button.mrtName = name;
			end;
		end;
	end;
end;

function AntiSpam_OnClickBlockButton(self)
	-- local dropdownFrame = UIDROPDOWNMENU_INIT_MENU

	local button = self.value;

	local name = self.mrtName;
	local server = AntiSpam_U2S_DB[name];

	if ( name and UnitPopupButtons[button] ) then
		local dialog = StaticPopup_Show("CONFIRM_MRTWOO_BLOCK", name, UnitPopupButtons[button].text );
		if ( dialog ) then
			local fullname = name;

			if (server == nil) or (server ~= "") then
				fullname = name .. "-" .. server;
			else
				fullname = name .. "-" .. MrtWoo.MyRealm;
			end

			dialog.data = {button = button, fullname = fullname};
		end;
	end
end;

function AntiSpam:UpdateDatabase(defDBVer, curDBVer)
	local needReloadDB = false;

	for word, value in pairs(MrtWoo_AntiSpamDefaultDB.Words) do
		local lwrWord = strlower(word);

		local curValue = MrtWoo_AntiSpamFilter.Words[lwrWord];

		local oldValue = false;
		if (MrtWoo.db.profile.modules.as_dbsnapshot ~= false) then
			oldValue = MrtWoo.db.profile.modules.as_dbsnapshot[lwrWord];
		end;

		if (curValue ~= nil) then
			if (curValue ~= value) and (oldValue == false or oldValue == curValue) then
				if (value == 0) then
					MrtWoo:Print(strformat("DB D: %s", lwrWord));
					MrtWoo_AntiSpamFilter.Words[lwrWord] = nil;
				else
					MrtWoo:Print(strformat("DB U: %s, old=%i, new=%i", lwrWord, curValue, value));
					MrtWoo_AntiSpamFilter.Words[lwrWord] = value;
				end;
				needReloadDB = true;
			end;
		else
			if (oldValue == false or oldValue == nil or (oldValue == 0 and value ~= 0)) then
				MrtWoo:Print(strformat("DB N: %s, new=%i", lwrWord, value));
				MrtWoo_AntiSpamFilter.Words[lwrWord] = value;
				needReloadDB = true;
			end;
		end;
	end;

	if (needReloadDB) then
		AntiSpam.Monitor.MessagesFilter:ReloadWords();
	end;

	MrtWoo.db.profile.modules.as_dbsnapshot = MrtWoo_AntiSpamDefaultDB.Words;
	MrtWoo.db.profile.modules.as_dbver = defDBVer;
end;

function AntiSpam:OnEnable()
	self.Monitor = MrtWoo_AntiSpamMonitor:new();

	self:RegisterMessage('MRTWOO_ASGUI_ONCLOSE', AntiSpam.OnClosePatternsEditor);

	MrtWoo_AntiSpamDefaultDB.Words = {};
	for word, value in pairs(MrtWoo_AntiSpamDefaultDB.Locale["Base"]) do
		MrtWoo_AntiSpamDefaultDB.Words[word] = value;
	end;

	local locale = GetLocale();
	if (locale ~= nil and MrtWoo_AntiSpamDefaultDB.Locale[locale] ~= nil) then
		for word, value in pairs(MrtWoo_AntiSpamDefaultDB.Locale[locale]) do
			MrtWoo_AntiSpamDefaultDB.Words[word] = value;
		end;
	end;

	local defDBVer = tonumber(MrtWoo_AntiSpamDefaultDB.Version) or 0;
	local curDBVer = tonumber(MrtWoo.db.profile.modules.as_dbver) or 0;

	if MrtWoo.db.profile.modules.as_filters ~= false then
		MrtWoo_AntiSpamFilter.Words = MrtWoo.db.profile.modules.as_filters;
	else
		MrtWoo_AntiSpamFilter.Words = MrtWoo_AntiSpamDefaultDB.Words;
		MrtWoo.db.profile.modules.as_dbsnapshot = MrtWoo_AntiSpamDefaultDB.Words;
		MrtWoo.db.profile.modules.as_dbver = defDBVer;
		curDBVer = defDBVer;
	end;

	self.Monitor.MessagesFilter:ReloadWords();

	if (MrtWoo.db.profile.modules.as_db_allow_update) and (defDBVer ~= 0) and (defDBVer > curDBVer) then
		MrtWoo:Print(strformat("DB Version: new=%i, you=%i", defDBVer, curDBVer));

		if (MrtWoo.db.profile.modules.as_db_allow_update_without_confirm) then
			AntiSpam:UpdateDatabase(defDBVer, curDBVer);
		else
			StaticPopupDialogs["MRTWOO_DBUP_CONFIRM"] = {
					text = strformat(strgsub(L["MrtWoo: Has been upgraded default database of keywords, update a local database?\\nDB Info: new=%i, you=%i"], "\\n", "\n"), defDBVer, curDBVer),
					button1 = ACCEPT,
					button2 = CANCEL,
					OnAccept = function(self, data, reason)

						local defDBVer = data.defDBVer;
						local curDBVer = data.curDBVer;

						AntiSpam:UpdateDatabase(defDBVer, curDBVer);
					end,
					OnCancel = function(self, data, reason)
						local defDBVer = data.defDBVer;
						local curDBVer = data.curDBVer;

						if( reason == 'clicked') then
							MrtWoo.db.profile.modules.as_dbver = defDBVer;
						end
					end,
					timeout = 0,
					whileDead = true,
					hideOnEscape = true
			}

			local needUpdateDB = false;

			for word, value in pairs(MrtWoo_AntiSpamDefaultDB.Words) do
				local lwrWord = strlower(word);

				local curValue = MrtWoo_AntiSpamFilter.Words[lwrWord];

				local oldValue = false;
				if (MrtWoo.db.profile.modules.as_dbsnapshot ~= false) then
					oldValue = MrtWoo.db.profile.modules.as_dbsnapshot[lwrWord];
				end;

				if (curValue ~= nil) then
					if (curValue ~= value) and (oldValue == false or oldValue == curValue) then
						needUpdateDB = true;
					end;
				else
					if (oldValue == false or oldValue == nil or (oldValue == 0 and value ~= 0)) then
						needUpdateDB = true;
					end;
				end;
			end;

			if ( needUpdateDB ) then
				local dialog = StaticPopup_Show("MRTWOO_DBUP_CONFIRM")
				if ( dialog ) then
					dialog.data = {defDBVer = defDBVer, curDBVer = curDBVer};
				end;
			else
				MrtWoo.db.profile.modules.as_dbver = defDBVer;
			end;
		end;
	end;

	UnitPopupButtons["MRTWOO_BLOCK"] = {};
	UnitPopupButtons["MRTWOO_BLOCK"].dist = 0;
	UnitPopupButtons["MRTWOO_BLOCK"].nested = 1;
	UnitPopupButtons["MRTWOO_BLOCK"].text = L["Block for..."];

	UnitPopupButtons["MRTWOO_BLOCK_15M"] = {dist = 0, text = strformat(L["%s min"], 15), func = AntiSpam_OnClickBlockButton};
	UnitPopupButtons["MRTWOO_BLOCK_30M"] = {dist = 0, text = strformat(L["%s min"], 30), func = AntiSpam_OnClickBlockButton};
	UnitPopupButtons["MRTWOO_BLOCK_60M"] = {dist = 0, text = strformat(L["%s min"], 60), func = AntiSpam_OnClickBlockButton};
	UnitPopupButtons["MRTWOO_BLOCK_120M"] = {dist = 0, text = strformat(L["%s min"], 120), func = AntiSpam_OnClickBlockButton};
	UnitPopupButtons["MRTWOO_BLOCK_24H"] = {dist = 0, text = strformat(L["%s hours"], 24), func = AntiSpam_OnClickBlockButton};
	UnitPopupButtons["MRTWOO_BLOCK_48H"] = {dist = 0, text = strformat(L["%s hours"], 48), func = AntiSpam_OnClickBlockButton};
	UnitPopupButtons["MRTWOO_BLOCK_7D"] = {dist = 0, text = strformat(L["%s days"], 7), func = AntiSpam_OnClickBlockButton};
	UnitPopupButtons["MRTWOO_BLOCK_15D"] = {dist = 0, text = strformat(L["%s days"], 15), func = AntiSpam_OnClickBlockButton};
	UnitPopupButtons["MRTWOO_BLOCK_30D"] = {dist = 0, text = strformat(L["%s days"], 30), func = AntiSpam_OnClickBlockButton};

	UnitPopupMenus["MRTWOO_BLOCK"] = {
		"MRTWOO_BLOCK_15M",
		"MRTWOO_BLOCK_30M",
		"MRTWOO_BLOCK_60M",
		"MRTWOO_BLOCK_120M",
		"MRTWOO_BLOCK_24H",
		"MRTWOO_BLOCK_48H",
		"MRTWOO_BLOCK_7D",
		"MRTWOO_BLOCK_15D",
		"MRTWOO_BLOCK_30D",
	};

	StaticPopupDialogs["CONFIRM_MRTWOO_BLOCK"] = {
		text = L["Do you really want to block |3-1(%s) on %s?"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function(self, data)
			local fullname = data.fullname;
			local button = data.button;

			local lifetime = 0;
			if (button == "MRTWOO_BLOCK_15M") then
				lifetime = 60 * 15;
			elseif (button == "MRTWOO_BLOCK_30M") then
				lifetime = 60 * 30;
			elseif (button == "MRTWOO_BLOCK_60M") then
				lifetime = 60 * 60;
			elseif (button == "MRTWOO_BLOCK_120M") then
				lifetime = 60 * 120;
			elseif (button == "MRTWOO_BLOCK_24H") then
				lifetime = 86400;
			elseif (button == "MRTWOO_BLOCK_48H") then
				lifetime = 86400 * 2;
			elseif (button == "MRTWOO_BLOCK_7D") then
				lifetime = 86400 * 7;
			elseif (button == "MRTWOO_BLOCK_15D") then
				lifetime = 86400 * 15;
			elseif (button == "MRTWOO_BLOCK_30D") then
				lifetime = 86400 * 30;
			end;

			if lifetime > 0 then
				MrtWoo_AntiSpamBlockList:Block(fullname, lifetime, L["User blocked manually"]);
			end;

		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	};

	hooksecurefunc("UnitPopup_ShowMenu", AntiSpam_UnitPopup_ShowMenu);

	tinsert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"]-1, "MRTWOO_BLOCK");

end;

function AntiSpam:OnDisable()
end;

-- ########################################################################

function __genOrderedIndex( t )
	local orderedIndex = {}
	for key in pairs(t) do
		tbl_ins( orderedIndex, key )
	end
	tbl_sort( orderedIndex )
	return orderedIndex
end

function orderedNext(t, state)
	-- Equivalent of the next function, but returns the keys in the alphabetic
	-- order. We use a temporary ordered key table that is stored in the
	-- table being iterated.

	--print("orderedNext: state = "..tostring(state) )
	if state == nil then
		-- the first time, generate the index
		t.__orderedIndex = __genOrderedIndex( t )
		key = t.__orderedIndex[1]
		return key, t[key]
	end
	-- fetch the next value
	key = nil
	for i = 1,tbl_getn(t.__orderedIndex) do
		if t.__orderedIndex[i] == state then
			key = t.__orderedIndex[i+1]
		end
	end

	if key then
		return key, t[key]
	end

	-- no more value to return, cleanup
	t.__orderedIndex = nil
	return
end

function orderedPairs(t)
	-- Equivalent of the pairs() function on tables. Allows to iterate
	-- in order
	return orderedNext, t, nil
end

-- ########################################################################