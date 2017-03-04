local categoryStates = {"Questing", "Dungeons", "Raids"}

LGFminimapIconButton = CreateFrame("Button", "LazyGroupFinderMinimapIcon", Minimap)
LGFminimapIconButton:SetPoint("RIGHT")
LGFminimapIconButton:SetSize(33, 33)
LGFminimapIconButton:SetMovable(true)
LGFminimapIconButton:EnableMouse(true)
LGFminimapIconButton:SetFrameStrata("HIGH")
LGFminimapIconButton:SetFrameLevel(8)
LGFminimapIconButton:SetClampedToScreen(true)
LGFminimapIconButton:SetDontSavePosition()
LGFminimapIconButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LGFminimapIconButton:RegisterForDrag("LeftButton", "RightButton")
LGFminimapIconButton:EnableDrawLayer("BACKGROUND")
LGFminimapIconButton:EnableDrawLayer("OVERLAY")
LGFminimapIconButton:Hide()

local normalTexture = LGFminimapIconButton:CreateTexture("PGF_minimapButton_BackgroundTexture", "BACKGROUND")
normalTexture:SetDrawLayer("BACKGROUND", 0)
normalTexture:SetTexture("Interface\\addons\\PGFinder\\disabled.tga")
normalTexture:SetSize(21,21)
normalTexture:SetPoint("TOPLEFT", 6, -5)

local highlightTexture = LGFminimapIconButton:CreateTexture("PGF_minimapButton_OverlayTexture", "OVERLAY")
highlightTexture:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
highlightTexture:SetSize(56,56)
highlightTexture:SetPoint("TOPLEFT")

LGFminimapIconButton:SetScript("OnClick", function(self)
	if self.dragging then
		self:SetScript("OnUpdate", nil)
	end
	local button = GetMouseButtonClicked()
	if button == "RightButton" then
		PlaySound("igMainMenuOptionCheckBoxOn")
		InterfaceOptionsFrame_OpenToCategory(LazyGroupFinderOptions)
		if not LazyGroupFinderOptions:IsVisible() then
			InterfaceOptionsFrame_OpenToCategory(LazyGroupFinderOptions)
		end
	elseif button == "LeftButton" then
		if LazyGroupFinderEnabled then
			LazyGroupFinderDisableAddon()
		else
			LazyGroupFinderEnableAddon()
		end
	end
end)
LGFminimapIconButton:SetScript("OnDragStart", function(self)
	self:LockHighlight()
	self.dragging = true
	self:SetScript("OnUpdate", function(self)
		if not IsMouseButtonDown() then
			self:SetScript("OnUpdate", nil)
			self.dragging = false
		end
		local xpos,ypos = GetCursorPosition()
		local xmin,xmax,ymin,ymax = Minimap:GetLeft(), Minimap:GetRight(), Minimap:GetBottom(), Minimap:GetTop()
		local xLen = xmax-xmin
		local yLen = ymax-ymin

		xpos = xmin-xpos/UIParent:GetScale()+(xLen/2) -- get coordinates as differences from the center of the minimap
		ypos = ypos/UIParent:GetScale()-ymin-(yLen/2)

		PGF_minimapDegree = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
		LazyGroupFinder_MinimapButton_SetPoint(PGF_minimapDegree)
	end)
end)
LGFminimapIconButton:SetScript("OnDragStop", function(self)
	self:LockHighlight()
	self.dragging = false
	self:SetScript("OnUpdate", nil)
end)
LGFminimapIconButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	if LazyGroupFinderEnabled then
		GameTooltip:SetText("|cFF00FF00Lazy Group Finder")
	else
		GameTooltip:SetText("|cFFFF0000Lazy Group Finder")
	end
	local nrofactivities = 0
	local results = C_LFGList.GetAvailableActivities(LazyGroupFinderActivityType, nil, 1)
	for k,v in pairs(results) do
		if LazyGroupFinderActivities[v] == nil then LazyGroupFinderActivities[v] = false end
		if LazyGroupFinderActivities[v] then nrofactivities = 1 + nrofactivities end
	end
	GameTooltip:AddLine("|cFFFFFFFF" .. categoryStates[LazyGroupFinderActivityType] .. " (" .. nrofactivities .. ")")
	if LazyGroupFinderEnabled then
		GameTooltip:AddLine("Leftclick: Disable")
	else
		GameTooltip:AddLine("Leftclick: Enable")
	end
	GameTooltip:AddLine("Rightclick: Options")
	GameTooltip:Show()
end)
LGFminimapIconButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

Minimap:HookScript("OnEnter", function(self)
	if LazyGroupFinderMinimapIconHover then
		LGFminimapIconButton:Show()
	end
end)
Minimap:HookScript("OnLeave", function(self)
	if LazyGroupFinderMinimapIconHover then 
		if not MouseIsOver(LGFminimapIconButton) then
			LGFminimapIconButton:Hide()
		end
	end
end)
LGFminimapIconButton:HookScript("OnLeave", function(self)
	if LazyGroupFinderMinimapIconHover then
		if not MouseIsOver(Minimap) then
			LGFminimapIconButton:Hide()
		end
	end
end)

function LazyGroupFinder_MinimapButton_SetEnabled(self)
	normalTexture:SetTexture("Interface\\addons\\LazyGroupFinder\\enabled.tga")
end
function LazyGroupFinder_MinimapButton_SetDisabled(self)
	normalTexture:SetTexture("Interface\\addons\\LazyGroupFinder\\disabled.tga")
end

function LazyGroupFinder_MinimapButton_SetPoint(degree)
	LazyGroupFinderMinimapIconPoint = degree
	LazyGroupFinderMinimapIcon:ClearAllPoints()
	LazyGroupFinderMinimapIcon:SetPoint("TOPLEFT", "Minimap","TOPLEFT",52-(80*cos(degree)),(80*sin(degree))-52)
end