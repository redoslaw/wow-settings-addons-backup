local g = BittensGlobalTables
local c = g.GetOrMakeTable("BittensSpellFlashLibrary", 2)
local u = g.GetTable("BittensUtilities")
if u.SkipOrUpgrade(c, "MainFile", tonumber("20150310040701") or time()) then
   return
end

local s = SpellFlashAddon
-- local x = s.UpdatedVariables

local GetNumGroupMembers = GetNumGroupMembers
local GetPowerRegen = GetPowerRegen
local GetSpecialization = GetSpecialization
local GetSpellCharges = GetSpellCharges
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local GetTotemInfo = GetTotemInfo
local GetVersatilityBonus = GetVersatilityBonus
local IsInRaid = IsInRaid
local IsItemInRange = IsItemInRange
local IsMounted = IsMounted
local UnitExists = UnitExists
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitInVehicle = UnitInVehicle
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsUnit = UnitIsUnit
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType
local UnitSpellHaste = UnitSpellHaste
local UnitThreatSituation = UnitThreatSituation

local max = math.max
local min = math.min
local pairs = pairs
local print = print
local select = select
local string = string
local tinsert = table.insert
local type = type
local unpack = unpack
local wipe = wipe

c.Flashing = { }

function c.Init(a)
   c.A = a
end

function c.RegisterAddon()
   c.RegisterForEvents()
   c.RegisterOptions()

   local a = c.A
   u.GetOrMakeTable(a, "SpecialGCDs")
   s.RegisterModuleSpamFunction(a.AddonName, function()
      c.Init(a)
      local rotation = c.GetCurrentRotation()
      if rotation == nil then
         c.DisableProcHighlights = false
         return
      end
      c.DisableProcHighlights = not c.AlwaysShowBlizHighlights

      local inCombat = s.InCombat()
      if (IsMounted() and not inCombat)
         or UnitIsDeadOrGhost("player")
         or UnitInVehicle("player")
      then
         return
      end

      c.UpdateEstimatedTargetCounts(rotation.GCDsForAoE)
      if c.UpdateLDB then
         -- @todo danielp 2015-03-09: someone reported this not existing, play
         -- it safe, and strip this in a while when we are confident...
         c.UpdateLDB()
      end

      wipe(c.Flashing)
      if a.PreFlash then
         a.PreFlash()
      end

      if rotation.PreFlash then
         rotation:PreFlash()
      end

      if rotation.FlashAlways then
         rotation:FlashAlways()
      end
      if inCombat then
         if rotation.FlashInCombat then
            rotation:FlashInCombat()
            c.FlashCommonInCombat()
         end
      else
         c.FlashCommonOutOfCombat(rotation)
         if rotation.FlashOutOfCombat then
            rotation:FlashOutOfCombat()
         end
      end
   end)
end

function c.GetCurrentRotation()
   for name, rotation in pairs(c.A.Rotations) do
      local optionName = "Flash" .. name
      if (rotation.CheckFirst == nil or rotation.CheckFirst())
         and rotation.Spec == GetSpecialization()
         and (not c.HasOption(optionName) or c.GetOption(optionName))
      then
         if rotation.Warning then
            u.Schedule(
               15, print,
               "|TInterface/TargetingFrame/UI-RaidTargetingIcon_8:0|t  " ..
                  "|cFFFF0000" .. rotation.Warning .. "|r -- SlippyCheeze" ..
                  "  |TInterface/TargetingFrame/UI-RaidTargetingIcon_8:0|t"
            )
            rotation.Warning = nil
         end
         return rotation
      end
   end
end

function c.GetSpell(name)
   if c.A.Spells then
      local spell = c.A.Spells[name]
      if spell == nil then
         spell = c.AddSpell(name)
      end
      return spell
   else
      return c.A.spells[name]
   end
end

function c.GetCooldown(name, noGCD, fullCD)
   local id = c.GetID(name)
   if not c.HasSpell(id) then
      return 9001 -- (more than 9000!)
   end

   if fullCD and c.IsCasting(id) then
      return fullCD
   else
      return max(0, s.SpellCooldown(id) - c.GetBusyTime(noGCD))
   end
end

function c.GetMinCooldown(...)
   local min
   local minName
   for i = 1, select("#", ...) do
      local name = select(i, ...)
      local cd = c.GetCooldown(name)
      if min == nil or cd < min then
         min = cd
         minName = name
      end
   end
   return min, minName
end

-- returns (number-of-charges, time-until-next-charge, time-until-max-charges)
function c.GetChargeInfo(name, noGCD)
   local charges, max, start, duration = GetSpellCharges(c.GetID(name))
   if charges == nil then
      -- don't have the spell.
      return 0, 9001, 9001
   end

   local untilNext = start + duration - GetTime()
   local busy = c.GetBusyTime(noGCD)
   if untilNext <= busy then
      charges = charges + 1
      untilNext = untilNext + duration
   end
   if c.IsCasting(name) then
      charges = charges - 1
   end
   if charges == max then
      return charges, 9001, 0
   else
      return charges, untilNext, untilNext + duration * (max - charges - 1)
   end
end

function c.GetIDs(...)
   local ids = {}
   for i = 1, select("#", ...) do
      local id = c.GetID(select(i, ...))
      if id then
         tinsert(ids, id)
      end
   end
   return ids
end

function c.GetID(name)
   if type(name) == "number" or type(name) == "table" then
      return name
   end

   local id
   if c.A.SpellIDs == nil then
      local spell = c.A.spells[name]
      if spell ~= nil then
         id = spell.ID
      end
   else
      id = c.A.SpellIDs[name]
   end
   if id then
      return id
   else
      if name ~= nil then
         print("No spell defined (or no ID attribute):", name)
      end
   end
end

local tankingByTarget = {
   [60143] = true, -- Gara'jal the Spiritbinder
   [2938] = true, -- lost name.  a scenario "boss".
}

function c.IsTanking(unit)
   if not unit then
      unit = "player"
   end

   -- Gara'jal (the Spiritbinder) does not attack his primary threat target
   -- most of the time.  Instead he attacks the person he put the voodoo thing
   -- on.
   local _, targetID = s.UnitInfo()
   if tankingByTarget[targetID] then
      return UnitIsUnit("targettarget", unit)
   else
      local status = UnitThreatSituation(unit, "target")
      return status == 2 or status == 3
   end
end

function c.WearingSet(number, name)
   local count = 0
   for slot, piece in pairs(c.A.EquipmentSets[name]) do
      if s.Equipped(piece, slot) then
         count = count + 1
      end
   end
   return count >= number
end

function c.HasTalent(name)
   local id = c.A.TalentIDs[name]
   if id == nil then
      print('No talent defined:', name)
   else
      return not not s.HasTalent(id)
   end
end

function c.HasGlyph(name)
   local id = c.A.GlyphIDs[name]
   if id == nil then
      print('No glyph defined:', name)
   else
      return s.HasGlyph(id)
   end
end

function c.Form(name)
   return s.Form(name and c.GetID(name) or nil)
end

local function getCastTime(localizedNameOrId)
  return (select(4, GetSpellInfo(localizedNameOrId)) or 0) / 1000
end

function c.GetCastTime(name)
   return getCastTime(c.GetID(name))
end

function c.GetCost(name)
   return s.SpellCost(s.SpellName(c.GetID(name)))
end

local fullChannels = { }
local channelBuffs = { }
function c.RegisterForFullChannels(name, unhastedChannelTime, channelViaBuff)
   local id = c.GetID(name)
   fullChannels[s.SpellName(id)] = unhastedChannelTime
   if channelViaBuff then
      channelBuffs[id] = true
   end
end

function c.RegisterBusyDuringBuff(name, unhastedChannelTime)
   c.RegisterForFullChannels(name, unhastedChannelTime)
end

local function getChannelTimeRemaining()
   local remaining = 0
   if fullChannels[s.ChannelingName(nil, "player")] then
      remaining = s.GetChanneling(nil, "player")
   end
   for buff in u.Keys(channelBuffs) do
      remaining = max(remaining, s.BuffDuration(buff, "player"))
   end
   return remaining
end

local function getCastFinish(info)
   return info.CastStart + getCastTime(info.Name)
end

local function getChannelFinish(info)
   local time = fullChannels[info.Name]
   if time then
      time = c.GetHastedTime(time)
   else
      time = 0
   end
   return info.CastStart + time
end

local function getGcdFinish(info)
   local nextGcd = c.A.SpecialGCDs[info.Name]
   if nextGcd == nil then
      nextGcd = c.LastGCD
   elseif nextGcd == "hasted" then
      nextGcd = max(1, c.GetHastedTime(1.5))
   end
   return info.GCDStart + nextGcd
end

function c.GetBusyTime(noGCD)
   local busy = 0
   local info = c.GetQueuedInfo()
   if info then
      busy = max(getCastFinish(info), getChannelFinish(info))
      if not noGCD then
         busy = max(busy, getGcdFinish(info))
      end
      busy = max(0, busy - GetTime())
   end
   if not noGCD then
      local gcd = s.GlobalCooldown()
      busy = max(busy, gcd)
   end
   return max(
      s.GetCasting(nil, "player"), getChannelTimeRemaining(), busy)
end

local function advancePowerCalc(t, power, newT, regen, max, info, powerType)
   if newT > t then
      power = min(max, power + regen * (newT - t))
      t = newT
   end
   if info then
      local cost = info.Cost[powerType]
      if not cost then
         cost = s.SpellCost(info.Name, powerType)
      end
      power = min(max, power - cost)
   end
   return t, power
end

-- If you supply a powerType it will not consider any currently casting spell.
-- But that should be OK, since I can only think of instant cast spells that use
-- secondary power.
function c.GetPower(regen, powerType)
   if not regen then
      regen = select(2, GetPowerRegen())
   end
   if not powerType then
      powerType = UnitPowerType("player")
   end

   local t = GetTime()
   local power = UnitPower("player", powerType)
   local max = UnitPowerMax("player", powerType)
--c.Debug("GetPower", power, "initial")

   -- current cast
   t, power = advancePowerCalc(
      t, power,
      GetTime() + s.GetCasting(nil, "player"), regen, max,
      c.GetCastingInfo(), powerType)
--c.Debug("GetPower", power, "After Current Cast")
   t, power = advancePowerCalc(
      t, power, GetTime() + getChannelTimeRemaining(), regen, max)
--c.Debug("GetPower", power, "After Current Channel")

   -- queued cast
   local queued = c.GetQueuedInfo()
   if queued then
      t, power = advancePowerCalc(
         t, power, getCastFinish(queued), regen, max, queued, powerType)
--c.Debug("GetPower", power, "After Queued Cast")
      t, power = advancePowerCalc(
         t, power, getChannelFinish(queued), regen, max)
--c.Debug("GetPower", power, "After Queued Channel")
      t, power = advancePowerCalc(t, power, getGcdFinish(queued), regen, max)
--c.Debug("GetPower", power, "After Queued GCD")
   end

   -- current gcd
   local _
   _, power = advancePowerCalc(
      t, power, GetTime() + s.GlobalCooldown(), regen, max)
--c.Debug("GetPower", power, "After Current GCD")
   return power
end

function c.GetPowerPercent()
   return c.GetPower() / UnitPowerMax("player") * 100
end

local function convertToIDs(attributes, key, ...)
   if string.find(key, "Use") then
      return
   end
   for i = 1, select("#", ...) do
      local pattern = select(i, ...)
      local _, last = string.find(key, pattern)
      if last == #key then
         local value = attributes[key]
         if type(value) == "table" then
            attributes[key] = c.GetIDs(unpack(value))
         else
            attributes[key] = c.GetID(value)
         end
      end
   end
end

function c.AddSpell(spellName, tag, attributes)
   local name = spellName
   if tag then
      name = name .. " " .. tag
   end
   if c.A.Spells == nil then
      c.A.Spells = { }
      c.A.AurasToSpells = { }
   elseif c.A.Spells[name] then
      print("Warning:", name, "is already defined")
   end
   if attributes == nil then
      attributes = { }
   end
   for k, _ in pairs(attributes) do
      convertToIDs(attributes, k, "ID", "Debuff%d*", "Buff%d*")
   end
   if attributes.ID == nil then
      attributes.ID = c.GetID(spellName)
   end
   c.A.Spells[name] = attributes

   if attributes.Applies then
      for _, aura in pairs(attributes.Applies) do
         u.GetOrMakeTable(c.A.AurasToSpells, c.GetID(aura))[attributes.ID] =
            true
      end
   end

   local localizedName = s.SpellName(attributes.ID, true)
   if attributes.SpecialGCD then
      u.GetOrMakeTable(c.A, "SpecialGCDs")[localizedName]
         = attributes.SpecialGCD
   elseif attributes.NoGCD then
      u.GetOrMakeTable(c.A, "SpecialGCDs")[localizedName] = 0
   end

   if attributes.Tick then
      attributes.EarlyRefresh = attributes.Tick
      c.ManageDotRefresh(name, attributes.Tick, attributes.ID)
   end

   return attributes
end

function c.AddOptionalSpell(name, tag, attributes, color)
   local spell = c.AddSpell(name, tag, attributes)
   spell.Continue = true
   if color ~= nil then
      spell.FlashColor = color
   elseif spell.FlashColor == nil then
      spell.FlashColor = "yellow"
   end
   return spell
end

function c.AddInterrupt(name, tag, attributes)
   local spell = c.AddOptionalSpell(name, tag, attributes)
   spell.Interrupt = true
   spell.FlashColor = "aqua"
   return spell
end

function c.AddDispel(name, tag, type, attributes)
   local spell = c.AddOptionalSpell(name, tag, attributes)
   spell.Dispel = type
   spell.FlashColor = "aqua"
   return spell
end

function c.AddTaunt(name, tag, attributes)
   local spell = c.AddOptionalSpell(name, tag, attributes)
   spell.CheckFirst = function(z)
      local primaryTarget = s.GetPrimaryThreatTarget()
      if not primaryTarget or UnitIsUnit(primaryTarget, "player") then
         return false
      end

      if UnitGroupRolesAssigned(primaryTarget) == "TANK" then
         z.FlashSize = s.FlashSizePercent() / 2
         z.FlashColor = "yellow"
      else
         z.FlashSize = nil
         z.FlashColor = "red"
      end
      return true
   end
   return spell
end

function c.GetGroupMembers()
   local last = 0
   local max = max(1, GetNumGroupMembers())
   local type
   if IsInRaid() then
      type = "raid"
   else
      type = "party"
   end
   return function()
      last = last + 1
      if last < max then
         return type .. last
      elseif last == max and type ~= "raid" then
         return "player"
      end
   end
end

function c.GetHastedTime(unhastedTime)
   return unhastedTime / (1 + UnitSpellHaste("player") / 100)
end

local itemRanges = {
   [32321] = 10, -- Sparrowhawk Net
   [46722] = 15, -- Grol'dom Net
   [10645] = 20, -- Gnomish Death Ray
   [24268] = 25, -- Netherweave Net
   [835]   = 30, -- Large Rope Net
   [41509] = 35, -- Frostweave Net
   [28767] = 40, -- The Decapitator
   [32698] = 45, -- Wrangling Rope
--      [35278] = 80, -- Reinforced Net
--      [89163] = ?, -- Requisitioned Firework Launcher
}

-- pre-fetch whatever wow needs to cache for the items
for id, _ in pairs(itemRanges) do
   IsItemInRange(id)
end

function c.DistanceAtTheLeast()
   local target = s.UnitSelection()
   if UnitExists(target) then
      return 0
   end

   local max = 0
   for itemId, range in pairs(itemRanges) do
      if range > max and IsItemInRange(itemId, target) == false then
         max = range
      end
   end
   return max
end

function c.DistanceAtTheMost()
   local min = 1000
   local target = s.UnitSelection()

   if not UnitExists(target) then
      return min
   end

   for itemId, range in pairs(itemRanges) do
      if range < min and IsItemInRange(itemId, target) == true then
         min = range
      end
   end

   return min
end

function c.IdMatches(id, ...)
   for i = 1, select('#', ...) do
      if id == c.GetID(select(i, ...)) then
         return true
      end
   end
   return false
end

function c.IsMissingTotem(slot)
   return c.GetTotemDuration(slot) == 0
end

function c.GetTotemDuration(slot)
   local _, name, startTime, duration, _ = GetTotemInfo(slot)
   return max(0, startTime + duration - GetTime() - c.GetBusyTime()),
      name
end

function c.GetHealth(unit)
   unit = s.UnitSelection(unit)
   return min(
      UnitHealthMax(unit),
      UnitHealth(unit) + (UnitGetIncomingHeals(unit) or 0))
end

function c.GetHealthPercent(unit)
   unit = s.UnitSelection(unit)
   local max = UnitHealthMax(unit)
   if max == 0 then -- happens when unit is dead (at least sometimes)
      return 0
   else
      return 100 * c.GetHealth(unit) / max
   end
end

-- Uses data from http://us.battle.net/wow/en/forum/topic/13087818929#2
-- ItemScaling value by player level:
local itemScaling = {
   -- ten levels per line
     3,   3,   4,   4,   5,   6,   6,   7,   7,   8,
     8,   9,   9,  10,  10,  11,  11,  12,  12,  13,
    13,  14,  14,  15,  15,  16,  16,  17,  17,  18,
    18,  19,  19,  20,  20,  21,  21,  22,  22,  23,
    23,  24,  24,  25,  25,  26,  26,  27,  27,  28,
    28,  29,  29,  30,  30,  31,  31,  32,  32,  32,
    35,  37,  39,  39,  40,  40,  41,  44,  44,  44,
    44,  44,  45,  46,  49,  49,  50,  50,  51,  51,
    52,  52,  54,  56,  57,  60,  61,  62,  64,  67,
   101, 118, 139, 162, 190, 225, 234, 242, 252, 261}

local resolveBuffName = GetSpellInfo(158298)

-- percentage that resolve will increase healing, etc, effects
function c.GetResolve()
   -- Base resolve out of combat
   local stamina = UnitStat("player", 3)
   local resolve_base = stamina / 250.0 / (itemScaling[UnitLevel("Player")] or 1)
   local resolve_buff = select(17, UnitBuff("player", resolveBuffName)) or 0

   -- Resolve: http://us.battle.net/wow/en/forum/topic/13087818929#2
   return 1 + (resolve_buff / stamina / 60 * 0.25 + resolve_base)
end

-- percentage that versatility will boost healing or damage
function c.GetVersatility()
   local percent = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
      + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
   return 1 + (percent / 100)
end

function c.GetCritChance()
   return 1 + (GetCritChance() / 100)
end

function c.MakeMini(spell, condition)
   if condition ~= false then
      spell.FlashSize = s.FlashSizePercent() / 2
   else
      spell.FlashSize = nil
   end
end

function c.MakeOptional(spell, condition)
   if condition ~= false then
      spell.FlashColor = "yellow"
      spell.Continue = true
   else
      spell.FlashColor = nil
      spell.Continue = nil
   end
end

function c.MakePredictor(spell, condition, normalColor)
   c.MakeMini(spell, condition)
   if condition ~= false then
      spell.FlashColor = "green"
   else
      spell.FlashColor = normalColor
   end
end

function c.HasSpell(name)
   return s.HasSpell(c.GetID(name))
end
