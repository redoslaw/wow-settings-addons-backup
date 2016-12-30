local PassLoot = LibStub("AceAddon-3.0"):GetAddon("PassLoot");
local L = LibStub("AceLocale-3.0"):GetLocale("PassLoot_Modules");
local module = PassLoot:NewModule(L["Equip Slot"])

function module:SetupValues()
  module.Choices = {
    {
      ["Name"] = L["Any"],
      ["Type"] = {
        "",
      },
      ["Group"] = {},
      ["Value"] = 1,
    },
    {
      ["Name"] = L["None"],
      ["Type"] = {
        "",
      },
      ["Group"] = {},
      ["Value"] = 2,
    },
    {
      ["Name"] = L["Armor"],
      ["Type"] = {
        "",
      },
      ["Group"] = {
        {
          ["Name"] = INVTYPE_CHEST,
          ["Type"] = {
            "INVTYPE_CHEST",
            "INVTYPE_ROBE",
          },
          ["Value"] = 5,
        },
        {
          ["Name"] = INVTYPE_FEET,
          ["Type"] = {
            "INVTYPE_FEET",
          },
          ["Value"] = 6,
        },
        {
          ["Name"] = INVTYPE_HAND,
          ["Type"] = {
            "INVTYPE_HAND",
          },
          ["Value"] = 8,
        },
        {
          ["Name"] = INVTYPE_HEAD,
          ["Type"] = {
            "INVTYPE_HEAD",
          },
          ["Value"] = 9,
        },
        {
          ["Name"] = INVTYPE_LEGS,
          ["Type"] = {
            "INVTYPE_LEGS",
          },
          ["Value"] = 11,
        },
        {
          ["Name"] = INVTYPE_SHIELD, -- Off Hand
          ["Type"] = {
            "INVTYPE_SHIELD",
          },
          ["Value"] = 20,
        },
        {
          ["Name"] = INVTYPE_SHOULDER,
          ["Type"] = {
            "INVTYPE_SHOULDER",
          },
          ["Value"] = 22,
        },
        {
          ["Name"] = INVTYPE_WAIST,
          ["Type"] = {
            "INVTYPE_WAIST",
          },
          ["Value"] = 26,
        },
        {
          ["Name"] = INVTYPE_WRIST,
          ["Type"] = {
            "INVTYPE_WRIST",
          },
          ["Value"] = 27,
        },
      },
    },
    {
      ["Name"] = L["Weapons"],
      ["Type"] = {
        "",
      },
      ["Group"] = {
        {
          ["Name"] = INVTYPE_HOLDABLE,
          ["Type"] = {
            "INVTYPE_HOLDABLE",
          },
          ["Value"] = 10,
        },
        {
          ["Name"] = INVTYPE_WEAPONMAINHAND, -- Main Hand
          ["Type"] = {
            "INVTYPE_WEAPONMAINHAND",
          },
          ["Value"] = 12,
        },
        {
          ["Name"] = INVTYPE_WEAPONOFFHAND, -- Off Hand
          ["Type"] = {
            "INVTYPE_WEAPONOFFHAND",
          },
          ["Value"] = 14,
        },
        {
          ["Name"] = INVTYPE_WEAPON, -- One-Hand
          ["Type"] = {
            "INVTYPE_WEAPON",
          },
          ["Value"] = 15,
        },
        {
          ["Name"] = INVTYPE_RANGED, -- Ranged
          ["Type"] = {
            "INVTYPE_RANGED",
            "INVTYPE_RANGEDRIGHT",
            "INVTYPE_THROWN",
          },
          ["Value"] = 18,
        },
        {
          ["Name"] = INVTYPE_2HWEAPON, -- Two-Hand
          ["Type"] = {
            "INVTYPE_2HWEAPON",
          },
          ["Value"] = 25,
        },
      },
    },
    {
      ["Name"] = L["Accessories"],
      ["Type"] = {
        "",
      },
      ["Group"] = {
        {
          ["Name"] = INVTYPE_CLOAK,
          ["Type"] = {
            "INVTYPE_CLOAK",
          },
          ["Value"] = 3,
        },
        {
          ["Name"] = INVTYPE_BAG,
          ["Type"] = {
            "INVTYPE_BAG",
          },
          ["Value"] = 4,
        },
        {
          ["Name"] = INVTYPE_NECK,
          ["Type"] = {
            "INVTYPE_NECK",
          },
          ["Value"] = 13,
        },
        {
          ["Name"] = INVTYPE_AMMO,
          ["Type"] = {
            "INVTYPE_AMMO",
          },
          ["Value"] = 16,
        },
        {
          ["Name"] = INVTYPE_RELIC,
          ["Type"] = {
            "INVTYPE_RELIC",
          },
          ["Value"] = 19,
        },
        {
          ["Name"] = INVTYPE_FINGER,
          ["Type"] = {
            "INVTYPE_FINGER",
          },
          ["Value"] = 7,
        },
        {
          ["Name"] = INVTYPE_BODY,
          ["Type"] = {
            "INVTYPE_BODY",
          },
          ["Value"] = 21,
        },
        {
          ["Name"] = INVTYPE_TABARD,
          ["Type"] = {
            "INVTYPE_TABARD",
          },
          ["Value"] = 23,
        },
        {
          ["Name"] = INVTYPE_TRINKET,
          ["Type"] = {
            "INVTYPE_TRINKET",
          },
          ["Value"] = 24,
        },
      },
    },
  };
end

module.ConfigOptions_RuleDefaults = {
  -- { VariableName, Default },
  {
    "EquipSlot",
    -- {
      -- [1] = { Value, Exception }
    -- }
  },
};
module.NewFilterValue = 1;

function module:OnEnable()
  self:SetupValues();
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
      { "EquipSlot", {} }
    };
    if ( Rule.EquipSlot ) then
      Table[1][2][1] = { Rule.EquipSlot, false };
    end
    return Table;
  end
  if ( FromVersion == 2 ) then
    local Table = {
      { "EquipSlot", {} },
    };
    if ( type(Rule.EquipSlot) == "table" ) then
      for Key, Value in ipairs(Rule.EquipSlot) do
        Table[1][2][Key] = { Value, false };
      end
    end
    return Table;
  end
  if ( FromVersion == 3 ) then
    local Table = {
      { "EquipSlot", nil },
    };
    if ( type(Rule.EquipSlot) == "table" ) then
      if ( #Rule.EquipSlot == 0 ) then
        return Table;
      end
    end
  end
  return;
end

function module:CreateWidget()
  local Widget = CreateFrame("Frame", "PassLoot_Frames_Widgets_EquipSlot", nil, "UIDropDownMenuTemplate");
  Widget:EnableMouse(true);
  Widget:SetHitRectInsets(15, 15, 0 ,0);
  _G[Widget:GetName().."Text"]:SetJustifyH("CENTER");
  UIDropDownMenu_SetWidth(Widget, 140);
  Widget:SetScript("OnEnter", function() self:ShowTooltip(L["Equip Slot"], L["Selected rule will only match items with this equip slot."]) end);
  Widget:SetScript("OnLeave", function() GameTooltip:Hide() end);
  local Button = _G[Widget:GetName().."Button"];
  Button:SetScript("OnEnter", function() self:ShowTooltip(L["Equip Slot"], L["Selected rule will only match items with this equip slot."]) end);
  Button:SetScript("OnLeave", function() GameTooltip:Hide() end);
  local Title = Widget:CreateFontString(Widget:GetName().."Title", "BACKGROUND", "GameFontNormalSmall");
  Title:SetParent(Widget);
  Title:SetPoint("BOTTOMLEFT", Widget, "TOPLEFT", 20, 0);
  Title:SetText(L["Equip Slot"]);
  Widget:SetParent(nil);
  Widget:Hide();
  Widget.initialize = function(...) self:DropDown_Init(...) end;
  Widget.YPaddingTop = Title:GetHeight();
  Widget.Height = Widget:GetHeight() + Widget.YPaddingTop;
  Widget.XPaddingLeft = -15;
  Widget.XPaddingRight = -15;
  Widget.Width = Widget:GetWidth() + Widget.XPaddingLeft + Widget.XPaddingRight;
  Widget.PreferredPriority = 8;
  Widget.Info = {
    L["Equip Slot"],
    L["Selected rule will only match items with this equip slot."],
  };
  return Widget;
end
module.Widget = module:CreateWidget();

-- Local function to get the data and make sure it's valid data
function module.Widget:GetData(RuleNum)
  local Data = module:GetConfigOption("EquipSlot", RuleNum);
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
    module:SetConfigOption("EquipSlot", Data);
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
  module:SetConfigOption("EquipSlot", Value);
end

function module.Widget:RemoveFilter(Index)
  local Value = self:GetData();
  table.remove(Value, Index);
  if ( #Value == 0 ) then
    Value = nil;
  end
  module:SetConfigOption("EquipSlot", Value);
end

function module.Widget:DisplayWidget(Index)
  if ( Index ) then
    module.FilterIndex = Index;
  end
  local Value = self:GetData();
  UIDropDownMenu_SetText(module.Widget, module:GetEquipSlotText(Value[module.FilterIndex][1]));
end

function module.Widget:GetFilterText(Index)
  local Value = self:GetData();
  return module:GetEquipSlotText(Value[Index][1]);
end

function module.Widget:IsException(RuleNum, Index)
  local Data = self:GetData(RuleNum);
  return Data[Index][2];
end

function module.Widget:SetException(RuleNum, Index, Value)
  local Data = self:GetData(RuleNum);
  Data[Index][2] = Value;
  module:SetConfigOption("EquipSLot", Data);
end

function module.Widget:SetMatch(ItemLink, Tooltip)
  local _, _, _, _, _, _, _, _, EquipSlot, _ = GetItemInfo(ItemLink);
  module.CurrentMatch = module:FindEquipSlot(EquipSlot);
  if ( EquipSlot ) then
    module:Debug("Equip Loc: "..(EquipSlot or "nil").." Found: ("..module.CurrentMatch..") ");
    if ( module.CurrentMatch == -1 ) then
      module:Debug("Could not find EquipSlot: "..(EquipSlot or "nil"));
    end
  end
end

function module.Widget:GetMatch(RuleNum, Index)
  local RuleValue = self:GetData(RuleNum);
  if ( RuleValue[Index][1] > 1 ) then
    if ( RuleValue[Index][1] ~= module.CurrentMatch ) then
      return false;
    end
  end
  return true;
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
        info.notClickable = true;
        info.value = Key;
      else
        info.hasArrow = false;
        info.notClickable = false;
        info.value = Value.Value;
      end
      UIDropDownMenu_AddButton(info, Level);
    end
  else
    for Key, Value in ipairs(self.Choices[UIDROPDOWNMENU_MENU_VALUE].Group) do
      info.text = Value.Name;
      info.hasArrow = false;
      info.notClickable = false;
      info.value = Value.Value;
      UIDropDownMenu_AddButton(info, Level);
    end
  end
end

function module:DropDown_OnClick(Frame)
  local Value = self.Widget:GetData();
  Value[self.FilterIndex][1] = Frame.value;
  self:SetConfigOption("EquipSlot", Value);
  UIDropDownMenu_SetText(Frame.owner, Frame:GetText());
  DropDownList1:Hide(); -- Nested dropdown buttons don't hide their parent menus on click.
end

function module:GetEquipSlotText(EquipID)
  for Key, Value in ipairs(self.Choices) do
    if ( #Value.Group > 0 ) then
      for GroupKey, GroupValue in ipairs(Value.Group) do
        if ( GroupValue.Value == EquipID ) then
          return GroupValue.Name;
        end
      end
    else
      if ( Value.Value == EquipID ) then
        return Value.Name;
      end
    end
  end
  return "";
end

function module:FindEquipSlot(Slot)
  for Key, Value in pairs(self.Choices) do
    if ( #Value.Group > 0 ) then
      for GroupKey, GroupValue in pairs(Value.Group) do
        for TypeKey, TypeValue in pairs(GroupValue.Type) do
          if ( Slot == TypeValue ) then
            return GroupValue.Value;
          end
        end
      end
    else
      for TypeKey, TypeValue in pairs(Value.Type) do
        if ( Slot == TypeValue and Value.Value ~= 1 ) then  --Don't return type 1 (Any), can return 2 (None)
          return Value.Value;
        end
      end
    end
  end
  return -1;
end
