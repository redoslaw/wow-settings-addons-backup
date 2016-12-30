local g = BittensGlobalTables
local s = SpellFlashAddon
local c = g.GetTable("BittensSpellFlashLibrary")
local u = g.GetTable("BittensUtilities")
local x = s.UpdatedVariables
if u.SkipOrUpgrade(c, "LDB", tonumber("20150310040701") or time()) then
   return
end

assert(LibStub, "LibStub is required")
assert(LibStub("LibDataBroker-1.1", true), "LibDataBroker-1.1 is required")

local format = string.format

local title = "Bitten's SpellFlash"
local minimap = LibStub("LibDBIcon-1.0")
local minimapSettings = nil

local lastHarmTargets = nil
local function updateLDB()
   -- lets avoid unnecessary string construction, shall we?
   if x.EstimatedHarmTargets ~= lastHarmTargets then
      c.LDB.text = format("AoE: %d", x.EstimatedHarmTargets)
      lastHarmTargets = x.EstimatedHarmTargets
   end
end

-- first time we do one-shot init, then we just point our code to the update
-- function forever onward, discarding the init code.
c.UpdateLDB = function()
   c.LDB = LibStub("LibDataBroker-1.1"):NewDataObject(title, {
      type = "data source",
      label = "BSF",
      text = "BSF",
      icon = "Interface/ICONS/INV_Elemental_Mote_Nether",
      OnClick = function()
         c.ShowDebugReport()
      end
   })

   minimapSettings = u.GetOrMakeTable(s.config.MODULE, c.A.AddonName, "libdbicon")
   minimap:Register(title, c.LDB, minimapSettings)
   c.UpdateMinimapIcon()

   c.UpdateLDB = updateLDB
   return updateLDB()
end

function c.UpdateMinimapIcon()
   if not c.A or not c.A.Options then
      return
   end

   if not minimapSettings then
      minimapSettings = u.GetOrMakeTable(s.config.MODULE, c.A.AddonName, "libdbicon")
   end

   if c.GetOption("MinimapIcon") then
      minimapSettings.hide = false
      minimap:Show(title)
   else
      minimapSettings.hide = true
      minimap:Hide(title)
   end
end
