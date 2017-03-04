--[[
$Id: CurrencyTracking_Options.lua 50 2017-03-01 16:00:24Z arith $
]]
local _G = getfenv(0)
-- Libraries
local math = _G.math;

local CurrencyTracking_Player = UnitName("player");
local CurrencyTracking_Server = GetRealmName();

local LibStub = _G.LibStub;
local L = LibStub("AceLocale-3.0"):GetLocale("CurrencyTracking");

local myaddon = {};

function CurrencyTrackingOptions_Toggle()
	if(InterfaceOptionsFrame:IsVisible()) then
		InterfaceOptionsFrame:Hide();
	else
		InterfaceOptionsFrame_OpenToCategory(L["CT_TITLE"]);
		InterfaceOptionsFrame_OpenToCategory(L["CT_CAT_TRACKED_CURRENCY"]);
	end
end

function CurrencyTrackingOptions_OnLoad(self)
	UIPanelWindows['CurrencyTrackingOptionsFrame'] = {area = 'center', pushable = 0};
	
	myaddon.panel = self;
	
	myaddon.panel.name = L["CT_TITLE"];
	InterfaceOptions_AddCategory(myaddon.panel);
end

function CurrencyTrackingOptions_OnShow()
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	CurrencyTrackingOptionsFrame_ShowOnScreen:SetChecked(options.show_currency);
	CurrencyTrackingOptionsFrame_BreakupNumbers:SetChecked(options.breakupnumbers);
	CurrencyTrackingOptionsFrameSliderFrameScale:SetValue(options.scale);
	CurrencyTrackingOptionsFrameSliderFrameAlpha:SetValue(options.alpha);
	CurrencyTrackingOptionsFrameSliderFrameBGAlpha:SetValue(options.bgalpha);
	CurrencyTrackingOptionsFrameSliderToolTipAlpha:SetValue(options.tooltip_alpha);
	CurrencyTrackingOptionsFrameSliderToolTipScale:SetValue(options.tooltip_scale);
end

function CurrencyTrackingOptions_ShowOnScreenToggle()
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	options.show_currency = not options.show_currency;
	if(options.show_currency) then
		CurrencyTrackingFrame:Show();
	else
		CurrencyTrackingFrame:Hide();
	end
end

function CurrencyTrackingOptions_BreakupNumbersToggle()
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];

	options.breakupnumbers = not options.breakupnumbers;
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

local function CurrencyTrackingOptions_UpdateSlider(self, text)
	_G[self:GetName().."Text"]:SetText("|cffffd200"..text.." ("..round(self:GetValue(), 3)..")");
end

function CurrencyTrackingOptions_SliderFrameScaleOnValueChanged(self)
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	CurrencyTrackingOptions_UpdateSlider(self, CT_OPT_SCALE);
	options.scale = self:GetValue();
	CurrencyTrackingFrame:SetScale(options.scale); 
end

function CurrencyTrackingOptions_SliderFrameAlphaOnValueChanged(self)
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	CurrencyTrackingOptions_UpdateSlider(self, CT_OPT_TRANSPARENCY);
	options.alpha = self:GetValue();
	CurrencyTrackingFrame:SetAlpha(options.alpha); 
end

function CurrencyTrackingOptions_SliderFrameBGAlphaOnValueChanged(self)
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	CurrencyTrackingOptions_UpdateSlider(self, CT_OPT_BGTRANSPARENCY);
	options.bgalpha = self:GetValue();
	CurrencyTrackingFrame.Texture:SetColorTexture(0, 0, 0, options.bgalpha); 
end

function CurrencyTrackingOptions_SliderToolTipAlphaOnValueChanged(self)
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	CurrencyTrackingOptions_UpdateSlider(self, CT_OPT_TOOLTIPTRANSPARENCY);
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

function CurrencyTrackingTokenOptions_OnLoad(self)
	UIPanelWindows['CurrencyTrackingTokenOptionsFrame'] = {area = 'center', pushable = 0};
	
	myaddon.panel2 = self;
	
	myaddon.panel2.name = L["CT_CAT_TRACKED_CURRENCY"];
	myaddon.panel2.parent = myaddon.panel.name;
	InterfaceOptions_AddCategory(myaddon.panel2);
	
	CurrencyTrackingTokenOptionsFrame.TokenContainer.update = CurrencyTrackingTokenContainer_Update;

	if (LibStub:GetLibrary("LibAboutPanel", true)) then
		LibStub("LibAboutPanel").new(L["CT_TITLE"], "CurrencyTracking");
	end
end

function CurrencyTrackingTokenOptions_OnShow()
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];
	
	-- Create buttons if not created yet
	if (not CurrencyTrackingTokenOptionsFrame.TokenContainer.buttons) then
		HybridScrollFrame_CreateButtons(CurrencyTrackingTokenOptionsFrame.TokenContainer, "CurrencyTrackingTokenButtonTemplate", 1, -2, "TOPLEFT", "TOPLEFT", 0, 0);
		local buttons = CurrencyTrackingTokenOptionsFrame.TokenContainer.buttons;
		local numButtons = #buttons;
		for i=1, numButtons do
			if ( math.fmod(i, 2) == 1 ) then
				buttons[i].stripe:Hide();
			end
		end
	end

	-- SetButtonPulse(CharacterFrameTab3, 0, 1);	--Stop the button pulse
	CurrencyTrackingTokenContainer_Update();
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
	
	if (not CurrencyTrackingTokenOptionsFrame.TokenContainer.buttons) then
		return;
	end

	-- Setup the buttons
	local scrollFrame = CurrencyTrackingTokenOptionsFrame.TokenContainer;
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
				if ( count == 0 ) then
					button.count:SetFontObject("GameFontRed");
					--button.name:SetFontObject("GameFontDisable");
					button.name:SetFontObject("GameFontRed");
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
			if ( name == CurrencyTrackingTokenOptionsFrame.TokenContainer.selectedToken ) then
				CurrencyTrackingTokenOptionsFrame.TokenContainer.selectedID = index;
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
		CurrencyTrackingTokenOptionsFrame.TokenContainer.selectedToken = self.name:GetText();
		CurrencyTrackingTokenButton_ToggleTrack(CurrencyTrackingTokenOptionsFrame.TokenContainer.selectedToken);
	end
	CurrencyTrackingTokenContainer_Update();
end

function CurrencyTrackingTokenButton_ToggleTrack(name)
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];

	if (options["currencies"][name] ~= nil) then
		options["currencies"][name] = not options["currencies"][name];
	else
		options["currencies"][name] = false;
	end
end

function CurrencyTracking_SetupTokenOptions(name)
	local options = CurrencyTrackingDB[CurrencyTracking_Server][CurrencyTracking_Player]["options"];

	if (options["currencies"][name] == nil) then
		options["currencies"][name] = false;
	end
end

