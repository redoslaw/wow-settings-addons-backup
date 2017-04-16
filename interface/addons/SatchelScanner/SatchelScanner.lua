--------------------------------
-- Coded by: Exzu / EU-Aszune --
--------------------------------
--     MAINFRAME & SCANNER    --
--------------------------------
SS_Spacer = "Interface\\Addons\\SatchelScanner\\textures\\hr.tga";
SS_Border = "Interface\\Addons\\SatchelScanner\\textures\\border.tga";
SS_BagIcon = "Interface\\Addons\\SatchelScanner\\textures\\bagIcon.tga";
SS_TankIcon = "Interface\\Addons\\SatchelScanner\\textures\\tankIcon.tga";
SS_HealerIcon = "Interface\\Addons\\SatchelScanner\\textures\\healerIcon.tga";
SS_DpsIcon = "Interface\\Addons\\SatchelScanner\\textures\\dpsIcon.tga";
SS_StartButton = "Interface\\Buttons\\UI-Panel-Button-Up.blp";
SS_StopButton = "Interface\\Buttons\\UI-Panel-Button-Up.blp";
SS_preFont = "Interface\\Addons\\SatchelScanner\\fonts\\font.TTF";
SS_highlightSmallUI = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp";
SS_hightlightMediumUI = "Interface\\Buttons\\UI-Panel-Button-Highlight.png";
SS_ConfigButtonPush = "Interface\\Addons\\SatchelScanner\\textures\\configpush.tga";
SS_CloseButtonPush = "Interface\\Addons\\SatchelScanner\\textures\\closepush.tga";
SS_ConfigButton = "Interface\\Addons\\SatchelScanner\\textures\\config.tga";
SS_CloseButton = "Interface\\Addons\\SatchelScanner\\textures\\close.tga";

SS_instanceID1 = 1046; -- Heroics
--SS_instanceID2 = 995; -- Timewalking WoTLK
--SS_instanceID2 = 1146; -- Timewalking Cataclysm
SS_instanceID2 = 744; -- Timewalking Burning Crusade
SS_instanceID3 = 1287; -- Darkbough
SS_instanceID4 = 1288; -- Tormented Guardians
SS_instanceID5 = 1289; -- Rift of Aln
SS_instanceID6 = 1411; -- Trial of Valor
SS_instanceID7 = 1290; -- Arcing Aqueducts
SS_instanceID8 = 1291; -- Royal Athenaeum
SS_instanceID9 = 1292; -- Nightspire
SS_instanceID10 = 1293; -- Betrayer's Rise
SS_instanceID11 = 1494; -- The Tidestone's Rest
SS_instanceID12 = 1495; -- Wailing Halls
SS_instanceID13 = 1496; -- Chamber of the Avatar
SS_instanceID14 = 1497; -- Deceiver's Fall

SS_Dungeons = {"Heroic", "Timewalking"}
SS_Raids = {"Darkbough", "Tormented Guardians", "Rift of Aln", "Trial of Valor", "Arcing Aqueducts", "Royal Athenaeum", "Nightspire", "Betrayer's Rise", "The Tidestone's Rest", "Wailing Halls", "Chamber of the Avatar", "Deceiver's Fall"}



--dungeonID, name, typeID, subtype, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionId, groupId, texture, difficultyID, numPlayers, description, isHoliday, bonusRepAmount, minPlayers = GetRFDungeonInfo(index)
--for i = 1, GetNumRFDungeons() do
--  local id, name = GetRFDungeonInfo(i)
--  print(id .. ": " .. name)
--end
--for i = 1, GetNumRandomDungeons() do
--  local id, name = GetLFGRandomDungeonInfo(i)
--  print(id .. ": " .. name)
--end

-- Variables
local running = false; -- Boolean to detect Running/paused state
SS_addonVersion = 7.19; -- Addon Version, useful for wiping savedvariables if needed
SS_versionTag = "Release";
SS_TimeSinceLastNotification = 0;

-- Dungeon Scan Var
SS_runVar = {"Not Running", "Running"};
SS_scanVar = {"#", "# ...", "# Searching...","# Legion Heroic!", "# Timewalking Dungeon!","# Darkbough!","# Tormented Guardians!","# Rift of Aln!","# Trial of Valor!","# Arcing Aqueducts!","# Royal Athenaeum!","# Nightspire!","# Betrayer's Rise!"}
SS_classScan = {"Not Scanning...","Scanning...","Satchel Found!"};
SS_ctaVar = {"Call to Arms: Tank","Call to Arms: Healer","Call to Arms: Dps"};

-- Text Colors
local redColor = {1,0,0,1};
local greenColor = {0,1,0,1};
local yellowColor = {1,1,0,1};
local whiteColor = {1,1,1,1};

SS_masterFrameTable = {
	[1] = {
		[1] = { "Icon", x = 5, texture = SS_TankIcon, },
		[2] = { "Text", x = 22, color = {1, 1, 1, 1}, text = "Tank:", },
		[3] = { "Text2", x = 50, color = {1, 0, 0, 1}, text = "Not Scanning...", },
		[4] = { "SS_heroicDungeonBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID1},
		[5] = { "SS_timewalkingDungeonBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID2},
		[6] = { "SS_DarkboughBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID3},
		[7] = { "SS_TormentedGuardiansBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID4},
		[8] = { "SS_RiftofAlnBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID5},
		[9] = { "SS_TrialofValorBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID6},
		[10] = { "SS_ArcingAqueductsBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID7},
		[11] = { "SS_RoyalAthenaeumBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID8},
		[12] = { "SS_NightspireBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID9},
		[13] = { "SS_BetrayersRiseBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID10},
		[14] = { "SS_TidestonesRestBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID11},
		[15] = { "SS_WailingHallsBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID12},
		[16] = { "SS_ChamberAvatarBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID13},
		[17] = { "SS_DeceiversFallBox1", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID14},
	},
	[2] = {
		[1] = { "Icon", x = 5, texture = SS_HealerIcon, },
		[2] = { "Text", x = 22, color = {1, 1, 1, 1}, text = "Heal:", },
		[3] = { "Text2", x = 49, color = {1, 0, 0, 1}, text = "Not Scanning...", },
		[4] = { "SS_heroicDungeonBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID1},
		[5] = { "SS_timewalkingDungeonBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID2},
		[6] = { "SS_DarkboughBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID3},
		[7] = { "SS_TormentedGuardiansBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID4},
		[8] = { "SS_RiftofAlnBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID5},
		[9] = { "SS_TrialofValorBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID6},
		[10] = { "SS_ArcingAqueductsBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID7},
		[11] = { "SS_RoyalAthenaeumBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID8},
		[12] = { "SS_NightspireBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID9},
		[13] = { "SS_BetrayersRiseBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID10},
		[14] = { "SS_TidestonesRestBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID11},
		[15] = { "SS_WailingHallsBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID12},
		[16] = { "SS_ChamberAvatarBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID13},
		[17] = { "SS_DeceiversFallBox2", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID14},
	},
	[3] = {
		[1] = { "Icon", x = 5, texture = SS_DpsIcon, },
		[2] = { "Text", x = 22, color = {1, 1, 1, 1}, text = "DPS:", },
		[3] = { "Text2", x = 46, color = {1, 0, 0, 1}, text = "Not Scanning...", },
		[4] = { "SS_heroicDungeonBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID1},
		[5] = { "SS_timewalkingDungeonBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID2},
		[6] = { "SS_DarkboughBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID3},
		[7] = { "SS_TormentedGuardiansBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID4},
		[8] = { "SS_RiftofAlnBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID5},
		[9] = { "SS_TrialofValorBox3", x = 5, color = {255, 255, 255, 1}, text = "# ...", id = SS_instanceID6},
		[10] = { "SS_ArcingAqueductsBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID7},
		[11] = { "SS_RoyalAthenaeumBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID8},
		[12] = { "SS_NightspireBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID9},
		[13] = { "SS_BetrayersRiseBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID10},
		[14] = { "SS_TidestonesRestBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID11},
		[15] = { "SS_WailingHallsBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID12},
		[16] = { "SS_ChamberAvatarBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID13},
		[17] = { "SS_DeceiversFallBox3", x = 5, color = {1, 1, 1, 1}, text = "# ...", id = SS_instanceID14},
	},
};

SS_slimFrame = {
	SS_HeaderText = { loc = "TOP", x = 0, y = 8, fontSize = "14", color = {1, 1, 1, 1}, text = "Satchel Scanner", },
	SS_SubHeaderText = { loc = "TOPLEFT", x = 5, y = -5, fontSize = "16", color = {0, 1, 0, 1}, text = "Current Status:", },
	SS_SubHeaderText2 = { loc = "TOPLEFT", x = 95, y = -5, fontSize = "16", color = {1, 0, 0, 1}, text = "Not Running", },
	SS_configButton = { loc = "TOP", x = 97, y = -5, width = "16", height = "16", functionName = "InterfaceOptionsFrame_OpenToCategory(SS_Options.childpanel)", texture = SS_ConfigButton, pushedTxt = SS_ConfigButtonPush, highLightTxt = SS_highlightSmallUI},
	SS_closeButton = { loc = "TOP", x = 115, y = -5, width = "16", height = "16", functionName = "SS_hideMainFrame()", texture = SS_CloseButton, pushedTxt = SS_CloseButtonPush, highLightTxt = SS_highlightSmallUI},
	SS_HeaderSpacertexture = { loc = "TOP", x = 0, y = -23, width = "0" , height = "2", texture = SS_Spacer},
	SS_bagIcontexture = { loc = "TOP", x = 79, y = -5, width = "16", height = "16", texture = SS_BagIcon},
	SS_bagCounterText = { loc = "TOP", x = 60, y = -7, fontSize = "14", color = {0, 0.6, 0.8, 1}, text = "0"},
	SS_startButton = { loc = "BOTTOM", x = -85, y = 5, text = "Start", yscale = 22/32, xscale = 80/130, width = "80", height = "25", functionName = "SS_startScanning()", texture = SS_StartButton, pushedTxt = "Interface\\Buttons\\UI-Panel-Button-Down.blp", highLightTxt = SS_hightlightMediumUI},
	SS_stopButton = { loc = "BOTTOM", x = 85, y = 5, text = "Stop", yscale = 22/32, xscale = 80/130, width = "80", height = "25", functionName = "SS_stopScanning()", texture = SS_StopButton, pushedTxt = "Interface\\Buttons\\UI-Panel-Button-Down.blp", highLightTxt = SS_hightlightMediumUI},
};

function SS_updateFrames()
	if not _G["SS_InstanceText3#14"] and not running then
		for j, var in ipairs(SS_masterFrameTable) do -- This register all frames and hides them
			for i, tVar in ipairs(var) do
				if not (i == 1) and not _G["SS_InstanceText"..j.."#"..i] then
					_G["SS_InstanceText"..j.."#"..i] = SatchelScannerDisplayWindow:CreateFontString(nil, "OVERLAY")
					_G["SS_InstanceText"..j.."#"..i]:SetFont(SS_preFont, 14, "OUTLINE");
					_G["SS_InstanceText"..j.."#"..i]:SetTextColor(unpack(tVar.color));
					_G["SS_InstanceText"..j.."#"..i]:SetText(tVar.text);
					_G["SS_InstanceText"..j.."#"..i]:SetPoint("TOPLEFT", 0, 0);
					_G["SS_InstanceText"..j.."#"..i]:Hide();
				elseif (i == 1) and not _G["SS_InstanceIcon"..j.."#"..i] then
					_G["SS_InstanceIcon"..j.."#"..i] = CreateFrame("Button", nil, SatchelScannerDisplayWindow);
					_G["SS_InstanceIcon"..j.."#"..i]:SetWidth("16");
					_G["SS_InstanceIcon"..j.."#"..i]:SetHeight("16");
					_G["SS_InstanceIcon"..j.."#"..i]:SetNormalTexture(tVar.texture)
					_G["SS_InstanceIcon"..j.."#"..i]:SetPoint("TOPLEFT", 0, 0);
					_G["SS_InstanceIcon"..j.."#"..i]:Hide();
				end	
			end
		end
	end
	if _G["SS_InstanceText3#14"] and not running then
		local yvar = -28;
		for j, var in ipairs(SS_masterFrameTable) do -- This is for displaying/hiding each texture
			local countMe = 0;
			for i, tVar in ipairs(var) do
				if string.find(tVar[1] or "", "Box") then
					if (_G[tVar[1]]:GetChecked()) then
						countMe = countMe + 1;
						_G["SS_InstanceText"..j.."#"..i]:Hide()
					elseif not (_G[tVar[1]]:GetChecked()) then
						_G["SS_InstanceText"..j.."#"..i]:Hide();
					end
				elseif string.find(tVar[1] or "", "Text") then
					_G["SS_InstanceText"..j.."#"..i]:SetPoint("TOPLEFT", tVar.x, yvar);
					_G["SS_InstanceText"..j.."#"..i]:SetText(tVar.text);
					_G["SS_InstanceText"..j.."#"..i]:SetTextColor(unpack(tVar.color));
					_G["SS_InstanceText"..j.."#"..i]:Show();
					if string.find(tVar[1] or "", "Text2") then
						yvar = yvar - 17;
					end
				elseif string.find(tVar[1] or "", "Icon") then
					_G["SS_InstanceIcon"..j.."#"..i]:SetPoint("TOPLEFT", tVar.x, yvar);
					_G["SS_InstanceIcon"..j.."#"..i]:Show();
					yvar = yvar - 1;
				end
			end
			if countMe == 0 then
				yvar = yvar + 18;
				_G["SS_InstanceText"..j.."#"..3]:Hide();
				_G["SS_InstanceText"..j.."#"..2]:Hide();
				_G["SS_InstanceIcon"..j.."#"..1]:Hide();
			end
			local heigth = (yvar*-1) + 30;
			SatchelScannerDisplayWindow:SetHeight(heigth);
		end
	end
	if _G["SS_InstanceText3#14"] and running then
		local yvar = -28;
		for j, var in ipairs(SS_masterFrameTable) do -- This is for setting scan parameters
			for i, tVar in ipairs(var) do
				if string.find(tVar[1] or "", "Box") and _G["SS_InstanceText"..j.."#"..i]:IsShown() then
					_G["SS_InstanceText"..j.."#"..i]:SetPoint("TOPLEFT", tVar.x, yvar);
					yvar = yvar - 15;
				elseif string.find(tVar[1] or "", "Text") and _G["SS_InstanceText"..j.."#"..i]:IsShown() then
					_G["SS_InstanceText"..j.."#"..i]:SetPoint("TOPLEFT", tVar.x, yvar);
					if string.find(tVar[1] or "", "Text2") then
						yvar = yvar - 17;
					end
				elseif string.find(tVar[1] or "", "Icon") then
					_G["SS_InstanceIcon"..j.."#"..i]:SetPoint("TOPLEFT", tVar.x, yvar);
					yvar = yvar - 1;
				end
			end
			local heigth = (yvar*-1) + 30;
			SatchelScannerDisplayWindow:SetHeight(heigth);
		end		
	end
	SS_bagCounterText:SetText(SS_satchelsReceived);
end

function SS_Scanner()
	if (_G["SS_InstanceText3#14"]) and running then
		for j, var in ipairs(SS_masterFrameTable) do
			local SatchelFound;
			for i, tVar in ipairs(var) do
				if (i > 3) then
					if (_G[tVar[1]]:GetChecked()) then
						local fastScan = {};
						local eligible, forTank, forHeal, forDps = GetLFGRoleShortageRewards(tVar.id, 1)
						fastScan[1] = forTank;
						fastScan[2] = forHeal;
						fastScan[3] = forDps;
						if fastScan[j] then
							_G["SS_InstanceText"..j.."#"..i]:SetTextColor(unpack(greenColor));
							_G["SS_InstanceText"..j.."#"..i]:SetText(SS_scanVar[i]);
							_G["SS_InstanceText"..j.."#"..i]:Show();
							SS_NotifcationTable[j] = true;
							SatchelFound = true;
						elseif not fastScan[j] then
							_G["SS_InstanceText"..j.."#"..i]:SetTextColor(unpack(whiteColor));
							_G["SS_InstanceText"..j.."#"..i]:SetText(SS_scanVar[3]);
							_G["SS_InstanceText"..j.."#"..i]:Hide();
						end
					end
				end
			end
			if SatchelFound then
				_G["SS_InstanceText"..j.."#3"]:SetTextColor(unpack(greenColor));
				_G["SS_InstanceText"..j.."#3"]:SetText(SS_classScan[3]);
			else
				_G["SS_InstanceText"..j.."#3"]:SetTextColor(unpack(yellowColor));
				_G["SS_InstanceText"..j.."#3"]:SetText(SS_classScan[2]);
			end
		end
		SS_updateFrames();
		if SS_NotifcationTable[1] or SS_NotifcationTable[2] or SS_NotifcationTable[3] then
			SatchelScanner_Notify();
		end
	end
end

function SS_drawFrames() -- Draws the SatchelScannerDisplayWindow --
	-- Draw Core
	SatchelScannerDisplayWindow = CreateFrame("Frame", "SatchelFrame", UIParent)
	SatchelScannerDisplayWindow:SetMovable(true)
	SatchelScannerDisplayWindow:EnableMouse(true)
	SatchelScannerDisplayWindow:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and not self.isMoving then
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	SatchelScannerDisplayWindow:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.isMoving then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	SatchelScannerDisplayWindow:SetScript("OnHide", function(self)
		if ( self.isMoving ) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	SatchelScannerDisplayWindow:SetWidth(260);
	SatchelScannerDisplayWindow:SetHeight(60);
	SatchelScannerDisplayWindow:SetPoint("TOPLEFT", 200, -400);
	SatchelScannerDisplayWindow:SetFrameStrata("BACKGROUND")
	SatchelScannerDisplayWindow:SetBackdrop({ 
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		edgeFile = SS_Border, tile = false, tileSize = 0, edgeSize = 8, 
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	for i, tVar in pairs(SS_slimFrame) do
		if string.find(i, "Button") then
			_G[i] = CreateFrame("Button", nil, SatchelScannerDisplayWindow, UIPanelButtonTemplate);
			_G[i]:SetWidth(tVar.width);
			_G[i]:SetHeight(tVar.height);
			_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
			_G[i]:SetNormalTexture(tVar.texture);
			_G[i]:SetPushedTexture(tVar.pushedTxt);
			_G[i]:SetHighlightTexture(tVar.highLightTxt);
			_G[i]:SetScript("OnClick", loadstring(tVar.functionName))
			if string.find(i, "start") or string.find(i, "stop") then
				_G[i]:GetNormalTexture():SetTexCoord(0,tVar.xscale,0,tVar.yscale);
				_G[i]:GetPushedTexture():SetTexCoord(0,tVar.xscale,0,tVar.yscale);
				_G[i]:GetHighlightTexture():SetTexCoord(0,tVar.xscale,0,tVar.yscale);
				if tVar.text then
					local buttonText = _G[i]:CreateFontString(nil, "OVERLAY")
					buttonText:SetFont(SS_preFont, 14, "");
					buttonText:SetPoint("CENTER", 0, 0);
					buttonText:SetTextColor(unpack(yellowColor));
					buttonText:SetText(tVar.text);
				end
			end
		elseif string.find(i, "texture") then
			_G[i] = CreateFrame("Button", nil, SatchelScannerDisplayWindow);
			_G[i]:SetWidth(tVar.width);
			_G[i]:SetHeight(tVar.height);
			_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
			_G[i]:SetNormalTexture(tVar.texture)
			if string.find(i, "Spacer") then
				_G[i]:SetWidth(SatchelScannerDisplayWindow:GetWidth() - 14);
				_G[i]:SetAlpha(1);
			end
		elseif string.find(i, "Text") then
			_G[i] = SatchelScannerDisplayWindow:CreateFontString(nil, "OVERLAY")
			_G[i]:SetFont(SS_preFont, tVar.fontSize, "OUTLINE");
			_G[i]:SetPoint(tVar.loc, tVar.x, tVar.y);
			_G[i]:SetTextColor(unpack(tVar.color));
			_G[i]:SetText(tVar.text);
		end
	end
	SS_datacall("read");
	SS_updateFrames();
end

function SS_startScanning()
	if not running then
		running = true
		SS_SubHeaderText2:SetText(SS_runVar[2]);
		SS_SubHeaderText2:SetTextColor(unpack(greenColor));
		SS_updateFrames();
		RequestLFDPlayerLockInfo();
		SS_printmm("Started Scanning!");
	end
end

function SS_stopScanning()
	if running then
		running = false;
		SS_SubHeaderText2:SetText(SS_runVar[1]);
		SS_SubHeaderText2:SetTextColor(unpack(redColor));
		SS_updateFrames();
		SS_printmm("Stopped Scanning!")
	end
end

function SS_hideMainFrame()
	SatchelScannerDisplayWindow:Hide();
	SS_showUI = false;
	SatchelScannerDB["showMainFrame"] = SS_showUI;
end

-------------------------------
-- PRINT, ERROR COLLECT ETC. --
-------------------------------
function SS_errorCollect(e, e2)
	print("|cffff0000==== SS3 ERROR DUMP ====");
	print("|cFF0080FFSS3: |cffffffffINVALID '"..e.."' CALL");
	print("|cFF0080FFSS3: |cffffffffCALL USED WAS: '"..e2.."'");
	print("|cFF0080FFSS3: |cffffffffPLEASE REPORT TO DEVELOPER");
	print("|cffff0000==== END OF SS3 DUMP ====");
end

function SS_printm(msg)
	print("|cFFFF007F" .. msg  .. "|r");
end

function SS_printmm(msg)
	print("|cFF0080FFSS3: |cffffffff"..msg.."|r");
end

----------------------------------
-- ON LOAD, ON UPDATE, ON EVENT --
----------------------------------

function SatchelScanner_OnEvent(self, event, arg, arg2)
	local SS_inLFGQueue = GetLFGQueueStats(LE_LFG_CATEGORY_LFD)
	local SS_inLFRQueue = GetLFGQueueStats(LE_LFG_CATEGORY_RF)
	local SS_debuff = UnitDebuff("player", "Dungeon Deserter")
	local SS_inGroup = IsInGroup()
	if event == "ADDON_LOADED" and arg == "SatchelScanner" then
		SS_interfaceConfig();
		SS_NotifcationTable = {};
		SS_printm("Satchel Scanner v"..SS_addonVersion.."-"..SS_versionTag.." Loaded!");
		SS_printm("->> Type /ss3 for commands!");
	elseif event == "CHAT_MSG_LOOT" and string.find(arg, "Shattered Satchel of Cooperation") and not (MailFrame:IsShown() or TradeFrame:IsShown()) then
		SS_satchelsReceived = SS_satchelsReceived + 1;
		SS_bagCounterText:SetText(SS_satchelsReceived);
		SS_datacall("update");
	elseif event == "LFG_QUEUE_STATUS_UPDATE" then
		-- This is just thrown to make sure SS_inLFGQueue/SS_inLFRQueue works as intended.
		-- Mostly to keep the booleans true/false even after an Que rejoin.
	elseif event == "PLAYER_ENTERING_WORLD" then
		ss_inInstance = IsInInstance()
	elseif event == "LFG_UPDATE_RANDOM_INFO" and running and not SS_inLFGQueue and not SS_inLFRQueue and not string.find(SS_debuff or "", "Dungeon Deserter") and (SS_scanInDungeon or not ss_inInstance) and (SS_scanInGroup or not SS_inGroup) then
		SS_Scanner();
	end
end

function SatchelScanner_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("CHAT_MSG_LOOT");
	self:RegisterEvent("LFG_UPDATE_RANDOM_INFO");
	self:RegisterEvent("LFG_QUEUE_STATUS_UPDATE");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	SLASH_SATCHELSCANNER1, SLASH_SATCHELSCANNER2 = "/satchelscan", "/ss3"
	SlashCmdList.SATCHELSCANNER = function(msg)
		if msg == "toggle" then
			if SatchelScannerDisplayWindow:IsShown() then
				SatchelScannerDisplayWindow:Hide();
				SS_showUI = false;
			else
				SatchelScannerDisplayWindow:Show();
				SS_showUI = true;
			end
			SS_datacall("update");
		elseif msg == "start" then
			SS_startScanning();
		elseif msg == "stop" then
			SS_stopScanning();
		elseif msg == "reset" then
			SS_satchelsReceived = SatchelScannerDB["satchels"];
			SS_datacall("reset");
		elseif msg == "reset-counter" then
			SS_satchelsReceived = 0;
			SS_datacall("update");
		elseif msg == "config" then
			InterfaceOptionsFrame_OpenToCategory(SS_Options.childpanel);
		elseif msg == "faq" then
			InterfaceOptionsFrame_OpenToCategory(SS_Options.panel);
		else
			SS_printm("====== Satchel Scanner ======");
			SS_printm("->> Type '/ss3 toggle' to show/hide the frame");
			SS_printm("->> Type '/ss3 start' to start scanning");
			SS_printm("->> Type '/ss3 stop' to stop scanning");
			SS_printm("->> Type '/ss3 reset' to reset the addon");
			SS_printm("->> Type '/ss3 reset-counter' to reset the bag counter");
			SS_printm("->> Type '/ss3 config' to configure the addon");
			SS_printm("->> Type '/ss3 faq' to open the F.A.Q")
		end
		msg = ""
	end
end

function SatchelScanner_Notify()
	if running then
		local timeSinceLast = GetTime(); -- GetTime(): KERNEL FUNCTION, KEEP IN MIND USES GetTickCount()!
		timeSinceLast = timeSinceLast - SS_TimeSinceLastNotification;
		if (timeSinceLast > SS_NotificationInterval) then
			FlashClientIcon();
			if SS_raidWarnNotify then
				for i=1,3,1 do
					if SS_NotifcationTable[i] then
						RaidNotice_AddMessage(RaidWarningFrame, SS_ctaVar[i], ChatTypeInfo["RAID_WARNING"])
						SS_NotifcationTable[i] = false;
					end
				end
			end
			if not SatchelScannerDisplayWindow:IsShown() then
				SatchelScannerDisplayWindow:Show();
			end
			if SS_playSound then
				PlaySoundFile("Sound\\interface\\RaidWarning.ogg", "Master");
			end
			SS_TimeSinceLastNotification = GetTime();
		end
	end
end

function SatchelScanner_OnUpdate(self, elapsed)
	--and not SS_inLFGQueue and not SS_inLFRQueue and (SS_scanInDungeon or not ss_inInstance) and (SS_scanInGroup or not SS_inGroup) 
	if running then
		self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
		while (self.TimeSinceLastUpdate > SS_ScannerInterval) do
			RequestLFDPlayerLockInfo();
			self.TimeSinceLastUpdate = self.TimeSinceLastUpdate - SS_ScannerInterval;
		end
	end
end


