-- ----------------------------------------------------------------------------
--  Salvage Crates
-- 		by Nasapunk88
-- ----------------------------------------------------------------------------
local _, L = ...;
SalvageCrates = {};

SalvageCrates.items = {
	{ ["name"] = "SalvageCrates_LargeCrateButton",  --"Large Crate of Salvage"
	  ["id"] = 140590, 
	  ["button"] = nil
	},
	{ ["name"] = "SalvageCrates_SalvageCrateButton",  --"Salvage Crate"
	  ["id"] = 139594, 
	  ["button"] = nil
	},
	{ ["name"] = "SalvageCrates_SackButton",  --"Sack of Salvaged Goods"
	  ["id"] = 139593, 
	  ["button"] = nil
	},
	{ ["name"] = "SalvageCrates_SmallSackButton",  --"Small Sack of Salvaged Goods"
	  ["id"] = 118473, 
	  ["button"] = nil
	},
	{ ["name"] = "SalvageCrates_BagButton",  --"Bag of Salvaged Goods"
	  ["id"] = 114116, 
	  ["button"] = nil
	},
	{ ["name"] = "SalvageCrates_CrateButton", --"Crate of Salvage"
	  ["id"] = 114119,
	  ["button"] = nil
	},
	{ ["name"] = "SalvageCrates_BigCrateButton", --"Big Crate of Salvage"
	  ["id"] = 114120,
	  ["button"] = nil
	},
	{ ["name"] = "SalvageCrates_FollowerArmor", --"Yellow Follower Armor"
      ["id"] = 120301,
      ["button"] = nil
    },
    { ["name"] = "SalvageCrates_FollowerWeapon", --"Yellow Follower Weapon"
      ["id"] = 120302,
      ["button"] = nil
    }
};

SalvageCrates.garrisonMaps = {
	[1152] = true, -- FW Horde Garrison Level 1
	[1330] = true, -- FW Horde Garrison Level 2
	[1153] = true, -- FW Horde Garrison Level 3
	[1154] = true, -- FW Horde Garrison Level 4
	[1158] = true, -- SMV Alliance Garrison Level 1
	[1331] = true, -- SMV Alliance Garrison Level 2
	[1159] = true, -- SMV Alliance Garrison Level 3
	[1160] = true, -- SMV Alliance Garrison Level 4
}

function SalvageCrates:updateButtons()
	self.previous = 0;
	local freeSpace = 0;
	for bag = 0, NUM_BAG_SLOTS do
		numberOfFreeSlots, BagType = GetContainerNumFreeSlots(bag);
		freeSpace = freeSpace + numberOfFreeSlots;
	end
	for i = 1, #self.items do
		self:updateButton(self.items[i].button,self.items[i].id,i,freeSpace);
	end
end

function SalvageCrates:updateButton(btn,id,num,freeSpace)
	local count = GetItemCount(id);
	if count > 0 then
		btn:ClearAllPoints();
		if SalvageCratesDB.alignment == "LEFT" then
			if self.previous == 0 then
				btn:SetPoint("LEFT", self.frame, "LEFT", 0, 0);
			else
				btn:SetPoint("LEFT", self.items[self.previous].button, "RIGHT", 2, 0);
			end
		else
			if self.previous == 0 then
				btn:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0);
			else
				btn:SetPoint("RIGHT", self.items[self.previous].button, "LEFT", -2, 0);
			end
		end
		if self.previous == 0 and SalvageCratesDB.freeSpace then
			btn.freeSpaceFont:SetText("Free:"..freeSpace);
			btn.freeSpace:Show();
		else
			btn.freeSpaceFont:SetText("");
			btn.freeSpace:Hide();
		end
		self.previous = num;
		btn.countString:SetText(format("%d",count));
		btn.texture:SetDesaturated(false);
		btn:Show();
		if (id == 120301 or id == 120302) and not SalvageCratesDB.followerTokens then
			btn:Hide();
		end
	elseif count == 0 then
		btn.countString:SetText("");
		btn.freeSpaceFont:SetText("");
		btn.freeSpace:Hide();
		btn.texture:SetDesaturated(true);
		btn:Hide();
	end
end

function SalvageCrates:createButton(btn,id)
	btn:Hide();
	btn:SetWidth(38);
	btn:SetHeight(38);
	btn:ClearAllPoints();
	btn:SetClampedToScreen(true);
	--Right click to drag
	btn:EnableMouse(true);
	btn:RegisterForDrag("RightButton");
	btn:SetMovable(true);
	btn:SetScript("OnDragStart", function(self) self:GetParent():StartMoving(); end);
	btn:SetScript("OnDragStop", function(self) 
			self:GetParent():StopMovingOrSizing();
			self:GetParent():SetUserPlaced(false);
			local point, relativeTo, relativePoint, xOfs, yOfs = self:GetParent():GetPoint();
			SalvageCratesDB.position = {point, nil, relativePoint, xOfs, yOfs};
		end);
	--Setup macro
	btn:SetAttribute("type", "macro");
	btn:SetAttribute("macrotext", format("/use item:%d",id));
	btn.countString = btn:CreateFontString(btn:GetName().."Count", "OVERLAY", "NumberFontNormal");
	btn.countString:SetPoint("BOTTOMRIGHT", btn, -3, 2);
	btn.countString:SetJustifyH("RIGHT");
	btn.freeSpace = CreateFrame("Frame", btn:GetName().."FreeSpace", btn);
	btn.freeSpace:SetFrameStrata("BACKGROUND");
	btn.freeSpace:SetWidth(35);
	btn.freeSpace:SetHeight(10);
	btn.freeSpace.t = btn.freeSpace:CreateTexture(nil, "BACKGROUND");
	btn.freeSpace.t:SetTexture(0,0,0,.8);
	btn.freeSpace.t:SetAllPoints(true);
	btn.freeSpace.texture = btn.freeSpace.t;
	btn.freeSpace:SetPoint("TOPLEFT", btn, 1.5, -1);
	btn.freeSpaceFont = btn.freeSpace:CreateFontString(btn.freeSpace:GetName().."Font", "OVERLAY", "SystemFont_Tiny");
	btn.freeSpaceFont:SetPoint("CENTER", btn.freeSpace, 0, 0);
	btn.freeSpaceFont:SetJustifyH("LEFT");
	btn.icon = btn:CreateTexture(nil,"BACKGROUND");
	btn.icon:SetTexture(GetItemIcon(id));
	btn.icon:SetAllPoints(true);
	btn.texture = btn.icon;
	btn.texture:SetPoint("TOPLEFT", btn, -2, 1);
	
	--Tooltip
	btn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self,"ANCHOR_TOP");
		GameTooltip:SetItemByID(format("%d",id));
		GameTooltip:SetClampedToScreen(true);
		GameTooltip:Show();
	  end);
	btn:SetScript("OnLeave",GameTooltip_Hide);
 end

function SalvageCrates:reset()
	SalvageCratesDB = {["enable"] = true,["garrison"] = false,["alignment"] = "LEFT",["freeSpace"] = true,["followerTokens"] = false};
	self.frame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0);
	self:OnEvent("UPDATE");
end

function SalvageCrates:OnEvent(event, ...)
	if event == "PLAYER_LOGIN" then
		self.frame:UnregisterEvent("PLAYER_LOGIN");
		SalvageCratesDB = SalvageCratesDB or {};
		--If DB is empty
		if next (SalvageCratesDB) == nil then
			SalvageCrates:reset();
		end
		return
	end 
	--Check for combat to avoid tainting frame
	if UnitAffectingCombat("player") then
		return
	end
	
	SalvageCrates.insideGarrison = SalvageCrates.garrisonMaps[select(8,GetInstanceInfo())];
	
	if SalvageCrates.insideGarrison then
		local buildings = C_Garrison.GetBuildings(LE_GARRISON_TYPE_6_0);
		for i = 1, #buildings do
			if buildings[i].buildingID == 52 or buildings[i].buildingID == 140 or buildings[i].buildingID == 141 then
				SalvageCrates.foundBuilding = true;
				SalvageCrates.maxLevel = select(16,C_Garrison.GetBuildingInfo(buildings[i].buildingID));
				if not SalvageCrates.maxLevel then
					SalvageCratesDB.garrison = true;
				end
				break;
			else
				SalvageCrates.foundBuilding = false;
			end
		end
	end

	SalvageCrates.buildingID, SalvageCrates.minimap = C_Garrison.GetBuildingInfo(52);
	local zone = GetMinimapZoneText();
	if (SalvageCratesDB.garrison and SalvageCrates.insideGarrison and SalvageCrates.foundBuilding) 
		or (not SalvageCratesDB.garrison and not IsInInstance() and (zone == L["Salvage Yard"]
		or zone == SalvageCrates.minimap 
		or strlower(zone) == strlower(SalvageCrates.minimap))) then
		self.frame:RegisterEvent("BAG_UPDATE");
		if SalvageCratesDB.enable  then
			self.frame:Show();
		else
			self.frame:Hide();
		end
		SalvageCrates:updateButtons();
	else --Hide anywhere else
		self.frame:Hide();
		self.frame:UnregisterEvent("BAG_UPDATE"); 
	end
end

------------------------------------------------
-- Slash Commands
------------------------------------------------
local function slashHandler(msg)
	msg = msg:lower() or "";
	if (msg == "show" or msg == "enable") then
		SalvageCratesDB.enable = true;
		SalvageCrates:OnEvent("UPDATE");
		print("|cffffff78Salvage Crates|r: Enabled");
	elseif (msg == "hide" or msg == "disable") then
		SalvageCratesDB.enable = false;
		SalvageCrates:OnEvent("UPDATE");
		print("|cffffff78Salvage Crates|r: Disabled");
	elseif (msg == "building") then
		if SalvageCrates.maxLevel then
			SalvageCratesDB.garrison = false;
			SalvageCrates:OnEvent("UPDATE");
			print("|cffffff78Salvage Crates|r: Only displaying inside the Salvage Yard.");
		else
			print("|cffffff78Salvage Crates|r: Must be inside Garrison to change. Also, Salvage Yard must be Level 3 to use this option.");
		end
	elseif (msg == "garrison") then
		SalvageCratesDB.garrison = true;
		SalvageCrates:OnEvent("UPDATE");
		print("|cffffff78Salvage Crates|r: Displaying inside your garrison. ");
	elseif (msg == "left") then
		SalvageCratesDB.alignment = "LEFT";
		SalvageCrates:updateButtons();
		print("|cffffff78Salvage Crates|r: Buttons aligned to the left");
	elseif (msg == "right") then
		SalvageCratesDB.alignment = "RIGHT";
		SalvageCrates:updateButtons();
		print("|cffffff78Salvage Crates|r: Buttons aligned to the right");
	elseif (msg == "tokens" or msg == "token") then
		SalvageCratesDB.followerTokens = not SalvageCratesDB.followerTokens;
		SalvageCrates:updateButtons();
		if SalvageCratesDB.followerTokens then
			print("|cffffff78Salvage Crates|r: Displaying follower weapon and armor tokens.");
		else
			print("|cffffff78Salvage Crates|r: Hiding follower weapon and armor tokens.");
		end
	elseif (msg == "free") then
		SalvageCratesDB.freeSpace = not SalvageCratesDB.freeSpace;
		SalvageCrates:updateButtons();
		if SalvageCratesDB.freeSpace then
			print("|cffffff78Salvage Crates|r: Displaying inventory space text.");
		else
			print("|cffffff78Salvage Crates|r: Hiding inventory space text.");
		end
	elseif (msg == "reset") then
		print("|cffffff78Salvage Crates|r: Resetting settings and position.");
		SalvageCrates:reset();
	else
		print("|cffffff78Salvage Crates|r: Arguments to |cffffff78/SalvageCrates|r :");
		print("  |cffffff78 show||hide|r - Toggle the buttons.");
		print("  |cffffff78 left||right|r - Set button alignment.");
		print("  |cffffff78 building|garrison|r - When to display buttons.");
		print("  |cffffff78 free|r - Toggle text for remaining inventory space.");
		print("  |cffffff78 tokens|r - Toggle display of follower tokens.");
		print("  |cffffff78 reset|r - Reset all settings.");
	end
end

SlashCmdList.SalvageCrates = function(msg) slashHandler(msg) end;
SLASH_SalvageCrates1 = "/SalvageCrates";
SLASH_SalvageCrates2 = "/SalvageCrate";

--Helper functions
local function cout(msg, premsg)
	premsg = premsg or "[".."Salvage Crates".."]"
	print("|cFFE8A317"..premsg.."|r "..msg);
end

local function coutBool(msg,bool)
	if bool then
		print(msg..": true");
	else
		print(msg..": false");
	end
end

--Main Frame
SalvageCrates.frame = CreateFrame("Frame", "SalvageCrates_Frame", UIParent);
SalvageCrates.frame:Hide();
SalvageCrates.frame:SetWidth(120);
SalvageCrates.frame:SetHeight(39);
SalvageCrates.frame:SetClampedToScreen(true);
SalvageCrates.frame:SetFrameStrata("BACKGROUND");
SalvageCrates.frame:SetMovable(true);
SalvageCrates.frame:RegisterEvent("ZONE_CHANGED"); 
SalvageCrates.frame:RegisterEvent("ZONE_CHANGED_INDOORS");
SalvageCrates.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
SalvageCrates.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
SalvageCrates.frame:RegisterEvent("PLAYER_REGEN_ENABLED");
SalvageCrates.frame:RegisterEvent("PLAYER_LOGIN");
SalvageCrates.frame:RegisterEvent("CHANNEL_UI_UPDATE");
SalvageCrates.frame:RegisterEvent("GARRISON_BUILDING_UPDATED");

SalvageCrates.frame:SetScript("OnEvent", function(self,event,...) SalvageCrates:OnEvent(event,...) end);
SalvageCrates.frame:SetScript("OnShow", function(self,event,...) 
	--Restore position
	self:ClearAllPoints();
	if SalvageCratesDB and SalvageCratesDB.position then
		self:SetPoint(SalvageCratesDB.position[1],UIParent,SalvageCratesDB.position[3],SalvageCratesDB.position[4],SalvageCratesDB.position[5]);
	else
		self:SetPoint('CENTER', UIParent, 'CENTER', 0, 0);
	end
 end);
---Create button for each item
for i = 1, #SalvageCrates.items do
	SalvageCrates.items[i].button = CreateFrame("Button", SalvageCrates.items[i].name, SalvageCrates.frame, "SecureActionButtonTemplate,ActionButtonTemplate");
	SalvageCrates:createButton(SalvageCrates.items[i].button,SalvageCrates.items[i].id);
end