---------------------------------------------------------------------------------
----------------------------- Configuration: ------------------------------------

local use24hformat = true -- Set this to false if you want to use a 12-hour format, or true to use a 24-hour format.


---------------------------------------------------------------------------------
----- DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING --------
---------------------------------------------------------------------------------


local hideTime = CreateFrame("frame")
hideTime:RegisterEvent("PLAYER_LOGIN")
hideTime:SetScript("OnEvent", function(self, event)
       TimeManagerClockButton:Hide();
       TimeManagerClockButton.Show = TimeManagerClockButton.Hide
end)


local clock = CreateFrame("Frame", nil, UIParent)

clock:RegisterEvent("ZONE_CHANGED")
clock:RegisterEvent("ZONE_CHANGED_INDOORS")
clock:RegisterEvent("ZONE_CHANGED_NEW_AREA")

MinimapZoneText:SetTextColor(1.0, 0.7, 0.0)

local elapsed = 0
clock:SetScript("OnUpdate", function(self, e)
   elapsed = elapsed + e
   if elapsed >= 1 then
       MinimapClockRefresh()
       elapsed = 0
   end
end)

clock:SetScript("OnEvent", function()
       MinimapZoneText:SetTextColor(1.0, 0.7, 0.0);
       MinimapClockRefresh()
end)

function MinimapClockRefresh()
	if use24hformat then
		MinimapZoneText:SetText(date("%H:%M:%S"))
	else
		MinimapZoneText:SetText(date("%I:%M:%S %p"))
	end
end

MinimapZoneTextButton:SetScript("OnEnter", function(self, motion)
       local pvpType, isSubZonePvP, factionName = GetZonePVPInfo();
       GameTooltip:SetOwner(MinimapZoneTextButton, "ANCHOR_LEFT");

       local zoneName = GetZoneText();
       local subzoneName = GetSubZoneText();

       if ( subzoneName == zoneName ) then
               subzoneName = "";
       end

       GameTooltip:AddLine( zoneName, 1.0, 1.0, 1.0 );

       if ( pvpType == "sanctuary" ) then
               GameTooltip:AddLine( subzoneName, 0.41, 0.8, 0.94 );
               GameTooltip:AddLine(SANCTUARY_TERRITORY, 0.41, 0.8, 0.94);
       elseif ( pvpType == "arena" ) then
               GameTooltip:AddLine( subzoneName, 1.0, 0.1, 0.1 );
               GameTooltip:AddLine(FREE_FOR_ALL_TERRITORY, 1.0, 0.1, 0.1);
       elseif ( pvpType == "friendly" ) then
               GameTooltip:AddLine( subzoneName, 0.1, 1.0, 0.1 );
               GameTooltip:AddLine(format(FACTION_CONTROLLED_TERRITORY, factionName), 0.1, 1.0, 0.1);
       elseif ( pvpType == "hostile" ) then
               GameTooltip:AddLine( subzoneName, 1.0, 0.1, 0.1 );
               GameTooltip:AddLine(format(FACTION_CONTROLLED_TERRITORY, factionName), 1.0, 0.1, 0.1);
       elseif ( pvpType == "contested" ) then
               GameTooltip:AddLine( subzoneName, 1.0, 0.7, 0.0 );
               GameTooltip:AddLine(CONTESTED_TERRITORY, 1.0, 0.7, 0.0);
       elseif ( pvpType == "combat" ) then
               GameTooltip:AddLine( subzoneName, 1.0, 0.1, 0.1 );
               GameTooltip:AddLine(COMBAT_ZONE, 1.0, 0.1, 0.1);
       else
               GameTooltip:AddLine( subzoneName, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b );
       end

       GameTooltip:AddLine(date("%A, %B %d, %Y"))
       GameTooltip:Show();
end)

MinimapZoneTextButton:SetScript("OnLeave", function(self, motion)
   GameTooltip:Hide()
end)
