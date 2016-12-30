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

local L = LibStub("AceLocale-3.0"):GetLocale("MrtWoo_AntiSpam", true);
local AceGUI = LibStub("AceGUI-3.0");

MrtWoo_AntiSpamBlockListGUI = {};
MrtWoo_AntiSpamBlockListGUI.Frame = nil;
MrtWoo_AntiSpamBlockListGUI.FrameTree = nil;
MrtWoo_AntiSpamBlockListGUI.FrameTreeWidget = nil;
MrtWoo_AntiSpamBlockListGUI.SelectedItem = nil;

function MrtWoo_AntiSpamBlockListGUI:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self;

	LibStub:GetLibrary('AceEvent-3.0'):Embed(self);

	return o;
end;

MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = nil;

function MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, text, index)
	local btn = AceGUI:Create("Dropdown-Item-Execute");
	btn.SetValue = function() end
	btn:SetText( text );
	btn:SetCallback("OnClick", function(btn)
		  widget.dropdown_lifetime:SetText(btn:GetText())
		  widget.dropdown_lifetime.pullout:Close();
		  MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = index;
	end)
	return btn;
end;

function MrtWoo_AntiSpamBlockListGUI:CreateGroupControls(widget)
	if not widget then
		return false;
	end;

	if not widget.editbox_player then
		widget:ReleaseChildren();
		-- widget:SetLayout("Flow");

		widget.button_new = AceGUI:Create("Button")
		widget.button_new:SetText(L["New player"]);
		widget.button_new:SetCallback("OnClick", MrtWoo_AntiSpamBlockListGUI.NewItem)
		widget:AddChild(widget.button_new);

		widget.editbox_player = AceGUI:Create("EditBox")
		widget.editbox_player:SetLabel(L["Player name:"])
		widget.editbox_player:SetText("");
		--widget.editbox_player:SetCallback("OnEnterPressed", MrtWoo_AntiSpamBlockListGUI.UpdateSelectedItem)
		widget:AddChild(widget.editbox_player);

		widget.dropdown_lifetime = AceGUI:Create("Dropdown")
		widget.dropdown_lifetime:SetLabel(L["Block Interval:"])

		local btn = MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, string.format(L["%s min"], 15), 1);
		widget.dropdown_lifetime.pullout:AddItem(btn);

		btn = MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, string.format(L["%s min"], 30), 2);
		widget.dropdown_lifetime.pullout:AddItem(btn);

		btn = MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, string.format(L["%s min"], 60), 3);
		widget.dropdown_lifetime.pullout:AddItem(btn);

		btn = MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, string.format(L["%s min"], 120), 4);
		widget.dropdown_lifetime.pullout:AddItem(btn);

		btn = MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, string.format(L["%s hours"], 24), 5);
		widget.dropdown_lifetime.pullout:AddItem(btn);

		btn = MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, string.format(L["%s hours"], 48), 6);
		widget.dropdown_lifetime.pullout:AddItem(btn);

		btn = MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, string.format(L["%s days"], 7), 7);
		widget.dropdown_lifetime.pullout:AddItem(btn);

		btn = MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, string.format(L["%s days"], 15), 8);
		widget.dropdown_lifetime.pullout:AddItem(btn);

		btn = MrtWoo_AntiSpamBlockListGUI:DropdownItem(widget, string.format(L["%s days"], 30), 9);
		widget.dropdown_lifetime.pullout:AddItem(btn);

		widget:AddChild(widget.dropdown_lifetime);

		widget.editbox_reason = AceGUI:Create("MultiLineEditBox")
		widget.editbox_reason:SetLabel(L["Reason:"])
		widget.editbox_reason:SetText("");
		widget.editbox_reason:SetNumLines(13);
		--widget.editbox_reason:SetCallback("OnEnterPressed", MrtWoo_AntiSpamBlockListGUI.UpdateSelectedItem)
		widget:AddChild(widget.editbox_reason);

		--[[
		widget.editbox_rate = AceGUI:Create("Slider")
		widget.editbox_rate:SetSliderValues(0, 500, 1);
		widget.editbox_rate:SetLabel(L["Rate:"])
		widget.editbox_rate:SetValue(0);
		--widget.editbox_rate:SetCallback("OnValueChanged", MrtWoo_AntiSpamBlockListGUI.UpdateSelectedItem)
		widget:AddChild(widget.editbox_rate);
		]]

		widget.button_save = AceGUI:Create("Button")
		widget.button_save:SetText(L["Save"]);
		widget.button_save:SetCallback("OnClick", MrtWoo_AntiSpamBlockListGUI.UpdateSelectedItem)
		widget:AddChild(widget.button_save);

		widget.button_delete = AceGUI:Create("Button")
		widget.button_delete:SetText(L["Delete"]);
		widget.button_delete:SetCallback("OnClick", MrtWoo_AntiSpamBlockListGUI.DeleteSelectedItem)
		widget:AddChild(widget.button_delete);

		MrtWoo_AntiSpamBlockListGUI.FrameTreeWidget = widget;
	end;
end;

function MrtWoo_AntiSpamBlockListGUI:NewItem()
	if not MrtWoo_AntiSpamBlockListGUI.FrameTreeWidget then
		return false;
	end;
	MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = nil;
	MrtWoo_AntiSpamBlockListGUI.FrameTreeWidget.editbox_player:SetText("");
	MrtWoo_AntiSpamBlockListGUI.FrameTreeWidget.editbox_reason:SetText("");
	MrtWoo_AntiSpamBlockListGUI.FrameTreeWidget.dropdown_lifetime:SetText("");
	MrtWoo_AntiSpamBlockListGUI.SelectedItem = nil;
	MrtWoo_AntiSpamBlockListGUI.FrameTree:Select("");
end;

function MrtWoo_AntiSpamBlockListGUI:UpdateSelectedItem()
	if not MrtWoo_AntiSpamBlockListGUI.FrameTreeWidget then
		return false;
	end;

	if MrtWoo_AntiSpamBlockListGUI.SelectedItem ~= nil then
		local player = MrtWoo_AntiSpamBlockListGUI.FrameTreeWidget.editbox_player:GetText();

		local reason = MrtWoo_AntiSpamBlockListGUI.FrameTreeWidget.editbox_reason:GetText();

		local lifetime = 60 * 15;
		if (MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex == 1) then
			lifetime = 60 * 15;
		elseif (MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex == 2) then
			lifetime = 60 * 30;
		elseif (MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex == 3) then
			lifetime = 60 * 60;
		elseif (MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex == 4) then
			lifetime = 60 * 120;
		elseif (MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex == 5) then
			lifetime = 86400;
		elseif (MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex == 6) then
			lifetime = 86400 * 2;
		elseif (MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex == 7) then
			lifetime = 86400 * 7;
		elseif (MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex == 8) then
			lifetime = 86400 * 15;
		elseif (MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex == 9) then
			lifetime = 86400 * 30;
		end;

		MrtWoo_AntiSpamBlockList:Block(player, lifetime, reason)

		MrtWoo_AntiSpamBlockListGUI:RebuildTree();
		MrtWoo_AntiSpamBlockListGUI:Select(string.lower(player));
	end;
end;

function MrtWoo_AntiSpamBlockListGUI:DeleteSelectedItem()
	if MrtWoo_AntiSpamBlockListGUI.SelectedItem ~= nil then
		MrtWoo_AntiSpamBlockList.BlockList[MrtWoo_AntiSpamBlockListGUI.SelectedItem] = nil;
		MrtWoo_AntiSpamBlockListGUI:RebuildTree();
		MrtWoo_AntiSpamBlockListGUI:Select(nil);
	end;
end;

function MrtWoo_AntiSpamBlockListGUI_GroupSelected(widget, event, uniquevalue)
	MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = nil;

	MrtWoo_AntiSpamBlockListGUI:CreateGroupControls(widget);

	if uniquevalue == "__orderedindex" then
		MrtWoo_AntiSpamBlockListGUI.SelectedItem = "-- new --";
		return false;
	end;

	widget.editbox_player:SetText(uniquevalue);

	local v = MrtWoo_AntiSpamBlockList.BlockList[uniquevalue];
	if v ~= nil then
		widget.editbox_reason:SetText(v.reason);

		local lifetime = v.lifetime;

		if (lifetime == 60 * 15) then
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 1;
			widget.dropdown_lifetime:SetText(string.format(L["%s min"], 15));
		elseif (lifetime == 60 * 30) then
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 2;
			widget.dropdown_lifetime:SetText(string.format(L["%s min"], 30));
		elseif (lifetime == 60 * 60) then
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 3;
			widget.dropdown_lifetime:SetText(string.format(L["%s min"], 60));
		elseif (lifetime == 60 * 120) then
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 4;
			widget.dropdown_lifetime:SetText(string.format(L["%s min"], 120));
		elseif (lifetime == 86400) then
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 5;
			widget.dropdown_lifetime:SetText(string.format(L["%s hours"], 24));
		elseif (lifetime == 86400 * 2) then
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 6;
			widget.dropdown_lifetime:SetText(string.format(L["%s hours"], 48));
		elseif (lifetime == 86400 * 7) then
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 7;
			widget.dropdown_lifetime:SetText(string.format(L["%s days"], 7));
		elseif (lifetime == 86400 * 15) then
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 8;
			widget.dropdown_lifetime:SetText(string.format(L["%s days"], 15));
		elseif (lifetime == 86400 * 30) then
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 9;
			widget.dropdown_lifetime:SetText(string.format(L["%s days"], 30));
		else
			MrtWoo_AntiSpamBlockListGUI.lifeTimeIndex = 1;
			widget.dropdown_lifetime:SetText(string.format(L["%s min"], 15));
		end;
	end;

	MrtWoo_AntiSpamBlockListGUI.SelectedItem = uniquevalue;
end

function MrtWoo_AntiSpamBlockListGUI:CreateFrame()

	if not MrtWoo_AntiSpamBlockListGUI.Frame then
		local frame = AceGUI:Create("Frame");
		frame:Hide();
		frame:SetTitle(L["BlockList Editor"])
		frame:SetStatusText("...")
		frame:SetLayout("Flow");
		frame:SetCallback("OnClose",function()
			self:SendMessage('MRTWOO_BLGUI_ONCLOSE');
		end)
		frame:SetWidth(435);

		local tree = AceGUI:Create("TreeGroup");
		tree:SetCallback("OnGroupSelected", MrtWoo_AntiSpamBlockListGUI_GroupSelected)
		tree:SetFullHeight(true);
		tree:SetFullWidth(true);

		frame:AddChild(tree);

		MrtWoo_AntiSpamBlockListGUI.Frame = frame;
		MrtWoo_AntiSpamBlockListGUI.FrameTree = tree;
	end;

end;

function MrtWoo_AntiSpamBlockListGUI:Show()

	if not MrtWoo_AntiSpamBlockListGUI.Frame then
		return false;
	end;

	for player, value in pairs(MrtWoo_AntiSpamBlockList.BlockList) do
		local lwrPlayer = string.lower(player);
		local state = MrtWoo_AntiSpamBlockList:IsBlocked(lwrPlayer);
		-- MrtWoo:Print(lwrPlayer, state);
	end;

	MrtWoo_AntiSpamBlockListGUI.Frame:Show();
	MrtWoo_AntiSpamBlockListGUI:RebuildTree();
	MrtWoo_AntiSpamBlockListGUI:Select(nil);

end;

function MrtWoo_AntiSpamBlockListGUI:Select(value)

	if not MrtWoo_AntiSpamBlockListGUI.FrameTree then
		return false;
	end;

	if not value then
		for k, v in orderedPairs(MrtWoo_AntiSpamBlockList.BlockList) do
			value = string.lower(k);
			break;
		end;

		MrtWoo_AntiSpamBlockList.BlockList.__orderedIndex = nil;
	end;

	if not value then
		return false;
	end;

	MrtWoo_AntiSpamBlockListGUI.FrameTree:SelectByValue(value);
end;

function MrtWoo_AntiSpamBlockListGUI:RebuildTree()
	if not MrtWoo_AntiSpamBlockListGUI.FrameTree then
		return false;
	end;

	local v = setmetatable({},{__mode="k"});

	for player, value in orderedPairs(MrtWoo_AntiSpamBlockList.BlockList) do
		local lwrPlayer = string.lower(player);
		tinsert(v, {
			text = lwrPlayer,
			value = lwrPlayer,
		});
	end;

	v.__orderedIndex = nil;
	MrtWoo_AntiSpamBlockListGUI.FrameTree:SetTree(v);
end;