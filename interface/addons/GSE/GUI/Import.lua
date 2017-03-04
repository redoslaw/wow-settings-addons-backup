local GSE = GSE

local AceGUI = LibStub("AceGUI-3.0")
local L = GSE.L
local libS = LibStub:GetLibrary("AceSerializer-3.0")
local libC = LibStub:GetLibrary("LibCompress")
local libCE = libC:GetAddonEncodeTable()

local importframe = AceGUI:Create("Frame")
importframe:Hide()


importframe:SetTitle(L["Gnome Sequencer: Import a Macro String."])
importframe:SetStatusText(L["Import Macro from Forums"])
importframe:SetCallback("OnClose", function(widget)  importframe:Hide(); GSE.GUIShowViewer() end)
importframe:SetLayout("List")

local importsequencebox = AceGUI:Create("MultiLineEditBox")
importsequencebox:SetLabel(L["Macro Collection to Import."])
importsequencebox:SetNumLines(20)
importsequencebox:DisableButton(true)
importsequencebox:SetFullWidth(true)
importframe:AddChild(importsequencebox)

local recButtonGroup = AceGUI:Create("SimpleGroup")
recButtonGroup:SetLayout("Flow")


local recbutton = AceGUI:Create("Button")
recbutton:SetText(L["Import"])
recbutton:SetWidth(150)
recbutton:SetCallback("OnClick", function() GSE.GUIImportSequence() end)
recButtonGroup:AddChild(recbutton)

importframe:AddChild(recButtonGroup)
GSE.GUIImportFrame = importframe

function GSE.GUIToggleImportDefault(switchstate)
  if switchstate == 1 then
      legacyradio:SetValue(true)
      defaultradio:SetValue(false)
    else
      legacyradio:SetValue(false)
      defaultradio:SetValue(true)
  end
end

function GSE.GUIImportSequence()
  local legacy = false

  if GSE.isEmpty(string.find(importsequencebox:GetText(), "MacroVersions")) then
    legacy = true
  end
  local success, message = GSE.ImportSequence(importsequencebox:GetText(), legacy)
  if success then
    StaticPopup_Show ("GSE-MacroImportSuccess")
    GSE.GUIImportFrame:Hide()
    local event = {}
    event.action = "openviewer"
    table.insert(GSE.OOCQueue, event)
  else
    StaticPopup_Show ("GSE-MacroImportFailure")
  end
end
