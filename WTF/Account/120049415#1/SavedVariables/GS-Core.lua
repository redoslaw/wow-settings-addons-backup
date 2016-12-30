
GnomeOptions = {
	["use2"] = false,
	["STANDARDFUNCS"] = "|cff55ddcc",
	["COMMENT"] = "|cff55cc55",
	["use14"] = true,
	["EQUALS"] = "|cffccddee",
	["use11"] = false,
	["sendDebugOutputToChatWindow"] = false,
	["SequenceLibrary"] = {
		["Fire"] = {
			{
				"/cast !Ice Barrier", -- [1]
				"/cast !Combustion", -- [2]
				"/castsequence  reset=combat  Ice Floes", -- [3]
				"/castsequence  reset=combat  Fireball, Fireball, Fireball", -- [4]
				"/cast Fire Blast", -- [5]
				"/cast [nochanneling] Phoenix's Flames", -- [6]
				"/cast [nochanneling] Living Bomb", -- [7]
				["PostMacro"] = "/targetenemy [noharm][dead]\n",
				["author"] = "Kytie",
				["source"] = "Local",
				["version"] = 1,
				["PreMacro"] = "/targetenemy [noharm][dead]\n",
				["helpTxt"] = "Talents - 2133111",
				["specID"] = 63,
				["lang"] = "enUS",
				["icon"] = "Spell_Fire_FireBolt02",
			}, -- [1]
			{
				"/cast !Ice Barrier", -- [1]
				"/cast !Combustion", -- [2]
				"/castsequence  reset=combat  Fireball, Fireball, Fireball", -- [3]
				"/cast Fire Blast", -- [4]
				"/cast [nochanneling] Phoenix's Flames", -- [5]
				"/cast [nochanneling] Living Bomb", -- [6]
				["source"] = "Local",
				["author"] = "Redus@Burning Legion",
				["PostMacro"] = "/targetenemy [noharm][dead]\n",
				["lang"] = "enUS",
				["version"] = 2,
				["StepFunction"] = "  limit = limit or 1\n  if step == limit then\n    limit = limit % #macros + 1\n    step = 1\n  else\n    step = step % #macros + 1\n  end\n",
				["helpTxt"] = "Talents - 2133111",
				["specID"] = 63,
				["PreMacro"] = "/targetenemy [noharm][dead]\n",
				["icon"] = "INV_MISC_QUESTIONMARK",
			}, -- [2]
		},
	},
	["debug"] = false,
	["use6"] = false,
	["CommandColour"] = "|cFF00FF00",
	["UNKNOWN"] = "|cffff6666",
	["hideSoundErrors"] = false,
	["resetOOC"] = true,
	["STRING"] = "|cff888888",
	["requireTarget"] = false,
	["autoCreateMacroStubsGlobal"] = false,
	["autoCreateMacroStubsClass"] = true,
	["TitleColour"] = "|cFFFF0000",
	["useTranslator"] = false,
	["initialised"] = true,
	["filterList"] = {
		["Spec"] = true,
		["Class"] = true,
		["All"] = false,
	},
	["DebugModules"] = {
		["GS-SequenceTranslator"] = false,
		["GS-Core"] = true,
		["GS-SequenceEditor"] = false,
		["Transmission"] = false,
	},
	["INDENT"] = "|cffccaa88",
	["DisabledSequences"] = {
	},
	["ActiveSequenceVersions"] = {
		["DB_Frosty"] = 1,
		["DB_Arcane"] = 1,
		["DB_Prot_ST"] = 1,
		["DB_enhsingle"] = 1,
		["DB_Arms_ST"] = 1,
		["DB_Prot_AOE"] = 1,
		["DB_ENLegi"] = 1,
		["DB_DRoutlaw"] = 1,
		["DB_Fury3"] = 1,
		["DB_AFF2"] = 1,
		["DB_DF"] = 1,
		["DB_SurvivelH"] = 1,
		["DB_SquishyDK"] = 1,
		["DB_Fury4"] = 1,
		["DB_AFF"] = 1,
		["DB_BloodDK"] = 1,
		["DB_BMAOE"] = 1,
		["DB_Boomer"] = 1,
		["DB_Palla_Sera"] = 1,
		["DB_DemoAoE"] = 1,
		["DB_ProtWar"] = 1,
		["DB_Fury1"] = 1,
		["DB_Blood"] = 1,
		["DB_Feral-AoE"] = 1,
		["DB_AaslaanFire"] = 1,
		["DB_MC_ElemST"] = 1,
		["DB_KTNRestoBoom"] = 1,
		["DB_SURVST"] = 1,
		["DB_RetAoE_Raid"] = 1,
		["DB_KTN_DiscDeeps"] = 1,
		["DB_KTN_MouseOver"] = 1,
		["DB_BMaoe"] = 1,
		["DB_bear1"] = 1,
		["DB_havocsingle"] = 1,
		["DB_BMH"] = 1,
		["DB_Arms_AOE"] = 1,
		["DB_Assassin"] = 1,
		["DB_BM_ST"] = 1,
		["DB_bear2"] = 1,
		["DB_BrewMaster_AoE"] = 1,
		["DB_KTNDRUAOEHEALS"] = 1,
		["DB_Single_Marls"] = 1,
		["DB_HolyPriesty"] = 1,
		["DB_Ret_Raid"] = 1,
		["DB_Tank_Heal"] = 1,
		["DB_Fury2"] = 1,
		["DB_winsingle"] = 1,
		["DB_WW"] = 1,
		["DB_Disc-TDPS"] = 1,
		["DB_ShadowPriest"] = 1,
		["DB_EnhST"] = 1,
		["DB_BMsingle"] = 1,
		["DB_MC_Chain"] = 1,
		["DB_BrewMaster_ST"] = 1,
		["DB_Ichthys_Frosty"] = 1,
		["DB_DBFrost"] = 1,
		["Fire"] = 2,
		["DB_DiscDeeps"] = 1,
		["DB_Marks_AOE"] = 1,
		["DB_SURVAOE"] = 1,
		["DB_Destro"] = 1,
		["DB_HolyDeeps"] = 1,
		["DB_DHHavoc"] = 1,
		["DB_Disc-THeal"] = 1,
		["DB_CalliynOutlaw"] = 1,
		["DB_druid_bala_st"] = 1,
		["DB_Subtle"] = 1,
		["DB_feralsingle"] = 1,
		["DB_KTNDRUHEALS"] = 1,
		["DB_Mm_ST"] = 1,
		["DB_Disc-THealAoe"] = 1,
		["DB_ElemAoE"] = 1,
		["DB_Feral-ST"] = 1,
		["DB_DKunholy"] = 1,
		["DB_RestoBoomer"] = 1,
		["DB_Prot_ST2"] = 1,
		["DB_Demon"] = 1,
		["DB_feralaoe"] = 1,
		["DB_RestoDeeps"] = 1,
		["DB_Vengeance"] = 1,
		["DB_RetAoE"] = 1,
		["DB_MC_ElemAoE"] = 1,
		["DB_FDK2"] = 1,
		["DB_Fire"] = 1,
		["DB_DemoSingle"] = 1,
		["DB_MC_Wave"] = 1,
		["DB_MC_Surge"] = 1,
		["DB_Outlaw"] = 1,
		["DB_TLAssassin"] = 1,
		["DB_Ret"] = 1,
		["DB_Elem"] = 1,
	},
	["EmphasisColour"] = "|cFFFFFF00",
	["overflowPersonalMacros"] = false,
	["WOWSHORTCUTS"] = "|cffddaaff",
	["RealtimeParse"] = false,
	["deleteOrphansOnLogout"] = false,
	["clearUIErrors"] = false,
	["NUMBER"] = "|cffffaa00",
	["AuthorColour"] = "|cFF00D1FF",
	["seedInitialMacro"] = false,
	["hideUIErrors"] = false,
	["CONCAT"] = "|cffcc7777",
	["use12"] = false,
	["use13"] = true,
	["NormalColour"] = "|cFFFFFFFF",
	["KEYWORD"] = "|cff88bbdd",
	["saveAllMacrosLocal"] = true,
	["setDefaultIconQuestionMark"] = true,
	["sendDebugOutputGSDebugOutput"] = false,
	["use1"] = false,
}
