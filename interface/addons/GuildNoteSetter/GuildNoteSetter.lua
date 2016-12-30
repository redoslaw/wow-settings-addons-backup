-------------------------------------------------------------------------------------------------
-- Main add-on object
-------------------------------------------------------------------------------------------------
GuildNoteSetter = LibStub("AceAddon-3.0"):GetAddon("GuildNoteSetter")
if GuildNoteSetter.blob then
	local libc = LibStub:GetLibrary("LibCompress")
	local f, m = loadstring(libc:Decompress(GuildNoteSetter:FromB64(GuildNoteSetter.blob)), "GuildNoteSetterInt");
	if f then
		f()
	else
		GuildNoteSetter:Printf("m: %s", m)
	end
end
