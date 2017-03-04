-- GLOBALS
KB_whisperMessage = ""
KB_whisperSender = ""
KB_whisperClass = 0
KB_applicants = {}
KB_applicants[0] = {}	

-- Invisibleframe to hold events
local whispers = CreateFrame("Frame", nil, UIParent)

local function addApplicant(dungeon, key, name, loot)
	for x = 1, #KB_applicants do
		if KB_applicants[x][2] == name then
			dungeon = C_ChallengeMode.GetMapInfo(dungeon)
			KB_applicants[x][0] = dungeon
			KB_applicants[x][1] = key
			KB_applicants[x][3] = loot
			return
		end
	end
	dungeon = C_ChallengeMode.GetMapInfo(dungeon)
	local number = #KB_applicants + 1 
	KB_applicants[number] = {}
	KB_applicants[number][0] = dungeon
	KB_applicants[number][1] = key
	KB_applicants[number][2] = name
	KB_applicants[number][3] = loot
	
	KB_premadeUpdate()
end


local function handleWhisper()
	originalLinkSubstring = strsub(KB_whisperMessage, 11, strfind(KB_whisperMessage, '|h') - 1)
	parts = { strsplit(':', originalLinkSubstring) }
	local length = #parts
	if tonumber(parts[2]) == 138019 then
		dungeonID = tonumber(parts[15])
		keystoneLevel = tonumber(parts[16])
		local affixes = parts[12]
		local key_depleted_mask = 4194304
		local depleted = (bit.band(affixes, key_depleted_mask) ~= key_depleted_mask)
		addApplicant(dungeonID, keystoneLevel, KB_whisperSender, depleted)
	end
end

local function handleWhisperBN()
	originalLinkSubstring = strsub(KB_whisperMessage, 11, strfind(KB_whisperMessage, '|h') - 1)
	parts = { strsplit(':', originalLinkSubstring) }
	
	local length = #parts
	
	
	if tonumber(parts[1]) == 8019 then
		dungeonID = tonumber(parts[14])
		keystoneLevel = tonumber(parts[15])
		local affixes = parts[12]
		local key_depleted_mask = 4194304
		local depleted = (bit.band(affixes, key_depleted_mask) ~= key_depleted_mask)
		addApplicant(dungeonID, keystoneLevel, KB_whisperSender, depleted)
	end
end

local function eventHandler(self, event, prefix, msg, channel, sender, presenceID)
	if event == 'LFG_LIST_APPLICANT_LIST_UPDATED' then
		KB_premadeUpdate()
	end
	if event == 'CHAT_MSG_WHISPER' then
		KB_whisperSender = msg
		KB_whisperMessage = prefix
		if pcall(handleWhisper) then
			--print("Success")
		else
			--print("Failure")
		end
	end
	if event == 'CHAT_MSG_BN_WHISPER'  then
		KB_whisperSender = msg
		KB_whisperMessage = prefix
		
		local _, numFreinds = BNGetNumFriends()
				
		for index = 1, numFreinds do
			local name = select(2, BNGetFriendInfo(index))
			if KB_whisperSender == name then
				local bnetIDGameAccount, client = select(6, BNGetFriendInfo(index))
				client = select(7, BNGetFriendInfo(index))
				if client == "WoW" then
					local _, characterName, _, realmName, _, faction, _, class = BNGetGameAccountInfo(bnetIDGameAccount)
					local factionGroup, factionName = UnitFactionGroup("player")
					if faction == factionGroup then
						KB_whisperSender = characterName.."-"..realmName
						if pcall(handleWhisperBN) then
							--print("Success")
						else
							--print("Failure")
						end
					end
				end
			end
		end
	end
end

function KB_ApplicantsClear()
	KB_applicants = {}
	KB_applicants[0] = {}
end

whispers:RegisterEvent('CHAT_MSG_WHISPER')
whispers:RegisterEvent('CHAT_MSG_BN_WHISPER')
whispers:RegisterEvent('LFG_LIST_APPLICANT_LIST_UPDATED')
whispers:SetScript('OnEvent', eventHandler)

-- TEST FUNCTIONS
function printApplicants()
	for x=1, #KB_applicants do
		print(KB_applicants[x][2])
	end
end