local m = {}
 function getMyKeystone()
	-- GetItemInfo() returns generic info, not info about the player's particular keystone
	-- name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(138019)
	
	-- The best way I could find was to scan the player's bags until a keystone is found, and then rip the info out of the item link
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			if(GetContainerItemID(bag, slot) == 138019) then
				originalLink = GetContainerItemLink(bag, slot)
				parts = { strsplit(':', originalLink) }
				
				--[[
				Thanks to http://wow.gamepedia.com/ItemString for the [Mythic Keystone] link format:
				1: color prefix
				2: itemID
				3: enchantID
				4: gemID1
				5: gemID2
				6: gemID3
				7: gemID4
				8: suffixID
				9: uniqueID
				10: playerLevel
				11: specID
				12: upgradeTypeID (maps to numAffixes)
				13: difficultyID
				14: numBonusIDs
				15..X: bonusID
				X..Y: upgradeID (dungeonID, keystoneLevel, affixIDs..., lootEligible)
				Y..: (numRelicIDs, relicIDs, ...)
				]]
				
				upgradeTypeID = tonumber(parts[12])
				-- These don't seem right, but I don't have a pile of keystones to test with. Going to get the number of affixes from the level for now instead
				-- numAffixes = ({[4587520] = 0, [5111808] = 1, [6160384] = 2, [4063232] = 3})[upgradeTypeID]
				dungeonID = tonumber(parts[15])
				keystoneLevel = tonumber(parts[16])
				numAffixes = ({0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3})[keystoneLevel]
				affixIDs = {}
				for i = 0, numAffixes - 1 do
					tinsert(affixIDs, tonumber(parts[17 + i]))
				end
				lootEligible = (tonumber(parts[17 + numAffixes]) == 1)
				return dungeonID, keystoneLevel, affixIDs, lootEligible
			end
		end
	end 
end

function renderKeystoneLink(dungeonID, keystoneLevel, affixIDs, lootEligible)
	dungeonName = C_ChallengeMode.GetMapInfo(dungeonID)
	numAffixes = #affixIDs
	linkColor = ({[0] = '00ff00', [1] = 'ffff00', [2] = 'ff0000', [3] = 'a335ee'})[numAffixes]
	if not lootEligible then
		linkColor = '999999'
	end
	originalLinkSubstring = strsub(originalLink, 11, strfind(originalLink, '|h') - 1)
	link = format("|TInterface\\Icons\\Achievement_PVP_A_%02d:16|t |cff%s%s|h[%s +%d]|r", keystoneLevel, linkColor, originalLinkSubstring, dungeonName, keystoneLevel)
	if numAffixes > 0 then
		affixNames = {}
		for i, id in ipairs(affixIDs) do
			affixName, affixDesc = C_ChallengeMode.GetAffixInfo(id)
			tinsert(affixNames, strlower(affixName))
		end
		link = format("%s (%s)", link, table.concat(affixNames, '/'))
	end
	if not lootEligible then
		link = link .. " (depleted)"
	end
	return link
end

function GetKey()
	link = renderKeystoneLink(getMyKeystone())
	return link
end

return m