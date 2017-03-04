--[[
    Name:           Titan Mount
	Description:	Titan Panel plugin for mounting.
	Author:         Skydragon247
	Version:        7.5.1
    --]]
	
--Binding Variables
BINDING_HEADER_TITANPANELMOUNT = "Titan Panel [Mount]"
BINDING_NAME_TOGGLETITANMOUNT = "Toggle last mount"

local MountID = "Mount"
local MountVersion = "7.5.1"
--White
local MountC1 = "|cffffffff"
--Burgundy
local MountC2 = "|cff993300"
--Green
local MountC3 = "|cff00ff00"
--Yellow
local MountC4 = "|cffffcc00"
--Gray
local MountC5 = "|cff999999"
--Orange
local MountC6 = "|cffff8000"
local alphabet = {
					{letter = 'A', found = false, mountIDs = {}},
					{letter = 'B', found = false, mountIDs = {}},
					{letter = 'C', found = false, mountIDs = {}},
					{letter = 'D', found = false, mountIDs = {}},
					{letter = 'E', found = false, mountIDs = {}},
					{letter = 'F', found = false, mountIDs = {}},
					{letter = 'G', found = false, mountIDs = {}},
					{letter = 'H', found = false, mountIDs = {}},
					{letter = 'I', found = false, mountIDs = {}},
					{letter = 'J', found = false, mountIDs = {}},
					{letter = 'K', found = false, mountIDs = {}},
					{letter = 'L', found = false, mountIDs = {}},
					{letter = 'M', found = false, mountIDs = {}},
					{letter = 'N', found = false, mountIDs = {}},
					{letter = 'O', found = false, mountIDs = {}},
					{letter = 'P', found = false, mountIDs = {}},
					{letter = 'Q', found = false, mountIDs = {}},
					{letter = 'R', found = false, mountIDs = {}},
					{letter = 'S', found = false, mountIDs = {}},
					{letter = 'T', found = false, mountIDs = {}},
					{letter = 'U', found = false, mountIDs = {}},
					{letter = 'V', found = false, mountIDs = {}},
					{letter = 'W', found = false, mountIDs = {}},
					{letter = 'X', found = false, mountIDs = {}},
					{letter = 'Y', found = false, mountIDs = {}},
					{letter = 'Z', found = false, mountIDs = {}},
				 }
local dropdownFrames = {}
local TPMountSFM = true
local mount = nil
local mountID = nil
local gFavSelection1, gFavSelection2
local favSelection1, favSelection2, favSelection3
local TitanMountInitialLoad = true;
local gDropDown1, gDropDown2
local dropdown1, dropdown2, dropdown3
local _G = getfenv(0);

--Event fired when the addon is first loaded onto the UI
function TitanPanelMountButton_OnLoad(self)
    TitanPanelMountButton:RegisterEvent("ADDON_LOADED")
    TitanPanelMountButton:RegisterEvent("PLAYER_LOGOUT")
    self.registry = {
		id = MountID,
	    version = MountVersion,
        menuText = MountID,
        buttonTextFunction = "TitanPanelMountButton_GetButtonText",	
        category = "General",
        tooltipTitle = MountC4..MountID,
		tooltipTextFunction = "TitanPanelMountButton_GetTooltipText",
        iconButtonWidth = 16,
        iconWidth = 16,        
        savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,  
            ShowTooltipText = 1,
            ShowMenuOptions = 1,
            ShowAdvancedMenus = 1,                
            }}
			
	DetectUsableMounts()

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("CHAT_MSG_SYSTEM");
end


function DetectUsableMounts()
    local mountName, owned
	
	for i = 1, table.getn(alphabet) do
		--For each mount, do we have at least one mount beginning with the current letter in the alphabet (uppercase)?
		--First, check to make sure it isnt already set to true. That way we dont have to waste our time going through the entire list of mounts
		if not alphabet[i].found then
			--Lets do some searching bitches!
			local mounts = C_MountJournal.GetMountIDs()
			
			for j = 1, #mounts do
				--Get dat mount info we need...
				mountName, _, _, _, owned, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(mounts[j])
				
				--If the account owns the mount and it starts with the current letter we're on, set found to true for the letter
				if mountName ~= nil then
					if alphabet[i].letter == strupper(strsub(mountName, 1, 1)) and owned then
						alphabet[i].found = true
						table.insert(alphabet[i].mountIDs, mounts[j])
					end
				end
			end
		end
	end
end

function AddNewMountID(mountNamePassed)
	local mounts = C_MountJournal.GetNumMounts()

	for i = 1, #mounts do	
		local mountName, owned
		--Get dat mount info we need...
		mountName, _, _, _, owned, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(mounts[i])



		--If the account owns the mount and it starts with the current letter we're on, set found to true for the letter
		if mountNamePassed == mountName then
			local letter = strupper(strsub(mountName, 1, 1))
			
			--Got it, but do we have it (to prevent someone changing code and adding a mount they dont have)
			for j = 1, table.getn(alphabet) do
				if alphabet[j].letter == letter then
					--It could be a new letter, mark it as found
					if not alphabet[j].found then
						alphabet[j].found = true
					end
					
					--Got the letter, now add it to that letters list of mountIDs


					table.insert(alphabet[j].mountIDs, mounts[i])
						
					DetectUsableMounts()
					print(mountName.." was added to your Titan Panel [Mount] collection")
			
					return
				end
			end
		end
	end
end

local GetCurrentMount, GetMountInfo
do
    -- Helper functions for handling the information about mounts

    -- Return the name and icon of the currently summoned mount, in that order
    -- Returns nil for each if the player seems not to be mounted
    -- Also sets the mountNumber and mountID 
    function GetCurrentMount()
        local summoned, name, icon, creatureID, mounts
		mounts = C_MountJournal.GetMountIDs()
		
        for i = 1, #mounts do
            name, _, icon, active, _, _, _, _, _, _, _, creatureID  = C_MountJournal.GetMountInfoByID(mounts[i])
            if active then
                --mountNumber = i
				--So this is now the creatureID instead of a "spell"
                mountID = creatureID
                return name, icon
            end
        end
        return nil, nil
    end

-- Returns the information for the currently active mount
function GetMountInfo()
    local name, icon, creatureID, active
		
    if mountID == nil then
		print("MountID is nil")
        return nil, nil
    end
	
    name, _, icon, active, _, _, _, _, _, _, _, creatureID = C_MountJournal.GetMountInfoByID(mountID)
    if creatureID ~= mountID then
        if mountID == nil then
			--Should never happen, but just in case...
			--print("HERE")
            mountID = creatureID
        else
            local mounts = C_MountJournal.GetMountIDs()	

			for i = 1, #mounts do
                name, _, icon, active, _, _, _, _, _, _, _, creatureID  = C_MountJournal.GetMountInfoByID(mounts[i])
                if creatureID == mountID then
                    --mountNumber = i
					break
                end
            end
        end
    end
		
    return name, icon
	
    end
end

--Sets the text of the titan button
function TitanPanelMountButton_GetButtonText(event)
    local Button = TitanUtils_GetButton(MountID)
    local mountName, mountIcon, mountColor  
	
    -- No mounts found
    if C_MountJournal.GetNumMounts() == 0 then 
		mountName = "No Mounts Found"
        mountIcon = "Interface\\Icons\\INV_Misc_QuestionMark"
    -- Not mounted
    elseif IsMounted() == false then
		mountName = "None"
        mountIcon = "Interface\\minimap\\TRACKING\\StableMaster"
    -- On Taxi
    elseif UnitOnTaxi("player") then 
		mountName = "On Taxi"
        mountIcon = "Interface\\CURSOR\\taxi"
    -- Mounted, but not cached
    else
		mountName, mountIcon = GetCurrentMount()
    end
	
    if IsOutdoors() == nil then
        mountColor = MountC5
    else
        mountColor = MountC3
    end
	
    Button.registry.icon = mountIcon
	
    return "Mount: "..mountColor..mountName
end

--Sets the tooltip text shown when mousing over the titan button
function TitanPanelMountButton_GetTooltipText() 
    if IsMounted() then
        if mountID == nil then
            GetCurrentMount()
        end

        return MountC3.."Right-click for Mount Menu\n"..MountC3.."Double Left-click to Dismount"
    else
        if mountID == nil and (MountFirstTime == nil or MountFirstTime == 1) then
            return MountC3.."Right-click for Mount Menu\n"
        else
            local mountName
            mountName = GetMountInfo()
            return MountC3.."Right-click for Mount Menu\n"..MountC3.."Double Left-click to Recall "..MountC4..mountName
        end
    end
end

local PrepareMountSubMenu, ShowFavorite, ShowMenuButton
do
    -- Helper functions for building the menu

    -- Build the submenu for a selection of mounts
    -- Show only mounts belonging to the titleLetter passed
    function PrepareMountSubMenu(titleLetter)
        local MountTestName, owned, icon
        local StartChar
        local info = {}

		--Loop through the alphabet, find the letter which was passed in via the titleLetterParameter
		for i = 1, table.getn(alphabet) do
			if(alphabet[i].letter == titleLetter) then
				--Found the letter, now add that letters mounts...
				local numLetterIDs = table.getn(alphabet[i].mountIDs)
				
				--But first, check to see if there is more than 25 mountIDs for that given letter
				if numLetterIDs > 25 then
					--We have more than 25 mounts, how many full sets of 25 can we make, ergo - How many sub-submenus will we make?
					local numSubMenus = math.floor(numLetterIDs/25)
					local extras = numLetterIDs % 25
					
					if extras > 0 then
						numSubMenus = numSubMenus + 1
					end
					
					for j = 1, numSubMenus do
					info.text = titleLetter.."-"..j
					info.notCheckable = 1
					info.hasArrow = 1


					Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])  
					end
				else
					for j = 1, table.getn(alphabet[i].mountIDs) do
						MountTestName, _, icon, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(alphabet[i].mountIDs[j])
						info.text = MountTestName
						info.icon = icon
						info.notCheckable = 1
						info.func = function() TitanPanelMountButton_MountToggle(alphabet[i].mountIDs[j], MountTestName) end
						Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])  
					end
				end
				
				break
			end
		end
    end
	
	--Prepares the submenu for for the third dropdown in the event a letter has more than 25 mounts in it
	function PrepareSplitMountSubMenu(titleLetter, subNumber)
		local startNumber
		
		if tonumber(subNumber) > 1 then
			startNumber = ((tonumber(subNumber) - 1) * 25) + 1
		else
			startNumber = 1
		end
		
		for i = 1, table.getn(alphabet) do
			if(alphabet[i].letter == titleLetter) then
				for j = startNumber, tonumber(subNumber) * 25 do
					if j > table.getn(alphabet[i].mountIDs) then
						return
					else
						local info = {}
						MountTestName, _, icon, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(alphabet[i].mountIDs[j])
						info.text = MountTestName
						info.icon = icon
						info.notCheckable = 1
						info.func = function() TitanPanelMountButton_MountToggle(alphabet[i].mountIDs[j], MountTestName) end
						Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])  
					end
				end
			end
		end
	end
	
	-- Returns the correct index and spell number for a favorite
    function SaveFavoriteMounts()
		local favSelectID1, favSelectID2, favSelectID3
		local gFavSelectID1, gFavSelectID2
		
		local function GetMountInfoFromText(mountNamePassed)
			local mounts = C_MountJournal.GetMountIDs()
			for i = 1, #mounts do
				local mountName
				--Get dat mount info we need...
				mountName, _, _, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(mounts[i])
				--If the account owns the mount and it starts with the current letter we're on, set found to true for the letter
				if mountNamePassed == mountName then
					return C_MountJournal.GetMountIDs()[i]
				end
			end
		end
		
		if favSelection1 ~= nil then
			favSelectID1 = GetMountInfoFromText(favSelection1)
		end
		
		if favSelection2 ~= nil then
			favSelectID2 = GetMountInfoFromText(favSelection2)
		end
		
		if favSelection3 ~= nil then
			favSelectID3 = GetMountInfoFromText(favSelection3)
		end
		
		if gFavSelection1 ~= nil then
			gFavSelectID1 = GetMountInfoFromText(gFavSelection1)
		end
		
		if gFavSelection2 ~= nil then
			gFavSelectID2 = GetMountInfoFromText(gFavSelection2)
		end
		
		--Make sure it isn't the default text
		if gFavSelectID1 ~= nil then
			TitanMountGlobalFav1 = gFavSelectID1
			TitanMountGlobalFavName1 = gFavSelection1
		end
		
		if gFavSelectID2 ~= nil then
			TitanMountGlobalFav2 = gFavSelectID2
			TitanMountGlobalFavName2 = gFavSelection2
		end
		
		if favSelectID1 ~= nil then
			TitanMountFav1 = favSelectID1
			TitanMountFavName1 = favSelection1
		end
		
		if favSelectID2 ~= nil then
		  TitanMountFav2 = favSelectID2
		  TitanMountFavName2 = favSelection2
		end
		
		if favSelectID3 ~= nil then
		  TitanMountFav3 = favSelectID3
		  TitanMountFavName3 = favSelection3
		end
    end
	
	--Prepares the list of mounts for the favorites submenu on the favorite panel
	function PrepareMountFavoriteSubMenu(titleLetter, favoriteDropDown)
        local MountTestName, owned, icon
        local StartChar
        local info = {}

		local function FavoriteMountSelect(self, arg1)
			Lib_UIDropDownMenu_SetSelectedID(favoriteDropDown, self:GetID())
			local dropDownName = favoriteDropDown:GetName()
			
			if dropDownName == "DropDownFav1" then
				favSelection1 = arg1
			elseif dropDownName == "DropDownFav2" then
				favSelection2 = arg1
			elseif dropDownName == "DropDownFav3" then
				favSelection3 = arg1
			elseif dropDownName == "GlobalDropDownFav1" then
				gFavSelection1 = arg1
			elseif dropDownName == "GlobalDropDownFav2" then
				gFavSelection2 = arg1
			end
		end
		
		--Loop through the alphabet, find the letter which was passed in via the titleLetterParameter
		for i = 1, table.getn(alphabet) do
			if(alphabet[i].letter == titleLetter) then
				--Found the letter, now add that letters mounts...
				for j = 1, table.getn(alphabet[i].mountIDs) do
					MountTestName, _, icon, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(alphabet[i].mountIDs[j])
					info.text = MountTestName
					info.icon = icon
					info.func = FavoriteMountSelect
					info.arg1 = MountTestName
					Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])  
				end
				
				break
			end
		end
    end
       
    
	--Shows a particular character favorite, if it exists, otherwise shows a button to the favorite panel
    function ShowFavorite(favorite, number)
        local info = {}
        if favorite == nil then
            info.text = MountC3.."Favorite #"..number
            info.notCheckable = 0
			info.func = function() ShowFavoriteAddMenu() end
        else
            local name, checked, icon
            --Does the name and the ID match one another?
			name, _, icon, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(favorite)
			
			if name ~= nil then
				info.text = MountC3..name
				info.icon = icon
				info.notCheckable = 1
				info.func = function() TitanPanelMountButton_MountToggle(favorite, name) end
			end
        end
		
        Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])
    end
	
	--Shows a particular account favorite, if it exists, otherwise shows a button to the favorite panel
	function ShowGlobalFavorite(favorite, number)
        local info = {}
        if favorite == nil then
            info.text = MountC3.."Account Favorite #"..number
            info.notCheckable = 0
			info.func = function() ShowFavoriteAddMenu() end
        else
            local name, checked, icon
            name, _, icon, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(favorite)
			
			if name ~= nil then
				info.text = MountC3..name
				info.icon = icon
				info.notCheckable = 1
				info.func = function() TitanPanelMountButton_MountToggle(favorite, name) end
			end
        end
		
        Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])
    end

	function CheckFavoriteID(favoriteID, favoriteName)
		local name, icon
		
		name, _, icon, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(favorite)	
	end
	
	--Sets prepares all dynamic frames for the favorite panel
	--This includes name label and all mount dropdowns
	--Called OnLoad
	function LoadFavoriteDropDowns(self)
		local name = UnitName("player")
		
		charLabel = TitanMountSpacer2:CreateFontString("CharLabel", "ARTWORK", "SystemFont_Small")
		charLabel:SetText(name)
		charLabel:SetTextColor(1, .82, 0)
		charLabel:SetPoint("Center", -10, 9)
	
		gDropDown1 = CreateFrame("Frame", "GlobalDropDownFav1", self, "Lib_UIDropDownMenuTemplate")
		gDropDown1:SetPoint("Center", 55, 110)
		Lib_UIDropDownMenu_SetWidth(gDropDown1, 200)
		Lib_UIDropDownMenu_SetText(gDropDown1, "Select Account Favorite Mount #1")
		
		gDropDown2 = CreateFrame("Frame", "GlobalDropDownFav2", self, "Lib_UIDropDownMenuTemplate")
		gDropDown2:SetPoint("Center", 55, 70)
		Lib_UIDropDownMenu_SetWidth(gDropDown2, 200)
		Lib_UIDropDownMenu_SetText(gDropDown2, "Select Account Favorite Mount #2")
		
		dropdown1 = CreateFrame("Frame", "DropDownFav1", self, "Lib_UIDropDownMenuTemplate")
		dropdown1:SetPoint("Center", 55, -90)
		Lib_UIDropDownMenu_SetWidth(dropdown1, 200)
		Lib_UIDropDownMenu_SetText(dropdown1, "Select Favorite Mount #1")
		
		dropdown2 = CreateFrame("Frame", "DropDownFav2", self, "Lib_UIDropDownMenuTemplate")
		dropdown2:SetPoint("Center", 55, -130)
		Lib_UIDropDownMenu_SetWidth(dropdown2, 200)
		Lib_UIDropDownMenu_SetText(dropdown2, "Select Favorite Mount #2")
		
		dropdown3 = CreateFrame("Frame", "DropDownFav3", self, "Lib_UIDropDownMenuTemplate")
		dropdown3:SetPoint("Center", 55, -170)
		Lib_UIDropDownMenu_SetWidth(dropdown3, 200)
		Lib_UIDropDownMenu_SetText(dropdown3, "Select Favorite Mount #3")
	end
	
	--Initializes display of favorite panel when it is show
	function ShowFavoriteAddMenu()
		local function initialize(self, level)
			if level == 1 then
				for i = 1, table.getn(alphabet) do
					if alphabet[i].found then
						ShowMenuButton(alphabet[i].letter)
					end
				end
			elseif level == 2 then
				for i = 1, table.getn(alphabet) do
					--Match the MENU_VALUE to the letter in the alphabet
					if _G["LIB_UIDROPDOWNMENU_MENU_VALUE"] == alphabet[i].letter then
						--Prepare the mounts!
						PrepareMountFavoriteSubMenu(alphabet[i].letter, self)
					end
				end
			end
		end
		
		Lib_UIDropDownMenu_Initialize(GlobalDropDownFav1, initialize)
		Lib_UIDropDownMenu_Initialize(GlobalDropDownFav2, initialize)
		
		Lib_UIDropDownMenu_Initialize(DropDownFav1, initialize)
		Lib_UIDropDownMenu_Initialize(DropDownFav2, initialize)
		Lib_UIDropDownMenu_Initialize(DropDownFav3, initialize)
		
		if TitanMountGlobalFav1 ~= nil then
			name, _, _, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(TitanMountGlobalFav1)
			Lib_UIDropDownMenu_SetText(gDropDown1, name)
		end
		
		if TitanMountGlobalFav2 ~= nil then
			name, _, _, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(TitanMountGlobalFav2)
			Lib_UIDropDownMenu_SetText(gDropDown2, name)
		end
		
		if TitanMountFav1 ~= nil then
			name, _, _, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(TitanMountFav1)
			Lib_UIDropDownMenu_SetText(dropdown1, name)
		end
		
		if TitanMountFav2 ~= nil then
			name, _, _, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(TitanMountFav2)
			Lib_UIDropDownMenu_SetText(dropdown2, name)
		end
		
		if TitanMountFav3 ~= nil then
			name, _, _, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(TitanMountFav3)
			Lib_UIDropDownMenu_SetText(dropdown3, name)
		end
		
		TitanMountFavoriteDialog:Show();
	end
	
    -- Creates the menu button for a submenu with title passed
    function ShowMenuButton(title)
        local info = {}
        info.text = title
        info.func = nil
        info.value = title
        info.notCheckable = 1
        info.hasArrow = 1
        Lib_UIDropDownMenu_AddButton(info, 1)
    end
end

--Controls how the level 1 and level 2 right click menu is displayed. Each "Arrow Over" is another menu level. 
function TitanPanelRightClickMenu_PrepareMountMenu()
        if _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"] == 2 then
			if _G["LIB_UIDROPDOWNMENU_MENU_VALUE"] == "Display Options" then
				local info = {}       
				info.text = "Button with Icon and Text"
				info.value = nil
				info.checkable = 1
				info.keepShownOnClick = 1
				Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])
					
				info.text = "Button with Icon"
				info.value = nil
				info.checkable = 1
				info.keepShownOnClick = 1
				Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])
				
				info.text = "Button with Text"
				info.value = nil
				info.checkable = 1
				info.keepShownOnClick = 1
				Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])
			else
				-- We're in a submenu, build it
				for i = 1, table.getn(alphabet) do
					--Match the MENU_VALUE to the letter in the alphabet
					if _G["LIB_UIDROPDOWNMENU_MENU_VALUE"] == alphabet[i].letter then
						--Prepare the mounts!
						PrepareMountSubMenu(alphabet[i].letter)
					end
				end
			end
		elseif _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"] == 3 then
			-- We're in a sub-submenu, build it
			for i = 1, table.getn(alphabet) do
				--Match the MENU_VALUE to the letter in the alphabet
				if strupper(strsub(_G["LIB_UIDROPDOWNMENU_MENU_VALUE"], 1, 1)) == alphabet[i].letter then
					--Get the number from the MENU_VALUE
					local subNumber = strsub(_G["LIB_UIDROPDOWNMENU_MENU_VALUE"], -1, string.len(_G["LIB_UIDROPDOWNMENU_MENU_VALUE"]))
					
					PrepareSplitMountSubMenu(alphabet[i].letter, subNumber)
				end
			end
        else
            -- Build the main menu
            TitanPanelRightClickMenu_AddTitle("Mounts")    
            TitanPanelRightClickMenu_AddSpacer()
        
			ShowGlobalFavorite(TitanMountGlobalFav1, 1)
			ShowGlobalFavorite(TitanMountGlobalFav2, 2)  
            TitanPanelRightClickMenu_AddSpacer()
			
            ShowFavorite(TitanMountFav1, 1)
            ShowFavorite(TitanMountFav2, 2)
            ShowFavorite(TitanMountFav3, 3)
           
            TitanPanelRightClickMenu_AddSpacer()
            
			--Ok, now iterate through the alphabet again, adding only the letters in which we've found existing, usable mounts
			for i = 1, table.getn(alphabet) do
				if alphabet[i].found then
					ShowMenuButton(alphabet[i].letter)
				end
			end

            TitanPanelRightClickMenu_AddSpacer()
        
            -- The Favorite Dialog button
            if TitanMountFav3 ~= nil or TitanMountFav2 ~= nil or TitanMountFav1 ~= nil then
                local info = {}       
                info.text = "Open Favorite Menu"
                info.value = nil
				info.notCheckable = 1
                info.func = function() ShowFavoriteAddMenu() end
                Lib_UIDropDownMenu_AddButton(info, _G["LIB_UIDROPDOWNMENU_MENU_LEVEL"])
            end
          
            TitanPanelRightClickMenu_AddToggleIcon(MountID)
		end   
end
 
function TitanPanelMountButton_MountToggle(i, passedName)
	--local name
    if (not IsModifierKeyDown()) then
	    local name, usable
		name, _, _, _, usable, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(i)
		if(not usable and name == passedName) then
		    --This should prevent issues which cause cross factions to not work (Traveler's Tundra Mammoth)
			local mounts = C_MountJournal.GetMountIDs()
			for num = 1, #mounts do
				name, _, _, _, usable, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(mounts[num])		
				if name == passedName and usable then
					i = mounts[num]
					break;
				end
			end		
		end
		
        C_MountJournal.SummonByID(i)
						
        TitanUtils_CloseRightClickMenu()
        mountID = i
		MountNumberOver = mountID
		MountFirstTime = 0
    end
end

--Fired when the titan button is double clicked
function TitanPanelMountButton_OnDoubleClick(button)
    if IsMounted() then
        Dismount()
    elseif button == "LeftButton" and mountID ~= nil then
        GetMountInfo()
        C_MountJournal.SummonByID(mountID)
    end
end

--Fired when the key binding is toggled and summons the last used mount if it existed
function TitanPanelMountBindingToggle()
    if IsMounted() then
        Dismount()
    elseif mountID ~= nil then
        GetMountInfo()
		C_MountJournal.SummonByID(mountID)
		print(mountID)
    end
end

--Various OnEvent handlers...
function TitanPanelMountButton_OnEvent(self, event, arg1, ...)

	if event =="CHAT_MSG_SYSTEM" then
		if strsub(arg1, 1, 25) == "You have added the mount " then
			local mounText
			mountText = string.gsub(arg1, "You have added the mount ", "")
			mountText = string.gsub(mountText, " to your collection.", "")
			
			--Now we have the name of the mount. Look er' up
			AddNewMountID(mountText)
			
			return;
		end
	end
	
    if event == "ADDON_LOADED" then
        if MountNumberOver ~= nil and MountFirstTime == 0 then
			mountID = MountNumberOver
		end
		return;
    end  
	
    if event == "PLAYER_LOGOUT" then
		TitanMountInitialLoad = true;
		MountNumberOver = mountID
		return;
    end
	
	if event == "PLAYER_ENTERING_WORLD" then
		if TitanMountInitialLoad then
			DEFAULT_CHAT_FRAME:AddMessage(MountC4.."Titan Panel ["..MountID.."] "..MountC3..MountVersion..MountC4.." by "..MountC6.."Skydragon247")
			
			--Check the favorites on load. When a new patch comes out new mounts are released and can throw off the users selected favorite
			TitanMountGlobalFavName1, TitanMountGlobalFav1 = CompareFavoriteNameAndID(TitanMountGlobalFavName1, TitanMountGlobalFav1)
			TitanMountGlobalFavName2, TitanMountGlobalFav2 = CompareFavoriteNameAndID(TitanMountGlobalFavName2, TitanMountGlobalFav2)
			
			TitanMountFavName1, TitanMountFav1 = CompareFavoriteNameAndID(TitanMountFavName1, TitanMountFav1)
			TitanMountFavName2, TitanMountFav2 = CompareFavoriteNameAndID(TitanMountFavName2, TitanMountFav2)
			TitanMountFavName3, TitanMountFav3 = CompareFavoriteNameAndID(TitanMountFavName3, TitanMountFav3)
		end
		
		DetectUsableMounts()
		
		TitanMountInitialLoad = false
		
		return;
    end
end

function CompareFavoriteNameAndID(favoriteName, favoriteID)
	if favoriteID ~= nil and favoriteName ~= nil then
		--Grab the favorite we have now..
		local name, usable
		name, _, _, _, usable, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(favoriteID)
		--Is the name we have now = to the name returned
		if name ~= favoriteName then	
			--print("Synchronizing Mount Name and ID...")
			--print("Mount ID: "..favoriteID)
			--print("Searching for match...")
			local mounts = C_MountJournal.GetMountIDs()
			for i = 1, #mounts do
				name, _, icon, _, usable, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(mounts[i])		
				if name == favoriteName then
					--print("Match found: "..favoriteName..": ID - "..i.." - Saved")
					--Got the names to match, grab what would be the new ID
					favoriteID = mounts[i]
					break;
				end
			end
		else
			--print("Mount Name and ID Match")
		end
	elseif favoriteName == nil and favoriteID ~= nil then
		--We have no set name but we have an ID - post release condition
		--print("Setting blank mount name from saved ID")
		--print("ID is "..favoriteID)
		local name
		name, _, icon, _, _, _, _, _, _, _, _  = C_MountJournal.GetMountInfoByID(favoriteID)
		--print("Name is ".. name)
		if name ~= nil then
			favoriteName = name
		else		
			favoriteID = nil
		end
		--print("Saved")
	elseif favoriteName == nil and favoriteID == nil then
		--print("No Favorite Selected - Continue")
	end
	
	return favoriteName, favoriteID
end

function TitanPanelMountButton_OnUpdate(self)         
    TitanPanelButton_UpdateButton(MountID)
end
