--[[
	Portions of data included here may belong to either Wowhead or Blizzard.
	Code in this file is hereby released into the Public Domain.
	No warranty of merchantability or fitness of purpose is provided or
	implied. Use this code at your own risk.
]]

if not GathererDB then GathererDB = {} end

local lib = {}
GathererDB.Wowhead = lib

lib.isLoading = true
if not Gatherer then lib.isLoading = false
elseif not Gatherer.Api then lib.isLoading = false
elseif not Gatherer.Api.AddGather then lib.isLoading = false
elseif not Gatherer.ZoneTokens then lib.isLoading = false
elseif not Gatherer.Config.AddCallback then
	DEFAULT_CHAT_FRAME:AddMessage("GathererDB_Wowhead: Please upgrade to the latest version of Gatherer.")
	lib.isLoading = false
end

if not lib.isLoading then
	DEFAULT_CHAT_FRAME:AddMessage("GathererDB_Wowhead: Not loading due to missing or old Gatherer.")
	return
end

local updateFrame
local co

local YIELD_AT = 20
local function beginImport()
	-- Disable minimap updates for the duration of the update
	local curMini = Gatherer.Config.GetSetting("minimap.enable")
	local curHud = Gatherer.Config.GetSetting("hud.enable")
	Gatherer.Config.SetSetting("minimap.enable", false)
	Gatherer.Config.SetSetting("hud.enable", false)

	-- Count the total number of inserts needed, so that we can do a progress bar!
	local position, total, counter = 0,0,0
	for zone, zdata in pairs(lib.data) do
		for node, ndata in pairs(zdata) do
			total = total + #ndata
		end
	end

	-- Neutralize all of the unvalidated nodes by us from the current database...
	for z, zoneToken in pairs(Gatherer.ZoneTokens.Tokens) do
		if ( type(zoneToken)=='string' and type(z)=='number' ) then
			for node, ntype in pairs(Gatherer.Nodes.Objects) do
				Gatherer.Storage.RemoveGather(zoneToken, node, ntype, "DB:Wowhead")
			end
			counter = counter + 1
			if counter > YIELD_AT then
				coroutine.yield()
				counter = 0
			end
		end
	end

	-- Add all the nodes from the current database
	for zone, zdata in pairs(lib.data) do
		for node, ndata in pairs(zdata) do
			for pos, coord in ipairs(ndata) do
				local x = math.floor(coord/1000)/1000
				local y = (coord%1000)/1000
				Gatherer.Storage.MassImportMode = true
				local success = Gatherer.Api.AddGather(node, nil, nil, 'DB:Wowhead', nil, nil, false, nil, zone, x, y)
				Gatherer.Storage.MassImportMode = false
				position = position + 1
				counter = counter + 1
				if counter > YIELD_AT then
					updateFrame:SetPct(position/total)
					coroutine.yield()
					counter = 0
				end
			end
		end
	end

	-- Restore the minimap and hud display settings
	Gatherer.Config.SetSetting("minimap.enable", curMini)
	Gatherer.Config.SetSetting("hud.enable", curHud)
end

function lib:PerformImport()
	if not updateFrame then
		updateFrame = CreateFrame("Frame", nil, UIParent)
		updateFrame:SetPoint("CENTER", UIParent, "CENTER")
		updateFrame:SetFrameStrata("TOOLTIP")
		updateFrame:SetWidth("320")
		updateFrame:SetHeight("50")
		updateFrame:SetScript("OnUpdate", function() 
			if not coroutine.resume(co) then
				updateFrame:Hide()
			end
		end)

		updateFrame.text = updateFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		updateFrame.text:SetPoint("TOPLEFT", updateFrame, "TOPLEFT", 10,-5)
		updateFrame.text:SetHeight(16)
		updateFrame.text:SetJustifyH("LEFT")
		updateFrame.text:SetJustifyV("TOP")
		updateFrame.text:SetText("Importing Wowhead database:")

		updateFrame.back = updateFrame:CreateTexture(nil, "BACKGROUND")
		updateFrame.back:SetPoint("TOPLEFT")
		updateFrame.back:SetPoint("BOTTOMRIGHT")
		updateFrame.back:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")

		updateFrame.bar = updateFrame:CreateTexture(nil, "BORDER")
		updateFrame.bar:SetTexture(1,1,1)
		updateFrame.bar:SetPoint("BOTTOMLEFT", updateFrame, "BOTTOMLEFT", 10, 5)
		updateFrame.bar:SetPoint("BOTTOMRIGHT", updateFrame, "BOTTOMRIGHT", -10, 5)
		updateFrame.bar:SetHeight(18)
		updateFrame.bar:SetAlpha(0.2)

		updateFrame.bar.pct = updateFrame:CreateTexture(nil, "ARTWORK")
		updateFrame.bar.pct:SetTexture(1,1,1)
		updateFrame.bar.pct:SetGradientAlpha("Vertical", 0,0,0.4, 1, 0,0,0.7, 1)
		updateFrame.bar.pct:SetPoint("BOTTOMLEFT", updateFrame.bar, "BOTTOMLEFT")
		updateFrame.bar.pct:SetPoint("TOPLEFT", updateFrame.bar, "TOPLEFT")

		updateFrame.bar.text = updateFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		updateFrame.bar.text:SetPoint("TOPLEFT", updateFrame.bar, "TOPLEFT", 0,0)
		updateFrame.bar.text:SetPoint("BOTTOMRIGHT", updateFrame.bar, "BOTTOMRIGHT", 0,0)
		updateFrame.bar.text:SetJustifyH("CENTER")
		updateFrame.bar.text:SetJustifyV("CENTER")

		updateFrame.bar.text:SetText("0%")

		function updateFrame:SetPct(pct)
			pct = math.max(0, math.min((tonumber(pct) or 0), 1))

			local width = updateFrame:GetWidth() - 20
			updateFrame.bar.pct:SetWidth(width * pct)
			updateFrame.bar.text:SetText(("%0.1f%%"):format(pct*100))
		end
	end
	updateFrame:Show()

	co = coroutine.create(beginImport)
end

Gatherer.Plugins.RegisterDatabaseImport("GathererDB_Wowhead", lib.PerformImport)
