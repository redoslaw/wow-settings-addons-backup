
local frame = CreateFrame("Frame")
local bSetSwappingGear = false
local sCurrentSpec = ""
frame:RegisterUnitEvent("EQUIPMENT_SWAP_FINISHED")
frame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED","player")
frame:RegisterUnitEvent("PLAYER_ENTERING_WORLD")

--added slashcommands for Silent Mode
SLASH_AUTOGEARSWAP1, SLASH_AUTOGEARSWAP2 = '/autogearswap', '/ags';
local function AutoGearSwap_CommandHandler(msg, editbox)
-- AutoGearSwapPrefs["AUTOGEARSWAP_SILENCE_MODE"]
 if msg == 'silence on' then
  print("|cA330C900AutoGearSwap|r: Addon silenced")
  AutoGearSwapPrefs["AUTOGEARSWAP_SILENCE_MODE"] = false
 elseif msg == 'silence off' then
  print("|cA330C900AutoGearSwap|r: Addon feedback enabled")
  AutoGearSwapPrefs["AUTOGEARSWAP_SILENCE_MODE"] = true
 end
end
SlashCmdList["AUTOGEARSWAP"] = AutoGearSwap_CommandHandler-- Also a valid assignment strategy

-- Local function to print if it is enabled
local function AutoGearSwap_Print(sToPrint)
	if not AutoGearSwapPrefs or AutoGearSwapPrefs == nil then
		AutoGearSwapPrefs = {}
		AutoGearSwapPrefs["AUTOGEARSWAP_SILENCE_MODE"] = true
	end
	if AutoGearSwapPrefs["AUTOGEARSWAP_SILENCE_MODE"] == nil then
		AutoGearSwapPrefs["AUTOGEARSWAP_SILENCE_MODE"] = true
	end
	if AutoGearSwapPrefs["AUTOGEARSWAP_SILENCE_MODE"] == true then
		print("|cA330C900AutoGearSwap|r: "..sToPrint)
	end
end

--Get the texture for a equipment set gear
local function AutoGearSwap_GetGearSetIconByName(gearname)
	if gearname and gearname ~= nil then
		local icon, setID, isEquipped, numItems, numEquipped, unknown, numMissing, numIgnored = GetEquipmentSetInfoByName(gearname)
		if string.find(icon,"INV_MISC") == nil then
			return(icon)
		else
			return("Interface\\icons\\"..icon)
		end
	end
end


local function AutoGearSwap_OnEvent(self, event,...)
		local currspec = GetSpecialization()
		if currspec then
				local id, name, description, icon, background, role = GetSpecializationInfo(currspec)

				if not AutoGearSwapPrefs or AutoGearSwapPrefs == nil then
					AutoGearSwapPrefs = {}
					AutoGearSwapPrefs["AUTOGEARSWAP_SILENCE_MODE"] = true
				end
				if name ~= nil and name then
					if event == "PLAYER_SPECIALIZATION_CHANGED" then
						if sCurrentSpec ~= name then
							if AutoGearSwapPrefs[currspec] == nil then
									AutoGearSwap_Print("No Gear Set for "..name.." |T"..icon..":16|t. Swap to a set in Equipment Manager and this add-on will remember it in future.")
							else				
									AutoGearSwap_Print("Spec changed to "..name.." |T"..icon..":16|t equipped gear set: |T"..AutoGearSwap_GetGearSetIconByName(AutoGearSwapPrefs[currspec])..":16|t ["..AutoGearSwapPrefs[currspec].."]")			
									bSetSwappingGear = true
									UseEquipmentSet(AutoGearSwapPrefs[currspec])
							end
						end
						sCurrentSpec = name
					elseif event == "EQUIPMENT_SWAP_FINISHED" then
						local success,currset = ...
						if bSetSwappingGear == false then
								AutoGearSwap_Print("Equipped set |T"..AutoGearSwap_GetGearSetIconByName(currset)..":16|t ["..currset.."] assigned to Spec "..name.." |T"..icon..":16|t")
								AutoGearSwapPrefs[currspec] = currset							
						end
						bSetSwappingGear = false
					elseif event == "PLAYER_ENTERING_WORLD" then
						sCurrentSpec = name
					end
				end
		end
end


frame:SetScript("OnEvent",AutoGearSwap_OnEvent)
