--[[
$Id: CurrencyTracking_Options.lua 34 2016-12-23 08:35:30Z arith $
]]

local LibStub = _G.LibStub;
local L = LibStub("AceLocale-3.0"):GetLocale("CurrencyTracking");


function CurrencyTrackingOptions_Toggle()
	if(InterfaceOptionsFrame:IsVisible()) then
		InterfaceOptionsFrame:Hide();
	else
		InterfaceOptionsFrame_OpenToCategory(L["TITLE"]);
		-- Yes we have to call this twice
		InterfaceOptionsFrame_OpenToCategory(L["TITLE"]);
	end
end

function CurrencyTrackingOptions_OnLoad(self)
	UIPanelWindows['CurrencyTrackingOptionsFrame'] = {area = 'center', pushable = 0};
	
	self.name = L["TITLE"];
	InterfaceOptions_AddCategory(self);
	if (LibStub:GetLibrary("LibAboutPanel", true)) then
		LibStub("LibAboutPanel").new(L["TITLE"], "CurrencyTracking");
	end
	
	CurrencyTrackingOptionsFrame.TokenContainer.update = CurrencyTrackingTokenContainer_Update;
end

function CurrencyTrackingOptions_OnShow()
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	CurrencyTrackingOptionsFrame_ShowOnScreen:SetChecked(options.show_currency);
	CurrencyTrackingOptionsFrameSliderAlpha:SetValue(options.tooltip_alpha);
	CurrencyTrackingOptionsFrameSliderToolTipScale:SetValue(options.tooltip_scale);

	-- Create buttons if not created yet
	if (not CurrencyTrackingOptionsFrame.TokenContainer.buttons) then
		HybridScrollFrame_CreateButtons(CurrencyTrackingOptionsFrame.TokenContainer, "CurrencyTrackingTokenButtonTemplate", 1, -2, "TOPLEFT", "TOPLEFT", 0, 0);
		local buttons = CurrencyTrackingOptionsFrame.TokenContainer.buttons;
		local numButtons = #buttons;
		for i=1, numButtons do
			if ( mod(i, 2) == 1 ) then
				buttons[i].stripe:Hide();
			end
		end
	end

	-- SetButtonPulse(CharacterFrameTab3, 0, 1);	--Stop the button pulse
	CurrencyTrackingTokenContainer_Update();
end

function CurrencyTrackingOptions_OnHide(self)
	if(MYADDONS_ACTIVE_OPTIONSFRAME == self) then
		ShowUIPanel(myAddOnsFrame);
	end
end

function CurrencyTrackingOptions_ShowOnScreenToggle()
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	if(CurrencyTrackingInfoFrame:IsVisible()) then
		CurrencyTrackingInfoFrame:Hide();
		options.show_currency = false;
	else
		CurrencyTrackingInfoFrame:Show();
		options.show_currency = true;
	end
end

function CurrencyTrackingOptions_ResetPosition()
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];

	CurrencyTrackingFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", 150, -80);
	options.offsetx = 150;
	options.offsety = -80;
end

function CurrencyTrackingOptions_SetupSlider(self, text, mymin, mymax, step)
	self:SetMinMaxValues(mymin, mymax);
	self:SetValueStep(step);
end

local function round(num, idp)
   local mult = 10 ^ (idp or 0);
   return math.floor(num * mult + 0.5) / mult;
end

function CurrencyTrackingOptions_UpdateSlider(self, text)
	_G[self:GetName().."Text"]:SetText("|cffffd200"..text.." ("..round(self:GetValue(), 3)..")");
end

function CurrencyTrackingOptions_SliderAlphaOnValueChanged(self)
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	CurrencyTrackingOptions_UpdateSlider(self, CT_OPT_TRANSPARENCY);
	options.tooltip_alpha = self:GetValue();
end

function CurrencyTrackingOptions_SliderToolTipScaleOnValueChanged(self)
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	CurrencyTrackingOptions_UpdateSlider(self, CT_OPT_TOOLTIPSCALE);
	options.tooltip_scale = self:GetValue();
end

function CurrencyTrackingOptions_OnMouseWheel(self, delta)
	if (delta > 0) then
		self:SetValue(self:GetValue() + self:GetValueStep())
	else
		self:SetValue(self:GetValue() - self:GetValueStep())
	end
end

function CurrencyTracking_PopulateCurrencyList()
	local name, isHeader, isExpanded, isUnused, count, icon, cCount;

	cCount = GetCurrencyListSize();
	for i = 1, cCount do 
		-- // GetCurrencyListInfo() syntax:
		-- // name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(index);
		name, isHeader, isExpanded, isUnused, _, count, icon = GetCurrencyListInfo(i);
		if ( isHeader ) then
			tooltip = tooltip..name.."\n";
		elseif ( (count ~= 0) and not isUnused ) then
			if (icon ~= nil) then
				display = " - "..name.."\t"..BreakUpLargeNumbers(count).." |T"..icon..":16|t"
			end
			-- trace(display)
			tooltip = strconcat(tooltip, display,"|r\n");
		end
	end 

end

function CurrencyTrackingTokenButton_OnLoad(self)
	local name = self:GetName();
	self.count = _G[name.."Count"];
	self.name = _G[name.."Name"];
	self.icon = _G[name.."Icon"];
	self.check = _G[name.."Check"];
	self.expandIcon = _G[name.."ExpandIcon"];
	self.highlight = _G[name.."Highlight"];
	self.stripe = _G[name.."Stripe"];
end

function CurrencyTrackingTokenContainer_Update()
	local numTokenTypes = GetCurrencyListSize();
	
	if (not CurrencyTrackingOptionsFrame.TokenContainer.buttons) then
		return;
	end

	-- Setup the buttons
	local scrollFrame = CurrencyTrackingOptionsFrame.TokenContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local name, isHeader, isExpanded, isUnused, isWatched, count, icon;
	local button, index;
	for i=1, numButtons do
		index = offset+i;
		name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(index);
		button = buttons[i];
		button.check:Hide();
		--button.Select:Hide();
		if ( not name or name == "" ) then
			button:Hide();
		else
			if ( isHeader ) then
				button.categoryLeft:Show();
				button.categoryRight:Show();
				button.categoryMiddle:Show();
				button.expandIcon:Show();
				button.count:SetText("");
				button.icon:SetTexture("");
				if ( isExpanded ) then
					button.expandIcon:SetTexCoord(0.5625, 1, 0, 0.4375);
				else
					button.expandIcon:SetTexCoord(0, 0.4375, 0, 0.4375);
				end
				button.highlight:SetTexture("Interface\\TokenFrame\\UI-TokenFrame-CategoryButton");
				button.highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -2);
				button.highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 2);
				button.name:SetText(name);
				button.name:SetFontObject("GameFontNormal");
				button.name:SetPoint("LEFT", 22, 0);
				button.LinkButton:Hide();
			else
				CurrencyTracking_SetupTokenOptions(name);
				button.categoryLeft:Hide();
				button.categoryRight:Hide();
				button.categoryMiddle:Hide();
				button.expandIcon:Hide();
				button.count:SetText(count);
				button.icon:SetTexture(icon);
				--if ( isWatched ) then
				--	button.check:Show();
				--end
				button.highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
				button.highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
				button.highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0);
				--Gray out the text if the count is 0
				if ( count == 0 ) then
					button.count:SetFontObject("GameFontDisable");
					button.name:SetFontObject("GameFontDisable");
				else
					button.count:SetFontObject("GameFontHighlight");
					button.name:SetFontObject("GameFontHighlight");
				end
				button.name:SetText(name);
				button.name:SetPoint("LEFT", 11, 0);
				button.LinkButton:Show();
				if (CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"]["currencies"][name] == true) then
					button.check:Show();
				end
			end
			--Manage highlight
			if ( name == CurrencyTrackingOptionsFrame.TokenContainer.selectedToken ) then
				CurrencyTrackingOptionsFrame.TokenContainer.selectedID = index;
				button:LockHighlight();
			else
				button:UnlockHighlight();
			end

			button.index = index;
			button.isHeader = isHeader;
			button.isExpanded = isExpanded;
			button.isUnused = isUnused;
			button.isWatched = isWatched;
			button:Show();
		end
	end
	local totalHeight = numTokenTypes * (button:GetHeight()+TOKEN_BUTTON_OFFSET);
	local displayedHeight = #buttons * (button:GetHeight()+TOKEN_BUTTON_OFFSET);

	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

function CurrencyTrackingTokenButton_OnClick(self)
	if ( self.isHeader ) then
		if ( self.isExpanded ) then
			ExpandCurrencyList(self.index, 0);
		else
			ExpandCurrencyList(self.index, 1);
		end
	else
		CurrencyTrackingOptionsFrame.TokenContainer.selectedToken = self.name:GetText();
		CurrencyTrackingTokenButton_ToggleTrack(CurrencyTrackingOptionsFrame.TokenContainer.selectedToken);
	end
	CurrencyTrackingTokenContainer_Update();
end

function CurrencyTrackingTokenButton_ToggleTrack(name)
	if (CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"]["currencies"][name] ~= nil) then
		CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"]["currencies"][name] = not CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"]["currencies"][name];
	else
		CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"]["currencies"][name] = false;
	end
end

function CurrencyTracking_SetupTokenOptions(name)
	if (CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"]["currencies"][name] == nil) then
		CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"]["currencies"][name] = false;
	end
end

