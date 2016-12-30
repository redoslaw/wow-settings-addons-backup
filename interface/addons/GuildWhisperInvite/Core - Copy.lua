local options = { 
	type='group',
	args = {
		phrase = {
			type = 'text',
			name = 'phrase',
			desc = 'The phrase which triggers a guild-invite',
			usage = "<Your phrase here>",
			get = "GetPhrase",
			set = "SetPhrase",
		},
	},
}

Gwi = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "AceConsole-2.0", "AceEvent-2.0") -- make Gwi an ace-addon. mix in some libs
Gwi:RegisterDB("GuildWhisperInviteDB", "GuildWhisperInviteDBPerChar") -- set up the savedVars DB
Gwi:RegisterChatCommand("/gwi", "/GuildWhisperInvite", options) -- register for the /gwi and /GuildWhisperInvite commands

Gwi:RegisterDefaults("profile", {
	keyPhrase = 'invite me' -- make 'invite me' the default keyphrase
})

function Gwi:OnEnable()
	self:RegisterEvent("CHAT_MSG_WHISPER") -- register for received whisper event
end

function Gwi:CHAT_MSG_WHISPER(msg, author, language, status)
	if self.db.profile.keyPhrase == msg then -- if we were whispered the keyphrase
		if CanGuildInvite() then -- and we can invite people to the guild
			GuildInvite(author) -- invite them
			self:Print(author.." has been invited to the guild.") -- tell the addon-user that we have invited someone to the guild
		else -- if we can't invite someone,
			self:Print("You do not have permission to invite someone to the guild") -- tell the addon-user
			SendChatMessage("Sorry, I don't have permission to invite you to the guild", "WHISPER", nil, author)
		end	
	end
end

-- Accessors for keyPhrase
function Gwi:GetPhrase()
	return self.db.profile.keyPhrase
end
function Gwi:SetPhrase(newPhrase)
	self.db.profile.keyPhrase = newPhrase
end