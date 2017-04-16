--/ This variable saving is so messy and will be remade once, sometime, somehow. It works, I just cant figure out how I want it to look like. But it works.

SS_savedVariables = {
	-- {"savedvar", defaultValue, "valueinherit"}
	SS_ScannerInterval = {"scantimer", 5, "SS_ScannerIntervalSlider"},
	SS_NotificationInterval = {"notificationtimer", 5, "SS_NotificationIntervalSlider"},
	SS_addonVersion = {"version", 7.19},
	SS_satchelsReceived = {"satchels", 0},
	SS_showUI = {"showMainFrame", true},
	-- Buttons
	SS_scanInDungeon = {"scanInDungeon", false, "SS_scanInDungeonButton"},
	SS_scanInGroup = {"scanInGroup", false, "SS_scanInGroupButton"},	
	SS_raidWarnNotify = {"raidwarning", true, "SS_raidWarningButton"},
	SS_playSound = {"sounds", true, "SS_playSoundButton"},
	-- Boxes
	SS_heroicDungeonBox1 = {"hcTank", true},
	SS_heroicDungeonBox2 = {"hcHeal", true},
	SS_heroicDungeonBox3 = {"hcDps", false},
	SS_timewalkingDungeonBox1 = {"timewalkTank", false},
	SS_timewalkingDungeonBox2 = {"timewalkHeal", false},
	SS_timewalkingDungeonBox3 = {"timewalkDps", false},
	SS_DarkboughBox1 = {"LFR1Tank", false},
	SS_DarkboughBox2 = {"LFR1Heal", false},
	SS_DarkboughBox3 = {"LFR1Dps", false},
	SS_TormentedGuardiansBox1 = {"LFR2Tank", false},
	SS_TormentedGuardiansBox2 = {"LFR2Heal", false},
	SS_TormentedGuardiansBox3 = {"LFR2Dps", false},
	SS_RiftofAlnBox1 = {"LFR3Tank", false},
	SS_RiftofAlnBox2 = {"LFR3Heal", false},
	SS_RiftofAlnBox3 = {"LFR3Dps", false},
	SS_TrialofValorBox1 = {"LFR4Tank", false},
	SS_TrialofValorBox2 = {"LFR4Heal", false},
	SS_TrialofValorBox3 = {"LFR4Dps", false},
	SS_ArcingAqueductsBox1 = {"LFR5Tank", false},
	SS_ArcingAqueductsBox2 = {"LFR5Heal", false},
	SS_ArcingAqueductsBox3 = {"LFR5Dps", false},
	SS_RoyalAthenaeumBox1 = {"LFR6Tank", false},
	SS_RoyalAthenaeumBox2 = {"LFR6Heal", false},
	SS_RoyalAthenaeumBox3 = {"LFR6Dps", false},
	SS_NightspireBox1 = {"LFR7Tank", false},
	SS_NightspireBox2 = {"LFR7Heal", false},
	SS_NightspireBox3 = {"LFR7Dps", false},
	SS_BetrayersRiseBox1 = {"LFR8Tank", false},
	SS_BetrayersRiseBox2 = {"LFR8Heal", false},
	SS_BetrayersRiseBox3 = {"LFR8Dps", false},
	SS_TidestonesRestBox1 = {"LFR9Tank", false},
	SS_TidestonesRestBox2 = {"LFR9Heal", false},
	SS_TidestonesRestBox3 = {"LFR9Dps", false},
	SS_WailingHallsBox1 = {"LFR10Tank", false},
	SS_WailingHallsBox2 = {"LFR10Heal", false},
	SS_WailingHallsBox3 = {"LFR10Dps", false},
	SS_ChamberAvatarBox1 = {"LFR11Tank", false},
	SS_ChamberAvatarBox2 = {"LFR11Heal", false},
	SS_ChamberAvatarBox3 = {"LFR11Dps", false},
	SS_DeceiversFallBox1 = {"LFR12Tank", false},
	SS_DeceiversFallBox2 = {"LFR12Heal", false},
	SS_DeceiversFallBox3 = {"LFR12Dps", false},
};

function SS_datacall(data)
	if not SatchelScannerDB then
		SatchelScannerDB = {};
		SS_datacall("reset");
	elseif data == "reset" then
		SatchelScannerDB = {};
		SS_printmm("Your settings have been reset!");
		for i, var in pairs(SS_savedVariables) do
			if string.find(var[1], "satchels") and not (_G[var[1]] == nil) then
				SatchelScannerDB[var[1]] = _G[i];
			else
				SatchelScannerDB[var[1]] = var[2];
			end
		end
		SS_datacall("read");
	elseif data == "update" then
		for i, var in pairs(SS_savedVariables) do
			if string.find(var[3] or "", "Button") then
				SatchelScannerDB[var[1]] = _G[var[3]]:GetChecked();
			elseif string.find(i, "Box") then
				SatchelScannerDB[var[1]] = _G[i]:GetChecked();
			elseif string.find(var[3] or "", "Slider") then
				SatchelScannerDB[var[1]] = _G[var[3]]:GetValue();
			else
				SatchelScannerDB[var[1]] = _G[i];
			end
		end
		SatchelScannerDB["showMainFrame"] = SS_showUI;
		SS_datacall("read");
	elseif SatchelScannerDB["version"] < 7.16 then
		_G["SS_satchelsReceived"] = SatchelScannerDB["satchels"];
		SS_datacall("reset");
	elseif data == "read" then
		for i, var in pairs(SS_savedVariables) do
			if string.find(var[3] or "", "Button") then
				_G[i] = SatchelScannerDB[var[1]];
				_G[var[3]]:SetChecked(_G[i]);
			elseif string.find(i, "Box") then
				_G[i]:SetChecked(SatchelScannerDB[var[1]]);
			elseif string.find(var[3] or "", "Slider") then
				_G[i] = SatchelScannerDB[var[1]];
				_G[var[3]]:SetValue(_G[i]);
			elseif string.find(i, "SS_satchelsReceived") then
				_G[i] = SatchelScannerDB[var[1]];
				_G["SS_bagCounterText"]:SetText(_G[i]);
			elseif string.find(i, "showUI") then
				_G[i] = SatchelScannerDB[var[1]];
				if SS_showUI then
					SatchelScannerDisplayWindow:Show();
				else
					SatchelScannerDisplayWindow:Hide();
				end
			end
		end
	else
		SS_errorCollect("DATATABLE", data);
	end
end