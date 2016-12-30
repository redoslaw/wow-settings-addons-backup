--[[
	MrtWoo_StatusBar: Shows useful information on the status bar
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
local StatusBar = MrtWoo:NewModule("StatusBar", "AceEvent-3.0");
StatusBar.Version = "0.3.14.60100-release2";
local L = LibStub("AceLocale-3.0"):GetLocale("MrtWoo_StatusBar", true);

local opts = {
	sb_options = {
		type="group",
		name=L["StatusBar"],
		args={
			enabled = {
				type = "toggle",
				name = L["Show status bar?"],
				get = function() return MrtWoo.db.profile.modules.sb_enabled end,
				set = function()
					MrtWoo.db.profile.modules.sb_enabled = not MrtWoo.db.profile.modules.sb_enabled
					if (MrtWoo.db.profile.modules.sb_enabled) then
						StatusBar:Show();
					else
						StatusBar:Hide();
					end;
				end,
				order=1,
			},

			exp = {
				type = "toggle",
				name = L["Show experience?"],
				get = function() return MrtWoo.db.profile.modules.sb_exp end,
				set = function() MrtWoo.db.profile.modules.sb_exp = not MrtWoo.db.profile.modules.sb_exp end,
				order=2,
			},

			short = {
				type = "toggle",
				name = L["Experience in the short form (1k..)?"],
				get = function() return MrtWoo.db.profile.modules.sb_exp_short end,
				set = function() MrtWoo.db.profile.modules.sb_exp_short = not MrtWoo.db.profile.modules.sb_exp_short end,
				order=3,
			},

			maxlvl = {
				type = "range",
				max = 100,
				min = 1,
				bigStep = 1,
				step = 1,
				name = L["Maximum gain experience"],
				get = function() return MrtWoo.db.profile.modules.sb_exp_maxlvl end,
				set = function(info, input) MrtWoo.db.profile.modules.sb_exp_maxlvl = input end,
				order=4,
			},

			rep = {
				type = "toggle",
				name = L["Show me a reputation?"],
				get = function() return MrtWoo.db.profile.modules.sb_rep end,
				set = function() MrtWoo.db.profile.modules.sb_rep = not MrtWoo.db.profile.modules.sb_rep end,
				order=5,
			},

			rep_smart = {
				type = "toggle",
				name = L["Show last updatet reputation?"],
				get = function() return MrtWoo.db.profile.modules.sb_rep_smart end,
				set = function() MrtWoo.db.profile.modules.sb_rep_smart = not MrtWoo.db.profile.modules.sb_rep_smart end,
				order=6,
			},

			emblems = {
				type = "toggle",
				name = L["Show me the emblems?"],
				get = function() return MrtWoo.db.profile.modules.sb_emblems end,
				set = function() MrtWoo.db.profile.modules.sb_emblems = not MrtWoo.db.profile.modules.sb_emblems end,
				order=7,
			},

			spaminfo = {
				type = "toggle",
				name = L["Show statistics about the block spam / flood?"],
				get = function() return MrtWoo.db.profile.modules.sb_spaminfo end,
				set = function() MrtWoo.db.profile.modules.sb_spaminfo = not MrtWoo.db.profile.modules.sb_spaminfo end,
				order=8,
			},

			align = {
				values = {L["Top"], L["Bottom"], L["Custom"]},
				type = "select",
				name = L["Position"],
				get = function() return MrtWoo.db.profile.modules.sb_align end,
				set = function(info, input)
						MrtWoo.db.profile.modules.sb_align = input ;
						if MrtWoo.db.profile.modules.sb_align ~= 3 then
							if StatusBar.Wnd:IsMouseEnabled() then
								StatusBar:EnableMouse(false);
							end;
						end;
						StatusBar:UpdateBarPosition();
					end,
				order=9,
			},

			repos = {
				disabled = function(info, input)
					return MrtWoo.db.profile.modules.sb_align ~= 3;
				end;
				type = "execute",
				name = function()
					if not StatusBar.Wnd:IsMouseEnabled() then
						return L["Move"];
					else
						return L["Freeze"];
					end;
				end,
				func = function(info, input)
						local mouseState = StatusBar.Wnd:IsMouseEnabled();
						StatusBar:EnableMouse(not mouseState);
					end,
				order=10,
			},
		},
	}
};

function StatusBar:EnableMouse(enable)
	StatusBar.Wnd:EnableMouse(enable);
	StatusBar.Wnd:SetMovable(enable);
	StatusBar.Wnd:SetResizable(enable);

	if enable then
		StatusBar.Wnd:SetScript("OnMouseDown", function(self, button)
			if button == 'LeftButton' then
				StatusBar.Wnd:StartMoving();
			end;
			if  button == 'RightButton' then
				StatusBar.Wnd:StartSizing();
			end;
		end);

		StatusBar.Wnd:SetScript("OnMouseUp", function(self, button)
		  StatusBar.Wnd:StopMovingOrSizing();
		  MrtWoo.db.profile.modules.sb_pos_x = StatusBar.Wnd:GetLeft();
		  MrtWoo.db.profile.modules.sb_pos_y = StatusBar.Wnd:GetTop();
		  MrtWoo.db.profile.modules.sb_size_w = StatusBar.Wnd:GetWidth();
		  MrtWoo.db.profile.modules.sb_size_h = StatusBar.Wnd:GetHeight();
		end);
	else
		StatusBar.Wnd:SetScript("OnMouseDown", nil);
		StatusBar.Wnd:SetScript("OnMouseUp", nil);
		StatusBar:UpdateBarPosition();
	end;
end;

StatusBar.FACTION_COLORS = {
	[0] = "FFFFFF",
	[1] = "CC4C38",
	[2] = "CC4C38",
	[3] = "BF4300",
	[4] = "E5B200",
	[5] = "009919",
	[6] = "009919",
	[7] = "009919",
	[8] = "009919",
};

StatusBar.UpdateLast = 0; -- sec
StatusBar.UpdateInterval = 2; -- sec

function StatusBar:SetDefaults()
	MrtWoo.defaults.profile.modules.sb_enabled = false;
	MrtWoo.defaults.profile.modules.sb_exp = true;
	MrtWoo.defaults.profile.modules.sb_exp_short = true;
	MrtWoo.defaults.profile.modules.sb_exp_maxlvl = 100;
	MrtWoo.defaults.profile.modules.sb_rep = true;
	MrtWoo.defaults.profile.modules.sb_rep_smart = false;
	MrtWoo.defaults.profile.modules.sb_emblems = true;
	MrtWoo.defaults.profile.modules.sb_spaminfo = false;
	MrtWoo.defaults.profile.modules.sb_align = 1;
	MrtWoo.defaults.profile.modules.sb_pos_x = 300
	MrtWoo.defaults.profile.modules.sb_pos_y = 300;
	MrtWoo.defaults.profile.modules.sb_size_w = 1000;
	MrtWoo.defaults.profile.modules.sb_size_h = 20;
end;

function StatusBar:UpdateBarPosition()
	StatusBar.Wnd:ClearAllPoints();

	if MrtWoo.db.profile.modules.sb_align == 1 then
		StatusBar.Wnd:SetPoint('TOPLEFT', 0, 0);
		StatusBar.Wnd:SetPoint('TOPRIGHT', 0, 0);
		self.Wnd:SetHeight(20);
	elseif MrtWoo.db.profile.modules.sb_align == 2 then
		StatusBar.Wnd:SetPoint('BOTTOMLEFT', 0, 0);
		StatusBar.Wnd:SetPoint('BOTTOMRIGHT', 0, 0);
		self.Wnd:SetHeight(20);
	else
		StatusBar.Wnd:SetPoint(
			'BOTTOMLEFT',
			MrtWoo.db.profile.modules.sb_pos_x,
			MrtWoo.db.profile.modules.sb_pos_y - MrtWoo.db.profile.modules.sb_size_h
		);
		self.Wnd:SetHeight(MrtWoo.db.profile.modules.sb_size_h);
		self.Wnd:SetWidth(MrtWoo.db.profile.modules.sb_size_w);
	end;
end;

function StatusBar:OnInitialize()

	self:SetDefaults();

	self.Wnd = CreateFrame("Frame", "MrtWooStatusBar", UIParent);
	self:Hide();

	self:EnableMouse(false);
	self:UpdateBarPosition();

	--Create Font String
	self.Font = self.Wnd:CreateFontString("MrtWooStatusBarFont", "OVERLAY");
	self.Font:SetFontObject(GameFontNormal);
	self.Font:SetHeight(20);
	self.Font:SetAllPoints(self.Wnd);

	--Create Background
	self.Texture = self.Wnd:CreateTexture("MrtWooStatusBarTexture", "BACKGROUND");
	self.Texture:SetHeight(20);
	self.Texture:SetWidth(2000);
	self.Texture:SetAllPoints(self.Wnd);
	self.Texture:SetTexture(0, 0, 0, 0.5);

	self.Wnd:SetScript("OnUpdate", StatusBar.OnUpdate);

	table.insert(MrtWoo.options.plugins, opts)

	self:RegisterMessage('MRTWOO_ASMON_SMI', StatusBar.UpdateSMI);

	MrtWoo.db.RegisterCallback(self, "OnProfileChanged", StatusBar.ReloadSettings);
	MrtWoo.db.RegisterCallback(self, "OnProfileCopied", StatusBar.ReloadSettings);
	MrtWoo.db.RegisterCallback(self, "OnProfileReset", StatusBar.ReloadSettings);

end;

function StatusBar:ReloadSettings()
	StatusBar:UpdateBarPosition();
end;

StatusBar.SMI_SpamRate = 0;
StatusBar.SMI_FloodRate = 0;
StatusBar.SMI_StrValue = '';

function StatusBar:UpdateSMI(qa, qw, ql, qm, so, sf, ss)
	if qa > 0 then
		local one = 100/qa;
		StatusBar.SMI_SpamRate = one*ss;
		StatusBar.SMI_FloodRate = one*sf;
		StatusBar.SMI_StrValue = string.format("|cffC0FFFFSpam: %.2f%%, Flood: %.2f%%|R", StatusBar.SMI_SpamRate, StatusBar.SMI_FloodRate);
	end;
end;

function StatusBar:GetEmblemsInfo()
	local name, count, icon, header, expanded;
	local info = "";

	for i=1,GetCurrencyListSize(),1 do
		name,header,expanded,_,watched,count,_,icon,_ = GetCurrencyListInfo(i);
		if not header and watched then
			info = info .. ", " .. name..": " .. count;
		end;
	end;

	return string.sub(info, 2);
end;

function StatusBar:IsShowExp()
	return MrtWoo.db.profile.modules.sb_exp;
end;

function StatusBar:IsShowReputation()
	return MrtWoo.db.profile.modules.sb_rep;
end;

function StatusBar:IsShowEmblems()
	return MrtWoo.db.profile.modules.sb_emblems;
end;

function StatusBar:IsExpShort()
	return MrtWoo.db.profile.modules.sb_exp_short;
end;

function StatusBar:IsShowSpamInfo()
	return MrtWoo.db.profile.modules.sb_spaminfo;
end;

function StatusBar:UpdateLevel()
	StatusBar.level = UnitLevel("player");
end;

function StatusBar:IsExpLevel()
	return MrtWoo.db.profile.modules.sb_exp_maxlvl > StatusBar.level;
end;

function StatusBar:GetExperience()
	local self = StatusBar;
	local experience = "";

	self.UpdateLevel();

	if self.IsShowExp() and self.IsExpLevel() then
		local xp = UnitXP("player");
		local mx = UnitXPMax("player");
		local color = "|cffFF00FF ";
		local ender = "|r";
		local xps = xp;
		local mxs = mx;

		if self.IsExpShort() then
			if xp >= 1000 then
				xps = math.floor(xp/1000).."k";
			end

			if mx >= 1000 then
				mxs = math.floor(mx/1000).."k";
			end
		end

		local rested = GetXPExhaustion();
		if rested then
			rested = rested / 2;
			if self.IsExpShort() then
				if rested >= 1000 then
					rested = math.floor(rested / 1000).."k";
				end
			end

			rested = " (+"..rested..")";

			color = "|cff0080FF";
		else
			rested = "";
		end

		local rexp = xps..rested.." / "..mxs;

		local percent  = " ("..math.floor((xp/mx)*100).."%) ";

		experience = color .. "lvl: ".. StatusBar.level .. ", ".. rexp .. percent .. ender ;
	end;

	return experience;

end;

StatusBar.OldFactionInfo = {};
StatusBar.OldFactionIdx = 0;

function StatusBar:GetReputation()
	local self = StatusBar;
	local reputation = "";

	if self.IsShowReputation() then

		if MrtWoo.db.profile.modules.sb_rep_smart then

			-- local oldIdx = self.OldFactionIdx;

			for factionIndex = 1, GetNumFactions() do

			  local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith,
				  canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(factionIndex);

			  if not isHeader then
				  -- MrtWoo:Print(name, self.OldFactionInfo[name], earnedValue);
				  if self.OldFactionInfo[name] ~= nil and self.OldFactionInfo[name] ~= earnedValue then
						-- MrtWoo:Print(name, self.OldFactionInfo[name], earnedValue)
						-- self.OldFactionInfo[name] = earnedValue;
						self.OldFactionIdx = factionIndex;
						--break;
				  elseif isWatched and StatusBar.OldFactionIdx == 0 then
						-- MrtWoo:Print(name, "isWatched")
						self.OldFactionIdx = factionIndex;
				  end;
				  self.OldFactionInfo[name] = earnedValue;
			  end;

			end;

			--[[
			if oldIdx ~= self.OldFactionIdx then
				MrtWoo:Print(self.OldFactionIdx);
			end;
			]]--

		end;

		local name, standing, minrep, maxrep, value = "", 0, 0, 0, 0;

		if not MrtWoo.db.profile.modules.sb_rep_smart or self.OldFactionIdx == 0 then
			name, standing, minrep, maxrep, value = GetWatchedFactionInfo();
		else
			name, _, standing, minrep, maxrep, value, _, _, _, _, _, _, _ = GetFactionInfo(self.OldFactionIdx);
			if minrep == 0 and maxrep == 0 then
				name, standing, minrep, maxrep, value = GetWatchedFactionInfo();
				self.OldFactionIdx = 0;
			end;
		end;

		if name then
			local color = "|cff"..self.FACTION_COLORS[standing];
			local ender = " |r";
			value = value - minrep;
			local limit = maxrep - minrep;
			local fraction = " "..value.." / "..limit;
			local percent  = " ("..math.floor((value/limit)*100).."%) ";
			local stand = "";

			if standing == 1 then
				stand = L["Hated"];
			elseif standing == 2 then
				stand = L["Hostile"];
			elseif standing == 3 then
				stand = L["Unfriendly"];
			elseif standing == 4 then
				stand = L["Nuetral"];
			elseif standing == 5 then
				stand = L["Friendly"] ;
			elseif standing == 6 then
				stand = L["Honored"];
			elseif standing == 7 then
				stand = L["Revered"];
			elseif standing == 8 then
				stand = L["Exalted"];
			else
				stand = L["Unknown"];
			end

			stand = "("..stand..")";

			if (string.len(stand) == 2) then
				stand = "";
			end;

			reputation = color.."\""..name.."\""..fraction..percent..stand..ender;
		end;
	end;
	return reputation;
end;

function StatusBar:OnUpdate(elapsed)
	if (not MrtWoo.db.profile.modules.sb_enabled) then
		return false;
	end;

	-- MrtWoo:Print(elapsed);
	local self = StatusBar;
	self.UpdateLast = self.UpdateLast + elapsed;

	if (self.UpdateLast > self.UpdateInterval) then

		local exp = self.GetExperience();
		local rep = self.GetReputation();

		local txtresult = exp..rep;

		if self.IsShowEmblems() then
			local emblems = self.GetEmblemsInfo();
			if (string.len(txtresult) > 0) and (string.len(emblems ) > 0) then
				emblems = ", "..emblems;
			end;
			txtresult = txtresult..emblems;
		end;

		if self.IsShowSpamInfo() then
			if (string.len(txtresult) > 0) and (string.len(StatusBar.SMI_StrValue) > 0) then
				txtresult = txtresult..', ';
			end;
			txtresult = txtresult..StatusBar.SMI_StrValue;
		end;

		if (string.len(txtresult) <= 0) then
			txtresult = "MrtWoo StatusBar " .. self.Version;
		end;

		self.Font:SetText(txtresult);

		StatusBar.UpdateLast = 0;
	end;
end;

function StatusBar:Show()
	if not self.Wnd:IsVisible() then
		self.Wnd:Show();
	end;
end;

function StatusBar:Hide()
	if self.Wnd:IsVisible() then
		self.Wnd:Hide();
	end;
end;


function StatusBar:OnEnable()
	if (MrtWoo.db.profile.modules.sb_enabled) then
		self:Show();
	end;
end;

function StatusBar:OnDisable()
	self:Hide();
end;
