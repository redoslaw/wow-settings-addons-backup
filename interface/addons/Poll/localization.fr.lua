-- Version : French ( by lenwe-saralonde )
-- Last Update : 22/05/2006

if ( GetLocale() == "frFR" ) then

PollMsg['VoteCommand'] = "vote"

PollMsg['ChannelError'] = "Le canal /CHANNEL est invalide."
PollMsg['Channel']      = "Le canal est maintenant /CHANNEL."

PollMsg['UnknownCommand'] = "Commande inconnue. Tapez /poll help pour obtenir la liste des commandes."

PollMsg['Loaded']       = "Poll VERSION chargé. Tapez /poll help pour obtenir de l'aide."
PollMsg['New']          = "Un nouveau sondage a été créé."
PollMsg['Title']        = "Le titre du sondage est \"TITLE\"."
PollMsg['InvalidIndex'] = "Index non valide."

PollMsg['ItemNotFound'] = "Aucun élément à cet index."
PollMsg['ItemRemoved']  = "L'élément \"ITEM\" a été retiré."

PollMsg['VoteInvalidIndex'] = "\"ITEM\" ne fait pas partie des options du vote."
PollMsg['VoteOK']           = "Votre vote pour \"ITEM\" a bien été pris en compte. Merci !"
PollMsg['AlreadyVoted']     = "Vous avez déjà voté pour \"ITEM\" et vous ne pouvez plus voter à nouveau."

PollMsg['VoteStarted']      = "Le vote TITLE vient de commencer ! Les options sont :"
PollMsg['CurrentVote']      = "Le vote TITLE est en cours. Les options sont :"
PollMsg['VoteInstructions'] = "Pour voter, envoyez  /w PLAYER COMMAND suivi du numéro de l'option."

PollMsg['Duration']           = "La durée du vote est de DURATION secondes."
PollMsg['DurationError']      = "Durée invalide."

PollMsg['VoteLimit']          = "Le vote est limité à LIMIT voix."
PollMsg['VoteLimitError']     = "Nombre de votants maximum invalide."

PollMsg['NoEnoughItemsError'] = "Il doit y avoir au moins 2 options de vote."

PollMsg['VoteOver'] = "Le vote est terminé ! "
PollMsg['VoteResults'] = "Les résultats du vote sont : "

PollMsg['Help'] =  {
		"===== Poll =====",
		"/poll <commande> [<paramètres>]",

		"- channel [<canal>] : Définit le canal de jeu (say, raid, party, guild, 1-10).",
		"- new [<titre>] : Créée un nouveau sondage.",
		"- title <titre> : Définit le titre du sondage.",
		"- item [<index>] <nomElement> : Ajoute ou remplace une option de vote.",
		"- remove <index> : Supprime une option de vote.",
		"- start [<durée> [<maxVotants>]] : Démarre le vote. La durée du vote et le nombre de votants peuvent être limités (0 = illimité). ",
		"- send : Envoie la liste des options et les instructions de vote dans le canal.",
		"- stop : Termine le vote en cours et annonce les résultats.",
		"- list : Affiche toutes les options de vote.",
		"- results [<annonce>] : Affiche le résultat des votes. Si le paramètre \"annonce\" est spécifié, les résultats sont annoncés dans le canal.",
		"- help : Affiche ce message d'aide.",
	}

end

