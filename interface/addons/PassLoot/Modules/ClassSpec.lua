local PassLoot = LibStub("AceAddon-3.0"):GetAddon("PassLoot");
local L = LibStub("AceLocale-3.0"):GetLocale("PassLoot_Modules");
local module = PassLoot:NewModule(L["Class Spec"]);
local BT = setmetatable({}, { __index = function(t, k)
	local _, spec = GetSpecializationInfoByID(k)
	t[k] = spec
	return spec
end })

function module:SetupValues()
  module.Choices = {
    {
      ["Name"] = L["Any"],
      ["Value"] = 1,
      ["Group"] = {},
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT,
      ["Value"] = 2,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[250], -- Blood
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[251], -- Frost
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[252], -- Unholy
          ["Value"] = 5,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER,
      ["Value"] = 13,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[577], -- Havoc
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[581], -- Vengeance
          ["Value"] = 4,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.DRUID,
      ["Value"] = 3,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[102], -- Balance
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[103], -- Feral Combat
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[105], -- Restoration
          ["Value"] = 5,
        },
        {
          ["Name"] = BT[104], -- Guardian
          ["Value"] = 10,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.HUNTER,
      ["Value"] = 4,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[253], -- Beast Mastery
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[254], -- Marksmanship
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[255], -- Survival
          ["Value"] = 5,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.MAGE,
      ["Value"] = 5,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[62], -- Arcane
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[63], -- Fire
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[64], -- Frost
          ["Value"] = 5,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.MONK,
      ["Value"] = 12,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[268], -- Brewmaster
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[269], -- Mistweaver
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[270], -- Windwalker
          ["Value"] = 5,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.PALADIN,
      ["Value"] = 6,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[65], -- Holy
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[66], -- Protection
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[70], -- Retribution
          ["Value"] = 5,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.PRIEST,
      ["Value"] = 7,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[256], -- Discipline
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[257], -- Holy
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[258], -- Shadow
          ["Value"] = 5,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.ROGUE,
      ["Value"] = 8,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[259], -- Assassination
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[260], -- Combat
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[261], -- Subtlety
          ["Value"] = 5,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.SHAMAN,
      ["Value"] = 9,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[262], -- Elemental
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[263], -- Enhancement
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[264], -- Restoration
          ["Value"] = 5,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.WARLOCK,
      ["Value"] = 10,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[265], -- Affliction
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[266], -- Demonology
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[267], -- Destruction
          ["Value"] = 5,
        },
      },
    },
    {
      ["Name"] = LOCALIZED_CLASS_NAMES_MALE.WARRIOR,
      ["Value"] = 11,
      ["Group"] = {
        {
          ["Name"] = L["Any"],
          ["Value"] = 1,
        },
        {
          ["Name"] = NONE,
          ["Value"] = 2,
        },
        {
          ["Name"] = BT[71], -- Arms
          ["Value"] = 3,
        },
        {
          ["Name"] = BT[72], -- Fury
          ["Value"] = 4,
        },
        {
          ["Name"] = BT[73], -- Protection
          ["Value"] = 5,
        },
      },
    },
  };
  for ClassIndex = #self.Choices, 1, -1 do
    if ( not self.Choices[ClassIndex] ) then
      table.remove(self.Choices, ClassIndex);
    else
      for GroupIndex = #self.Choices[ClassIndex].Group, 1, -1 do
        if ( not self.Choices[ClassIndex].Group[GroupIndex] ) then
          table.remove(self.Choices[ClassIndex].Group, GroupIndex);
        end
      end
    end
  end
end
module.ConfigOptions_RuleDefaults = {
  -- { VariableName, Default },
  {
    "ClassSpec",
    -- {
      -- [1] = { Class, Spec, Exception }
    -- },
  },
};
module.NewFilterValue_Class = 1;
module.NewFilterValue_Spec = 1;

function module:OnEnable()
  self:SetupValues();
  self:RegisterDefaultVariables(self.ConfigOptions_RuleDefaults);
  self:AddWidget(self.Widget);
  self:CheckDBVersion(2, "UpgradeDatabase");
end

function module:OnDisable()
  self:UnregisterDefaultVariables();
  self:RemoveWidgets();
end

function module:UpgradeDatabase(FromVersion, Rule)
  if ( FromVersion == 1 ) then
    local Table = {
      { "ClassSpec", nil },
    };
    if ( type(Rule.ClassSpec) == "table" ) then
      if ( #Rule.ClassSpec == 0 ) then
        return Table;
      end
    end
  end
  return;
end

function module:CreateWidget()
  local Widget = CreateFrame("Frame", "PassLoot_Frames_Widgets_ClassSpec", nil, "UIDropDownMenuTemplate");
  Widget:EnableMouse(true);
  Widget:SetHitRectInsets(15, 15, 0 ,0);
  _G[Widget:GetName().."Text"]:SetJustifyH("CENTER");
  UIDropDownMenu_SetWidth(Widget, 180);
  Widget:SetScript("OnEnter", function()
    local Spec = string.gsub(L["Current Spec: %spec%"], "%%spec%%", self:GetCurrentSpec())
    self:ShowTooltip(L["Class Spec"], L["Selected rule will only match items when you are this class and spec."], Spec)
  end);
  Widget:SetScript("OnLeave", function() GameTooltip:Hide() end);
  local Button = _G[Widget:GetName().."Button"];
  Button:SetScript("OnEnter", function()
    local Spec = string.gsub(L["Current Spec: %spec%"], "%%spec%%", self:GetCurrentSpec())
    self:ShowTooltip(L["Class Spec"], L["Selected rule will only match items when you are this class and spec."], Spec)
  end);
  Button:SetScript("OnLeave", function() GameTooltip:Hide() end);
  Widget.Title = Widget:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall");
  Widget.Title:SetParent(Widget);
  Widget.Title:SetPoint("BOTTOMLEFT", Widget, "TOPLEFT", 20, 0);
  Widget.Title:SetText(L["Class Spec"]);
  Widget:SetParent(nil);
  Widget:Hide();
  Widget.initialize = function(...) self:DropDown_Init(...) end;

  Widget.YPaddingTop = Widget.Title:GetHeight();
  Widget.Height = Widget:GetHeight() + Widget.YPaddingTop;
  Widget.XPaddingLeft = -15;
  Widget.XPaddingRight = -15;
  Widget.Width = Widget:GetWidth() + Widget.XPaddingLeft + Widget.XPaddingRight;
  Widget.PreferredPriority = 2;
  Widget.Info = {
    L["Class Spec"],
    L["Selected rule will only match items when you are this class and spec."],
  };
  return Widget;
end
module.Widget = module:CreateWidget();

-- Local function to get the data and make sure it's valid data
function module.Widget:GetData(RuleNum)
  local Data = module:GetConfigOption("ClassSpec", RuleNum);
  local Changed = false;
  if ( Data ) then
    if ( type(Data) == "table" and #Data > 0 ) then
      for Key, Value in ipairs(Data) do
        if ( type(Value) ~= "table" or type(Value[1]) ~= "number" or type(Value[2]) ~= "number" ) then
          Data[Key] = { module.NewFilterValue_Class, module.NewFilterValue_Spec, false };
          Changed = true;
        end
      end
    else
      Data = nil;
      Changed = true;
    end
  end
  if ( Changed ) then
    module:SetConfigOption("ClassSpec", Data);
  end
  return Data or {};
end

function module.Widget:GetNumFilters(RuleNum)
  local Value = self:GetData(RuleNum);
  return #Value;
end

function module.Widget:AddNewFilter()
  local Value = self:GetData();
  table.insert(Value, { module.NewFilterValue_Class, module.NewFilterValue_Spec, false });
  module:SetConfigOption("ClassSpec", Value);
end

function module.Widget:RemoveFilter(Index)
  local Value = self:GetData();
  table.remove(Value, Index);
  if ( #Value == 0 ) then
    Value = nil;
  end
  module:SetConfigOption("ClassSpec", Value);
end

function module.Widget:DisplayWidget(Index)
  if ( Index ) then
    module.FilterIndex = Index;
  end
  local Value = self:GetData();
  UIDropDownMenu_SetText(module.Widget, module:GetClassSpecText(Value[module.FilterIndex][1], Value[module.FilterIndex][2]));
end

function module.Widget:GetFilterText(Index)
  local Value = self:GetData();
  return module:GetClassSpecText(Value[Index][1], Value[Index][2]);
end

function module.Widget:IsException(RuleNum, Index)
  local Data = self:GetData(RuleNum);
  return Data[Index][3];
end

function module.Widget:SetException(RuleNum, Index, Value)
  local Data = self:GetData(RuleNum);
  Data[Index][3] = Value;
  module:SetConfigOption("ClassSpec", Data);
end

function module.Widget:SetMatch(ItemLink, Tooltip)
  local _, Class = UnitClass("player");
  Class = LOCALIZED_CLASS_NAMES_MALE[Class];
  local Spec = module:GetCurrentSpec();
  module.CurrentMatchClass = -1;
  module.CurrentMatchSpec = -1;
  for ClassKey, ClassValue in pairs(module.Choices) do
    if ( ClassValue.Name == Class ) then
      for SpecKey, SpecValue in pairs(ClassValue.Group) do
        if ( Spec == SpecValue.Name ) then
          module.CurrentMatchSpec = SpecValue.Value;
          break;
        end
      end
      module.CurrentMatchClass = ClassValue.Value;
      break;
    end
  end
  if ( module.CurrentMatchClass == -1 ) then
    module:Debug("Could not find Class: "..(Class or "nil"));
  else
    module:Debug("Class: "..(Class or "nil").." Found: ("..module.CurrentMatchClass..") ");
  end
  if ( module.CurrentMatchSpec == -1 ) then
    module:Debug("Could not find Spec: "..(TalentMatchA or "nil"));
  else
    module:Debug("Spec: "..(TalentMatchA or "nil").." Found: ("..module.CurrentMatchSpec..") ");
  end
end

function module.Widget:GetMatch(RuleNum, Index)
  local Value = self:GetData(RuleNum);
  local Class = Value[Index][1];
  local Spec = Value[Index][2];
  if ( Class > 1 ) then
    if ( Class ~= module.CurrentMatchClass ) then
      module:Debug("Class doesn't match");
      return false;
    end
  end
  if ( Spec > 1 ) then
    if ( Spec ~= module.CurrentMatchSpec ) then
      module:Debug("Spec doesn't match");
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
      info.value = {
        ["Key"] = Key,
        ["Class"] = Value.Value,
        ["Spec"] = 1,
      };
      info.notClickable = false;
      if ( #Value.Group > 0 ) then
        info.hasArrow = true;
      else
        info.hasArrow = false;
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
        ["Class"] = UIDROPDOWNMENU_MENU_VALUE.Class,
        ["Spec"] = Value.Value,
      };
      UIDropDownMenu_AddButton(info, Level);
    end
  end
end

function module:DropDown_OnClick(Frame)
  local Value = self.Widget:GetData();
  Value[self.FilterIndex][1] = Frame.value.Class;
  Value[self.FilterIndex][2] = Frame.value.Spec;
  self:SetConfigOption("ClassSpec", Value);
  UIDropDownMenu_SetText(Frame.owner, self:GetClassSpecText(Frame.value.Class, Frame.value.Spec));
  DropDownList1:Hide(); -- Nested dropdown buttons don't hide their parent menus on click.
end

function module:GetClassSpecText(Class, Spec)
  for ClassKey, ClassValue in ipairs(self.Choices) do
    if ( Class == ClassValue.Value ) then
      if ( #ClassValue.Group > 0 ) then
        for SpecKey, SpecValue in ipairs(ClassValue.Group) do
          if ( SpecValue.Value == Spec ) then
            local ReturnValue = string.gsub(L["%class% - %spec%"], "%%class%%", ClassValue.Name);
            ReturnValue = string.gsub(ReturnValue, "%%spec%%", SpecValue.Name);
            return ReturnValue;
          end
        end
      else
        return ClassValue.Name;
      end
    end
  end
  return "";
end

function module:GetCurrentSpec()
  local Spec = GetSpecialization();
  if spec and spec > 0 then
    local _, Name = GetSpecializationInfo(Spec);
    return Name;
  end
end
