local PassLoot = LibStub("AceAddon-3.0"):GetAddon("PassLoot");
local L = LibStub("AceLocale-3.0"):GetLocale("PassLoot_Modules");
local module = PassLoot:NewModule(L["Zone Type"])

module.Choices = {
  {
    ["Name"] = L["Any"],
    ["Group"] = {},
    ["Value"] = 1,
  },
  {
    ["Name"] = L["Outside"],
    ["Group"] = {},
    ["Value"] = 2,
  },
  {
    ["Name"] = L["Group"],
    ["Group"] = {
      {
        ["Name"] = L["Any"],
        ["Value"] = 3,
      },
      {
        ["Name"] = L["Dungeon Finder"],
        ["Value"] = 19,
      },
      {
        ["Name"] = GetDifficultyInfo(24), -- Timewalking
        ["Value"] = 21,
      },
      {
        ["Name"] = L["Normal"],
        ["Value"] = 4,
      },
      {
        ["Name"] = L["Heroic"],
        ["Value"] = 5,
      },
      {
        ["Name"] = L["Challenge"],
        ["Value"] = 18,
      },
      {
        ["Name"] = L["Mythic"],
        ["Value"] = 20,
      },
    },
  },
  {
    ["Name"] = L["Raid"],
    ["Group"] = {
      {
        ["Name"] = L["Any"],
        ["Value"] = 13,
      },
      {
        ["Name"] = GetDifficultyInfo(17), -- Looking for Raid
        ["Value"] = 17,
      },
      {
        ["Name"] = L["Normal"],
        ["Value"] = 14,
      },
      {
        ["Name"] = L["Heroic"],
        ["Value"] = 14,
      },
      {
        ["Name"] = L["Mythic"],
        ["Value"] = 16,
      },
    },
  },
  {
    ["Name"] = L["Legacy Raid - 10 Man"],
    ["Group"] = {
      {
        ["Name"] = L["Any"],
        ["Value"] = 6,
      },
      {
        ["Name"] = L["Normal"],
        ["Value"] = 7,
      },
      {
        ["Name"] = L["Heroic"],
        ["Value"] = 9,
      },
    },
  },
  {
    ["Name"] = L["Legacy Raid - 25 Man"],
    ["Group"] = {
      {
        ["Name"] = L["Any"],
        ["Value"] = 10,
      },
      {
        ["Name"] = GetDifficultyInfo(7), -- Looking for Raid,
        ["Value"] = 12,
      },
      {
        ["Name"] = L["Normal"],
        ["Value"] = 8,
      },
      {
        ["Name"] = L["Heroic"],
        ["Value"] = 11,
      },
    },
  },
};
module.ConfigOptions_RuleDefaults = {
  -- { VariableName, Default },
  {
    "ZoneType",
    -- {
      -- [1] = { Value, Exception }
    -- },
  },
};
module.NewFilterValue = 1;

function module:OnEnable()
  self:RegisterDefaultVariables(self.ConfigOptions_RuleDefaults);
  self:AddWidget(self.Widget);
  self:CheckDBVersion(4, "UpgradeDatabase");
end

function module:OnDisable()
  self:UnregisterDefaultVariables();
  self:RemoveWidgets();
end

function module:UpgradeDatabase(FromVersion, Rule)
  if ( FromVersion == 1 ) then
    local Table = {
      { "ZoneType", {} },
    };
    if ( Rule.ZoneType ) then
      Table[1][2][1] = { Rule.ZoneType, false };
    end
    return Table;
  end
  if ( FromVersion == 2 ) then
    local Table = {
      { "ZoneType", {} },
    };
    if ( type(Rule.ZoneType) == "table" ) then
      for Key, Value in ipairs(Rule.ZoneType) do
        Table[1][2][Key] = { Value, false };
      end
    end
    return Table;
  end
  if ( FromVersion == 3 ) then
    local Table = {
      { "ZoneType", nil },
    };
    if ( type(Rule.ZoneType) == "table" ) then
      if ( #Rule.ZoneType == 0 ) then
        return Table;
      end
    end
  end
  return;
end

function module:CreateWidget()
  local Widget = CreateFrame("Frame", "PassLoot_Frames_Widgets_ZoneType", nil, "UIDropDownMenuTemplate");
  Widget:EnableMouse(true);
  Widget:SetHitRectInsets(15, 15, 0 ,0);
  _G[Widget:GetName().."Text"]:SetJustifyH("CENTER");
  UIDropDownMenu_SetWidth(Widget, 160);
  Widget:SetScript("OnEnter", function() self:ShowTooltip(L["Zone Type"], L["Selected rule will only match items when you are in this type of zone."]) end);
  Widget:SetScript("OnLeave", function() GameTooltip:Hide() end);
  local Button = _G[Widget:GetName().."Button"];
  Button:SetScript("OnEnter", function() self:ShowTooltip(L["Zone Type"], L["Selected rule will only match items when you are in this type of zone."]) end);
  Button:SetScript("OnLeave", function() GameTooltip:Hide() end);
  local Title = Widget:CreateFontString(Widget:GetName().."Title", "BACKGROUND", "GameFontNormalSmall");
  Title:SetParent(Widget);
  Title:SetPoint("BOTTOMLEFT", Widget, "TOPLEFT", 20, 0);
  Title:SetText(L["Zone Type"]);
  Widget:SetParent(nil);
  Widget:Hide();
  Widget.initialize = function(...) self:DropDown_Init(...) end;
  Widget.YPaddingTop = Title:GetHeight();
  Widget.Height = Widget:GetHeight() + Widget.YPaddingTop;
  Widget.XPaddingLeft = -15;
  Widget.XPaddingRight = -15;
  Widget.Width = Widget:GetWidth() + Widget.XPaddingLeft + Widget.XPaddingRight;
  Widget.PreferredPriority = 2;
  Widget.Info = {
    L["Zone Type"],
    L["Selected rule will only match items when you are in this type of zone."],
  };
  return Widget;
end
module.Widget = module:CreateWidget();

-- Local function to get the data and make sure it's valid data
function module.Widget:GetData(RuleNum)
  local Data = module:GetConfigOption("ZoneType", RuleNum);
  local Changed = false;
  if ( Data ) then
    if ( type(Data) == "table" and #Data > 0 ) then
      for Key, Value in ipairs(Data) do
        if ( type(Value) ~= "table" or type(Value[1]) ~= "number" ) then
          Data[Key] = { module.NewFilterValue, false };
          Changed = true;
        end
      end
    else
      Data = nil;
      Changed = true;
    end
  end
  if ( Changed ) then
    module:SetConfigOption("ZoneType", Data);
  end
  return Data or {};
end

function module.Widget:GetNumFilters(RuleNum)
  local Value = self:GetData(RuleNum);
  return #Value;
end

function module.Widget:AddNewFilter()
  local Value = self:GetData();
  table.insert(Value, { module.NewFilterValue, false });
  module:SetConfigOption("ZoneType", Value);
end

function module.Widget:RemoveFilter(Index)
  local Value = self:GetData();
  table.remove(Value, Index);
  if ( #Value == 0 ) then
    Value = nil;
  end
  module:SetConfigOption("ZoneType", Value);
end

function module.Widget:DisplayWidget(Index)
  if ( Index ) then
    module.FilterIndex = Index;
  end
  local Value = self:GetData();
  UIDropDownMenu_SetText(module.Widget, module:GetZoneTypeText(Value[module.FilterIndex][1]));
end

function module.Widget:GetFilterText(Index)
  local Value = self:GetData();
  return module:GetZoneTypeText(Value[Index][1]);
end

function module.Widget:IsException(RuleNum, Index)
  local Data = self:GetData(RuleNum);
  return Data[Index][2];
end

function module.Widget:SetException(RuleNum, Index, Value)
  local Data = self:GetData(RuleNum);
  Data[Index][2] = Value;
  module:SetConfigOption("ZoneType", Data);
end

function module.Widget:SetMatch(ItemLink, Tooltip)
end

module.Widget.LookupTable = {
  -- 1 = Any
  -- 2 = Outside
  -- 3 = Group - Any
  -- 4 = Group - Normal
  -- 5 = Group - Heroic
  -- 18 = Group - Challenge
  -- 19 = Group - Dungeon Finder
  -- 20 = Group - Mythic
  -- 21 = Group - Timewalking
  -- 6 = 10 Raid - Any
  -- 7 = 10 Raid - Normal
  -- 9 = 10 Raid - Heroic
  -- 10 = 25 Raid - Any
  -- 12 = 25 Raid - Raid Finder
  -- 8 = 25 Raid - Normal
  -- 11 = 25 Raid - Heroic
  -- 13 = Raid - Any
  -- 14 = Raid - Normal
  -- 15 = Raid - Heroic
  -- 16 = Raid - Mythic
  -- 17 = Raid - Raid Finder
  [1] = function(InstanceType, Difficulty) return true end,
  [2] = function(InstanceType, Difficulty) return InstanceType == "none" end,

  [3]  = function(InstanceType, Difficulty) return InstanceType == "party" end,
  [4]  = function(InstanceType, Difficulty) return Difficulty == 1 end,
  [5]  = function(InstanceType, Difficulty) return Difficulty == 2 end,
  [18] = function(InstanceType, Difficulty) return Difficulty == 8 end, -- Not used as of 7.0.3
  [19] = function(InstanceType, Difficulty, LFG) return InstanceType == "party" and LFG end,
  [20] = function(InstanceType, Difficulty) return Difficulty == 23 end,
  [21] = function(InstanceType, Difficulty) return Difficulty == 24 end,

  [6] = function(InstanceType, Difficulty) return Difficulty == 3 or Difficulty == 5 end,
  [7] = function(InstanceType, Difficulty) return Difficulty == 3 end,
  [9] = function(InstanceType, Difficulty) return Difficulty == 5 end,

  [10] = function(InstanceType, Difficulty) return Difficulty == 4 or Difficulty == 6 or Difficulty == 7 end,
  [8]  = function(InstanceType, Difficulty) return Difficulty == 4 end,
  [11] = function(InstanceType, Difficulty) return Difficulty == 6 end,
  [12] = function(InstanceType, Difficulty) return Difficulty == 7 end,

  [13] = function(InstanceType, Difficulty) return InstanceType == "raid" end,
  [14] = function(InstanceType, Difficulty) return Difficulty == 14 end,
  [15] = function(InstanceType, Difficulty) return Difficulty == 15 end,
  [16] = function(InstanceType, Difficulty) return Difficulty == 16 end,
  [17] = function(InstanceType, Difficulty) return Difficulty == 17 end,
};

function module.Widget:GetMatch(RuleNum, Index)
  local RuleValue = self:GetData(RuleNum);
  local _, InstanceType, Difficulty = GetInstanceInfo();
  local LFG = IsInGroup(LE_PARTY_CATEGORY_INSTANCE);
  if ( self.LookupTable[RuleValue[Index][1]](InstanceType, Difficulty, LFG) ) then
    return true;
  end
  module:Debug("ZoneType doesn't match");
  return false;
end

function module:DropDown_Init(Frame, Level)
  Level = Level or 1;
  local info = {};
  info.checked = false;
  info.notCheckable = true;
  info.func = function(...) self:DropDown_OnClick(...) end;
  info.owner = Frame;
  if ( Level == 1 ) then
    for Key, Value in ipairs(self.Choices) do
      info.text = Value.Name;
      if ( #Value.Group > 0 ) then
        info.hasArrow = true;
        info.notClickable = false;
        info.value = {
          ["Key"] = Key,
          ["Value"] = self.Choices[Key].Group[1].Value,
        };
      else
        info.hasArrow = false;
        info.notClickable = false;
        info.value = {
          ["Key"] = Key,
          ["Value"] = Value.Value,
        };
      end
      UIDropDownMenu_AddButton(info, Level);
    end
  else
    for Key, Value in ipairs(self.Choices[UIDROPDOWNMENU_MENU_VALUE.Key].Group) do
      info.text = Value.Name;
      info.hasArrow = false;
      info.notClickable = false;
      info.value = {
        ["Key"] = UIDROPDOWNMENU_MENU_VALUE.Key,
        ["Value"] = Value.Value,
      };
      UIDropDownMenu_AddButton(info, Level);
    end
  end
end

function module:DropDown_OnClick(Frame)
  local Value = self.Widget:GetData();
  Value[self.FilterIndex][1] = Frame.value.Value;
  self:SetConfigOption("ZoneType", Value);
  UIDropDownMenu_SetText(Frame.owner, self:GetZoneTypeText(Frame.value.Value));
  DropDownList1:Hide(); -- Nested dropdown buttons don't hide their parent menus on click.
end

function module:GetZoneTypeText(ZoneID)
  for Key, Value in ipairs(self.Choices) do
    if ( #Value.Group > 0 ) then
      for GroupKey, GroupValue in ipairs(Value.Group) do
        if ( GroupValue.Value == ZoneID ) then
          local ReturnValue = string.gsub(L["%zonetype% - %instancedifficulty%"], "%%zonetype%%", Value.Name);
          ReturnValue = string.gsub(ReturnValue, "%%instancedifficulty%%", GroupValue.Name);
          return ReturnValue;
        end
      end
    else
      if ( Value.Value == ZoneID ) then
        return Value.Name;
      end
    end
  end
  return "";
end
