--------------------------------
-- Coded by: Exzu / EU-Aszune --
--------------------------------
--   INTERFACE CONFIG FRAME   --
--------------------------------
SS_TankTexture = "Interface\\Addons\\SatchelScanner\\textures\\tank.tga";
SS_HealTexture = "Interface\\Addons\\SatchelScanner\\textures\\healer.tga";
SS_DpsTexture = "Interface\\Addons\\SatchelScanner\\textures\\dps.tga";

SS_newsTable = {
	SS_mythicDungeonNews = { text = "Seems Scrapped.", loc = "TOPLEFT", x = 20, y = -4, anchor = "SS_mythicDungeonBox3"},
	SS_LFR1News = { text = "Release: March 7", loc = "TOPLEFT", x = 20, y = -4, anchor = "SS_BetrayersRiseBox3"},
	SS_LFR2News = { text = "Release: Patch 7.2", loc = "TOPLEFT", x = 20, y = -4, anchor = "SS_TidestonesRestBox3"},
	SS_LFR3News = { text = "Release: Patch 7.2", loc = "TOPLEFT", x = 20, y = -4, anchor = "SS_WailingHallsBox3"},
	SS_LFR4News = { text = "Release: Patch 7.2", loc = "TOPLEFT", x = 20, y = -4, anchor = "SS_ChamberAvatarBox3"},
	SS_LFR5News = { text = "Release: Patch 7.2", loc = "TOPLEFT", x = 20, y = -4, anchor = "SS_DeceiversFallBox3"},
};

SS_optionsTable2 = {
	SS_ScannerMain = {
		SS_aboutHeader = { loc = "TOP", x = 0, y = -5, fontSize = 28, text = "|cFF0080FFSatchel Scanner|r"},
		SS_aboutSubHeader = { loc = "TOP", x = 0, y = -30, fontSize = 14, text = "Created by Exzu-Aszune"},
		SS_aboutText1 = { loc = "TOP", x = 0, y = -55, fontSize = 24, text = "|cffff0000Questions and Answers|r"},
		SS_aboutQ1 = { loc = "TOPLEFT", x = 10, y = -84, fontSize = 16, text = "|cFF0080FFQ: Why does it list an satchel as available when there's nothing shown in the LFG window?|r"},
		SS_aboutA1 = { loc = "TOPLEFT", x = 10, y = -100, fontSize = 16, text = "A: This may be because your in a group. You will have to leave your group to view available rewards."},
		SS_aboutQ2 = { loc = "TOPLEFT", x = 10, y = -124, fontSize = 16, text = "|cFF0080FFQ: Can you really recieve an satchel as DPS?|r"},
		SS_aboutA2 = { loc = "TOPLEFT", x = 10, y = -140, fontSize = 16, text = "A: Yes. It may be uncommon, but it does exist."},
		SS_aboutQ3 = { loc = "TOPLEFT", x = 10, y = -164, fontSize = 16, text = "|cFF0080FFQ: I'm having an odd issue that only seems to be occuring for me, solution?|r"},
		SS_aboutA3	= { loc = "TOPLEFT", x = 10, y = -180, fontSize = 16, text = "A: Try using '/ss3 reset' to reset all options to default."},
		SS_aboutQ4 = { loc = "TOPLEFT", x = 10, y = -204, fontSize = 16, text = "|cFF0080FFQ: Will you add the option to Auto-Queue when an Satchel is available?|r"},
		SS_aboutA4 = { loc = "TOPLEFT", x = 10, y = -220, fontSize = 16, text = "A: No, this will never happen."},
		SS_aboutTexture1 = { loc = "TOP", x = 0, y = -80, width = "0" , height = "2", texture = SS_Spacer},
		SS_aboutTexture2 = { loc = "TOP", x = 0, y = -120, width = "0" , height = "2", texture = SS_Spacer},
		SS_aboutTexture3 = { loc = "TOP", x = 0, y = -160, width = "0" , height = "2", texture = SS_Spacer},
		SS_aboutTexture4 = { loc = "TOP", x = 0, y = -200, width = "0" , height = "2", texture = SS_Spacer},
		SS_aboutTexture5 = { loc = "TOP", x = 0, y = -240, width = "0" , height = "2", texture = SS_Spacer},
	};
	SS_ScannerOptions = {
		SS_optionsTextHeader = { fontSize = 24, loc = "TOP", x = 0, y = -5, text = "|cFF0080FFSatchel Scanner|r"},
		SS_optionsTextSubHeader = { fontSize = 18, loc = "TOP", x = 0, y = -25, text = "|cffff0000Scanner Options|r"},
		SS_optionTexFrame1 = { loc = "TOP", x = 0, y = -45, width = "0" , height = "2", texture = SS_Spacer},
		-- Scan related stuff
		SS_optionText1 = { fontSize = 16, loc = "TOPLEFT", x = 10, y = -50, text = "|cffff0000Scan Options|r"},
		SS_optionText2 = { fontSize = 14, loc = "TOPLEFT", x = 30, y = -70, text = "Scan while in a Instance"},
		SS_optionText3 = { fontSize = 14, loc = "TOPLEFT", x = 30, y = -90, text = "Scan while in a Group"},
		SS_scanInDungeonButton = { loc = "TOPLEFT", x = 8, y = -65},
		SS_scanInGroupButton = { loc = "TOPLEFT", x = 8, y = -85},
		-- Slider
		SS_sliderText1 = { loc = "TOPLEFT", x = 145, y = -132, fontSize = 16, text = ""},
		SS_sliderText2 = { loc = "TOPLEFT", x = 10, y = -115, fontSize = 14, text = "Scan Interval in Seconds"},
		SS_ScannerIntervalSlider = { loc = "TOPLEFT", x = 10, y = -130, width = 130, height = 20, minMax = {3, 30}, valueStep = 1, func = "SS_sliderText1:SetText(SS_ScannerIntervalSlider:GetValue())"},
		-- Notification related stuff
		SS_optionText4 = { loc = "TOPLEFT", x = 10, y = -170, fontSize = 16, text = "|cffff0000Notification Options|r"},
		SS_optionText5 = { loc = "TOPLEFT", x = 30, y = -190, fontSize = 14, text = "Play Soundwarning"},
		SS_optionText6 = { loc = "TOPLEFT", x = 30, y = -210, fontSize = 14, text = "Show Raidwarning"},
		SS_playSoundButton = { loc = "TOPLEFT", x = 8, y = -185},
		SS_raidWarningButton = { loc = "TOPLEFT", x = 8, y = -205},
		-- Slider
		SS_NotificationIntervalSlider = { loc = "TOPLEFT", x = 10, y = -250, width = 130, height = 20, minMax = {3, 30}, valueStep = 1, func = "SS_sliderText3:SetText(SS_NotificationIntervalSlider:GetValue())"},
		SS_sliderText3 = { loc = "TOPLEFT", x = 145, y = -252, fontSize = 16, text = ""},
		SS_sliderText4 = { loc = "TOPLEFT", x = 10, y = -235, fontSize = 14, text = "Notification Interval in Seconds"},
	};
	SS_ScannerInstances = {
		SS_spacer6 = { loc = "TOP", x = 0, y = -45, isSpacer = true, isIcon = true, width = "0" , height = "2", texture = SS_Spacer},
		SS_spacer7 = { loc = "TOP", x = 0, y = -130, isSpacer = true, isIcon = true, width = "0" , height = "2", texture = SS_Spacer},
		SS_spacer8 = { loc = "TOP", x = 0, y = -215, isSpacer = true, isIcon = true, width = "0" , height = "2", texture = SS_Spacer},
		SS_spacer9 = { loc = "TOP", x = 0, y = -320, isSpacer = true, isIcon = true, width = "0" , height = "2", texture = SS_Spacer},
		SS_spacer10 = { loc = "TOP", x = 0, y = -425, isSpacer = true, isIcon = true, width = "0" , height = "2", texture = SS_Spacer},
		SS_instanceHeader = { isText = true, fontSize = 24, loc = "TOP", x = 0, y = -5, text = "|cFF0080FFSatchel Scanner|r"},
		SS_instanceSubHeader = { isText = true, fontSize = 18, loc = "TOP", x = 0, y = -25, text = "|cffff0000Instance Options|r"},
		SS_tankIconText = { text = "Tank", loc = "TOP", x = -148, y = -110, isText = true, fontSize = 14},
		SS_healIconText = { text = "Heal", loc = "TOP", x = 2, y = -110, isText = true, fontSize = 14},
		SS_dpsIconText = { text = "Dps", loc = "TOP", x = 152, y = -110, isText = true, fontSize = 14},
		SS_tankBigIcon = { loc = "TOP", x = -150, y = -50, isIcon = true, width = "64", height = "64", texture = SS_TankTexture},
		SS_healBigIcon = { loc = "TOP", x = 0, y = -50, isIcon = true, width = "64", height = "64", texture = SS_HealTexture},
		SS_dpsBigIcon = { loc = "TOP", x = 150, y = -50, isIcon = true, width = "64", height = "64", texture = SS_DpsTexture},
		-- Dungeons
		SS_randomDungeons = { text = "|cffff0000Random Dungeons|r", loc = "TOP", x = 0, y = -136, isText = true, fontSize = 14},
		SS_heroicDungeon = { text = "Heroic Dungeons:", loc = "TOPLEFT", x = 10, y = -155, isText = true, fontSize = 14},
		SS_mythicDungeon = { text = "Mythic Dungeons:", loc = "TOPLEFT", x = 10, y = -175, isText = true, fontSize = 14},
		SS_timewalkingDungeon = { text = "Timewalking:", loc = "TOPLEFT", x = 10, y = -195, isText = true, fontSize = 14},
		SS_heroicDungeonBox1 = { loc = "TOP", x = -150, y = -150},
		SS_heroicDungeonBox2 = { loc = "TOP", x = 0, y = -150},
		SS_heroicDungeonBox3 = { loc = "TOP", x = 150, y = -150},
		SS_mythicDungeonBox1 = { locked = true; loc = "TOP", x = -150, y = -170},
		SS_mythicDungeonBox2 = { locked = true; loc = "TOP", x = 0, y = -170},
		SS_mythicDungeonBox3 = { locked = true; loc = "TOP", x = 150, y = -170},
		SS_timewalkingDungeonBox1 = { loc = "TOP", x = -150, y = -190},
		SS_timewalkingDungeonBox2 = { loc = "TOP", x = 0, y = -190},
		SS_timewalkingDungeonBox3 = { loc = "TOP", x = 150, y = -190},
		-- Emerald Nightmare, ToV
		SS_EmeraldNightmareLFR = { text = "|cffff0000Emerald Nightmare & Trial of Valor|r", loc = "TOP", x = 0, y = -221, isText = true, fontSize = 14},
		SS_Darkbough = { text = "Darkbough:", loc = "TOPLEFT", x = 10, y = -240, isText = true, fontSize = 14},
		SS_TormentedGuardians = { text = "Tormented Guardians:", loc = "TOPLEFT", x = 10, y = -260, isText = true, fontSize = 14},
		SS_RiftofAln = { text = "Rift of Aln:", loc = "TOPLEFT", x = 10, y = -280, isText = true, fontSize = 14},
		SS_TrialofValor = { text = "Trial of Valor:", loc = "TOPLEFT", x = 10, y = -300, isText = true, fontSize = 14},
		SS_DarkboughBox1 = { loc = "TOP", x = -150, y = -235},
		SS_DarkboughBox2 = { loc = "TOP", x = 0, y = -235},
		SS_DarkboughBox3 = { loc = "TOP", x = 150, y = -235},
		SS_TormentedGuardiansBox1 = { loc = "TOP", x = -150, y = -255},
		SS_TormentedGuardiansBox2 = { loc = "TOP", x = 0, y = -255},
		SS_TormentedGuardiansBox3 = { loc = "TOP", x = 150, y = -255},
		SS_RiftofAlnBox1 = { loc = "TOP", x = -150, y = -275},
		SS_RiftofAlnBox2 = { loc = "TOP", x = 0, y = -275},
		SS_RiftofAlnBox3 = { loc = "TOP", x = 150, y = -275},
		SS_TrialofValorBox1 = { loc = "TOP", x = -150, y = -295},
		SS_TrialofValorBox2 = { loc = "TOP", x = 0, y = -295},
		SS_TrialofValorBox3 = { loc = "TOP", x = 150, y = -295},
		-- Nighthold
		SS_NightholdLFR = { text = "|cffff0000Looking for Raid: Nighthold|r", loc = "TOP", x = 0, y = -326, isText = true, fontSize = 14},
		SS_ArcingAqueducts = { text = "Arcing Aqueducts:", loc = "TOPLEFT", x = 10, y = -345, isText = true, fontSize = 14},
		SS_RoyalAthenaeum = { text = "Royal Athenaeum:", loc = "TOPLEFT", x = 10, y = -365, isText = true, fontSize = 14},
		SS_Nightspire = { text = "Nightspire:", loc = "TOPLEFT", x = 10, y = -385, isText = true, fontSize = 14},
		SS_BetrayersRise = { text = "Betrayer's Rise:", loc = "TOPLEFT", x = 10, y = -405, isText = true, fontSize = 14},
		SS_ArcingAqueductsBox1 = { loc = "TOP", x = -150, y = -340},
		SS_ArcingAqueductsBox2 = { loc = "TOP", x = 0, y = -340},
		SS_ArcingAqueductsBox3 = { loc = "TOP", x = 150, y = -340},
		SS_RoyalAthenaeumBox1 = { loc = "TOP", x = -150, y = -360},
		SS_RoyalAthenaeumBox2 = { loc = "TOP", x = 0, y = -360},
		SS_RoyalAthenaeumBox3 = { loc = "TOP", x = 150, y = -360},
		SS_NightspireBox1 = { loc = "TOP", x = -150, y = -380},
		SS_NightspireBox2 = { loc = "TOP", x = 0, y = -380},
		SS_NightspireBox3 = { loc = "TOP", x = 150, y = -380},
		SS_BetrayersRiseBox1 = { locked = true; loc = "TOP", x = -150, y = -400},
		SS_BetrayersRiseBox2 = { locked = true; loc = "TOP", x = 0, y = -400},
		SS_BetrayersRiseBox3 = { locked = true; loc = "TOP", x = 150, y = -400},
		-- Tomb of Sargeras
		SS_TombofSargerasLFR = { text = "|cffff0000Tomb of Sargeras!|r", loc = "TOP", x = 0, y = -431, isText = true, fontSize = 14},
		SS_TidestonesRest = { text = "The Tidestone's Rest:", loc = "TOPLEFT", x = 10, y = -450, isText = true, fontSize = 14},
		SS_WailingHallsRest = { text = "Wailing Halls:", loc = "TOPLEFT", x = 10, y = -470, isText = true, fontSize = 14},
		SS_ChamberAvatarRest = { text = "Chamber of the Avatar:", loc = "TOPLEFT", x = 10, y = -490, isText = true, fontSize = 14},
		SS_DeceiversFallRest = { text = "Deveiver's Fall:", loc = "TOPLEFT", x = 10, y = -510, isText = true, fontSize = 14},
		SS_TidestonesRestBox1 = { locked = true; loc = "TOP", x = -150, y = -445},
		SS_TidestonesRestBox2 = { locked = true; loc = "TOP", x = 0, y = -445},
		SS_TidestonesRestBox3 = { locked = true; loc = "TOP", x = 150, y = -445},	
		SS_WailingHallsBox1 = { locked = true; loc = "TOP", x = -150, y = -465},
		SS_WailingHallsBox2 = { locked = true; loc = "TOP", x = 0, y = -465},
		SS_WailingHallsBox3 = { locked = true; loc = "TOP", x = 150, y = -465},
		SS_ChamberAvatarBox1 = { locked = true; loc = "TOP", x = -150, y = -485},
		SS_ChamberAvatarBox2 = { locked = true; loc = "TOP", x = 0, y = -485},
		SS_ChamberAvatarBox3 = { locked = true; loc = "TOP", x = 150, y = -485},
		SS_DeceiversFallBox1 = { locked = true; loc = "TOP", x = -150, y = -505},
		SS_DeceiversFallBox2 = { locked = true; loc = "TOP", x = 0, y = -505},
		SS_DeceiversFallBox3 = { locked = true; loc = "TOP", x = 150, y = -505},
	};
};	

SS_optionsPanelBackdrop = { 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
----------------------------
-- ADDONS/INTERFACE PANEL --
----------------------------
function SS_interfaceConfig()
    --------------------------
    -- Main Panel About/FAQ --
	--------------------------
	SS_Options = {};
	SS_Options.panel = CreateFrame("Frame", "SatchelScannerPanel", UIParent);
	SS_Options.panel.name = "Satchel Scanner";
	SS_Options.panel.okay = function(self) SS_datacall("update"); SS_stopScanning(); updateFrames(); end;
	SS_Options.panel:SetBackdrop(SS_optionsPanelBackdrop);
	SS_Options.panel:SetBackdropColor(0, 0, 0, 0.8);
	InterfaceOptions_AddCategory(SS_Options.panel);
	-- Options
	SS_Options.childpanel = CreateFrame("Frame", "SatchelScannerOptions", SS_Options.panel);
	SS_Options.childpanel.name = "Options";
	SS_Options.childpanel.parent = SS_Options.panel.name;
	SS_Options.childpanel:SetBackdrop(SS_optionsPanelBackdrop);
	SS_Options.childpanel:SetBackdropColor(0, 0, 0, 0.8);
	InterfaceOptions_AddCategory(SS_Options.childpanel);
	-- Instances
	SS_Options.childpanel2 = CreateFrame("Frame", "SatchelScannerInstances", SS_Options.panel);
	SS_Options.childpanel2.name = "Instances";
	SS_Options.childpanel2.parent = SS_Options.panel.name;
	SS_Options.childpanel2:SetBackdrop(SS_optionsPanelBackdrop);
	SS_Options.childpanel2:SetBackdropColor(0, 0, 0, 0.8);
	InterfaceOptions_AddCategory(SS_Options.childpanel2);
	for j, var in pairs(SS_optionsTable2) do
		for i, tVar in pairs(var) do
			if j == "SS_ScannerMain" then
				if tVar.text then
					_G[i] = SS_Options.panel:CreateFontString(nil, "OVERLAY")
					_G[i]:SetFont(SS_preFont, tVar.fontSize, "OUTLINE");
					_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
					_G[i]:SetText(tVar.text);
				elseif tVar.texture then
					_G[i] = CreateFrame("Button", nil, SS_Options.panel);
					_G[i]:SetWidth(tVar.width);
					_G[i]:SetHeight(tVar.height);
					_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
					_G[i]:SetNormalTexture(tVar.texture)
					_G[i]:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth() - 20);
					_G[i]:SetAlpha(0.5);
				end
			elseif j == "SS_ScannerOptions" then
				if string.find(i, "Text") then
					_G[i] = SS_Options.childpanel:CreateFontString(nil, "OVERLAY")
					_G[i]:SetFont(SS_preFont, tVar.fontSize, "OUTLINE");
					_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
					_G[i]:SetText(tVar.text);
				elseif string.find(i, "Button") then	
					_G[i] = CreateFrame("CheckButton", nil, SS_Options.childpanel, "ChatConfigCheckButtonTemplate");
					_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
					_G[i]:SetHitRectInsets(0, 0, 0, 0);
				elseif string.find(i, "Slider") then
					_G[i] = CreateFrame("Slider", nil, SS_Options.childpanel, "OptionsSliderTemplate")
					_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
					_G[i]:SetWidth(tVar.width);
					_G[i]:SetHeight(tVar.height);
					_G[i]:SetOrientation('HORIZONTAL');
					_G[i]:SetMinMaxValues(unpack(tVar.minMax));
					_G[i]:SetValueStep(tVar.valueStep);
					_G[i]:SetObeyStepOnDrag(true);
					_G[i]:SetScript("OnValueChanged", loadstring(tVar.func));
					_G[i]:Show();
				elseif string.find(i, "TexFrame") then
					_G[i] = CreateFrame("Button", nil, SS_Options.childpanel);
					_G[i]:SetWidth(tVar.width);
					_G[i]:SetHeight(tVar.height);
					_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
					_G[i]:SetNormalTexture(tVar.texture)
					_G[i]:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth() - 20);
					_G[i]:SetAlpha(0.5);
				end
			elseif j == "SS_ScannerInstances" then
				if string.find(i, "Box") then	
					_G[i] = CreateFrame("CheckButton", nil, SS_Options.childpanel2, "ChatConfigCheckButtonTemplate");
					_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
					_G[i]:SetHitRectInsets(0, 0, 0, 0);
					if tVar.locked then
						_G[i]:SetAlpha(0.3);
						_G[i]:Disable();
					end
				elseif tVar.isText then
					_G[i] = SS_Options.childpanel2:CreateFontString(nil, "OVERLAY")
					_G[i]:SetFont(SS_preFont, tVar.fontSize, "OUTLINE");
					_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
					_G[i]:SetText(tVar.text);
				elseif tVar.isIcon then
					_G[i] = CreateFrame("Button", nil, SS_Options.childpanel2);
					_G[i]:SetWidth(tVar.width);
					_G[i]:SetHeight(tVar.height);
					_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
					_G[i]:SetNormalTexture(tVar.texture);
					if tVar.isSpacer then
						_G[i]:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth() - 20);
						_G[i]:SetAlpha(0.5);
					end
				end
			end
		end
	end
	for i, tVar in pairs(SS_newsTable) do
		_G[i] = _G[tVar.anchor]:CreateFontString(nil, "OVERLAY")
		_G[i]:SetFont(SS_preFont, 14, "OUTLINE");
		_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
		_G[i]:SetText(tVar.text);
	end
	drawFrames();
end

