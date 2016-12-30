
local guide = WoWPro:RegisterGuide('LudoBuildingsAlliance', 'Achievements', 'Shadowmoon Valley@Draenor', 'Ludovicus', 'Alliance')
WoWPro:GuideLevels(guide,90, 100, 92)
WoWPro:GuideIcon(guide,"ACH",9096)
WoWPro:GuideNextGuide(guide, nil)
WoWPro:GuideAutoSwitch(guide)
WoWPro:GuideSteps(guide, function()
return [[

; This you need to make done in Shadowmoon
A Shadows Awaken |QID|34019|N|From Prophet Velen|M|49.12,38.51|PRE|33765;33070;33905|
C Shadows Awaken |QID|34019|N|Head into the centre of the observatory and wait for Ner'zhul to spawn Karnoth|M|49.3,37.4|NC|QO|1|
C Shadows Awaken |QID|34019|N|Kill and loot Karnoth.|M|49.4,37.0|

A The Mysterious Flask|QID|35342|N|Loot the Mysterious Flask from Karnoth, and use it to begin the quest.|U|113103|P|Alchemy;171;*;1;700|
A The Strength of Iron|QID|36309|N|Loot Haephest's Satchel from Karnoth, and use it to begin the quest.|U|115343|P|Blacksmithing;164;*;1;700|
A Enchanted Highmaul Bracer|QID|36308|N|Loot the Enchanted Highmaul Bracer from Karnoth, and use it to begin the quest.|U|115281|P|Enchanting;333;*;1;700|
A Transponder 047-B|QID|36286|N|Loot the Gnomish Location Transponder from Karnoth, and use it to begin the quest.|U|115278|P|Engineering;202;*;1;700|
A A Mysterious Satchel|QID|36239|N|Loot the Mysterious Satchel from Karnoth, and use it to begin the quest.|U|114984|P|Inscription;773;*;1;700|
A A Power Lost|QID|36408|N|Loot the Drained Crystal Fragment from Karnoth, and use it to begin the quest.|U|115507|P|Jewelcrafting;755;*;1;700|
A A Call for Huntsman|QID|36176|N|Loot the Dirty Note from Karnoth, and use it to begin the quest.|U|114877|P|Leatherworking;165;*;1;700|
A The Cryptic Tome of Tailoring|QID|36236|N|Loot the Cryptic Tome of Tailoring Note from Karnoth, and use it to begin the quest.|U|114972|P|Tailoring;197;*;1;700|
T Shadows Awaken |QID|34019|N|To Prophet Velen|CN|M|49.30,37.41;49.42,36.81|

; Now the quests to get the intro plans


H Lunarfall |QID|36308;35342;36236|N|Use your Garrison Hearthstone, or fly back to your garrison.|U|110560|ACTIVE|36308;35342;36236|
F Embaari Village |QID|35343;36262;36310|N|Fly to Embaari Village|ACTIVE|35343;36262;36310|M|47.99,49.92|

;Alchemy
T The Mysterious Flask|QID|35342|M|47.69,45.39|Z|Lunarfall|N|To Aenir, in your Garrison.|ACTIVE|35342|
A The Young Alchemist|QID|35343|M|47.69,45.39|Z|Lunarfall|N|From Aenir.|PRE|35342|
T The Young Alchemist|QID|35343|M|55.85,41.15|N|To Abatha.|
A The Missing Father|QID|35344|M|55.85,41.15|N|From Abatha.|PRE|35343|
T The Missing Father|QID|35344|M|54.02,45.75|N|To Telos.|
A Shocking Assistance|QID|35345|M|54.02,45.75|N|From Telos.|PRE|35344|
C Shocking Assistance|QID|35345|M|54.0,45.5|N|Kill and loot the Shockscale Eel for the Shockscales.|
T Shocking Assistance|QID|35345|M|55.85,41.18|N|To Abatha.|

;Blacksmithing
T The Strength of Iron|QID|36309|N|To Haephest in Embaari Village|M|45.2,38.9|ACTIVE|36309|
A Father and Son|QID|36311|N|From Haephest|M|45.2,38.9|PRE|36309|
C Father and Son|QID|36311|N|Speak to Duna at Arbor Glen|M|51.1,37.0|CHAT|
T Father and Son|QID|36311|N|To Haephest|M|45.2,38.9|

; Enchanting
T Enchanted Highmaul Bracer|QID|36308|N|To Eileese Shadowsong, in your Garrison.|Z|Lunarfall|M|50.07,42.10|
A The Arakkoan Enchanter|QID|36310|N|From Eileese Shadowsong|Z|Lunarfall|M|50.07,42.10|PRE|36308|
T The Arakkoan Enchanter|QID|36310|N|To Arcanist Delath|M|37.4,72.6|
A Failed Apprentice |QID|36313|N|From Arcanist Delath|M|37.4,72.6|PRE|36310|
C Failed Apprentice |QID|36313|N|Free Deema|M|37.4,72.6|NC|
T Failed Apprentice |QID|36313|N|To Deema|M|37.4,72.6|
A Oru'kai's Staff |QID|36315|N|From Deema|M|37.4,72.6|PRE|36313|
C Oru'kai's Staff |QID|36315|N|Obtain Oru'kai's Staff from the water.|
T Oru'kai's Staff |QID|36315|N|To Arcanist Delath|M|37.4,72.6|

; Engineering
T Transponder 047-B|QID|36286|N|To Goggles|M|60.9,32.6|ACTIVE|36286|
A Snatch 'n' Grab|QID|36287|N|From Goggles|M|60.9,32.6|PRE|36286|
C Snatch 'n' Grab|QID|36287|N|Obtain the Pilfered Parts from Moonlit Shore|NC|M|66.9,27.5|
T Snatch 'n' Grab|QID|36287|N|To Goggles|M|60.9,32.6|PRE|36286|

; Inscription
T A Mysterious Satchel|QID|36239|N|To Sha'la|M|57.98,21.70|
A Slow and Steady|QID|36240|N|From Sha'la|M|57.8,21.4|PRE|36239|
C Slow and Steady|QID|36240|N|Loot Toxic Umbrafen Herbs from the Moonglow Sporebats and Umbraspore Giants|M|55.2,21.0|QO|1|
T Slow and Steady|QID|36240|N|To Sha'la|M|57.8,21.4|
A The Power of Preservation|QID|36241|N|From Sha'la|M|57.8,21.4|PRE|36240|
T The Power of Preservation|QID|36241|N|To Ardule D'na|M|58.31,20.84|

; Jewelcrafting
T A Power Lost|QID|36408|N|To Artificer Baleera in Embaari Village|M|46.96,38.64|ACTIVE|36408|
A Restoration |QID|36409|N|From Artificer Baleera|M|46.96,38.64|PRE|36408|
C Restoration |QID|36409|N|Kill Morakh Chillwhisper, and loot the Empowered Crystal|M|50.5,20.1|
T Restoration |QID|36409|N|To Artificer Baleera|M|46.96,38.64|

; Leatherworking
T A Call for Huntsman |QID|36176|N|To Fanara in Embaari Village.|M|44.2,40.9|ACTIVE|36176|
A Friendly Competition |QID|36177|N|From Fanara in Embaari Village.|M|44.2,40.9|PRE|36176|
C Friendly Competition |QID|36177|N|Kill and loot the Shadowmoon Stalkers.|M|44.0,42.0|S|QO|1|
C Friendly Competition |QID|36177|N|Kill and loot the Silverwing Kaliri|M|45.0,30.0|QO|2|T|Silverwing|
C Friendly Competition |QID|36177|N|Kill and loot the Shadowmoon Stalkers.|M|44.0,42.0|US|QO|1|
T Friendly Competition |QID|36177|N|To Fanara in Embaari Village.|M|44.2,40.9|
A Fair Trade |QID|36185|N|From Fanara in Embaari Village.|M|44.2,40.9|PRE|36177|
T Fair Trade |QID|36185|N|To Garaal|M|45.0,39.2|

; Tailoring
T The Cryptic Tome of Tailoring|QID|36236|M|43.0,54.9|Z|Lunarfall|N|To Aerun|ACTIVE|36236|
A Ameeka, Master Tailor|QID|36262|M|43.0,54.9|Z|Lunarfall|N|From Aerun, in your Garrison.|PRE|36236|
T Ameeka, Master Tailor|QID|36262|N|To Ameeka in Elodor.|M|58.2,26.5|
A The Clothes on Their Backs|QID|36266|N|From Ameeka.|PRE|36262|M|58.2,26.5|
C The Clothes on Their Backs|QID|36266|N|Kill and loot the Shadowmoon Forces for their Ceremonial Shadowmoon Robes.|S|
F Fey Landing |QID|36266|N|Fly to Fey Landing in Elodor.|ACTIVE|36266|
T The Clothes on Their Backs|QID|36266|N|To Ameeka.|M|58.2,26.5|
A Hexcloth|QID|36269|N|From Ameeka.|PRE|36266|M|58.2,26.5|
C Hexcloth|QID|36269|N|Click on Ameeka's Flytrap Ichor on the floor.|NC|M|58.28,26.57|
T Hexcloth|QID|36269|N|To Ameeka.|M|58.2,26.5|



; Now the quests to start up the buildings.
;if you chose the lumber mill  
A Easing into Lumberjacking|QID|36189|N|From Justin Timberlord.|BUILDING|LumberMill;40|Z|Lunarfall|
C Easing into Lumberjacking|QID|36189|M|31.29, 24.70|N|Ride and exit your garrison through the main gate and the tree will be on your right on the road.|
T Easing into Lumberjacking|QID|36189|N|To Justin Timberlord.|BUILDING|LumberMill;40|Z|Lunarfall|
A Turning Timber into Profit|QID|36192|N|From Justin Timberlord.|PRE|36189|Z|Lunarfall|BUILDING|LumberMill;40|
F Embaari Village |QID|36138|N|Fly to Embaari Village to go to Arbor Glen for your wood.|ACTIVE|36138|
C Turning Timber into Profit|QID|36192|M|46.60,34.50|N|As you are out and about don't forget to mark trees.|QO|1|
C Turning Timber into Profit|QID|36192|N|Now turn in your first order at the mill.|BUILDING|LumberMill;40|QO|2|Z|Lunarfall|
T Turning Timber into Profit|QID|36192|N|From Justin Timberlord.|Z|Lunarfall|BUILDING|LumberMill;40|
A Sharper Blades, Bigger Timber|QID|36189|N|From Justin Timberlord.|BUILDING|LumberMill;41|PRE|36192|Z|Lunarfall|
C Sharper Blades, Bigger Timber|QID|36189|M|30.51,30.67|N|Ride and exit your garrison through the main gate ride to near Anguish Fortress.|
T Easing into Lumberjacking|QID|36189|N|To Justin Timberlord.|Z|Lunarfall|
A Tree-i-cide|QID|36189|N|From Justin Timberlord.|BUILDING|LumberMill;138|PRE|36189|Z|Lunarfall|
C Tree-i-cide|QID|36189|M|35.24,22.25;33,25|CS|N|When facing the cliff, the path is to your left. To get up the final rise, the slope is a little to the left of the center.|
T Tree-i-cide|QID|36189|N|To Justin Timberlord.|BUILDING|LumberMill;138|Z|Lunarfall|

;if you chose the inn(tavern) MED
A The Headhunter's Harvest|QID|37046|RANK|2|M|50.50,60.66|N|From Akanja.|BUILDING|Inn;34;35;36|
C The Headhunter's Harvest|QID|37046|CHAT|RANK|2|M|50.50,60.53|N|Talk to Akanja and pick a follower.|
T The Headhunter's Harvest|QID|37046|RANK|2|M|50.50,60.53|N|To Akanja.|

;gladiators sanctum MED
A Warlord of Draenor|QID|36874|M|51.51,59.56|BUILDING|GladiatorsSantum;159;160;161|N|From Raza'kul.|

;storehouse SMALL;51/142/143
A Lost in Transition|QID|37087|BUILDING|Storehouse;51|Z|Lunarfall|N|From Kyra Goldhands.|
C Lost in Transition|QID|37087|Z|Frostwall|N|These are scattered around your garrison.|
T Lost in Transition|QID|37087|BUILDING|Storehouse;51|Z|Lunarfall|N|To Kyra Goldhands.|

;trading post MED
A Tricks of the Trade|QID|37062|M|57.76,27.75|BUILDING|Trading Post;111;144;145|N|From Fayla Fairfeather.|
C Tricks of the Trade|QID|37062|U|118418|M|44.51,14.48|Z|Frostwall|N|He is sleeping just outside  the gates.|
T Tricks of the Trade|QID|37062|M|57.88,27.83|N|To Fayla Fairfeather.|
N Auctioning For Parts|QID|36948|BUILDING|Trading Post;144;145|M|57.88,27.83|N|There is now a quest available, but you can't pick it up until you collect all the necessary items. These items will be automatically looted as you go about normal activities. For more details see Wowhead.

;tannery SMALL
A Your First Leatherworking Work Order|QID|37574|M|53.00,41.32|BUILDING|Tannery;90;121;122|N|From Murne Greenhoof.|
B Raw Beast Hide|QID|37574|M|52.84,47.29|BUILDING|Tannery;90;121;122|L|110609 5|N|Acquire from skinning or the Auction House or some other method.|
C Place work order|QID|37574|M|52.84,47.29|QO|1|CHAT|L|110609 5|N|At Yanny.|
C Pick up work order|QID|37574|M|52.95,41.3|QO|2|NC|L|110609 5|N|At Yanny.|
t Your First Leatherworking Work Order|QID|37574|M|52.84,47.29|N|To Yanny.|

;tailering emporium SMALL
A Your First Tailoring Work Order|QID|36643|M|48.22,32.51|Z|Frostwall|BUILDING|TailoringEmporium;94;127;128|N|From ??.|
B Sumptuous Fur|QID|36643|M|48.32,31.64|Z|Frostwall|BUILDING|TailoringEmporium;94;127;128|L|111557 5|N|Acquire from killing and looting humanoids (saborons a very good source) or the Auction House or some other method.|
C Place order|QID|36643|QO|1|M|48.32,31.64|Z|Frostwall|BUILDING|TailoringEmporium;94;127;128|CHAT|N|Talk to Turga to start a work order.|
C Pick up order|QID|36643|QO|2|M|47.57,34.36|Z|Frostwall|BUILDING|TailoringEmporium;94;127;128|NC|N|From the bundles, barrels and boxes beside the building, called 'Tailoring Work Order' .|
T Your First Tailoring Work Order|QID|36643|M|48.32,31.64|Z|Frostwall|BUILDING|TailoringEmporium;94;127;128||N|From Turga.|

;the forge SMALL
A Your First Blacksmithing Work Order|QID|35168|M|48.22,32.51|Z|Frostwall|BUILDING|TheForge;60;117;118|N|From ??.|
B True Iron Ore|QID|35168|M|48.32,31.64|Z|Frostwall|BUILDING|TheForge;60;117;118|L|109118 5|N|Acquire from mining or the Auction House or some other method.|
C Place order|QID|35168|QO|1|M|48.32,31.64|Z|Frostwall|BUILDING|TheForge;60;117;118|CHAT|N|Talk to Kinja to start a work order.|
C Pick up order|QID|35168|QO|2|M|47.57,34.36|Z|Frostwall|BUILDING|TheForge;60;117;118|NC|N|From the bundles, barrels and boxes beside the building, called 'Blacksmithing Work Order' .|
T Your First Blacksmithing Work Order|QID|35168|M|48.32,31.64|Z|Frostwall|BUILDING|TheForge;60;117;118||N|From Kinja.|

;gem boutique SMALL
A Your First Jewelcrafting Work Order|QID|37573|M|48.22,32.51|Z|Frostwall|BUILDING|GemBoutique;96;131;132|N|From Dorogarr.|
B Blackrock Ore|QID|37573|M|48.32,31.64|Z|Frostwall|BUILDING|GemBoutique;96;131;132|L|109118 5|N|Acquire from mining or the Auction House or some other method.|
C Place order|QID|37573|QO|1|M|48.32,31.64|Z|Frostwall|BUILDING|GemBoutique;96;131;132|CHAT|N|Talk to Elrondir Surrion to start a work order.|
C Pick up order|QID|37573|QO|2|M|47.57,34.36|Z|Frostwall|BUILDING|GemBoutique;96;131;132|NC|N|From the bundles, barrels and boxes beside the building, called 'Jewelcrafting Work Order'.|
T Your First Jewelcrafting Work Order|QID|37573|M|48.32,31.64|Z|Frostwall|BUILDING|GemBoutique;96;131;132|N|From Elrondir Surrion.|

;if you chose alchemy lab SMALL
A Your First Alchemy Work Order|QID|37568|M|48.22,32.51|Z|Frostwall|BUILDING|AlchemyLab;76;119;120|N|From Albert de Hyde.|
B Frostweed|QID|37568|M|48.32,31.64|Z|Frostwall|BUILDING|AlchemyLab;76;119;120|L|109124 5|N|Acquire from herbalism or the Auction House or some other method.|
C Place order|QID|37568|QO|1|M|48.32,31.64|Z|Frostwall|BUILDING|AlchemyLab;76;119;120|CHAT|N|Talk to Keyana Tone to start a work order.|
C Pick up order|QID|37568|QO|2|M|47.57,34.36|Z|Frostwall|BUILDING|AlchemyLab;76;119;120|NC|N|From the bundles, barrels and boxes beside the building, called 'Alchemy Work Order' .|
T Your First Alchemy Work Order|QID|37568|M|48.32,31.64|Z|Frostwall|BUILDING|AlchemyLab;76;119;120|N|From Keyana Tone.|

;if you choose scribes quarters SMALL
A Your First Inscription Work Order|QID|37572|M|48.22,32.51|Z|Frostwall|BUILDING|ScribesQtrs;95;129;130|N|From Urgra.|
B Cereleun Pigment|QID|37572|M|48.32,31.64|Z|Frostwall|BUILDING|ScribesQtrs;95;129;130|L|114931 2|N|Acquire from milling Draenor herbs or the Auction House or some other method.|
C Place order|QID|37572|QO|1|M|48.32,31.64|Z|Frostwall|BUILDING|ScribesQtrs;95;129;130|CHAT|N|Talk to Y'rogg to start a work order.|
C Pick up order|QID|37572|QO|2|M|47.57,34.36|Z|Frostwall|BUILDING|ScribesQtrs;95;129;130|NC|N|From the bundles, barrels and boxes beside the building, called 'Inscription Work Order'.|
T Your First Inscription Work Order|QID|37572|M|48.32,31.64|Z|Frostwall|BUILDING|ScribesQtrs;95;129;130|N|From Y'rogg.|

;engineering works SMALL
A Your First Engineering Work Order|QID|37571|M|53.97,37.33|BUILDING|EngineeringWorks;91;123;124|N|From Pozzlow.|Z|Frostwall|
B True Iron Ore|QID|37571|L|109118 2|N|Mine or Acquire (from your bank/mailbox/Auction House) 2 Blackrock Ore.|BUILDING|EngineeringWorks;91;123;124|Z|Frostwall|
B Blackrock Ore|QID|37571|L|109119 2|N|Mine or Acquire (from your bank/mailbox/Auction House) 2 True Iron Ore.|BUILDING|EngineeringWorks;91;123;124|Z|Frostwall|
C Place work order|QID|37571|CHAT|QO|1|M|53.13,36.18|N|At Garbra Fizzwonk.|BUILDING|EngineeringWorks;91;123;124|Z|Frostwall|
C Pick up work order|QID|37571|NC|QO|2|M|51.84,35.94|Z|Frostwall|N|At the pile of boxes and bags named 'Engineering Work Order.|BUILDING|EngineeringWorks;91;123;124|
T Your First Engineering Work Order|QID|37571|M|53.47,36.94|N|To Garbra Fizzwonk.|BUILDING|EngineeringWorks;91;123;124|Z|Frostwall|

;if you chose enchanting hut SMALL
A Your First Enchanting Work Order|QID|36645|M|52.95,37.31|N|From Yukla Greenshadow.|BUILDING|EnchantingHut;93;125;126|
B Draenic Dust|QID|36645|M|51.85,35.76|L|109693 5|N|Use the Essence Font in you Enchanting Hut to DE some unneeded gear to get the Draenic Dust for the work order(or otherwise acquire it from bank/mailbox/AH).|BUILDING|EnchantingHut;93;125;126|
C Place first work order|QID|36645|M|51.85,35.76|QO|1|CHAT|N|At Garra.|BUILDING|EnchantingHut;93;125;126|
C Pick up work order|QID|36645|M|51.85,35.76|QO|2|NC|N|At the bundles and boxes called 'Enchanting Work Order'.|BUILDING|EnchantingHut;93;125;126|
T Your First Enchanting Work Order|QID|36645|M|52.56,36.72|N|To Garra.|BUILDING|EnchantingHut;93;125;126|

;if you choose barn MED
A Breaking Into the Trap Game|QID|36345|BUILDING|Barn;24;25;133|M|51.71,58.32|Z|Frostwall|N|From Farmer Lok'lub|
C Go trap an animal|QID|36345|QO|1|M|55,62;26,43|CN|U|113991|N|Trap a wolf (in the shivering trench ~55,62) if you want fur (cloth) and a clefthoof (nearest concentration is outside of sootstained mines ~26,46) if you are interested in leather. You can trap more if you want, up to 7 can be turned in each day.|
C Place a work order|QID|36345|QO|2|M|51.71,58.32|Z|Frostwall|N|At Farmer Lok'lub, sometimes he gets bored and wanders around, I have found him as far away as my garrison's graveyard.|
T Breaking Into the Trap Game|QID|36345|BUILDING|Barn;24;25;133|M|51.71,58.32|Z|Frostwall|N|To Farmer Lok'lub|


;; Garrison Level Quesrs

A Things Are Not Goren Our Way |QID|34192|N|From Timothy Leens|M|65.46,41.79|Z|Lunarfall|PRE|36592|BUILDING|townhall;2|
C Things Are Not Goren Our Way |QID|34192|N|Kill the Lunarfall Goren (both Red and Yellow count).|M|65.46,41.79|Z|Lunarfall|S|QO|1|
C Things Are Not Goren Our Way |QID|34192|N|Head to the back of the mine and kill Stonetooth.|M|58.81,78.85|Z|Lunarfall Excavation@Lunarfall|T|Stonetooth|QO|2|
C Things Are Not Goren Our Way |QID|34192|N|Kill the Lunarfall Goren (both Red and Yellow count).|M|65.46,41.79|Z|Lunarfall|US|QO|1|
T Things Are Not Goren Our Way |QID|34192|N|To Timothy Leens|M|65.46,41.79|Z|Lunarfall|

A Looking For Help |QID|34194|M|53.79, 14.33|Z|Lunarfall|N|From Ron Ashton|PRE|36592|BUILDING|townhall;2|LVL|94|
C Looking For Help |QID|34194|M|26.96, 7.29|CHAT|N|Ask for help from Maidari at Eventide Landing.  Fastest way to get there is to jump carefully down the back of your garrison.|
T Looking For Help |QID|34194|M|26.96, 7.29|N|To Madari.|
A Moonshell Claws |QID|36199|M|26.96, 7.29|N|From Madari.|PRE|34194|
C Claws |QID|36199|M|30.20, 10.68|QO|1|N|On the other side of the ship.|
T Moonshell Claws |QID|36199|M|26.96, 7.29|N|To Madari.|
A Proving Your Worth |QID|36201|M|26.96, 7.29|N|From Madari.|PRE|36199|
C Shadow Sturgeons |QID|36201|M|27.59, 6.90|QO|1|N|Be sure to equip your best fishing pole and use the bait.|U|114874|
T Proving Your Worth |QID|36201|M|26.96, 7.29|N|From Madari.|
A Anglin' In Our Garrison |QID|36202|M|26.96, 7.29|N|From Madari.|PRE|36201|
T Anglin' In Our Garrison |QID|36202|M|53.79, 14.33|Z|Lunarfall|N|From Ron Ashton|

A Clearing the Garden |QID|36404|M|58.89, 53.45|N|From Naron Bloomthistle|Z|Lunarfall|PRE|36592|BUILDING|townhall;2|LVL|96|
C Kill the Raccoons|QID|36404|M|57.6,59.6|Z|Lunarfall|QO|1|
T Clearing the Garden |QID|36404|M|58.89, 53.45|Z|Lunarfall|N|To Naron Bloomthistle|

]]

end)
