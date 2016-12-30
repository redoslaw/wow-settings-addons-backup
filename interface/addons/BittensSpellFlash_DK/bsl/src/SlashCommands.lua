local g = BittensGlobalTables
local c = g.GetTable("BittensSpellFlashLibrary")
local u = g.GetTable("BittensUtilities")
if u.SkipOrUpgrade(c, "SlashCommands", tonumber("20150310040701") or time()) then
   return
end

local GetCVar = GetCVar
local SetCVar = SetCVar
local print = print

local function regCommand(subCommand, func)
   u.RegisterSlashCommand("bsf", subCommand, func)
end

local function taggedPrint(tag, ...)
   print("|cFF00FFFF[" .. tag .. "]|r", ...)
end

function c.Print(...)
   taggedPrint("Lib", ...)
end

---------------------------------------------------------------------- AoE Mode

-- This variable is considered a public API.  Keep it working.
c.AoE = false

function c.ToggleAoE()
   c.Print("AoE Mode:", "AoE mode is now automatic, and cannot be toggled")
end

regCommand("aoe", c.ToggleAoE)

-------------------------------------------------------------- Debugging Output
c.ShouldPrint = {
   ["Debugging Info"] = false,
   ["Cast Event"] = false,
   ["Log Event"] = false,
   ["AoE"] = false,
}

function c.Debug(tag, ...)
   c.DebugRing:Push(tag, ...)
   if c.ShouldPrint["Debugging Info"] and c.ShouldPrint[tag] ~= false then
      taggedPrint(tag, ...)
   end
end

function c.ToggleDebugging(tag)
   if tag == nil or tag == "" then
      tag = "debugging info"
   else
      tag = strlower(tag)
   end

   for name, _ in pairs(c.ShouldPrint) do
      if tag == strlower(name) then
         c.ShouldPrint[name] = not c.ShouldPrint[name]
         c.Print("Print " .. name .. ":", c.ShouldPrint[name])
         break
      end
   end

end

function c.IsTagOn(tag)
   if tag == "Debugging Info" then
      return not not c.ShouldPrint[tag]
   else
      return c.ShouldPrint[tag] ~= false
   end
end

regCommand("debug", c.ToggleDebugging)
regCommand("report", c.ShowDebugReport)

---------------------------------------------------------- Floating Combat Text
function c.ToggleFloatingCombatText()
   if GetCVar("CombatDamage") == "0" then
      SetCVar("CombatDamage", 1)
      SetCVar("enableCombatText", 1)
      SHOW_COMBAT_TEXT = "1"
      c.Print("Floating Combat Text on")
   else
      SetCVar("CombatDamage", 0)
      SetCVar("enableCombatText", 0)
      SHOW_COMBAT_TEXT = "0"
      c.Print("Floating Combat Text off")
   end
   if (CombatText_UpdateDisplayedMessages) then
      CombatText_UpdateDisplayedMessages()
   end
end

regCommand("floatingcombattext", c.ToggleFloatingCombatText)
regCommand("fct", c.ToggleFloatingCombatText)

--------------------------------------------------------------- Bliz Highlights
function c.ToggleAlwaysShowBlizHighlights()
   c.AlwaysShowBlizHighlights = not c.AlwaysShowBlizHighlights
   c.Print("Use Blizzard Proc Animations:", c.AlwaysShowBlizHighlights)
end

regCommand("blizprocs", c.ToggleAlwaysShowBlizHighlights)

--------------------------------------------------------- Damage Mode in Groups

-- This function is considered a public API.  Keep it working.
function c.InDamageMode()
   return c.IsSolo()
      and c.GetHealthPercent("player") > 50
      or c.DamageModeInGroups
end

function c.ToggleDamageModeInGroups()
   c.DamageModeInGroups = not c.DamageModeInGroups
   c.Print("Damage Mode in Groups:", c.DamageModeInGroups)
end

regCommand("damage", c.ToggleDamageModeInGroups)
