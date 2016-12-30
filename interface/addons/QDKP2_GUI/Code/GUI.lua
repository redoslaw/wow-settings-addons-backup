-- Copyright 2012 Akhaan & HonestyHyj
-- This file is a part of QDKP_V2 (see about.txt in the Addon's root folder)

--          ## GUI FUNCTIONS ##


-------------------GUI Constants-------------------------------

QDKP2_FramesOpen = {}

------------------GUI DEFAULTS---------------------------------
QDKP2_dkpPerHour 	= 10
QDKP2_dkpIM 		= 10
QDKP2_dkpAwardRaid 	= 10
QDKP2_dkpMenuAward 	= 10

----------------------------------------TOGGLES------------------------
--Brings up popup GUI
function QDKP2_Toggle_Main(self) --showFrame is optional
  if not QDKP2_ACTIVE then
    QDKP2_Msg("Quick DKP is not fully initialized yet. Please wait 5 seconds and try again.","WARNING")
    return
  end
  if QDKP2_OfficerMode() then QDKP2GUI_Main:Toggle()
  else QDKP2GUI_Roster:Toggle()
  end
  
  --Added dump for debugging
  --[[
  local DKPval, dvalue, dflexval, dheroic
  for i,BossDKP in ipairs(QDKP2_Bosses) do
    local DKPboss=BossDKP.name or '-'
    DEFAULT_CHAT_FRAME:AddMessage("BossTable boss "..DKPboss.." i "..i) 
	if (DKPboss == "Garrosh Hellscream" or DKPboss == "Immerseus") then
		
	  dvalue = BossDKP["DKP_10"] or 99
	  dflexval = BossDKP["Normal"] or 95
	  dheroic = BossDKP["Heroic"] or 96
	  DEFAULT_CHAT_FRAME:AddMessage("DKP_10 "..dvalue.." Normal "..dflexval.." Heroic "..dheroic) 
	  for j, vals in pairs(BossDKP) do
	    vals = vals or "Nil"
	    DEFAULT_CHAT_FRAME:AddMessage("j "..j.." vals "..vals)
	  end
	end
  end
  
  for i,InstanceDKP in ipairs(QDKP2_Instances) do
    local DKPzone=InstanceDKP.name or '-'
	dvalue = InstanceDKP["DKP_10"] or 89
	dflexval = InstanceDKP["Normal"] or 85
	DEFAULT_CHAT_FRAME:AddMessage("Instance index "..i.." Name "..DKPzone.." DKP_10 "..dvalue.." flex "..dflexval)
  end
  local instDiff, DKPType = QDKP2_InstanceDiff() -- Check current instance
  DEFAULT_CHAT_FRAME:AddMessage("Current instance diff "..instDiff.." DKPType "..DKPType)
  --]]
  --End of dump
  
end


--toggles it so that it will hide windows past closed window, but shows them if that one is opened again
function QDKP2_SmartToggle(self, ...)
  local toggleFrame = ... ;
  if(QDKP2_FramesOpen[toggleFrame]) then
    QDKP2_FramesOpen[toggleFrame]=false
  else
    QDKP2_FramesOpen[toggleFrame]=true
  end

  for i=1, 5 do
    local incFrame = _G["QDKP2_Frame"..i]
    if(QDKP2_FramesOpen[i]) then
      if QDKP2_OfficerMode() or (i==2 or i==5) then
        incFrame:Show()
      end
    else
      incFrame:Hide()
    end
  end
end


--toggles target frame.. secondvar is optional
function QDKP2_Toggle( frameNum, showFrame)
  local incFrame = _G["QDKP2_Frame"..frameNum]
  if incFrame then 
    if showFrame==true then
      if QDKP2_OfficerMode() or (frameNum==2 or frameNum==5) then
        incFrame:Show()
        QDKP2_FramesOpen[frameNum] = true
      end
    elseif showFrame==false then
      incFrame:Hide();
      QDKP2_FramesOpen[frameNum] = false
    else
      if incFrame:IsVisible() then
        incFrame:Hide();
        QDKP2_FramesOpen[frameNum] = false
      else
        if QDKP2_OfficerMode() or (frameNum==2 or frameNum==5) then
	  incFrame:Show()
          QDKP2_FramesOpen[frameNum] = true
	end
      end
    end
  end
end

---------------------------------------

--Toglges all frames after index off, but only first on
function QDKP2_ToggleOffAfter(index)

  local temp = _G["QDKP2_Frame"..index]
  local isOn = false
  if(temp:IsVisible() ) then
    isOn = true
    local incFrame = _G["QDKP2_Frame"..index]
    incFrame:Hide();
  else
    local incFrame = _G["QDKP2_Frame"..index]
    if QDKP2_OfficerMode() or (index==2 or index==5) then incFrame:Show(); end
  end

  if index <= 1 and isOn then
    QDKP2GUI_Roster.SelectedPlayers={}
    QDKP2GUI_Log:Hide()
  end
  if index == 5 and isOn then
    QDKP2GUI_Log:Hide()
    QDKP2_Refresh_ModifyPane("hide")
  end
  for i=index, 4 do
    local incFrame = _G["QDKP2_Frame"..i]
    if(isOn == true ) then
      incFrame:Hide();
    end

  end
end

---------------------------------------

--Toggles all frames after index off/on
function QDKP2_ToggleAfter(index)
  local temp = _G["QDKP2_Frame"..index]
  local isOn = false
  if(temp:IsVisible() ) then
    isOn = true
    local incFrame = _G["QDKP2_Frame"..index]
    incFrame:Hide();
  else
    local incFrame = _G["QDKP2_Frame"..index]
    if QDKP2_OfficerMode() or (index==2 or index==5) then incFrame:Show(); end
  end
  if index <= 1 and isOn then
    QDKP2GUI_Roster.SelectedPlayers={}
    QDKP2GUI_Log:Hide()
  end
  if index == 5 and isOn then
    QDKP2GUI_Log:Hide()
  end
  for i=index, 4 do
    local incFrame = _G["QDKP2_Frame"..i]
    if(isOn == true ) then
      incFrame:Hide();
    else
      if QDKP2_OfficerMode() or (i==2 or i==5) then incFrame:Show(); end
    end
  end
end

---------------------------------------Frame Utility---------------

function QDKP2_RefreshAll()
  QDKP2GUI_Main:Refresh()
  QDKP2GUI_Roster:Refresh(true) --forces a resort
  QDKP2GUI_Log:Refresh()
  QDKP2GUI_Toolbox:Refresh()
  --QDKP2_Refresh_ModifyPane("refresh")
end

function QDKP2GUI_GetClickedEntry(self, class,suffix)
  local buttonName = self:GetName()
  suffix=suffix or ""
  local indexFromButton = 0
  for i=1, class.ENTRIES do
    local button = class.EntryName..tostring(i)..suffix
    if buttonName==button then
      indexFromButton = i
      break
    end
  end
  local EntryIndex= indexFromButton + class.Offset
  return class.List[EntryIndex],EntryIndex
end

function QDKP2GUI_IsDoubleClick(self,class)
  local double
  local itemName=self:GetName()
  if class.DoubleClick_Time and time()-class.DoubleClick_Time<0.2 and class.DoubleClick_Name==itemName then double=true; end
  class.DoubleClick_Time=time()
  class.DoubleClick_Name=itemName
  return double
end

function QDKP2GUI_CloseMenus()
  CloseDropDownMenus(1)
  QDKP2GUI_LogEntryMod:Hide()
end
