SS_savedVariables = {
	-- {"var", defaultValue, "varToGetLiveValue"}
	SS_ScannerInterval = {"scantimer", 5, "SS_ScannerIntervalSlider"},
	SS_NotificationInterval = {"notificationtimer", 5, "SS_NotificationIntervalSlider"},
	SS_dbVersion = {"version", 7.17, "SS_addonVersion"},
	SS_raidWarnNotify = {"raidwarning", true, "SS_raidWarningButton"},
	SS_playSound = {"sounds", true, "SS_playSoundButton"},
	SS_satchelsReceived = {"satchels", 0, "SS_satchelsReceived"},
	SS_showUI = {"showMainFrame", true, "SS_showUI"},
	SS_scanInDungeon = {"scanInDungeon", false, "SS_scanInDungeonButton"},
	SS_scanInGroup = {"scanInGroup", false, "SS_scanInGroupButton"},	
	SS_hcDungeon1 = {"hcTank", true, "SS_heroicDungeonBox1"},
	SS_hcDungeon2 = {"hcHeal", true, "SS_heroicDungeonBox2"},
	SS_hcDungeon3 = {"hcDps", false, "SS_heroicDungeonBox3"},
	SS_mythicDungeon1 = {"mythicTank", false, "SS_mythicDungeonBox1"},
	SS_mythicDungeon2 = {"mythicHeal", false, "SS_mythicDungeonBox2"},
	SS_mythicDungeon3 = {"mythicDps", false, "SS_mythicDungeonBox3"},
	SS_timewalkingDungeon1 = {"timewalkTank", false, "SS_timewalkingDungeonBox1"},
	SS_timewalkingDungeon2 = {"timewalkHeal", false, "SS_timewalkingDungeonBox2"},
	SS_timewalkingDungeon3 = {"timewalkDps", false, "SS_timewalkingDungeonBox3"},
	SS_Darkbough1 = {"LFR1Tank", false, "SS_DarkboughBox1"},
	SS_Darkbough2 = {"LFR1Heal", false, "SS_DarkboughBox2"},
	SS_Darkbough3 = {"LFR1Dps", false, "SS_DarkboughBox3"},
	SS_TormentedGuardians1 = {"LFR2Tank", false, "SS_TormentedGuardiansBox1"},
	SS_TormentedGuardians2 = {"LFR2Heal", false, "SS_TormentedGuardiansBox2"},
	SS_TormentedGuardians3 = {"LFR2Dps", false, "SS_TormentedGuardiansBox3"},
	SS_RiftofAln1 = {"LFR3Tank", false, "SS_RiftofAlnBox1"},
	SS_RiftofAln2 = {"LFR3Heal", false, "SS_RiftofAlnBox2"},
	SS_RiftofAln3 = {"LFR3Dps", false, "SS_RiftofAlnBox3"},
	SS_TrialofValor1 = {"LFR4Tank", false, "SS_TrialofValorBox1"},
	SS_TrialofValor2 = {"LFR4Heal", false, "SS_TrialofValorBox2"},
	SS_TrialofValor3 = {"LFR4Dps", false, "SS_TrialofValorBox3"},
	SS_ArcingAqueducts1 = {"LFR5Tank", false, "SS_ArcingAqueductsBox1"},
	SS_ArcingAqueducts2 = {"LFR5Heal", false, "SS_ArcingAqueductsBox2"},
	SS_ArcingAqueducts3 = {"LFR5Dps", false, "SS_ArcingAqueductsBox3"},
	SS_RoyalAthenaeum1 = {"LFR6Tank", false, "SS_RoyalAthenaeumBox1"},
	SS_RoyalAthenaeum2 = {"LFR6Heal", false, "SS_RoyalAthenaeumBox2"},
	SS_RoyalAthenaeum3 = {"LFR6Dps", false, "SS_RoyalAthenaeumBox3"},
	SS_Nightspire1 = {"LFR7Tank", false, "SS_NightspireBox1"},
	SS_Nightspire2 = {"LFR7Heal", false, "SS_NightspireBox2"},
	SS_Nightspire3 = {"LFR7Dps", false, "SS_NightspireBox3"},
	SS_BetrayersRise1 = {"LFR8Tank", false, "SS_BetrayersRiseBox1"},
	SS_BetrayersRise2 = {"LFR8Heal", false, "SS_BetrayersRiseBox2"},
	SS_BetrayersRise3 = {"LFR8Dps", false, "SS_BetrayersRiseBox3"},
	SS_TidestonesRest1 = {"LFR9Tank", false, "SS_TidestonesRestBox1"},
	SS_TidestonesRest2 = {"LFR9Heal", false, "SS_TidestonesRestBox2"},
	SS_TidestonesRest3 = {"LFR9Dps", false, "SS_TidestonesRestBox3"},
	SS_WailingHalls1 = {"LFR10Tank", false, "SS_WailingHallsBox1"},
	SS_WailingHalls2 = {"LFR10Heal", false, "SS_WailingHallsBox2"},
	SS_WailingHalls3 = {"LFR10Dps", false, "SS_WailingHallsBox3"},
	SS_ChamberAvatar1 = {"LFR11Tank", false, "SS_ChamberAvatarBox1"},
	SS_ChamberAvatar2 = {"LFR11Heal", false, "SS_ChamberAvatarBox2"},
	SS_ChamberAvatar3 = {"LFR11Dps", false, "SS_ChamberAvatarBox3"},
	SS_DeceiversFall1 = {"LFR12Tank", false, "SS_DeceiversFallBox1"},
	SS_DeceiversFall2 = {"LFR12Heal", false, "SS_DeceiversFallBox2"},
	SS_DeceiversFall3 = {"LFR12Dps", false, "SS_DeceiversFallBox3"},
};

function SS_datacall(data)
	if not SatchelScannerDB then
		SatchelScannerDB = {};
		SS_datacall("reset");
	elseif data == "reset" then
		SatchelScannerDB = {};
		printmm("Your settings have been reset!");
		for i, var in pairs(SS_savedVariables) do
			if string.find(var[1], "satchels") and not (_G[var[1]] == nil) then
				SatchelScannerDB[var[1]] = _G[var[3]];
			else
				SatchelScannerDB[var[1]] = var[2];
			end
		end
		SS_datacall("read");
	elseif data == "update" then
		for i, var in pairs(SS_savedVariables) do
			if string.find(var[3], "Button") then
				SatchelScannerDB[var[1]] = _G[var[3]]:GetChecked();
			elseif string.find(var[3], "Box") then
				SatchelScannerDB[var[1]] = _G[var[3]]:GetChecked();
			elseif string.find(var[3], "Slider") then
				SatchelScannerDB[var[1]] = _G[var[3]]:GetValue();
			else
				SatchelScannerDB[var[1]] = _G[var[3]];
			end
		end
		SS_datacall("read");
	elseif SatchelScannerDB["version"] < 7.16 then
		_G["SS_satchelsReceived"] = SatchelScannerDB["satchels"];
		SS_datacall("reset");
	elseif data == "read" then
		for i, var in pairs(SS_savedVariables) do
			_G[i] = SatchelScannerDB[var[1]];
			if string.find(var[3], "Button") then
				_G[var[3]]:SetChecked(_G[i]);
			elseif string.find(var[3], "Box") then
				_G[var[3]]:SetChecked(_G[i]);
			elseif string.find(var[3], "Slider") then
				_G[var[3]]:SetValue(_G[i]);
			elseif string.find(var[3], "SS_satchelsReceived") then
				_G["SS_bagCounterText"]:SetText(_G[i]);
			elseif string.find(var[3], "showUI") then
				if SS_showUI then
					SatchelScannerDisplayWindow:Show();
				else
					SatchelScannerDisplayWindow:Hide();
				end
			end
		end
	else
		errorCollect("DATATABLE", data);
	end
end