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

MrtWoo_AntiSpamFilterGUI = {};
MrtWoo_AntiSpamFilterGUI.Words = {};
MrtWoo_AntiSpamFilterGUI.Frame = nil;
MrtWoo_AntiSpamFilterGUI.FrameTree = nil;
MrtWoo_AntiSpamFilterGUI.FrameTreeWidget = nil;
MrtWoo_AntiSpamFilterGUI.SelectedItem = nil;

function MrtWoo_AntiSpamFilterGUI:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self;

	LibStub:GetLibrary('AceEvent-3.0'):Embed(self);

	return o;
end;

local selectedItem = nil;

function MrtWoo_AntiSpamFilterGUI_GroupSelected(widget, event, uniquevalue)
	MrtWoo_AntiSpamFilterGUI:CreateGroupControls(widget);

	widget.editbox_pattern:SetText(uniquevalue);

	local rate = MrtWoo_AntiSpamFilterGUI.Words[uniquevalue];
	if rate ~= nil then
		widget.editbox_rate:SetValue(rate);
	else
		widget.editbox_rate:SetValue(0);
	end;

	MrtWoo_AntiSpamFilterGUI.SelectedItem = uniquevalue;
end

function MrtWoo_AntiSpamFilterGUI:NewItem()
	if not MrtWoo_AntiSpamFilterGUI.FrameTreeWidget then
		return false;
	end;

	MrtWoo_AntiSpamFilterGUI.FrameTreeWidget.editbox_pattern:SetText("");
	MrtWoo_AntiSpamFilterGUI.FrameTreeWidget.editbox_rate:SetValue(0);
	MrtWoo_AntiSpamFilterGUI.SelectedItem = nil;
	MrtWoo_AntiSpamFilterGUI.FrameTree:Select("");
end;

function MrtWoo_AntiSpamFilterGUI:AddItem()
	if not MrtWoo_AntiSpamFilterGUI.FrameTreeWidget then
		return false;
	end;

	local pattern = MrtWoo_AntiSpamFilterGUI.FrameTreeWidget.editbox_pattern:GetText();
	pattern = string.lower(pattern);

	local rate = MrtWoo_AntiSpamFilterGUI.FrameTreeWidget.editbox_rate:GetValue();
	MrtWoo_AntiSpamFilterGUI.Words[pattern] = rate;
	MrtWoo_AntiSpamFilterGUI:RebuildTree();
	MrtWoo_AntiSpamFilterGUI:Select(pattern);
end;

function MrtWoo_AntiSpamFilterGUI:DeleteSelectedItem()
	if MrtWoo_AntiSpamFilterGUI.SelectedItem ~= nil then
		MrtWoo_AntiSpamFilterGUI.Words[MrtWoo_AntiSpamFilterGUI.SelectedItem] = nil;
		MrtWoo_AntiSpamFilterGUI:RebuildTree();
		MrtWoo_AntiSpamFilterGUI:Select(nil);
	end;
end;

function MrtWoo_AntiSpamFilterGUI:UpdateSelectedItem()
	if not MrtWoo_AntiSpamFilterGUI.FrameTreeWidget then
		return false;
	end;

	if MrtWoo_AntiSpamFilterGUI.SelectedItem ~= nil then
		local pattern = MrtWoo_AntiSpamFilterGUI.FrameTreeWidget.editbox_pattern:GetText();
		pattern = string.lower(pattern);

		local rate = MrtWoo_AntiSpamFilterGUI.FrameTreeWidget.editbox_rate:GetValue();

		if pattern ~= MrtWoo_AntiSpamFilterGUI.SelectedItem then
			MrtWoo_AntiSpamFilterGUI.Words[MrtWoo_AntiSpamFilterGUI.SelectedItem] = nil;
		end;

		MrtWoo_AntiSpamFilterGUI.Words[pattern] = rate;
		MrtWoo_AntiSpamFilterGUI:RebuildTree();
		MrtWoo_AntiSpamFilterGUI:Select(pattern);
	end;
end;

function MrtWoo_AntiSpamFilterGUI:CreateGroupControls(widget)
	if not widget then
		return false;
	end;

	if not widget.editbox_pattern then
		widget:ReleaseChildren();
		-- widget:SetLayout("Flow");

		widget.button_new = AceGUI:Create("Button")
		widget.button_new:SetText(L["New"]);
		widget.button_new:SetCallback("OnClick", MrtWoo_AntiSpamFilterGUI.NewItem)
		widget:AddChild(widget.button_new);

		widget.editbox_pattern = AceGUI:Create("EditBox")
		widget.editbox_pattern:SetLabel(L["Pattern:"])
		widget.editbox_pattern:SetText("");
		--widget.editbox_pattern:SetCallback("OnEnterPressed", MrtWoo_AntiSpamFilterGUI.UpdateSelectedItem)
		widget:AddChild(widget.editbox_pattern);

		widget.editbox_rate = AceGUI:Create("Slider")
		widget.editbox_rate:SetSliderValues(-500, 500, 1);
		widget.editbox_rate:SetLabel(L["Rate:"])
		widget.editbox_rate:SetValue(0);
		--widget.editbox_rate:SetCallback("OnValueChanged", MrtWoo_AntiSpamFilterGUI.UpdateSelectedItem)
		widget:AddChild(widget.editbox_rate);

		widget.button_save = AceGUI:Create("Button")
		widget.button_save:SetText(L["Save"]);
		widget.button_save:SetCallback("OnClick", MrtWoo_AntiSpamFilterGUI.UpdateSelectedItem)
		widget:AddChild(widget.button_save);

		--[[
		widget.button_add = AceGUI:Create("Button")
		widget.button_add:SetText(L["Add"]);
		widget.button_add:SetCallback("OnClick", MrtWoo_AntiSpamFilterGUI.AddItem)
		widget:AddChild(widget.button_add);
		]]

		widget.button_delete = AceGUI:Create("Button")
		widget.button_delete:SetText(L["Delete"]);
		widget.button_delete:SetCallback("OnClick", MrtWoo_AntiSpamFilterGUI.DeleteSelectedItem)
		widget:AddChild(widget.button_delete);

		MrtWoo_AntiSpamFilterGUI.FrameTreeWidget = widget;
	end;
end;

function MrtWoo_AntiSpamFilterGUI:RebuildTree()

	if not MrtWoo_AntiSpamFilterGUI.FrameTree then
		return false;
	end;

	local v = setmetatable({},{__mode="k"});

	for word, value in orderedPairs(MrtWoo_AntiSpamFilterGUI.Words) do
		local lwrWord = string.lower(word);
		tinsert(v, {
			text = lwrWord,
			value = lwrWord,
		});
	end;

	MrtWoo_AntiSpamFilterGUI.FrameTree:SetTree(v);
end;

function MrtWoo_AntiSpamFilterGUI:Select(value)

	if not MrtWoo_AntiSpamFilterGUI.FrameTree or not MrtWoo_AntiSpamFilterGUI.Words then
		return false;
	end;

	if not value then
		for k, v in orderedPairs(MrtWoo_AntiSpamFilterGUI.Words) do
			value = string.lower(k);
			break;
		end;
		MrtWoo_AntiSpamFilterGUI.Words.__orderedIndex = nil;
	end;

	if not value then
		return false;
	end;

	MrtWoo_AntiSpamFilterGUI.FrameTree:SelectByValue(value);
end;

function MrtWoo_AntiSpamFilterGUI:CreateFrame()

	if not MrtWoo_AntiSpamFilterGUI.Frame then
		local frame = AceGUI:Create("Frame");
		frame:Hide();
		frame:SetTitle(L["Patterns Editor"])
		frame:SetStatusText("...")
		frame:SetLayout("Flow");
		frame:SetCallback("OnClose",function()
			self:SendMessage('MRTWOO_ASGUI_ONCLOSE');
		end)
		frame:SetWidth(435);

		local tree = AceGUI:Create("TreeGroup");
		tree:SetCallback("OnGroupSelected", MrtWoo_AntiSpamFilterGUI_GroupSelected)
		tree:SetFullHeight(true);
		tree:SetFullWidth(true);

		frame:AddChild(tree);

		MrtWoo_AntiSpamFilterGUI.Frame = frame;
		MrtWoo_AntiSpamFilterGUI.FrameTree = tree;
	end;

end;

function MrtWoo_AntiSpamFilterGUI:Show()

	if not MrtWoo_AntiSpamFilterGUI.Frame then
		return false;
	end;

	MrtWoo_AntiSpamFilterGUI.Words = setmetatable({},{__mode="k"});

	for word, value in pairs(MrtWoo_AntiSpamFilter.Words) do
		local lwrWord = string.lower(word);
		MrtWoo_AntiSpamFilterGUI.Words[lwrWord] = value;
	end;

	MrtWoo_AntiSpamFilterGUI.Frame:Show();
	MrtWoo_AntiSpamFilterGUI:RebuildTree();
	MrtWoo_AntiSpamFilterGUI:Select(nil);

end;

function MrtWoo_AntiSpamFilterGUI:Hide()

	if not MrtWoo_AntiSpamFilterGUI.Frame then
		return false;
	end;

	MrtWoo_AntiSpamFilterGUI.Frame:Hide();

end;

function MrtWoo_AntiSpamFilterGUI:Serialize()
	local AceSerializer = LibStub("AceSerializer-3.0");
	return AceSerializer:Serialize(MrtWoo_AntiSpamFilter.Words);
end;
