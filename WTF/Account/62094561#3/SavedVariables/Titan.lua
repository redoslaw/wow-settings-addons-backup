
TitanAll = {
	["OrderHall"] = true,
	["TimerAdjust"] = 1,
	["TimerPEW"] = 4,
	["TimerDualSpec"] = 2,
	["GlobalProfileName"] = "<>",
	["TimerLDB"] = 2,
	["TimerVehicle"] = 1,
	["Silenced"] = false,
	["GlobalProfileUse"] = false,
}
TitanSettings = {
	["Players"] = {
		["Tmgmage@Sargeras"] = {
			["Panel"] = {
				["FontSize"] = 10,
				["ButtonAlign"] = 1,
				["Scale"] = 1,
				["ScreenAdjust"] = false,
				["ButtonSpacing"] = 20,
				["Bar2_Transparency"] = 0.7,
				["AuxTransparency"] = 0.7,
				["TexturePath"] = "Interface\\AddOns\\Titan\\Artwork\\",
				["LockButtons"] = false,
				["BagAdjust"] = 1,
				["Buttons"] = {
					"XP", -- [1]
					"AutoHide_Bar", -- [2]
				},
				["Bar_Transparency"] = 0.7,
				["FrameStrata"] = "DIALOG",
				["Bar2_Hide"] = false,
				["Transparency"] = 0.7,
				["AuxBar2_Align"] = 1,
				["Location"] = {
					"Bar", -- [1]
					"Bar", -- [2]
				},
				["TooltipFont"] = 1,
				["LockAutoHideInCombat"] = false,
				["AuxBar_Transparency"] = 0.7,
				["Bar2_Show"] = false,
				["AuxBar_Align"] = 1,
				["Bar_Show"] = true,
				["AuxBar2_Hide"] = false,
				["VersionShown"] = 1,
				["AuxBar2_Transparency"] = 0.7,
				["AuxScreenAdjust"] = false,
				["TooltipTrans"] = 1,
				["MinimapAdjust"] = false,
				["AuxBar2_Show"] = false,
				["TicketAdjust"] = 1,
				["IconSpacing"] = 0,
				["ToolTipsShown"] = 1,
				["FontName"] = "Friz Quadrata TT",
				["Bar2_Align"] = 1,
				["HideTipsInCombat"] = false,
				["Bar_Hide"] = false,
				["Bar_Align"] = 1,
				["Position"] = 1,
				["AuxBar_Show"] = false,
				["DisableTooltipFont"] = 1,
				["AuxBar_Hide"] = false,
				["LogAdjust"] = false,
			},
			["Plugins"] = {
				["AutoHide_AuxBar2"] = {
					["DisplayOnRightSide"] = 1,
					["ForceBar"] = "AuxBar2",
				},
				["AutoHide_AuxBar"] = {
					["DisplayOnRightSide"] = 1,
					["ForceBar"] = "AuxBar",
				},
				["AutoHide_Bar2"] = {
					["DisplayOnRightSide"] = 1,
					["ForceBar"] = "Bar2",
				},
				["XP"] = {
					["UseSeperatorComma"] = true,
					["ShowSimpleRested"] = false,
					["UseSeperatorPeriod"] = false,
					["ShowLabelText"] = 1,
					["ShowSimpleNumOfKills"] = false,
					["ShowIcon"] = 1,
					["ShowSimpleNumOfGains"] = false,
					["ShowSimpleToLevel"] = false,
					["DisplayType"] = "ShowXPPerHourSession",
				},
				["BagnonLauncher"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["AutoHide_Bar"] = {
					["DisplayOnRightSide"] = 1,
					["ForceBar"] = "Bar",
				},
			},
			["Register"] = {
				["ToBeNum"] = 6,
				["TitanPlugins"] = {
					["AutoHide_AuxBar2"] = {
						["savedVariables"] = {
							["DisplayOnRightSide"] = 1,
							["ForceBar"] = "AuxBar2",
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["id"] = "AutoHide_AuxBar2",
						["menuText"] = "AutoHide_AuxBar2",
						["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
					},
					["AutoHide_AuxBar"] = {
						["savedVariables"] = {
							["DisplayOnRightSide"] = 1,
							["ForceBar"] = "AuxBar",
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["id"] = "AutoHide_AuxBar",
						["menuText"] = "AutoHide_AuxBar",
						["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
					},
					["AutoHide_Bar2"] = {
						["savedVariables"] = {
							["DisplayOnRightSide"] = 1,
							["ForceBar"] = "Bar2",
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["id"] = "AutoHide_Bar2",
						["menuText"] = "AutoHide_Bar2",
						["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
					},
					["XP"] = {
						["tooltipTextFunction"] = "TitanPanelXPButton_GetTooltipText",
						["id"] = "XP",
						["menuText"] = "XP",
						["savedVariables"] = {
							["UseSeperatorComma"] = true,
							["ShowSimpleRested"] = false,
							["UseSeperatorPeriod"] = false,
							["ShowLabelText"] = 1,
							["ShowSimpleNumOfKills"] = false,
							["ShowIcon"] = 1,
							["ShowSimpleNumOfGains"] = false,
							["ShowSimpleToLevel"] = false,
							["DisplayType"] = "ShowXPPerHourSession",
						},
						["controlVariables"] = {
							["ShowColoredText"] = false,
							["ShowIcon"] = true,
							["ShowRegularText"] = false,
							["DisplayOnRightSide"] = false,
							["ShowLabelText"] = true,
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["iconWidth"] = 16,
						["buttonTextFunction"] = "TitanPanelXPButton_GetButtonText",
						["tooltipTitle"] = "XP Info",
					},
					["BagnonLauncher"] = {
						["notes"] = "",
						["iconWidth"] = 16,
						["id"] = "BagnonLauncher",
						["menuText"] = "Bagnon",
						["savedVariables"] = {
							["ShowColoredText"] = false,
							["ShowIcon"] = true,
							["ShowRegularText"] = false,
							["DisplayOnRightSide"] = true,
							["ShowLabelText"] = true,
						},
						["controlVariables"] = {
							["ShowColoredText"] = false,
							["ShowIcon"] = false,
							["ShowRegularText"] = false,
							["DisplayOnRightSide"] = true,
							["ShowLabelText"] = true,
						},
						["buttonTextFunction"] = "TitanLDBShowText",
						["ldb"] = "launcher",
						["icon"] = "Interface\\Icons\\INV_Misc_Bag_07",
						["LDBVariables"] = {
							["type"] = "launcher",
							["name"] = "BagnonLauncher",
							["suffix"] = "",
							["value"] = "",
							["text"] = "78/104",
							["label"] = "Bagnon",
						},
					},
					["AutoHide_Bar"] = {
						["savedVariables"] = {
							["DisplayOnRightSide"] = 1,
							["ForceBar"] = "Bar",
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["id"] = "AutoHide_Bar",
						["menuText"] = "AutoHide_Bar",
						["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
					},
				},
				["ToBe"] = {
					{
						["self"] = {
							["registry"] = {
								["savedVariables"] = {
									["DisplayOnRightSide"] = 1,
									["ForceBar"] = "Bar",
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["id"] = "AutoHide_Bar",
								["menuText"] = "AutoHide_Bar",
								["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
							},
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "AutoHide_Bar",
						["category"] = "Built-ins",
						["button"] = "TitanPanelAutoHide_BarButton",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [1]
					{
						["self"] = {
							["registry"] = {
								["savedVariables"] = {
									["DisplayOnRightSide"] = 1,
									["ForceBar"] = "Bar2",
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["id"] = "AutoHide_Bar2",
								["menuText"] = "AutoHide_Bar2",
								["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
							},
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "AutoHide_Bar2",
						["category"] = "Built-ins",
						["button"] = "TitanPanelAutoHide_Bar2Button",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [2]
					{
						["self"] = {
							["registry"] = {
								["savedVariables"] = {
									["DisplayOnRightSide"] = 1,
									["ForceBar"] = "AuxBar2",
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["id"] = "AutoHide_AuxBar2",
								["menuText"] = "AutoHide_AuxBar2",
								["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
							},
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "AutoHide_AuxBar2",
						["category"] = "Built-ins",
						["button"] = "TitanPanelAutoHide_AuxBar2Button",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [3]
					{
						["self"] = {
							["registry"] = {
								["savedVariables"] = {
									["DisplayOnRightSide"] = 1,
									["ForceBar"] = "AuxBar",
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["id"] = "AutoHide_AuxBar",
								["menuText"] = "AutoHide_AuxBar",
								["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
							},
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "AutoHide_AuxBar",
						["category"] = "Built-ins",
						["button"] = "TitanPanelAutoHide_AuxBarButton",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [4]
					{
						["self"] = {
							["registry"] = {
								["tooltipTextFunction"] = "TitanPanelXPButton_GetTooltipText",
								["id"] = "XP",
								["menuText"] = "XP",
								["savedVariables"] = {
									["UseSeperatorComma"] = true,
									["ShowSimpleRested"] = false,
									["UseSeperatorPeriod"] = false,
									["ShowLabelText"] = 1,
									["ShowSimpleNumOfKills"] = false,
									["ShowIcon"] = 1,
									["ShowSimpleNumOfGains"] = false,
									["ShowSimpleToLevel"] = false,
									["DisplayType"] = "ShowXPPerHourSession",
								},
								["controlVariables"] = {
									["ShowColoredText"] = false,
									["ShowIcon"] = true,
									["ShowRegularText"] = false,
									["DisplayOnRightSide"] = false,
									["ShowLabelText"] = true,
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["iconWidth"] = 16,
								["buttonTextFunction"] = "TitanPanelXPButton_GetButtonText",
								["tooltipTitle"] = "XP Info",
							},
							["sessionTime"] = 1479239994,
							["totalTime"] = 77904.0200054152,
							["initXP"] = 346060,
							["levelTime"] = 68221.0200054152,
							["startSessionTime"] = 1479239994,
							["sessionXP"] = 0,
							["accumXP"] = 0,
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "XP",
						["category"] = "Built-ins",
						["button"] = "TitanPanelXPButton",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [5]
					{
						["self"] = {
							["registry"] = {
								["notes"] = "",
								["iconWidth"] = 16,
								["id"] = "BagnonLauncher",
								["menuText"] = "Bagnon",
								["savedVariables"] = {
									["ShowColoredText"] = false,
									["ShowIcon"] = true,
									["ShowRegularText"] = false,
									["DisplayOnRightSide"] = true,
									["ShowLabelText"] = true,
								},
								["controlVariables"] = {
									["ShowColoredText"] = false,
									["ShowIcon"] = false,
									["ShowRegularText"] = false,
									["DisplayOnRightSide"] = true,
									["ShowLabelText"] = true,
								},
								["buttonTextFunction"] = "TitanLDBShowText",
								["ldb"] = "launcher",
								["icon"] = "Interface\\Icons\\INV_Misc_Bag_07",
								["LDBVariables"] = {
									["type"] = "launcher",
									["name"] = "BagnonLauncher",
									["suffix"] = "",
									["value"] = "",
									["text"] = "78/104",
									["label"] = "Bagnon",
								},
							},
						},
						["notes"] = "",
						["plugin_type"] = "LDB: 'launcher'",
						["name"] = "BagnonLauncher",
						["category"] = "General",
						["button"] = "TitanPanelBagnonLauncherButton",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [6]
				},
				["Extras"] = {
				},
			},
		},
		["Alyyn@Sargeras"] = {
			["Panel"] = {
				["FontSize"] = 10,
				["ButtonAlign"] = 1,
				["Scale"] = 1,
				["ScreenAdjust"] = false,
				["ButtonSpacing"] = 20,
				["Bar2_Transparency"] = 0.7,
				["AuxTransparency"] = 0.7,
				["TexturePath"] = "Interface\\AddOns\\Titan\\Artwork\\",
				["LockButtons"] = false,
				["BagAdjust"] = 1,
				["Buttons"] = {
					"Location", -- [1]
					"XP", -- [2]
					"Gold", -- [3]
					"Clock", -- [4]
					"Volume", -- [5]
					"AutoHide_Bar", -- [6]
					"Bag", -- [7]
					"Repair", -- [8]
				},
				["Bar_Transparency"] = 0.7,
				["FrameStrata"] = "DIALOG",
				["Bar2_Hide"] = false,
				["Transparency"] = 0.7,
				["AuxBar2_Align"] = 1,
				["Location"] = {
					"Bar", -- [1]
					"Bar", -- [2]
					"Bar", -- [3]
					"Bar", -- [4]
					"Bar", -- [5]
					"Bar", -- [6]
					"Bar", -- [7]
					"Bar", -- [8]
				},
				["TooltipFont"] = 1,
				["LockAutoHideInCombat"] = false,
				["AuxBar_Transparency"] = 0.7,
				["Bar2_Show"] = false,
				["AuxBar_Align"] = 1,
				["Bar_Show"] = true,
				["AuxBar2_Hide"] = false,
				["VersionShown"] = 1,
				["AuxBar2_Transparency"] = 0.7,
				["AuxScreenAdjust"] = false,
				["TooltipTrans"] = 1,
				["MinimapAdjust"] = false,
				["AuxBar2_Show"] = false,
				["TicketAdjust"] = 1,
				["IconSpacing"] = 0,
				["ToolTipsShown"] = 1,
				["FontName"] = "Friz Quadrata TT",
				["Bar2_Align"] = 1,
				["HideTipsInCombat"] = false,
				["Bar_Hide"] = false,
				["Bar_Align"] = 1,
				["Position"] = 1,
				["AuxBar_Show"] = false,
				["DisableTooltipFont"] = 1,
				["AuxBar_Hide"] = false,
				["LogAdjust"] = false,
			},
			["Plugins"] = {
				["AnnounceIt"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["Mount"] = {
					["ShowMenuOptions"] = 1,
					["ShowIcon"] = 1,
					["ShowTooltipText"] = 1,
					["ShowAdvancedMenus"] = 1,
					["ShowLabelText"] = 1,
				},
				["PassLoot"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["Currency"] = {
					["DisplayOnRightSide"] = false,
				},
				["AskMrRobot"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["MrtWoo"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = true,
					["DisplayOnRightSide"] = false,
					["ShowLabelText"] = true,
				},
				["WeakAuras"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = true,
					["DisplayOnRightSide"] = false,
					["ShowLabelText"] = true,
				},
				["CharacterNotes"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["ItmC"] = {
					["ShowIcon"] = 1,
					["ShowItem"] = false,
					["debug"] = false,
					["ShowLabelText"] = false,
				},
				["AutoHide_Bar2"] = {
					["DisplayOnRightSide"] = 1,
					["ForceBar"] = "Bar2",
				},
				["TomTomPing"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = true,
					["DisplayOnRightSide"] = false,
					["ShowLabelText"] = true,
				},
				["CurrencyTracker"] = {
					["TokenHeaders"] = {
						"", -- [1]
					},
					["TipIconSize"] = 12,
					["ShowChanged"] = 1,
					["ShowCAP_Warn90"] = 1,
					["ShortGlamourAnnounce"] = false,
					["ShowAltSummarySpace"] = false,
					["ShowCAP_Warn75"] = 1,
					["ShowGlamourAnnounce"] = 1,
					["ShowAltSummary"] = 1,
					["ShowAnnounce"] = false,
					["AppendChanged"] = 1,
					["ShowCAP_Alert"] = 1,
					["ShowLog"] = false,
					["ShowSummary"] = 1,
					["BarIconSize"] = 20,
					["IconSize"] = 16,
					["ShowCAP"] = 1,
				},
				["Location"] = {
					["ShowColoredText"] = 1,
					["ShowZoneText"] = 1,
					["ShowCursorOnMap"] = true,
					["ShowLabelText"] = 1,
					["ShowLocOnMiniMap"] = 1,
					["ShowIcon"] = 1,
					["ShowCoordsOnMap"] = true,
					["CoordsFormat1"] = 1,
					["CoordsFormat2"] = false,
					["UpdateWorldmap"] = false,
					["CoordsFormat3"] = false,
				},
				["Paste"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["Repair"] = {
					["ShowColoredText"] = false,
					["IgnoreThrown"] = false,
					["AutoRepair"] = false,
					["DiscountFriendly"] = false,
					["ShowIcon"] = 1,
					["ShowDiscounts"] = true,
					["ShowDurabilityFrame"] = 1,
					["ShowUndamaged"] = false,
					["ShowPercentage"] = false,
					["DiscountRevered"] = false,
					["ShowInventory"] = false,
					["UseGuildBank"] = false,
					["ShowRepairCost"] = 1,
					["ShowLabelText"] = 1,
					["ShowCosts"] = true,
					["DiscountExalted"] = false,
					["ShowMostDmgPer"] = 1,
					["ShowItems"] = true,
					["AutoRepairReport"] = false,
					["DiscountHonored"] = false,
					["ShowPopup"] = false,
					["ShowMostDamaged"] = false,
				},
				["Bag"] = {
					["CountProfBagSlots"] = false,
					["ShowIcon"] = 1,
					["ShowUsedSlots"] = 1,
					["ShowColoredText"] = 1,
					["ShowDetailedInfo"] = false,
					["ShowLabelText"] = 1,
				},
				["AutoLog"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = true,
					["DisplayOnRightSide"] = false,
					["ShowLabelText"] = true,
				},
				["CurrencyTracking"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = true,
					["DisplayOnRightSide"] = false,
					["ShowLabelText"] = true,
				},
				["GuildSearch"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["AutoHide_Bar"] = {
					["DisplayOnRightSide"] = 1,
					["ForceBar"] = "Bar",
				},
				["Guild Recruitment"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = true,
					["DisplayOnRightSide"] = false,
					["ShowLabelText"] = true,
				},
				["AutoHide_AuxBar"] = {
					["DisplayOnRightSide"] = 1,
					["ForceBar"] = "AuxBar",
				},
				["LootType"] = {
					["RandomRoll"] = 100,
					["ShowIcon"] = 1,
					["ShowLabelText"] = 1,
					["DungeonDiffType"] = "AUTO",
					["ShowDungeonDiff"] = false,
				},
				["Speed"] = {
					["ShowOnlyX"] = false,
					["ShowPitch"] = 1,
					["ShowTenth"] = false,
					["ShowIcon"] = 1,
					["ShowLabelText"] = false,
				},
				["XP"] = {
					["UseSeperatorComma"] = true,
					["ShowSimpleRested"] = false,
					["UseSeperatorPeriod"] = false,
					["ShowLabelText"] = 1,
					["ShowSimpleNumOfKills"] = false,
					["ShowIcon"] = 1,
					["ShowSimpleNumOfGains"] = false,
					["ShowSimpleToLevel"] = false,
					["DisplayType"] = "ShowXPPerHourSession",
				},
				["ActionBarProfiles"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["TradeSkillMaster"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["Clock"] = {
					["HideMapTime"] = false,
					["ShowColoredText"] = false,
					["DisplayOnRightSide"] = 1,
					["OffsetHour"] = 0,
					["TimeMode"] = "Server",
					["Format"] = "12H",
					["HideGameTimeMinimap"] = false,
					["ShowLabelText"] = false,
				},
				["Performance"] = {
					["ShowAddonMemory"] = false,
					["ShowMemory"] = 1,
					["AddonMemoryType"] = 1,
					["ShowLatency"] = 1,
					["ShowWorldLatency"] = 1,
					["ShowLabelText"] = false,
					["ShowIcon"] = 1,
					["ShowAddonIncRate"] = false,
					["ShowColoredText"] = 1,
					["NumOfAddons"] = 5,
					["ShowFPS"] = 1,
				},
				["LDB_WhisperPop"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = true,
					["DisplayOnRightSide"] = false,
					["ShowLabelText"] = true,
				},
				["Gold"] = {
					["Initialized"] = true,
					["MergeServers"] = false,
					["SeparateServers"] = true,
					["DisplayGoldPerHour"] = true,
					["UseSeperatorComma"] = true,
					["ShowIcon"] = true,
					["ShowCoinLabels"] = true,
					["ShowLabelText"] = false,
					["ShowCoinIcons"] = false,
					["SortByName"] = true,
					["ViewAll"] = true,
					["gold"] = {
						["neg"] = false,
						["total"] = "112233",
					},
					["ShowGoldOnly"] = false,
					["ShowCoinNone"] = false,
					["UseSeperatorPeriod"] = false,
					["ShowColoredText"] = true,
				},
				["ExRT"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["GR"] = {
					["ShowIcon"] = 1,
					["ShowLabelText"] = false,
				},
				["AutoHide_AuxBar2"] = {
					["DisplayOnRightSide"] = 1,
					["ForceBar"] = "AuxBar2",
				},
				["Volume"] = {
					["VolumeMaster"] = 1,
					["DisplayOnRightSide"] = 1,
					["VolumeDialog"] = 0.5,
					["VolumeInboundChat"] = 1,
					["VolumeAmbience"] = 0.5,
					["VolumeSFX"] = 0.5,
					["VolumeMusic"] = 0.5,
					["VolumeOutboundChat"] = 1,
					["OverrideBlizzSettings"] = false,
				},
				["BagnonLauncher"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
				["RaidAchievement"] = {
					["ShowColoredText"] = false,
					["ShowIcon"] = true,
					["ShowRegularText"] = false,
					["DisplayOnRightSide"] = true,
					["ShowLabelText"] = true,
				},
			},
			["Register"] = {
				["ToBeNum"] = 7,
				["TitanPlugins"] = {
					["AutoHide_AuxBar2"] = {
						["savedVariables"] = {
							["DisplayOnRightSide"] = 1,
							["ForceBar"] = "AuxBar2",
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["id"] = "AutoHide_AuxBar2",
						["menuText"] = "AutoHide_AuxBar2",
						["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
					},
					["AutoHide_AuxBar"] = {
						["savedVariables"] = {
							["DisplayOnRightSide"] = 1,
							["ForceBar"] = "AuxBar",
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["id"] = "AutoHide_AuxBar",
						["menuText"] = "AutoHide_AuxBar",
						["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
					},
					["AskMrRobot"] = {
						["notes"] = "\nThis is a LDB 'launcher' without .label using .text instead!!!!",
						["iconWidth"] = 16,
						["id"] = "AskMrRobot",
						["menuText"] = "AskMrRobot",
						["savedVariables"] = {
							["ShowColoredText"] = false,
							["ShowIcon"] = true,
							["ShowRegularText"] = false,
							["DisplayOnRightSide"] = true,
							["ShowLabelText"] = true,
						},
						["controlVariables"] = {
							["ShowColoredText"] = false,
							["ShowIcon"] = false,
							["ShowRegularText"] = false,
							["DisplayOnRightSide"] = true,
							["ShowLabelText"] = true,
						},
						["version"] = "39",
						["buttonTextFunction"] = "TitanLDBShowText",
						["ldb"] = "launcher",
						["icon"] = "Interface\\AddOns\\AskMrRobot\\Media\\icon",
						["LDBVariables"] = {
							["type"] = "launcher",
							["name"] = "AskMrRobot",
							["suffix"] = "",
							["value"] = "",
							["text"] = "",
							["label"] = "Ask Mr. Robot",
						},
					},
					["AutoHide_Bar2"] = {
						["savedVariables"] = {
							["DisplayOnRightSide"] = 1,
							["ForceBar"] = "Bar2",
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["id"] = "AutoHide_Bar2",
						["menuText"] = "AutoHide_Bar2",
						["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
					},
					["BagnonLauncher"] = {
						["notes"] = "",
						["iconWidth"] = 16,
						["id"] = "BagnonLauncher",
						["menuText"] = "Bagnon",
						["savedVariables"] = {
							["ShowColoredText"] = false,
							["ShowIcon"] = true,
							["ShowRegularText"] = false,
							["DisplayOnRightSide"] = true,
							["ShowLabelText"] = true,
						},
						["controlVariables"] = {
							["ShowColoredText"] = false,
							["ShowIcon"] = false,
							["ShowRegularText"] = false,
							["DisplayOnRightSide"] = true,
							["ShowLabelText"] = true,
						},
						["buttonTextFunction"] = "TitanLDBShowText",
						["ldb"] = "launcher",
						["icon"] = "Interface\\Icons\\INV_Misc_Bag_07",
						["LDBVariables"] = {
							["type"] = "launcher",
							["name"] = "BagnonLauncher",
							["suffix"] = "",
							["value"] = "",
							["text"] = "24/104",
							["label"] = "Bagnon",
						},
					},
					["XP"] = {
						["tooltipTextFunction"] = "TitanPanelXPButton_GetTooltipText",
						["id"] = "XP",
						["menuText"] = "XP",
						["savedVariables"] = {
							["UseSeperatorComma"] = true,
							["ShowSimpleRested"] = false,
							["UseSeperatorPeriod"] = false,
							["ShowLabelText"] = 1,
							["ShowSimpleNumOfKills"] = false,
							["ShowIcon"] = 1,
							["ShowSimpleNumOfGains"] = false,
							["ShowSimpleToLevel"] = false,
							["DisplayType"] = "ShowXPPerHourSession",
						},
						["controlVariables"] = {
							["ShowColoredText"] = false,
							["ShowIcon"] = true,
							["ShowRegularText"] = false,
							["DisplayOnRightSide"] = false,
							["ShowLabelText"] = true,
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["iconWidth"] = 16,
						["buttonTextFunction"] = "TitanPanelXPButton_GetButtonText",
						["tooltipTitle"] = "XP Info",
					},
					["AutoHide_Bar"] = {
						["savedVariables"] = {
							["DisplayOnRightSide"] = 1,
							["ForceBar"] = "Bar",
						},
						["version"] = "5.9.4.70100",
						["category"] = "Built-ins",
						["id"] = "AutoHide_Bar",
						["menuText"] = "AutoHide_Bar",
						["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
					},
				},
				["ToBe"] = {
					{
						["self"] = {
							[0] = nil --[[ skipped userdata ]],
							["registry"] = {
								["savedVariables"] = {
									["DisplayOnRightSide"] = 1,
									["ForceBar"] = "Bar",
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["id"] = "AutoHide_Bar",
								["menuText"] = "AutoHide_Bar",
								["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
							},
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "AutoHide_Bar",
						["category"] = "Built-ins",
						["button"] = "TitanPanelAutoHide_BarButton",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [1]
					{
						["self"] = {
							[0] = nil --[[ skipped userdata ]],
							["registry"] = {
								["savedVariables"] = {
									["DisplayOnRightSide"] = 1,
									["ForceBar"] = "Bar2",
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["id"] = "AutoHide_Bar2",
								["menuText"] = "AutoHide_Bar2",
								["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
							},
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "AutoHide_Bar2",
						["category"] = "Built-ins",
						["button"] = "TitanPanelAutoHide_Bar2Button",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [2]
					{
						["self"] = {
							[0] = nil --[[ skipped userdata ]],
							["registry"] = {
								["savedVariables"] = {
									["DisplayOnRightSide"] = 1,
									["ForceBar"] = "AuxBar2",
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["id"] = "AutoHide_AuxBar2",
								["menuText"] = "AutoHide_AuxBar2",
								["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
							},
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "AutoHide_AuxBar2",
						["category"] = "Built-ins",
						["button"] = "TitanPanelAutoHide_AuxBar2Button",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [3]
					{
						["self"] = {
							[0] = nil --[[ skipped userdata ]],
							["registry"] = {
								["savedVariables"] = {
									["DisplayOnRightSide"] = 1,
									["ForceBar"] = "AuxBar",
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["id"] = "AutoHide_AuxBar",
								["menuText"] = "AutoHide_AuxBar",
								["tooltipTitle"] = "Toggles Titan Panel auto-hide on/off feature",
							},
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "AutoHide_AuxBar",
						["category"] = "Built-ins",
						["button"] = "TitanPanelAutoHide_AuxBarButton",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [4]
					{
						["self"] = {
							[0] = nil --[[ skipped userdata ]],
							["registry"] = {
								["tooltipTextFunction"] = "TitanPanelXPButton_GetTooltipText",
								["id"] = "XP",
								["menuText"] = "XP",
								["savedVariables"] = {
									["UseSeperatorComma"] = true,
									["ShowSimpleRested"] = false,
									["UseSeperatorPeriod"] = false,
									["ShowLabelText"] = 1,
									["ShowSimpleNumOfKills"] = false,
									["ShowIcon"] = 1,
									["ShowSimpleNumOfGains"] = false,
									["ShowSimpleToLevel"] = false,
									["DisplayType"] = "ShowXPPerHourSession",
								},
								["controlVariables"] = {
									["ShowColoredText"] = false,
									["ShowIcon"] = true,
									["ShowRegularText"] = false,
									["DisplayOnRightSide"] = false,
									["ShowLabelText"] = true,
								},
								["version"] = "5.9.4.70100",
								["category"] = "Built-ins",
								["iconWidth"] = 16,
								["buttonTextFunction"] = "TitanPanelXPButton_GetButtonText",
								["tooltipTitle"] = "XP Info",
							},
							["totalTime"] = 86755.6750726556,
							["initXP"] = 0,
							["startSessionTime"] = 1479300368,
							["accumXP"] = 309811,
							["levelTime"] = 90.5780029529706,
							["tooltipText"] = "Total Time Played: 	|cffffffff1d 0h 4m 42s|r\nTime Played This Level: 	|cffffffff17s|r\nTime Played This Session: 	|cffffffff38m 49s|r\n\nTotal XP Required This Level: 	|cffffffff717,000|r\nRested: 	|cffffffff0|r\nXP Gained This Level: 	|cffffffff0 (0.0%)|r\nXP Needed To Level: 	|cffffffff717,000 (100.0%)|r\nXP Gained This Session: 	|cffffffff309,811|r\nKills To Level (at 590 XP gained last): 	|cffffffff1,216|r\nXP Gains To Level (at 0 XP gained last): 	|cffffffffUnknown|r\n\nXP/HR This Level: 	|cffffffff0|r\nXP/HR This Session: 	|cffffffff478,883|r\nTime To Level (Level Rate): 	|cffffffffN/A|r\nTime To Level (Session Rate): 	|cffffffff1h 29m 50s|r",
							["sessionXP"] = 309811,
							["sessionTime"] = 1479300368,
							["tooltipTitle"] = "XP Info",
						},
						["notes"] = "",
						["plugin_type"] = "Titan",
						["name"] = "XP",
						["category"] = "Built-ins",
						["button"] = "TitanPanelXPButton",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [5]
					{
						["self"] = {
							[0] = nil --[[ skipped userdata ]],
							["registry"] = {
								["notes"] = "",
								["iconWidth"] = 16,
								["id"] = "BagnonLauncher",
								["menuText"] = "Bagnon",
								["savedVariables"] = {
									["ShowColoredText"] = false,
									["ShowIcon"] = true,
									["ShowRegularText"] = false,
									["DisplayOnRightSide"] = true,
									["ShowLabelText"] = true,
								},
								["controlVariables"] = {
									["ShowColoredText"] = false,
									["ShowIcon"] = false,
									["ShowRegularText"] = false,
									["DisplayOnRightSide"] = true,
									["ShowLabelText"] = true,
								},
								["buttonTextFunction"] = "TitanLDBShowText",
								["ldb"] = "launcher",
								["icon"] = "Interface\\Icons\\INV_Misc_Bag_07",
								["LDBVariables"] = {
									["type"] = "launcher",
									["name"] = "BagnonLauncher",
									["suffix"] = "",
									["value"] = "",
									["text"] = "24/104",
									["label"] = "Bagnon",
								},
							},
						},
						["notes"] = "",
						["plugin_type"] = "LDB: 'launcher'",
						["name"] = "BagnonLauncher",
						["category"] = "General",
						["button"] = "TitanPanelBagnonLauncherButton",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [6]
					{
						["self"] = {
							[0] = nil --[[ skipped userdata ]],
							["registry"] = {
								["notes"] = "\nThis is a LDB 'launcher' without .label using .text instead!!!!",
								["iconWidth"] = 16,
								["id"] = "AskMrRobot",
								["menuText"] = "AskMrRobot",
								["savedVariables"] = {
									["ShowColoredText"] = false,
									["ShowIcon"] = true,
									["ShowRegularText"] = false,
									["DisplayOnRightSide"] = true,
									["ShowLabelText"] = true,
								},
								["controlVariables"] = {
									["ShowColoredText"] = false,
									["ShowIcon"] = false,
									["ShowRegularText"] = false,
									["DisplayOnRightSide"] = true,
									["ShowLabelText"] = true,
								},
								["version"] = "39",
								["buttonTextFunction"] = "TitanLDBShowText",
								["ldb"] = "launcher",
								["icon"] = "Interface\\AddOns\\AskMrRobot\\Media\\icon",
								["LDBVariables"] = {
									["type"] = "launcher",
									["name"] = "AskMrRobot",
									["suffix"] = "",
									["value"] = "",
									["text"] = "",
									["label"] = "Ask Mr. Robot",
								},
							},
						},
						["notes"] = "\nThis is a LDB 'launcher' without .label using .text instead!!!!",
						["plugin_type"] = "LDB: 'launcher'",
						["name"] = "AskMrRobot",
						["category"] = "General",
						["button"] = "TitanPanelAskMrRobotButton",
						["issue"] = "",
						["isChild"] = false,
						["status"] = "|cff20ff20Registered|r",
					}, -- [7]
				},
				["Extras"] = {
					{
						["id"] = "AnnounceIt",
						["num"] = 1,
					}, -- [1]
					{
						["id"] = "Mount",
						["num"] = 2,
					}, -- [2]
					{
						["id"] = "PassLoot",
						["num"] = 3,
					}, -- [3]
					{
						["id"] = "Currency",
						["num"] = 4,
					}, -- [4]
					{
						["id"] = "MrtWoo",
						["num"] = 5,
					}, -- [5]
					{
						["id"] = "WeakAuras",
						["num"] = 6,
					}, -- [6]
					{
						["id"] = "CharacterNotes",
						["num"] = 7,
					}, -- [7]
					{
						["id"] = "ItmC",
						["num"] = 8,
					}, -- [8]
					{
						["id"] = "TomTomPing",
						["num"] = 9,
					}, -- [9]
					{
						["id"] = "CurrencyTracker",
						["num"] = 10,
					}, -- [10]
					{
						["id"] = "Location",
						["num"] = 11,
					}, -- [11]
					{
						["id"] = "Paste",
						["num"] = 12,
					}, -- [12]
					{
						["id"] = "Repair",
						["num"] = 13,
					}, -- [13]
					{
						["id"] = "Bag",
						["num"] = 14,
					}, -- [14]
					{
						["id"] = "AutoLog",
						["num"] = 15,
					}, -- [15]
					{
						["id"] = "CurrencyTracking",
						["num"] = 16,
					}, -- [16]
					{
						["id"] = "GuildSearch",
						["num"] = 17,
					}, -- [17]
					{
						["id"] = "Guild Recruitment",
						["num"] = 18,
					}, -- [18]
					{
						["id"] = "LootType",
						["num"] = 19,
					}, -- [19]
					{
						["id"] = "Speed",
						["num"] = 20,
					}, -- [20]
					{
						["id"] = "ActionBarProfiles",
						["num"] = 21,
					}, -- [21]
					{
						["id"] = "TradeSkillMaster",
						["num"] = 22,
					}, -- [22]
					{
						["id"] = "Clock",
						["num"] = 23,
					}, -- [23]
					{
						["id"] = "Performance",
						["num"] = 24,
					}, -- [24]
					{
						["id"] = "LDB_WhisperPop",
						["num"] = 25,
					}, -- [25]
					{
						["id"] = "Gold",
						["num"] = 26,
					}, -- [26]
					{
						["id"] = "ExRT",
						["num"] = 27,
					}, -- [27]
					{
						["id"] = "GR",
						["num"] = 28,
					}, -- [28]
					{
						["id"] = "Volume",
						["num"] = 29,
					}, -- [29]
					{
						["id"] = "RaidAchievement",
						["num"] = 30,
					}, -- [30]
				},
			},
		},
	},
	["Player"] = "Alyyn@Sargeras",
	["Version"] = "5.9.4.70100",
	["Profile"] = "Alyyn@Sargeras",
}
TitanSkins = {
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\",
		["name"] = "Titan Default",
	}, -- [1]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\BlackPlusOne Skin\\",
		["name"] = "BlackPlusOne",
	}, -- [2]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Christmas Skin\\",
		["name"] = "Christmas",
	}, -- [3]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Charcoal Metal\\",
		["name"] = "Charcoal Metal",
	}, -- [4]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Crusader Skin\\",
		["name"] = "Crusader",
	}, -- [5]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Cursed Orange Skin\\",
		["name"] = "Cursed Orange",
	}, -- [6]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Dark Wood Skin\\",
		["name"] = "Dark Wood",
	}, -- [7]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Deep Cave Skin\\",
		["name"] = "Deep Cave",
	}, -- [8]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Elfwood Skin\\",
		["name"] = "Elfwood",
	}, -- [9]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Engineer Skin\\",
		["name"] = "Engineer",
	}, -- [10]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Frozen Metal Skin\\",
		["name"] = "Frozen Metal",
	}, -- [11]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Graphic Skin\\",
		["name"] = "Graphic",
	}, -- [12]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Graveyard Skin\\",
		["name"] = "Graveyard",
	}, -- [13]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Hidden Leaf Skin\\",
		["name"] = "Hidden Leaf",
	}, -- [14]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Holy Warrior Skin\\",
		["name"] = "Holy Warrior",
	}, -- [15]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Nightlife Skin\\",
		["name"] = "Nightlife",
	}, -- [16]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Orgrimmar Skin\\",
		["name"] = "Orgrimmar",
	}, -- [17]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Plate Skin\\",
		["name"] = "Plate",
	}, -- [18]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\Tribal Skin\\",
		["name"] = "Tribal",
	}, -- [19]
	{
		["titan"] = true,
		["path"] = "Interface\\AddOns\\Titan\\Artwork\\Custom\\X-Perl\\",
		["name"] = "X-Perl",
	}, -- [20]
}
ServerTimeOffsets = {
}
ServerHourFormat = {
}
