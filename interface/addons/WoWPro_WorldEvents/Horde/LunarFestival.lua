
-- WoWPro Guides by "The WoW-Pro Community" are licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
-- Based on a work at github.com.
-- Permissions beyond the scope of this license may be available at http://www.wow-pro.com/License.

-- URL: http://wow-pro.com/wiki/lunar_festival_horde
-- Date: 2015-02-24 08:27
-- Who: Emmaleah
-- Log: Correct a misplaced "|"

-- URL: http://wow-pro.com/node/3452/revisions/27144/view
-- Date: 2015-02-24 04:58
-- Who: Emmaleah
-- Log: updated for WOD, also streamlined quest order so you aren't flying thru hubs multiple times. Put Vashj'ir and Uldam in the sequence while flying around since they do not have portals back to orgrimmar.

-- URL: http://wow-pro.com/node/3452/revisions/26495/view
-- Date: 2014-06-10 21:32
-- Who: Ludovicus
-- Log: Changed guide format.

-- URL: http://wow-pro.com/node/3452/revisions/25874/view
-- Date: 2014-01-23 00:22
-- Who: Ludovicus
-- Log: Z tags corrections

-- URL: http://wow-pro.com/node/3452/revisions/25524/view
-- Date: 2013-02-06 20:29
-- Who: Ludovicus
-- Log: Coord fixes and a few LVL tags

-- URL: http://wow-pro.com/node/3452/revisions/25514/view
-- Date: 2013-01-28 12:03
-- Who: Ludovicus
-- Log: Updated with new Alliance coord.  Horde cords not verified yet.

-- URL: http://wow-pro.com/node/3452/revisions/25302/view
-- Date: 2013-01-09 17:28
-- Who: Ludovicus
-- Log: Added CS tags

-- URL: http://wow-pro.com/node/3452/revisions/24941/view
-- Date: 2012-02-07 03:29
-- Who: Laotseu
-- Log: Merge back the corrections that I had made in the previous version of the guide with the new Cata elders.

-- URL: http://wow-pro.com/node/3452/revisions/24940/view
-- Date: 2012-02-05 23:54
-- Who: Ludovicus
-- Log: Add in LaoTseu's changes

-- URL: http://wow-pro.com/node/3452/revisions/24932/view
-- Date: 2012-02-04 22:39
-- Who: Ludovicus
-- Log: Elders of Cata

-- URL: http://wow-pro.com/node/3452/revisions/24918/view
-- Date: 2012-01-23 23:13
-- Who: Ludovicus
-- Log: Merge in Laotseu's update.

-- URL: http://wow-pro.com/node/3452/revisions/24853/view
-- Date: 2011-12-10 04:35
-- Who: Crackerhead22

-- URL: http://wow-pro.com/node/3452/revisions/24846/view
-- Date: 2011-12-07 18:37
-- Who: Crackerhead22
-- Log: Added Elders guide source code, added section for Lunar Festival achievements.

-- URL: http://wow-pro.com/node/3452/revisions/24844/view
-- Date: 2011-12-07 18:30
-- Who: Crackerhead22
-- Log: Source page created.

local guide = WoWPro:RegisterGuide("CraLunFesEldH",'WorldEvents',"Lunar Festival Elders Guide", "Crackerhead22", "Horde")
WoWPro:GuideLevels(guide,1,90,45.000000)
WoWPro.WorldEvents:GuideHoliday(guide,"LunarFestival")
WoWPro:GuideSteps(guide, function()
return [[

N Wall of Text Part 1 of 3|QID|8677|N|This guide is geared toward actually completing all the Elder quests necessary for the Lunar Festival's achievments of "Elders of...". Most of the dungeon Elders can be snuck to if your level is high enough. There are a couple you have to kill bosses to get to.|
N Wall of Text Part 2 of 3|QID|8677|N|For the Elders that are possible (like Loch Modan) and definite PVP (like Ironforge), I will be putting a target button for them. That way if you have auto-accept/turn-in on, all you have to do is hit the button. It will target the Elder, then run in and right click on them, it will complete the quest, then run like your butt is on fire.|
N Wall of Text Part 3 of 3|QID|8677|N|if you want waypoints to work in instances, you need to have Enable Hiding box unchecked in the WoW-Pro UI Display Options.|
N This guide starts...|QID|8677|N|...In Orgrimmar.|

A Darkhorn the Elder|N|From Elder Darkhorn.|QID|8677|M|52.25,59.98|Z|Orgrimmar@Orgrimmar|
R Azshara|N|Run North/West out of Orgrimmar to Azshara.|QID|8720|M|64.74,79.34|Z|Azshara|
A Skygleam the Elder|N|From Elder Skygleam.|QID|8720|M|64.74,79.34|Z|Azshara|
F Everlook|N|Fly to Everlook in Winterspring.|QID|8672|M|51.4,74.2|Z|Azshara|
A Stonespire the Elder|N|From Elder Stonespire.|QID|8672|M|59.97,49.95|Z|Winterspring|
A Brightspear the Elder|N|From Elder Brightspear.|QID|8726|M|53.23,56.75|Z|Winterspring|
F Whisperwind Grove|N|Fly to Whisperwind Grove in Felwood.|QID|8723|M|58.84,48.2|Z|Winterspring|LVL|60|
A Nightwind the Elder|N|From Elder Nightwind.|QID|8723|M|38.36,52.85|Z|Felwood|LVL|60|
R Lor'danel|N|Run to Lor'danel in Darkshore.|QID|8721|M|49.5,18.9|Z|Darkshore|
A Starweave the Elder|N|From Elder Starweave.|QID|8721|M|49.54,18.95|Z|Darkshore|T|Elder Starweave|
R Rut'theran Village|QID|8715|M|56.8,90.6|Z|Teldrassil|LVL|60|N|There is no boat to Rut'theran Village anymore unless you go from Stormwind. You can easily fly across to it though.|
R Dolanaar|N|Run to Dolanaar. I would recommend going up and over the tree instead of going through the pink portal, as there is a chance you will get killed by the flying guards.|QID|8715|M|56.8,52.9|Z|Teldrassil|LVL|60|
A Bladeleaf the Elder|N|From Elder Bladeleaf.|QID|8715|M|56.85,53.10|Z|Teldrassil|T|Elder Bladeleaf|LVL|60|
R Darnassus|N|Run to Darnassus.|QID|8721|M|39.2,31.8|Z|Darnassus|LVL|60|
A Bladeswift the Elder|N|From Elder Bladeswift.|QID|8718|M|39.21,31.85|Z|Darnassus|T|Elder Bladeswift|LVL|60|
R Rut'theran Village|N|Run through the pink portal if you think you can make it, or go back over the tree.|QID|8721|M|36.16,50.16|Z|Darnassus|LVL|60|
F Astramaar|N|Now for the long trek down to Astramaar. You could head back over to Whisperwind Grove in Felwood if you wish to use a flightpoint as that is the closest to you.|QID|8725|M|35.4,48.9|Z|Ashenvale|
A Riversong the Elder|N|From Elder Riversong.|QID|8725|M|35.54,48.91|Z|Ashenvale|T|Elder Riversong|

F Razor Hill|N|Fly to Razor Hill in Durotar.|QID|8670|M|38,42.2|Z|Ashenvale|
A Runetotem the Elder|N|From Elder Runetotem.|QID|8670|M|53.23,43.61|Z|Durotar|
F The Crossroads|N|Fly to The Crossroads in Northern Barrens. Unless you are going to go afk, you probably don't want to use the flight path as it routes your through Orgrimmar first. (so manually check off this step.)|QID|8717|M|53,43.6|Z|Durotar|
A Moonwarden the Elder|N|From Elder Moonwarden.|QID|8717|M|48.52,59.26|Z|Northern Barrens|
F Vendetta Point|N|Fly to Vendetta Point in Southern Barrens.|QID|8686|M|48.6,58.6|Z|Northern Barrens|
A High Mountain the Elder|N|From Elder High Mountain.|QID|8686|M|41.60,47.45|Z|Southern Barrens|
F Bloodhoof Village|N|Fly to Bloodhoof Village in Mulgore. This is another one that is much faster to fly on your own, since the flight path will route your through Thunder Bluff.(manually check this off if you choose to fly on your own.)|QID|8673|M|41.6,47.6|Z|Southern Barrens|
A Bloodhoof the Elder|N|From Elder Bloodhoof.|QID|8673|M|48.50,53.23|Z|Mulgore|
F Thunder Bluff|N|Fly to Thunder Bluff in Mulgore.|QID|8678|M|47.43,58.64|Z|Mulgore|
A Wheathoof the Elder|N|From Elder Ezra Wheathoof.|QID|8678|M|72.98,23.38|Z|Thunder Bluff|
F Shadowprey Village|N|Fly to Shadowprey Village in Desolace.|QID|8635|M|46.99,49.64|Z|Thunder Bluff|RANK|2|
R Maraudon|QID|8635|M|29.12,62.56|CC|N|Head over to the Maraudon.|Z|Desolace|RANK|2|
R Open the Stone Door|QID|8635|N|And follow the path until you come to a mini-map change.|M|28.23,62.61;28.29,65.08;27.58,62.85;28.09,62.8|CS|Z|Desolace|RANK|2|
R Follow the dots|QID|8635|N|Until you come to a portal.|M|29.06,62.48;29.97,59.96;29.39,60.94|Z|Desolace|CS|RANK|2|
A Splitrock the Elder|N|Enter the portal. From Elder Splitrock.|QID|8635|M|51.4,93.4|Z|Zaetar's Grave@Maraudon|RANK|2|
R Maraudon|QID|8685|N|Easy way out is to invite a friend, make them the leader then leave group. You will end up at the nearest graveyard, in this case right near the stone gate out. Should take about 1-2 minutes before you are booted.|RANK|2|
F Stonemaul Hold|N|Fly to Stonemaul Hold in Feralas.|QID|8685|M|21.6,74|Z|Desolace|
A Mistwalker the Elder|N|From Elder Mistwalker inside the arena at Dire Maul, NOT inside the instance.|QID|8685|M|62.56,31.07|Z|Feralas|
A Grimtotem the Elder|N|From Elder Mistwalker located at Lariss Pavilion.|QID|8679|M|76.70,37.90|Z|Feralas|
F Cenarion Hold|N|Fly to Cenarion Hold in Silithus.|QID|8719|M|75.4,44.2|Z|Feralas|
A Primestone the Elder|N|From Elder Primestone, Silithus.|QID|8654|M|30.80,13.31|Z|Silithus|
A Bladesing the Elder|N|From Elder Bladesing, Silithus.|QID|8719|M|53.02,35.47|Z|Silithus|

F Oasis of Vir'sar|QID|29741|M|52.7,34.4|Z|Silithus|N|Fly to Oasis of Vir'sar.|LVL|60|
A Sekhemi the Elder|QID|29741|M|31.59,62.99|Z|Uldum|N|From Elder Sekhemi|LVL|60|
A Menkhaf the Elder|QID|29742|M|65.52,18.68|Z|Uldum|N|From Elder Menkhaf|LVL|60|
F Marshal's Stand|QID|8681|N|Fly to Marshal's Stand in Un'Goro Crater.|M|52.7,34.4|Z|Silithus|LEAD|29742|
A Thunderhorn the Elder|N|From Elder Thunderhorn.|QID|8681|M|50.38,76.16|Z|Un'Goro Crater|
R Marshal's Stand|N|Fly to Marshal's Stand in Un'Goro Crater.|QID|8681|M|56,64|Z|Un'Goro Crater|
F Dawnrise Expedition|N|Fly to Dawnrise Expedition in Tanaris. Not a direct flight, you may prefer to check this off and fly on your own.|QID|8671|M|56,64|Z|Un'Goro Crater|
A Ragetotem the Elder|N|From Elder Ragetotem.|QID|8671|M|37.24,79.06|Z|Tanaris|
F Gadgetzan|N|Fly to Gadgetzan in Tanaris.|QID|8684|M|33.2,77.2|Z|Tanaris|
A Dreamseer the Elder|N|From Elder Dreamseer.|QID|8684|M|51.40,28.80|Z|Tanaris|
R Zul'Farrak|N|Run into Zul'Farrak.|QID|8676|M|39.23,21.21|CC|Z|Tanaris|RANK|2|
A Wildmane the Elder|N|From Elder Wildmane.|QID|8676|M|57.14,55.20;46.65,49.33;34.49,39.36|CS|Z|ZulFarrak|RANK|2|
F Fizzle & Pozzik's Speedbarge|N|Fly to Fizzle & Pozzik's Speedbarge in Thousand Needles.|QID|8724|M|52.0,27.6|Z|Tanaris|
A Morningdew the Elder|N|From Elder Morningdew.|QID|8724|M|77.08,75.61|Z|Thousand Needles|
A Skyseer the Elder|N|From Elder Skyseer, Thousand Needles. If you hover in the air beside the tower you are less likely to get agro.|QID|8682|M|46.34,51.01|Z|Thousand Needles|
F Ratchet|N|Fly to Ratchet in Northern Barrens.|QID|8680|M|79.15,71.93|Z|Thousand Needles|
A Windtotem the Elder|N|From Elder Windtotem.|QID|8680|M|68.36,69.96|Z|Northern Barrens|
b Booty Bay|N|Catch the boat to Booty Bay.|M|70.9,72.56|Z|Northern Barrens|QID|8674|

A Winterhoof the Elder|N|From Elder Winterhoof.|QID|8674|M|39.96,72.52|Z|The Cape of Stranglethorn|
F Bambala|N|Fly to Bambala in Northern Stranglethorn.|QID|8716|M|40.6,73.2|Z|The Cape of Stranglethorn|
A Starglade the Elder|N|From Elder Starglade.|QID|8716|M|71.04,34.30|Z|Northern Stranglethorn|
R Blasted Lands|N|Run to Blasted Lands|QID|8647|M|48.16,7.28|Z|Blasted Lands|LVL|90|
N Zidormi|QID|8647|N|Chat with Zidormi to turn the area back to pre-WOD invasion state. You will need to manually check this step off.|CHAT|M|48.16,7.28|Z|Blasted Lands|LVL|90|
R The Dark Portal|N|Head over to the Dark Portal.|QID|8647|M|54.3,49.5|Z|Blasted Lands|
A Bellowrage the Elder|N|From Elder Bellowrage.|QID|8647|M|54.3,49.5|Z|Blasted Lands|
N Optional - Zidormi|QID|8713|N|Chat with Zidormi to turn the area return post-WOD invasion state. You will need to manually check this step off. You can skip this step if you don't care which state Blasted Lands is in.|CHAT|M|48.16,7.28|Z|Blasted Lands|LVL|90|
R The Temple of Atal'Hakkar|N|Head North to Swamp of Sworrows and into the Temple of Atal'Hakkar.|QID|8713|M|69.37,53.07|Z|Swamp of Sorrows|RANK|2|
R Hall of Masks|N|Head inside the Temple down into the Hall of Masks|QID|8713|Z|Swamp of Sorrows|M|75.99,45.22|RANK|2|
A Starsong the Elder|N|From Elder Starsong from inside the instance.|QID|8713|M|62.90,34.47|Z|TheTempleOfAtalHakkar|RANK|2|
R The Temple of Atal'Hakkar|N|Get back out of the instance.|QID|8675|M|49.9,18.4|Z|TheTempleOfAtalHakkar|RANK|2|
R Westfall|N|Head to Westfall.|QID|8675|M|56.6,47|Z|Westfall|LVL|60|
A Skychaser the Elder|N|From Elder Skychaser.|QID|8675|M|56.64,47.09|Z|Westfall|T|Elder Skychaser|LVL|60|
R Elwynn Forest|N|Run North to Elwynn Forest.|QID|8649|M|39.6,63.5|Z|Elwynn Forest|
A Stormbrow the Elder|N|From Elder Stormbrow.|QID|8649|M|39.79,63.67|Z|Elwynn Forest|T|Elder Stormbrow|
A Hammershout the Elder|N|From Elder Hammershout.|QID|8646|M|34.56,50.25|Z|Elwynn Forest|T|Elder Hammershout|
R Burning Steppes|N|Time to head to Burning Steppes.|QID|8636|M|70.1,45.4|Z|Burning Steppes|

A Rumblerock the Elder|N|From Elder Rumblerock.|QID|8636|M|70.11,45.39|Z|Burning Steppes|
A Dawnstrider the Elder|N|From Elder Dawnstrider.|QID|8683|M|52.37,23.94|Z|Burning Steppes|
R Blackrock Mountain|N|Run to Blackrock Mountain.|QID|8644|M|20.39,34.56|Z|Burning Steppes|RANK|2|
R Do you have a flying mount?|N|If yes, fly up to the ledge at this waypoint. If not pass this step and follow the next steps.|QID|8644|M|23.77,26.14|Z|Burning Steppes|CS|RANK|2|
R Follow the series of waypoints|N|To get into the instance. If you flew up, manually check this off.|QID|8644|CS|M|24.36,29.86;25.8,26.44;26.4,26.33|Z|Burning Steppes|RANK|2|
R Follow the series of waypoints|N|To get into the instance. Part 2 If you flew up, manually check this off.|QID|8644|CS|M|25.72,25.98;25.89,28.1;24.71,28.37;24.22,26.12|Z|Burning Steppes|RANK|2|
R Lower Blackrock Spires|QID|8644|N|With WOD, the entrance you are looking for has moved slightly, go straight forward and it will be on your right.|M|27.55,25.38|Z|Burning Steppes|RANK|2|
A Stonefort the Elder|N|Head in the instance. From Elder Stonefort.|QID|8644|M|42.31,45.00;52.18,36.98;61.82,40.08|CS|Z|Hordemar City@BlackrockSpire|RANK|2|
R The Molten Span|N|Head back out of the instance and run (fly) to this waypoint at the bottom near the lava.|CS|QID|8619|M|18.59,25.03|Z|Burning Steppes|RANK|2|
R Blackrock Depths|N|Follow the waypoints to get into Blackrock Depths instance.|CS|QID|8619|M|18.75,24.89;16.72,20.63;14.29,15.88;14.47,9.25|Z|Burning Steppes|RANK|2|

A Morndeep the Elder|N|From Elder Morndeep.|QID|8619|M|50.55,62.90|Z|Detention Block@BlackrockDepths|RANK|2|
R Searing Gorge|N|Head out of the instance, and run North to Searing Gorge.|QID|8651|M|34.56,83.46|CC|Z|Searing Gorge|RANK|2|
A Ironband the Elder|N|From Elder Ironband.|QID|8651|M|21.29,79.11|Z|Searing Gorge|
R Loch Modan|N|Head towards Loch Modan.|QID|8642|M|33,46.5|Z|Loch Modan|
A Silvervein the Elder|N|From Elder Silvervein.|QID|8642|M|33.32,46.54|Z|Loch Modan|T|Elder Silvervein|
R Dun Morogh|N|Fly to Dun Morogh.|QID|8653|M|53.9,49.8|Z|Dun Morogh|
A Goldwell the Elder|N|From Elder Goldwell.|QID|8653|M|53.90,49.91|Z|Dun Morogh|T|Elder Goldwell|
R Ironforge|N|Run into Ironforge.|QID|8866|M|29.4,14|Z|Ironforge|LVL|60|
A Bronzebeard the Elder|N|From Elder Bronzebeard.|QID|8866|M|29.20,17.06|Z|Ironforge|T|Elder Bronzebeard|LVL|60|

R Edge of Don Morogh|N|Fly over to the easternmost point of Dun Morogh|LVL|60|M|3.15,28.99|CC|Z|Dun Morogh|QID|29738|
R Vashj'ir|QID|29738|LVL|60|M|39.33,59.22;37.74,59.42|CS|Z|Eastern Kingdoms|N|Fly across the narrowest part of the fatigue water and then when you get into Vashj'ir head south towards the elder.|
A Moonlance the Elder|QID|29738|M|57.25,86.14|Z|Shimmering Expanse|N|From Elder Moonlance, Near Biel'Aran Ridge.|LVL|60|
R Sandy Beach|QID|8645|M|61.03,28.43|CC|Z|Shimmering Expanse|N|Fly over to Sandy Beach to catch a flight point back to the mainland.|LVL|60|
F The Sepulcher|N|Fly to Sepulcher in Silverpine Forest.|QID|8645|M|61.03,28.43|Z|Shimmering Expanse|LVL|60|

F The Sepulcher|N|Fly to Sepulcher in Silverpine Forest. The closest flight point is South in Searing Gorge.|QID|8645|M|34.8,30.8|Z|Searing Gorge|LEAD|29738|
A Obsidian the Elder|N|From Elder Obsidian.|QID|8645|M|44.97,41.14|Z|Silverpine Forest|
F Undercity|N|Fly to Undercity in Tirisfal Glades.|QID|8648|M|45.4,42.4|Z|Silverpine Forest|
A Darkcore the Elder|N|From Elder Darkcore. He is near the Thone.|QID|8648|M|58.96,48.14;67.0,41.76;66.63,38.23|CS|Z|Undercity|
R Brill|N|Run to Brill|QID|8652|M|61.86,53.91|Z|Tirisfal Glades|
A Graveborn the Elder|N|From Elder Graveborn.|QID|8652|M|61.86,53.91|Z|Tirisfal Glades|
F Hiri'watha Research Station|QID|8643|M|58.87,51.86|Z|Tirisfal Glades|N|Fly to Hiri'watha Research Stateion in the Hinterlands.|
A Highpeak the Elder|N|From Elder Highpeak.|QID|8643|M|50.00,48.05|Z|The Hinterlands|
F Thondroril River|N|Fly to Thondroril River in Eastern Plaguelands.|QID|8722|M|32.4,58|Z|The Hinterlands|
A Moonstrike the Elder|N|From Elder Moonstrike. She is on top of Scholomance, not inside the instance.|QID|8714|M|69.19,73.45|Z|Western Plaguelands|
A Meadowrun the Elder|N|From Elder Meadowrun, inside the cave. At the first intersection, go straight, and in a few more steps you will see the Elder.|QID|8722|M|65.21,38.72;63.51,36.11|Z|Western Plaguelands|CS|
R Crown Guard Tower|N|Head over to Crown Guard Tower.|QID|8688|M|35.6,68.8|Z|Eastern Plaguelands|
A Windrun the Elder|N|From Elder Windrun.|QID|8688|M|35.58,68.82|Z|Eastern Plaguelands|

F Light's Hope Chapel|N|Fly to Light's Hope Chapel in Eastern Plaguelands.|QID|8650|M|34.9,67.9|Z|Eastern Plaguelands|
A Snowcrown the Elder|N|From Elder Snowcrown.|QID|8650|M|75.73,54.56|Z|Eastern Plaguelands|
F Plaguewood Tower|N|Fly to Plaguewood Tower in Eastern Plaguelands.|QID|8727|M|75.85,53.41|Z|Eastern Plaguelands|
R Stratholme |N|Enter Stratholme's main entrance.|QID|8727|M|26.3,11.7|Z|Eastern Plaguelands|RANK|2|
A Farwhisper the Elder|N|From Elder Farwhisper.|QID|8727|M|78.59,21.16|Z|Crusader's Square@Stratholme|RANK|2|
R Stratholme|QID|8645|M|65.4,87.8|CC|Z|Crusader's Square@Stratholme|RANK|2|N|Exit Stratholme.|
R Plaguewood Tower|QID|13017|M|18.46,27.36|Z|Eastern Plaguelands|N|Run to Plaguewood Tower in Eastern Plaguelands.|
F Brill|QID|13017|M|18.46,27.36|Z|Eastern Plaguelands|N|Fly to Brill in Tirisfal Glade.|
b Vengeance Landing (Howling Fjord)|N|Take the zeppelin to Howling Fjord.|QID|13017|M|58.9,59.0|Z|Tirisfal Glades|LVL|68|

R Utgarde Keep|N|Head inside Utgarde Keep.|QID|13017|M|58.9,48.7|Z|Howling Fjord|RANK|3|LVL|68|
A Jarten the Elder|N|From Elder Jarten inside the instance. Down the stairs in Lower Pinnacle, after Dalronn the Controller.|QID|13017|M|47.41,69.55|Z|Njorndir Preparation@UtgardeKeep|RANK|3|LVL|68|
R Utgarde Pinnacle|N|Head out of Utgarde Keep, then run around north of the Keep to get to Utgarde Pinnacle.|QID|13067|M|58.0,50.1;57.25,46.63|Z|Howling Fjord|CS|RANK|3|LVL|77|
A Chogan'gada the Elder|N|From Elder Chogan'gada from inside the instance.|QID|13067|M|48.79,23.14|Z|Upper Pinnacle@UtgardePinnacle|RANK|3|LVL|77|

F Camp Oneqwah|N|Fly to Camp Oneqwah in Grizzly Hills.|QID|13030|M|79,29.6|Z|Howling Fjord|LVL|68|
A Whurain the Elder|N|From Elder Whurain.|QID|13030|M|64.18,46.98|Z|Grizzly Hills|LVL|68|
A Lunaro the Elder|N|From Elder Lunaro.|QID|13025|M|80.53,37.11|Z|Grizzly Hills|LVL|68|
A Beldak the Elder|N|From Elder Beldak.|QID|13013|M|60.4,27.6|Z|Grizzly Hills|T|Elder Beldak|LVL|68|
R Drak'Tharon Keep|N|Head into Drak'Tharon Keep.|QID|13023|M|17.42,21.2|Z|Grizzly Hills|RANK|3|LVL|71|
A Kilias the Elder|N|From Elder Kilias.|QID|13023|M|68.92,79.10|Z|The Vestibules of Drak'Tharon@DrakTharonKeep|RANK|3|LVL|71|
R Zim'Torga|N|Head out of Drak'Tharon Keep and head to Zim'Torga.|QID|13027|M|58.8,56|Z|Zul'Drak|RANK|3|LVL|68|
A Tauros the Elder|N|From Elder Tauros.|QID|13027|M|58.91,55.97|Z|Zul'Drak|LVL|68|
R Gundrak|N|Head inside of Gundrak.|QID|13065|M|76.43,21.43|Z|Zul'Drak|RANK|3|LVL|73|
A Ohanzee the Elder|N|From Elder Ohanzee.|QID|13065|M|45.64,61.50|Z|Gundrak|RANK|3|LVL|73|

R Camp Tunka'lo|N|Leave Gundrak and head over to Camp Tunka'lo.|QID|13032|M|65.4,50.7|Z|The Storm Peaks|LVL|68|
A Muraco the Elder|N|From Elder Muraco.|QID|13032|M|64.59,51.34|Z|The Storm Peaks|LVL|68|
F Ulduar|QID|13066|M|65.4,50.6|N|Fly to Ulduar in The Storm Peaks.|Z|The Storm Peaks|LVL|74|
R Halls of Stone|N|Run into the Halls of Stone.|QID|13066|M|39.57,26.92|Z|The Storm Peaks|RANK|3|LVL|74|
A Yurauk the Elder|N|From Elder Yurauk.|QID|13066|M|29.39,62.06|Z|Ulduar|RANK|3|LVL|74|
R The Storm Peaks|N|Exit the Halls of Stone|M|34.4, 36.2|Z|Ulduar|RANK|3|QID|13020|LVL|74|
A Stonebeard the Elder|N|From Elder Stonebeard.|QID|13020|M|31.26,37.61|Z|The Storm Peaks|LVL|68|
A Fargal the Elder|N|From Elder Fargal.|QID|13015|M|28.89,73.72|Z|The Storm Peaks|T|Elder Fargal|LVL|68|
A Graymane the Elder|N|From Elder Graymane.|QID|13028|M|41.16,84.72|Z|The Storm Peaks|LVL|68|

F Agmar's Hammer|N|Fly to Agmar's Hammer in Dragonblight.|QID|13014|M|40.6,84.6|Z|The Storm Peaks|LVL|68|
A Skywarden the Elder|N|From Elder Skywarden.|QID|13031|M|35.09,48.35|Z|Dragonblight|LVL|68|
A Morthie the Elder|N|From Elder Morthie.|QID|13014|M|29.75,55.90|Z|Dragonblight|T|Elder Morthie|LVL|68|
R Azjol-Nerub|N|Head inside of Azjol-Nerub.|QID|13022|M|25.99,50.86|Z|Dragonblight|RANK|3|LVL|69|
A Nurgen the Elder|N|From Elder Nurgen. He is down the hole after second boss to the left side, sitting in a clearing.|QID|13022|M|21.80,43.60|Z|The Brood Pit@AzjolNerub|RANK|3|LVL|69|
R Moa'ki Harbor|N|Run back out of Azjol-Nerub and head down to Moa'ki Harbor.|QID|13019|M|48.8,78|Z|Dragonblight|LVL|68|
A Thoim the Elder|N|From Elder Thoim.|QID|13019|M|48.77,78.17|Z|Dragonblight|LVL|68|
F Wintergrasp|N|Fly to Wintergrasp in Wintergrasp.|QID|13026|M|48.4,74.4|Z|Dragonblight|LVL|68|
A Bluewolf the Elder|N|From Elder Bluewolf. Just a note, if the Horde does not have Wintergrasp you may not be able to get this Elder. It may be possible though if the Alliance has control, if the main gate is damaged enough to fly into.|QID|13026|M|49.03,13.95|Z|Wintergrasp|LVL|68|

F River's Heart|N|Fly to River's Heart in Sholazar Basin.|QID|13018|M|21.6,34.8|Z|Wintergrasp|LVL|68|
A Sandrene the Elder|N|From Elder Sandrene.|QID|13018|M|49.78,63.62|Z|Sholazar Basin|LVL|68|
A Wanikaya the Elder|N|From Elder Wanikaya.|QID|13024|M|63.80,49.02|Z|Sholazar Basin|LVL|68|

F Transitus Shield|N|Fly to the Transitus Shield in Colderra.|QID|13016|M|50,61.4|Z|Sholazar Basin|LVL|68|
A Northal the Elder|N|From Elder Northal.|QID|13016|M|33.80,34.36|Z|Borean Tundra|LVL|68|
R The Nexus|N|Run into The Nexus.|QID|13021|M|27.5,26.09|Z|Borean Tundra|RANK|3|LVL|68|
A Igasho the Elder|N|From Elder Igasho.|QID|13021|M|55.19,64.72|Z|TheNexus|RANK|3|LVL|68|
R D.E.H.T.A Encampment|N|Head out of The Nexus and go to the D.H.E.T.A Encampment.|QID|13033|M|57.4,43.6|Z|Borean Tundra|LVL|68|
A Arp the Elder|N|From Elder Arp.|QID|13033|M|57.41,43.72|Z|Borean Tundra|LVL|68|
A Pamuya the Elder|N|From Elder Pamuya.|QID|13029|M|42.94,49.57|Z|Borean Tundra|LVL|68|
A Sardis the Elder|N|From Elder Sardis.|QID|13012|M|59.10,65.63|Z|Borean Tundra|T|Elder Sardis|LVL|68|

F Temple of Earth|QID|29735|N|Take the portal to Deepholm.|M|50.81,36.43|Z|Orgrimmar@Orgrimmar|LVL|82|
A Stonebrand the Elder|QID|29735|M|49.70,54.88|Z|Deepholm|N|From Elder Stonebrand|LVL|82|
A Deepforge the Elder|QID|29734|M|27.71,69.17|Z|Deepholm|N|From Elder Deepforge|LVL|82|
F Temple of Earth|QID|29734|M|50.81,53.08|Z|Deepholm|N|Fly back to the Temple of Earth and take the portal back to Orgrimmar.|LVL|82|

F Nordrassil|QID|29740|N|Take the portal to Mount Hyjal.|M|51.13,38.27|Z|Orgrimmar@Orgrimmar|LVL|80|
A Evershade the Elder|QID|29740|M|62.54,22.82|Z|Mount Hyjal|N|From Elder Evershade|LVL|80|
A Windsong the Elder|QID|29739|M|26.69,62.05|Z|Mount Hyjal|N|From Elder Windsong|LVL|80|

F Thundermar|QID|29736||N|Take the portal to the Twilight Highlands.|M|50.21,39.44|Z|Orgrimmar@Orgrimmar|LVL|84|
A Darkfeather the Elder|QID|29736|M|51.87,33.07|Z|Twilight Highlands|N|From Elder Darkfeather|LVL|84|
A Firebeard the Elder|QID|29737|M|50.91,70.45|Z|Twilight Highlands|N|From Elder Firebeard|LVL|84|
R Dragonmaw Port|QID|29738|M|73.58,53.52|Z|Twilight Highlands|N|Take the portal back to Orgrimmar.|LVL|84|

N The End |N|That's all for this year.|

]]
end)
