--[[
	Poll

	Version: v1.0.5.9
	Date:    2016-08-01T20:14:51Z
	Author:  lenwe-saralonde
]]

-- ===========================================
-- Core
-- ===========================================

-- Init configuration variables
function Poll_InitVars()
	PollVersion = 'v1.0.5'

    local configInitialisation =
    {
        ['system']    = "SAY",
        ['channel']   = "s",
        ['idChannel'] = 0,
        ['locale']    = GetLocale(),
    }

    if PollConfig == nil then
        PollConfig = {}
    end

    if PollConfig[PollMyID] == nil then
        PollConfig[PollMyID] = {}
    end

    for k, v in pairs(configInitialisation) do
    	if PollConfig[PollMyID][k] == nil then
    		 PollConfig[PollMyID][k] = v
    	end
    end

    Poll_New()
end


-- Inits a new poll

function Poll_New()
	PollItems = {}
	PollVotes = {}

	PollVoting = false
	PollTitle = ''
end


-- Set poll title
-- @param string title
function Poll_SetTitle(title)
	PollTitle = title

	local s = string.gsub(PollMsg['Title'], "TITLE", PollTitle)
	DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)
end


-- Sets the item at index. If index is null, the item will
-- be added at then end of the table
-- @param string  itemName
-- @param integer index
function Poll_SetItem(itemName, index)
	local i
	local tableKeys
	local foundIndex

	itemName = Poll_Trim(itemName)

	if (index ~= nil) then
		index = math.floor(index)

		if (index <= 0) then
			DEFAULT_CHAT_FRAME:AddMessage(PollMsg['InvalidIndex'],1,0,0)
			PlaySoundFile("Sound\\interface\\Error.wav")
			return false
		end

		PollItems[index] = itemName
	else
		foundIndex = Poll_GetIndexByItemName(itemName)
		if (foundIndex ~= nil) then
			return Poll_SetItem(itemName, foundIndex)
		end

		table.insert(PollItems, itemName)
		index = Poll_GetIndexByItemName(itemName)
	end

	Poll_OrderItems()
	DEFAULT_CHAT_FRAME:AddMessage(index..'. '..itemName,1,1,1)

	return true
end


-- Removes the item at index
function Poll_RemoveItem(index)
	if (PollItems[index] == nil) then
		DEFAULT_CHAT_FRAME:AddMessage(PollMsg['ItemNotFound'],1,0,0)
		PlaySoundFile("Sound\\interface\\Error.wav")
		return false
	end

	local itemName = PollItems[index]
	table.remove(PollItems, index)

	local s = string.gsub(PollMsg['ItemRemoved'], "ITEM", itemName)
	DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)

	Poll_OrderItems()

	return true
end


-- Shows the list of items
function Poll_List()
	local index, itemName

	if(PollTitle ~= "") then
		local s = string.gsub(PollMsg['Title'], "TITLE", PollTitle)
		DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)
	end

	for index, itemName in pairs(PollItems) do
		DEFAULT_CHAT_FRAME:AddMessage(index..'. '..itemName,1,1,1)
	end
end


-- Sets a vote for a player
-- @param string  player
-- @param string  indexOrItemName
-- @param boolean withVoteCommand
function Poll_Vote(player, indexOrItemName, withVoteCommand)
	local index
	local indexValid, alreadyVoted

	-- Not voting, nothing to do here
	if (not PollVoting) then
		return false
	end

	indexOrItemName = Poll_Trim(indexOrItemName)

	-- Get numeric index
	index = tonumber(indexOrItemName)

	-- Not a numeric index, find index from item name
	if (index == nil) then
		index = Poll_GetIndexByItemName(indexOrItemName)
	end

	-- The index is not valid
	indexValid = (index ~= nil) and (PollItems[index] ~= nil)

	-- Check if player already voted
	alreadyVoted = (PollVotes[player] ~= nil)

	-- Send not valid index message
	if (not indexValid and withVoteCommand and not alreadyVoted) then
		local s = string.gsub(PollMsg['VoteInvalidIndex'], "ITEM", indexOrItemName)
		Poll_Whisper(player, s)
	end

	-- Send already voted message
	if ((indexValid or withVoteCommand) and alreadyVoted and (not PollVotes[player]['notify'])) then
		local s = string.gsub(PollMsg['AlreadyVoted'], "ITEM", PollItems[PollVotes[player]['item']])
		Poll_Whisper(player, s)
		PollVotes[player]['notify'] = true
	end

	-- No vote if already voted or invalid index
	if (not indexValid or alreadyVoted) then
		return false
	end

	-- Proceed vote
	PollVotes[player] = {}
	PollVotes[player]['notify'] = false
	PollVotes[player]['item']   = index

	-- Send confirmation message
	local s = string.gsub(PollMsg['VoteOK'], "ITEM", PollItems[PollVotes[player]['item']])
	Poll_Whisper(player, s)

	-- Count votes
	local numVotes = 0
	for _, _ in pairs(PollVotes) do
		numVotes = numVotes + 1
	end

	-- Stop votes if limit reached
	if (numVotes == PollVoteLimit) then
		Poll_StopVote()
	end

	return true
end


-- Starts the voting sequence. Stops after duration seconds or maxVotes votes
-- Both duration and maxVotes are optional
-- @param integer duration
-- @param integer maxVotes
function Poll_StartVote(duration, maxVotes)
	local s

	if (PollVoting == true) then
		return false
	end

	if (#PollItems < 2) then
		DEFAULT_CHAT_FRAME:AddMessage(PollMsg['NoEnoughItemsError'],1,0,0)
		PlaySoundFile("Sound\\interface\\Error.wav")
		return false
	end

	-- set duration
	if  (duration == nil) then
		PollVoteDuration = 0
	else
		duration = tonumber(duration)

		if ((duration ~= nil) and (duration < 0)) then
		  duration = nil
		end

		if (duration == nil) then
			DEFAULT_CHAT_FRAME:AddMessage(PollMsg['DurationError'],1,0,0)
			  PlaySoundFile("Sound\\interface\\Error.wav")
			  return false
		end

		PollVoteDuration = duration

		if (PollVoteDuration > 0) then
			s = string.gsub(PollMsg['Duration'], "DURATION", PollVoteDuration)
			DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)
		end
	end

	-- set vote limit
	if (maxVotes == nil) then
		PollVoteLimit = 0
	else
		maxVotes = tonumber(maxVotes)

		if (maxVotes ~= nil) then
			maxVotes = math.floor(maxVotes)
			if (maxVotes < 0) then
				maxVotes = nil
			end
		end

		if (maxVotes == nil) then
			DEFAULT_CHAT_FRAME:AddMessage(PollMsg['VoteLimitError'],1,0,0)
				PlaySoundFile("Sound\\interface\\Error.wav")
			return false
		end

		PollVoteLimit = maxVotes
		if (PollVoteLimit > 0) then
			s = string.gsub(PollMsg['VoteLimit'], "LIMIT", PollVoteLimit)
			DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)
		end
	end

	PollVotes = {}
	PollFrame.TimeSinceLastUpdate = 0
	PollVoting = true

    Poll_SendPollMessage(true)
end


-- Sends the poll instructions on the channel.
-- If newPoll is false, the message is sent as a reminder
-- @param boolean newPoll
function Poll_SendPollMessage(newPoll)
	if (PollVoting ~= true) then
		return false
	end

	-- start vote !
	local rows, index, itemName, s

	rows = {}
	for index, itemName in pairs(PollItems) do
		table.insert(rows, index..'. '..itemName)
	end

	if (newPoll) then
		s = PollMsg['VoteStarted']
	else
		s = PollMsg['CurrentVote']
	end

	if (PollTitle ~= "") then
		s = string.gsub(s, "TITLE", "\""..PollTitle.."\"")
	else
		s = string.gsub(s, "TITLE", "")
	end

	Poll_Say(Poll_Trim(s))
	Poll_Say(Poll_OptimizeListForSay(rows))

	s = PollMsg['VoteInstructions']
	if (PollVoteDuration > 0) then
		s = s..' '..PollMsg['Duration']
	end

	s = string.gsub(s, "PLAYER",   UnitName("player"))
	s = string.gsub(s, "COMMAND",  string.upper(PollMsg['VoteCommand']))

	if (newPoll) then
		 s = string.gsub(s, "DURATION", PollVoteDuration)
	else
		 s = string.gsub(s, "DURATION", math.floor(PollVoteDuration - PollFrame.TimeSinceLastUpdate))
	end

	Poll_Say(s)
end


-- Stops the voting sequence and announces the results.
function Poll_StopVote()
	PollVoting = false

	local stuffToSay = {}
	local results = Poll_GetResults()

	if (#results > 0) then
		stuffToSay = results
		stuffToSay[1] = PollMsg['VoteOver']..PollMsg['VoteResults']..results[1]
		stuffToSay = Poll_OptimizeListForSay(stuffToSay)
		Poll_Say(stuffToSay)
	end
end


-- Returns the table of the vote results
-- @return table
function Poll_GetResults()
	local itemsCount = {}
	local player, playerRow, index
	local totalCount = 0

	if (#PollItems == 0) then
		return {}
	end

	for index, _ in pairs(PollItems) do
		itemsCount[index] = {}
		itemsCount[index]['num']  = 0
		itemsCount[index]['item'] = index
	end

	for player, playerRow in pairs(PollVotes) do
		itemsCount[playerRow['item']]['num'] = itemsCount[playerRow['item']]['num'] + 1
		totalCount = totalCount + 1
	end

	table.sort(itemsCount, Poll_CompareResults)

	local resultsTable = {}
	local value
	local position = 1

	if (totalCount == 0) then
		totalCount = 1
	end

	for index, value in pairs(itemsCount) do
		table.insert(resultsTable, position..'. '..
			                         PollItems[value['item']]..' : '..
															 value['num']..
															 ' ('..math.floor(0.5 + 100 * value['num'] / totalCount)..' %)')
		position = position + 1
	end

	return resultsTable
end


-- Comparison function for Poll_GetResults()
-- @param table rowA
-- @param table rowB
-- @return boolean
function Poll_CompareResults(rowA, rowB)
	return rowA['num'] > rowB['num']
end


-- Show the vote results or say them if sayResults is truc
-- @param boolean sayResults
function Poll_ShowResults(sayResults)
	local stuffToSay = {}
	local results = Poll_GetResults()

	if (#results == 0) then
		return
	end

	if (sayResults) then
		stuffToSay = results
		stuffToSay[1] = PollMsg['VoteResults']..results[1]
		stuffToSay = Poll_OptimizeListForSay(stuffToSay)
		Poll_Say(stuffToSay)
	else
		local row

		DEFAULT_CHAT_FRAME:AddMessage(PollMsg['VoteResults'],1,1,1)
		for _, row in pairs(results) do
			DEFAULT_CHAT_FRAME:AddMessage(row,1,1,1)
		end
	end
end


-- Reorder items by index
function Poll_OrderItems()
	local index, itemName
	local indexes, newItemList

	newItemList = {}
	indexes = {}

	for index, _ in pairs(PollItems) do
		table.insert(indexes, index)
	end

	table.sort(indexes)

	for _, index in pairs(indexes) do
		newItemList[index] = PollItems[index]
	end

	PollItems = newItemList
end


-- Returns the item index using its item name
-- Returns nil if not found
-- @param string itemName
-- @return integer
function Poll_GetIndexByItemName(itemName)
	local index, anItemName

	itemName = Poll_StripAccents(string.lower(Poll_Trim(itemName)))

	for index, anItemName in pairs(PollItems) do
		if (itemName == Poll_StripAccents(string.lower(Poll_Trim(anItemName)))) then
		  return index
		end
	end

	return nil
end


-- Remove spaces at the beginning and end of the string and turns
-- multiple spaces into a single one
-- @param string str
-- @return string
function Poll_Trim(str)
	if(str == nil) then return "" end

	str = string.gsub(str, "%s+", " ")
	str = string.gsub(str, "^%s", "")
	str = string.gsub(str, "%s$", "")

	return str
end


-- Remove all accents from string
-- @param string str
-- @return string
function Poll_StripAccents(str)
	local a, r, accents

	accents = {
		["À"] = "A",
		["Á"] = "A",
		["Â"] = "A",
		["Ã"] = "A",
		["Ä"] = "A",
		["Å"] = "A",
		["à"] = "a",
		["á"] = "a",
		["â"] = "a",
		["ã"] = "a",
		["ä"] = "a",
		["å"] = "a",
		["Ò"] = "O",
		["Ó"] = "O",
		["Ô"] = "O",
		["Õ"] = "O",
		["Ö"] = "O",
		["Ø"] = "O",
		["ò"] = "o",
		["ó"] = "o",
		["ô"] = "o",
		["õ"] = "o",
		["ö"] = "o",
		["ø"] = "o",
		["È"] = "E",
		["É"] = "E",
		["Ê"] = "E",
		["Ë"] = "E",
		["è"] = "e",
		["é"] = "e",
		["ê"] = "e",
		["ë"] = "e",
		["Ç"] = "C",
		["ç"] = "c",
		["Ì"] = "I",
		["Í"] = "I",
		["Î"] = "I",
		["Ï"] = "I",
		["ì"] = "i",
		["í"] = "i",
		["î"] = "i",
		["ï"] = "i",
		["Ù"] = "U",
		["Ñ"] = "U",
		["Û"] = "U",
		["Ü"] = "U",
		["ù"] = "u",
		["ú"] = "u",
		["û"] = "u",
		["ü"] = "u",
		["ÿ"] = "y",
		["Ñ"] = "N",
		["ñ"] = "n"
	}

	for a, r in pairs(accents) do
		str = string.gsub(str, a, r)
	end

	return str
end


-- Script initialization.
function Poll_OnLoad()
	PollMyID = GetRealmName()..'-'..UnitName("player")

	PollFrame:RegisterEvent("VARIABLES_LOADED")
	PollFrame:RegisterEvent("CHAT_MSG_WHISPER")

	PollFrame.TimeSinceLastUpdate = 0
	PollVoting = false

	PollFrame:SetScript("OnEvent",  Poll_OnEvent)
	PollFrame:SetScript("OnUpdate", Poll_OnUpdate)
end


function Poll_OnEvent(this, event, ...)
	local element
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 = ...

	-- Init saved variables
	if (event == "VARIABLES_LOADED") then
		Poll_InitVars()
		local s = string.gsub(PollMsg['Loaded'], "VERSION", 	PollVersion)
		DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)
		return

	elseif (event == "CHAT_MSG_WHISPER") then
		-- arg1: message, arg2: player
		arg1 = string.lower(Poll_Trim(arg1))
		element = string.find(arg1, "^"..PollMsg['VoteCommand'].." *(.+)")
		if (element ~= nil) then
			element = string.gsub(arg1, "^"..PollMsg['VoteCommand'].." *(.+)", "%1")
			Poll_Vote(arg2, element, true)
			return
		end

		Poll_Vote(arg2, arg1, false)
	end
end


function Poll_OnUpdate(this, arg1)
	if ((not PollVoting) or (PollVoteDuration == 0)) then return end

	PollFrame.TimeSinceLastUpdate = PollFrame.TimeSinceLastUpdate + arg1
	if( PollFrame.TimeSinceLastUpdate > PollVoteDuration ) then
		-- End Vote
		Poll_StopVote()
	end
end


-- Returns a table of messages in order to be sent in a chat message
-- sending the less lines as possible
-- @param table   list
-- @param integer limit
-- @return table
function Poll_OptimizeListForSay(list, limit)
	local lines, aLine, currentLine

	if (limit == nil) then
		limit = 255
	end

	currentLine = ''
	lines = {}
	for _, aLine in pairs(list) do
		if (string.len(currentLine) + string.len(aLine) + 2 > limit) then
			table.insert(lines, currentLine)
			currentLine = aLine
		else
			if (currentLine ~= '') then
				currentLine = currentLine..", "
			end

			currentLine = currentLine..aLine
		end
	end

  if (currentLine ~= "") then
		table.insert(lines, currentLine)
	end

	return lines
end


-- Sends a message in the selected channel
-- msg can be a string or a table
-- @param string msg
function Poll_Say(msg)
	local row

	if (type(msg) == 'table') then
		for _, row in pairs(msg) do
			SendChatMessage(row, PollConfig[PollMyID]['system'], nil, GetChannelName(PollConfig[PollMyID]['idChannel']))
		end
		return
	end

	SendChatMessage(msg, PollConfig[PollMyID]['system'], nil, GetChannelName(PollConfig[PollMyID]['idChannel']))
end


-- Sends a whisper message to the given player
-- @param string player
-- @param string msg
function Poll_Whisper(player, msg)
	local row

	if (type(msg) == 'table') then
		for _, row in pairs(msg) do
			SendChatMessage(row, "WHISPER", nil, player)
		end
		return
	end

	SendChatMessage(msg, "WHISPER", nil, player)
end


-- Shows help
function Poll_Help()
	local row
	for _, row in pairs(PollMsg['Help']) do
		DEFAULT_CHAT_FRAME:AddMessage(row,1,1,1)
	end
end


-- Set poll channel
-- Accepted values : s, say, guild, raid, party and currently joined channels
-- @param string ch
function Poll_SetChannel(ch)
	PollConfig[PollMyID]['system'] = ""
	if ((ch == "say") or (ch == "s")) then
		PollConfig[PollMyID]['system']	= "SAY"
		PollConfig[PollMyID]['channel'] 	= ch
		PollConfig[PollMyID]['idChannel'] = 0
	end
	if ((ch == "guild") or (ch == "g")) then
		PollConfig[PollMyID]['system']  	= "GUILD"
		PollConfig[PollMyID]['channel'] 	= ch
		PollConfig[PollMyID]['idChannel'] = 0
	end
	if (ch == "raid") then
		PollConfig[PollMyID]['system']  = "RAID"
		PollConfig[PollMyID]['channel'] = ch
		PollConfig[PollMyID]['idChannel'] = 0
	end
	if ((ch == "gr") or (ch == "party")) then
		PollConfig[PollMyID]['system']  	= "PARTY"
		PollConfig[PollMyID]['channel'] 	= ch
		PollConfig[PollMyID]['idChannel'] = 0
	end
	if (ch == "bg") then
		PollConfig[PollMyID]['system']  	= "BATTLEGROUND"
		PollConfig[PollMyID]['channel'] 	= ch
		PollConfig[PollMyID]['idChannel'] = 0
	end
	if(PollConfig[PollMyID]['system'] == "") then
		if (GetChannelName(ch) ~= 0) then
			PollConfig[PollMyID]['idChannel'] = ch
			PollConfig[PollMyID]['system']    = "CHANNEL"
			PollConfig[PollMyID]['channel']   = ch
		end
	end

	-- Bad channel
	if(PollConfig[PollMyID]['system'] == "") then
		PollConfig[PollMyID]['system']  	= "SAY"
		PollConfig[PollMyID]['channel']  = "s"
		local s = string.gsub(PollMsg['ChannelError'], "CHANNEL", ch)
    	DEFAULT_CHAT_FRAME:AddMessage(s,1,0,0)
		return false
	end

	local s = string.gsub(PollMsg['Channel'], "CHANNEL", PollConfig[PollMyID]['channel'])
	DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)

	return true
end


-- ===========================================
-- slash commands
-- ===========================================

-- /poll option [value [value2]..]

SlashCmdList["POLL"] = function(commandLine)
	local c, a, a1, a2
	local commandName, args, arg1, arg2

	-- Récupération de la commande et des paramètres
	commandName = ''
	args = ''
	arg1 = ''
	arg2 = ''
	for c, a in string.gmatch(commandLine, " *(%a+) *(.*) *") do
		if (c == nil) then commandName = '' else commandName = string.lower(c) end
		if (a == nil) then args = '' else args = a end

		for a1, a2 in string.gmatch(args, " *(%w+) *(.*) *") do
			if (a1 == nil) then arg1 = '' else arg1 = a1 end
			if (a2 == nil) then arg2 = '' else arg2 = a2 end
		end
	end

	if     ((commandName == "chan") or (commandName == "channel")) then
    Poll_SetChannel(args)

	elseif (commandName == "help") then
		Poll_Help()

	elseif (commandName == "new") then
		Poll_New()
		DEFAULT_CHAT_FRAME:AddMessage(PollMsg['New'],1,1,1)

		if (args ~= '') then
		  Poll_SetTitle(args)
		end

	elseif (commandName == "title") then
		Poll_SetTitle(args)

	elseif ((commandName == "add") or (commandName == "set") or (commandName == "item")) then
		local index
		index = tonumber(arg1)

		if (index ~= nil and (arg2 ~= "")) then
			Poll_SetItem(arg2, index)
		else
			Poll_SetItem(args)
		end

	elseif (commandName == "remove") then
		local index
		index = tonumber(args)

		if (index == nil) then
			index = Poll_GetIndexByItemName(args)
		end

		if (index ~= nil) then
			Poll_RemoveItem(index)
		end

	elseif (commandName == "start") then
		if (arg1 == '') then arg1 = 0 end
		if (arg2 == '') then arg2 = 0 end
		Poll_StartVote(arg1, arg2)

	elseif ((commandName == "stop") or (commandName == "end")) then
		Poll_StopVote()

	elseif ((commandName == "list") or (commandName == "items")) then
		Poll_List()

	elseif ((commandName == "instructions") or (commandName == "announce") or (commandName == "send")) then
		Poll_SendPollMessage(false)

	elseif (commandName == "results") then
		if (args ~= "") then
			Poll_ShowResults(true)
		else
			Poll_ShowResults(false)
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(PollMsg['UnknownCommand'],1,0,0)
  		PlaySoundFile("Sound\\interface\\Error.wav")
	end
end

SLASH_POLL1 = "/poll"
SLASH_POLL2 = "/vote"