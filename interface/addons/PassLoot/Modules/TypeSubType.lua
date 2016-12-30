local PassLoot = LibStub("AceAddon-3.0"):GetAddon("PassLoot");
local L = LibStub("AceLocale-3.0"):GetLocale("PassLoot_Modules");
local module = PassLoot:NewModule(L["Type / SubType"])

function module:SetupValues()
  -- XXX This _really_ should be auto-generated.
  module.ItemTypes = {
    {
      ["Name"] = L["Any"],
      ["Value"] = 1,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_WEAPON,
      ["Value"] = 2,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_AXE1H,
          ["Value"] = 2,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_AXE2H,
          ["Value"] = 3,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_BOWS,
          ["Value"] = 4,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_GUNS,
          ["Value"] = 5,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_MACE1H,
          ["Value"] = 6,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_MACE2H,
          ["Value"] = 7,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_POLEARM,
          ["Value"] = 8,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_SWORD1H,
          ["Value"] = 9,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_SWORD2H,
          ["Value"] = 10,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_STAFF,
          ["Value"] = 11,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_UNARMED,
          ["Value"] = 12,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_GENERIC,
          ["Value"] = 13,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_DAGGER,
          ["Value"] = 14,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_THROWN,
          ["Value"] = 15,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_CROSSBOW,
          ["Value"] = 16,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_WAND,
          ["Value"] = 17,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_FISHINGPOLE,
          ["Value"] = 18,
        },
        {
          ["Name"] = LE_ITEM_WEAPON_WARGLAIVE,
          ["Value"] = 19,
        },
        -- {
        --   ["Name"] = LE_ITEM_WEAPON_BEARCLAW,
        --   ["Value"] = 20,
        -- },
        -- {
        --   ["Name"] = LE_ITEM_WEAPON_CATCLAW,
        --   ["Value"] = 21,
        -- },
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_ARMOR,
      ["Value"] = 3,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = LE_ITEM_ARMOR_GENERIC,
          ["Value"] = 2,
        },
        {
          ["Name"] = LE_ITEM_ARMOR_CLOTH,
          ["Value"] = 3,
        },
        {
          ["Name"] = LE_ITEM_ARMOR_LEATHER,
          ["Value"] = 4,
        },
        {
          ["Name"] = LE_ITEM_ARMOR_MAIL,
          ["Value"] = 5,
        },
        {
          ["Name"] = LE_ITEM_ARMOR_PLATE,
          ["Value"] = 6,
        },
        {
          ["Name"] = LE_ITEM_ARMOR_SHIELD,
          ["Value"] = 7,
        },
        {
          ["Name"] = LE_ITEM_ARMOR_RELIC,
          ["Value"] = 12,
        },
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_CONTAINER, -- Bag
      ["Value"] = 4,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = 0, -- Bag
          ["Value"] = 2,
        },
        -- {
        --   ["Name"] = 1, -- Soul Bag
        --   ["Value"] = 3,
        -- }, -- Removed 4.0.3
        {
          ["Name"] = 2, -- Herb Bag
          ["Value"] = 4,
        },
        {
          ["Name"] = 3, -- Enchanting Bag
          ["Value"] = 5,
        },
        {
          ["Name"] = 4, -- Engineering Bag
          ["Value"] = 6,
        },
        {
          ["Name"] = 5, -- Gem Bag
          ["Value"] = 7,
        },
        {
          ["Name"] = 6, -- Mining Bag
          ["Value"] = 8,
        },
        {
          ["Name"] = 7, -- Leatherworking Bag
          ["Value"] = 9,
        },
        {
          ["Name"] = 8, -- Inscription Bag
          ["Value"] = 10,
        },  -- 3.0 added
        {
          ["Name"] = 9, -- Tackle Box
          ["Value"] = 11,
        },  -- 4.0.3 added
        {
          ["Name"] = 10, -- Cooking Bag
          ["Value"] = 12,
        },  -- 5.1.0 added
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_CONSUMABLE, -- Consumable
      ["Value"] = 5,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = 1, -- Potion
          ["Value"] = 3,
        },
        {
          ["Name"] = 2, -- Elixir
          ["Value"] = 4,
        },
        {
          ["Name"] = 3, -- Flask
          ["Value"] = 5,
        },
        -- {
        --   ["Name"] = 4, -- Scroll (OBSOLETE)
        --   ["Value"] = 8,
        -- },
        {
          ["Name"] = 5, -- Food & Drink
          ["Value"] = 3,
        },
        -- {
        --   ["Name"] = 6, -- Item Enhancement (OBSOLETE)
        --   ["Value"] = 7,
        -- },
        {
          ["Name"] = 7, -- Bandage
          ["Value"] = 6,
        },
        {
          ["Name"] = 8, -- Other
          ["Value"] = 9,
        },
        {
          ["Name"] = 9, -- Vantus Runes
          ["Value"] = 11,
        },  -- 7.0.3 added (or maybe 6.1.0 as Augment Runes?)
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_GLYPH, -- Glyph
      ["Value"] = 15,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        -- 7.0.3 removed
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Warrior"),
        --   ["Value"] = 2,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Paladin"),
        --   ["Value"] = 3,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Hunter"),
        --   ["Value"] = 4,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Rogue"),
        --   ["Value"] = 5,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Priest"),
        --   ["Value"] = 6,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Death Knight"),
        --   ["Value"] = 7,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Shaman"),
        --   ["Value"] = 8,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Mage"),
        --   ["Value"] = 9,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Warlock"),
        --   ["Value"] = 10,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Monk"),
        --   ["Value"] = 12,
        -- },
        -- {
        --   ["Name"] = GetItemSubClassInfo(LE_ITEM_CLASS_GLYPH, "Druid"),
        --   ["Value"] = 11,
        -- },
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_TRADEGOODS, -- Tradeskiull
      ["Value"] = 6,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = 1, -- Parts
          ["Value"] = 10,
        },
        -- {
        --   ["Name"] = 2, -- Explosives (OBSOLETE)
        --   ["Value"] = 12,
        -- },
        -- {
        --   ["Name"] = 3, -- Devices (OBSOLETE)
        --   ["Value"] = 11,
        -- },
        {
          ["Name"] = 4, -- Jewelcrafting
          ["Value"] = 9,
        },
        {
          ["Name"] = 5, -- Cloth
          ["Value"] = 3,
        },
        {
          ["Name"] = 6, -- Leather
          ["Value"] = 4,
        },
        {
          ["Name"] = 7, -- Metal & Stone
          ["Value"] = 5,
        },
        {
          ["Name"] = 8, -- Cooking
          ["Value"] = 6,
        },
        {
          ["Name"] = 9, -- Herb
          ["Value"] = 7,
        },
        {
          ["Name"] = 10, -- Elemental
          ["Value"] = 2,
        },
        {
          ["Name"] = 11, -- Other
          ["Value"] = 13,
        },
        {
          ["Name"] = 12, -- Enchanting
          ["Value"] = 8,
        },
        -- {
        --   ["Name"] = 13, -- Materials (OBSOLETE)
        --   ["Value"] = 15, -- 2.4.2 added
        -- },
        -- {
        --   ["Name"] = 14, -- Item Enchantment (OBSOLETE)
        --   ["Value"] = 18,
        -- },
        -- {
        --   ["Name"] = 15, -- Weapon Enchantment - Obsolete
        --   ["Value"] = nil,
        -- },
        {
          ["Name"] = 16, -- Inscription
          ["Value"] = 19,
        },
        -- {
        --   ["Name"] = 17, -- Explosives and Devices (OBSOLETE)
        --   ["Value"] = nil,
        -- },
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_RECIPE,
      ["Value"] = 9,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = 0, -- Book
          ["Value"] = 2,
        },
        {
          ["Name"] = 1, -- Leatherworking
          ["Value"] = 3,
        },
        {
          ["Name"] = 2, -- Tailoring
          ["Value"] = 4,
        },
        {
          ["Name"] = 3, -- Engineering
          ["Value"] = 5,
        },
        {
          ["Name"] = 4, -- Blacksmithing
          ["Value"] = 6,
        },
        {
          ["Name"] = 5, -- Cooking
          ["Value"] = 7,
        },
        {
          ["Name"] = 6, -- Alchemy
          ["Value"] = 8,
        },
        {
          ["Name"] = 7, -- First Aid
          ["Value"] = 9,
        },
        {
          ["Name"] = 8, -- Enchanting
          ["Value"] = 10,
        },
        {
          ["Name"] = 9, -- Fishing
          ["Value"] = 11,
        },
        {
          ["Name"] = 10, -- Jewelcrafting
          ["Value"] = 12,
        },
        {
          ["Name"] = 11, -- Inscription
          ["Value"] = 13,  -- Added 4.0.3 I think
        },
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_GEM,
      ["Value"] = 10,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"] or "Any",
          ["Value"] = 1,
        },
        -- 6.0.3 removed (maybe) Gems went from colors directly to stats
        -- {
        --   ["Name"] = "Red",
        --   ["Value"] = 2,
        -- },
        -- {
        --   ["Name"] = "Blue",
        --   ["Value"] = 3,
        -- },
        -- {
        --   ["Name"] = "Yellow",
        --   ["Value"] = 4,
        -- },
        -- {
        --   ["Name"] = "Purple",
        --   ["Value"] = 5,
        -- },
        -- {
        --   ["Name"] = "Green",
        --   ["Value"] = 6,
        -- },
        -- {
        --   ["Name"] = "Orange",
        --   ["Value"] = 7,
        -- },
        -- {
        --   ["Name"] = "Meta",
        --   ["Value"] = 8,
        -- },
        -- {
        --   ["Name"] = "Simple",
        --   ["Value"] = 9,
        -- },
        -- {
        --   ["Name"] = "Prismatic"),
        --   ["Value"] = 10,
        -- },
        -- {
        --   ["Name"] = "Hydraulic",
        --   ["Value"] = 11,
        -- },
        -- {
        --   ["Name"] = "Cogwheel",
        --   ["Value"] = 12,
        -- },
        {
          ["Name"] = 0, -- Intellect
          ["Value"] = 13,
        },
        {
          ["Name"] = 1, -- Agility
          ["Value"] = 14,
        },
        {
          ["Name"] = 2, -- Strength
          ["Value"] = 15,
        },
        {
          ["Name"] = 3, -- Stamina
          ["Value"] = 16,
        },
        {
          ["Name"] = 4, -- Spirit
          ["Value"] = 17,
        },
        {
          ["Name"] = 5, -- Critical Strike
          ["Value"] = 18,
        },
        {
          ["Name"] = 6, -- Mastery
          ["Value"] = 19,
        },
        {
          ["Name"] = 7, -- Haste
          ["Value"] = 20,
        },
        {
          ["Name"] = 8, -- Versatility
          ["Value"] = 21,
        },
        {
          ["Name"] = 9, -- Other
          ["Value"] = 22,
        },
        {
          ["Name"] = 10, -- Multiple Stats
          ["Value"] = 23,
        },
        {
          ["Name"] = 11, -- Artifact Relic
          ["Value"] = 24,
        },
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_MISCELLANEOUS,
      ["Value"] = 11,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = 0, -- Junk
          ["Value"] = 2,
        },
        {
          ["Name"] = 1, -- Reagent
          ["Value"] = 3,
        },
        {
          ["Name"] = 2, -- Companion Pets
          ["Value"] = 4,
        },
        {
          ["Name"] = 3, -- Holiday
          ["Value"] = 5,
        },
        {
          ["Name"] = 4, -- Other
          ["Value"] = 6,
        },
        {
          ["Name"] = 5, -- Mount
          ["Value"] = 7,
        },
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_KEY, -- Key
      ["Value"] = 12,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = 0, -- Key
          ["Value"] = 2,
        },
        {
          ["Name"] = 1, -- Lockpick
          ["Value"] = 3,
        },
      },
    },
    {
      ["Name"] = LE_ITEM_CLASS_QUESTITEM, -- Quest
      ["Value"] = 13,
      ["SubTypes"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = 0, -- Quest
          ["Value"] = 2,
        },
      },
    },
  };
  for TypeIndex = #module.ItemTypes, 1, -1 do
    if ( module.ItemTypes[TypeIndex] ) then
      for SubTypeIndex = #module.ItemTypes[TypeIndex].SubTypes, 1, -1 do
        if ( not module.ItemTypes[TypeIndex].SubTypes[SubTypeIndex] ) then
          ChatFrame1:AddMessage("Removing "..TypeIndex.." "..SubTypeIndex);
          table.remove(module.ItemTypes[TypeIndex].SubTypes, SubTypeIndex);
        end
      end
    else
      ChatFrame1:AddMessage("Removing "..TypeIndex);
      table.remove(module.ItemTypes, TypeIndex)
    end
  end
end
module.ConfigOptions_RuleDefaults = {
  -- { VariableName, Default },
  { "Type", nil }, -- No longer used
  { "SubType", nil }, -- No longer used
  {
    "TypeSubType",
    -- {
      -- [1] = { Type, SubType, Exception }
    -- },

  },
};
module.NewFilterValue_Type = 1;
module.NewFilterValue_SubType = 1;

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
      { "Type", nil },
      { "SubType", nil },
      { "TypeSubType", {} },
    };
    if ( Rule.Type and Rule.SubType ) then
      Table[3][2][1] = {
        Rule.Type,
        Rule.SubType,
        false
      };
    end
    return Table;
  end
  if ( FromVersion == 2 ) then
    local Table = {
      { "Type", nil },
      { "SubType", nil },
      { "TypeSubType", {} },
    };
    if ( type(Rule.TypeSubType) == "table" ) then
      for Key, Value in ipairs(Rule.TypeSubType) do
        Table[3][2][Key] = { Value[1], Value[2], false };
      end
    end
    return Table;
  end
  if ( FromVersion == 3 ) then
    local Table = {
      { "Type", nil },
      { "SubType", nil },
      { "TypeSubType", nil },
    };
    if ( type(Rule.TypeSubType) == "table" ) then
      if ( #Rule.TypeSubType == 0 ) then
        return Table;
      end
    end
  end
  return;
end

function module:CreateWidget()
  local Widget = CreateFrame("Frame", "PassLoot_Frames_Widgets_TypeSubType", nil, "UIDropDownMenuTemplate");
  Widget:EnableMouse(true);
  Widget:SetHitRectInsets(15, 15, 0 ,0);
  _G[Widget:GetName().."Text"]:SetJustifyH("CENTER");
  UIDropDownMenu_SetWidth(Widget, 220);
  Widget:SetScript("OnEnter", function() self:ShowTooltip(L["Type / SubType"], L["Selected rule will only match items with this type and subtype."]) end);
  Widget:SetScript("OnLeave", function() GameTooltip:Hide() end);
  local Button = _G[Widget:GetName().."Button"];
  Button:SetScript("OnEnter", function() self:ShowTooltip(L["Type / SubType"], L["Selected rule will only match items with this type and subtype."]) end);
  Button:SetScript("OnLeave", function() GameTooltip:Hide() end);
  local Title = Widget:CreateFontString(Widget:GetName().."Title", "BACKGROUND", "GameFontNormalSmall");
  Title:SetParent(Widget);
  Title:SetPoint("BOTTOMLEFT", Widget, "TOPLEFT", 20, 0);
  Title:SetText(L["Type / SubType"]);
  Widget:SetParent(nil);
  Widget:Hide();
  Widget.initialize = function(...) self:DropDown_Init(...) end;
  Widget.YPaddingTop = Title:GetHeight();
  Widget.Height = Widget:GetHeight() + Widget.YPaddingTop;
  Widget.XPaddingLeft = -15;
  Widget.XPaddingRight = -15;
  Widget.Width = Widget:GetWidth() + Widget.XPaddingLeft + Widget.XPaddingRight;
  Widget.PreferredPriority = 9;
  Widget.Info = {
    L["Type / SubType"],
    L["Selected rule will only match items with this type and subtype."],
  };
  return Widget;
end
module.Widget = module:CreateWidget();

-- Local function to get the data and make sure it's valid data
function module.Widget:GetData(RuleNum)
  local Data = module:GetConfigOption("TypeSubType", RuleNum);
  local Changed = false;
  if ( Data ) then
    if ( type(Data) == "table" and #Data > 0 ) then
      for Key, Value in ipairs(Data) do
        if ( type(Value) ~= "table" or type(Value[1]) ~= "number" or type(Value[2]) ~= "number" ) then
          Data[Key] = {
            module.NewFilterValue_Type,
            module.NewFilterValue_SubType,
            false
          };
          Changed = true;
        else  -- Check to make sure they are valid
          local FoundType, FoundSubType;
          for TypeKey, TypeValue in pairs(module.ItemTypes) do
            if ( TypeValue.Value == Data[Key][1] ) then
              FoundType = true;
              for SubTypeKey, SubTypeValue in pairs(TypeValue.SubTypes) do
                if ( SubTypeValue.Value == Data[Key][2] ) then
                  FoundSubType = true;
                  break;
                end
              end
              break;
            end
          end
          if ( not FoundType or not FoundSubType ) then
            Data[Key] = {
              module.NewFilterValue_Type,
              module.NewFilterValue_SubType,
              false
            };
            Changed = true;
          end
        end  -- If valid.
      end
    else
      Data = nil;
      Changed = true;
    end
  end
  if ( Changed ) then
    module:SetConfigOption("TypeSubType", Data);
  end
  return Data or {};
end

function module.Widget:GetNumFilters(RuleNum)
  local Value = self:GetData(RuleNum);
  return #Value;
end

function module.Widget:AddNewFilter()
  local Value = self:GetData();
  local NewTable = {
    module.NewFilterValue_Type,
    module.NewFilterValue_SubType,
    false
  };
  table.insert(Value, NewTable);
  module:SetConfigOption("TypeSubType", Value);
end

function module.Widget:RemoveFilter(Index)
  local Value = self:GetData();
  table.remove(Value, Index);
  if ( #Value == 0 ) then
    Value = nil;
  end
  module:SetConfigOption("TypeSubType", Value);
end

function module.Widget:DisplayWidget(Index)
  if ( Index ) then
    module.FilterIndex = Index;
  end
  local Value = self:GetData();
  local Value_Type = Value[module.FilterIndex][1];
  local Value_SubType = Value[module.FilterIndex][2];
  UIDropDownMenu_SetText(module.Widget, module:GetTypeSlotText(Value_Type, Value_SubType));
end

function module.Widget:GetFilterText(Index)
  local Value = self:GetData();
  local Value_Type = Value[Index][1];
  local Value_SubType = Value[Index][2];
  return module:GetTypeSlotText(Value_Type, Value_SubType);
end

function module.Widget:IsException(RuleNum, Index)
  local Data = self:GetData(RuleNum);
  return Data[Index][3];
end

function module.Widget:SetException(RuleNum, Index, Value)
  local Data = self:GetData(RuleNum);
  Data[Index][3] = Value;
  module:SetConfigOption("TypeSubType", Data);
end

function module.Widget:SetMatch(ItemLink, Tooltip)
  local _, _, _, _, _, ItemType, ItemSubType, _, _, _, _, ItemClassID, ItemSubClassID = GetItemInfo(ItemLink);
  module.CurrentTypeMatch = -1;
  module.CurrentSubTypeMatch = -1;
  for TypeKey, TypeValue in pairs(module.ItemTypes) do
    if ( ItemClassID == TypeValue.Name ) then
      for SubTypeKey, SubTypeValue in pairs(TypeValue.SubTypes) do
        if ( ItemSubClassID == SubTypeValue.Name ) then
          module.CurrentSubTypeMatch = SubTypeValue.Value;
          break;
        end
      end
      module.CurrentTypeMatch = TypeValue.Value
      break;
    end
  end
  if ( ItemType ) then
    module:Debug("Type: "..ItemType.." Found: ("..module.CurrentTypeMatch..") ");
    if ( module.CurrentTypeMatch == -1 ) then
      module:Debug("Could not find ItemType: "..ItemType);
    end
  end
  if ( ItemSubType ) then
    module:Debug("Sub Type: "..ItemSubType.." Found: ("..module.CurrentSubTypeMatch..") ");
    if ( module.CurrentSubTypeMatch == -1 ) then
      module:Debug("Could not find ItemSubType: "..ItemSubType);
    end
  end
end

function module.Widget:GetMatch(RuleNum, Index)
  local Value = self:GetData(RuleNum);
  local RuleType = Value[Index][1];
  local RuleSubType = Value[Index][2];
  if ( RuleType > 1 ) then
    if ( RuleType ~= module.CurrentTypeMatch ) then
      module:Debug("Type doesn't match");
      return false;
    end
  end
  if ( RuleSubType > 1 ) then
    if ( RuleSubType ~= module.CurrentSubTypeMatch ) then
      module:Debug("SubType doesn't match");
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
    for Key, Value in ipairs(self.ItemTypes) do
      info.text = type(Value.Name) == "number" and GetItemClassInfo(Value.Name) or Value.Name;
      info.hasArrow = true;
      info.notClickable = false;
      info.value = {
        ["Key"] = Key,
        ["Name"] = Value.Name,
        ["Type"] = Value.Value,
        ["SubType"] = 1,
      };
      UIDropDownMenu_AddButton(info, Level);
    end
  else
    for Key, Value in ipairs(self.ItemTypes[UIDROPDOWNMENU_MENU_VALUE.Key].SubTypes) do
      info.text = type(Value.Name) == "number" and GetItemSubClassInfo(UIDROPDOWNMENU_MENU_VALUE.Name, Value.Name) or Value.Name;
      info.hasArrow = false;
      info.notClickable = false;
      info.value = {
        ["Key"] = UIDROPDOWNMENU_MENU_VALUE.Key,
        ["Name"] = UIDROPDOWNMENU_MENU_VALUE.Name,
        ["Type"] = UIDROPDOWNMENU_MENU_VALUE.Type,
        ["SubType"] = Value.Value,
      };
      UIDropDownMenu_AddButton(info, Level);
    end
  end
end

function module:DropDown_OnClick(Frame)
  local Value = self.Widget:GetData();
  Value[self.FilterIndex][1] = Frame.value.Type;
  Value[self.FilterIndex][2] = Frame.value.SubType;
  self:SetConfigOption("TypeSubType", Value);
  UIDropDownMenu_SetText(Frame.owner, self:GetTypeSlotText(Frame.value.Type, Frame.value.SubType));
  DropDownList1:Hide(); -- Nested dropdown buttons don't hide their parent menus on click.
end

function module:GetTypeSlotText(TypeID, SubTypeID)
  for TypeKey, TypeValue in ipairs(self.ItemTypes) do
    if ( TypeValue.Value == TypeID ) then
      for SubTypeKey, SubTypeValue in ipairs(TypeValue.SubTypes) do
        if ( SubTypeValue.Value == SubTypeID ) then
          local itemType, itemSubType = TypeValue.Name, SubTypeValue.Name
          if type(itemType) == "number" then
            if type(itemSubType) == "number" then
              itemSubType = GetItemSubClassInfo(itemType, itemSubType)
            end
            itemType = GetItemClassInfo(itemType)
          end
          return L["%type% - %subtype%"]:gsub("%%type%%", itemType):gsub("%%subtype%%", itemSubType);
        end
      end
    end
  end
  return "";
end
