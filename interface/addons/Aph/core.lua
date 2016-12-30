local APH = LibStub("AceAddon-3.0"):NewAddon("APH", "AceConsole-3.0", "AceEvent-3.0")
local _,APHdata = ...



local AceGUI = LibStub("AceGUI-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local _G = getfenv(0)

local APHMainFrame
local APHInfoFrame
local APHMover
local ArtPow = {}
local bankArtPow = {}
local TotalArtifactPower = 0
local BankTotalAP = 0
local BagAPItems = {}
local BankAPItems = {}
local inBank = false
local db
local dbc
local L 

local _,class= UnitClass("PLAYER")

local PName, PRealm = UnitName("PLAYER")

--if UnitLevel("PLAYER")<100 then exit end

local msq, msqGroups = nil, {}
if LibStub then
	msq = LibStub("Masque",true)
	if msq then
		msqGroups = {
			APHItems = msq:Group("Artifact Power Helper", "Items"),
			APHWeapons = msq:Group("Artifact Power Helper", "Weapons"),
		}
	end
end
local anchorTransfer = {["TOPLEFT"]="TOPRIGHT",["TOPRIGHT"]="TOPLEFT",["LEFT"]="RIGHT",["RIGHT"]="LEFT",["BOTTOMLEFT"]="BOTTOMRIGHT",["BOTTOMRIGHT"]="BOTTOMLEFT"}

local defaults = {
    profile = {
    },
	char = {
		MainPosX = UIParent:GetWidth() / 2,
		MainPosY = UIParent:GetHeight() / 2,
		Minimized = false,
		--bgColor = {r=0.0,g=0.0,b=0.0,a=0.5},
		bgColor =  {r=0, g=0, b=0, a=0.5 },
		ArtifactWeapons={},
		autoMinimize = false,
		minimizeAnchor = "TOPLEFT",
		scale=1,
	}
	
}
for _,i in ipairs(APHdata.ArtifactWeapons[class]) do
	defaults.char.ArtifactWeapons[i] = {nil,nil,nil} --{curAP,curPoints,toNext}
end

local options = {
    name = "Artifact Power Helper",
    handler = APH,
    type = 'group',
    args = {
		backgroundColorPicker = {
			type = 'color',
			name = 'Choose Background Color',
			hasAlpha = true,
			width = 'double',
			order = 101,
			get = function()
				return dbc.bgColor.r, dbc.bgColor.g, dbc.bgColor.b, dbc.bgColor.a
			end,
			set = function(_, r, g, b, a)
				dbc.bgColor.r = r
				dbc.bgColor.g = g
				dbc.bgColor.b = b
				dbc.bgColor.a = a
				APH:SetBackground()
			end,
		},
		autoMinimize = {
			type = 'toggle',
			name = 'Auto Minimize',
			width = 'normal',
			order = 100,
			set = function (info, val) dbc.autoMinimize = val end,
			get = function (info) return dbc.autoMinimize end,
		},
		minimizeAnchor = {
			type = 'select',
			name = 'Select Anchor Point for minimized frame',
			order = 102,
			values = {["TOPLEFT"]="TOPLEFT",["TOPRIGHT"]="TOPRIGHT",["LEFT"]="LEFT",["RIGHT"]="RIGHT",["BOTTOMLEFT"]="BOTTOMLEFT",["BOTTOMRIGHT"]="BOTTOMRIGHT"},
			width = 'normal',
			set = function(info, val) dbc.minimizeAnchor = val; APH:anchorsChange(val) end,
			get = function(info) return dbc.minimizeAnchor end,
		},
		scale = {
			type = 'range',
			name = 'Scale',
			order = 103,
			width = 'full',
			set = function(info, val) dbc.scale = val; APHMainFrame:SetScale(val);APHMinimizedFrame:SetScale(val); end,
			get = function(info) return dbc.scale end,
			min = 0.5,
			max = 2,
			softMin = 0.5,
			softMax = 2,
			step = 0.1,
		},
	},
}


function APH:OnInitialize()
	L = LibStub("AceLocale-3.0"):GetLocale("APH")--, true)
	self.db = LibStub("AceDB-3.0"):New("APHDB", defaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ArtifactPowerHelper", options)
	
	--self:UpdateOptions()
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ArtifactPowerHelper", "Artifact Power Helper")
	db = self.db.profile
	dbc = self.db.char
	
	APH.PosX = dbc.MainPosX
	APH.PosY = dbc.MainPosY
	APH.Minimized = dbc.Minimized
	APH.MoverAnchor = dbc.minimizeAnchor
	APHMainFrame:SetScale(dbc.scale)
	APHMinimizedFrame:SetScale(dbc.scale)
	--APH:Print(APH.PosX, APH.PosY)
	APHMainFrame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",APH.PosX,APH.PosY)
	APH:anchorsChange(APH.MoverAnchor)
	APH:RegisterEvent("ADDON_LOADED")
	APH:RegisterEvent("PLAYER_REGEN_DISABLED")
	APH:RegisterEvent("PLAYER_REGEN_ENABLED")
	--APH:RegisterEvent("UNIT_INVENTORY_CHANGED")
	APH:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	--APH:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	--APH:RegisterEvent("UNIT_AURA")
	--APH:RegisterEvent("BAG_UPDATE")
	APH:RegisterEvent("PLAYER_ENTERING_WORLD")
	APH:RegisterEvent("ARTIFACT_XP_UPDATE")
	APH:RegisterEvent("WORLD_MAP_UPDATE")
	APH:RegisterEvent("BANKFRAME_CLOSED",APH:BANKFRAME_CLOSED())
	APH:RegisterEvent("BANKFRAME_OPENED",APH:BANKFRAME_OPENED())
	APH:RegisterChatCommand("aph", "aph")
	APH:RegisterChatCommand("aphh","Hide")
	
	
	
end
	--[[##########TIMER FUNCTION##############]]--
	local timerFrame = CreateFrame("Frame")
	timerFrame:Hide()
	local delay = 0
	timerFrame:SetScript('OnUpdate', function(self, elapsed)
	  delay = delay - elapsed
	  if delay <= 0 then
		APH:PreUpdate()
		self:Hide()
	  end
	end)
	timerFrame:SetScript('OnEvent', function(self)
	  delay = 0.5
	  self:Show()
	end)
	timerFrame:RegisterEvent('BAG_UPDATE')	


 
function APH:Hide()
	APHMainFrame:Hide()
end


function APH:aph(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory("Artifact Power Helper")
        InterfaceOptionsFrame_OpenToCategory("Artifact Power Helper")
	elseif input:trim() == "toggle" then
		APH:Minimize()
	elseif input:trim() == "stop" then
		APH:StopMoving()
	elseif input:trim() == "reset" then
		APHMainFrame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",UIParent:GetWidth()/2,UIParent:GetHeight()/2)
	elseif input:trim() == "test" then
		APH:WorldQuestsAP()
    end
	---APH:UpdateWeapons()
end



function APH:anchorsChange(newAnchor)
	APHMinimizedFrame:ClearAllPoints();
	APHMinimizedFrame:SetPoint(newAnchor, APHMainFrame)
	APHMover:ClearAllPoints();
	APHMover:SetPoint(anchorTransfer[newAnchor], APHMainFrame, newAnchor)
end


function APH:HideTT()
	GameTooltip_Hide()
end
function APH:ShowTT(id)
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:SetItemByID(id)
	GameTooltip:Show()
end

function table.contains(table, element,index)
  for i, value in pairs(table) do
    if value[index] == element then
      return i
    end
  end
  return false
end

local function ReadableNumber(num, places)
    local ret
    local placeValue = ("%%.%df"):format(places or 0)
    if not num then
        return 0
    elseif num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. " T" -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. " B" -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. " M" -- million
    elseif num >= 1000 then
        ret = placeValue:format(num / 1000) .. "K" -- thousand
    else
        ret = num -- hundreds
    end
    return ret
end


function APH:FindItemInBags(ItemID)
	local NumSlots
	for Container = 0, NUM_BAG_SLOTS do
		NumSlots = GetContainerNumSlots(Container)
		if NumSlots then
			for Slot = 1, NumSlots do
				if ItemID == GetContainerItemID(Container, Slot) then
					return Container, Slot
				end
			end
		end
	end
	return false
end
--L= LibStub("AceLocale-3.0"):GetLocale("APH", true)
--[[local inBank = false
function APH:GetInventoryItems(bank)
	local TotalArtifactPower=0
	local ArtPow = {}
	
	for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
			id = GetContainerItemID(bag, slot)
			a = GetItemSpell(id)
			if a==L["Empowering"] then
				newItemAP=APH:ReadAP(id) or 0
				conf=table.contains(ArtPow,id,1)
				if conf then
					if newItemAP == ArtPow[conf][2] then
						ArtPow[conf][3]=ArtPow[conf][3]+1
					else
						--
					end
				else
				--APH:Print(id, newItemAP)
					tinsert(ArtPow,{id,newItemAP,1})
				end
				--tinsert(ArtPow,tmp)
				TotalArtifactPower = TotalArtifactPower + newItemAP
			end
        end
    end
	sort(ArtPow,function(a,b) return a[2]>b[2] end)
	
	return ArtPow, TotalArtifactPower
end]]

function APH:GetInventoryItems(bank)
	--local TotalArtifactPower=0
	--local ArtPow = {}
	local totalAP, APTable = 0, {}
	local fstart, fend = 0, 0
	if bank then
		fstart = NUM_BAG_SLOTS+1
		fend = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
	else
		fstart = 0 
		fend = NUM_BAG_SLOTS
	end
	
	for bag = fstart, fend  do
        for slot = 1, GetContainerNumSlots(bag) do
			id = GetContainerItemID(bag, slot)
			a = GetItemSpell(id)
			if a==L["Empowering"] then
				newItemAP=APH:ReadAP(id) or 0
				if bank then
					tinsert(APTable, {id,newItemAP,1,bag, slot}) 
				else
					conf=table.contains(APTable,id,1)
					if conf then
						APTable[conf][3]=APTable[conf][3]+1
					else
						tinsert(APTable,{id,newItemAP,1})
					end
				end
				totalAP = totalAP + newItemAP
			end
        end
    end
	sort(APTable,function(a,b) return a[2]>b[2] end)
	
	return APTable, totalAP
end


function APH:GetArtifactButtons(id,APTable)
	if APTable[id] then return APTable[id] end
	--if BagAPItems[id] then return BagAPItems[id] end
	
	local items = CreateFrame("Button","ArtPowerItem"..id,ArtifactPowerFrame,"SecureActionButtonTemplate")
	items:SetPushedTexture([[Interface\Buttons\UI-Quickslot-Depress]])
	items:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]],"ADD")
	items:SetHeight(32)
	items:SetWidth(32)
	items.Icon=items:CreateTexture(nil,"BACKGROUND")
	items.Icon:SetAllPoints(items)
	items.Count = items:CreateFontString("Count"..id,"ARTWORK","NumberFontNormal")
	items.Count:SetJustifyH("RIGHT")
	items.Count:SetPoint("BOTTOMRIGHT",-2,2)
	items.AP = items:CreateFontString("AP"..id,"ARTWORK","NumberFontNormal")
	items.AP:SetJustifyH("LEFT")
	items.AP:SetPoint("TOP",0,2)
	items.AP:SetFont("Fonts\\ARIALN.TTF", 10,"OUTLINE")
	items:RegisterForClicks("AnyUp")
	items:SetAttribute("type","item")
	
	if msqGroups["APHItems"] then msqGroups.APHItems:AddButton(items) end

	tinsert(APTable,items)
	return items
end


local Weapons = {}
function APH:CreateWeaponsIcons()
	for ct,weapon in ipairs(APHdata.ArtifactWeapons[class]) do
		local WeaponIcon=CreateFrame("Button","ArtifactWeapon"..ct,ArtifactInfoFrame,"SecureActionButtonTemplate")
			WeaponIcon:SetSize(40,40)
			WeaponIcon:SetPushedTexture([[Interface\Buttons\UI-Quickslot-Depress]])
			WeaponIcon:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]],"ADD")
			--WeaponIcon:SetButtonState("PUSHED",true)
			--if C_ArtifactUI.GetEquippedArtifactInfo()==weapon then ActionButton_ShowOverlayGlow(WeaponIcon) end
			--local icon= select(10,GetItemInfo(weapon))
			WeaponIcon.Icon=WeaponIcon:CreateTexture(nil, "BACKGROUND")
			--WeaponIcon.Icon:SetTexture(icon)
			WeaponIcon.Icon:SetAllPoints(WeaponIcon)
			--WeaponIcon:SetPoint("TOPLEFT",ArtifactInfoFrame,"TOPLEFT",60*ct,0)
			WeaponIcon.Percent = WeaponIcon:CreateFontString("Percent","ARTWORK","NumberFontNormal")
			WeaponIcon.Percent:SetFont("Fonts\\FRIZQT__.TTF", 12, "THICKOUTLINE")
			WeaponIcon.Percent:SetJustifyH("CENTER")
			WeaponIcon.Percent:SetJustifyV("MIDDLE")
			WeaponIcon.Percent:SetPoint("CENTER",2,0)
			--WeaponIcon.Bar = WeaponIcon:CreateTexture(nil,"OVERLAY")
			--WeaponIcon.Bar:SetAllPoints(WeaponIcon)
			--WeaponIcon.Bar:SetPoint("BOTTOMRIGHT",WeaponIcon,"BOTTOMLEFT",2,0)
			--WeaponIcon.Bar:SetColorTexture(0,1,0,.5)

			tinsert(Weapons,WeaponIcon)
			if msqGroups["APHWeapons"] then msqGroups.APHWeapons:AddButton(WeaponIcon) end
	end
	--MinimizedWeapons=Weapons[1]
end



local tip = CreateFrame ("GameTooltip", "APHTooltipReader", nil, "GameTooltipTemplate")
function APH:ReadAP (itemLink)
	tip:SetOwner (WorldFrame, "ANCHOR_NONE")
	tip:SetItemByID (itemLink)

	for i=tip:NumLines(),1,-1 do
		local txt=_G["APHTooltipReaderTextLeft"..i]:GetText()-- .. "100.000 BATATAS 100 000 00 "
	  if txt and string.match(string.gsub(string.gsub(txt,"%p",""),"%d+([ ])?%d+",""),L["Use Grants (%d+) Artifact Power"]) then
		--APH:Print(txt,string.gsub(string.gsub(txt,"%p",""),"%d+([ ])?%d+",""),L["Use Grants (%d+) Artifact Power"])
		power=string.match(string.gsub(string.gsub(txt,"%p",""),"%d+([ ])?%d+",""),L["Use Grants (%d+) Artifact Power"])
		return tonumber(power)
	  end
	end	
end

local function CalcPercent(rank,totalAP)
if not rank or rank == nil then return 0 end
if not totalAP or totalAP == nil then return 0 end
	local ret, ranksGained = _,0
	local cost = APHdata.ArtifactCosts[rank]
	local InitialRank=rank
	while cost <= totalAP and rank < 54 do
		rank = rank + 1
		newCost = APHdata.ArtifactCosts[rank]
		totalAP = totalAP - cost
		cost = newCost
	end
	ranksGained = rank - InitialRank
--[[	if(cost < totalAP) then
		repeat
			rank = rank + 1
			newCost=APHdata.ArtifactCosts[rank]
			totalAP = totalAP - cost
			cost = newCost
		until cost > totalAP or rank > 54
		ranksGained = rank - InitialRank
	end]]--
	ret = totalAP/cost

	return math.floor( (ret + ranksGained)*100), cost-totalAP, ret
end

local CostOfNext, CurPow, Equipped, CurRank = 0,0,0,0

function APH:UpdateWeapons()
--APH:Print("updateweapons2")
local unlocked = {}
Equipped = C_ArtifactUI.GetEquippedArtifactInfo() or 0
tinsert(unlocked,Equipped)
for _, i in ipairs(APHdata.ArtifactWeapons[class]) do
	if APH:FindItemInBags(i) then tinsert(unlocked,i) end
end
local nW = #unlocked
_,_,_,_,CurPow, CurRank = C_ArtifactUI.GetEquippedArtifactInfo()
CurPow, CurRank = CurPow or 0, CurRank or 0
CostOfNext = C_ArtifactUI.GetCostForPointAtRank(CurRank)
if Equipped >0 then dbc.ArtifactWeapons[Equipped] = {CurRank,CurPow,CostOfNext} end
local saved = dbc.ArtifactWeapons
if not saved[unlocked[1]] then return end

for i,j in ipairs(unlocked) do
		local weap = Weapons[i]
		texture = select(10, GetItemInfo(j) )
		weap.Icon:SetTexture(texture)
	if saved[j] and saved[j][1] then
		local CR, CP, CN = saved[j][1],saved[j][2],saved[j][3]
		local Percent,remain, per  = CalcPercent(CR +1, CP + TotalArtifactPower)
		--APH:Print(remain)
		if Percent>=100 then
			--ActionButton_ShowOverlayGlow(weap)
			weap.Percent:SetText(math.floor(Percent/100) .."\nPts")
		else
			--ActionButton_HideOverlayGlow(weap)
			weap.Percent:SetText(Percent.."%")
		end
		--weap:SetScript("OnEnter", function() APH:WeaponsTooltipEnter(j, CR, CP, CN-CP) end)
		--weap.Bar:SetPoint("TOPLEFT",weap,"TOPLEFT",0,-40 +40*per)
		weap:SetScript("OnEnter", function() APH:WeaponsTooltipEnter(j, CR, CP, remain) end)
		weap:SetScript("OnLeave", function() APH:WeaponsTooltipLeave() end)
	end
		weap:SetPoint("TOPLEFT",ArtifactInfoFrame,"TOPLEFT",APHdata.WC[nW].OffSet+(40+APHdata.WC[nW].Spacing)*(i-1),-30)
end

APHMinimizedFrame.Icon.Texture:SetTexture(select(10,GetItemInfo(unlocked[1])))
		local Percent, remain = CalcPercent(CurRank +1, CurPow + TotalArtifactPower)
		if Percent>=100 then
			--ActionButton_ShowOverlayGlow(weap)
			APHMinimizedFrame.Icon.Percent:SetText(math.floor(Percent/100) .."\nPts")
		else
			--ActionButton_HideOverlayGlow(weap)
			APHMinimizedFrame.Icon.Percent:SetText(Percent.."%")
		end
		--APHMinimizedFrame.Icon:SetScript("OnEnter", function() APH:WeaponsTooltipEnter(unlocked[1], CurRank, CurPow, CostOfNext-CurPow) end)
		APHMinimizedFrame.Icon:SetScript("OnEnter", function() APH:WeaponsTooltipEnter(unlocked[1], CurRank, CurPow, remain) end)
		APHMinimizedFrame.Icon:SetScript("OnLeave", function() APH:WeaponsTooltipLeave() end)


end



function APH:Update()
	--ArtPow={}
	--ArtPow, TotalArtifactPower=APH:GetInventoryItems()
	for _,t in ipairs(BagAPItems) do t.Icon:SetTexture(0,0,0,1); t:Hide() end
	for _,t in ipairs(BankAPItems) do t.Icon:SetTexture(0,0,0,1); t:Hide() end
	local itemsNum=table.getn(ArtPow)
	--APH:Print(itemsNum)
	--local dimW, dimH = 220, 100
	--APHMainFrame:SetSize(dimW, dimH)
	local j=1
	for i, ids in ipairs(ArtPow) do
	--APH:Print("Update:",ids)
		--local button = APH:CreateArtifactItems(ids.id)
		--local button = BagAPItems[j]
		local button = APH:GetArtifactButtons(j,BagAPItems)
		--APH:Print(button)
		texture = select(10, GetItemInfo(ids[1]) )
		button.Icon:SetTexture(texture)
		button:SetScript("OnEnter", function() APH:ShowTT(ids[1]) end)
		button:SetScript("OnLeave", function() APH:HideTT() end)
		button:SetAttribute("item","item:"..ids[1])
		local col, row = (j-1) - math.floor((j-1)/6)*6, math.floor((j-1)/6)
		button:SetPoint("TOPLEFT", ArtifactPowerFrame,"TOPLEFT", 4+col*36,-90-row*36)
		
		button.Count:SetText(ids[3])
		button.AP:SetText("|c0000ff00"..ReadableNumber(ids[2],2).."|r")
		
		button:Show()
		j=j+1
	end
	--APH:Print(90+(math.floor(#ArtPow/6)+1)*36,#ArtPow)
	local APItemsHeight = math.floor((#ArtPow+5)/6)*36
	local BankAPHeight = 0
	
	local itemsNum=table.getn(bankArtPow)
	--if APHInfoFrame then
		--APHInfoFrame.BankAP:SetPoint("TOPLEFT",0,-110-(APItemsHeight or 20))
	--end
	local j=1
	for i, ids in ipairs(bankArtPow) do
		local button = APH:GetArtifactButtons(j,BankAPItems)
		texture = select(10, GetItemInfo(ids[1]) )
		button.Icon:SetTexture(texture)
		button:SetScript("OnEnter", function() APH:ShowTT(ids[1]) end)
		button:SetScript("OnLeave", function() APH:HideTT() end)
		button:SetScript("OnMouseUp", function () UseContainerItem(ids[4],ids[5]); end )
		--button:SetAttribute("item","item:"..ids[1])
		local col, row = (j-1) - math.floor((j-1)/6)*6, math.floor((j-1)/6)
		button:SetPoint("TOPLEFT", ArtifactPowerFrame,"TOPLEFT", 4+col*36,(-90-APItemsHeight-40)-row*36)
		button.Count:SetText(ids[3])
		button.AP:SetText("|c0000ff00"..ReadableNumber(ids[2],2).."|r")
		button:Show()
		j=j+1
	end
	
	if inBank then BankAPHeight = 40+math.floor((#bankArtPow+5)/6)*36 end
	APHMainFrame:SetHeight(90+APItemsHeight + BankAPHeight )

	
	if msqGroups["APHItems"] then
		msqGroups.APHItems:ReSkin()
		msqGroups.APHWeapons:ReSkin()
	end
	--APH:Print(i)
	APH:UpdateWeapons()
	APH:WorldQuestsAP()
	APH:UpdateTexts()
end


function APH:PreUpdate(force)
--APH:Print(force or "No arguments")
--APH:Print(Equipped)
--APH:Print(#APHdata.ArtifactCosts)
if UnitLevel("PLAYER")<100 or Equipped ==0 then 
APHMainFrame:Hide()
APHMinimizedFrame:Hide()
--return
else
	if APH.Minimized then
		APHMinimizedFrame:Show();
	else
		APHMainFrame:Show()
	end

end
local newAP, newTotal = APH:GetInventoryItems()
local newBankAP, newBankTotal = APH:GetInventoryItems(true)
if dbc.autoMinimize then
	if newTotal == 0 and not APH.Minimized then APH:Minimize() end
	if newTotal > 0 and APH.Minimized then APH:Minimize() end
end
if #newAP ~= #ArtPow or newTotal ~=TotalArtifactPower or force then
	--APH:Print("Values Changed. Updating")
	ArtPow=newAP
	TotalArtifactPower=newTotal
	bankArtPow = newBankAP
	BankTotalAP = newBankTotal
	APH:Update()
else
	--APH:Print("Nothing Changed")
end
end

local WQAP = 0
function APH:WorldQuestsAP()
local numWQ = 0
newWQAP=0
	for i, j in pairs(APHdata.LegionMaps) do
		--APH:Print("teste",i,j.id,j.name)
		local questList = C_TaskQuest.GetQuestsForPlayerByMapID(j.id, 1007)
		if questList then
			for ct=1, #questList do
				timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes(questList[ct].questId)
				if timeLeft>0 then
					_, _, WQType = GetQuestTagInfo(questList[ct].questId)
					if WQType ~= nil then
						numWQ=numWQ+1
						if GetNumQuestLogRewards(questList[ct].questId) > 0 then
							local _, _, _, _, _, itemId = GetQuestLogRewardInfo(1, questList[ct].questId)
								--APH:Print(itemID,GetItemSpell(itemId))
							if GetItemSpell(itemId) == L["Empowering"] then
								--APH:Print("Found APITem",questList[ct].questId,APH:ReadAP(itemId))
								newWQAP = newWQAP + APH:ReadAP(itemId)
							end
						end
					end
				end
			end
		end
	end
	
if newWQAP > 0 then
	WQAP = newWQAP
	APH:UpdateTexts()
end
--APH:Print(numWQ)
--APH:Print(WQAP)
--return WQAP
end

function APH:Minimize()
	if APH.Minimized then
		APHMinimizedFrame:Hide();
		--APHMinimizedFrame.Maxi:Hide()
		APHMover.Maxi:Hide();
		APHMover.Mini:Show()
		APHMainFrame:Show();
		APH.Minimized = not APH.Minimized
	else
		APHMainFrame:Hide();
		APHMover.Mini:Hide();
		APHMover.Maxi:Show()
		APHMinimizedFrame:Show();
		APH.Minimized = not APH.Minimized
	end
	dbc.Minimized = APH.Minimized
end

function APH:WeaponsTooltipEnter(id,rank, ap, left)
	rank = rank or 0
	ap = ap or 0
	left = left or 0
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
--	GameTooltip_SetDefaultAnchor(APHMainFrame, APHMainFrame)
	GameTooltip:SetOwner(APHMainFrame,"ANCHOR_CURSOR")
	name = GetItemInfo(id)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name,1, 0.9, 0.8,false)
	GameTooltip:AddDoubleLine("Rank:", rank)
	GameTooltip:AddDoubleLine("Artifact Power:",ap)
	GameTooltip:AddDoubleLine("Remaining:",left)
	GameTooltip:Show()
end

function APH:WeaponsTooltipLeave(id)
	GameTooltip_Hide()
end



function APH:PLAYER_EQUIPMENT_CHANGED(slot,hasItem)
--APH:Print("PLAYER_EQUIPMENT_CHANGED",slot,hasItem)
if slot == 16 or 17 then
--APH:Print("Weapons Changed")
APH:UpdateWeapons()
APH:Update()

end
end

function APH:WORLD_MAP_UPDATE()
	APH:WorldQuestsAP()
end

function APH:PLAYER_REGEN_DISABLED()
	timerFrame:UnregisterEvent("BAG_UPDATE")
	APHMainFrame:Hide()
	APHMinimizedFrame:Hide();
end

function APH:PLAYER_REGEN_ENABLED()
	timerFrame:RegisterEvent("BAG_UPDATE")
	if APH.Minimized then
		APHMinimizedFrame:Show();
	else
		APHMainFrame:Show()
	end
	APH:PreUpdate()
end

function APH:BAG_UPDATE()
--APH:Print("BAG_UPDATE")	
	APH:PreUpdate()
end

function APH:PLAYER_ENTERING_WORLD()
--APH:Print("PLAYER_ENTERING_WORLD")	
	APH:PreUpdate(true)
APH.Minimized = not APH.Minimized
APH:Minimize()

end

function APH:ADDON_LOADED()
	APH:SetBackground()
end

function APH:PLAYER_LOGIN()
	--if UnitLevel("PLAYER")<100 then APH:Disable() end
end

function APH:ARTIFACT_XP_UPDATE()
--APH:Print("ARTIFACT_XP_UPDATE")
	APH:PreUpdate(1)
end

function APH:BANKFRAME_OPENED()
	inBank = true
	APHMainFrame:SetFrameStrata("DIALOG")
	APHMinimizedFrame:SetFrameStrata("DIALOG")
	
	APH:PreUpdate(true)
end

function APH:BANKFRAME_CLOSED()
	if inBank then
		--APH:Print("Bank frame closed")
		inBank = false
		APHMainFrame:SetFrameStrata("BACKGROUND")
		APHMinimizedFrame:SetFrameStrata("BACKGROUND")
		APH:PreUpdate(true)
	end
end



function APH:StopMoving()
	APHMainFrame:StopMovingOrSizing()
	dbc.MainPosX = APHMainFrame:GetLeft()
	dbc.MainPosY = APHMainFrame:GetBottom() + APHMainFrame:GetHeight()
end

function APH:SetBackground()
--db.bgColor.r, db.bgColor.g, db.bgColor.b, db.bgColor.a
APHMainFrame.texture:SetColorTexture(dbc.bgColor.r, dbc.bgColor.g, dbc.bgColor.b, dbc.bgColor.a)
APHMinimizedFrame.texture:SetColorTexture(dbc.bgColor.r, dbc.bgColor.g, dbc.bgColor.b, dbc.bgColor.a)
end


	
	
	
	
APHMainFrame = CreateFrame("Frame", "ArtifactPowerFrame", UIParent)
    APHMainFrame:SetSize(220, 20)
	--APHMainFrame:SetScale(2)
	APHMainFrame:SetFrameStrata("BACKGROUND")
	APHMainFrame.texture = APHMainFrame:CreateTexture(nil, "BACKGROUND")
	--APHMainFrame.texture:SetColorTexture(0,0,0,.5)
	APHMainFrame.texture:SetAllPoints()
    --APHMainFrame:SetPoint("TOPLEFT", APHMover,"TOPRIGHT")--,"BOTTOMLEFT", APH.PosX,APH.PosY)
    APHMainFrame:SetMovable(true)
    APHMainFrame:SetClampedToScreen(true)
	APHMainFrame:SetDontSavePosition(true)
	APHMainFrame:EnableMouse(true)
	APHMainFrame:RegisterForDrag("LeftButton")
	APHMainFrame:SetScript("OnDragStart", APHMainFrame.StartMoving)
	APHMainFrame:SetScript("OnDragStop", function () APH:StopMoving() end)
	APHMainFrame:SetScript("OnEnter", function() APHMover:Show() end)
	APHMainFrame:SetScript("OnLeave", function() APHMover:Hide() end)
	APHMainFrame:SetHitRectInsets(-20, -20, -20, -20)
	

	
	
	
local APHInfoFrame = CreateFrame("Frame", "ArtifactInfoFrame", ArtifactPowerFrame)
		APHInfoFrame:SetSize(220,40)
		APHInfoFrame:SetPoint("TOPLEFT", ArtifactPowerFrame)
		APHInfoFrame.ItemsAP= APHInfoFrame:CreateFontString("TotalItemsAP","ARTWORK","NumberFontNormal")
		APHInfoFrame.ItemsAP:SetFont("Fonts\\FRIZQT__.TTF", 10)
		APHInfoFrame.ItemsAP:SetJustifyH("CENTER")
		APHInfoFrame.ItemsAP:SetPoint("TOPLEFT")
		APHInfoFrame.ItemsAP:SetWidth(110)
		APHInfoFrame.WorldQuestsAP= APHInfoFrame:CreateFontString("WorldQuestsAP","ARTWORK","NumberFontNormal")
		APHInfoFrame.WorldQuestsAP:SetFont("Fonts\\FRIZQT__.TTF", 10)
		APHInfoFrame.WorldQuestsAP:SetJustifyH("CENTER")
		APHInfoFrame.WorldQuestsAP:SetPoint("TOPLEFT",110,0)
		APHInfoFrame.WorldQuestsAP:SetWidth(110)
		--APHInfoFrame.RemainingAP= APHInfoFrame:CreateFontString("RemainingAP","ARTWORK","NumberFontNormal")
		--APHInfoFrame.RemainingAP:SetFont("Fonts\\FRIZQT__.TTF", 10)
		--APHInfoFrame.RemainingAP:SetJustifyH("CENTER")
		--APHInfoFrame.RemainingAP:SetPoint("TOPLEFT",147,0)
		--APHInfoFrame.RemainingAP:SetWidth(73)
		APHInfoFrame.BankAP = APHInfoFrame:CreateFontString("BankAP","ARTWORK","NumberFontNormal")
		APHInfoFrame.BankAP:SetFont("Fonts\\FRIZQT__.TTF", 10)
		APHInfoFrame.BankAP:SetJustifyH("CENTER")
		APHInfoFrame.BankAP:SetPoint("TOPLEFT",0,-110-(APItemsHeight or 20))
		APHInfoFrame.BankAP:SetWidth(220)


function APH:UpdateTexts()
--APHInfoFrame.CurAp:SetText("Current\n"..BreakUpLargeNumbers(CurPow))
APHInfoFrame.ItemsAP:SetText("Items\n"..BreakUpLargeNumbers(TotalArtifactPower)) --.. "/" .. BreakUpLargeNumbers( (CostOfNext or 0) - (CurPow or 0) ) )
APHInfoFrame.WorldQuestsAP:SetText("World Quests\n"..BreakUpLargeNumbers(WQAP))
--APHInfoFrame.RemainingAP:SetText("Remaining\n"..BreakUpLargeNumbers(CostOfNext - CurPow))
if inBank then
	APHInfoFrame.BankAP:Show()
	APHInfoFrame.BankAP:SetText("Bank Artifact Power\n"..BreakUpLargeNumbers(BankTotalAP))
	APHInfoFrame.BankAP:SetPoint("TOPLEFT",0,-100-(math.floor((#ArtPow+5)/6)*36 or 20))
else
	APHInfoFrame.BankAP:Hide()
end

end	
	
local APHItemFrame = CreateFrame("Frame", "ArtifactItemFrame", ArtifactPowerFrame)
	APHItemFrame:SetPoint("BOTTOMLEFT", ArtifactInfoFrame,"BOTTOMLEFT",0,0)
	--APH:CreateArtifactItems()
	APH:CreateWeaponsIcons()

local APHMinimizedFrame = CreateFrame("Frame","APHMinimizedFrame", UIParent)
	APHMinimizedFrame:SetSize(50,50)
	--APHMinimizedFrame:SetPoint(APH.MoverAnchor or "TOPLEFT", APHMainFrame)--,-54,0)
	APHMinimizedFrame:SetFrameStrata("BACKGROUND")
	APHMinimizedFrame.texture = APHMinimizedFrame:CreateTexture(nil, "BACKGROUND")
	APHMinimizedFrame.texture:SetColorTexture(0,0,0,1)
	APHMinimizedFrame.texture:SetAllPoints()
    --APHMinimizedFrame:SetMovable(true)
    --APHMinimizedFrame:SetClampedToScreen(true)
	--APHMinimizedFrame:SetDontSavePosition(true)
	APHMinimizedFrame:EnableMouse(true)
	--APHMinimizedFrame:RegisterForDrag("LeftButton")
	--APHMinimizedFrame:SetScript("OnDragStart", APHMainFrame.StartMoving)
	APHMinimizedFrame:SetScript("OnDragStop", function () APH:StopMoving() end)
	
	
	APHMinimizedFrame.Icon = CreateFrame("Button","MinimizedWeapon",APHMinimizedFrame,"SecureActionButtonTemplate")
	APHMinimizedFrame.Icon:SetSize(36,36)
	APHMinimizedFrame.Icon.Texture=APHMinimizedFrame.Icon:CreateTexture(nil,"BACKGROUND")
	APHMinimizedFrame.Icon.Texture:SetAllPoints()
	APHMinimizedFrame.Icon:SetPoint("CENTER",APHMinimizedFrame)
	APHMinimizedFrame.Icon:SetPushedTexture([[Interface\Buttons\UI-Quickslot-Depress]])
	APHMinimizedFrame.Icon:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]],"ADD")
	APHMinimizedFrame.Icon.Percent = APHMinimizedFrame.Icon:CreateFontString("Percent","ARTWORK","NumberFontNormal")
	APHMinimizedFrame.Icon.Percent:SetFont("Fonts\\FRIZQT__.TTF", 10, "THICKOUTLINE")
	APHMinimizedFrame.Icon.Percent:SetJustifyH("CENTER")
	APHMinimizedFrame.Icon.Percent:SetJustifyV("MIDDLE")
	APHMinimizedFrame.Icon.Percent:SetPoint("CENTER",2,0)
	APHMinimizedFrame.Icon:SetScript("OnEnter", function() APHMinimizedFrame.Maxi:Show() end)
	APHMinimizedFrame.Icon:SetScript("OnLeave", function() APHMinimizedFrame.Maxi:Hide() end)

	if msqGroups["APHWeapons"] then msqGroups.APHWeapons:AddButton(APHMinimizedFrame.Icon) end

	
	APHMinimizedFrame:SetScript("OnEnter", function() APHMover:Show() end)
	APHMinimizedFrame:SetScript("OnLeave", function() APHMover:Hide() end)
	APHMinimizedFrame:SetHitRectInsets(-10, -10, -10, -10)

	APHMinimizedFrame:Hide()


APHMover = CreateFrame("Frame","APHMover",UIParent)
	APHMover:SetSize(32,50)
    APHMover:SetPoint("TOPRIGHT", APHMainFrame,"TOPLEFT")--,"BOTTOMLEFT", APH.PosX,APH.PosY)
	--APHMover:SetPoint("BOTTOMRIGHT",APHMainFrame)
	APHMover.Texture = APHMover:CreateTexture(nil,"BACKGROUND")
	--APHMover.Texture:SetColorTexture(0.3,0.3,0.3,0.9)
	APHMover.Texture:SetAllPoints()
	--APHMover:SetPoint("TOPLEFT", UIParent,"BOTTOMLEFT", APH.PosX,APH.PosY)
	--APHMover:SetMovable(true)
	APHMover:EnableMouse(true)
	--APHMover:RegisterForDrag("LeftButton")
	--APHMover:SetScript("OnDragStart", APHMover.StartMoving)
	--APHMover:SetScript("OnDragStop", function () APH:StopMoving() end)
	APHMover:SetScript("OnEnter", function() APHMover:Show() end)
	APHMover:SetScript("OnLeave", function() APHMover:Hide() end)
	APHMover:SetHitRectInsets(0, -10, 0, -10)
	--APHMover:HookScript("OnHide",APH:StopMoving())
	APHMover:Hide()

	APHMover.Mini = CreateFrame("Button","Minimize",APHMover,"SecureActionButtonTemplate")
	APHMover.Mini:SetSize(32,32)
	APHMover.Mini.Texture=APHMover.Mini:CreateTexture(nil,"BACKGROUND")
	APHMover.Mini.Texture:SetAllPoints()
	APHMover.Mini:SetPoint("TOP",APHMover,0,5)
	APHMover.Mini:SetNormalTexture([[Interface\Buttons\UI-Panel-SmallerButton-Up]])
	APHMover.Mini:SetPushedTexture([[Interface\Buttons\UI-Panel-SmallerButton-Down]])
	APHMover.Mini:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]],"ADD")
	--APHMover.Mini:Hide()
	APHMover.Mini:SetScript("OnEnter", function() APHMover:Show() end)
	APHMover.Mini:SetScript("OnMouseUp", function() APH:Minimize() end)

	APHMover.Maxi = CreateFrame("Button","APHMaximize",APHMover,"SecureActionButtonTemplate")
	APHMover.Maxi:SetSize(32,32)
	APHMover.Maxi.Texture=APHMover.Maxi:CreateTexture(nil,"BACKGROUND")
	APHMover.Maxi.Texture:SetAllPoints()
	APHMover.Maxi:SetPoint("TOP",APHMover,0,5)
	--APHMover.Maxi:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	APHMover.Maxi:SetNormalTexture([[Interface\Buttons\UI-Panel-BiggerButton-Up]])
	APHMover.Maxi:SetPushedTexture([[Interface\Buttons\UI-Panel-BiggerButton-Down]])
	APHMover.Maxi:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]],"ADD")
	APHMover.Maxi:SetScript("OnEnter", function() APHMover:Show() end)
	APHMover.Maxi:SetScript("OnMouseUp", function() APH:Minimize() end)
	APHMover.Maxi:Hide()
