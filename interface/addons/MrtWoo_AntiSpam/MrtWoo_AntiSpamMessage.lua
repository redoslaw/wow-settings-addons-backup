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

local ReportPlayer = ReportPlayer;
local ComplainChat = ComplainChat;
local CanComplainChat = CanComplainChat;

MrtWoo_AntiSpamMessage = {};

function MrtWoo_AntiSpamMessage:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;

	o.id = 0;
	o.rate = 0;
	o.data = '';
	o.status = 0;
	o.time = 0;
	o.is_spam = false;
	o.is_reported = false;

	return o;
end;

function MrtWoo_AntiSpamMessage:SetId(value)
	self.id = value;
end;

function MrtWoo_AntiSpamMessage:SetValue(value)
	self.data = value;
end;

function MrtWoo_AntiSpamMessage:SetRate(value)
	self.rate = value;
end;

function MrtWoo_AntiSpamMessage:SetTime(value)
	self.time = value;
end;

function MrtWoo_AntiSpamMessage:SetStatus(value)
	self.time = value;
end;

function MrtWoo_AntiSpamMessage:GetId()
	return self.id;
end;

function MrtWoo_AntiSpamMessage:GetValue()
	return self.data;
end;

function MrtWoo_AntiSpamMessage:GetRate()
	return self.rate;
end;

function MrtWoo_AntiSpamMessage:GetTime()
	return self.time;
end;

function MrtWoo_AntiSpamMessage:GetStatus()
	return self.status;
end;

function MrtWoo_AntiSpamMessage:Spam()
	self.is_spam = true;
end;

function MrtWoo_AntiSpamMessage:IsSpam()
	return self.is_spam;
end;

function MrtWoo_AntiSpamMessage:Report()
	if not self.is_reported and (self.id > 0) and CanComplainChat(self.id) then
		if ReportPlayer then --Patch 4.3.4 compat
			-- ReportPlayer(PLAYER_REPORT_TYPE_SPAM, self.id);
		else
			ComplainChat(self.id);
		end;
		self.is_reported = true;
	end;
end;

function MrtWoo_AntiSpamMessage:IsReported()
	return self.is_reported;
end;
