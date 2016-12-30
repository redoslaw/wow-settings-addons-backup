local L = LibStub("AceLocale-3.0"):NewLocale("GuildNoteSetter", "enUS", true)

L["!note"] = true
L["Note updated."] = true
L["Version %s"] = true
L["Polling guild mates, please wait..."] = true
L["Found %d guild mates with the addon installed:"] = true
L["Failed updating the note for %s"] = true
L["Note for X updated."] = function(X)
  return "Note for " .. X .. " updated.";
end
L["Blacklist"] = true
L["Add"] = true
L["Apply"] = true
L["Revert"] = true
L["Updated"] = true
L["Reason:"] = true
L["Added by:"] = true
L["Add a player to the black list.|n|nShift-Click for batch adding of multiple players at once."] = true
L["Apply all blacklist changes and send update to the other officers."] = true
L["Revert all blacklist changes."] = true
L["Edit"] = true
L["Remove"] = true
L["The blacklist was reverted."] = true
L["Blacklist changes approved: "] = true
L["players added."] = true
L["players removed."] = true
L["players edited."] = true
L["The blacklist hasn't changed."] = true
L["Blacklist update received from %s"] = true
L["ATTENTION: Black-listed character found in the guild"] = true
L["Black-listed character %s is found in the guild. Kick it?"] = true

L["Save"] = true
L["Cancel"] = true
L["Save changes and close this window"] = true
L["Close this window without saving"] = true
L["Name:"] = true
L["Enter the character name"] = true
L["Reason:"] = true
L["Details why the character was black-listed."] = true
L["You must specify a reason for black-listing"] = true
L["The character name is not specified"] = true
L["The character is already on the black list"] = true

L["Are you sure you want to remove the character %s from the blacklist?"] = true
L["Yes"] = true
L["No"] = true
