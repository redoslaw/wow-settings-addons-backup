function WoWNotifier_OnUpdate(self, elapsed)
	if IsAFKChecking then
		if IsChatAFK() then
			self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
			--1200
			if (self.TimeSinceLastUpdate > 1200.0) then
				if (self.HasAFKNotified ~= true) then
				tempf = CreateFrame("Frame", nil, UIParent);
				tempf:SetFrameStrata("HIGH");
				tempf:SetWidth(20)
				tempf:SetHeight(20)							
				tempf:SetFrameLevel(1000000)
				local t = tempf:CreateTexture(nil, "ARTWORK");
				t:SetTexture([[Interface\BUTTONS\WHITE8X8]])
				t:SetAllPoints(tempf);					
				tempf.texture = t;
				-- AFK IS PURPLE				
				t:SetVertexColor(1, 0, 1);
							
				tempf:SetPoint("TOPLEFT", 0,0);
				tempf:Show();
				
					print("WoWNotifier detected you AFK for 20 minutes. Sending notification...")
					Screenshot();
					self.HasAFKNotified = true;
					if (IsgxRestarting) then
						print("Start GX");
						ConsoleExec("/script SetCVar(\"gxWindow\", 1 - GetCVar(\"gxWindow\"));")
						--ConsoleExec("gxRestart");
						print("End GX");
					end	
				end
			end
		else
			self.HasAFKNotified = false;
			self.TimeSinceLastUpdate = 0;
		end
	else
		self.HasAFKNotified = false;
		self.TimeSinceLastUpdate = 0;
	end
end

function WoWNotifier_OnEvent(self, event, arg1, ...)		
	if event == "ADDON_LOADED" and arg1 == "WoWNotifier" then	
		WoWNotifier_OnLoad(self);		
		myCheckButton:SetChecked(IsNotifying);
		myCheckButton2:SetChecked(IsBattlePetNotifying);
		myCheckButton3:SetChecked(IsPVPNotifying);			
		myCheckButton4:SetChecked(IsgxRestarting);		
		myCheckButton5:SetChecked(IsGroupNotifying);		
		myCheckButton6:SetChecked(IsPremadeNotifying);		
		myCheckButton7:SetChecked(IsMissionCompleteNotifying);		
		myCheckButton8:SetChecked(IsReadyCheckNotifying);		
		myCheckButton9:SetChecked(IsAFKChecking);	
	end
		
		
	if event == "LFG_PROPOSAL_SHOW" then
		proposalExists, id, typeID, subtypeID, name, texture, role, hasResponded, nonsenseValue, completedEncounters, numMembers, isLeader, isSomethingElse, totalEncounters = GetLFGProposal();
		if proposalExists and IsNotifying then
			if (IsgxRestarting) then
				print("Start GX");
				ConsoleExec("gxRestart");				
				print("End GX");
			end	
			tempf = CreateFrame("Frame", nil, UIParent);
			tempf:SetFrameStrata("HIGH");
			tempf:SetWidth(20)
			tempf:SetHeight(20)							
			local t = tempf:CreateTexture(nil, "ARTWORK");
			t:SetTexture([[Interface\BUTTONS\WHITE8X8]])
			t:SetAllPoints(tempf);					
			tempf.texture = t;
								
			-- LFR/LFD is RED									
			t:SetVertexColor(1, 0, 0);
						
			tempf:SetPoint("TOPLEFT", 0,0);
			tempf:Show();
			
				
			
			print("WoWNotifier detected a LFG/LFR/Scenario pop. Sending notification...")
			Screenshot();		
					
		end
	end
	

	--BATTLEFIELD_MGR_ENTRY_INVITE
	-- TODO: Update to World PvP Queue
	if event == "BATTLEFIELD_MGR_ENTRY_INVITE" then				
		if IsPVPNotifying then
			tempf = CreateFrame("Frame", nil, UIParent);
				tempf:SetFrameStrata("HIGH");
				tempf:SetWidth(20)
				tempf:SetHeight(20)							
				local t = tempf:CreateTexture(nil, "ARTWORK");
				t:SetTexture([[Interface\BUTTONS\WHITE8X8]])
				t:SetAllPoints(tempf);					
				tempf.texture = t;
				
				t:SetVertexColor(1, 1, 0);
							
				tempf:SetPoint("TOPLEFT", 0,0);
				tempf:Show();				
			print("WoWNotifier detected a group invite. Sending notification...")
			Screenshot();		
			if (IsgxRestarting) then
				ConsoleExec("gxRestart");
			end	
		end
	end	
	
	
	if event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then	
		LFGListInviteDialog_CheckPending(self);
		local status = ...;
		
        --local _, status, pendingStatus = C_LFGList.GetApplicationInfo(id);
		if (status == "invited") then
			if IsPremadeNotifying then
			tempf = CreateFrame("Frame", nil, UIParent);
				tempf:SetFrameStrata("HIGH");
				tempf:SetWidth(20)
				tempf:SetHeight(20)							
				local t = tempf:CreateTexture(nil, "ARTWORK");
				t:SetTexture([[Interface\BUTTONS\WHITE8X8]])
				t:SetAllPoints(tempf);					
				tempf.texture = t;
				-- READY CHECK IS GREEN		
				t:SetVertexColor(.25, .25, .25);
							
				tempf:SetPoint("TOPLEFT", 0,0);
				tempf:Show();
				
				print("WoWNotifier detected a Premade invite. Sending notification...")
				Screenshot();	
				if (IsgxRestarting) then
					ConsoleExec("gxRestart");
				end	
			end
		end			
	end
	
	if event == "READY_CHECK" then
		if IsReadyCheckNotifying then
		
		tempf = CreateFrame("Frame", nil, UIParent);
				tempf:SetFrameStrata("HIGH");
				tempf:SetWidth(20)
				tempf:SetHeight(20)							
				local t = tempf:CreateTexture(nil, "ARTWORK");
				t:SetTexture([[Interface\BUTTONS\WHITE8X8]])
				t:SetAllPoints(tempf);					
				tempf.texture = t;
				-- READY CHECK IS GREEN		
				t:SetVertexColor(0, 1, 0);
							
				tempf:SetPoint("TOPLEFT", 0,0);
				tempf:Show();
		
			print("WoWNotifier detected a Ready Check. Sending notification...")
			Screenshot();	
			if (IsgxRestarting) then
				ConsoleExec("gxRestart");
			end	
		end
	end
	
	
	--[[
	if event == "PLAYER_FLAGS_CHANGED" then
		if IsAFKChecking then
			if IsChatDND() then
												
			end
		end
	end]]--
	
	if event == "SCREENSHOT_FAILED" then
		print("Screenshot FAILED");
	end
	
	if event == "SCREENSHOT_SUCCEEDED" then
	print("Screenshot SUCCESS");
		if (tempf) then
			tempf:Hide();
			tempf = nil;
		end
	end
	
	
	if event == "PARTY_INVITE_REQUEST" then		
		if IsGroupNotifying then
		tempf = CreateFrame("Frame", nil, UIParent);
				tempf:SetFrameStrata("HIGH");
				tempf:SetWidth(20)
				tempf:SetHeight(20)							
				local t = tempf:CreateTexture(nil, "ARTWORK");
				t:SetTexture([[Interface\BUTTONS\WHITE8X8]])
				t:SetAllPoints(tempf);					
				tempf.texture = t;
				--Group Invite is white
				t:SetVertexColor(1, 1, 1);
							
				tempf:SetPoint("TOPLEFT", 0,0);
				tempf:Show();				
			print("WoWNotifier detected a group invite. Sending notification...")
			Screenshot();		
			if (IsgxRestarting) then
				ConsoleExec("gxRestart");
			end	
		end
	end	
	
	
	if event == "GARRISON_MISSION_STARTED" then
		-- TODO: Send to new Mission Timer Service for timed pushes.
	end
	
	if event == "GARRISON_MISSION_FINISHED" then
		if IsMissionCompleteNotifying then
			tempf = CreateFrame("Frame", nil, UIParent);
				tempf:SetFrameStrata("HIGH");
				tempf:SetWidth(20)
				tempf:SetHeight(20)							
				local t = tempf:CreateTexture(nil, "ARTWORK");
				t:SetTexture([[Interface\BUTTONS\WHITE8X8]])
				t:SetAllPoints(tempf);					
				tempf.texture = t;
									
				-- GARRISONS are BLUE
				t:SetVertexColor(0, 0, 1);
							
				tempf:SetPoint("TOPLEFT", 0,0);
				tempf:Show();
			print("WoWNotifier detected that a garrison mission finished. Sending notification...")
			Screenshot();

			if (IsgxRestarting) then
				ConsoleExec("gxRestart");
			end				
		end
	end
		
	
	if event == "UPDATE_BATTLEFIELD_STATUS" then		
		for i=1, 3 do
			status, mapName, instanceID = GetBattlefieldStatus(i)			
			if status == "confirm" then
				if IsPVPNotifying then
				tempf = CreateFrame("Frame", nil, UIParent);
				tempf:SetFrameStrata("HIGH");
				tempf:SetWidth(20)
				tempf:SetHeight(20)							
				local t = tempf:CreateTexture(nil, "ARTWORK");
				t:SetTexture([[Interface\BUTTONS\WHITE8X8]])
				t:SetAllPoints(tempf);					
				tempf.texture = t;
				-- PVP is Yellow						
				t:SetVertexColor(1, 1, 0);
							
				tempf:SetPoint("TOPLEFT", 0,0);
				tempf:Show();
					print("WoWNotifier detected a PvP pop. Sending notification...")
					Screenshot();		
					if (IsgxRestarting) then
						ConsoleExec("gxRestart");					
					end
				end
			end
		end		
	end
	
	if event == "PET_BATTLE_QUEUE_PROPOSE_MATCH" then		
		if IsBattlePetNotifying then
		
		tempf = CreateFrame("Frame", nil, UIParent);
				tempf:SetFrameStrata("HIGH");
				tempf:SetWidth(20)
				tempf:SetHeight(20)							
				local t = tempf:CreateTexture(nil, "ARTWORK");
				t:SetTexture([[Interface\BUTTONS\WHITE8X8]])
				t:SetAllPoints(tempf);					
				tempf.texture = t;
				-- pet battle is blue-green.			
				t:SetVertexColor(0, 1, 1);
							
				tempf:SetPoint("TOPLEFT", 0,0);
				tempf:Show();				
				
				
			print("WoWNotifier detected a pet battle pop. Sending notification...");					
			Screenshot();				
			if (IsgxRestarting) then
				ConsoleExec("gxRestart");
			end
		end
	end
end

function WoWNotifier_OnLoad(panel)
	panel.name = "WoW Notifier"
	InterfaceOptions_AddCategory(panel);
	
	header = panel:CreateFontString("headerText" , "ARTWORK", "GameFontNormal");
	
	header:SetPoint("TOPLEFT", 15, -20);
	headerText:SetText("WoW Notifier Options");
	
	myCheckButton = CreateFrame("CheckButton", "myCheckButton_GlobalName", panel, "ChatConfigCheckButtonTemplate")
	myCheckButton:SetPoint("TOPLEFT", 10, -65)
	myCheckButton_GlobalNameText:SetText("  Enable LFG/LFR/Scenario Notifications")
	myCheckButton.tooltip = "Click to toggle notifications on or off."
	myCheckButton:SetScript("PostClick", 
	  function(self)		
		if self:GetChecked() then			
			IsNotifying = true
		else			
			IsNotifying = false
		end
	  end
	)
	
	myCheckButton2 = CreateFrame("CheckButton", "myCheckButton2_GlobalName", panel, "ChatConfigCheckButtonTemplate")
	myCheckButton2:SetPoint("TOPLEFT", 10, -105)
	myCheckButton2_GlobalNameText:SetText("  Enable Pet Battle Notifications")
	myCheckButton2.tooltip = "Click to toggle pet battle notifications on or off."
	myCheckButton2:SetScript("PostClick", 
	  function(self)		
		if self:GetChecked() then			
			IsBattlePetNotifying = true
		else			
			IsBattlePetNotifying = false
		end
	  end
	)
	
	myCheckButton3 = CreateFrame("CheckButton", "myCheckButton3_GlobalName", panel, "ChatConfigCheckButtonTemplate")
	myCheckButton3:SetPoint("TOPLEFT", 10, -145)
	myCheckButton3_GlobalNameText:SetText("  Enable PvP Notifications")
	myCheckButton3.tooltip = "Click to toggle PvP notifications on or off."
	myCheckButton3:SetScript("PostClick", 
	  function(self)		
		if self:GetChecked() then			
			IsPVPNotifying = true
		else			
			IsPVPNotifying = false
		end
	  end
	)
	
	myCheckButton4 = CreateFrame("CheckButton", "myCheckButton4_GlobalName", panel, "ChatConfigCheckButtonTemplate")
	myCheckButton4:SetPoint("TOPLEFT", 10, -185)
	myCheckButton4_GlobalNameText:SetText("  Enable gxRestart on Notification")
	myCheckButton4.tooltip = "Click to toggle gxRestart for notifications on or off."
	myCheckButton4:SetScript("PostClick", 
	  function(self)		
		if self:GetChecked() then			
			IsgxRestarting = true
		else			
			IsgxRestarting = false
		end
	  end
	)
	
	myCheckButton5 = CreateFrame("CheckButton", "myCheckButton5_GlobalName", panel, "ChatConfigCheckButtonTemplate")
	myCheckButton5:SetPoint("TOPLEFT", 275, -65)
	myCheckButton5_GlobalNameText:SetText("  Enable Group Invite Notifications")
	myCheckButton5.tooltip = "Click to toggle Group Invite notifications on or off."
	myCheckButton5:SetScript("PostClick", 
	  function(self)		
		if self:GetChecked() then			
			IsGroupNotifying = true
		else			
			IsGroupNotifying = false
		end
	  end
	)
	
	myCheckButton6 = CreateFrame("CheckButton", "myCheckButton6_GlobalName", panel, "ChatConfigCheckButtonTemplate")
	myCheckButton6:SetPoint("TOPLEFT", 275, -105)
	myCheckButton6_GlobalNameText:SetText("  Enable Premade Group Invite Notifications")
	myCheckButton6.tooltip = "Click to toggle Premade Group Invite notifications on or off."
	myCheckButton6:SetScript("PostClick", 
	  function(self)		
		if self:GetChecked() then			
			IsPremadeNotifying = true
		else			
			IsPremadeNotifying = false
		end
	  end
	)
	
	myCheckButton7 = CreateFrame("CheckButton", "myCheckButton7_GlobalName", panel, "ChatConfigCheckButtonTemplate")
	myCheckButton7:SetPoint("TOPLEFT", 275, -145)
	myCheckButton7_GlobalNameText:SetText("  Enable Garrison Mission Complete Notifications")
	myCheckButton7.tooltip = "Click to toggle Garrison Mission Completion notifications on or off."
	myCheckButton7:SetScript("PostClick", 
	  function(self)		
		if self:GetChecked() then			
			IsMissionCompleteNotifying = true
		else			
			IsMissionCompleteNotifying = false
		end
	  end
	)
	
	myCheckButton8 = CreateFrame("CheckButton", "myCheckButton8_GlobalName", panel, "ChatConfigCheckButtonTemplate")
	myCheckButton8:SetPoint("TOPLEFT", 275, -185)
	myCheckButton8_GlobalNameText:SetText("  Enable Ready Check Notifications")
	myCheckButton8.tooltip = "Click to toggle Ready Check notifications on or off."
	myCheckButton8:SetScript("PostClick", 
	  function(self)		
		if self:GetChecked() then			
			IsReadyCheckNotifying = true
		else			
			IsReadyCheckNotifying = false
		end
	  end
	)
	
	myCheckButton9 = CreateFrame("CheckButton", "myCheckButton9_GlobalName", panel, "ChatConfigCheckButtonTemplate")
	myCheckButton9:SetPoint("TOPLEFT", 10, -225)
	myCheckButton9_GlobalNameText:SetText("  Enable AFK (20 minute warning) Notifications")
	myCheckButton9.tooltip = "Click to toggle AFK notifications on or off."
	myCheckButton9:SetScript("PostClick", 
	  function(self)		
		if self:GetChecked() then			
			IsAFKChecking = true
		else			
			IsAFKChecking = false
		end
	  end
	)
	--[[
	afkWarningText = CreateFrame("Messageframe", "afkWarningText_GlobalName", panel)
	afkWarningText:SetPoint("TOPLEFT", 10, -235)	--]]
	--fs = panel:CreateFontString()
	--fs:SetFont("Fonts\FRIZQT__.TTF", 11, "OUTLINE")
	--fs:SetText("If you use ElvUI, you'll need to disable AFK Mode for now.");
	
	fs = panel:CreateFontString("headerText" , "ARTWORK", "GameFontNormal");	
	fs:SetFont("Fonts\FRIZQT__.TTF", 11, "OUTLINE")
	fs:SetPoint("TOPLEFT", 10, -245);
	fs:SetText("If you use ElvUI, you'll need to disable AFK Mode for now.");
	
	fs = panel:CreateFontString("headerText" , "ARTWORK", "GameFontNormal");	
	fs:SetFont("Fonts\FRIZQT__.TTF", 11, "OUTLINE")
	fs:SetPoint("TOPLEFT", 10, -205);
	fs:SetText("Enable gxRestarts when in Fullscreen mode and Alt-Tab out.");
	
end

SLASH_WOWNOTIFIER1, SLASH_WOWNOTIFIER2 = '/wn', '/wownotifier'

SlashCmdList["WOWNOTIFIER"] = function(msg)		
	if msg == 'help' then
		print([[WoW Notifier Help:
/wn /wownotifier - Displays the current notification status.
/wn (on/off) - Disable or enable all notifications.
/wn (lfg/lfr) - Disable or enable LFG/LFR notifications.
/wn pet - Disable or enable Pet Battle notifications.
/wn pvp - Disable or enable Player versus Player notifications.
/wn gx - Disable or enable calling gxRestart for notifications.
/wn afk - Disable or enable AFK notifications.
/wn (rc/ready) - Disable or enable ready check notifications.
/wn (gm/missions) - Disable or enable Garrison Mission completion notifications.
/wn (pm/premade) - Disable or enable Premade Group invite notifications.
/wn (gp/group) - Disable or enable regular Group invite notifications.
/wn help - Show this message.
]]);
		return;
	end
	
	if msg == 'qr' then
		--TODO: QR Code Generation			
	end
	
	
		
	if msg == 'lfr' or msg == 'lfg' or msg == 'scenario' or msg == 'LFR' or msg == 'LFG' or msg == 'Senario' then
		if myCheckButton:GetChecked() then
			IsNotifying = false
			myCheckButton:SetChecked(IsNotifying);
			print("LFG/LFR Notifications disabled.");		
		else
			IsNotifying = true
			myCheckButton:SetChecked(IsNotifying);
			print("LFG/LFR Notifications enabled.");
		end
		return;
	end
	if msg == 'pet' or msg == 'Pet' or msg == 'pets' or msg == 'Pets' or msg == 'petbattles' or msg == 'PetBattles' then
		if myCheckButton2:GetChecked() then
			IsBattlePetNotifying = false
			myCheckButton2:SetChecked(IsBattlePetNotifying);
			print("Pet Battle Notifications disabled.");		
		else
			IsBattlePetNotifying = true
			myCheckButton2:SetChecked(IsBattlePetNotifying);
			print("Pet Battle Notifications enabled.");
		end
		return;
	end
	if msg == 'off' or msg == 'OFF' or msg == 'Off' or msg == 'disable' or msg == 'Disable' or msg == 'DISABLE' then
		IsNotifying = false
		myCheckButton:SetChecked(IsNotifying);
		IsBattlePetNotifying = false
		myCheckButton2:SetChecked(IsBattlePetNotifying);
		IsPVPNotifying = false
		myCheckButton3:SetChecked(IsPVPNotifying);		
		print('All notifications disabled.');
		return;
	end
	if msg == 'on' or msg == 'On' or msg == 'ON' or msg == 'enable' or msg == 'Enable' or msg == 'ENABLE' then
		IsNotifying = true
		myCheckButton:SetChecked(IsNotifying);
		IsBattlePetNotifying = true
		myCheckButton2:SetChecked(IsBattlePetNotifying);
		IsPVPNotifying = true
		myCheckButton3:SetChecked(IsPVPNotifying);
		print('All notifications enabled.');
		return;
	end
	if msg == 'pvp' or msg == 'PVP' or msg == 'PvP' then
		if myCheckButton3:GetChecked() then
			IsPVPNotifying = false
			myCheckButton3:SetChecked(IsPVPNotifying);
			print("PvP Notifications disabled.");		
		else
			IsPVPNotifying = true
			myCheckButton3:SetChecked(IsPVPNotifying);
			print("PvP Notifications enabled.");
		end
		return;
	end
	
	if msg == 'gx' or msg == 'GX' or msg == 'Gx' then
		if myCheckButton3:GetChecked() then
			IsgxRestarting = false
			myCheckButton4:SetChecked(IsgxRestarting);
			print("gxRestarts disabled.");		
		else
			IsgxRestarting = true
			myCheckButton4:SetChecked(IsgxRestarting);
			print("gxRestarts enabled.");
		end
		return;
	end
	
	if msg == "afk" or msg == "AFK" or msg == "Afk" then
		if myCheckButton9:GetChecked() then
			IsAFKChecking = false
			myCheckButton9:SetChecked(IsAFKChecking);
			print("AFK notification disabled.");		
		else
			IsAFKChecking = true
			myCheckButton9:SetChecked(IsAFKChecking);
			print("AFK notification enabled.");
		end
		return;
	end
	
	if msg == "gm" or msg == "GM" or msg == "Gm" or msg == "missions" then
		if myCheckButton7:GetChecked() then
			IsMissionCompleteNotifying = false
			myCheckButton7:SetChecked(IsMissionCompleteNotifying);
			print("Garrison mission notifications disabled.");		
		else
			IsMissionCompleteNotifying = true
			myCheckButton7:SetChecked(IsMissionCompleteNotifying);
			print("Garrison mission notifications enabled.");
		end
		return;
	end
	
	if msg == "group" or msg == "gp" then
		if myCheckButton5:GetChecked() then
			IsGroupNotifying = false
			myCheckButton5:SetChecked(IsGroupNotifying);
			print("Party invite notifications disabled.");		
		else
			IsGroupNotifying = true
			myCheckButton5:SetChecked(IsGroupNotifying);
			print("Party invite notifications enabled.");
		end
		return;
	end
	
	if msg == "premade" or msg == "pm" or msg == "pre" then
		if myCheckButton6:GetChecked() then
			IsPremadeNotifying = false
			myCheckButton6:SetChecked(IsPremadeNotifying);
			print("Premade invite notifications disabled.");		
		else
			IsPremadeNotifying = true
			myCheckButton6:SetChecked(IsPremadeNotifying);
			print("Premade invite notifications enabled.");
		end
		return;
	end
	
	if msg == "rc" or msg == "ready" or msg == "ready check" or msg == "check" then
		if myCheckButton8:GetChecked() then
			IsReadyCheckNotifying = false
			myCheckButton8:SetChecked(IsReadyCheckNotifying);
			print("Ready check notifications disabled.");		
		else
			IsReadyCheckNotifying = true
			myCheckButton8:SetChecked(IsReadyCheckNotifying);
			print("Ready check notifications enabled.");
		end
		return;
	end
	
	if IsNotifying then
		print ("LFG/LFR/Scenario Notificaions are currently enabled. Type /wn lfg to disable.");
	else
		print ("LFG/LFR/Scenario Notificaions are currently disabled. Type /wn lfg to enable.");
	end
	if IsBattlePetNotifying then
		print ("Pet Battle Notificaions are currently enabled. Type /wn pet to disable.");
	else
		print ("Pet Battle Notificaions are currently disabled. Type /wn pet to enable.");
	end
	if IsPVPNotifying then
		print ("PvP Notificaions are currently enabled. Type /wn pvp to disable.");
	else
		print ("PvP Notificaions are currently disabled. Type /wn pvp to enable.");
	end
	if IsgxRestarting then
		print ("gxRestarts are currently enabled. Type /wn gx to disable.");
	else
		print ("gxRestarts are currently disabled. Type /wn gx to enable.");
	end
	if IsMissionCompleteNotifying then
		print ("Garrison mission notifications are currently enabled. Type /wn gm to disable.");
	else
		print ("Garrison mission notifications are currently disabled. Type /wn gm to enable.");
	end
	if IsGroupNotifying then
		print ("Party invites are currently enabled. Type /wn gp to disable.");
	else
		print ("Party invites are currently disabled. Type /wn gp to enable.");
	end
	if IsPremadeNotifying then
		print ("Premade Group invites are currently enabled. Type /wn pre to disable.");
	else
		print ("Premade Group invites are currently disabled. Type /wn pre to enable.");
	end
	if IsReadyCheckNotifying then
		print ("Ready Check notifications are currently enabled. Type /wn rc to disable.");
	else
		print ("Ready Check notifications are currently disabled. Type /wn rc to enable.");
	end
	if IsAFKChecking then
		print ("AFK notifications are currently enabled. Type /wn afk to disable.");
	else
		print ("AFK notifications are currently disabled. Type /wn afk to enable.");
	end
	return true;
end