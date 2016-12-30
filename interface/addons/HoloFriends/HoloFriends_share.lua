--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file manages the share-friends dialog

]]


local HF_Anonym = false;

local HF_Num_ScrollFrame_Buttons = 10;
local HF_CharList = {};
local HF_PlayerList = {};

local HF_PDframe = "";
local HF_ActualPlayer = "";
local HF_SelectedListKey = "";
local HF_CharListCheckedCnt = 0;
local HF_PlayerListCheckedCnt = 0;
local HF_Longlist


local function HFF_CopyFriendslist(list)
	local result = {};
	for key, entry in pairs(list) do
		local temp      = {};
		temp.name       = entry.name
		temp.group      = entry.group;
		temp.search     = entry.search;
		temp.realid     = entry.realid;
		temp.share      = false;
		temp.sharegroup = false;
		table.insert(result, temp);
	end
	-- sort the list in case new entries are added without loading of the char
	table.sort(result, HoloFriendsFuncs_CompareEntry);
	return result;
end


local function HFF_CopyCharList(list, exclude)
	local faction, faction_lc = UnitFactionGroup("player");
	local result = {};
	for key, entry in pairs(list) do
		if ( entry ~= exclude ) then
			local name = entry;
			if ( name == faction ) then name = faction_lc; end
			local temp = {};
			temp.name  = name;
			temp.share = false;
			table.insert(result, temp);
		end
	end
	return result;
end


local function HFF_RealmGetFactionChars(flist, mark)
	local clist = HoloFriendsFuncs_RealmGetAllFactionChars();

	for idx = table.getn(clist), 1, -1 do
		if ( not (HoloFriendsFuncs_IsCharDataAvailable(flist, clist[idx])) ) then
			if ( mark ) then
				clist[idx] = "("..clist[idx]..")"
			else
				table.remove(clist, idx);
			end
		end
	end

	return clist;
end


local function HFF_CharListRemoveUnavailable(clist, flist)
	local faction, faction_lc = UnitFactionGroup("player");
	for idx = table.getn(clist), 1, -1 do
		local name = clist[idx].name;
		if ( not name ) then name = clist[idx]; end
		if ( name == faction_lc ) then name = faction; end
		if ( not (HoloFriendsFuncs_IsCharDataAvailable(flist, name)) ) then
			if ( clist[idx].share ) then
				HF_CharListCheckedCnt = HF_CharListCheckedCnt - 1;
			end
			table.remove(clist, idx);
		end
	end
	return clist;
end


-- Scroll frame handling

local function HFF_ScrollFrame_Update(list, scrollFrame, btnName)
	local visibleCnt;

	-- get visible index table
	local ShownIndexTable = {};
	ShownIndexTable = HoloFriendsFuncs_ShownListTab(list, HF_Num_ScrollFrame_Buttons);

	-- count visible entries
	local numElementsTable = table.getn(ShownIndexTable);
	local visibleCnt = 0;
	if ( numElementsTable > HF_Num_ScrollFrame_Buttons ) then
		visibleCnt = numElementsTable;
	else
		local numElementsList = table.getn(list);
		for ii = 1, numElementsTable do
			if ( ShownIndexTable[ii] <= numElementsList ) then
				visibleCnt = visibleCnt + 1;
			end
		end
	end

	-- ScrollFrame stuff
	FauxScrollFrame_Update(scrollFrame, visibleCnt, HF_Num_ScrollFrame_Buttons, 16);
	-- scrollframe offset
	local offset = FauxScrollFrame_GetOffset(scrollFrame);

	-- button and textures
	local button, buttonText, buttonIcon, buttonCheck;

	local entry = {};
	local line = 1;

	-- set values / textures for all buttons
	while ( line <= HF_Num_ScrollFrame_Buttons ) do
		local index = ShownIndexTable[line + offset];

		entry = list[index];

		button = getglobal(btnName..line);
		button:SetID(index);

		if ( line > visibleCnt ) then
			button:Hide();
		else
			button:Show();
		end

		if ( entry ) then
			-- get textfields and icon
			buttonText  = getglobal(btnName..line.."Name");
			buttonIcon  = getglobal(btnName..line.."ShareIcon");
			buttonCheck = getglobal(btnName..line.."ShareCheck");

			local name = HoloFriendsLists_GetName(list, index, HF_DISPLAY);

			-- group entry ?
			if ( entry.name == "1" or entry.name == "0" ) then
				buttonText:SetText(name);
				buttonText:SetWidth(110);

				buttonIcon:Hide();
				if ( entry.share ) then
					buttonCheck:SetChecked(true);
				else
					buttonCheck:SetChecked(false);
				end
				buttonCheck:SetID(index);
				buttonCheck:Show();

				if ( entry.name == "1" ) then
					button:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				else
					button:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				end
			else -- no, we got a player
				if ( string.sub(name,1,1) == "(" ) then
					buttonText:SetText("|cff999999"..name.."|r");
				else
					buttonText:SetText(name);
				end
				buttonText:SetWidth(130);

				if ( entry.share ) then
					buttonIcon:Show();
				else
					buttonIcon:Hide();
				end
				if ( buttonCheck ) then buttonCheck:Hide(); end

				button:SetNormalTexture("");
			end

			-- Set the button text with
			button:SetWidth(150);
		end

		line = line + 1;
	end
end


function HoloFriendsShare_SourceScrollFrame_Update(self)
	local window = self:GetName();
	if ( strsub(window,5,5) == "F" ) then
		HFF_ScrollFrame_Update(HF_PlayerList, HoloFriends_ShareFrame_SourceScrollFrame, "HoloFriends_ShareFrame_Source");
	end
	if ( strsub(window,5,5) == "I" ) then
		HFF_ScrollFrame_Update(HF_PlayerList, HoloIgnore_ShareFrame_SourceScrollFrame, "HoloIgnore_ShareFrame_Source");
	end
end


function HoloFriendsShare_TargetScrollFrame_Update(self)
	local window = self:GetName();
	if ( strsub(window,5,5) == "F" ) then
		HFF_ScrollFrame_Update(HF_CharList, HoloFriends_ShareFrame_TargetScrollFrame, "HoloFriends_ShareFrame_Target");
	end
	if ( strsub(window,5,5) == "I" ) then
		HFF_ScrollFrame_Update(HF_CharList, HoloIgnore_ShareFrame_TargetScrollFrame, "HoloIgnore_ShareFrame_Target");
	end
end


-- Overall window functions

local function HFF_ListUpdate(self)
	local window = self:GetName();
	local holo_list, isFL, frame;
	if ( strsub(window,5,5) == "F" ) then
		holo_list = HOLOFRIENDS_LIST;
		isFL = HF_HFLIST;
		frame = "HoloFriends_ShareFrame";
	end
	if ( strsub(window,5,5) == "I" ) then
		holo_list = HOLOIGNORE_LIST;
		isFL = HF_HILIST;
		frame = "HoloIgnore_ShareFrame";
	end

	local faction = UnitFactionGroup("player");
	HF_Longlist = false;
	if ( HF_SelectedListKey == faction ) then HF_Longlist = true; end
	HF_CharList = HFF_CopyCharList(HFF_RealmGetFactionChars(holo_list, HF_Longlist), HF_SelectedListKey);

	-- be certain, the name exists in holo_list, otherwise
	-- HoloFriendsFuncs_LoadList() would create a new entry
	if ( HoloFriendsFuncs_IsCharDataAvailable(holo_list, HF_SelectedListKey) ) then
		-- use a copy, not the original data
		local list = HoloFriendsFuncs_LoadList(holo_list, HF_SelectedListKey, isFL, HF_SHARE);
		HF_PlayerList = HFF_CopyFriendslist(list);
	else
		HF_PlayerList = {};
	end

	HF_CharListCheckedCnt = 0;
	HF_PlayerListCheckedCnt = 0;

	getglobal(frame.."_ButtonShareAdd"):Disable();
	getglobal(frame.."_ButtonShareSub"):Disable();

	HoloFriendsShare_SourceScrollFrame_Update(self);
	HoloFriendsShare_TargetScrollFrame_Update(self);

	if ( HF_SelectedListKey == faction ) then
		getglobal(frame.."_FactionButtons_Character1_text"):SetText("-");
		getglobal(frame.."_FactionButtons_ButtonFactionAdd"):Disable();
	else
		local name = HF_SelectedListKey;
		if ( HF_Anonym ) then name = PLAYER; end
		getglobal(frame.."_FactionButtons_Character1_text"):SetText(name);
		getglobal(frame.."_FactionButtons_ButtonFactionAdd"):Enable();
	end

	getglobal(frame.."_FactionButtons_Character2_text"):SetText("-");
	getglobal(frame.."_FactionButtons_ButtonFactionExtract"):Disable();
end

-- add the share frames after the options category is added
local HF_FF_self = nil;
local HF_IF_self = nil;
function HoloFriendsShare_VariablesLoaded()
	InterfaceOptions_AddCategory(HF_FF_self);
	InterfaceOptions_AddCategory(HF_IF_self);
end

function HoloFriendsShare_OnLoad(self)
	local window = self:GetName();
	if ( strsub(window,5,5) == "F" ) then
		self.name = HOLOFRIENDS_SHAREFRIENDSWINDOWTITLE;
	end
	if ( strsub(window,5,5) == "I" ) then
		self.name = HOLOFRIENDS_SHAREIGNOREWINDOWTITLE;
	end
	self.parent = HOLOFRIENDS_OPTIONS0LISTENTRY;
	-- add the share frames after the options category is added
	if ( strsub(window,5,5) == "F" ) then
		HF_FF_self = self;
	end
	if ( strsub(window,5,5) == "I" ) then
		HF_IF_self = self;
	end
--	InterfaceOptions_AddCategory(self);
end


function HoloFriendsShare_OnShow(self)
	local window = self:GetName();
	local holo_list, frame;
	if ( strsub(window,5,5) == "F" ) then
		holo_list = HOLOFRIENDS_LIST;
		frame = "HoloFriends_ShareFrame";
	end
	if ( strsub(window,5,5) == "I" ) then
		holo_list = HOLOIGNORE_LIST;
		frame = "HoloIgnore_ShareFrame";
	end

	if ( strsub(window,5,5) == "F" ) then
		HoloFriendsFrameShareButton:Disable();
	end
	if ( strsub(window,5,5) == "I" ) then
		HoloIgnoreFrameShareButton:Disable();
	end

	local faction, faction_lc = UnitFactionGroup("player");
	HF_ActualPlayer = UnitName("player");
	if ( not (HoloFriendsFuncs_IsCharDataAvailable(holo_list, HF_ActualPlayer)) ) then
		HF_ActualPlayer = faction;
	end

	HF_SelectedListKey = HF_ActualPlayer;

	for i = 1, HF_Num_ScrollFrame_Buttons do
		getglobal(frame.."_Source"..i.."ShareIcon"):Hide();
		getglobal(frame.."_Target"..i.."ShareIcon"):Hide();
	end

	HFF_ListUpdate(self);

	-- update actual name to the pull down menu
	if ( HF_PDframe and (HF_PDframe ~= "") ) then
		local name = HF_ActualPlayer;
		if ( name == faction ) then
			name = faction_lc;
		elseif ( HF_Anonym ) then
			name = PLAYER;
		end
		UIDropDownMenu_SetText(getglobal(HF_PDframe), name);
	end
end


function HoloFriendsShare_OnHide(self)
	local window = self:GetName();
	local frame;
	if ( strsub(window,5,5) == "F" ) then
		frame = "HoloFriends_ShareFrame";
	end
	if ( strsub(window,5,5) == "I" ) then
		frame = "HoloIgnore_ShareFrame";
	end

	HF_CharList = {};
	HF_PlayerList = {};
	HF_SelectedListKey = "";
	HF_CharListCheckedCnt = 0;
	HF_PlayerListCheckedCnt = 0;

	if ( strsub(window,5,5) == "F" ) then
		HoloFriendsFrameShareButton:Enable();
	end
	if ( strsub(window,5,5) == "I" ) then
		HoloIgnoreFrameShareButton:Enable();
	end

	getglobal(frame.."_FactionButtons_Character1_text"):SetText("-");
	getglobal(frame.."_FactionButtons_ButtonFactionAdd"):Disable();

	getglobal(frame.."_FactionButtons_Character2_text"):SetText("-");
	getglobal(frame.."_FactionButtons_ButtonFactionExtract"):Disable();
end


-- Actions on click to one of the two lists

local function HFF_ChangeOnClick(self, name)
	local window = self:GetName();
	local holo_list, frame;
	if ( strsub(window,5,5) == "F" ) then
		holo_list = HOLOFRIENDS_LIST;
		frame = "HoloFriends_ShareFrame";
	end
	if ( strsub(window,5,5) == "I" ) then
		holo_list = HOLOIGNORE_LIST;
		frame = "HoloIgnore_ShareFrame";
	end

	local faction = UnitFactionGroup("player");

	if ( (HF_PlayerListCheckedCnt > 0) and (HF_CharListCheckedCnt > 0) ) then
		getglobal(frame.."_ButtonShareAdd"):Enable();
		getglobal(frame.."_ButtonShareSub"):Enable();
	else
		getglobal(frame.."_ButtonShareAdd"):Disable();
		getglobal(frame.."_ButtonShareSub"):Disable();
	end

	if ( HF_SelectedListKey == faction ) then
		if ( (HF_PlayerListCheckedCnt == 0) and (HF_CharListCheckedCnt == 0) and not HF_Longlist ) then
			HF_Longlist = true;
			HF_CharList = HFF_CopyCharList(HFF_RealmGetFactionChars(holo_list, HF_Longlist), HF_SelectedListKey);
			HF_CharListCheckedCnt = 0;
			HoloFriendsShare_TargetScrollFrame_Update(self);
		end

		local change = false;
		if ( (HF_PlayerListCheckedCnt > 0) and HF_Longlist ) then change = true; end
		if ( (HF_CharListCheckedCnt > 0) and HF_Longlist ) then
			if ( HF_CharListCheckedCnt > 1 ) then change = true; end
			if ( name ) then
				if ( string.sub(name,1,1) ~= "(" ) then change = true; end
			else change = true; end
		end
		if ( change ) then
			HF_Longlist = false;
			HF_CharList = HFF_CharListRemoveUnavailable(HF_CharList, holo_list);
			HoloFriendsShare_TargetScrollFrame_Update(self);
		end
	end

	if ( (HF_CharListCheckedCnt > 0) or (HF_PlayerListCheckedCnt > 0)
	    or (HF_SelectedListKey == faction) ) then
		getglobal(frame.."_FactionButtons_Character1_text"):SetText("-");
		getglobal(frame.."_FactionButtons_ButtonFactionAdd"):Disable();
	else
		local name = HF_SelectedListKey;
		if ( HF_Anonym ) then name = PLAYER; end
		getglobal(frame.."_FactionButtons_Character1_text"):SetText(name);
		getglobal(frame.."_FactionButtons_ButtonFactionAdd"):Enable();
	end

	if ( (HF_CharListCheckedCnt == 1) and (HF_PlayerListCheckedCnt == 0)
	    and (HF_SelectedListKey == faction) and name and (string.sub(name,1,1) == "(") ) then
		local namelength = string.len(name);
		local sepname = string.sub(name,2,namelength - 1);
		if ( HF_Anonym ) then sepname = PLAYER; end
		getglobal(frame.."_FactionButtons_Character2_text"):SetText(sepname);
		getglobal(frame.."_FactionButtons_ButtonFactionExtract"):Enable();
	else
		getglobal(frame.."_FactionButtons_Character2_text"):SetText("-");
		getglobal(frame.."_FactionButtons_ButtonFactionExtract"):Disable();
	end
end


-- Actions on click to the source list

function HoloFriendsShare_Source_OnClick(self)
	local icon = getglobal(self:GetName().."ShareIcon");
	local index = self:GetID();

	if ( HoloFriendsLists_IsGroup(HF_PlayerList, index) ) then
		if ( HF_PlayerList[index].name == "0" and not HF_PlayerList[index].share ) then
			HF_PlayerList[index].name = "1" --show
		else
			HF_PlayerList[index].name = "0" --collapse
		end
		HoloFriendsShare_SourceScrollFrame_Update(self);
	else
		-- show/hide checkbox-symbol
		if ( HF_PlayerList[index].share ) then
			HF_PlayerList[index].share = false;
			HF_PlayerListCheckedCnt = HF_PlayerListCheckedCnt - 1;
			icon:Hide();
		else
			HF_PlayerList[index].share = true;
			HF_PlayerListCheckedCnt = HF_PlayerListCheckedCnt + 1;
			icon:Show();
		end

		HFF_ChangeOnClick(self);
	end
end


-- Actions on click to group check box

local function HFF_ChangeShareGroup(group, set)
	local list = HF_PlayerList;

	for index = 1, table.getn(list) do
		if ( list[index].group == group ) then
			if ( set ) then
				HF_PlayerList[index].share = true;
				HF_PlayerList[index].sharegroup = true;
				HF_PlayerListCheckedCnt = HF_PlayerListCheckedCnt + 1;
			else
				HF_PlayerList[index].share = false;
				HF_PlayerList[index].sharegroup = false;
				HF_PlayerListCheckedCnt = HF_PlayerListCheckedCnt - 1;
			end
		end
	end
end


function HoloFriendsShare_Group_OnClick(self)
	local index = self:GetID();

	if ( HoloFriendsLists_IsGroup(HF_PlayerList, index) ) then
		if ( HF_PlayerList[index].share ) then
			-- unset share and sharegroup for all group members
			HFF_ChangeShareGroup(HF_PlayerList[index].group, false)
		else
			-- collapse group list display
			HF_PlayerList[index].name = "0"
			-- set share and sharegroup for all group members
			HFF_ChangeShareGroup(HF_PlayerList[index].group, true)
		end
	end

	HoloFriendsShare_SourceScrollFrame_Update(self);

	HFF_ChangeOnClick(self);
end


-- Actions on click to the target list

function HoloFriendsShare_Target_OnClick(self)
	local icon = getglobal(self:GetName().."ShareIcon");
	local index = self:GetID();

	-- show/hide checkbox-symbol
	if ( HF_CharList[index].share ) then
		HF_CharList[index].share = false;
		HF_CharListCheckedCnt = HF_CharListCheckedCnt - 1;
		icon:Hide();
	else
		HF_CharList[index].share = true;
		HF_CharListCheckedCnt = HF_CharListCheckedCnt + 1;
		icon:Show();
	end

	HFF_ChangeOnClick(self, HF_CharList[index].name);
end


-- Char pulldown menu

function HoloFriendsShare_CharDropDown_OnShow(self)
	local window = self:GetName();
	local holo_list;
	if ( strsub(window,5,5) == "F" ) then
		holo_list = HOLOFRIENDS_LIST;
	end
	if ( strsub(window,5,5) == "I" ) then
		holo_list = HOLOIGNORE_LIST;
	end

	HF_PDframe = window;

	local player = UnitName("player");
	if ( not (HoloFriendsFuncs_IsCharDataAvailable(holo_list, player)) ) then
		_, player = UnitFactionGroup("player");
	end

	UIDropDownMenu_Initialize(self, HoloFriendsShare_CharDropDown_Init);
	UIDropDownMenu_SetText(self, player);
	UIDropDownMenu_SetWidth(self, 160);
end


function HoloFriendsShare_CharDropDown_Init(self)
	local window = self:GetName();
	local holo_list;
	if ( strsub(window,5,5) == "F" ) then
		holo_list = HOLOFRIENDS_LIST;
	end
	if ( strsub(window,5,5) == "I" ) then
		holo_list = HOLOIGNORE_LIST;
	end

	local faction, faction_lc = UnitFactionGroup("player");
	for k,value in pairs(HFF_RealmGetFactionChars(holo_list)) do
		local name = value;
		if ( name == faction ) then
			name = faction_lc;
		elseif ( HF_Anonym ) then
			name = PLAYER;
		end
		local info = { };
		info.text = name;
		info.value = value;
		if ( strsub(window,5,5) == "F" ) then
			info.func = HoloFriendsShare_CharFriendsDropDown_OnClick;
		end
		if ( strsub(window,5,5) == "I" ) then
			info.func = HoloFriendsShare_CharIgnoreDropDown_OnClick;
		end
		UIDropDownMenu_AddButton(info);
	end
end


-- this function is for friends list only
function HoloFriendsShare_CharFriendsDropDown_OnClick(self)
	local faction, faction_lc = UnitFactionGroup("player");
	local name = self.value;
	if ( name == faction ) then
		name = faction_lc;
	elseif ( HF_Anonym ) then
		name = PLAYER;
	end

	UIDropDownMenu_SetText(HoloFriends_ShareFrame_CharDropDown, name);

	HF_SelectedListKey = self.value;

	HFF_ListUpdate(HoloFriends_ShareFrame);
end


-- this function is for ignore list only
function HoloFriendsShare_CharIgnoreDropDown_OnClick(self)
	local faction, faction_lc = UnitFactionGroup("player");
	local name = self.value;
	if ( name == faction ) then
		name = faction_lc;
	elseif ( HF_Anonym ) then
		name = PLAYER;
	end

	UIDropDownMenu_SetText(HoloIgnore_ShareFrame_CharDropDown, name);

	HF_SelectedListKey = self.value;

	HFF_ListUpdate(HoloIgnore_ShareFrame);
end


-- Functions to perform the sharing

local function HFF_ShareEntry(biglist, cname, fkey, sharegroup, addentry, isFL, NewList)
	local realm = GetRealmName();

	local srclist = biglist[realm][HF_SelectedListKey];
	local tarlist = biglist[realm][cname];

	local tarEntry = {};
	local srcEntry = srclist[fkey];

	local name   = srcEntry.name;
	local group  = srcEntry.group;
	local realid = srcEntry.realid;

	-- check if destination (target) exist and get the list index
	local cfKey;
	if ( (name ~= "0") and (name ~= "1") ) then
		cfKey = HoloFriendsLists_ContainsPlayer(tarlist, name);
	else
		cfKey = HoloFriendsLists_ContainsGroup(tarlist, group);
	end

	-- check if target is older than source
	local oldtar = false;
	if ( not addentry and (cfKey ~= nil) ) then
		tarEntry = tarlist[cfKey];
		local lastSeen1 = HoloFriendsLists_GetLastSeen(tarlist, cfKey);
		local lastSeen2 = HoloFriendsLists_GetLastSeen(srclist, fkey);
		if ( lastSeen1 and lastSeen2 ) then
			oldtar = HoloFriendsFuncs_Date1ltDate2(lastSeen1, lastSeen2);
		end
	end

	-- copy values
	tarEntry.name   = srcEntry.name;
	if ( realid ) then tarEntry.realid = srcEntry.realid; end

	-- handle the group entry according the flags and options
	if ( sharegroup ) then
		-- the group entry is always the first entry in the sorted friends list
		if ( ((name == "0") or (name == "1")) and cfKey and HOLOFRIENDS_OPTIONS.MarkRemove ) then
			-- set the flag .remove for all group members at target list
			-- for not copied entries, the flag is not removed
			for rkey, rval in pairs(tarlist) do
				if ( tarlist[rkey].group == group ) then
					tarlist[rkey].remove = true;
				end
			end
		end
		-- set for actual entry only
		tarEntry.remove = nil;
		tarEntry.group = srcEntry.group;
	elseif ( not cfKey ) then
		if ( (name ~= "0") and (name ~= "1") ) then
			if ( isFL ) then
				tarEntry.group = FRIENDS;
			else
				tarEntry.group = IGNORE;
			end
		else
			tarEntry.group = srcEntry.group;
		end
	end

	-- merge comments according to the options
	local merge = HOLOFRIENDS_OPTIONS.MergeComments;
	local comment = srcEntry.comment;
	local setNote = HoloFriendsFuncs_MergeComment(tarEntry, comment, srcEntry.mergecnt, merge, true);
	if ( comment and (comment ~= "") and not merge and cfKey ) then setNote = true; end

	if ( (name ~= "0") and (name ~= "1") ) then
		if ( not cfKey ) then
			tarEntry.notify = srcEntry.notify;
			if ( srcEntry.notify and not NewList) then
				tarEntry.imported  = true;
				tarEntry.connected = nil;
				tarEntry.notify    = HF_OFFLINE;
			end
		elseif ( setNote and isFL ) then
			tarEntry.setnote   = true;
		end
		if ( (not cfKey or oldtar) and isFL ) then
			tarEntry.class     = srcEntry.class;
			tarEntry.lc_class  = srcEntry.lc_class;
			tarEntry.level     = srcEntry.level;
			tarEntry.area      = srcEntry.area;
			tarEntry.lastSeen  = srcEntry.lastSeen;
			if ( realid ) then
				tarEntry.onstate = srcEntry.onstate;
				tarEntry.toon    = srcEntry.toon;
				tarEntry.realm   = srcEntry.realm;
				tarEntry.faction = srcEntry.faction;
				tarEntry.bcast   = srcEntry.bcast;
				tarEntry.client  = srcEntry.client;
			end
		end
	end

	-- add only, if entry not already exists
	if ( not cfKey ) then
		table.insert(tarlist, tarEntry);
	end
end


function HoloFriendsShare_ShareAdd(self, add)
	local window = self:GetName();
	local holo_list, isFL;
	if ( strsub(window,5,5) == "F" ) then
		holo_list = HOLOFRIENDS_LIST;
		isFL = HF_HFLIST;
	end
	if ( strsub(window,5,5) == "I" ) then
		holo_list = HOLOIGNORE_LIST;
		isFL = HF_HILIST;
	end

	-- data source should be available ...
	if ( not (HoloFriendsFuncs_IsCharDataAvailable(holo_list, HF_SelectedListKey)) ) then
		return;
	end

	local faction, faction_lc = UnitFactionGroup("player");
	for cKey, cVal in pairs(HF_CharList) do
		if ( cVal.share ) then
			local name = cVal.name;
			if ( name == faction_lc ) then name = faction; end
			for fKey, fVal in pairs(HF_PlayerList) do
				if ( fVal.share and not (name == fVal.name) ) then
					HFF_ShareEntry(holo_list, name, fKey, fVal.sharegroup, add, isFL)
				end
			end

			-- update current player's friendslist, if he was a target
			if ( name == HF_ActualPlayer ) then
				if ( strsub(window,5,5) == "F" ) then
					HoloFriends_List_Update();
				end
				if ( strsub(window,5,5) == "I" ) then
					HoloIgnore_List_Update();
				end
			end
		end
	end

	-- reset selections
	HFF_ListUpdate(self);
end


function HoloFriendsShare_MergeCharDialog(self)
	local window = self:GetName();
	if ( strsub(window,5,5) == "F" ) then
		StaticPopup_Show("HOLOSHARE_FRIENDSMERGEFACTION", HF_SelectedListKey);
	end
	if ( strsub(window,5,5) == "I" ) then
		StaticPopup_Show("HOLOSHARE_IGNOREMERGEFACTION", HF_SelectedListKey);
	end
end


function HoloFriendsShare_MergeGroupsDialog(self)
	local window = self:GetName();
	local faction = UnitFactionGroup("player");
	local realm = GetRealmName();

	if ( strsub(window,5,5) == "F" ) then
		local exist = HOLOFRIENDS_LIST[realm][faction];
		if ( not exist ) then
			StaticPopup_Show("HOLOSHARE_FRIENDSMERGEFACTIONPRIORITY");
		else
			StaticPopup_Show("HOLOSHARE_FRIENDSMERGEFACTIONGROUPS", HF_SelectedListKey);
		end
	end
	if ( strsub(window,5,5) == "I" ) then
		local exist = HOLOIGNORE_LIST[realm][faction];
		if ( not exist ) then
			StaticPopup_Show("HOLOSHARE_IGNOREMERGEFACTIONPRIORITY");
		else
			StaticPopup_Show("HOLOSHARE_IGNOREMERGEFACTIONGROUPS", HF_SelectedListKey);
		end
	end
end


function HoloFriendsShare_MergeChar(self, sharegroup)
	local window = self:GetName();
	local holo_list, isFL;
	if ( strsub(window,5,5) == "F" ) then
		holo_list = HOLOFRIENDS_LIST;
		isFL = HF_HFLIST;
	end
	if ( strsub(window,5,5) == "I" ) then
		holo_list = HOLOIGNORE_LIST;
		isFL = HF_HILIST;
	end

	-- source char data should be available ...
	if ( not (HoloFriendsFuncs_IsCharDataAvailable(holo_list, HF_SelectedListKey)) ) then
		HoloFriends_chat("No data available for "..HF_SelectedListKey, HF_DEBUG_OUTPUT);
		return;
	end

	local faction, faction_lc = UnitFactionGroup("player");
	local realm = GetRealmName();

	local exist = holo_list[realm][faction];
	local NewList = false;
	if ( not exist ) then
		local nlist = HOLOFRIENDS_FACTIONS[realm][faction];
		local fexist = false;
		for _, entry in pairs(nlist) do
			if ( entry == faction ) then fexist = true; end
		end
		if ( not fexist ) then
			table.insert(nlist, faction);
			table.sort(nlist, function (a,b) return a < b; end);
		end

		holo_list[realm][faction] = {};
		NewList = true;
	end

	for fKey, fVal in pairs(HF_PlayerList) do
		HFF_ShareEntry(holo_list, faction, fKey, sharegroup, false, isFL, NewList);
	end

	holo_list[realm][HF_SelectedListKey] = nil;

	if ( HF_SelectedListKey == UnitName("player") ) then
		if ( strsub(window,5,5) == "F" ) then
			HoloFriends_LoadList();
			HoloFriends_List_Update();
		end
		if ( strsub(window,5,5) == "I" ) then
			HoloIgnore_LoadList();
			HoloIgnore_List_Update();
		end
	end
	if ( HF_ActualPlayer == faction ) then
		if ( strsub(window,5,5) == "F" ) then
			HoloFriends_List_Update();
		end
		if ( strsub(window,5,5) == "I" ) then
			HoloIgnore_List_Update();
		end
	end

	if ( strsub(window,5,5) == "F" ) then
		local msg = format(TEXT(HOLOFRIENDS_MSGFACTIONMERGEDONE), HF_SelectedListKey);
		HoloFriendsFuncs_SystemMessage(msg);
	end
	if ( strsub(window,5,5) == "I" ) then
		local msg = format(TEXT(HOLOFRIENDS_MSGFACTIONMERGEDONE), HF_SelectedListKey);
		HoloFriendsFuncs_SystemMessage(msg);
	end

	HoloFriendsShare_OnShow(self);
end


function HoloFriendsShare_SeparateChar(self)
	local window = self:GetName();
	local holo_list, isFL, frame;
	if ( strsub(window,5,5) == "F" ) then
		holo_list = HOLOFRIENDS_LIST;
		isFL = HF_HFLIST;
		frame = "HoloFriends_ShareFrame";
	end
	if ( strsub(window,5,5) == "I" ) then
		holo_list = HOLOIGNORE_LIST;
		isFL = HF_HILIST;
		frame = "HoloIgnore_ShareFrame";
	end

	local faction = UnitFactionGroup("player");
	local realm = GetRealmName();

	-- the faction list should be selected
	if ( HF_SelectedListKey ~= faction ) then
		HoloFriends_chat("No faction list selected: "..HF_SelectedListKey, HF_DEBUG_OUTPUT);
		return;
	end

	local charname = getglobal(frame.."_FactionButtons_Character2_text"):GetText();

	-- charname should be set
	if ( not charname or charname == "-" ) then
		HoloFriends_chat("No char name given", HF_DEBUG_OUTPUT);
		return;
	end

	-- destination char data should not exist ...
	if ( HoloFriendsFuncs_IsCharDataAvailable(holo_list, charname) ) then
		HoloFriends_chat("Data already existing for "..charname, HF_DEBUG_OUTPUT);
		return;
	end

	-- create chars friends list and copy the faction friends list over
	local realm = GetRealmName();
	holo_list[realm][charname] = {};
	for fKey, fVal in pairs(HF_PlayerList) do
		HFF_ShareEntry(holo_list, charname, fKey, true, false, isFL, true);
	end

	-- remove the faction friends list, if all chars are separated
	local nlistall = table.getn(HoloFriendsFuncs_RealmGetAllFactionChars());
	local flist = HFF_RealmGetFactionChars(HOLOFRIENDS_LIST);
	local nflist = table.getn(flist);
	local ilist = HFF_RealmGetFactionChars(HOLOIGNORE_LIST);
	local nilist = table.getn(ilist);

	local fexist = false;
	for _, entry in pairs(flist) do
		if ( entry == faction ) then fexist = true; end
	end
	local iexist = false;
	for _, entry in pairs(ilist) do
		if ( entry == faction ) then iexist = true; end
	end

	local fdelete = false;
	if ( isFL and fexist and not iexist and (nlistall == nflist) ) then fdelete = true; end
	if ( not isFL and not fexist and iexist and (nlistall == nilist) ) then fdelete = true; end
	if ( fdelete ) then
		-- includes HoloFriendsShare_OnShow()
		HoloFriendsFuncs_DeleteChar(faction);
	else
		if ( isFL and fexist and iexist and (nlistall == nflist) ) then fdelete = true; end
		if ( not isFL and fexist and iexist and (nlistall == nilist) ) then fdelete = true; end
		if ( fdelete ) then holo_list[realm][faction] = nil; end
		HoloFriendsShare_OnShow(self);
	end

	-- reload the friends list, if actual player was separated
	if ( charname == UnitName("player") ) then
		if ( strsub(window,5,5) == "F" ) then
			HoloFriends_LoadList();
			HoloFriends_List_Update();
		end
		if ( strsub(window,5,5) == "I" ) then
			HoloIgnore_LoadList();
			HoloIgnore_List_Update();
		end
	end
end
