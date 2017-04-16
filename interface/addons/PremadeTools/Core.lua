---------------------
-- SEE LICENSE.TXT --
---------------------

---------------
-- LIBRARIES --
---------------
local AceAddon = LibStub ("AceAddon-3.0");
local LibDBIcon = LibStub ("LibDBIcon-1.0");
local AceGUI = LibStub("AceGUI-3.0");
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");
local LibDataBroker = LibStub ("LibDataBroker-1.1");


------------
-- LOCALS --
------------
local loaded = false;
local RECOMMENDED_PVE_FILTER = 5;
local PVE_RAID_CATEGORY = 3;
local loot_types = {
	["freeforall"] = "Free for All",
	["roundrobin"] = "Round Robin",
	["group"] = "Group Loot",
	["needbeforegreed"] = "Need Before Greed",
	["master"] = "Master Looter",
	["personalloot"] = "Personal Loot",
}


----------
-- CORE --
----------
PremadeTools = AceAddon:NewAddon ("PremadeTools", "AceConsole-3.0", "AceEvent-3.0");
PremadeTools.selectedCategory = PVE_RAID_CATEGORY;
PremadeTools.selectedGroup = nil;
PremadeTools.loaded_template = "";
PremadeTools.template_name = "";
PremadeTools.auto_relist = false;
PremadeTools.auto_relist_listing_table = nil;
PremadeTools.listing_table = {
	activity = nil,
	ilvl = 0,
	title = "",
	voice = "",
	auto_accept = "",
	details = "",
}


-----------------------------
-- DEFAULT SAVED VARIABLES --
-----------------------------
PremadeTools.defaults = {
    global = {
        enable = true,
        minimap = {
            show = false,
            when_solo = false,
            only_when_lead = false,
        },
		templates = {
		},
    }
}


----------------
-- GUI TABLES --
----------------
PremadeTools.listing = {
	name = "PremadeTools: Manage Listing",
    type = 'group',
    args = {
		templates_group = {
			type = 'group',
			name = " ",
			order = .5,
			inline = true,
			hidden = function() return select (1, C_LFGList.GetActiveEntryInfo()) end,
			args = {
				saved = {
					type = 'select',
					name = "Saved Listings",
					get = function() return PremadeTools.loaded_template; end,
					set = function(_, name) PremadeTools:LoadTemplate (name); end,
					values = function() return PremadeTools:GetTemplatesDropdown (); end,
					width = "full",
					order = 1,
				},
				template_name = {
					type = 'input',
					name = "Save Listing As",
					get = function() return PremadeTools.template_name; end,
					set = function(_, newValue) PremadeTools.template_name = newValue; end,
					order = 2,
					width = "double",
				},
				save_button = {
					type = 'execute',
					name = "Save",
					func = function() PremadeTools:SaveTemplate (PremadeTools.template_name, PremadeTools.listing_table); PremadeTools.loaded_template = PremadeTools.template_name; end,
					order = 3,
					width = "half",
				},
				remove_button = {
					type = 'execute',
					name = "Delete",
					func = function() PremadeTools:RemoveTemplate (PremadeTools.loaded_template); end,
					order = 4,
					disabled = function() return (not PremadeTools.db.global.templates[PremadeTools.loaded_template]) end,
					width = "half",
				},
			}
		},
		activity_group = {
			type = 'group',
			name = "Activity",
			order = 1,
			inline = true,
			disabled = function() return select (1, C_LFGList.GetActiveEntryInfo()) end,
			args = {
				activity_category = {
                    type = 'select',
                    name = "",
                    get = function() return PremadeTools.selectedCategory; end,
                    set = function(_, newValue) PremadeTools.selectedCategory = newValue; PremadeTools:FillOutSelectedActivities (newValue) end,
                    values = function() return PremadeTools:GetCategories (); end,
					width = "normal",
                    order = 1,
                },
				activity_group = {
                    type = 'select',
                    name = "",
                    get = function() return PremadeTools.selectedGroup; end,
                    set = function(_, newValue) PremadeTools.selectedGroup = newValue; PremadeTools:FillOutSelectedActivities (nil, newValue); end,
                    values = function() return PremadeTools:GetGroups (); end,
					width = "normal",
                    order = 2,
                },
				activity = {
                    type = 'select',
                    name = "",
                    get = function() return PremadeTools.listing_table.activity; end,
                    set = function(_, newValue) PremadeTools.listing_table.activity = newValue; PremadeTools:FillOutSelectedActivities (nil, nil, newValue); end,
                    values = function() return PremadeTools:GetActivities (); end,
					width = "normal",
                    order = 3,
                },
			}
		},
		title_group = {
			type = 'group',
			name = "Title",
			order = 3,
			inline = true,
			args = {
				title = {
					type = 'input',
					name = "",
					get = function() return PremadeTools.listing_table.title; end,
					set = function(_, newValue) PremadeTools.listing_table.title = newValue; end,
					order = 1,
					width = "full",
				},
				-- left = {
					-- type = 'description',
					-- name = "|cFFFFFF00%LF%|r: Looking for/Waitlist\n|cFFFFFF00%SHORT%|r: Instance Short Name",
					-- order = 2,
					-- width = "normal",
				-- },
				-- right = {
					-- type = 'description',
					-- name = "|cFFFFFF00%BOSS%|r: Current Boss\n|cFFFFFF00%FRESH%|r: Only displayed if fresh",
					-- order = 3,
					-- width = "normal",
				-- },
			}
		},
		details_group = {
			type = 'group',
			name = "Details",
			order = 4,
			inline = true,
			args = {
				details = {
					type = 'input',
					multiline = true,
					name = "",
					get = function() return PremadeTools.listing_table.details; end,
					set = function(_, newValue) PremadeTools.listing_table.details = string.gsub(newValue, "\n", " "); end,
					order = 1,
					width = "full",
				},
			}
		},
		misc_group = {
			type = 'group',
			name = "Misc",
			order = 5,
			inline = true,
			args = {
				ilvl = {
					type = 'input',
					name = "Required iLvl",
					get = function() if (PremadeTools.listing_table.ilvl == 0) then return "" else return tostring (PremadeTools.listing_table.ilvl) end end,
					set = function(_, newValue) PremadeTools.listing_table.ilvl = (tonumber (newValue) or 0); end,
					order = 1,
					width = "half",
				},
				voice = {
					type = 'input',
					name = "Voice App",
					get = function() return PremadeTools.listing_table.voice; end,
					set = function(_, newValue) PremadeTools.listing_table.voice = newValue; end,
					order = 2,
				},
				auto_accept = {
					type = 'toggle',
					name = "Auto Accept",
					get = function() return PremadeTools.listing_table.auto_accept; end,
					set = function(_, newValue) PremadeTools.listing_table.auto_accept = newValue; end,
					order = 2.5,
				},
				auto_relist = {
					type = 'toggle',
					name = "Auto Relist",
					get = function() return PremadeTools.auto_relist; end,
					set = function(_, newValue) PremadeTools.auto_relist = newValue; end,
					order = 3,
					width = "full",
				},
			}
		},
		clear_button = {
			type = 'execute',
			name = "Clear",
			func = function() PremadeTools:ClearGUI () end,
			order = -2,
			width = "full",
			hidden = function() return select (1, C_LFGList.GetActiveEntryInfo()) end,
		},
		update_button = {
			type = 'execute',
			name = "Update Listing",
			func = function() PremadeTools:List (PremadeTools.listing_table); end,
			order = -2,
			width = "full",
			hidden = function() return not select (1, C_LFGList.GetActiveEntryInfo()) end,
		},
		list_button = {
			type = 'execute',
			name = "List Group",
			func = function() PremadeTools:List (PremadeTools.listing_table); end,
			order = -1,
			width = "full",
			hidden = function() return select (1, C_LFGList.GetActiveEntryInfo()) end,
		},
		delist_button = {
			type = 'execute',
			name = "Delist Group",
			func = function() PremadeTools.auto_relist = false; PremadeTools.auto_relist_listing_table = nil; C_LFGList.RemoveListing() end,
			order = -1,
			width = "full",
			hidden = function() return not select (1, C_LFGList.GetActiveEntryInfo()) end,
		},
	}
}


------------
-- LIB DB --
------------
local PremadeToolsLDB_MenuFrame;
local PremadeToolsLDB_Menu = {
	{
		text = "PremadeTools Menu",
		isTitle = true,
		notCheckable = true,
	},
    {
		text = "Manage Listings",
		notCheckable = true,
		func = function() PremadeTools:ShowHideListingWindow (); end,
	},
    -- {
		-- text = "Option 2",
		-- notCheckable = true,
		-- func = function() print("You've chosen option 2"); end,
	-- },
    -- {
		-- text = "More Options",
		-- hasArrow = true,
		-- notCheckable = true,
        -- menuList = {
            -- { 
				-- text = "Option 3",
				-- func = function() print("You've chosen option 3"); end,
				-- notCheckable = true,
			-- }
        -- },
    -- },
	{
		text = " ",
		isTitle = true,
		notCheckable = true,
		notClickable = true,
	},
	{
		text = "Close",
		notCheckable = true,
		func = function() CloseDropDownMenus (); end,
	}
}
local PremadeToolsLDB = LibDataBroker:NewDataObject ("PremadeTools", {
	type = "data source",
	text = "Premade Tools",
	icon = "Interface\\Icons\\INV_Misc_Eye_01",
	OnClick = function (frame, button) 
		if (button == "LeftButton") then
			PremadeTools:ShowHideListingWindow ();
		elseif (button == "RightButton") then
			PremadeToolsLDB_MenuFrame = PremadeToolsLDB_MenuFrame or CreateFrame ("Frame", "PremadeToolsLDB_MenuFrame", UIParent, "UIDropDownMenuTemplate");
			EasyMenu (PremadeToolsLDB_Menu, PremadeToolsLDB_MenuFrame, "cursor", 10, 0, "MENU");
		end
	end,
    OnTooltipShow = function (tt)
		tt:AddLine("Premade Tools", 1, 1, 1);
		tt:AddLine("Left Click: Manage Listing");
		tt:AddLine("Right Click: Open Menu");
	end,
})


-------------------
-- LOCAL HELPERS --
-------------------
local function create_listing_table (activity, title, ilvl, voice, auto_accept, details)
	local listing_table = {};

	listing_table.activity = activity;
	listing_table.title = title;
	listing_table.ilvl = ilvl;
	listing_table.voice = voice;
	listing_table.auto_accept = auto_accept;
	listing_table.details = details;

	return listing_table;
end


----------------
-- SETUP/INIT --
----------------
function PremadeTools:OnInitialize ()
    -- register saved variables
    self.db = LibStub("AceDB-3.0"):New ("PremadeToolsDB", self.defaults, true);

	-- make sure that if we are disabled, that we stay disabled
	if (not self.db.global.enable) then
        self:Disable();
    end

	-- this avoids the bug where C_LFGList will not return basically any information whatsoever
	-- there may be a race condition because this happens async; basically I'm hoping that the OnEnable is
	-- called after the information is gotten
	C_LFGList.RequestAvailableActivities();
end

function PremadeTools:OnEnable ()
	self.db.global.enable = true;

	-- only do this once, this is a dumb hack because of the RequestAvailableActivities async requirement
	if (not loaded) then
		-- create our minimap button
		LibDBIcon:Register ("PremadeTools", PremadeToolsLDB, self.db.global.minimap);

		-- register our option table
		self:RegisterOptions ();

		-- load in current group into GUI if we're listed
		local active, activity, ilvl, honor, title, details, voice, _, auto_accept = C_LFGList.GetActiveEntryInfo();
		
		if (active) then
			self.listing_table.activity = activity;
			self.listing_table.ilvl = ilvl;
			self.listing_table.title = title;
			self.listing_table.voice = voice;
			self.listing_table.auto_accept = auto_accept;
			self.listing_table.details = details;
			
			self:FillOutSelectedActivities (nil, nil, self.listing_table.activity);
			AceConfigRegistry:NotifyChange ("PremadeTools.listing");
		else
			self:FillOutSelectedActivities (PVE_RAID_CATEGORY);
			AceConfigRegistry:NotifyChange ("PremadeTools.listing");
		end
		
		loaded = true;
	end

	PremadeTools:ShowHideMinimapIcon ()

	self:RegisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATE");
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "ShowHideMinimapIcon");
	self:RegisterEvent("PARTY_LEADER_CHANGED", "ShowHideMinimapIcon");
end

function PremadeTools:OnDisable ()
    self.db.global.enable = false;

	LibDBIcon:Hide ("PremadeTools");
	self:UnregisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATE");
end


------------
-- EVENTS --
------------
function PremadeTools:LFG_LIST_ACTIVE_ENTRY_UPDATE (createdNew)
	-- save a template of the last listed group
	local active, activityID, ilvl, honor, title, details, voice, _, auto_accept = C_LFGList.GetActiveEntryInfo();

	if (active) then
		auto_relist_listing_table = create_listing_table (activityID, title, ilvl, voice, auto_accept, details);
	
		if (UnitIsGroupLeader("player")) then
			-- a group was listed while we were the group leader, save it under "Last Listed Group"
			self:SaveTemplate ("Last Listed Group", create_listing_table (activityID, title, ilvl, voice, auto_accept, details));
		else
			-- a group was listed when we were not the group leader, save it "Last Joined Group"
			self:SaveTemplate ("Last Joined Group", create_listing_table (activityID, title, ilvl, voice, auto_accept, details));
		end
	end
	
	-- auto relist
	if (self.auto_relist and not active and auto_relist_listing_table) then
		self:List (auto_relist_listing_table);
		self:Print ("Your group was relisted because you have the auto relist option on.");
	end
	
	-- refresh the listing window, making sure that the state of things is consistant
	AceConfigRegistry:NotifyChange ("PremadeTools.listing");
end


---------
-- GUI --
---------
function PremadeTools:RegisterOptions ()
	AceConfigRegistry:RegisterOptionsTable("PremadeTools.listing", PremadeTools.listing);
	AceConfigDialog:SetDefaultSize("PremadeTools.listing", 600, 700);
end

function PremadeTools:ShowHideListingWindow ()
	if (AceConfigDialog.OpenFrames["PremadeTools.listing"]) then
		AceConfigDialog:Close ("PremadeTools.listing");
	else
		AceConfigDialog:Open ("PremadeTools.listing");
		AceConfigDialog.OpenFrames["PremadeTools.listing"]:EnableResize(true);
	end
end

function PremadeTools:ShowHideMinimapIcon ()
	if (IsInGroup()) then
		if (UnitIsGroupLeader("player") and self.db.global.minimap.only_when_lead) then
			LibDBIcon:Show ("PremadeTools");
			return;
		end
	else
		if (self.db.global.minimap.when_solo) then
			LibDBIcon:Show ("PremadeTools");
			return;
		end
	end

	LibDBIcon:Hide ("PremadeTools");
end

function PremadeTools:ClearGUI ()
	self.listing_table.activity = nil;
	self.listing_table.ilvl = 0;
	self.listing_table.title = "";
	self.listing_table.voice = "";
	self.listing_table.auto_accept = "";
	self.listing_table.details = "";
	
	self.selectedCategory = PVE_RAID_CATEGORY;
	self.selectedGroup = nil;
	self.loaded_template = "";
	self.template_name = "";
	
	self:FillOutSelectedActivities (PVE_RAID_CATEGORY);
	AceConfigRegistry:NotifyChange ("PremadeTools.listing");
end


----------------
-- ACTIVITIES --
----------------
function PremadeTools:FillOutSelectedActivities (category, group, activity)
	local filters, categoryID, groupID, activityID = LFGListUtil_AugmentWithBest(RECOMMENDED_PVE_FILTER, category, group, activity);
	self.selectedCategory = categoryID;
	self.selectedGroup = groupID;
	self.listing_table.activity = activityID;
end

function PremadeTools:GetCategories ()
	local category_ids = C_LFGList.GetAvailableCategories (RECOMMENDED_PVE_FILTER);
    local categories = {};

    for i, v in pairs(category_ids) do
        categories[v] = C_LFGList.GetCategoryInfo(v);
    end

	return categories;
end

function PremadeTools:GetGroups ()
	local group_ids = C_LFGList.GetAvailableActivityGroups (self.selectedCategory, RECOMMENDED_PVE_FILTER);
    local groups = {};

    for i, v in pairs (group_ids) do
        groups[v] = C_LFGList.GetActivityGroupInfo (v);
    end

	return groups;
end

function PremadeTools:GetActivities ()
	local activity_ids = C_LFGList.GetAvailableActivities (self.selectedCategory, self.selectedGroup, RECOMMENDED_PVE_FILTER);
    local activities = {};

    for i, v in pairs (activity_ids) do
        activities[v] = select(2, C_LFGList.GetActivityInfo (v));
    end

	return activities;
end

function PremadeTools:List (listing_table)
	if (listing_table) then
		if (not C_LFGList.GetActiveEntryInfo()) then
			-- 7.0.3 added 4th parm honorLevel for pvp groups.  we hard-set this to 0, as we're only doing PVE groups.
			C_LFGList.CreateListing(listing_table.activity, listing_table.title, listing_table.ilvl, 0, listing_table.voice, listing_table.details, listing_table.auto_accept);
		else
			C_LFGList.UpdateListing(listing_table.activity, listing_table.title, listing_table.ilvl, 0, listing_table.voice, listing_table.details, listing_table.auto_accept);
		end
	end
end


---------------
-- TEMPLATES --
---------------
function PremadeTools:SaveTemplate (name, listing_table)
	if (not listing_table) then
		return;
	end

	if (not self.db.global.templates[name]) then
		self.db.global.templates[name] = {};
	end

	self.db.global.templates[name].activity = listing_table.activity;
	self.db.global.templates[name].ilvl = listing_table.ilvl;
	self.db.global.templates[name].title = listing_table.title;
	self.db.global.templates[name].voice = listing_table.voice;
	self.db.global.templates[name].auto_accept = listing_table.auto_accept;
	self.db.global.templates[name].details = listing_table.details;
	
	AceConfigRegistry:NotifyChange ("PremadeTools.listing");
end

function PremadeTools:RemoveTemplate (name)
	if (not name or not self.db.global.templates[name]) then
		return;
	end

	self.loaded_template = "";
	self.template_name = "";
	self.db.global.templates[name] = nil;
	AceConfigRegistry:NotifyChange ("PremadeTools.listing");
end

function PremadeTools:GetTemplatesDropdown ()
	local templates = {}

	for name, listing_table in pairs(self.db.global.templates) do
		templates[name] = name;
	end

	return templates;
end

function PremadeTools:LoadTemplate (name)
	if (not self.db.global.templates[name]) then
		return
	end

	self.listing_table.activity = self.db.global.templates[name].activity;
	self.listing_table.ilvl = self.db.global.templates[name].ilvl;
	self.listing_table.title = self.db.global.templates[name].title;
	self.listing_table.voice = self.db.global.templates[name].voice;
	self.listing_table.auto_accept = self.db.global.templates[name].auto_accept;
	self.listing_table.details = self.db.global.templates[name].details;

	self.loaded_template = name;
	self.template_name = name;

	self:FillOutSelectedActivities (nil, nil, self.listing_table.activity);
	AceConfigRegistry:NotifyChange ("PremadeTools.listing");
end
