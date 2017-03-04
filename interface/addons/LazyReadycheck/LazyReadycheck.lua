if LazyReadyCheck == nil then LazyReadyCheck = { ["enabled"] = false, } end
local strings = {
	["on"] = [[Turned |cff33CC33on|r! Will accept ready checks.]],
	["off"] = [[Turned |cffFF0000off|r! Will ignore ready checks.]],
	["options_on"] = [[Type /LRC for options. Currently turned |cff33CC33on|r!]],
	["options_off"] = [[Type /LRC for options. Currently turned |cffFF0000off|r!]],
	["lrc"] = [[|cffFFA500LazyReadyCheck:|r]],
	["onOff"] = [[/LRC on/off - autoaccept or ignore ready checks]],
}

SLASH_LAZYREADYCHECK1 = "/lrc"
SLASH_LAZYREADYCHECK2 = "/lazyreadycheck"
SlashCmdList["LAZYREADYCHECK"] = function(msg, editbox)
	local _msg = string.lower(msg)
	if _msg == "on" or _msg == "enable" then
		print(strings["lrc"],strings["on"])
		ReadyCheckFrameYesButton.elapsed = math.random(10,50)/10
		LazyReadyCheck.enabled = true
	elseif _msg == "off" or _msg == "disable" then
		print(strings["lrc"],strings["off"])
		ReadyCheckFrameYesButton:SetText(READY)
		LazyReadyCheck.enabled = false
	else
		print(strings["lrc"],strings["onOff"])
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self,event,...)
	if LazyReadyCheck.enabled then
		print(strings["lrc"],strings["options_on"])
	else
		print(strings["lrc"],strings["options_off"])
	end
end)

ReadyCheckFrameYesButton:HookScript("OnUpdate",function(self,elapsed)
	if LazyReadyCheck.enabled then
		self.elapsed = self.elapsed - elapsed
		self:SetFormattedText('%s |cffffffff(%.1f)|r', READY, self.elapsed)
		if(self.elapsed <= 0) then
			self:SetText(READY)
			self:Click()
		end
	end
end)

ReadyCheckFrameYesButton:HookScript("OnShow", function(self)
	self.elapsed = math.random(10,50)/10
end)
