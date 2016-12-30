local key = 'dodaj do gildii'
local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:SetScript("OnEvent", function(self, event, msg, author)
    if msg == key and CanGuildInvite() then
        GuildInvite(author)
    end
end)