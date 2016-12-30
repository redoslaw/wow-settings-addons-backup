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

local strlower = strlower;

MrtWoo_AntiSpamBlockList = {};

function MrtWoo_AntiSpamBlockList:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;

	if (MrtWoo.db.profile.modules.as_blocklist == false) then
		 MrtWoo.db.profile.modules.as_blocklist = setmetatable({},{__mode="k"});
	end;

	o.BlockList = MrtWoo.db.profile.modules.as_blocklist;--setmetatable({},{__mode="k"});

	self.BlockList = o.BlockList;

	return o;
end;

function MrtWoo_AntiSpamBlockList:Block(player, lifetime, reason)
	-- MrtWoo:Print('== call MrtWoo_AntiSpamBlockList:Block ===');
	if (not player) then
		return false;
	end;

	local _player = strlower(player);
	self.BlockList[_player] = {player = player, time = time(), lifetime = lifetime, reason = reason };

	return true;
end;

function MrtWoo_AntiSpamBlockList:UnBlock(player)
	if (not player) then
		return false;
	end;

	local _player = strlower(player);
	self.BlockList[_player] = nil;

	return true;
end;

function MrtWoo_AntiSpamBlockList:IsBlocked(player)
	if (not player) then
		return false;
	end;

	local _player = strlower(player);
	local _blockInfo = self.BlockList[_player];

	if not _blockInfo then
		return false;
	end;

	local _tNow  = time();

	if (_blockInfo.lifetime > 0) and ((_tNow - _blockInfo.time) > _blockInfo.lifetime) then
		self:UnBlock(_player);
		return false;
	end;

	return true;
end;
