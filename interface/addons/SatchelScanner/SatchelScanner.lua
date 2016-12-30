--------------------------------
-- Coded by: Exzu / EU-Aszune --
--------------------------------
--     MAINFRAME & SCANNER    --
--------------------------------
textTable = {
	ANT = { outLine = "OUTLINE", fontSize = "14", loc = "TOP", x = 0, y = 8, color = {1, 1, 1, 1}, text = "Satchel Scanner", },
	statusText = { outLine = "OUTLINE", fontSize = "16", loc = "LEFT", x = 5, y = 61, color = {0, 1, 0, 1}, text = "Current Status:", },
	scanText = { outLine = "OUTLINE", fontSize = "16", loc = "LEFT", x = 95, y = 61, color = {1, 0, 0, 1}, text = "Not Running", },
	tankText = { outLine = "OUTLINE", fontSize = "14", loc = "LEFT", x = 22, y = 45, color = {1, 1, 1, 1}, text = "Tank:", },
	tankScanningText = { outLine = "OUTLINE", fontSize = "14", loc = "LEFT", x = 52, y = 45, color = {1, 0, 0, 1}, text = "Not Scanning...", },
	tankdg1 = { outLine = "OUTLINE", fontSize = "14", loc = "LEFT", x = 6, y = 29, color = {0, 0.6, 0.8, 1}, text = "# ...", },
	healerText = { outLine = "OUTLINE", fontSize = "14", loc = "LEFT", x = 22, y = 13, color = {1, 1, 1, 1}, text = "Healer:", },
	healScanningText = { outLine = "OUTLINE", fontSize = "14", loc = "LEFT", x = 62, y = 13, color = {1, 0, 0, 1}, text = "Not Scanning...", },
	healdg1 = { outLine = "OUTLINE", fontSize = "14", loc = "LEFT", x = 6, y = -3, color = {0, 0.6, 0.8, 1}, text = "# ...", },
	dpsText = { outLine = "OUTLINE", fontSize = "14", loc = "LEFT", x = 22, y = -19, color = {1, 1, 1, 1}, text = "DPS:", },
	dpsScanningText = { outLine = "OUTLINE", fontSize = "14", loc = "LEFT", x = 47, y = -19, color = {1, 0, 0, 1}, text = "Not Scanning...", },
	dpsdg1 = { outLine = "OUTLINE", fontSize = "14", loc = "LEFT", x = 6, y = -35, color = {0, 0.6, 0.8, 1}, text = "# ...", },
	bagCounter = { outLine = "OUTLINE", fontSize = "14", loc = "TOP", x = 116, y = -23, color = {0, 0.6, 0.8, 1}, bag = true, text = "0", },
};

frameTable = {
	scanButton = { zscale = 0, zxscale = 0, yscale = 22/32, xscale = 80/128, texture = true, Type = "Button", width = "80", height = "25", loc = "BOTTOM", x = -80, y = 5, text = "Start", script = true, functionName = "startScanning()", normalTxt = "Interface\\Buttons\\UI-Panel-Button-Up.blp", pushedTxt = "Interface\\Buttons\\UI-Panel-Button-Down.blp", highLightTxt = "Interface\\Buttons\\UI-Panel-Button-Highlight.png", },
	stopButton = { zscale = 0, zxscale = 0, yscale = 22/32, xscale = 80/128, texture = true, Type = "Button", width = "80", height = "25", loc = "BOTTOM", x = 80, y = 5, text = "Stop", script = true, functionName = "stopScanning()", normalTxt = "Interface\\Buttons\\UI-Panel-Button-Up.blp", pushedTxt = "Interface\\Buttons\\UI-Panel-Button-Down.blp", highLightTxt = "Interface\\Buttons\\UI-Panel-Button-Highlight.png", },
	configButton = { zscale = 0, zxscale = 0, yscale = 1, xscale = 1, texture = true, Type = "Button", width = "16", height = "16", loc = "TOP", x = 97, y = -5, script = true, functionName = "InterfaceOptionsFrame_OpenToCategory(SatchelScannerOptions.childpanel)", normalTxt = "Interface\\Addons\\SatchelScanner\\icons\\config.tga", pushedTxt = "Interface\\Addons\\SatchelScanner\\icons\\configpush.tga", highLightTxt = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp", },
	closeButton = { zscale = 0, zxscale = 0, yscale = 1, xscale = 1, texture = true, Type = "Button", width = "16", height = "16", loc = "TOP", x = 115, y = -5, script = true, functionName = "hideMainFrame()", normalTxt = "Interface\\Addons\\SatchelScanner\\icons\\close.tga", pushedTxt = "Interface\\Addons\\SatchelScanner\\icons\\closepush.tga", highLightTxt = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp", },
	bagIcon = { zscale = 0, zxscale = 0, yscale = 1, xscale = 1, Type = "Button", width = "16", height = "16", loc = "TOP", x = 97, y = -23, normalTxt = "Interface\\Addons\\SatchelScanner\\icons\\bagIcon.tga", },
	tankIcon = { zscale = 0, zxscale = 0, yscale = 1, xscale = 1, Type = "Button", width = "15", height = "15", loc = "LEFT", x = 6, y = 45, normalTxt = "Interface\\Addons\\SatchelScanner\\icons\\tankIcon.tga", },
	healIcon = { zscale = 0, zxscale = 0, yscale = 1, xscale = 1, Type = "Button", width = "15", height = "15", loc = "LEFT", x = 6, y = 13, normalTxt = "Interface\\Addons\\SatchelScanner\\icons\\healerIcon.tga", },
	dpsIcon = { zscale = 0, zxscale = 0, yscale = 1, xscale = 1, Type = "Button", width = "15", height = "15", loc = "LEFT", x = 6, y = -19, normalTxt = "Interface\\Addons\\SatchelScanner\\icons\\dpsIcon.tga", },
};

dungeonTable = {
	dungeon1 = { id = 1046, }
};
-- Variables
local playSound = true; -- Play sound to notify?
local raidWarnNotify = true; -- Use Raidwarning to notify?
local UpdateInterval = 5; -- Update Interval
local scanForTank = true; -- Scan for Tank Option
local scanForHeal = true; -- Scan for Heal Option
local scanForDps = false; -- Scan for Dps Option
local showUI = true; -- Show UI Yes by defualt

local running = false; -- Boolean to detect Running/paused state

local addonVersion = 7.05; -- Addon Version, useful for wiping savedvariables if needed
--local versionTag = "Release";
local tankSatchelFound = false; -- Specific Boolean for Tank Satchels
local healSatchelFound = false; -- Specific Boolean for Healer Satchels
local dpsSatchelFound = false; -- Specific Boolean for DPS Satchels
local satchelsReceived = 0;

local scanInDungeon = false; -- Scan while in an dungeon?
local scanInGroup = true; -- Scan while in an group?

-- Dungeon Scan Var
local runVar = {"Not Running", "Running"};
local heroicVar = {"# Legion Heroic!", "# Not used...!"};
local scanVar = {"# ...", "# Searching..."};
local classScan = {"Not Scanning...","Scanning...","Satchel Found!"};
local ctaVar = {"Call to Arms: Tank","Call to Arms: Healer","Call to Arms: Dps"};


-- Text Colors
local redColor = {1,0,0,1};
local greenColor = {0,1,0,1};
local yellowColor = {1,1,0,1};

function stopScanning()
	if running then
		tankSatchelFound = false;
		healSatchelFound = false;
		dpsSatchelFound = false;
		running = false;
		textTable.scanText.textFrame:SetTextColor(unpack(redColor));
		textTable.scanText.textFrame:SetText(runVar[1]);
		textTable.tankScanningText.textFrame:SetText(classScan[1]);
		textTable.tankScanningText.textFrame:SetTextColor(unpack(redColor));
		textTable.healScanningText.textFrame:SetText(classScan[1]);
		textTable.healScanningText.textFrame:SetTextColor(unpack(redColor));
		textTable.dpsScanningText.textFrame:SetText(classScan[1]);
		textTable.dpsScanningText.textFrame:SetTextColor(unpack(redColor));
		textTable.tankdg1.textFrame:SetText(scanVar[1]);
		textTable.healdg1.textFrame:SetText(scanVar[1]);
		textTable.dpsdg1.textFrame:SetText(scanVar[1]);
	end
end

function startScanning()
	if not running and (scanForTank or scanForHeal or scanForDps) then
		running = true
		textTable.scanText.textFrame:SetTextColor(unpack(greenColor));
		textTable.scanText.textFrame:SetText(runVar[2]);
		if scanForTank then
			textTable.tankdg1.textFrame:SetText(scanVar[2]);
		end
		if scanForHeal then
			textTable.healdg1.textFrame:SetText(scanVar[2]);
		end
		if scanForDps then
			textTable.dpsdg1.textFrame:SetText(scanVar[2]);
		end
		RequestLFDPlayerLockInfo();
	elseif not running and not (scanForTank or scanForHeal or scanForDps) then
		print("Must scan for atleast one class before starting the program!");
	end
end

function hideMainFrame()
	MainFrame:Hide();
	tableAdd("showMainFrame", false);
end

function drawFrames() -- Draws the MainFrame --
	SS_interfaceConfig();
	MainFrame = CreateFrame("Frame", "DragFrame2", UIParent)
	MainFrame:SetMovable(true)
	MainFrame:EnableMouse(true)
	MainFrame:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and not self.isMoving then
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	MainFrame:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.isMoving then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	MainFrame:SetScript("OnHide", function(self)
		if ( self.isMoving ) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	MainFrame:SetWidth(256);
	MainFrame:SetHeight(150);
	MainFrame:SetPoint("BOTTOMLEFT", 800, 400);
	MainFrame:SetFrameStrata("BACKGROUND")
	MainFrame:SetBackdrop({ 
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		edgeFile = "Interface\\Addons\\SatchelScanner\\border\\border.tga", tile = false, tileSize = 0, edgeSize = 8, 
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	for i, frameData in pairs(frameTable) do -- This is for drawing each texture.
		frameData.frame = CreateFrame(frameData.Type,nil,MainFrame, UIPanelButtonTemplate);
		frameData.frame:SetWidth(frameData.width);
		frameData.frame:SetHeight(frameData.height);
		frameData.frame:SetPoint(frameData.loc, frameData.x, frameData.y);
		frameData.frame:SetNormalTexture(frameData.normalTxt);
		frameData.frame:SetPushedTexture(frameData.pushedTxt);
		frameData.frame:SetHighlightTexture(frameData.highLightTxt);
		frameData.frame:GetNormalTexture():SetTexCoord(frameData.zxscale,frameData.xscale,frameData.zscale,frameData.yscale);
		if frameData.texture then
			frameData.frame:GetPushedTexture():SetTexCoord(frameData.zxscale,frameData.xscale,frameData.zscale,frameData.yscale);
			frameData.frame:GetHighlightTexture():SetTexCoord(frameData.zxscale,frameData.xscale,frameData.zscale,frameData.yscale);
		end
		if frameData.text then
			local buttonText = frameData.frame:CreateFontString(nil, "OVERLAY")
			buttonText:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", 14, "");
			buttonText:SetPoint("CENTER", 0, 0);
			buttonText:SetTextColor(unpack(yellowColor));
			buttonText:SetText(frameData.text);
		end
		if frameData.script then
			frameData.frame:SetScript("OnClick", loadstring(frameData.functionName));
		end
	end
end

function drawText() -- Draws the Text -- 
	for i, textData in pairs(textTable) do
		textData.textFrame = MainFrame:CreateFontString(nil, "OVERLAY")
		textData.textFrame:SetFont("Interface\\Addons\\SatchelScanner\\fonts\\font.TTF", textData.fontSize, textData.outLine);
		textData.textFrame:SetPoint(textData.loc, textData.x, textData.y);
		textData.textFrame:SetTextColor(unpack(textData.color));
		textData.textFrame:SetText(textData.text);
	end
end

----------------------------
-- SCANNER, DO NOT MODIFY --
----------------------------
--for i, dungeonID in pairs(dungeonTable) do
--end
----------------------------
	
function SS_Scanner()
	local eligible, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(1046, 1)
		if forTank and scanForTank then
			tankSatchelFound = true;
			textTable.tankScanningText.textFrame:SetText(classScan[3]);
			textTable.tankScanningText.textFrame:SetTextColor(unpack(greenColor));
			textTable.tankdg1.textFrame:SetText(heroicVar[1]);
			if raidWarnNotify then
				RaidNotice_AddMessage(RaidWarningFrame, ctaVar[1], ChatTypeInfo["RAID_WARNING"])
			end
			if not MainFrame:IsShown() then
				MainFrame:Show();
			end
		else
			tankSatchelFound = false;
			textTable.tankdg1.textFrame:SetText(scanVar[2]);
			textTable.tankScanningText.textFrame:SetText(classScan[2]);
			textTable.tankScanningText.textFrame:SetTextColor(unpack(yellowColor));
		end
		if forHealer and scanForHeal then
			healSatchelFound = true;
			textTable.healScanningText.textFrame:SetText(classScan[3]);
			textTable.healScanningText.textFrame:SetTextColor(unpack(greenColor));
			textTable.healdg1.textFrame:SetText(heroicVar[1]);
			if raidWarnNotify then
				RaidNotice_AddMessage(RaidWarningFrame, ctaVar[2], ChatTypeInfo["RAID_WARNING"])
			end
			if not MainFrame:IsShown() then
				MainFrame:Show();
			end
		else
			healSatchelFound = false;
			textTable.healdg1.textFrame:SetText(scanVar[2]);
			textTable.healScanningText.textFrame:SetText(classScan[2]);
			textTable.healScanningText.textFrame:SetTextColor(unpack(yellowColor));
		end
		if forDamage and scanForDps then
			dpsSatchelFound = true;
			textTable.dpsScanningText.textFrame:SetText(classScan[3]);
			textTable.dpsScanningText.textFrame:SetTextColor(unpack(greenColor));
			textTable.dpsdg1.textFrame:SetText(heroicVar[1]);
			if raidWarnNotify then
				RaidNotice_AddMessage(RaidWarningFrame, ctaVar[3], ChatTypeInfo["RAID_WARNING"])
			end
			if not MainFrame:IsShown() then
				MainFrame:Show();
			end
		else
			dpsSatchelFound = false;
			textTable.dpsdg1.textFrame:SetText(scanVar[2]);
			textTable.dpsScanningText.textFrame:SetText(classScan[2]);
			textTable.dpsScanningText.textFrame:SetTextColor(unpack(yellowColor));
		end
end

-----------------------------
-- DATABASE, DO NOT MODIFY --
-----------------------------
function datacall(datatable)
	if datatable == "reset" then
		SatchelScannerDB = {}
		tableAdd("updateint", 5);
		tableAdd("version", addonVersion);
		tableAdd("raidwarning", true);
		tableAdd("sounds", true);
		tableAdd("scanTank", true);
		tableAdd("scanHeal", true);
		tableAdd("scanDps", false);
		tableAdd("scanInDungeon", false);
		tableAdd("scanInGroup", true);
		tableAdd("satchels", satchelsReceived);
		tableAdd("showMainFrame", true);
		datacall("read");
	elseif datatable == "update" then
		tableAdd("updateint", updateIntervalSlider:GetValue());
		tableAdd("version", addonVersion);
		tableAdd("raidwarning", raidWarningButton:GetChecked());
		tableAdd("sounds", playSoundButton:GetChecked());
		tableAdd("scanTank", scanForTankButton:GetChecked());
		tableAdd("scanHeal", scanForHealButton:GetChecked());
		tableAdd("scanDps", scanForDpsButton:GetChecked());
		tableAdd("scanInDungeon", scanInDungeonButton:GetChecked());
		tableAdd("scanInGroup", scanInGroupButton:GetChecked());
		tableAdd("satchels", satchelsReceived);
		tableAdd("showMainFrame", showUI);
		datacall("read");
	elseif datatable == "read" then
		if not SatchelScannerDB then
			printm("SS3: Your settings have been reset!");
			datacall("reset");
		elseif SatchelScannerDB["version"] < 7.04 then
			satchelsReceived = SatchelScannerDB["satchels"];
			printm("SS3: Your settings have been reset!");
			datacall("reset");
		else
			playSound = SatchelScannerDB["sounds"];
			playSoundButton:SetChecked(playSound);
			raidWarnNotify = SatchelScannerDB["raidwarning"];
			raidWarningButton:SetChecked(raidWarnNotify);
			satchelsReceived = SatchelScannerDB["satchels"];
			textTable.bagCounter.textFrame:SetText(satchelsReceived);
			UpdateInterval = SatchelScannerDB["updateint"];
			updateIntervalSlider:SetValue(UpdateInterval);
			dbVersion = SatchelScannerDB["version"];
			scanForTank = SatchelScannerDB["scanTank"];
			scanForHeal = SatchelScannerDB["scanHeal"];
			scanForDps = SatchelScannerDB["scanDps"];
			scanInDungeon = SatchelScannerDB["scanInDungeon"];
			scanInGroup = SatchelScannerDB["scanInGroup"];
			scanInGroupButton:SetChecked(scanInGroup);
			scanInDungeonButton:SetChecked(scanInDungeon);
			scanForDpsButton:SetChecked(scanForDps);
			scanForTankButton:SetChecked(scanForTank);
			scanForHealButton:SetChecked(scanForHeal);
			showUI = SatchelScannerDB["showMainFrame"];
			if showUI then
				MainFrame:Show();
			else
				MainFrame:Hide();
			end
		end
	else
		errorCollect("DATATABLE", datatable);
	end
end

function tableAdd(var, arg) -- Updates values in tables
	SatchelScannerDB[var] = arg;
end

-------------------------------
-- PRINT, ERROR COLLECT ETC. --
-------------------------------
function errorCollect(e, e2)
	print("|cffff0000==== SS3 ERROR DUMP ====");
	print("|cFF0080FFSS3: |cffffffffINVALID '"..e.."' CALL");
	print("|cFF0080FFSS3: |cffffffffCALL USED WAS: '"..e2.."'");
	print("|cFF0080FFSS3: |cffffffffPLEASE REPORT TO DEVELOPER");
	print("|cffff0000==== END OF SS3 DUMP ====");
end

function printm(msg)
	print("|cFFFF007F" .. msg  .. "|r");
end

----------------------------------
-- ON LOAD, ON UPDATE, ON EVENT --
----------------------------------

function SatchelScanner_OnEvent(self, event, arg, arg2)
	local SS_inLFGQueue = GetLFGQueueStats(LE_LFG_CATEGORY_LFD)
	local SS_inLFRQueue = GetLFGQueueStats(LE_LFG_CATEGORY_LFR)
	local SS_debuff = UnitDebuff("player", "Dungeon Deserter")
	local SS_inGroup = IsInGroup()
	if event == "ADDON_LOADED" and arg == "SatchelScanner" then
		datacall("read");
		printm("Satchel Scanner v" .. addonVersion .. " Loaded!");
		printm("->> Type /ss3 for commands!");
	elseif event == "CHAT_MSG_LOOT" and string.find(arg, "Shattered Satchel of Cooperation") and not (MailFrame:IsShown() or TradeFrame:IsShown()) then
		satchelsReceived = satchelsReceived + 1;
		tableAdd("satchels", satchelsReceived);
		textTable.bagCounter.textFrame:SetText(satchelsReceived);
	elseif event == "LFG_QUEUE_STATUS_UPDATE" then
		-- This is just thrown to make sure SS_inLFGQueue/SS_inLFRQueue works as intended.
		-- Mostly to keep the booleans true/false even after an Que rejoin.
	elseif event == "PLAYER_ENTERING_WORLD" then
		ss_inInstance = IsInInstance()
	elseif event == "LFG_UPDATE_RANDOM_INFO" and running and not SS_inLFGQueue and not SS_inLFRQueue and not string.find(SS_debuff or "", "Dungeon Deserter") and (scanInDungeon or not ss_inInstance) and (scanInGroup or not SS_inGroup) then
		SS_Scanner();
	end
end

function SatchelScanner_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("CHAT_MSG_LOOT");
	self:RegisterEvent("LFG_UPDATE_RANDOM_INFO");
	self:RegisterEvent("LFG_QUEUE_STATUS_UPDATE");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	drawFrames();
	drawText();
	SLASH_SATCHELSCANNER1, SLASH_SATCHELSCANNER2 = "/satchelscan", "/ss3"
	SlashCmdList.SATCHELSCANNER = function(msg)
		if msg == "toggle" then
			if MainFrame:IsShown() then
				MainFrame:Hide();
				showUI = false;
			else
				MainFrame:Show();
				showUI = true;
			end
			datacall("update");
		elseif msg == "start" then
			startScanning();
		elseif msg == "stop" then
			stopScanning();
		elseif msg == "reset" then
			satchelsReceived = SatchelScannerDB["satchels"];
			datacall("reset");
		elseif msg == "reset-counter" then
			satchelsReceived = 0;
			datacall("update");
		elseif msg == "config" then
			InterfaceOptionsFrame_OpenToCategory(SatchelScannerOptions.childpanel);
		else
			printm("====== Satchel Scanner ======");
			printm("->> Type '/ss3 toggle' to show/hide the frame");
			printm("->> Type '/ss3 start' to start scanning");
			printm("->> Type '/ss3 stop' to stop scanning");
			printm("->> Type '/ss3 reset' to reset the addon");
			printm("->> Type '/ss3 reset-counter' to reset the bag counter");
			printm("->> Type '/ss3 config' to configure the addon");
		end
		msg = ""
	end
end

function SatchelScanner_OnUpdate(self, elapsed)
	if running and not SS_inLFGQueue and not SS_inLFRQueue and (scanInDungeon or not ss_inInstance) and (scanInGroup or not SS_inGroup) then
		self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
		while (self.TimeSinceLastUpdate > UpdateInterval) do
			RequestLFDPlayerLockInfo();
			if (tankSatchelFound or healSatchelFound or dpsSatchelFound) and playSound and running then
				PlaySoundFile("Sound\\interface\\RaidWarning.ogg", "Master")
				FlashClientIcon()
			end
			self.TimeSinceLastUpdate = self.TimeSinceLastUpdate - UpdateInterval;
		end
	end
end


