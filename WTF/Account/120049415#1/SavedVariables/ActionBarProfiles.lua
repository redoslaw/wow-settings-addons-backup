
ActionBarProfilesDBv3 = {
	["profileKeys"] = {
		["Redbullek - Burning Legion"] = "DRUID",
		["Redus - Burning Legion"] = "MAGE",
		["Ðeadshot - Burning Legion"] = "HUNTER",
		["Ðeathshot - Steamwheedle Cartel"] = "HUNTER",
		["Kot - Chamber of Aspects"] = "DRUID",
	},
	["profiles"] = {
		["MAGE"] = {
			["list"] = {
				["Prolongi"] = {
					["talents"] = {
						"|cff71d5ff|Htalent:22459|h[Conflagration]|h|r", -- [1]
						"|cff71d5ff|Htalent:22442|h[Shimmer]|h|r", -- [2]
						"|cff71d5ff|Htalent:22445|h[Rune of Power]|h|r", -- [3]
						"|cff71d5ff|Htalent:22465|h[Flame On]|h|r", -- [4]
						"|cff71d5ff|Htalent:22446|h[Ice Floes]|h|r", -- [5]
						"|cff71d5ff|Htalent:22451|h[Living Bomb]|h|r", -- [6]
						"|cff71d5ff|Htalent:21631|h[Kindling]|h|r", -- [7]
					},
					["name"] = "Prolongi",
					["icon"] = "Interface\\Icons\\Spell_Fire_FireBolt02",
					["macros"] = {
						"|cffff0000|Habp:macro:644389:/click GoGoButton2~0a:1|h[# Mount Z Buta]|h|r", -- [1]
						"|cffff0000|Habp:macro:132247:/cancelaura enveloping mist~0a/cancelaura Life Cocoon~0a/cancelaura Ice Barrier~0a/cancelaura Renewing Mist~0a:1|h[###KILL]|h|r", -- [2]
						"|cffff0000|Habp:macro:669468:#showtooltip Combustion~0a/stopcasting~0a/cast Combustion~0a/use 12~0a/use 13~0a/use 14~0a/use ~5bmodifier~3aalt~5d Potion of Deadly Grace~0a/cast ~5bmodifier~3ashift~5d Time Warp~0a:1|h[###MAGE RAID]|h|r", -- [3]
						"|cffff0000|Habp:macro:132853:/cast ~5b@mouseover~5d disenchant~0a:1|h[#DISENCHANT]|h|r", -- [4]
						"|cffff0000|Habp:macro:134400:/click JambaFTLAssist~0a:1|h[#DLA ALTA]|h|r", -- [5]
						"|cffff0000|Habp:macro:413580:/jamba-follow strobeonme all~0a:1|h[#FOLLOW]|h|r", -- [6]
						"|cffff0000|Habp:macro:133564:/jamba-follow strobeonme all~0a/jamba-follow strobeoff all~0a:1|h[#stop follow]|h|r", -- [7]
						"|cffff0000|Habp:macro:134302:#showtooltip Speckled Tastyfish~0a/fishing~0a:1|h[AAAA ILE RYBEK]|h|r", -- [8]
						"|cffff0000|Habp:macro:134400:/follow Ðeadshot~0a/assist Ðeadshot~0a/startattack~0a:1|h[AAAA### MULTIBOX]|h|r", -- [9]
						"|cffff0000|Habp:macro:413580:#showtooltip Fishing~0a/cancelform~0a/dismount~0a/use Anglers Fishing Raft~0a/equip Fishing Pole~0a/run UIErrorsFrame~3aClear()~0a/cast Fishing~0a:1|h[AAAAAAAAAAAAAAAA]|h|r", -- [10]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/targetenemy ~5bdead~5d~5bnoexists~5d~5bnoharm~5d~0a/cancelaura Deterrence~0a/cancelaura hand of protection~0a/cast Aimed Shot~0a:1|h[Aimed Shot]|h|r", -- [11]
						"|cffff0000|Habp:macro:133780:/poll new KONTYNUACJA RAIDU (DLA CHETNYCH) JESZCZE PRZED RESETEM~0a/poll item ~5bPN~5d~0a/poll item ~5bWT~5d~0a/poll item ~5bPN + WT = 2 dni~5d~0a/poll item ~5bODPADAM~5d~0a/poll channel raid~0a/poll start 0 20~0a:1|h[ANKIETA]|h|r", -- [12]
						"|cffff0000|Habp:macro:132847:/poll results~0a/poll send~0a:1|h[ANKIETA SHOW]|h|r", -- [13]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/cast ~5bnomodifier~5d Aspect of the Cheetah~0a/cancelaura ~5bmodifier~3aalt~5d Aspect of the Cheetah~0a:1|h[ASPECT]|h|r", -- [14]
						"|cffff0000|Habp:macro:134400:/cast Arcane Shot~0a:1|h[BARN Arcane Shot]|h|r", -- [15]
						"|cffff0000|Habp:macro:134400:/statattack~0a/stopattack~0a:1|h[BARN Autoattack]|h|r", -- [16]
						"|cffff0000|Habp:macro:135727:/cast Berserking~0a/cast Blood Fury~0a/use 13~0a:1|h[BUFF]|h|r", -- [17]
						"|cffff0000|Habp:macro:136010:/rt check buffschat~0a:1|h[BUFF-CHECK]|h|r", -- [18]
						"|cffff0000|Habp:macro:134400::1|h[CANCEL MACRO]|h|r", -- [19]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/targetenemy ~5bdead~5d~5bnoexists~5d~5bnoharm~5d~0a/cancelaura Deterrence~0a/cancelaura hand of protection~0a/cast Chimaera Shot~0a:1|h[Chimaera Shot]|h|r", -- [20]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/stopcasting~0a/cancelaura Deterrence~0a/cast Concussive Shot~0a/cast Growl~0a:1|h[Concussive Shot]|h|r", -- [21]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/cancelaura Deterrence~0a/cast ~5bnomodifier~5d Deterrence~0a/cast ~5bmodifier~3aalt~5d Feign Death~0a/cast ~5bmodifier~3actrl~5d Feign Death~0a:1|h[Deterrence]|h|r", -- [22]
						"|cffff0000|Habp:macro:645142:/click ClickMeForWorkDisenchanting~0a:1|h[Disenchantus]|h|r", -- [23]
						"|cffff0000|Habp:macro:134400:#showtooltip Gorefiend's Grasp~0a/cast ~5b@player~5d Gorefiend's Grasp~0a:1|h[DK: Gorefiend's]|h|r", -- [24]
						"|cffff0000|Habp:macro:134400:#showtooltip Death Coil~0a/cast Death Coil~0a/cast Blood Tap~0a/script UIErrorsFrame~3aClear();~0a:1|h[DK:DC+BT]|h|r", -- [25]
						"|cffff0000|Habp:macro:132623:/target  Ghostly Pandaren Fisherman~0a:1|h[FISHING]|h|r", -- [26]
						"|cffff0000|Habp:macro:132932:#showtooltip Fishing~0a/fb fishing start~0a/cast  ~5bnochanneling~3aFishing~5d Fishing~0a:1|h[FishingBuddy]|h|r", -- [27]
						"|cffff0000|Habp:macro:464778:/run ShowHelm(not ShowingHelm())~0a:1|h[GLOWA]|h|r", -- [28]
						"|cffff0000|Habp:macro:1100022:/script SetRaidTargetIcon(\"Razerix\", 6 )~0a/script SetRaidTargetIcon(\"Panidoktor\", 4 )~0a:1|h[HEAL i TANK]|h|r", -- [29]
						"|cffff0000|Habp:macro:135939:/way Undercity 78.34 76.38 Heirloomy w Undercity (+upgrade)~0a:1|h[HEIRLOOMY]|h|r", -- [30]
						"|cffff0000|Habp:macro:413590:/target focus~0a/click ExtraActionButton1~0a/targetlasttarget~0a:1|h[HoF]|h|r", -- [31]
						"|cffff0000|Habp:macro:134400:#showtooltip ~5bmodifier~3ashift~5d ~5bmodifier~3aalt~5d Mend Pet; Dire Beast; Mend Pet~0a/cast ~5bmodifier~3ashift~5d Mend Pet~0a/cast ~5bmodifier~3aalt~5d Mend Pet~0a/cast ~5bnomodifier~5d Dire Beast~0a:1|h[HUNTER: Bestia]|h|r", -- [32]
						"|cffff0000|Habp:macro:134400:#showtooltip Master's Call~0a/cast ~5b@player~5d Master's Call~0a:1|h[HUNTER: CALL]|h|r", -- [33]
						"|cffff0000|Habp:macro:134400:/cast ~5bnomodifier~5d Focus Fire~0a/cast ~5bmodifier~3ashift~5d Camouflage~0a/cast ~5bmodifier~3aalt~5d Camouflage~0a:1|h[HUNTER: FF/CAMO]|h|r", -- [34]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/cast ~5bmodifier~3aalt~5d Tranquilizing Shot~0a/cast ~5bmodifier~3ashift~5d Concussive Shot~0a/cast ~5bnomodifier~5d Counter Shot~0a:1|h[HUNTER: Interrup]|h|r", -- [35]
						"|cffff0000|Habp:macro:134400:#showtooltip Kill Command~0a/cast Bestial Wrath~0a/cast Kill Command~0a/petattack~0a:1|h[HUNTER: Kill Com]|h|r", -- [36]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/cancelaura Deterrence~0a#/stopcasting~0a#/stopcasting~0a/cast Kill Shot~0a:1|h[HUNTER: Kill Sho]|h|r", -- [37]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/cast ~5bmodifier~3ashift~5d Aspect of the Cheetah~0a/cast ~5bmodifier~3aalt~5d Aspect of the Cheetah~0a/cast ~5bnomodifier~5d Disengage~0a:1|h[HUNTER: MOVE]|h|r", -- [38]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/cast ~5bmodifier~3aalt~5d Shadowmeld~0a/cast ~5bnomodifier~5d Feign Death~0a:1|h[HUNTER: RUN AWAY]|h|r", -- [39]
						"|cffff0000|Habp:macro:134400:#showtooltip ~5bmodifier~3ashift~5d ~5bmodifier~3aalt~5d Mend Pett; Mend Pet~0a/cast ~5bmodifier~3ashift~5d Mend Pet~0a/cast ~5bmodifier~3aalt~5d Mend Pet~0a/cast ~5bnomodifier~5d Dire Beast~0a:1|h[HUNTER: SURVI]|h|r", -- [40]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/cast ~5bmodifier~3aalt~5d Freezing Trap~0a/cast ~5bmodifier~3ashift~5d Ice Trap~0a/cast ~5bnomodifier~5d Explosive Trap~0a:1|h[HUNTER: TRAP]|h|r", -- [41]
						"|cffff0000|Habp:macro:252184:/run IFT();~0a:1|h[IfThen_Btn]|h|r", -- [42]
						"|cffff0000|Habp:macro:134143:/run ShowHelm(not ShowingHelm())~0a:1|h[LEB]|h|r", -- [43]
						"|cffff0000|Habp:macro:134400:#showtooltip ~0a/select ~5bnopet~5d spell~3aLone;Dismiss Pet~0a/click ~5bbtn~3a2~5dS127M;S127A~0a:1|h[Lone Wolf]|h|r", -- [44]
						"|cffff0000|Habp:macro:236206:/way Talador 70.36 56.99 Farma Drzewek lvl 2~0a:1|h[LUMBER FARM 2]|h|r", -- [45]
						"|cffff0000|Habp:macro:135856:/stopcasting~0a/cast ~5b@focus~5d Counterspell~0a:1|h[MAGE: #Countersp]|h|r", -- [46]
						"|cffff0000|Habp:macro:236216:#showtooltip Inferno Blast~0a#/stopcasting~0a/cast Inferno Blast~0a:1|h[MAGE: #Inferno B]|h|r", -- [47]
						"|cffff0000|Habp:macro:135729:/stopcasting~0a/cast ~5b@focus~5d Spellsteal~0a:1|h[MAGE: #Spellstea]|h|r", -- [48]
						"|cffff0000|Habp:macro:135739:/stopcasting~0a/cast Blink~0a:1|h[MAGE: Blink]|h|r", -- [49]
						"|cffff0000|Habp:macro:236220:#showtooltip Living Bomb~0a#/stopcasting~0a/cast Living Bomb~0a:1|h[MAGE: FOCUS LB]|h|r", -- [50]
						"|cffff0000|Habp:macro:134400:/cast ~5bmodifier~3aalt~5d Presence of Mind~0a/cast ~5bnomodifier~3aalt~5d Frostbolt~0a:1|h[MAGE: Frostbolt]|h|r", -- [51]
						"|cffff0000|Habp:macro:134400:/cast ~5b@focus, help~5d ~5b@pet, nodead, exists~5d ~0a/cast ~5b@focus, help~5d ~5b@pet, nodead, exists~5d ~0a:1|h[Mend Pet]|h|r", -- [52]
						"|cffff0000|Habp:macro:132180:#showtooltip~0a/cast ~5b@Roys~5d Misdirection~0a:1|h[Missdirection]|h|r", -- [53]
						"|cffff0000|Habp:macro:413588:/mountspecial~0a:1|h[MOUNT SPECIAL]|h|r", -- [54]
						"|cffff0000|Habp:macro:134400:#showtooltip Multi-Shot~0a/cast ~5b@focus, help~5d ~5b@pet, nodead, exists~5d Misdirection~0a/cast Multi-Shot~0a:1|h[Multi-shot]|h|r", -- [55]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/cancelaura Aspect of the turtle~0a/cast Rapid Fire~0a/use 12~0a/cast Berserking~0a/cast Trueshot~0a/cancelaura ~5bmodifier~3aalt~5d Deterrence~0a/cast ~5bmodifier~3aalt~5d Rapid Fire~0a/cast ~5bmodifier~3aalt~5d Berserking~0a:1|h[ODPALKA]|h|r", -- [56]
						"|cffff0000|Habp:macro:135988:/cast ~5bmodifier~3aalt~5d Presence of Mind~0a/cast ~5bnomodifier~3aalt~5d Ice Barrier~0a:1|h[Placek/tarcza]|h|r", -- [57]
						"|cffff0000|Habp:macro:134400:#showtooltip Presence of Mind~0a/cast Presence of Mind~0a/cast Frostbolt~0a:1|h[Presence of MInd]|h|r", -- [58]
						"|cffff0000|Habp:macro:136094:/run for k,v in pairs({deathtalon=39287, terrorfist=39288, doomroller=39289, vengeance=39290}) do print(format(\"%s~3a %s\", k, IsQuestFlaggedCompleted(v) and \"\\124cFFFF0000Completed\\124r\" or \"\\124cFF00FF00Not completed yet\\124r\")) end~0a:1|h[RARE TANAN CHECK]|h|r", -- [59]
						"|cffff0000|Habp:macro:134268:/reload~0a:1|h[RELOAD]|h|r", -- [60]
						"|cffff0000|Habp:macro:135827:/cast ~5bmodifier~3aalt~5d Fire Blast~0a/cast ~5bnomodifier~3aalt~5d Scorch~0a:1|h[scroach]|h|r", -- [61]
						"|cffff0000|Habp:macro:134400:#showtooltip~0a/cancelaura Deterrence~0a/cancelaura hand of protection~0a/cast Cobra Shot~0a:1|h[Steady Shot]|h|r", -- [62]
						"|cffff0000|Habp:macro:134400:#showtooltip ~5bmodifier~3ashift~5d ~5bmodifier~3aalt~5d Mend Pet; Explosive Trap; Mend Pet~0a/cast ~5bmodifier~3ashift~5d Mend Pet~0a/cast ~5bmodifier~3aalt~5d Mend Pet~0a/cast ~5bnomodifier~5d Explosive Trap~0a:1|h[SURVI]|h|r", -- [63]
						"|cffff0000|Habp:macro:236847:/way Tanaan Jungle 47, 52 Doomroller~0a/way Tanaan Jungle 15, 63 Terror fist~0a/way Tanaan Jungle 32, 73 Vengence~0a/way Tanaan Jungle 24 40 Deathtalon~0a:1|h[TANAN BOSSES]|h|r", -- [64]
						"|cffff0000|Habp:macro:236179:/targetenemy ~5bdead~5d~5bnoexists~5d ~0a:1|h[TARGET]|h|r", -- [65]
						"|cffff0000|Habp:macro:134400:/target Arctic Grizzly~0a/script if UnitHealth(\"Arctic Grizzly\")==0 and UnitExists(\"Arctic Grizzly\") then ClearTarget(); end~0a:1|h[Test]|h|r", -- [66]
						"|cffff0000|Habp:macro:1032149:/tgf enable~0a/tgf distance~0a/tgf killed~0a:1|h[TGF]|h|r", -- [67]
						"|cffff0000|Habp:macro:134400:#showtooltip Flame Orb~0a/cast Flame Orb~0a/use 14~0a/cast Arcane Power~0a/cast Flame Orb~0a|h[#LivingBomb]|h|r", -- [68]
						"|cffff0000|Habp:macro:236220:#showtooltip~0a/cast ~5bmodifier~3actr;~5d Cinderstorm~0a/cast ~5bnomodifier~3actrl~5d Living Bomb~0a|h[AoE]|h|r", -- [69]
						"|cffff0000|Habp:macro:458224:#showtooltip Time Warp~0a/cast Time Warp~0a/use Volcanic Potion~0a|h[BL]|h|r", -- [70]
						"|cffff0000|Habp:macro:135739:/cast Blink~0a|h[BLINK]|h|r", -- [71]
						"|cffff0000|Habp:macro:252188:#showtooltip Arcane Explosion~0a/castsequence Arcane Explosion, Arcane Explosion, Arcane Explosion, Mana Shield, Arcane Explosion, Arcane Explosion, Arcane Explosion, Arcane Explosion, Arcane Explosion, Arcane Explosion, Arcane Explosion, Mage Armor~0a|h[Bracki]|h|r", -- [72]
						"|cffff0000|Habp:macro:237446:/way Townlong Steppes 49 70 Shado-pan~0a|h[DAILY]|h|r", -- [73]
						"|cffff0000|Habp:macro:236248:/mountspecial~0a/assist~0a|h[MountSpecjal]|h|r", -- [74]
						"|cffff0000|Habp:macro:135265:#showtooltip Mirror Image~0a/cast Mirror Image~0a/use 13~0a/use 14~0a/cast Flame Orb~0a/cast Living Bomb~0a/use Volcanic Potion~0a|h[NUKE!!!]|h|r", -- [75]
						"|cffff0000|Habp:macro:135805:#showtooltip Arcane Power~0a/cast Arcane Power~0a/use Volcanic Potion~0a/cast Mirror Image~0a|h[NUKE:)]|h|r", -- [76]
						"|cffff0000|Habp:macro:369214:/way Northern Barrens 39.85 73.73 Rybki~0a|h[Rybki]|h|r", -- [77]
						"|cffff0000|Habp:macro:135257:#showtooltip Ice Ward~0a/stopcasting~0a/cast ~5b@focus~5d Ice Ward~0a|h[sas]|h|r", -- [78]
						"|cffff0000|Habp:macro:237446:/console grounEffectDensity 16~0a/console groundEfectDist 1~0a/console horizonfarclip 1305~0a/console farclip 177~0a/console characterAmbient 1~0a/console smallcull 1~0a/console skycloudlod 1~0a/console detailDoodadAlpha 1~0a|h[settings]|h|r", -- [79]
						"|cffff0000|Habp:macro:135729:/stopcasting~0a/cast ~5b@focus~5d Spellsteal~0a|h[SpellstealFocus]|h|r", -- [80]
						"|cffff0000|Habp:macro:538042:#TARGET~0a/target Garalon's Leg~0a|h[TAR-SPINE-ARCANE]|h|r", -- [81]
						"|cffff0000|Habp:macro:132664:/target boss2~0a/tar twilight sap~0a/tar Elementium Bolt~0a/tar Blistering Tentacle~0a/tar Mana Void~0a/tar Beä~0a/tar Corruption~0a/tar Amirya~0a|h[TARGET]|h|r", -- [82]
						"|cffff0000|Habp:macro:369214:/way Sholazar 54.65 56.18 Jajko~0a|h[TomTom (JAJKO)]|h|r", -- [83]
					},
					["class"] = "MAGE",
					["actions"] = {
						"|cffff0000|Habp:macro:774322:#showtooltip Combustion~0a/stopcasting~0a/cast Combustion~0a/use 12~0a/use 13~0a/use 14~0a/use ~5bmodifier~3aalt~5d Potion of Prolonged Power~0a/cast ~5bmodifier~3ashift~5d Time Warp~0a:1|h[###MAGE: #Combo]|h|r", -- [1]
						"|cff71d5ff|Hspell:2948:0|h[Scorch]|h|r", -- [2]
						"|cff71d5ff|Hspell:2120:0|h[Flamestrike]|h|r", -- [3]
						"|cff71d5ff|Hspell:194466:0|h[Phoenix's Flames]|h|r", -- [4]
						"|cff71d5ff|Hspell:31661:0|h[Dragon's Breath]|h|r", -- [5]
						"|cff71d5ff|Hspell:122:0|h[Frost Nova]|h|r", -- [6]
						"|cffff0000|Habp:macro:136103:/focus~0a:1|h[#focus]|h|r", -- [7]
						"|cff71d5ff|Hspell:130:0|h[Slow Fall]|h|r", -- [8]
						"|cff71d5ff|Hspell:11366:0|h[Pyroblast]|h|r", -- [9]
						"|cff71d5ff|Htalent:22465|h[Flame On]|h|r", -- [10]
						"|cffa335ee|Hitem:139326::::::::110:63::::::|h[Wriggling Sinew]|h|r", -- [11]
						"|cff71d5ff|Hspell:190319:1267|h[Combustion]|h|r", -- [12]
						"|cffff0000|Habp:macro:643910:/click TSMAuctioningCancelButton~0a/click TSMShoppingBuyoutConfirmationButton~0a/click TSMAuctioningPostButton~0a/click TSMShoppingBuyoutButton~0a/click TSMDestroyButton~0a:1|h[TSMMacro]|h|r", -- [13]
						"|cffff0000|Habp:macro:135992:/click ExtraActionButton1~0a/cast slow fall~0a:1|h[EXTRA BUTTON]|h|r", -- [14]
						"|cffff0000|Habp:macro:134400:/cast Magic Broom~0a:1|h[Lataj]|h|r", -- [15]
						"|cffff0000|Habp:macro:132199:/stopcasting~0a/cast ~5b@focus~5d Polymorph~0a:1|h[## POLY]|h|r", -- [16]
						"|cffff0000|Habp:macro:133730:/cleartarget~0a/tar ~5bnodead~5d Arctic Grizzly~0a/script SetRaidTarget(\"target\",8);~0a:1|h[TARGET SKULL]|h|r", -- [17]
						nil, -- [18]
						"|cff71d5ff|Hspell:131474:0|h[Fishing]|h|r", -- [19]
						"|cff0070dd|Hitem:107950::::::::110:63::::::|h[Bipsi's Bobbing Berg]|h|r", -- [20]
						"|cff0070dd|Hitem:118938::::::::110:63::::::|h[Manastorm's Duplicator]|h|r", -- [21]
						"|cff71d5ff|Hspell:28271:0|h[Polymorph]|h|r", -- [22]
						"|cff71d5ff|Hspell:161353:0|h[Polymorph]|h|r", -- [23]
						"|cffff0000|Habp:macro:134400:/console cameraDistanceMaxZoomFactor 2.6~0a:1|h[#CAM]|h|r", -- [24]
						"|cff71d5ff|Hspell:118089:0|h[Azure Water Strider]|h|r", -- [25]
						"|cff0070dd|Hitem:85500::::::::110:63::::::|h[Anglers Fishing Raft]|h|r", -- [26]
						"|cffff0000|Habp:macro:458228:/run local cvar,val=\"Sound_OutputDriverIndex\" val=(GetCVar(cvar) == \"1\" and 8 or 1) SetCVar(cvar, val) print(\"New sound driver\", Sound_GameSystem_GetOutputDriverNameByIndex(val)) AudioOptionsFrame_AudioRestart()~0a:1|h[#SOUND]|h|r", -- [27]
						"|cff0070dd|Hbattlepet:1117:25:3:1400:292:292:BattlePet-0-00000596F7B6|h[Cinder Kitten]|h|r", -- [28]
						"|cff71d5ff|Hspell:190336:0|h[Conjure Refreshment]|h|r", -- [29]
						"|cff71d5ff|Hspell:198929:0|h[Cinderstorm]|h|r", -- [30]
						nil, -- [31]
						"|cffff0000|Habp:macro:1032149:/run local __ = GetCVar( 'gxMaximize' ); SetCVar( 'gxMaximize', 1 - __ ); RestartGx()~0a:1|h[### SCREEN]|h|r", -- [32]
						"|cffff0000|Habp:macro:132221:#/use Potion Of Deadly Grace~0a/use 13~0a/use 14~0a/cast Combustion~0a:1|h[TRINKI]|h|r", -- [33]
						"|cffffffff|Hitem:140192::::::::110:63::::::|h[Dalaran Hearthstone]|h|r", -- [34]
						"|cffffffff|Hitem:110560::::::::110:63::::::|h[Garrison Hearthstone]|h|r", -- [35]
						"|cffffffff|Hitem:6948::::::::110:63::::::|h[Hearthstone]|h|r", -- [36]
						"|cff71d5ff|Hspell:122708:0|h[Grand Expedition Yak]|h|r", -- [37]
						"|cffff0000|Habp:macro:413588:/click GoGoButton~0a:1|h[## Mount FLYING]|h|r", -- [38]
						"|cffff0000|Habp:macro:133032:/click GoGoButton3~0a:1|h[# Mount Pasazerd]|h|r", -- [39]
						"|cff71d5ff|Htalent:22445|h[Rune of Power]|h|r", -- [40]
						"|cff71d5ff|Hspell:195095:0|h[Alchemy]|h|r", -- [41]
						"|cff71d5ff|Hspell:195096:0|h[Enchanting]|h|r", -- [42]
						"|cffffffff|Hitem:58487::::::::110:63::::::|h[Potion of Deepholm]|h|r", -- [43]
						"|cffff0000|Habp:macro:135761:/y Pls move mob(s) out of my fire-circle!!~0a:1|h[TRINKET]|h|r", -- [44]
						"|cffffffff|Hitem:142117::::::::110:63::::::|h[Potion of Prolonged Power]|h|r", -- [45]
						"|cff71d5ff|Hspell:69046:0|h[Pack Hobgoblin]|h|r", -- [46]
						"|cffff0000|Habp:flyout:11|h[Portal]|h|r", -- [47]
						"|cffff0000|Habp:flyout:1|h[Teleport]|h|r", -- [48]
						"|cffff0000|Habp:macro:132199:/stopcasting~0a/cast ~5b@focus~5d Polymorph~0a|h[Polymorph]|h|r", -- [49]
						"|cff71d5ff|Hspell:66:0|h[Invisibility]|h|r", -- [50]
						"|cffffffff|Hitem:127843::::::::110:63::::::|h[Potion of Deadly Grace]|h|r", -- [51]
						"|cffffffff|Hitem:133570::::::::110:63::::::|h[The Hungry Magister]|h|r", -- [52]
						"|cffff0000|Habp:macro:609813:/use Conjured Mana Pudding~0a/use Conjured Mana Fritter:1|h[Mana Cookie]|h|r", -- [53]
						"|cffffffff|Hitem:127834::::::::110:63::::::|h[Ancient Healing Potion]|h|r", -- [54]
						"|cff71d5ff|Hspell:80353:0|h[Time Warp]|h|r", -- [55]
						"|cff71d5ff|Hspell:69070:0|h[Rocket Jump]|h|r", -- [56]
						"|cff0070dd|Hitem:139773::::::::110:63::::::|h[Emerald Winds]|h|r", -- [57]
						"|cff0070dd|Hitem:131811::::::::110:63::::::|h[Rocfeather Skyhorn Kite]|h|r", -- [58]
						"|cff1eff00|Hitem:142406::::::::110:63::::::|h[Drums of the Mountain]|h|r", -- [59]
						"|cff0070dd|Hitem:141605::::::::110:63::::::|h[Flight Master's Whistle]|h|r", -- [60]
						"|cff71d5ff|Htalent:22446|h[Ice Floes]|h|r", -- [61]
						"|cffff0000|Habp:macro:135808:#showtooltip Pyroblast~0a#/stopcasting~0a/cast Pyroblast~0a/stopcasting~0a:1|h[MAGE: PYRO]|h|r", -- [62]
						"|cff71d5ff|Hspell:108853:0|h[Fire Blast]|h|r", -- [63]
						"|cff71d5ff|Hspell:133:0|h[Fireball]|h|r", -- [64]
						"|cff71d5ff|Htalent:22465|h[Flame On]|h|r", -- [65]
						"|cff71d5ff|Htalent:22451|h[Living Bomb]|h|r", -- [66]
						"|cff71d5ff|Hspell:212653:0|h[Shimmer]|h|r", -- [67]
						"|cffff0000|Habp:macro:135856:/stopcasting~0a/cast ~5b@focus, modifier~3aalt~5dSpellsteal; ~5b@focus~5dCounterspell~0a|h[Counterspell FOC]|h|r", -- [68]
						"|cff1eff00|Hitem:90888::::::::110:63::::::|h[Foot Ball]|h|r", -- [69]
						"|cffff0000|Habp:macro:135988:/cast ~5bmodifier~3aalt~5d Slow Fall~0a/cast ~5bnomodifier~3aalt~5d Ice Barrier~0a:1|h[RED]|h|r", -- [70]
						"|cff71d5ff|Htalent:22445|h[Rune of Power]|h|r", -- [71]
						"|cffff0000|Habp:macro:135841:#showtooltip~0a/cancelaura Ice Block~0a#/stopcasting~0a#/stopcasting~0a/cast Ice Block~0a:1|h[Ice Block]|h|r", -- [72]
						"|cff71d5ff|Hspell:66:0|h[Invisibility]|h|r", -- [73]
						"|cffffffff|Hitem:5512::::::::110:63::::::|h[Healthstone]|h|r", -- [74]
						nil, -- [75]
						"|cffff0000|Habp:macro:370670:/equipset ~5bmod~3ashift~5d raider;questy~0a:1|h[#SET]|h|r", -- [76]
						"|cff71d5ff|Hspell:69070:0|h[Rocket Jump]|h|r", -- [77]
						"|cffff0000|Habp:macro:132199:/stopcasting~0a/cast ~5b@focus~5d Polymorph~0a:1|h[## POLY]|h|r", -- [78]
						"|cffff0000|Habp:equip|h[raider]|h|r", -- [79]
						"|cff71d5ff|Hspell:80353:0|h[Time Warp]|h|r", -- [80]
					},
					["bindings"] = {
						["TARGETPET"] = {
							"SHIFT-F1", -- [1]
						},
						["ACTIONPAGE4"] = {
							"SHIFT-4", -- [1]
						},
						["MULTIACTIONBAR1BUTTON6"] = {
							"BUTTON14", -- [1]
							"NUMPAD6", -- [2]
						},
						["TOGGLEACHIEVEMENT"] = {
							"Y", -- [1]
						},
						["MULTIACTIONBAR1BUTTON12"] = {
							"NUMPADMINUS", -- [1]
						},
						["TOGGLESOUND"] = {
							"CTRL-S", -- [1]
						},
						["MULTIACTIONBAR1BUTTON7"] = {
							"BUTTON5", -- [1]
							"NUMPAD7", -- [2]
						},
						["ACTIONPAGE3"] = {
							"SHIFT-3", -- [1]
						},
						["SHAPESHIFTBUTTON4"] = {
							"CTRL-F4", -- [1]
						},
						["TARGETPREVIOUSFRIEND"] = {
							"CTRL-SHIFT-TAB", -- [1]
						},
						["TOGGLEFPS"] = {
							"CTRL-R", -- [1]
						},
						["SHAPESHIFTBUTTON7"] = {
							"CTRL-F7", -- [1]
						},
						["OPENALLBAGS"] = {
							"B", -- [1]
						},
						["TOGGLEGROUPFINDER"] = {
							"I", -- [1]
						},
						["STRAFERIGHT"] = {
							"E", -- [1]
						},
						["TOGGLECOLLECTIONS"] = {
							"SHIFT-P", -- [1]
						},
						["SHAPESHIFTBUTTON1"] = {
							"CTRL-F1", -- [1]
						},
						["CHATPAGEUP"] = {
							"PAGEUP", -- [1]
						},
						["TOGGLEBAG4"] = {
							"F11", -- [1]
						},
						["TOGGLEGAMEMENU"] = {
							"ESCAPE", -- [1]
						},
						["TOGGLEBATTLEFIELDMINIMAP"] = {
							"SHIFT-M", -- [1]
						},
						["TARGETNEARESTFRIEND"] = {
							"CTRL-TAB", -- [1]
						},
						["MASTERVOLUMEUP"] = {
							"CTRL-=", -- [1]
						},
						["TOGGLEWORLDMAP"] = {
							"M", -- [1]
						},
						["CAMERAZOOMOUT"] = {
							"MOUSEWHEELDOWN", -- [1]
						},
						["TOGGLETALENTS"] = {
							"N", -- [1]
						},
						["TOGGLEGUILDTAB"] = {
							"J", -- [1]
						},
						["REPLY2"] = {
							"SHIFT-R", -- [1]
						},
						["TOGGLEBAG1"] = {
							"F8", -- [1]
						},
						["MULTIACTIONBAR1BUTTON5"] = {
							"NUMPAD5", -- [1]
							"BUTTON12", -- [2]
						},
						["NEXTACTIONPAGE"] = {
							"SHIFT-DOWN", -- [1]
							"SHIFT-MOUSEWHEELDOWN", -- [2]
						},
						["ACTIONPAGE2"] = {
							"SHIFT-2", -- [1]
						},
						["TOGGLEPETBOOK"] = {
							"SHIFT-I", -- [1]
						},
						["TOGGLESPELLBOOK"] = {
							"P", -- [1]
						},
						["BONUSACTIONBUTTON6"] = {
							"CTRL-6", -- [1]
						},
						["ACTIONPAGE5"] = {
							"SHIFT-5", -- [1]
						},
						["SHAPESHIFTBUTTON10"] = {
							"CTRL-F10", -- [1]
						},
						["BONUSACTIONBUTTON9"] = {
							"CTRL-9", -- [1]
						},
						["ASSISTTARGET"] = {
							"F", -- [1]
						},
						["TURNLEFT"] = {
							"A", -- [1]
							"LEFT", -- [2]
						},
						["TOGGLEMUSIC"] = {
							"CTRL-M", -- [1]
						},
						["MULTIACTIONBAR1BUTTON4"] = {
							"BUTTON9", -- [1]
							"NUMPAD4", -- [2]
						},
						["REPLY"] = {
							"R", -- [1]
						},
						["PREVIOUSACTIONPAGE"] = {
							"SHIFT-UP", -- [1]
							"SHIFT-MOUSEWHEELUP", -- [2]
						},
						["TARGETPARTYPET1"] = {
							"SHIFT-F2", -- [1]
						},
						["SHAPESHIFTBUTTON8"] = {
							"CTRL-F8", -- [1]
						},
						["SHAPESHIFTBUTTON3"] = {
							"CTRL-F3", -- [1]
						},
						["MULTIACTIONBAR1BUTTON3"] = {
							"NUMPAD3", -- [1]
							"BUTTON7", -- [2]
						},
						["SCREENSHOT"] = {
							"PRINTSCREEN", -- [1]
						},
						["SHAPESHIFTBUTTON9"] = {
							"CTRL-F9", -- [1]
						},
						["BONUSACTIONBUTTON10"] = {
							"CTRL-0", -- [1]
						},
						["TOGGLEBACKPACK"] = {
							"SHIFT-B", -- [1]
							"F12", -- [2]
						},
						["MULTIACTIONBAR1BUTTON8"] = {
							"BUTTON6", -- [1]
							"NUMPAD8", -- [2]
						},
						["SHAPESHIFTBUTTON2"] = {
							"CTRL-F2", -- [1]
						},
						["COMBATLOGPAGEUP"] = {
							"CTRL-PAGEUP", -- [1]
						},
						["TARGETPARTYPET3"] = {
							"SHIFT-F4", -- [1]
						},
						["ACTIONBUTTON3"] = {
							"3", -- [1]
						},
						["BONUSACTIONBUTTON5"] = {
							"CTRL-5", -- [1]
						},
						["MULTIACTIONBAR1BUTTON11"] = {
							"NUMPADPLUS", -- [1]
						},
						["PITCHDOWN"] = {
							"DELETE", -- [1]
						},
						["CHATBOTTOM"] = {
							"SHIFT-PAGEDOWN", -- [1]
						},
						["TURNRIGHT"] = {
							"D", -- [1]
							"RIGHT", -- [2]
						},
						["JUMP"] = {
							"SPACE", -- [1]
						},
						["COMBATLOGBOTTOM"] = {
							"CTRL-SHIFT-PAGEDOWN", -- [1]
						},
						["TARGETNEARESTENEMY"] = {
							"TAB", -- [1]
						},
						["ACTIONBUTTON4"] = {
							"4", -- [1]
						},
						["MULTIACTIONBAR1BUTTON10"] = {
							"NUMPAD0", -- [1]
							"CTRL-NUMPAD1", -- [2]
						},
						["TARGETPARTYMEMBER1"] = {
							"F2", -- [1]
						},
						["ALLNAMEPLATES"] = {
							"CTRL-V", -- [1]
						},
						["CHATPAGEDOWN"] = {
							"PAGEDOWN", -- [1]
						},
						["BONUSACTIONBUTTON3"] = {
							"CTRL-3", -- [1]
						},
						["STRAFELEFT"] = {
							"Q", -- [1]
						},
						["NAMEPLATES"] = {
							"ALT-V", -- [1]
						},
						["ACTIONPAGE6"] = {
							"SHIFT-6", -- [1]
						},
						["ACTIONBUTTON7"] = {
							"7", -- [1]
						},
						["BONUSACTIONBUTTON1"] = {
							"CTRL-1", -- [1]
						},
						["ACTIONBUTTON5"] = {
							"5", -- [1]
						},
						["TOGGLESOCIAL"] = {
							"O", -- [1]
						},
						["TARGETPARTYMEMBER3"] = {
							"F4", -- [1]
						},
						["ACTIONBUTTON8"] = {
							"8", -- [1]
						},
						["TOGGLECHARACTER4"] = {
							"H", -- [1]
						},
						["ACTIONBUTTON2"] = {
							"2", -- [1]
						},
						["OPENCHAT"] = {
							"ENTER", -- [1]
						},
						["ACTIONBUTTON1"] = {
							"1", -- [1]
						},
						["MULTIACTIONBAR1BUTTON1"] = {
							"NUMPAD1", -- [1]
						},
						["ACTIONBUTTON11"] = {
							"-", -- [1]
						},
						["TOGGLEWORLDSTATESCORES"] = {
							"SHIFT-SPACE", -- [1]
						},
						["ACTIONBUTTON9"] = {
							"9", -- [1]
						},
						["TARGETPREVIOUSENEMY"] = {
							"SHIFT-TAB", -- [1]
						},
						["OPENCHATSLASH"] = {
							"/", -- [1]
						},
						["FRIENDNAMEPLATES"] = {
							"SHIFT-V", -- [1]
						},
						["TARGETPARTYMEMBER4"] = {
							"F5", -- [1]
						},
						["MOVEFORWARD"] = {
							"W", -- [1]
							"UP", -- [2]
						},
						["TOGGLERUN"] = {
							"NUMPADDIVIDE", -- [1]
						},
						["TARGETPARTYPET2"] = {
							"SHIFT-F3", -- [1]
						},
						["ACTIONBUTTON12"] = {
							"=", -- [1]
						},
						["PITCHUP"] = {
							"INSERT", -- [1]
						},
						["TOGGLEBAG3"] = {
							"F10", -- [1]
						},
						["COMBATLOGPAGEDOWN"] = {
							"CTRL-PAGEDOWN", -- [1]
						},
						["TOGGLEENCOUNTERJOURNAL"] = {
							"SHIFT-J", -- [1]
						},
						["RAIDTARGET8"] = {
							"ALT-E", -- [1]
						},
						["TARGETPARTYPET4"] = {
							"SHIFT-F5", -- [1]
						},
						["MOVEBACKWARD"] = {
							"S", -- [1]
							"DOWN", -- [2]
						},
						["SHAPESHIFTBUTTON6"] = {
							"CTRL-F6", -- [1]
						},
						["TARGETLASTHOSTILE"] = {
							"G", -- [1]
						},
						["ACTIONBUTTON6"] = {
							"6", -- [1]
						},
						["TOGGLEAUTORUN"] = {
							"NUMLOCK", -- [1]
							"BUTTON4", -- [2]
						},
						["ACTIONPAGE1"] = {
							"SHIFT-1", -- [1]
						},
						["TOGGLECHARACTER2"] = {
							"U", -- [1]
						},
						["TOGGLEPROFESSIONBOOK"] = {
							"K", -- [1]
						},
						["TOGGLEQUESTLOG"] = {
							"L", -- [1]
						},
						["BONUSACTIONBUTTON8"] = {
							"CTRL-8", -- [1]
						},
						["TOGGLECHANNELPULLOUT"] = {
							"SHIFT-O", -- [1]
						},
						["BONUSACTIONBUTTON2"] = {
							"CTRL-2", -- [1]
						},
						["ACTIONBUTTON10"] = {
							"0", -- [1]
						},
						["TOGGLEDUNGEONSANDRAIDS"] = {
							"CTRL-I", -- [1]
						},
						["BONUSACTIONBUTTON4"] = {
							"CTRL-4", -- [1]
						},
						["TOGGLECHARACTER0"] = {
							"C", -- [1]
						},
						["MULTIACTIONBAR1BUTTON9"] = {
							"BUTTON10", -- [1]
							"NUMPAD9", -- [2]
						},
						["TOGGLEUI"] = {
							"ALT-Z", -- [1]
						},
						["MULTIACTIONBAR1BUTTON2"] = {
							"NUMPAD2", -- [1]
						},
						["BONUSACTIONBUTTON7"] = {
							"CTRL-7", -- [1]
						},
						["PETATTACK"] = {
							"SHIFT-T", -- [1]
						},
						["TOGGLESHEATH"] = {
							"Z", -- [1]
						},
						["ITEMCOMPARISONCYCLING"] = {
							"SHIFT-C", -- [1]
						},
						["CAMERAZOOMIN"] = {
							"MOUSEWHEELUP", -- [1]
						},
						["TOGGLESTATISTICS"] = {
							"SHIFT-Y", -- [1]
						},
						["SITORSTAND"] = {
							"X", -- [1]
						},
						["MASTERVOLUMEDOWN"] = {
							"CTRL--", -- [1]
						},
						["RECOUNT_TOGGLE_MAIN"] = {
							"F1", -- [1]
						},
						["RAIDTARGET5"] = {
							"ALT-Q", -- [1]
						},
					},
				},
			},
			["minimap"] = {
				["minimapPos"] = 203.962464263538,
			},
		},
		["DRUID"] = {
		},
		["HUNTER"] = {
		},
	},
}
