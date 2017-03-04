local GSE = GSE
local Statics = GSE.Static

local L = GSE.L

local GNOME = "Storage"

--- Delete a sequence starting with the macro and then the sequence from the library
function GSE.DeleteSequence(classid, sequenceName)
  GSE.DeleteMacroStub(sequenceName)
  GSELibrary[classid][sequenceName] = nil
end

function GSE.CloneSequence(sequence)
  local newsequence = {}

  for k,v in pairs(sequence) do
    newsequence[k] = v
  end

  newsequence.MacroVersions = {}
  for k,v in ipairs(sequence.MacroVersions) do
    newsequence.MacroVersions[tonumber(k)] = GSE.CloneMacroVersion(v)
  end

  return newsequence
end

--- This function clones the Macro Version part of a sequence.
function GSE.CloneMacroVersion(macroversion)
  local retseq = {}
  for k,v in ipairs(macroversion) do
    table.insert(retseq, v)
  end

  for k,v in pairs(macroversion) do
    retseq[k] = v
  end

  if not GSE.isEmpty(macroversion.PreMacro) then
    retseq.PreMacro = {}
    for k,v in ipairs(macroversion.PreMacro) do
      table.insert(retseq.PreMacro, v)
    end
  end

  if not GSE.isEmpty(macroversion.PostMacro) then
    retseq.PostMacro = {}
    for k,v in ipairs(macroversion.PostMacro)do
      table.insert(retseq.PostMacro, v)
    end
  end

  if not GSE.isEmpty(macroversion.KeyRelease) then
    retseq.KeyRelease = {}
    for k,v in ipairs(macroversion.KeyRelease) do
      table.insert(retseq.KeyRelease, v)
    end
  end

  if not GSE.isEmpty(macroversion.KeyPress) then
    retseq.KeyPress = {}
    for k,v in ipairs(macroversion.KeyPress) do
      table.insert(retseq.KeyPress, v)
    end
  end

  return retseq

end

--- Add a sequence to the library
function GSE.AddSequenceToCollection(sequenceName, sequence, classid)
  local vals = {}
  vals.action = "Save"
  vals.sequencename = sequenceName
  vals.sequence = sequence
  vals.classid = classid
  table.insert(GSE.OOCQueue, vals)
end
--- Add a sequence to the library
function GSE.OOCAddSequenceToCollection(sequenceName, sequence, classid)
  local confirmationtext = ""

  -- Remove Spaces or commas from SequenceNames and replace with _'s
  sequenceName = string.gsub(sequenceName, " ", "_")
  sequenceName = string.gsub(sequenceName, ",", "_")

  -- CHeck for colissions
  local found = false
  if GSE.isEmpty(classid) or classid == 0 then
    classid = tonumber(GSE.GetClassIDforSpec(sequence.SpecID))
  end
  if GSE.isEmpty(sequence.SpecID) then
    sequence.SpecID = GSE.GetCurrentClassID()
    classid = GSE.GetCurrentClassID()
  end
  if GSE.isEmpty(GSELibrary[classid]) then
    GSELibrary[classid] = {}
  end
  if not GSE.isEmpty(GSELibrary[classid][sequenceName]) then
      found = true
  end
  if found then
    -- check if source the same.  If so ignore
    for k,v in ipairs(sequence.MacroVersions) do
      for i, j in ipairs(GSELibrary[classid][sequenceName].MacroVersions) do
        if GSE.CompareSequence(v,j) then
          GSE.PrintDebugMessage("Macro Version already exists", "Storage")
        else
          GSE.Print (string.format(L["A new version of %s has been added."], sequenceName), GNOME)
          GSE.PrintDebugMessage("adding ".. k, "Storage")
          table.insert(GSELibrary[classid][sequenceName].MacroVersions, v)

          GSE.PrintDebugMessage("Finished colliding entry entry", "Storage")
        end
      end
    end
  else
    -- New Sequence
    if GSE.isEmpty(sequence.Author) then
      -- set to unknown author
      sequence.Author = "Unknown Author"
      confirmationtext = confirmationtext .. " " .. L["Sequence Author set to Unknown"] .. "."
    end
    if GSE.isEmpty(sequence.Talents) then
      -- set to currentSpecID
      sequence.Talents = "?,?,?,?,?,?,?"
      confirmationtext = confirmationtext .. " " .. L["No Help Information Available"] .. "."
    end

    GSELibrary[classid][sequenceName] = {}
    GSELibrary[classid][sequenceName] = sequence
  end
  if not GSE.isEmpty(confirmationtext) then
    GSE.Print(GSEOptions.EmphasisColour .. sequenceName .. "|r" .. L[" was imported with the following errors."] .. " " .. confirmationtext, GNOME)
  end
  if classid == GSE.GetCurrentClassID() or classid == 0 then
     GSE.UpdateSequence(sequenceName, sequence.MacroVersions[sequence.Default])
  end
end

--- Load a collection of Sequences
function GSE.ImportMacroCollection(Sequences)
  for k,v in pairs(Sequences) do
    GSE.AddSequenceToCollection(k, v)
  end
end


--- Return the Active Sequence Version for a Sequence.
function GSE.GetActiveSequenceVersion(sequenceName)
  local classid = GSE.GetCurrentClassID()
  if GSE.isEmpty(GSELibrary[GSE.GetCurrentClassID()][sequenceName]) then
    classid = 0
  end
  -- Set to default or 1 if no default
  local vers = 1
  if not GSE.isEmpty(GSELibrary[classid][sequenceName].Default) then
    vers = GSELibrary[classid][sequenceName].Default
  end
  if not GSE.isEmpty(GSELibrary[classid][sequenceName].PVP) and GSE.PVPFlag then
    vers = GSELibrary[classid][sequenceName].PVP
  elseif not GSE.isEmpty(GSELibrary[classid][sequenceName].Raid) and GSE.inRaid then
    vers = GSELibrary[classid][sequenceName].Raid
  elseif not GSE.isEmpty(GSELibrary[classid][sequenceName].Mythic) and GSE.inMythic then
    vers = GSELibrary[classid][sequenceName].Mythic
  end
  return vers
end


--- Add a macro for a sequence amd register it in the list of known sequences
function GSE.CreateMacroIcon(sequenceName, icon, forceglobalstub)
  local sequenceIndex = GetMacroIndexByName(sequenceName)
  local numAccountMacros, numCharacterMacros = GetNumMacros()
  if sequenceIndex > 0 then
    -- Sequence exists do nothing
    GSE.PrintDebugMessage("Moving on - macro for " .. sequenceName .. " already exists.", GNOME)
  else
    -- Create Sequence as a player sequence
    if numCharacterMacros >= MAX_CHARACTER_MACROS - 1 and not GSEOptions.overflowPersonalMacros and not forceglobalstub then
      GSE.Print(GSEOptions.AuthorColour .. L["Close to Maximum Personal Macros.|r  You can have a maximum of "].. MAX_CHARACTER_MACROS .. L[" macros per character.  You currently have "] .. GSEOptions.EmphasisColour .. numCharacterMacros .. L["|r.  As a result this macro was not created.  Please delete some macros and reenter "] .. GSEOptions.CommandColour .. L["/gs|r again."], GNOME)
    elseif numAccountMacros >= MAX_ACCOUNT_MACROS - 1 and GSEOptions.overflowPersonalMacros then
      GSE.Print(L["Close to Maximum Macros.|r  You can have a maximum of "].. MAX_CHARACTER_MACROS .. L[" macros per character.  You currently have "] .. GSEOptions.EmphasisColour .. numCharacterMacros .. L["|r.  You can also have a  maximum of "] .. MAX_ACCOUNT_MACROS .. L[" macros per Account.  You currently have "] .. GSEOptions.EmphasisColour .. numAccountMacros .. L["|r. As a result this macro was not created.  Please delete some macros and reenter "] .. GSEOptions.CommandColour .. L["/gs|r again."], GNOME)
    else
      sequenceid = CreateMacro(sequenceName, (GSEOptions.setDefaultIconQuestionMark and "INV_MISC_QUESTIONMARK" or icon), '#showtooltip\n/click ' .. sequenceName, (forceglobalstub and false or GSE.SetMacroLocation()) )
    end
  end
end

--- Load a GSE Sequence Collection from a String
function GSE.ImportSequence(importStr, legacy)
  local success, returnmessage = false, ""

  local functiondefinition =  GSE.FixQuotes(importStr) .. [===[
  return Sequences
  ]===]

  GSE.PrintDebugMessage (functiondefinition, "Storage")
  local fake_globals = setmetatable({
    Sequences = {},
    }, {__index = _G})
  local func, err = loadstring (functiondefinition, "Storage")
  if func then
    -- Make the compiled function see this table as its "globals"
    setfenv (func, fake_globals)

    local TempSequences = assert(func())
    if not GSE.isEmpty(TempSequences) then
      local newkey = ""
      for k,v in pairs(TempSequences) do
        if legacy then
          v = GSE.ConvertLegacySequence(v)
        end
        GSE.AddSequenceToCollection(k, v)
        if GSE.isEmpty(v.Icon) then
          -- Set a default icon
          v.Icon = GSE.GetDefaultIcon()
        end
        newkey = k
      end
      success = true
    end
  else
    GSE.Print (err, GNOME)
    returnmessage = err

  end
  return success, returnmessage
end

function GSE.ReloadSequences()
  GSE.PrintDebugMessage("Reloading Sequences")
  for name, sequence in pairs(GSELibrary[GSE.GetCurrentClassID()]) do
    GSE.UpdateSequence(name, sequence.MacroVersions[GSE.GetActiveSequenceVersion(name)])
  end
  if GSEOptions.CreateGlobalButtons then
    if not GSE.isEmpty(GSELibrary[0]) then
      for name, sequence in pairs(GSELibrary[0]) do
        GSE.UpdateSequence(name, sequence.MacroVersions[GSE.GetActiveSequenceVersion(name)])
      end
    end
  end
end

function GSE.PrepareLogout(deletenonlocalmacros)
  GSE.CleanMacroLibrary(deletenonlocalmacros)
  if GSEOptions.deleteOrphansOnLogout then
    GSE.CleanOrphanSequences()
  end
end

function GSE.IsLoopSequence(sequence)
  local loopcheck = false
  if not GSE.isEmpty(sequence.PreMacro) then
    loopcheck = true
  end
  if not GSE.isEmpty(sequence.PostMacro) then
    loopcheck = true
  end
  if not GSE.isEmpty(sequence.LoopLimit) then
    loopcheck = true
  end
  return loopcheck
end

--- Creates a string representation of the a Sequence that can be shared as a string.
--      Accepts a <code>sequence table</code> and a <code>SequenceName</code>
function GSE.ExportSequence(sequence, sequenceName)
  GSE.PrintDebugMessage("ExportSequence Sequence Name: " .. sequenceName, "Storage")
  local disabledseq = ""
  local sequencemeta = "  Talents = \"" .. GSEOptions.INDENT .. (GSE.isEmpty(sequence.Talents) and "?,?,?,?,?,?,?" or sequence.Talents) .. Statics.StringReset .. "\",\n"
  if not GSE.isEmpty(sequence.Helplink) then
    sequencemeta = sequencemeta .. "  Helplink = \"" .. GSEOptions.INDENT .. sequence.Helplink .. Statics.StringReset .. "\",\n"
  end
  if not GSE.isEmpty(sequence.Help) then
    sequencemeta = sequencemeta .. "  Help = \"" .. GSEOptions.INDENT .. sequence.Help .. Statics.StringReset .. "\",\n"
  end
  sequencemeta = sequencemeta .. "  Default=" ..sequence.Default .. ",\n"
  if not GSE.isEmpty(sequence.Raid) then
    sequencemeta = sequencemeta .. "  Raid=" ..sequence.Raid .. ",\n"
  end
  if not GSE.isEmpty(sequence.PVP) then
    sequencemeta = sequencemeta .. "  PVP=" ..sequence.PVP .. ",\n"
  end
  if not GSE.isEmpty(sequence.Mythic) then
    sequencemeta = sequencemeta .. "  Mythic=" ..sequence.Mythic .. ",\n"
  end
  local macroversions = "  MacroVersions = {\n"
  for k,v in pairs(sequence.MacroVersions) do
    local outputversion =  GSE.CleanMacroVersion(v)
    macroversions = macroversions .. "    [" .. k .. "] = {\n"

    local steps = "      StepFunction = " .. GSEOptions.INDENT .. "\"Sequential\"" .. Statics.StringReset .. ",\n" -- Set to this as the default if its blank.

    if not GSE.isEmpty(v.StepFunction) then
      if  v.StepFunction == Statics.PriorityImplementation then
        steps = "      StepFunction = " .. GSEOptions.INDENT .. "\"Priority\"" .. Statics.StringReset .. ",\n"
      elseif v.StepFunction == "Priority" then
       steps = "      StepFunction = " .. GSEOptions.INDENT .. "\"Priority\"" .. Statics.StringReset .. ",\n"
     else
       steps = "      StepFunction = [[" .. GSEOptions.INDENT .. v.StepFunction .. Statics.StringReset .. "]],\n"
      end
    end
    if not GSE.isEmpty(outputversion.Combat) then
      macroversions = macroversions .. "     Combat=" .. tostring(outputversion.Combat) .. ",\n"
    end
    if not GSE.isEmpty(outputversion.Trinket1) then
      macroversions = macroversions .. "      Trinket1=" .. tostring(outputversion.Trinket1) .. ",\n"
    end
    if not GSE.isEmpty(outputversion.Trinket2) then
      macroversions = macroversions .. "      Trinket2=" .. tostring(outputversion.Trinket2) .. ",\n"
    end
    if not GSE.isEmpty(outputversion.Head) then
      macroversions = macroversions .. "      Head=" .. tostring(outputversion.Head) .. ",\n"
    end
    if not GSE.isEmpty(outputversion.Neck) then
      macroversions = macroversions .. "      Neck=" .. tostring(outputversion.Neck) .. ",\n"
    end
    if not GSE.isEmpty(outputversion.Belt) then
      macroversions = macroversions .. "      Belt=" .. tostring(outputversion.Belt) .. ",\n"
    end
    if not GSE.isEmpty(outputversion.Ring1) then
      macroversions = macroversions .. "      Ring1=" .. tostring(outputversion.Ring1) .. ",\n"
    end
    if not GSE.isEmpty(outputversion.Ring2) then
      macroversions = macroversions .. "      Ring2=" .. tostring(outputversion.Ring2) .. ",\n"
    end

    macroversions = macroversions .. steps
    if not GSE.isEmpty(outputversion.LoopLimit) then
      macroversions = macroversions .. "      LoopLimit=" .. GSEOptions.EQUALS .. outputversion.LoopLimit .. Statics.StringReset .. ",\n"
    end
    if not GSE.isEmpty(outputversion.KeyPress) then
      macroversions = macroversions .. "      KeyPress={\n"
      for _,p in ipairs(outputversion.KeyPress) do
        local results = GSE.TranslateString(p, "enUS", "enUS", true)
        if not GSE.isEmpty(results)then
          macroversions = macroversions .. "        \"" .. results .."\",\n"
        end
      end
      macroversions = macroversions .. "      },\n"
    end
    if not GSE.isEmpty(outputversion.PreMacro) then
      macroversions = macroversions .. "      PreMacro={\n"
      for _,p in ipairs(outputversion.PreMacro) do
        local results = GSE.TranslateString(p, "enUS", "enUS", true)
        if not GSE.isEmpty(results)then
          macroversions = macroversions .. "        \"" .. results .."\",\n"
        end
      end
      macroversions = macroversions .. "      },\n"
    end
    for _,p in ipairs(v) do
      local results = GSE.TranslateString(p, "enUS", "enUS", true)
      if not GSE.isEmpty(results)then
        macroversions = macroversions .. "        \"" .. results .."\",\n"
      end
    end
    if not GSE.isEmpty(outputversion.PostMacro) then
      macroversions = macroversions .. "      PostMacro={\n"
      for _,p in ipairs(outputversion.PostMacro) do
        local results = GSE.TranslateString(p, "enUS", "enUS", true)
        if not GSE.isEmpty(results)then
          macroversions = macroversions .. "        \"" .. results .."\",\n"
        end
      end
      macroversions = macroversions .. "      },\n"
    end
    if not GSE.isEmpty(outputversion.KeyRelease) then
      macroversions = macroversions .. "      KeyRelease={\n"
      for _,p in ipairs(outputversion.KeyRelease) do
        local results = GSE.TranslateString(p, "enUS", "enUS", true)
        if not GSE.isEmpty(results)then
          macroversions = macroversions .. "        \"" .. results .."\",\n"
        end
      end
      macroversions = macroversions .. "      },\n"
    end
    macroversions = macroversions .. "    },\n"
  end
  macroversions = macroversions .. "  },\n"
  --local returnVal = ("Sequences['" .. sequenceName .. "'] = {\n" .."author=\"".. sequence.author .."\",\n" .."specID="..sequence.specID ..",\n" .. sequencemeta .. steps )
  local returnVal = "Sequences['" .. GSEOptions.EmphasisColour .. sequenceName .. Statics.StringReset .. "'] = {\n"
  returnVal = returnVal .. GSEOptions.CONCAT .. "-- " .. string.format(L["This Sequence was exported from GSE %s."], GSE.formatModVersion(GSE.VersionString)) .. Statics.StringReset .. "\n"
  returnVal = returnVal .. "  Author=\"" .. GSEOptions.AuthorColour .. (GSE.isEmpty(sequence.Author) and "Unknown Author" or sequence.Author) .. Statics.StringReset .. "\",\n" .. (GSE.isEmpty(sequence.SpecID) and "-- Unknown SpecID.  This could be a GS sequence and not a GS-E one.  Care will need to be taken. \n" or "  SpecID=" .. GSEOptions.NUMBER  .. sequence.SpecID .. Statics.StringReset ..",\n") ..  sequencemeta
  if not GSE.isEmpty(sequence.Icon) then
     returnVal = returnVal .. "  Icon=" .. GSEOptions.CONCAT .. (tonumber(sequence.Icon) and sequence.Icon or "'".. sequence.Icon .. "'") .. Statics.StringReset ..",\n"
  end
  returnVal = returnVal .. macroversions
  returnVal = returnVal .. "}\n"

  return returnVal
end

function GSE.FixSequence(sequence)
  if GSE.isEmpty(sequence.PreMacro) then
    sequence.PreMacro = {}
    GSE.PrintDebugMessage("Empty PreMacro", GNOME)
  end
  if GSE.isEmpty(sequence.PostMacro) then
    sequence.PostMacro = {}
    GSE.PrintDebugMessage("Empty PostMacro", GNOME)
  end
  if GSE.isEmpty(sequence.KeyPress) then
    sequence.KeyPress = {}
    GSE.PrintDebugMessage("Empty KeyPress", GNOME)
  end
  if GSE.isEmpty(sequence.KeyRelease) then
    sequence.KeyRelease = {}
    GSE.PrintDebugMessage("Empty KeyRelease", GNOME)
  end
  if GSE.isEmpty(sequence.StepFunction) then
    sequence.StepFunciton = Statics.Sequential
    GSE.PrintDebugMessage("Empty StepFunction", GNOME)
  end
  if not GSE.isEmpty(sequence.Target) then
    sequence.Target = nil
  end

end
--- This function removes any macro stubs that do not relate to a GSE macro
function GSE.CleanOrphanSequences()
  local maxmacros = MAX_ACCOUNT_MACROS + MAX_CHARACTER_MACROS + 2
  local todelete = {}
  for macid = 1, maxmacros do
    local found = false
    local mname, mtexture, mbody = GetMacroInfo(macid)
    if not GSE.isEmpty(mname) then
      if not GSE.isEmpty(GSELibrary[GSE.GetCurrentClassID()][mname]) then
        found = true
      end
      if not GSE.isEmpty(GSELibrary[0][mname]) then
        found = true
      end

      if not found then
        -- check if body is a gs one and delete the orphan
        todelete[mname] = true
      end
    end
  end
  for k,_ in pairs(todelete) do
    GSE.DeleteMacroStub(k)
  end
end

--- This function is used to clean the loacl sequence library
function GSE.CleanMacroLibrary(forcedelete)
  -- clean out the sequences database except for the current version
  if forcedelete then
    GSELibrary[GSE.GetCurrentClassID()] = nil
    GSELibrary[GSE.GetCurrentClassID()] = {}
  end
end

--- This function resets a button back to its initial setting
function GSE.ResetButtons()
  for k,v in pairs(GSE.UsedSequences) do
    button = _G[k]
    if button:GetAttribute("combatreset") == true then
      button:SetAttribute("step",1)
      GSE.UpdateIcon(button, true)
      GSE.UsedSequences[k] = nil
    end
  end
end

--- This functions schedules an update to a sequence in the OOCQueue.
function GSE.UpdateSequence(name, sequence)
  local vals = {}
  vals.action = "UpdateSequence"
  vals.name = name
  vals.macroversion = sequence
  table.insert(GSE.OOCQueue, vals)
end



--- This function updates the button for an existing sequence.  It is called from the OOC queue
function GSE.OOCUpdateSequence(name,sequence)
  sequence = GSE.CleanMacroVersion(sequence)
  GSE.FixSequence(sequence)
  tempseq = GSE.CloneMacroVersion(sequence)

  local existingbutton = true
  if GSE.isEmpty(_G[name]) then
    GSE.CreateButton(name,tempseq)
    existingbutton = false
  end
  local button = _G[name]
  -- only translate a sequence if the option to use the translator is on, there is a translator available and the sequence matches the current class
  if GetLocale() ~= "enUS" then
    tempseq = GSE.TranslateSequence(tempseq, name)
  end
  tempseq = GSE.UnEscapeSequence(tempseq)

  local executionseq = {}
  local pmcount = 0
  if not GSE.isEmpty(tempseq.PreMacro) then
    pmcount = table.getn(tempseq.PreMacro) + 1
    button:SetAttribute('loopstart', pmcount)
    for k,v in ipairs(tempseq.PreMacro) do
      table.insert(executionseq, v)
    end

  end

  for k,v in ipairs(tempseq) do
    table.insert(executionseq, v)
  end

  button:SetAttribute('loopstop', table.getn(executionseq))

  if not GSE.isEmpty(tempseq.PostMacro) then
    for k,v in ipairs(tempseq.PostMacro) do
      table.insert(executionseq, v)
    end

  end

  GSE.SequencesExec[name] = executionseq

  button:Execute('name, macros = self:GetName(), newtable([=======[' .. strjoin(']=======],[=======[', unpack(executionseq)) .. ']=======])')
  button:SetAttribute("step",1)
  button:SetAttribute('KeyPress',table.concat(GSE.PrepareKeyPress(tempseq), "\n") or '' .. '\n')
  GSE.PrintDebugMessage("GSUpdateSequence KeyPress updated to: " .. button:GetAttribute('KeyPress'))
  button:SetAttribute('KeyRelease',table.concat(GSE.PrepareKeyRelease(tempseq), "\n") or '' .. '\n')
  GSE.PrintDebugMessage("GSUpdateSequence KeyRelease updated to: " .. button:GetAttribute('KeyRelease'))
  if existingbutton then
    button:UnwrapScript(button,'OnClick')
  end

  if (GSE.isEmpty(sequence.Combat) and GSEOptions.resetOOC ) or sequence.Combat then
    button:SetAttribute("combatreset", true)
  else
    button:SetAttribute("combatreset", true)
  end
  button:WrapScript(button, 'OnClick', format(Statics.OnClick, GSE.PrepareStepFunction(sequence.StepFunction,  GSE.IsLoopSequence(sequence))))
  if not GSE.isEmpty(sequence.LoopLimit) then
    button:SetAttribute('looplimit', sequence.LoopLimit)
  end

end

function GSE.PrepareStepFunction(stepper, looper)
  retvalue = ""
  if looper then
    if GSE.isEmpty(stepper) or stepper == Statics.Sequential then
      retvalue = Statics.LoopSequentialImplementation
    else
      retvalue = Statics.LoopPriorityImplementation
    end
  else
    if GSE.isEmpty(stepper) or stepper == Statics.Sequential then
      retvalue = Statics.Sequential
    end
    if stepper == Statics.Priority then
      retvalue = Statics.PriorityImplementation
    elseif stepper == Statics.Sequential then
      retvalue = 'step = step % #macros + 1'
    else
      retvalue = stepper
    end
  end
  return retvalue
end

--- This funciton dumps what is currently running on an existing button.
function GSE.DebugDumpButton(SequenceName)
  local targetreset = ""
  local looper = GSE.IsLoopSequence(GSELibrary[GSE.GetCurrentClassID()][SequenceName].MacroVersions[GSE.GetActiveSequenceVersion(SequenceName)])
  if GSELibrary[GSE.GetCurrentClassID()][SequenceName].MacroVersions[GSE.GetActiveSequenceVersion(SequenceName)].Target then
    targetreset = Statics.TargetResetImplementation
  end
  GSE.Print("Button name: "  .. SequenceName)
  GSE.Print(_G[SequenceName]:GetScript('OnClick'))
  GSE.Print("KeyPress" .. _G[SequenceName]:GetAttribute('KeyPress'))
  GSE.Print("KeyRelease" .. _G[SequenceName]:GetAttribute('KeyRelease'))
  GSE.Print("LoopMacro?" .. tostring(looper))
  GSE.Print(format(Statics.OnClick, targetreset, GSE.PrepareStepFunction(GSELibrary[GSE.GetCurrentClassID()][SequenceName].MacroVersions[GSE.GetActiveSequenceVersion(SequenceName)].StepFunction, looper)))
end


--- Compares two sequences and return a boolean if the match.  If they do not
--    match then if will print an element by element comparison.  This comparison
--    ignores version, authorversion, source, helpTxt elements as these are not
--    needed for the execution of the macro but are more for help and versioning.
function GSE.CompareSequence(seq1,seq2)
  GSE.FixSequence(seq1)
  GSE.FixSequence(seq2)
  local match = true
  local steps1 = table.concat(seq1, "")
  local steps2 = table.concat(seq2, "")

  if seq1.SpecID == seq2.SpecID then
    GSE.PrintDebugMessage("Matching specID", GNOME)
  else
    GSE.PrintDebugMessage("Different specID", GNOME)
    match = false
  end
  if seq1.StepFunction == seq2.StepFunction then
    GSE.PrintDebugMessage("Matching StepFunction", GNOME)
  else
    GSE.PrintDebugMessage("Different StepFunction", GNOME)
    match = false
  end
  if table.concat(seq1.KeyPress, "") ==  table.concat(seq2.KeyPress, "") then
    GSE.PrintDebugMessage("Matching KeyPress", GNOME)
  else
    GSE.PrintDebugMessage("Different KeyPress", GNOME)
    match = false
  end
  if steps1 == steps2 then
    GSE.PrintDebugMessage("Same Sequence Steps", GNOME)
  else
    GSE.PrintDebugMessage("Different Sequence Steps", GNOME)
    match = false
  end
  if table.concat(seq1.KeyRelease) == table.concat(seq2.KeyRelease) then
    GSE.PrintDebugMessage("Matching KeyRelease", GNOME)
  else
    GSE.PrintDebugMessage("Different KeyRelease", GNOME)
    match = false
  end
  if table.concat(seq1.PreMacro) == table.concat(seq2.PreMacro) then
    GSE.PrintDebugMessage("Matching PreMacro", GNOME)
  else
    GSE.PrintDebugMessage("Different PreMacro", GNOME)
    match = false
  end
  if table.concat(seq1.PostMacro) == table.concat(seq2.PostMacro) then
    GSE.PrintDebugMessage("Matching PostMacro", GNOME)
  else
    GSE.PrintDebugMessage("Different PostMacro", GNOME)
    match = false
  end

  if not GSE.compareValues(seq1.Head, seq2.Head, "Head") then
    match = false
  end

  if not GSE.compareValues(seq1.Trinket1, seq2.Trinket1, "Trinket1") then
    match = false
  end

  if not GSE.compareValues(seq1.Trinket2, seq2.Trinket2, "Trinket2") then
    match = false
  end
  if not GSE.compareValues(seq1.Ring1, seq2.Ring1, "Ring1") then
    match = false
  end
  if not GSE.compareValues(seq1.Ring2, seq2.Ring2, "Ring2") then
    match = false
  end
  if not GSE.compareValues(seq1.Neck, seq2.Neck, "Neck") then
    match = false
  end
  if not GSE.compareValues(seq1.Belt, seq2.Belt, "Belt") then
    match = false
  end
  if not GSE.compareValues(seq1.LoopLimit, seq2.LoopLimit, "LoopLimit") then
    match = false
  end

  return match
end


--- Compares the values of a sequence used in GSE.CompareSequence
function GSE.compareValues(a, b, description)
  local match = true
  if not GSE.isEmpty(a) then
    if GSE.isEmpty(b) then
      GSE.PrintDebugMessage(description .." in Sequence 1 but not in Sequence 2", GNOME)
      match = false
    else
      if a == b then
        GSE.PrintDebugMessage("Matching " .. description, GNOME)
      else
        GSE.PrintDebugMessage("Different  ".. description .. " Values", GNOME)
        match = false
      end
    end
  else
    if not GSE.isEmpty(a) then
      GSE.PrintDebugMessage(description .. " in Sequence 2 but not in Sequence 1", GNOME)
      match = false
    end
  end
  return match
end


--- Return whether to store the macro in Personal Character Macros or Account Macros
function GSE.SetMacroLocation()
  local numAccountMacros, numCharacterMacros = GetNumMacros()
  local returnval = 1
  if numCharacterMacros >= MAX_CHARACTER_MACROS - 1 and GSEOptions.overflowPersonalMacros then
   returnval = nil
  end
  return returnval
end




--- Check if a macro has been created and if the create flag is true and the macro hasnt been created then create it.
function GSE.CheckMacroCreated(SequenceName, create)
  local found = false
  local classid = GSE.GetCurrentClassID()
  if GSE.isEmpty(GSELibrary[GSE.GetCurrentClassID()][SequenceName]) then
    classid = 0
  end
  local macroIndex = GetMacroIndexByName(SequenceName)
  if macroIndex and macroIndex ~= 0 then
    found = true
    EditMacro(macroIndex, nil, nil, '#showtooltip\n/click ' .. SequenceName)
  else
    if create then
      local icon = (GSE.isEmpty(GSELibrary[classid][SequenceName].Icon) and Statics.QuestionMark or GSELibrary[classid][SequenceName].Icon)
      GSE.CreateMacroIcon(SequenceName, icon)
      found = true
    end
  end
  return found
end

--- This removes a macro Stub.
function GSE.DeleteMacroStub(sequenceName)
  local mname, _, mbody = GetMacroInfo(sequenceName)
  if mname == sequenceName then
    trimmedmbody = mbody:gsub("[^%w ]", "")
    compar = '#showtooltip\n/click ' .. mname
    trimmedcompar = compar:gsub("[^%w ]", "")
    if string.lower(trimmedmbody) == string.lower(trimmedcompar) then
      GSE.Print(L[" Deleted Orphaned Macro "] .. mname, GNOME)
      DeleteMacro(sequenceName)
    end
  end
end


--- Not Used
function GSE.GetDefaultIcon()
  local currentSpec = GetSpecialization()
  local currentSpecID = currentSpec and select(1, GetSpecializationInfo(currentSpec)) or ""
  local _, _, _, defaulticon, _, _, _ = GetSpecializationInfoByID(currentSpecID)
  return strsub(defaulticon, 17)
end


--- This returns a list of Sequence Names for the current spec
function GSE.GetSequenceNames()
  local keyset={}
  for k,v in pairs(GSELibrary) do
    if GSEOptions.filterList[Statics.All] or k == GSE.GetCurrentClassID()  then
      for i,j in pairs(GSELibrary[k]) do
        keyset[k .. "," .. i] = i
      end
    else
      if k == 0 and GSEOptions.filterList[Statics.Global] then
        for i,j in pairs(GSELibrary[k]) do
          keyset[k .. "," .. i] = i
        end
      end
    end
  end

  return keyset
end


--- Return the Macro Icon for the specified Sequence
function GSE.GetMacroIcon(classid, sequenceIndex)
  classid = tonumber(classid)
  GSE.PrintDebugMessage("sequenceIndex: " .. (GSE.isEmpty(sequenceIndex) and "No value" or sequenceIndex), GNOME)
  classid = tonumber(classid)
  local macindex = GetMacroIndexByName(sequenceIndex)
  local a, iconid, c =  GetMacroInfo(macindex)
  if not GSE.isEmpty(a) then
    GSE.PrintDebugMessage("Macro Found " .. a .. " with iconid " .. (GSE.isEmpty(iconid) and "of no value" or iconid) .. " " .. (GSE.isEmpty(iconid) and L["with no body"] or c), GNOME)
  else
    GSE.PrintDebugMessage("No Macro Found. Possibly different spec for Sequence " .. sequenceIndex , GNOME)
    return GSEOptions.DefaultDisabledMacroIcon
  end

  local sequence = GSELibrary[classid][sequenceIndex]
  if GSE.isEmpty(sequence.Icon) and GSE.isEmpty(iconid) then
    GSE.PrintDebugMessage("SequenceSpecID: " .. sequence.SpecID, GNOME)
    if sequence.SpecID == 0 then
      return "INV_MISC_QUESTIONMARK"
    else
      local _, _, _, specicon, _, _, _ = GetSpecializationInfoByID((GSE.isEmpty(sequence.SpecID) and GSE.GetCurrentSpecID() or sequence.SpecID))
      GSE.PrintDebugMessage("No Sequence Icon setting to " .. strsub(specicon, 17), GNOME)
      return strsub(specicon, 17)
    end
  elseif GSE.isEmpty(iconid) and not GSE.isEmpty(sequence.Icon) then

      return sequence.Icon
  else
      return iconid
  end
end



--- This converts a legacy GS/GSE1 sequence to a new GSE2
function GSE.ConvertLegacySequence(sequence)
  local GSStaticPriority = Statics.PriorityImplementation
  local returnSequence = {}
  if not GSE.isEmpty(sequence.specID) then
    returnSequence.SpecID = sequence.specID
  end
  if not GSE.isEmpty(sequence.author) then
    returnSequence.Author = sequence.author
  end
  if not GSE.isEmpty(sequence.helpTxt) then
    returnSequence.Help = sequence.helpTxt
  end
  returnSequence.Default = 1
  returnSequence.MacroVersions = {}
  returnSequence.MacroVersions[1] = {}
  if not GSE.isEmpty(sequence.PreMacro) then
    returnSequence.MacroVersions[1].KeyPress = GSE.SplitMeIntolines(sequence.PreMacro)
  end
  if not GSE.isEmpty(sequence.PostMacro) then
    returnSequence.MacroVersions[1].KeyRelease = GSE.SplitMeIntolines(sequence.PostMacro)
  end
  if not GSE.isEmpty(sequence.StepFunction) then
    if sequence.StepFunction == GSStaticPriority then
      returnSequence.MacroVersions[1].StepFunction = Statics.Priority
    else
      GSE.Print(L["The Custom StepFunction Specified is not recognised and has been ignored."], GNOME)
      returnSequence.MacroVersions[1].StepFunction = Statics.Sequential
    end
  else
    returnSequence.MacroVersions[1].StepFunction = Statics.Sequential
  end
  if not GSE.isEmpty(sequence.icon) then
    returnSequence.Icon = sequence.icon
  end
  local macroversion = returnSequence.MacroVersions[1]
  local loopstart = tonumber(sequence.loopstart) or 1
  local loopstop = tonumber(sequence.loopstop) or table.getn(sequence)
  if loopstart > 1 then
    macroversion.PreMacro = {}
  end
  if loopstop < table.getn(sequence) then
    macroversion.PostMacro = {}
  end
  for k,v in ipairs(sequence) do
    if k < loopstart then
      table.insert(macroversion.PreMacro, v)
    elseif k > loopstop then
      table.insert(macroversion.PostMacro, v)
    else
      table.insert(macroversion, v)
    end
  end
  return returnSequence
end

--- Load in the sample macros for the current class.
function GSE.LoadSampleMacros(classID)
  GSE.ImportMacroCollection(Statics.SampleMacros[classID])
end


function GSE.CreateButton(name, sequence)
  local button = CreateFrame('Button', name, nil, 'SecureActionButtonTemplate,SecureHandlerBaseTemplate')
  button:SetAttribute('type', 'macro')
  button.UpdateIcon = GSE.UpdateIcon
end


function GSE.UpdateIcon(self, reset)
  local step = self:GetAttribute('step') or 1
  local button = self:GetName()
  local executionseq = GSE.SequencesExec[button]
  local commandline, foundSpell, notSpell = executionseq[step], false, ''
  for cmd, etc in gmatch(commandline or '', '/(%w+)%s+([^\n]+)') do
    if Statics.CastCmds[strlower(cmd)] or strlower(cmd) == "castsequence" then
      local spell, target = SecureCmdOptionParse(etc)
      if not reset then
        GSE.TraceSequence(button, step, spell)
      end
      if spell then
        if GetSpellInfo(spell) then
          SetMacroSpell(button, spell, target)
          foundSpell = true
          break
        elseif notSpell == '' then
          notSpell = spell
        end
      end
    end
  end
  if not foundSpell then SetMacroItem(button, notSpell) end
  if not reset then
    GSE.UsedSequences[button] = true
  end
end

function GSE.PrepareKeyPress(sequence)

  local tab = {}
  if GSEOptions.requireTarget then

    -- see #20 prevent target hopping
    table.insert(tab, "/stopmacro [@playertarget, noexists]")
  end

  if GSEOptions.hideSoundErrors then
    -- potentially change this to SetCVar("Sound_EnableSFX", 0)
    table.insert(tab,"/run sfx=GetCVar(\"Sound_EnableSFX\");")
    table.insert(tab, "/run ers=GetCVar(\"Sound_EnableErrorSpeech\");")
    table.insert(tab, "/console Sound_EnableSFX 0")
    table.insert(tab, "/console Sound_EnableErrorSpeech 0")
  end
  if not GSE.isEmpty(sequence.KeyPress) then
    for k,v in pairs(sequence.KeyPress) do
      table.insert(tab, v)
    end
  end

  return tab
end

function GSE.PrepareKeyRelease(sequence)
  local tab = {}
  if GSEOptions.requireTarget then
    -- see #20 prevent target hopping
    table.insert(tab, "/stopmacro [@playertarget, noexists]")
  end
  if not GSE.isEmpty(sequence.KeyRelease) then
    for k,v in pairs(sequence.KeyRelease) do
      table.insert(tab, v)
    end
  end
  if sequence.Ring1 or (sequence.Ring1 == nil and GSEOptions.use11) then
    table.insert(tab, "/use [combat] 11")
  end
  if sequence.Ring2 or (sequence.Ring2 == nil and GSEOptions.use12) then
    table.insert(tab, "/use [combat] 12")
  end
  if sequence.Trinket1 or (sequence.Trinket1 == nil and GSEOptions.use13) then
    table.insert(tab, "/use [combat] 13")
  end
  if sequence.Trinket2 or (sequence.Trinket2 == nil and GSEOptions.use14) then
    table.insert(tab, "/use [combat] 14")
  end
  if sequence.Neck or (sequence.Neck == nil and GSEOptions.use2) then
    table.insert(tab, "/use [combat] 2")
  end
  if sequence.Head or (sequence.Head == nil and GSEOptions.use1) then
    table.insert(tab, "/use [combat] 1")
  end
  if sequence.Belt or (sequence.Belt == nil and GSEOptions.use6) then
    table.insert(tab, "/use [combat] 6")
  end
  if GSEOptions.hideSoundErrors then
    -- potentially change this to SetCVar("Sound_EnableSFX", 1)
    table.insert(tab, "/run SetCVar(\"Sound_EnableSFX\",sfx);")
    table.insert(tab, "/run SetCVar(\"Sound_EnableErrorSpeech\",ers);")
  end
  if GSEOptions.hideUIErrors then
    table.insert(tab, "/script UIErrorsFrame:Hide();")
    -- potentially change this to UIErrorsFrame:Hide()
  end
  if GSEOptions.clearUIErrors then
    -- potentially change this to UIErrorsFrame:Clear()
    table.insert(tab, "/run UIErrorsFrame:Clear()")
  end
  return tab
end

--- Takes a collection of Sequences and returns a list of names
function GSE.GetSequenceNamesFromLibrary(library)
  local sequenceNames = {}
  for k,_ in pairs(library) do
    table.insert(sequenceNames, k)
  end
  return sequenceNames
end

--- Moves Macros hidden in Global Macros to their appropriate class.
function GSE.MoveMacroToClassFromGlobal()
  for k,v in pairs(GSELibrary[0]) do
    if not GSE.isEmpty(v.SpecID) and tonumber(v.SpecID) > 0 then
      if v.SpecID < 12 then
        GSELibrary[v.SpecID][k] = v
        GSE.Print(string.format(L["Moved %s to class %s."], k, Statics.SpecIDList[v.SpecID]))
        GSELibrary[0][k] = nil
      else
        GSELibrary[GSE.GetClassIDforSpec(v.SpecID)][k] = v
        GSE.Print(string.format(L["Moved %s to class %s."], k, Statics.SpecIDList[GSE.GetClassIDforSpec(v.SpecID)]))
        GSELibrary[0][k] = nil
      end
    end
  end
  GSE.ReloadSequences()
end
