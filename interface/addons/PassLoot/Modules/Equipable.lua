local PassLoot = LibStub("AceAddon-3.0"):GetAddon("PassLoot");
local L = LibStub("AceLocale-3.0"):GetLocale("PassLoot_Modules");
local module = PassLoot:NewModule(L["Equipable"])

module.Choices = {
  {
    ["Name"] = L["Any"],
    ["Value"] = 1,
  },
  {
    ["Name"] = NEVER,
    ["Value"] = 2,
  },
  {
    ["Name"] = L["Now"],
    ["Value"] = 3,
  },
  {
    ["Name"] = L["Later"],
    ["Value"] = 4,
  },
};
module.ConfigOptions_RuleDefaults = {
  -- { VariableName, Default },
  {
    "Equipable",
    -- {
      -- [1] = { Value, Exception }
    -- },
  },
};
module.NewFilterValue = 1;

-- A list of Type / SubTypes to check for.
-- nil entries will not be checked.
local TypeSubTypes = {
  [LE_ITEM_CLASS_WEAPON] = {
    [LE_ITEM_WEAPON_AXE1H] = true,
    [LE_ITEM_WEAPON_AXE2H] = true,
    [LE_ITEM_WEAPON_BOWS] = true,
    [LE_ITEM_WEAPON_GUNS] = true,
    [LE_ITEM_WEAPON_MACE1H] = true,
    [LE_ITEM_WEAPON_MACE2H] = true,
    [LE_ITEM_WEAPON_POLEARM] = true,
    [LE_ITEM_WEAPON_SWORD1H] = true,
    [LE_ITEM_WEAPON_SWORD2H] = true,
    [LE_ITEM_WEAPON_WARGLAIVE] = true,
    [LE_ITEM_WEAPON_STAFF] = true,
    [LE_ITEM_WEAPON_BEARCLAW] = true,
    [LE_ITEM_WEAPON_CATCLAW] = true,
    [LE_ITEM_WEAPON_UNARMED] = true,
    [LE_ITEM_WEAPON_GENERIC] = true,
    [LE_ITEM_WEAPON_DAGGER] = true,
    [LE_ITEM_WEAPON_THROWN] = true,
    [LE_ITEM_WEAPON_CROSSBOW] = true,
    [LE_ITEM_WEAPON_WAND] = true,
    -- [LE_ITEM_WEAPON_FISHINGPOLE] = true,
  },
  [LE_ITEM_CLASS_ARMOR] = {
    [LE_ITEM_ARMOR_GENERIC] = true,  -- Head, Neck, Shirt, Finger, Trinket, Held in Off Hand
    [LE_ITEM_ARMOR_CLOTH] = true,  -- Head, Shoulder, Chest, Waist, Legs, Feet, Wrist, Hands, Back
    [LE_ITEM_ARMOR_LEATHER] = true,  -- Head, Shoulder, Chest, Waist, Legs, Feet, Wrist, Hands
    [LE_ITEM_ARMOR_MAIL] = true,  -- Head, Shoulder, Chest, Waist, Legs, Feet, Wrist, Hands
    [LE_ITEM_ARMOR_PLATE] = true,  -- Head, Shoulder, Chest, Waist, Legs, Feet, Wrist, Hands
    -- [LE_ITEM_ARMOR_COSMETIC] = true,
    [LE_ITEM_ARMOR_SHIELD] = true,
    [LE_ITEM_ARMOR_LIBRAM] = true,
    [LE_ITEM_ARMOR_IDOL] = true,
    [LE_ITEM_ARMOR_TOTEM] = true,
    [LE_ITEM_ARMOR_SIGIL] = true,
    [LE_ITEM_ARMOR_RELIC] = true,
  },
  --[=[
  [BI["Container"]] = {
    [BI["Bag"]] = true,
    [BI["Soul Bag"]] = true,
    [BI["Herb Bag"]] = true,
    [BI["Enchanting Bag"]] = true,
    [BI["Engineering Bag"]] = true,
    [BI["Gem Bag"]] = true,
    [BI["Mining Bag"]] = true,
    [BI["Leatherworking Bag"]] = true,
    [BI["Inscription Bag"]] = true,
  },
  [BI["Consumable"]] = {
    [BI["Food & Drink"]] = true,
    [BI["Potion"]] = true,
    [BI["Elixir"]] = true,
    [BI["Flask"]] = true,
    [BI["Bandage"]] = true,
    [BI["Item Enhancement"]] = true,
    [BI["Scroll"]] = true,
    [BI["Other"]] = true,
    [BI["Consumable"]] = true,
  },
  [BI["Glyph"]] = {
    [BI["Warrior"]] = true,
    [BI["Paladin"]] = true,
    [BI["Hunter"]] = true,
    [BI["Rogue"]] = true,
    [BI["Priest"]] = true,
    [BI["Death Knight"]] = true,
    [BI["Shaman"]] = true,
    [BI["Mage"]] = true,
    [BI["Warlock"]] = true,
    [BI["Druid"]] = true,
  },
  [BI["Trade Goods"]] = {
    [BI["Elemental"]] = true,
    [BI["Cloth"]] = true,
    [BI["Leather"]] = true,
    [BI["Metal & Stone"]] = true,
    [BI["Meat"]] = true,
    [BI["Herb"]] = true,
    [BI["Enchanting"]] = true,
    [BI["Jewelcrafting"]] = true,
    [BI["Parts"]] = true,
    [BI["Devices"]] = true,
    [BI["Explosives"]] = true,
    [BI["Materials"]] = true,
    [BI["Other"]] = true,
    [BI["Armor Enchantment"]] = true,
    [BI["Weapon Enchantment"]] = true,
    [BI["Trade Goods"]] = true,
  },
  [BI["Projectile"]] = {
    [BI["Arrow"]] = true,
    [BI["Bullet"]] = true,
  },
  [BI["Quiver"]] = {
    [BI["Quiver"]] = true,
    [BI["Ammo Pouch"]] = true,
  },
  [BI["Reagent"]] = {
    [BI["Reagent"]] = true,
  },
  [BI["Recipe"]] = {
    [BI["Book"]] = true,
    [BI["Leatherworking"]] = true,
    [BI["Tailoring"]] = true,
    [BI["Engineering"]] = true,
    [BI["Blacksmithing"]] = true,
    [BI["Cooking"]] = true,
    [BI["Alchemy"]] = true,
    [BI["First Aid"]] = true,
    [BI["Enchanting"]] = true,
    [BI["Fishing"]] = true,
    [BI["Jewelcrafting"]] = true,
  },
  [BI["Gem"]] = {
    [BI["Red"]] = true,
    [BI["Blue"]] = true,
    [BI["Yellow"]] = true,
    [BI["Purple"]] = true,
    [BI["Green"]] = true,
    [BI["Orange"]] = true,
    [BI["Meta"]] = true,
    [BI["Simple"]] = true,
    [BI["Prismatic"]] = true,
  },
  [BI["Miscellaneous"]] = {
    [BI["Junk"]] = true,
    [BI["Reagent"]] = true,
    [BI["Pet"]] = true,
    [BI["Holiday"]] = true,
    [BI["Mount"]] = true,
    [BI["Other"]] = true,
  },
  [BI["Key"]] = {
    [BI["Key"]] = true,
  },
  [BI["Quest"]] = {
    [BI["Quest"]] = true,
  },
  ]=]
};
-- Same thing for Equip Slots - Will not check nil entries
local EquipSlots = {
  ["INVTYPE_AMMO"] = true,  -- Ammo
  ["INVTYPE_HEAD"] = true,  -- Head
  ["INVTYPE_NECK"] = true,  -- Neck
  ["INVTYPE_SHOULDER"] = true,  -- Shoulder
  ["INVTYPE_BODY"] = true,  -- Shirt
  ["INVTYPE_CHEST"] = true,  -- Chest
  ["INVTYPE_ROBE"] = true,  -- Chest
  ["INVTYPE_WAIST"] = true,  -- Waist
  ["INVTYPE_LEGS"] = true,  -- Legs
  ["INVTYPE_FEET"] = true,  -- Feet
  ["INVTYPE_WRIST"] = true,  -- Wrist
  ["INVTYPE_HAND"] = true,  -- Hands
  ["INVTYPE_FINGER"] = true,  -- Fingers
  ["INVTYPE_TRINKET"] = true,  -- Trinkets
  ["INVTYPE_CLOAK"] = true,  -- Cloaks
  ["INVTYPE_WEAPON"] = true,  -- One-Hand
  ["INVTYPE_SHIELD"] = true,  -- Shield
  ["INVTYPE_2HWEAPON"] = true,  -- Two-Handed
  ["INVTYPE_WEAPONMAINHAND"] = true,  -- Main-Hand Weapon
  ["INVTYPE_WEAPONOFFHAND"] = true, -- Off-Hand Weapon
  ["INVTYPE_HOLDABLE"] = true,  -- Held In Off-Hand
  ["INVTYPE_RANGED"] = true,  -- Bows
  ["INVTYPE_THROWN"] = true,  -- Ranged
  ["INVTYPE_RANGEDRIGHT"] = true,  -- Wands, Guns, and Crossbows
  ["INVTYPE_RELIC"] = true,
  -- ["INVTYPE_TABARD"] = true,
  -- ["INVTYPE_BAG"] = true,  -- Containers
  -- ["INVTYPE_QUIVER"] = true,
};
module.Wearable = {  -- Type, SubType, EquipSlot (nil matches all)
  ["DEATHKNIGHT"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH, "INVTYPE_CLOAK" },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_PLATE },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_POLEARM },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_SIGIL },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_RELIC },
  },
  ["DEMONHUNTER"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH, "INVTYPE_CLOAK" },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_LEATHER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_WARGLAIVE },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_DAGGER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_UNARMED },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD1H },
  },
  ["DRUID"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH, "INVTYPE_CLOAK" },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_LEATHER },
    { LE_ITEM_CLASS_WEAPON, nil, "INVTYPE_HOLDABLE" },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_DAGGER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_BEARCLAW },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_CATCLAW },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_STAFF },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_POLEARM },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_IDOL },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_RELIC },
  },
  ["MAGE"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH },
    { LE_ITEM_CLASS_WEAPON, nil, "INVTYPE_HOLDABLE" },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_DAGGER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_STAFF },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_WAND },
  },
  ["MONK"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH, "INVTYPE_CLOAK" },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_LEATHER },
    { LE_ITEM_CLASS_WEAPON, nil, "INVTYPE_HOLDABLE" },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_UNARMED },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_STAFF },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_POLEARM },
  },
  ["PALADIN"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH, "INVTYPE_CLOAK" },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_PLATE },
    { LE_ITEM_CLASS_WEAPON, nil, "INVTYPE_HOLDABLE" },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_POLEARM },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_SHIELD },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_LIBRAM },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_RELIC },
  },
  ["PRIEST"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH },
    { LE_ITEM_CLASS_WEAPON, nil, "INVTYPE_HOLDABLE" },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_DAGGER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_STAFF },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_WAND },
  },
  ["ROGUE"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH, "INVTYPE_CLOAK" },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_LEATHER },
    { LE_ITEM_CLASS_WEAPON, nil, "INVTYPE_HOLDABLE" },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_DAGGER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_UNARMED },
  },
  ["HUNTER"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH, "INVTYPE_CLOAK" },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_MAIL },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_DAGGER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_STAFF },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_POLEARM },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_UNARMED },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_BOWS },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_GUNS },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_CROSSBOW },
  },
  ["SHAMAN"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH, "INVTYPE_CLOAK" },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_MAIL },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_DAGGER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_STAFF },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_UNARMED },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE2H },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_SHIELD },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_TOTEM },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_RELIC },
  },
  ["WARLOCK"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_DAGGER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_STAFF },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_WAND },
  },
  ["WARRIOR"] = {
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_GENERIC },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH, "INVTYPE_CLOAK" },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_PLATE },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_DAGGER },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_STAFF },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_POLEARM },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD1H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_UNARMED },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_MACE2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_AXE2H },
    { LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_SWORD2H },
    { LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_SHIELD },
  },
};

function module:OnEnable()
  self:RegisterDefaultVariables(self.ConfigOptions_RuleDefaults);
  self:AddWidget(self.Widget);
  self:CheckDBVersion(2, "UpgradeDatabase");
  local _, Class = UnitClass("player");
  self.ClassTable = self.Wearable[Class];
  if ( not self.ClassTable ) then
    self:Debug("Unable to figure out what class we are.");
    self:Disable();
  end
end

function module:OnDisable()
  self:UnregisterDefaultVariables();
  self:RemoveWidgets();
end

function module:UpgradeDatabase(FromVersion, Rule)
  if ( FromVersion == 1 ) then
    local Table = {
      { "Equipable", nil },
    };
    if ( type(Rule.Equipable) == "table" ) then
      if ( #Rule.Equipable == 0 ) then
        return Table;
      end
    end
  end
  return;
end

function module:CreateWidget()
  local Widget = CreateFrame("Frame", "PassLoot_Frames_Widgets_Equipable", nil, "UIDropDownMenuTemplate");
  Widget:EnableMouse(true);
  Widget:SetHitRectInsets(15, 15, 0 ,0);
  _G[Widget:GetName().."Text"]:SetJustifyH("CENTER");
  UIDropDownMenu_SetWidth(Widget, 120);
  Widget:SetScript("OnEnter", function() self:ShowTooltip(L["Equipable"], L["Selected rule will only match items that are equipable."]) end);
  Widget:SetScript("OnLeave", function() GameTooltip:Hide() end);
  local Button = _G[Widget:GetName().."Button"];
  Button:SetScript("OnEnter", function() self:ShowTooltip(L["Equipable"], L["Selected rule will only match items that are equipable."]) end);
  Button:SetScript("OnLeave", function() GameTooltip:Hide() end);
  local Title = Widget:CreateFontString(Widget:GetName().."Title", "BACKGROUND", "GameFontNormalSmall");
  Title:SetParent(Widget);
  Title:SetPoint("BOTTOMLEFT", Widget, "TOPLEFT", 20, 0);
  Title:SetText(L["Equipable"]);
  Widget:SetParent(nil);
  Widget:Hide();
  Widget.initialize = function(...) self:DropDown_Init(...) end;
  Widget.YPaddingTop = Title:GetHeight();
  Widget.Height = Widget:GetHeight() + Widget.YPaddingTop;
  Widget.XPaddingLeft = -15;
  Widget.XPaddingRight = -15;
  Widget.Width = Widget:GetWidth() + Widget.XPaddingLeft + Widget.XPaddingRight;
  Widget.PreferredPriority = 4;
  Widget.Info = {
    L["Equipable"],
    L["Selected rule will only match items that are equipable."],
  };
  return Widget;
end
module.Widget = module:CreateWidget();

-- Local function to get the data and make sure it's valid data
function module.Widget:GetData(RuleNum)
  local Data = module:GetConfigOption("Equipable", RuleNum);
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
    module:SetConfigOption("Equipable", Data);
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
  module:SetConfigOption("Equipable", Value);
end

function module.Widget:RemoveFilter(Index)
  local Value = self:GetData();
  table.remove(Value, Index);
  if ( #Value == 0 ) then
    Value = nil;
  end
  module:SetConfigOption("Equipable", Value);
end

function module.Widget:DisplayWidget(Index)
  if ( Index ) then
    module.FilterIndex = Index;
  end
  local Value = self:GetData();
  UIDropDownMenu_SetText(module.Widget, module:GetEquipableText(Value[module.FilterIndex][1]));
end

function module.Widget:GetFilterText(Index)
  local Value = self:GetData();
  return module:GetEquipableText(Value[Index][1]);
end

function module.Widget:IsException(RuleNum, Index)
  local Data = self:GetData(RuleNum);
  return Data[Index][2];
end

function module.Widget:SetException(RuleNum, Index, Value)
  local Data = self:GetData(RuleNum);
  Data[Index][2] = Value;
  module:SetConfigOption("Equipable", Data);
end

function module.Widget:ColorCheck(Red, Green, Blue, Alpha)
  Red = math.floor(Red * 255 + 0.5);
  Green = math.floor(Green * 255 + 0.5);
  Blue = math.floor(Blue * 255 + 0.5);
  Alpha = math.floor(Alpha * 255 + 0.5);
  return ( Red == 255 and Green == 32 and Blue == 32 and Alpha == 255 );
end

function module.Widget:SetMatch(ItemLink, Tooltip)
  local CanEquip, Usable;
  if ( IsEquippableItem(ItemLink) ) then
    local _, _, _, _, _, _, _, _, EquipLoc, _, _, ItemType, ItemSubType = GetItemInfo(ItemLink);
    if ( TypeSubTypes[ItemType] ) then  -- We check for this Type
      if ( not TypeSubTypes[ItemType][ItemSubType] ) then  -- We don't check for this SubType
        ItemSubType = nil;
      end
    else  -- We don't check for this Type
      ItemType = nil;
    end
    if ( not EquipSlots[EquipLoc] ) then  -- We don't check for this EquipSlot
      EquipLoc = nil;
    end
    for Key, Value in pairs(module.ClassTable) do
      if ( ( not Value[1] or not ItemType or Value[1] == ItemType )
      and ( not Value[2] or not ItemSubType or Value[2] == ItemSubType )
      and ( not Value[3] or not EquipLoc or Value[3] == EquipLoc ) ) then
        CanEquip = true;
        break;
      end
    end
    -- Reasons for not being able to equip it: (I'll just scan the tooltip for red text again)
    -- 1 - We havn't learned the skill yet
    -- 2 - Our level is below the required level.
    if ( CanEquip ) then
      Usable = true;
      local Line, Text, Red, Green, Blue, Alpha;
      for Index = 2, Tooltip:NumLines() do
        Line = _G[Tooltip:GetName().."TextLeft"..Index];
        if ( Line ) then
          Text = Line:GetText();
          if ( Text and Text ~= "" ) then
            Red, Green, Blue, Alpha = Line:GetTextColor();
            if ( string.find(Text, "^\n") ) then
              break;
            end
            if ( self:ColorCheck(Red, Green, Blue, Alpha) ) then
              Usable = false;  -- Unusable
              break;
            end
          end
        end
        Line = _G[Tooltip:GetName().."TextRight"..Index];
        if ( Line ) then
          Text = Line:GetText();
          if ( Text and Text ~= "" ) then  -- Check right side, as it might be armor type/weapon stuff
            Red, Green, Blue, Alpha = Line:GetTextColor();
            if ( self:ColorCheck(Red, Green, Blue, Alpha) ) then
              Usable = false;  -- Unusable
              break;
            end
          end
        end  -- if Line
      end  -- for Index = 2, Tooltip:NumLines()
    end  -- CanEquip
  end  -- IsEquippable()
  -- 1 = Any
  -- 2 = Never
  -- 3 = Now
  -- 4 = Later
  if ( CanEquip ) then
    if ( Usable ) then
      module.CurrentMatch = 3;
    else
      module.CurrentMatch = 4;
    end
  else
    module.CurrentMatch = 2;
  end
  module:Debug(string.format("Can Equip: %s, Now: %s", CanEquip and "true" or "false", Usable and "true" or "false"));
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
  for Key, Value in ipairs(self.Choices) do
    info.text = Value.Name;
    info.value = Value.Value;
    UIDropDownMenu_AddButton(info, Level);
  end
end

function module:DropDown_OnClick(Frame)
  local Value = self.Widget:GetData();
  Value[self.FilterIndex][1] = Frame.value;
  self:SetConfigOption("Equipable", Value);
  UIDropDownMenu_SetText(Frame.owner, Frame:GetText());
end

function module:GetEquipableText(Num)
  for Key, Value in ipairs(self.Choices) do
    if ( Value.Value == Num ) then
      return Value.Name;
    end
  end
  return "";
end
