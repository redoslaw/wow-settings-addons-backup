--------------------------------
-- Coded by: Exzu / EU-Aszune --
--------------------------------
--   INTERFACE CONFIG FRAME   --
--------------------------------

function SS_interfaceConfig() -- Draws Config Panel --
	SatchelScannerOptions = {};
	SatchelScannerOptions.panel = CreateFrame("Frame", "SatchelScannerInfo", UIParent );
	SatchelScannerOptions.panel.name = "Satchel Scanner";
	InterfaceOptions_AddCategory(SatchelScannerOptions.panel);

	SatchelScannerOptions.childpanel = CreateFrame("Frame", "SatchelScannerOptionsConfig", SatchelScannerOptions.panel);
	SatchelScannerOptions.childpanel.name = "Options";
	SatchelScannerOptions.childpanel.parent = SatchelScannerOptions.panel.name;
	InterfaceOptions_AddCategory(SatchelScannerOptions.childpanel);
	SatchelScannerOptions.panel.okay = function(self) datacall("update"); end;
	
 	configurationText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	configurationText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 18, "OUTLINE");
	configurationText:SetPoint("TOP", 0, -7);
	configurationText:SetText("Satchel Scanner Configuration!");
	-- Scanner Options
	scanOptionText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	scanOptionText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 16, "OUTLINE");
	scanOptionText:SetPoint("TOPLEFT", 10, -16);
	scanOptionText:SetText("|cffff0000Scanning Options|r");
	-- Tank CheckBox
	scanForTankButton = CreateFrame("CheckButton", nil, SatchelScannerOptions.childpanel, "ChatConfigCheckButtonTemplate");
	scanForTankButton:SetPoint("TOPLEFT", 8, -32);
 	scanForTankText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	scanForTankText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 14, "OUTLINE");
	scanForTankText:SetPoint("TOPLEFT", 30, -36);
	scanForTankText:SetText("Scan for Tank Satchels");
	-- Healer CheckBox
	scanForHealButton = CreateFrame("CheckButton", nil, SatchelScannerOptions.childpanel, "ChatConfigCheckButtonTemplate");
	scanForHealButton:SetPoint("TOPLEFT", 8, -52);
 	scanForHealText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	scanForHealText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 14, "OUTLINE");
	scanForHealText:SetPoint("TOPLEFT", 30, -56);
	scanForHealText:SetText("Scan for Healer Satchels");
	-- Dps CheckBox
 	scanForDpsButton = CreateFrame("CheckButton", nil, SatchelScannerOptions.childpanel, "ChatConfigCheckButtonTemplate");
	scanForDpsButton:SetPoint("TOPLEFT", 8, -72);
 	scanForDpsText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	scanForDpsText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 14, "OUTLINE");
	scanForDpsText:SetPoint("TOPLEFT", 30, -76);
	scanForDpsText:SetText("Scan for Dps Satchels");
	-- Scan while inside an instance
	scanInDungeonButton = CreateFrame("CheckButton", nil, SatchelScannerOptions.childpanel, "ChatConfigCheckButtonTemplate");
	scanInDungeonButton:SetPoint("TOPLEFT", 8, -92);
 	scanInDungeonText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	scanInDungeonText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 14, "OUTLINE");
	scanInDungeonText:SetPoint("TOPLEFT", 30, -96);
	scanInDungeonText:SetText("Scan while in Instance");
	-- Scan while in Group
	scanInGroupButton = CreateFrame("CheckButton", nil, SatchelScannerOptions.childpanel, "ChatConfigCheckButtonTemplate");
	scanInGroupButton:SetPoint("TOPLEFT", 8, -112);
 	scanInGroupText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	scanInGroupText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 14, "OUTLINE");
	scanInGroupText:SetPoint("TOPLEFT", 30, -116);
	scanInGroupText:SetText("Scan while in Group");
	-- Notifications
	scanOption2Text = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	scanOption2Text:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 16, "OUTLINE");
	scanOption2Text:SetPoint("TOPLEFT", 10, -142);
	scanOption2Text:SetText("|cffff0000Notification Options|r");
	-- Sound CheckBox
	playSoundButton = CreateFrame("CheckButton", nil, SatchelScannerOptions.childpanel, "ChatConfigCheckButtonTemplate");
	playSoundButton:SetPoint("TOPLEFT", 8, -158);
 	playSoundText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	playSoundText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 14, "OUTLINE");
	playSoundText:SetPoint("TOPLEFT", 30, -162);
	playSoundText:SetText("Play Soundwarning");
	-- Raidwarning CheckBox
	raidWarningButton = CreateFrame("CheckButton", nil, SatchelScannerOptions.childpanel, "ChatConfigCheckButtonTemplate");
	raidWarningButton:SetPoint("TOPLEFT", 8, -178);
 	raidWarningText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	raidWarningText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 14, "OUTLINE");
	raidWarningText:SetPoint("TOPLEFT", 30, -182);
	raidWarningText:SetText("Show Raidwarning");
	-- Slider for Scanner Interval
	sliderText = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	sliderText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 16, "OUTLINE");
	sliderText:SetPoint("TOPLEFT", 145, -225);
	sliderText2 = SatchelScannerOptions.childpanel:CreateFontString(nil, "OVERLAY")
	sliderText2:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 14, "OUTLINE");
	sliderText2:SetPoint("TOPLEFT", 10, -208);
	sliderText2:SetText("Update Interval in Seconds");
	updateIntervalSlider = CreateFrame("Slider", nil, SatchelScannerOptions.childpanel, "OptionsSliderTemplate")
	updateIntervalSlider:SetPoint("TOPLEFT", 10, -223);
	updateIntervalSlider:SetWidth(130);
	updateIntervalSlider:SetHeight(20);
	updateIntervalSlider:SetOrientation('HORIZONTAL');
	updateIntervalSlider:SetMinMaxValues(3, 15);
	updateIntervalSlider:SetValueStep(1);
	updateIntervalSlider:SetObeyStepOnDrag(true);
	updateIntervalSlider:SetScript("OnValueChanged", function(self) sliderText:SetText(updateIntervalSlider:GetValue()); end)
	updateIntervalSlider:Show();
end
