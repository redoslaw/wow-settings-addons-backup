-- Version : German ( by DOcean2 )
-- Last Update : 23/01/2010

if ( GetLocale() == "deDE" ) then

PollMsg['VoteCommand'] = "vote"

PollMsg['ChannelError'] = "Channel /CHANNEL ungültig."
PollMsg['Channel']      = "Der Channel ist jetzt /CHANNEL."

PollMsg['UnknownCommand'] = "Unbekanntes Kommando. Tippe /poll help für eine Hilfe."

PollMsg['Loaded']       = "Poll VERSION geladen. Tippe /poll help für Hilfe."
PollMsg['New']          = "Eine neue Umfrage wurde gestartet."
PollMsg['Title']        = "Der Titel der Umfrage ist \"TITLE\"."
PollMsg['InvalidIndex'] = "Ungütilger Index."

PollMsg['ItemNotFound'] = "Kein Eintrag an dieser Postion."
PollMsg['ItemRemoved']  = "Eintrag \"ITEM\" wurde entfernt."

PollMsg['VoteInvalidIndex']  = "\"ITEM\" gehört nicht zu den Umfrage Optionen."
PollMsg['VoteOK']            = "Deine Stimme für \"ITEM\" wurde gezählt! Danke."
PollMsg['AlreadyVoted']      = "Du hast bereist abgestimmt, für \"ITEM\", du kannst deine Wahl nicht ändern."

PollMsg['VoteStarted']      = "Die Abstimmung TITLE wurde gestartet! Die Optionen sind:"
PollMsg['CurrentVote']      = "Die Abstimmung TITLE läuft! Die Optionen sind:"
PollMsg['VoteInstructions'] = "Um abzustimme, sende  /w PLAYER COMMAND gefolgt von der Nummer."

PollMsg['Duration']           = "Die Umfragedauer ist DURATION Sekunden."
PollMsg['DurationError']      = "Ungültige Dauer."

PollMsg['VoteLimit']          = "Das Umfragelimit ist LIMIT ."
PollMsg['VoteLimitError']     = "Ungültige maximale Auswahlanzahl."

PollMsg['NoEnoughItemsError'] = "Es müssen mindestens 2 Optionen vorhanden sein."

PollMsg['VoteOver'] = "Die Abstimmung ist vorbei!"
PollMsg['VoteResults'] = "Das Ergebnis ist:"

PollMsg['Help'] =  {
		"===== Poll =====",
		"/poll <command> [<parameters>]",

		"- channel [<channel>] : Setzte Spiel Channel (say, raid, party, guild, 1-10).",
		"- new [<title>] : Starte eine neue Abstimmung.",
		"- title <title> : Setzt den Abstimmungs Titel.",
		"- item [<index>] <itemName> : (Er-)setzt eine Umfragenoption.",
		"- remove <index> : Entfernt einen Auswahlpunkt.",
		"- start [<duration> [<maxVotes>]] : Starte die Abstimmung. Die Dauer und die Anzahl an Stimmen can limitiert werden (0=unendlich). ",
		"- send : Sendet die Umfrage in den eingestellten Channel.",
		"- stop : Beendet die Abstimmung und zeigt das Ergebnis.",
		"- list : Zeigt die Möglichkeiten.",
		"- results [<announce>] : Zeigt die Ergebnisse. Wenn \"announce\" gesetzt ist, wir in den Channel geschrieben.",
		"- help : Zeigt dieses Ausgabe.",
	}
	
end