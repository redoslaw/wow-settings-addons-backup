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

local MrtWoo = MrtWoo;

MrtWoo_AntiSpamPlayer = {};

function MrtWoo_AntiSpamPlayer:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;

	o.name = '';
	o.info = nil;
	o.is_lock = false;
	o.is_block = false;
	o.is_spammer = false;
	o.is_reported = false;

	o.last_msg = {id = 0, rate = 0, data = ''};

	o.messages = MrtWoo_AntiSpamMessages:new();

	-- MrtWoo:Print('MrtWoo_AntiSpamPlayer:new() => self.Messages:', self.messages);

	return o;
end;

function MrtWoo_AntiSpamPlayer:SetName(value)
	self.name = value;
end;

function MrtWoo_AntiSpamPlayer:GetFullName()
	return self.name;
end;

function MrtWoo_AntiSpamPlayer:GetShortName()
	local n, s = strmatch(self.name, "^([^-]+)-(.*)");
	return n;
end;

function MrtWoo_AntiSpamPlayer:GetName()
	local n, s = strmatch(self.name, "^([^-]+)-(.*)");
	if (s ~= MrtWoo.MyRealm) then
		return self.name;
	end;
	return n;
end;

function MrtWoo_AntiSpamPlayer:Block()
	self.is_block = true;
end;

function MrtWoo_AntiSpamPlayer:UnBlock()
	self.is_block = false;
end;

function MrtWoo_AntiSpamPlayer:IsBlock()
	return self.is_block == true;
end;

function MrtWoo_AntiSpamPlayer:Lock()
	self.is_lock = true;
end;

function MrtWoo_AntiSpamPlayer:UnLock()
	self.is_lock = false;
end;

function MrtWoo_AntiSpamPlayer:IsLock()
	return self.is_lock == true;
end;

function MrtWoo_AntiSpamPlayer:Spammer()
	self.is_spammer = true;
end;

function MrtWoo_AntiSpamPlayer:IsSpammer()
	return self.is_spammer;
end;

function MrtWoo_AntiSpamPlayer:SetInfo(value)
	self.info = value;
end;

function MrtWoo_AntiSpamPlayer:GetInfo()
	return self.info;
end;

function MrtWoo_AntiSpamPlayer:GetMessages()
	return self.messages;
end;