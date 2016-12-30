-- Version : English (default) ( by lenwe-saralonde )
-- Last Update : 22/05/2006

PollMsg = {}

PollMsg['VoteCommand'] = "vote"

PollMsg['ChannelError'] = "Channel /CHANNEL is invalid."
PollMsg['Channel']      = "The channel is now /CHANNEL."

PollMsg['UnknownCommand'] = "Unknown command. Type /poll help for command list."

PollMsg['Loaded']       = "Poll VERSION loaded. Type /poll help for help."
PollMsg['New']          = "A new poll has been created."
PollMsg['Title']        = "Poll title is \"TITLE\"."
PollMsg['InvalidIndex'] = "Invalid index."

PollMsg['ItemNotFound'] = "No item at this index."
PollMsg['ItemRemoved']  = "Item \"ITEM\" has been removed."

PollMsg['VoteInvalidIndex']  = "\"ITEM\" does not belong to the poll options."
PollMsg['VoteOK']            = "Your vote for \"ITEM\" has been accounted. Thank you!"
PollMsg['AlreadyVoted']      = "Your have already voted for \"ITEM\", you cannot change this anymore."

PollMsg['VoteStarted']      = "The vote TITLE has begun! The options are:"
PollMsg['CurrentVote']      = "The vote TITLE is in progress. The options are:"
PollMsg['VoteInstructions'] = "To vote, send  /w PLAYER COMMAND followed by option number."

PollMsg['Duration']           = "The vote duration is DURATION seconds."
PollMsg['DurationError']      = "Invalid duration."

PollMsg['VoteLimit']          = "Le vote limit is LIMIT votes."
PollMsg['VoteLimitError']     = "Invalid max votes number limit."

PollMsg['NoEnoughItemsError'] = "There must be at least 2 vote options."

PollMsg['VoteOver'] = "The vote is over! "
PollMsg['VoteResults'] = "The vote results are: "

PollMsg['Help'] =  {
		"===== Poll =====",
		"/poll <command> [<parameters>]",

		"- channel [<channel>] : Sets game channel (say, raid, party, guild, 1-10).",
		"- new [<title>] : Creates a new poll.",
		"- title <title> : Sets poll title.",
		"- item [<index>] <itemName> : Sets or replaces a vote option.",
		"- remove <index> : Removes a vote option.",
		"- start [<duration> [<maxVotes>]] : Starts the poll. The duration and number of votes can be limited (0 = unlimited). ",
		"- send : Sends the options list and the voting instructions in the channel.",
		"- stop : Ends the poll and announces the results.",
		"- list : Shows the vote options.",
		"- results [<announce>] : Displays vote results. If \"announce\" is set, the results will be announced in the channel.",
		"- help : Shows this help message.",
	}