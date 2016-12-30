-- Copyright 2012 Akhaan & Honesty Hyj (www.quickdkp.com)
-- This file is a part of QDKP_V2 (see about.txt in the Addon's root folder)

--             ## CORE FUNCTIONS ##
--               Loot Functions
--
--      Function to detect, qualify and charge loots
--
-- API Documentation:
--
-- QDKP2_Loot(Player, itemLink, [itemQuantity=1]) -- This is called whenever a player loots something. It checks for everything (Logging, price, warnings...).
-- QDKP2_GetItemPrice(item, [Zone]) -- Returns the DKP price of the given item dropped in <Zone>. If Zone is not provided, then GetRealZoneText() is used
-- QDKP2_PayLoot(name, quota, loot, ZS) --<name> pays <quota> for <loot>. if ZS, it will trigger a zerosum award. The latter needs management mode.
-- QDKP2_FixedPricesSet(todo) -- Activate/deactivate the fixed price chargin. todo can be 'on', 'off' or 'toggle'
-- QDKP2_GiveLootToPlayer(itemLink, player) -- tries to give loot to the specified player. If fails, returns false,reason.


-- Loot Handler
function QDKP2_OnLoot(name, item, itemQty)
  if not QDKP2_ManagementMode() then return; end
  name = QDKP2_FormatName(name) -- make sure name is properly formatted
  if not name or type(name)~='string' or not QDKP2_IsInGuild(name) then
    QDKP2_Debug(1,"Core","Called QDKP2_Loot with invalid Player name: "..tostring(name))
    return
  end
  if not item or type(item)~='string' then
    QDKP2_Debug(1,"Core","Called QDKP2_Loot with invalid item: "..tostring(item))
    return
  end
  itemQty=itemQty or 1
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, invTexture = GetItemInfo(item)
  -- WORKAROUND: Libbabble-Inventory does not have the "Money" item type! This feature won't work on non-english localized clients till the
  --             LibBabble devs don't introduce the word.
  if not itemName then
    QDKP2_Debug(1,"Core","GetItemInfo failed for "..item)
    return
  end
  if (itemType=="Money" or QDKP2inventoryEnglish[itemType]=="Money") and not QDKP2_LogBadges then return; end           -- Badges
  if QDKP2inventoryEnglish[itemType]=="Trade Goods" and QDKP2inventoryEnglish[itemSubType]=="Enchanting" and not QDKP2_LogShards then
    return   -- Disenchanted stuff
  end

  if itemRarity >= MIN_CHARGABLE_LOOT_QUALITY and QDKP2_IsInGuild(name) then
    QDKP2_LootItem = itemLink
    QDKP2_LooterName = name
  end
  if itemRarity >= MIN_LISTABLE_QUALITY then
    QDKP2_Events:Fire("ADD_LOOT_HISTORY",itemLink)
  end

  local toLogPvt, toLogRaid
  local timestamp=QDKP2_Timestamp()
  --quality-based logging
  if (itemRarity >= MIN_LOGGED_LOOT_QUALITY and QDKP2_IsInGuild(name)) then toLogPvt=true; end
  if (itemRarity >= MIN_LOGGED_RAID_LOOT_QUALITY and toLogPvt) then toLogRaid=true; end
  --Items you don't want to log (QDKP2_NotLogLoots table)
  for i=1,#QDKP2_NotLogLoots do                            --error here length of nil
    local Item=QDKP2_NotLogLoots[i]
    if string.lower(Item) == string.lower(itemName) then
      toLogPvt=false
      toLogRaid=false
      break
    end
  end
  --Items you WANT to log (QDKP2_LogLoots table)
  local LootTableLvl
  for i=1,#QDKP2_LogLoots do
  local Loot=QDKP2_LogLoots[i]
    local tologItem=Loot.item
    if string.lower(tologItem)==string.lower(itemName) then
      LootTableLvl=Loot.level; break
    end
  end
  if LootTableLvl then
    local msg=string.gsub(QDKP2_LOC_LootsItem,"$ITEM",itemLink)
    if ToLog >= 1 then  --log it
      toLogPvt=true; toLogRaid=true
    end
    if ToLog == 2 then QDKP2_Msg(QDKP2_COLOR_BLUE..name.." "..msg); end --message
    if ToLog == 3 then QDKP2_NotifyUser(name.." "..msg); end            --warning
  end
  --Now log or go away.
  if toLogPvt then
    local flags=nil
    if itemQty>1 then flags=QDKP2log_PacketFlags(nil,nil,nil,nil,itemQty); end
    QDKP2log_Entry(name,item, QDKP2LOG_LOOT, nil, timestamp, flags)
  end
  if toLogPvt and toLogRaid then QDKP2log_Link("RAID", name, timestamp);end

  if QDKP2_GuildData.FixedPrices then
    local price=QDKP2_GetItemPrice(item)
    if price and price ~= 0 then QDKP2_OpenToolboxForCharge(name, price, itemLink)
    elseif price and QDKP2_AlwaysOpenToolbox then QDKP2_OpenToolboxForCharge(name, nil, itemLink)
    end
  end
  QDKP2_Events:Fire("DATA_UPDATED","log")
end


function QDKP2_GetItemPrice(item, zone)
-- returns the DKPprice of <item> dropped in <zone>
-- DKPPrice is price if the item is a valid raid drop, nil elseif.
-- This appears to be a kluge for handling token prices in two specific instances.  Has not been updated for post-SoO
  if not item or type(item)~='string' then
    QDKP2_Debug(1,"Core","Called GetItemPrice with invalid item: "..tostring(item))
    return nil
  end
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, invTexture = GetItemInfo(item)
  if not itemName then
    QDKP2_Debug(2,"Core","GetItemInfo failed for "..item)
    return nil
  end
  zone=zone or GetRealZoneText()
  local diff,price,tipo,zonaDrop, ManagedDrop, difficulty
  local zoneEng=QDKP2zoneEnglish[zone] or zone
  if zoneEng == "Siege of Orgrimmar" then  --Here change to new raid zones-------
    zonaDrop='SoO'
  elseif zoneEng == "Throne of Thunder" then
    zonaDrop='ToT'
  elseif zoneEng == "Hellfire Citadel" then
    zonaDrop='HFC'
  elseif zoneEng == "The Emerald Nightmare" then
    zonaDrop='TEN'
  elseif zoneEng == "Nighthold" then
    zonaDrop='NH'
  end
  --[[
  local difficulty=GetRaidDifficultyID()
  if     difficulty==3 then Diff="10"
  elseif difficulty==4 then Diff="25"
  elseif difficulty==5 then Diff="10H"
  elseif difficulty==6 then Diff="25H"
  elseif difficulty==7 then Diff="LFR"
  elseif difficulty==9 then Diff="40"
  elseif difficulty==14 then Diff="flex"
  end
  --]]
  --Modified 6.0.3 to make consistent with the rest
  
  difficulty, diff = QDKP2_InstanceDiff()
  
  
  if QDKP2inventoryEnglish[itemType]=='Weapon' then tipo = 'Weap'
  elseif QDKP2inventoryEnglish[itemType]=='Armor' then tipo = 'Armor'
  elseif QDKP2inventoryEnglish[itemType]=='Miscellaneous' and --these should be all the tokens for the tiers.
    QDKP2inventoryEnglish[itemSubType]=='Junk' and
    itemRarity==4 and
    itemMinLevel>=100 then tipo='Tier'
  elseif QDKP2inventoryEnglish[itemType]=='Miscellaneous' and  --this is the trophy of the crusader
    QDKP2inventoryEnglish[itemSubType]=='Other' and
    itemRarity==4 and
    itemLevel==100 then tipo='Tier'
  end
  if zonaDrop and diff and tipo and itemRarity>=MIN_POPUP_TOOLBOX_Q then
    local variable='QDKP2_Prices_'..zonaDrop..diff..'_'..tipo
    price=getglobal(variable)
    QDKP2_Debug(3,"Core","Loot is a valid raid drop. Looking for default amount "..variable.."="..tostring(price))
    price = price or 0
  end
  for i=1,#QDKP2_ChargeLoots do
    local Loot=QDKP2_ChargeLoots[i]
    if string.lower(Loot.item) == string.lower(itemName) then
      price=Loot.DKP
      break
    end
  end
  return price
end

function QDKP2_PayLoot(name, quota, loot, ZS)
  if type(name)=='table' then
    QDKP2_Msg("Payment of loot in multiple selection is not allowed.")
    return
  end

  if type(quota)=='string' then quota=QDKP2_GetAmountFromText(quota,name); end

  if not quota then
    QDKP2_Debug(1,"Core","PayLoot failed. quota is nil.")
    return
  end

  if not QDKP2_IsChargeable(name,quota) then
    QDKP2_Msg(nam.." cannot be charged by the given amount!","WARNING")
    return
  end
  if not ZS then
    local timestamp=QDKP2_Timestamp()
    QDKP2_AddTotals(name,nil,quota,nil,loot,nil,timestamp)
    if QDKP2_IsManagingSession() then QDKP2log_Link("RAID",name,timestamp,QDKP2_OngoingSession()); end
    if QDKP2_SENDTRIG_CHARGE then QDKP2_UploadAll(); end
  else
    QDKP2_RaidAward(quota,loot, name)
  end
end


function QDKP2_OpenToolboxForCharge(name,amount,reason)
--dummy of payloot, only used if QDKP2GUI isn't loaded
  if not QDKP2_OfficerMode() then QDKP2_Msg(QDKP2_LOC_NoRights,"ERROR")(); return; end
  if not name then return; end
  if not amount then
    QDKP2_OpenInputBox("Enter DKP amount to charge "..name.."\nfor "..tostring(reason),
      function(amount,name,reason)
        if amount and tonumber(amount) then QDKP2_OpenToolboxForCharge(name,tonumber(amount),reason);end
      end, name, reason)
  else
    QDKP2_AskUser("Do you want to charge "..tostring(amount).." DKP to\n"..name.."\nfor "..tostring(reason).."?",
    QDKP2_PayLoot,
    name,amount,itemLink
    )
  end
end


function QDKP2_FixedPricesSet(todo)
  if todo == "toggle" then
    if QDKP2_GuildData.FixedPrices then QDKP2_FixedPricesSet("off")
    else QDKP2_FixedPricesSet("on")
    end
  elseif todo==true or todo == "on" then
    QDKP2_GuildData.FixedPrices = true
    QDKP2_Events:Fire("FIXEDPRICES_ON")
    QDKP2_Msg(QDKP2_COLOR_YELLOW.."Fixed Prices Table enabled")
  elseif todo==false or todo == "off" then
    QDKP2_GuildData.FixedPrices = false
    QDKP2_Events:Fire("FIXEDPRICES_OFF")
    QDKP2_Msg(QDKP2_COLOR_YELLOW.."Fixed Prices Table disabled")
  end
end

function QDKP2_IsMasterLooter()
	lootmethod, masterlooterPartyID, masterlooterRaidID=GetLootMethod()
	--if masterlooterRaidID and masterlooterRaidID==GetNumGroupMembers() then return true; end
	if lootmethod=="master" and masterlooterPartyID==0 then return true; end  --5.0 change, should be ok for nil party id
end

function QDKP2_GiveLootToPlayer(item, name, simul)
  QDKP2_Debug(2,"Core","Giving "..tostring(item).." to "..tostring(name).." (simul="..tostring(simul))
	local lootmethod = GetLootMethod()
  local lootnum=GetNumLootItems()
 	local itemName,itemLink = GetItemInfo(item or '')
	if not lootmethod=='master' then return false, 'Loot method is not master looter.'; end
	if not itemLink then return false, 'Did not received a valid item'; end
	if not QDKP2_IsMasterLooter() then return false, "You need to be lootmaster to give loot"; end
	if not lootnum or lootnum==0 then return false, "No loot window detected or window is empty."; end

	local itemSlot
	for i=1,GetNumLootItems() do
		if GetLootSlotLink(i)==itemLink then itemSlot=i; break; end
	end
	if not itemSlot then return false,"Couldn't find the given item in the loot window."; end

	local nameSlot, shortName
	local qName1, qServer1 = strsplit("-", name, 2)
	if (qServer1 == QDKP2_playerRealm) then
		shortName = qName1
	else
		shortName = name
	end
	for i=1,50 do 
		if GetMasterLootCandidate(itemSlot, i)==shortName then nameSlot=i; break; end
	end
	if not nameSlot then return false, "Given player is not eligible to loot that object."; end
	if not simul then GiveMasterLoot(itemSlot, nameSlot); end

	return true
end


--[[
local forbidden_items={
"DEATH KNIGHT"=[
  "Shields"=true,
  "Librams"=true,
  "Totems"=true,
  "Idols"=true
  "Bows"=true,
  "Crossbows"=true,
  "Guns"=true,
  "Thrown"=true,
  "Daggers"=true
  "Staves"=true
  "Fist Weapons"=true,
  "Wands"=true,
},

"DRUID"=[
  "Mail"=true
  "Plate"=true
  "Shields"=true
  "Librams"=true
  "Totems"=true
  "Sigils"=true
  "Bows"=true,
  "Crossbows"=true,
  "Guns"=true,
  "Thrown"=true,
  "One-Handed Axes"=true
  "One-Handed Swords"=true
  "Two-Handed Axes"=true
  "Two-Handed Swords"=true
  "Wands"=true
},

"HUNTER"=[
  "Plate"=true
  "Shields"=true
  "Librams"=true
  "Totems"=true
  "Sigils"=true
  "Idols"=true
  "One-Handed Maces"=true
  "Two-Handed Maces"=true
  "Wands"=true
},

"MAGE"=[
  "Leather"=true
  "Mail"=true
  "Plate"=true
  "Shields"=true
  "Librams"=true
  "Totems"=true
  "Sigils"=true
  "Idols"=true
  "Bows"=true,
  "Crossbows"=true,
  "Guns"=true,
  "Thrown"=true,
  "Fist Weapons"=true
  "One-Handed Axes"=true
  "One-Handed Maces"=true
  "Polearms"=true
  "Two-Handed Axes"=true
  "Two-Handed Swords"=true
  "Two-Handed Maces"=true
},

"PALADIN"=[
  "Idols"=true
  "Totems"=true
  "Sigils"=true
  "Bows"=true,
  "Crossbows"=true,
  "Guns"=true,
  "Thrown"=true,
  "Wands"=true
  "Daggers"=true
  "Fist Weapons"=true
  "Staves"=true
},

"PRIEST"=[
  "Leather"=true
  "Mail"=true
  "Plate"=true
  "Shields"=true
  "Librams"=true
  "Totems"=true
  "Sigils"=true
  "Idols"=true
  "Bows"=true,
  "Crossbows"=true,
  "Guns"=true,
  "Thrown"=true,
  "Fist Weapons"=true
  "One-Handed Axes"=true
  "One-Handed Swords"=true
  "Polearms"=true
  "Two-Handed Axes"=true
  "Two-Handed Swords"=true
  "Two-Handed Maces"=true
},

"ROGUE"=[
  "Mail"=true
  "Plate"=true
  "Shields"=true
  "Librams"=true
  "Totems"=true
  "Sigils"=true
  "Idols"=true
  "Polearms"=true
  "Two-Handed Axes"=true
  "Two-Handed Swords"=true
  "Two-Handed Maces"=true
  "Staves"=true
  "Wands"=true
},
"SHAMAN"=[
  "Plate"=true
  "Idols"=true
  "Librams"=true
  "Sigils"=true
  "Wands"=true
  "Polearms"=true
  "One-Handed Swords"=true
  "Two-Handed Swords"=true
},
"WARLOCK"=[
  "Leather"=true
  "Mail"=true
  "Plate"=true
  "Shields"=true
  "Librams"=true
  "Totems"=true
  "Sigils"=true
  "Idols"=true
  "Bows"=true,
  "Crossbows"=true,
  "Guns"=true,
  "Thrown"=true,
  "Fist Weapons"=true
  "One-Handed Axes"=true
  "One-Handed Maces"=true
  "Polearms"=true
  "Two-Handed Axes"=true
  "Two-Handed Swords"=true
  "Two-Handed Maces"=true
},
"WARRIOR" = {
  "Librams"=true
  "Idols"=true
  "Totems"=true
  "Sigils"=true
  "Wands"=true
}


function QDKP2_BidM_CanUseItem(item,class)
--returns true if class can use item.
--class must be in english and all upercase, eg WARRIOR
  if not item then
    QDKP2_Debug(1,"Core","Asking CanUseItem but nil item provided")
    return
  elseif not class then
    QDKP2_Debug(1,"Core","Asking CanUseItem but nil item provided")
    return
  end
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType  = GetItemInfo(item)

  if not itemName then
    QDKP2_Debug(1,"Core","Asking CanUseItem but invalid item provided: "..tostring(item))
    return
  elseif not itemSubType then
    QDKP2_Debug(2,"Core",itemName.." doesn't appear to have a itemSubType. assuming it's usable."
  itemSubType=QDKP2inventoryEnglish[itemSubType] or itemSubType

  local ko_items=forbidden_items[class]
  if not ko_items then
    QDKP2_Debug(1,"Core","Asking CanUseItem but invalid class provided: "..tostring(class))
    return
  end
  if ko_items[itemSubType]


]]
