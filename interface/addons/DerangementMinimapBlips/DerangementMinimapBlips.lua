
local function eventHandler(self,event,...)
	Minimap:SetBlipTexture("Interface\\AddOns\\DerangementMinimapBlips\\ObjectIconsAtlas");
end

local frame=CreateFrame("Frame","derangementMinimapBlipsFrame");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:SetScript("OnEvent",eventHandler);
 