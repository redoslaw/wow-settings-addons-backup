local resetButton = CreateFrame("Button", "ResetButton", UIParent, "OptionsButtonTemplate")
resetButton:SetMovable(true)
resetButton:EnableMouse(true)
resetButton:RegisterForDrag("LeftButton")
resetButton:SetScript("OnDragStart",resetButton.StartMoving)
resetButton:SetScript("OnDragStop", resetButton.StopMovingOrSizing)
resetButton:SetPoint("CENTER")
resetButton:SetText("Reset")



function OnClick_Reset()
	local inInstance, instanceType = IsInInstance()
	if inInstance == false then
		ResetInstances()
	else
		SendChatMessage("You're In Instance. Get out of Here","SAY")
	end
end

resetButton:SetScript("OnClick",OnClick_Reset)
--------------------------------------------------------
local now =0
local onEvent
function onEvent(self, event, ...)
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...
	local inInstance, instanceType = IsInInstance()
	if (inInstance and event == "PLAYER_ENTERING_WORLD") then
		now = GetTime()
	end
	if (inInstance == false and event == "PLAYER_ENTERING_WORLD") then
		if now ~= 0 then
			wallClock = GetTime() - now
			min = wallClock/60
			sec = wallClock%60
			local timeStamp
			if(min>1) then
				timeStamp = string.format("%d",min ).."m "..string.format("%d",sec ).."s"
			else
				timeStamp = string.format("%d",sec ).."s"
			end
			SendChatMessage(timeStamp,"SAY")
			now = 0
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", onEvent)