local autoloot = select(2,...)

autoloot.blacklist_loot = {nil}    
autoloot.history_tmp = {nil}    
autoloot.history_items = {nil}    
autoloot.history_items_anzahl = {nil}    
autoloot.history_items_quantity = {nil}    
autoloot.history_blacklist_items= {nil}
autoloot.lootwindow_ingame_location_table = {nil}

autoloot.start_pos = -250

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN") 
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		if show_rolled_at_loot_display_toc == nil then 
			autoloot.autoloot_enabled = true
			autoloot.autoloot_quality_int = -1
			autoloot.history_enabled = false
			autoloot.minimap_position = 45
			autoloot.blacklist_enabled = false
			autoloot.autorepair_enabled = false
			autoloot.blacklist_lootlog = false
			autoloot.disable_raid = false
			autoloot.whisper_msg = ""
			autoloot.whisper_respond = false
			autoloot.disable_group = false
			autoloot.loot_display_ingame = true
			autoloot.min_item_price = -1 
			autoloot.min_item_price_job = false
			autoloot.fadein_time = 1
			autoloot.fadeout_time = 2
			autoloot.stay_time = 4
			autoloot.icon_size = 32
			autoloot.font_size = 160
			autoloot.autoroll_job = false
			autoloot.autoroll_green = 1337
			autoloot.autoroll_blue = 1337
			autoloot.blacklist_invert = false
			autoloot.blacklist_lootlog_invert = false
			autoloot.show_rolled_at_loot_display = false 
			lootwindow:SetPoint("CENTER", nil, "CENTER", 0, 0)
		else
			if autoloot.autoloot_enabled == nil then
				autoloot.autoloot_enabled = autoloot_job
				autoloot.autoloot_quality_int = autoloot_quality
				autoloot.history_enabled = history_job
				autoloot.minimap_position = minimap_pos
				autoloot.autorepair_enabled = autorepair_job
				autoloot.blacklist_enabled = blacklist_job
				autoloot.blacklist_lootlog = lootlog_blacklist_job
				autoloot.disable_raid = loot_raid
				autoloot.whisper_msg = whisper_msg_toc
				autoloot.whisper_respond = whisper_trigger
				autoloot.disable_group = loot_group
				autoloot.loot_display_ingame = loot_display_toc
				autoloot.fadein_time = tonumber(loot_display_fadein)
				autoloot.fadeout_time = tonumber(loot_display_fadeout)
				autoloot.stay_time = tonumber(loot_display_staytime)
				autoloot.icon_size = tonumber(icon_size_toc)
				autoloot.font_size = tonumber(font_size_toc)
				autoloot.min_item_price = loot_by_gold
				autoloot.min_item_price_job = loot_by_gold_job
				autoloot.autoroll_job = autoroll_job
				autoloot.autoroll_blue = autoroll_quality_blue
				autoloot.autoroll_green = autoroll_quality_green
				autoloot.blacklist_invert = invert_blacklist_toc
				autoloot.blacklist_lootlog_invert = invert_blacklist_lootlog_toc
				autoloot.show_rolled_at_loot_display = show_rolled_at_loot_display_toc
			
				for i=0, autoloot.arrays_size do
					 autoloot.blacklist_loot[i] = blacklist_itemtable[i]
					 autoloot.history_blacklist_items[i] = lootlog_blacklist_items[i]
				end
				
				for i=0, 5 do
					 autoloot.lootwindow_ingame_location_table[i] = loot_display_location[i]
				end
			end
		end
		autoloot.get_lang()
		SetCVar("autoLootDefault", 0)
	end
end)

local history_counter = 0

local frame = CreateFrame("Frame")
frame:RegisterEvent("LOOT_OPENED")
frame:SetScript("OnEvent", function(self, event, ...)
		if event == "LOOT_OPENED" then
				autoloot.start_pos = -250		
			
				if autoloot.autoloot_enabled == true then
				
					if autoloot.disable_raid == true then
						isRaid = IsInRaid()
					else
						isRaid = false
					end
					if autoloot.disable_group == true then
						isGroup = IsInGroup()
					else
						isGroup = false
					end
					if isRaid == false and isGroup == false then
					
					local target_loot_max = GetNumLootItems()
					local lootcounter = 0
					history_counter = target_loot_max
					
					if target_loot_max > 0 then
						while lootcounter < target_loot_max do
							lootcounter = lootcounter + 1
							local target_loot_path, target_loot_name, target_loot_quantity, target_loot_quality = GetLootSlotInfo(lootcounter)
							local seen = 0
								if target_loot_quality > autoloot.autoloot_quality_int then 
									if autoloot.blacklist_enabled == true and autoloot.blacklist_invert == false then
									
										for i = 0, autoloot.arrays_size do
											if autoloot.blacklist_loot[i] == target_loot_name then
												seen = 1
												break
											else
											seen = 0
											end
										end
										
									elseif autoloot.blacklist_enabled == true and autoloot.blacklist_invert == true then
								
										for i = 0, autoloot.arrays_size do
											if autoloot.blacklist_loot[i] ~= target_loot_name then
												seen = 1
											else
												seen = 0
												break
											end
										end
									elseif autoloot.blacklist_enabled == false then
									seen = 0
								end
								
								if seen == 0 then
									local test_var, test_var, test_var, test_var, test_var, test_var, test_var, test_var, test_var, test_var, itemSellPrice = GetItemInfo(target_loot_name or target_loot_name or target_loot_name or target_loot_name)
									if itemSellPrice ~= nil and itemSellPrice >= tonumber(autoloot.min_item_price*10000) and autoloot.min_item_price_job == true then
										LootSlot(lootcounter)
									elseif autoloot.min_item_price_job == false then
										LootSlot(lootcounter)
									else
									end
								end
								
								if autoloot.history_enabled == true and target_loot_quantity ~= 0 and target_loot_quantity ~= nil then
									autoloot.history_tmp[lootcounter] = target_loot_name
									autoloot.history_items_quantity[lootcounter] = target_loot_quantity
								end
											
								if autoloot.loot_display_ingame == true then
									test_print_icon(target_loot_path,target_loot_name,target_loot_quantity,target_loot_quality)
								end
						end
					end
				end	
			CloseLoot();
			end
		end
	end
end)



local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGOUT" then
		save_savedvariables()
	end
end)

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_WHISPER")
frame:SetScript("OnEvent", function(self, event, sender, msg)
	if event == "CHAT_MSG_WHISPER" and autoloot.whisper_respond == true and autoloot.whisper_msg ~= "" then
		SendChatMessage("Autoloot || "..autoloot.whisper_msg, "WHISPER", nil, msg);
	else
	end
end)



local frame = CreateFrame("Frame")
frame:RegisterEvent("LOOT_CLOSED")
frame:SetScript("OnEvent", function(self, event, ...)

	if event == "LOOT_CLOSED" and autoloot.history_enabled == true then
	
	autoloot.start_pos = -250
	
	if my_money == nil then
			get_money()
	end
	
	
	if history_counter ~= nil then
		for c = 1, history_counter do
			set = false
			local seen = 0
			for i=1, autoloot.arrays_size do
				if autoloot.blacklist_lootlog == true and autoloot.blacklist_lootlog_invert == false then
					for i = 1, autoloot.arrays_size do
						if autoloot.history_blacklist_items[i] == autoloot.history_tmp[c] then
							seen = 1
							break
						elseif seen == 0 then
							if autoloot.history_items[i] == autoloot.history_tmp[c] and set == false and autoloot.history_items_quantity[c] ~= 0 and autoloot.history_items_quantity[c] ~= nil then
								autoloot.history_items_anzahl[i] = autoloot.history_items_anzahl[i] + autoloot.history_items_quantity[c] 
								set = true
							elseif autoloot.history_items[i] == nil and set == false then
								autoloot.history_items[i] = autoloot.history_tmp[c]
								autoloot.history_items_anzahl[i] = autoloot.history_items_quantity[c]
								set = true
							end
						end
					end
				elseif autoloot.blacklist_lootlog == true and autoloot.blacklist_lootlog_invert == true then
					for i = 1, autoloot.arrays_size do
						if autoloot.history_blacklist_items[i] ~= autoloot.history_tmp[c] then
							seen = 1
							break
						elseif seen == 0 then
							if autoloot.history_items[i] == autoloot.history_tmp[c] and set == false and autoloot.history_items_quantity[c] ~= 0 and autoloot.history_items_quantity[c] ~= nil then
								autoloot.history_items_anzahl[i] = autoloot.history_items_anzahl[i] + autoloot.history_items_quantity[c] 
								set = true
							elseif autoloot.history_items[i] == nil and set == false then
								autoloot.history_items[i] = autoloot.history_tmp[c]
								autoloot.history_items_anzahl[i] = autoloot.history_items_quantity[c]
								set = true
							end
						end
					end
				elseif autoloot.blacklist_lootlog == false then
					if autoloot.history_items[i] == autoloot.history_tmp[c] and set == false and autoloot.history_items_quantity[c] ~= 0 and autoloot.history_items_quantity[c] ~= nil then
						autoloot.history_items_anzahl[i] = autoloot.history_items_anzahl[i] + autoloot.history_items_quantity[c] 
						set = true
					elseif autoloot.history_items[i] == nil and set == false then
						autoloot.history_items[i] = autoloot.history_tmp[c]
						autoloot.history_items_anzahl[i] = autoloot.history_items_quantity[c]
						set = true
					end
				end
			end	
		end  
		autoloot.history_tmp = {nil}   
		autoloot.history_items_quantity = {nil}
		history_counter = 0
	end
	end
end)

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_MONEY")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_MONEY" and autoloot.history_enabled == true then
		get_money_after_loot()
		money_calculate_new()
	end
end)


local frame = CreateFrame("Frame")
frame:RegisterEvent("START_LOOT_ROLL")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "START_LOOT_ROLL" and autoloot.autoroll_job == true then
		if autoloot.disable_raid == true then
				isRaid = IsInRaid()
			else
				isRaid = false
			end
			if autoloot.disable_group == true then
				isGroup = IsInGroup()
			else
				isGroup = false
			end
			if isRaid == false and isGroup == false then
				local RollID = select(1, ...)
				iicon, iname, test_var, quality, test_var, test_var , test_var , canDisenchant  = GetLootRollItemInfo(RollID);
				local ilink = GetLootRollItemLink(RollID)
				local roll_iname = "|cFF00FF00 Gruppe: |r"..iname
				if autoloot.show_rolled_at_loot_display == true then
				test_print_icon(iicon,roll_iname,1,quality)
				end
				if quality == 2 then
					if autoloot.autoroll_green == 3 and canDisenchant == 1 then
						RollOnLoot(RollID,autoloot.autoroll_green)
						print_autoroll_rolled_msg(ilink, quality)
					elseif autoloot.autoroll_green == 3 and canDisenchant ~= 1 then
						print(autoloot.cached_lang[72])
					elseif autoloot.autoroll_green ~= 3 then
						RollOnLoot(RollID,autoloot.autoroll_green);
						print_autoroll_rolled_msg(ilink, quality)
					elseif autoloot.autoroll_green == 1337 then
					end
				elseif quality == 3 then
					if autoloot.autoroll_blue == 3 and canDisenchant == 1 then
						RollOnLoot(RollID,autoloot.autoroll_blue);
						print_autoroll_rolled_msg(ilink, quality)
					elseif autoloot.autoroll_blue == 3 and canDisenchant ~= 1 then
						print(autoloot.cached_lang[72])
					elseif autoloot.autoroll_blue ~= 3 then
						RollOnLoot(RollID,autoloot.autoroll_blue);
						print_autoroll_rolled_msg(ilink, quality)
					elseif autoloot.autoroll_blue == 1337 then
				end
			else 
		end
	end
end
end)

local f = CreateFrame("Frame")
f:RegisterEvent("CONFIRM_LOOT_ROLL")
f:SetScript("OnEvent",function(self,event,...)
  if event == "CONFIRM_LOOT_ROLL" then
	local RollID = select(1, ...)
    local roll = select(2, ...)
    ConfirmLootRoll(RollID, roll)
  end   
end)

local f = CreateFrame("Frame")
f:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
f:SetScript("OnEvent",function(self,event,...)
  if event == "CONFIRM_DISENCHANT_ROLL" then
	local RollID = select(1, ...)
    local roll = select(2, ...)
	if roll == 3 then
    ConfirmLootRoll(RollID, roll)
	end
  end   
end)


SLASH_AUTOLOOT1, SLASH_AUTOLOOT2 = '/al', '/autoloot';
local function handler(msg, editbox)
		Main_Frame:Show();
			close_icon:Show()
			need_help_icon:Show()
			autoroll_start_icon:Show()
			min_gold_editbox:SetText(autoloot.min_item_price)
			Main_Frame_editbox:SetText(autoloot.cached_lang[32])
			lootlog_editbox:SetText(autoloot.cached_lang[32])
			whispermsg_editbox:SetText(autoloot.cached_lang[28])
			text_load_main_frame()
end
SlashCmdList["AUTOLOOT"] = handler;


