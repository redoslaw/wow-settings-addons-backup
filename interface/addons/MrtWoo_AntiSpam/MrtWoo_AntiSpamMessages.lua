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

MrtWoo_AntiSpamMessages = {};

local pairs = pairs;

local strlower = string.lower;
local strformat = string.format;

function MrtWoo_AntiSpamMessages:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;

	o.msg_val = setmetatable({},{__mode="k"});
	o.msg_ids = setmetatable({},{__mode="k"});

	return o;
end;

function MrtWoo_AntiSpamMessages:Add(msgId, msgVal)
	local msg = MrtWoo_AntiSpamMessage:new();

	msg:SetId(msgId);
	msg:SetValue(msgVal);

	msgVal = strlower(strtrim(msgVal));

	if self.msg_val[msgVal] == nil then
		self.msg_val[msgVal] = {t = 0, v = {}};
	end;

	self.msg_val[msgVal].v[msgId] = msgId;
	self.msg_ids[msgId] = msg;

	return msg;
end;

function MrtWoo_AntiSpamMessages:GetMsg(msgId)
	if self.msg_ids[msgId] == nil then
		return nil;
	end;

	return self.msg_ids[msgId];
end;

function MrtWoo_AntiSpamMessages:GetDup(msgVal)
	msgVal = strlower(strtrim(msgVal));
	if self.msg_val[msgVal] == nil then
		return nil;
	end;

	return self.msg_val[msgVal];
end;

function MrtWoo_AntiSpamMessages:SmartClean(lifetime)
	local c_time = GetTime();
	if self.msg_val then
		for k, v in pairs(self.msg_val) do
			local keep = false;
			if v.v and v.t then
				for _, msgId in pairs(v.v) do
					local msg = self.msg_ids[msgId];
					if msg then
						local msgTime = msg:GetTime();
						if not msg:IsSpam() and not msg:IsReported() and ((msgTime < v.t) or (c_time - msgTime > lifetime)) then
							self.msg_ids[msgId] = nil;
							self.msg_val[k].v[msgId] = nil;
							--[[
							if MrtWoo.db.profile.modules.as_debug then
								MrtWoo:Print(strformat('REMOVE self.msg_ids[%i]', msgId));
							end;
							]]
						else
							--[[
							if MrtWoo.db.profile.modules.as_debug then
								MrtWoo:Print(strformat('KEEP self.msg_ids[%i]', msgId));
							end;
							]]
							keep = true;
						end;
					end;
				end;
			end;
			if not keep then
				--[[
				if MrtWoo.db.profile.modules.as_debug then
					MrtWoo:Print(strformat('REMOVE self.msg_val: %s', k));
				end;
				]]
				self.msg_val[k] = nil;
			end;
		end;
	end;
end;



