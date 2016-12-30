local autoloot = select(2,...)

local blacklist_index_current = 0 
local lootlog_current_index = 0 
local word_cache_size = 88
autoloot.addon_name = "|cFF00FF00 Autoloot |r | "
local addon_version = "1.2 Release"
local curse_downloadlink = "http://www.curse.com/addons/wow/autoloot1337"
autoloot.arrays_size = 12


function convert_quality_to_int()
	if autoloot.autoloot_quality_string == "all" then
		autoloot.autoloot_quality_int = -1
	elseif autoloot.autoloot_quality_string == "white" then
		autoloot.autoloot_quality_int = 0
	elseif autoloot.autoloot_quality_string == "green" then
		autoloot.autoloot_quality_int = 1
	elseif autoloot.autoloot_quality_string == "blue" then
		autoloot.autoloot_quality_int = 2
	end
end

function blacklist_add(item)
	local blacklist_next_empty = nil 
	for i = 1, autoloot.arrays_size do
		if autoloot.blacklist_loot[i] == nil then
			blacklist_next_empty = i 
			break
		end
	end
	local itemName, test_var, test_var, test_var, test_var, test_var, test_var, test_var, test_var, itemTexture, itemSellPrice = GetItemInfo(item or item or item or item)
	if itemName == nil then 
		print(autoloot.addon_name..autoloot.cached_lang[7])	
	elseif autoloot.blacklist_loot[i] == nil then
		autoloot.blacklist_loot[blacklist_next_empty] = itemName
		Blacklist_text:SetText(tostring(blacklist_next_empty).."         "..autoloot.blacklist_loot[blacklist_next_empty]);
		get_item_texture(autoloot.blacklist_loot[blacklist_next_empty],1)
	end
end


function blacklist_print_up()

	if blacklist_index_current <= autoloot.arrays_size -1 then
		blacklist_index_current = blacklist_index_current + 1
		local full_item = nil
		local n_string = tostring(blacklist_index_current)
		get_item_texture(autoloot.blacklist_loot[blacklist_index_current],1)
		if autoloot.blacklist_loot[blacklist_index_current] ~= nil then
			full_item = n_string.."         "..autoloot.blacklist_loot[blacklist_index_current]
			Blacklist_text:SetText(full_item)
		elseif autoloot.blacklist_loot[blacklist_index_current] == nil then
			full_item = n_string.."         "..autoloot.cached_lang[16]
			Blacklist_text:SetText(full_item)
			blacklist_icon_al:Hide()
		end
	else
	end
end

function blacklist_print_down()
		if blacklist_index_current >= 2 then
			blacklist_index_current = blacklist_index_current - 1
			local full_item = nil
			local n_string = tostring(blacklist_index_current)
			get_item_texture(autoloot.blacklist_loot[blacklist_index_current],1)
			if autoloot.blacklist_loot[blacklist_index_current] ~= nil then
				full_item = n_string.."         "..autoloot.blacklist_loot[blacklist_index_current]
				Blacklist_text:SetText(full_item)
			elseif autoloot.blacklist_loot[blacklist_index_current] == nil then
				full_item = n_string.."         "..autoloot.cached_lang[16]
				Blacklist_text:SetText(full_item)
				blacklist_icon_al:Hide()
			end
		else
	end
end

function blacklist_remove_entry()
	if autoloot.blacklist_loot[blacklist_index_current] ~= nil then
		print(autoloot.addon_name..autoloot.blacklist_loot[blacklist_index_current]..autoloot.cached_lang[9])
		autoloot.blacklist_loot[blacklist_index_current] = nil
		get_item_texture(nil,1)
	else
		print(autoloot.addon_name..autoloot.cached_lang[40])
	end
end

function check_minimap()
if IsShiftKeyDown() == false then

	if Main_Frame:IsShown() == true then
		main_frame_hide()
	elseif Main_Frame:IsShown() ~= true then
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
	
	else
	history_reset()
	end
end


function main_frame_hide()
	Main_Frame:Hide();
	blacklist_icon_al:Hide()
	history_blacklist_icon_al_:Hide()
	close_icon:Hide()
	need_help_icon:Hide()
	autoroll_start_icon:Hide()
end

function history_reset()
	autoloot.history_items = {nil}    
	autoloot.history_items_anzahl = {nil}    
	login_money = GetMoney();
end

function autoloot_minimapbutton_Reposition()
	autoloot_minimap_button:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(autoloot.minimap_position)),(80*sin(autoloot.minimap_position))-52)
end

function autoloot_minimap_button_on_update()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()
	xpos = xmin-xpos/UIParent:GetScale()+70
	ypos = ypos/UIParent:GetScale()-ymin-70
	autoloot.minimap_position = math.deg(math.atan2(ypos,xpos)) 
	autoloot_minimapbutton_Reposition()
end


function autoloot_minimap_button_on_enter()
	if IsShiftKeyDown() ~= true then
		GameTooltip:SetOwner(autoloot_minimap_button, "ANCHOR_BOTTOM");
		GameTooltip:AddLine("|cFF00FF00                     Autoloot |r");
		GameTooltip:AddLine(" ");
		if autoloot.autoloot_enabled == true then
			GameTooltip:AddLine("Auto-Loot : "..autoloot.cached_lang[2]);
		elseif autoloot.autoloot_enabled == false then
			GameTooltip:AddLine("Auto-Loot : "..autoloot.cached_lang[1]);
		end
		if autoloot.autoroll_job == true then
			GameTooltip:AddLine("Auto-Roll : "..autoloot.cached_lang[2]);
		elseif autoloot.autoroll_job == false then
			GameTooltip:AddLine("Auto-Roll : "..autoloot.cached_lang[1]);
		end
		if autoloot.autoloot_quality_int == -1 then
			GameTooltip:AddLine(autoloot.cached_lang[15].." : "..autoloot.cached_lang[3]);
		elseif autoloot.autoloot_quality_int == 0 then
			GameTooltip:AddLine(autoloot.cached_lang[15].." : "..autoloot.cached_lang[4]);
		elseif autoloot.autoloot_quality_int == 1 then
			GameTooltip:AddLine(autoloot.cached_lang[15].." : "..autoloot.cached_lang[5]);
		elseif autoloot.autoloot_quality_int == 2 then
			GameTooltip:AddLine(autoloot.cached_lang[15].." : "..autoloot.cached_lang[6]);
		end
		if autoloot.blacklist_enabled == false then
			GameTooltip:AddLine( "Blacklist : |r"..autoloot.cached_lang[1].."("..arrays_count_items("blacklist")..autoloot.cached_lang[10]..")");
		elseif autoloot.blacklist_enabled == true then
			GameTooltip:AddLine( "Blacklist : "..autoloot.cached_lang[2].."("..arrays_count_items("blacklist")..autoloot.cached_lang[10]..")");
		end
		if autoloot.history_enabled == true then
			GameTooltip:AddLine( "Itemlog : "..autoloot.cached_lang[2].."("..arrays_count_items("history")..autoloot.cached_lang[10]..")");
		elseif autoloot.history_enabled == false then
			GameTooltip:AddLine( "Itemlog : "..autoloot.cached_lang[1].."("..arrays_count_items("history")..autoloot.cached_lang[10]..")");
		end
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine("|cFF00FF00 LMB - |r"..autoloot.cached_lang[31]);
		GameTooltip:AddLine("|cFF00FF00 RMB - |r"..autoloot.cached_lang[33]);
		GameTooltip:AddLine("|cFF00FF00 Shift + LMB  - |r"..autoloot.cached_lang[44]);
		GameTooltip:AddLine("|cFF00FF00 Shift & Mouseover  - |r"..autoloot.cached_lang[34]);
		GameTooltip:Show();
	else
		lootlog_tooltiptest()
	end

end

function set_points_menue()
	local point, relativeTo, relativePoint, xOfs, yOfs = blacklist_checkbutton:GetPoint()
		Main_Frame_Lootlogg_Status:SetPoint("CENTER", "Main_Frame", "CENTER", xOfs - 61, yOfs - 20);
		lootlog_blacklist_checkbutton:SetPoint("CENTER", "Main_Frame", "CENTER", xOfs, yOfs - 20);
		history_title:SetPoint("CENTER", "Main_Frame", "CENTER", xOfs - 61, yOfs - 40);
		lootlog_checkbutton:SetPoint("CENTER", "Main_Frame", "CENTER", xOfs, yOfs - 40);
end

function arrays_count_items(array_name)
	local eintrage = 0
	if array_name == "blacklist" then
		for i=1, autoloot.arrays_size do
			if autoloot.blacklist_loot[i] ~= nil then
				eintrage = eintrage + 1 
			end
		end
	return eintrage
	elseif array_name == "history" then
		for i=1, autoloot.arrays_size do
			if autoloot.history_items[i] ~= nil then
				eintrage = eintrage + 1
			end
		end
	return eintrage
	end
end

function lootlog_blacklist_add(item) 
	for i = 1, autoloot.arrays_size do
		if autoloot.history_blacklist_items[i] == nil then
			lootlog_blacklist_next_empty = i 
			break
		end
	end
	local itemName, test_var, test_var, test_var, test_var, test_var, test_var, test_var, test_var, itemTexture, itemSellPrice = GetItemInfo(item or item or item or item)
	if itemName == nil then 
		print(autoloot.addon_name..autoloot.cached_lang[7])	
	elseif autoloot.history_blacklist_items[i] == nil then 
		autoloot.history_blacklist_items[lootlog_blacklist_next_empty] = itemName
		lootlog_blacklist_text:SetText(tostring(lootlog_blacklist_next_empty).."         "..autoloot.history_blacklist_items[lootlog_blacklist_next_empty]);
		get_item_texture(autoloot.history_blacklist_items[lootlog_blacklist_next_empty],2)
	end
end



function lootlog_blacklist_up()
	if lootlog_current_index <= autoloot.arrays_size -1 then
		lootlog_current_index = lootlog_current_index + 1
		local full_item = nil
		local n_string = tostring(lootlog_current_index)
		get_item_texture(autoloot.history_blacklist_items[lootlog_current_index],2)
		if autoloot.history_blacklist_items[lootlog_current_index] ~= nil then
			full_item = n_string.."         "..autoloot.history_blacklist_items[lootlog_current_index]
			lootlog_blacklist_text:SetText(full_item)
		elseif autoloot.history_blacklist_items[lootlog_current_index] == nil then
			full_item = n_string.."         "..autoloot.cached_lang[16]
			lootlog_blacklist_text:SetText(full_item)
			history_blacklist_icon_al_:Hide()
		end
	else
	end
end

function lootlog_blacklist_down()
	if lootlog_current_index >= 2 then
		lootlog_current_index = lootlog_current_index - 1
		local full_item = nil
		local n_string = tostring(lootlog_current_index)
		get_item_texture(autoloot.history_blacklist_items[lootlog_current_index],2)
		if autoloot.history_blacklist_items[lootlog_current_index] ~= nil then
			full_item = n_string.."         "..autoloot.history_blacklist_items[lootlog_current_index]
			lootlog_blacklist_text:SetText(full_item)
		elseif autoloot.history_blacklist_items[lootlog_current_index] == nil then
			full_item = n_string.."         "..autoloot.cached_lang[16]
			lootlog_blacklist_text:SetText(full_item)
			history_blacklist_icon_al_:Hide()
		end
	else 
	end
end



function lootlog_blacklist_remove_entry()
	if autoloot.history_blacklist_items[lootlog_current_index] ~= nil then
		print(autoloot.addon_name..autoloot.history_blacklist_items[lootlog_current_index]..autoloot.cached_lang[9])
		autoloot.history_blacklist_items[lootlog_current_index] = nil
		lootlog_blacklist_text:SetText(autoloot.history_blacklist_items[lootlog_current_index]);
		get_item_texture(nil,2)
	else 
		print(autoloot.addon_name..autoloot.cached_lang[40])
	end
end

function lootlog_tooltiptest()
	GameTooltip:SetOwner(autoloot_minimap_button, "ANCHOR_BOTTOM");
	GameTooltip:AddLine(autoloot.cached_lang[14])
	GameTooltip:AddLine(" ")
	if my_money ~= nil then
		GameTooltip:AddLine(autoloot.cached_lang[57]..": "..GetCoinTextureString(my_money))
	else 
		GameTooltip:AddLine(autoloot.cached_lang[57]..": "..GetCoinTextureString(00000))
	end
	if increase == nil then
		GameTooltip:AddLine(autoloot.cached_lang[56]..": "..GetCoinTextureString(00000))
	elseif increase ~= 0 then
		GameTooltip:AddLine(autoloot.cached_lang[56]..": "..GetCoinTextureString(increase))
	end
	GameTooltip:AddLine(" ")
	for i = 1, autoloot.arrays_size do
		if autoloot.history_items[i] == nil then
			GameTooltip:AddLine("|cFF00FF00[|r"..i.."|cFF00FF00]|r".."     "..autoloot.cached_lang[16])
		elseif autoloot.history_items[i] ~= nil then
			GameTooltip:AddLine("|cFF00FF00[|r"..i.."|cFF00FF00]|r".."     "..autoloot.history_items[i].." x "..autoloot.history_items_anzahl[i] )
	end
	GameTooltip:Show();
end
end

function autoloot.get_lang()
	local location = GetLocale()
	--local location = "enUS"
	autoloot.cached_lang = {nil}
	infoframe_version:SetText(addon_version.."("..location..")")
	if location == "deDE" then
		for i = 1,word_cache_size do
			autoloot.cached_lang[i] = autoloot.german[i]
		end
	elseif location ~= "deDE" then
		for i = 1,word_cache_size do
			autoloot.cached_lang[i] = autoloot.english[i]
		end
	end
end

function text_load_info_window()
	how_to_copy:SetText(autoloot.cached_lang[55])
	Delete_Info_title:SetText(autoloot.cached_lang[62])
	Delete_Info_one:SetText(autoloot.cached_lang[64])
	Delete_Info_two:SetText(autoloot.cached_lang[65])
	ok_delete_now:SetText(autoloot.cached_lang[60])
	full_reset_autoloot:SetText(autoloot.cached_lang[62])
end

function text_load_loot_display()
	icon_size_text:SetText(autoloot.cached_lang[59])
	font_size_text:SetText(autoloot.cached_lang[58])
	Lootwindow_lockbutton:SetText(autoloot.cached_lang[46])
	fade_in_text:SetText(autoloot.cached_lang[41])
	fade_out_text:SetText(autoloot.cached_lang[42])
	stay_text:SetText(autoloot.cached_lang[43])
end


function text_load_main_frame()
	green_text:SetText(autoloot.cached_lang[5])
	blue_text:SetText(autoloot.cached_lang[6])
	loot_by_gold_text:SetText(autoloot.cached_lang[67])
	loot_display_unlock:SetText(autoloot.cached_lang[49])
	Main_Frame_editbox:SetText(autoloot.cached_lang[32])
	lootlog_editbox:SetText(autoloot.cached_lang[32])
	Main_Frame_statustext:SetText(autoloot.cached_lang[18])
	Main_Frame_raritaet:SetText(autoloot.cached_lang[19])
	Main_Frame_raritaet_alles:SetText(autoloot.cached_lang[3])
	Main_Frame_raritaet_grau:SetText(autoloot.cached_lang[4])
	Main_Frame_raritaet_gruen:SetText(autoloot.cached_lang[5])
	Main_Frame_raritaet_blau:SetText(autoloot.cached_lang[6])
	Main_Frame_Lootlogg_Status:SetText(autoloot.cached_lang[21])
	Main_Frame_Blacklist_Status:SetText(autoloot.cached_lang[20])
	Blacklist_text:SetText(autoloot.cached_lang[22])
	history_title:SetText(autoloot.cached_lang[23])
	lootlog_blacklist_text:SetText(autoloot.cached_lang[48])
	Blacklist_select_item_down:SetText(autoloot.cached_lang[24])
	Blacklist_select_item_up:SetText(autoloot.cached_lang[25])
	Blacklist_select_item_remove:SetText(autoloot.cached_lang[26])
	lootlog_blacklist_up_button:SetText(autoloot.cached_lang[24])
	lootlog_blacklist_down_button:SetText(autoloot.cached_lang[25])
	lootlog_blacklist_del:SetText(autoloot.cached_lang[26])
	whispermsg_editbox:SetText(autoloot.whisper_msg)
	text_disable_for_raidsdisable_for_raids:SetText(autoloot.cached_lang[29])
	Whisperrespond_text:SetText(autoloot.cached_lang[30])
	text_disable_for_raidsdisable_for_group:SetText(autoloot.cached_lang[35])
	loot_display_text:SetText(autoloot.cached_lang[37])
	info_text:SetText(autoloot.cached_lang[38])
	autoroll_job_text:SetText(autoloot.cached_lang[85])
	autoroll_show_in_loot_display_text:SetText(autoloot.cached_lang[88])
end

function minimap_eventhandler()
		check_minimap()
end

function whispermsg_create(msg)
	autoloot.whisper_msg = msg
	print(autoloot.addon_name..autoloot.cached_lang[45])
end

function test_print_icon(icon,name,amount,rarity)
	create_icon(icon,-80,autoloot.start_pos)
	create_font(name,amount,35,autoloot.start_pos,rarity)
	autoloot.start_pos = autoloot.start_pos + 45
end

function create_icon(icon,xpos,ypos)
	local button = CreateFrame("Button", nil, UIParent)
	button:SetFrameStrata("HIGH")
	button:SetPoint("CENTER", lootwindow, "CENTER", xpos, ypos)
	button:SetWidth(autoloot.icon_size)
	button:SetHeight(autoloot.icon_size)
	local ntex = button:CreateTexture()
	ntex:SetTexture(icon)
	ntex:SetAllPoints()	
	button:SetNormalTexture(ntex)
	UIFrameFlash(button, tonumber(autoloot.fadein_time) , tonumber(autoloot.fadeout_time) , tonumber(autoloot.stay_time) , false, 1, 2)
	button={nil}
end

function create_font(text,amount,xpos,ypos,quality)
	local f = CreateFrame("MessageFrame",nil, UIParent)
	f:SetWidth(autoloot.font_size)
	f:SetHeight(12)
	f:SetPoint("LEFT", lootwindow, "LEFT", xpos, ypos)
	f:SetFontObject("GameFontNormal")
	
	if quality == 0 then
		f:AddMessage(text.." x "..amount , 1, 1, 1, 1)
	elseif quality == 1 then
		f:AddMessage(text.." x "..amount , 1, 1, 1, 1)
	elseif quality == 2 then
		f:AddMessage(text.." x "..amount , 0, 1, 0, 1)
	elseif quality == 3 then
		f:AddMessage(text.." x "..amount , 0, 0.5, 0.8, 1)
	else
		f:AddMessage(text.." x "..amount , 1, 0, 1, 1)
	end
	UIFrameFlash(f, tonumber(autoloot.fadein_time) , tonumber(autoloot.fadeout_time) , tonumber(autoloot.stay_time) , false, 1, 2)
	
	f={nil}
end

function get_location_loot_window()
	local point3, relativeTo3, relativePoint3, xOfs3, yOfs3 = lootwindow:GetPoint() 
	autoloot.lootwindow_ingame_location_table[1] = point3
	autoloot.lootwindow_ingame_location_table[2] = relativeTo3
	autoloot.lootwindow_ingame_location_table[3] = relativePoint3
	autoloot.lootwindow_ingame_location_table[4] = xOfs3
	autoloot.lootwindow_ingame_location_table[5] = yOfs3
end


function get_item_texture(iname,index)
	if iname ~= nil then
		local itemName, test_var, test_var, test_var, test_var, test_var, test_var, test_var, test_var, itemTexture = GetItemInfo(iname or iname or iname or iname)
		if index == 1 then
			blacklist_icon_al:SetNormalTexture(itemTexture)
			blacklist_icon_al:Show()
		elseif index == 2 then
			history_blacklist_icon_al_:SetNormalTexture(itemTexture)
			history_blacklist_icon_al_:Show()
		else
			if index == 1 then
				blacklist_icon_al:Hide()
			elseif index == 2 then
				history_blacklist_icon_al_:Hide()
			end
		end
	end
end

function set_fade_times(textbox)
		autoloot.fadein_time = tonumber(fade_in_time:GetText())
		autoloot.fadeout_time = tonumber(fade_out_time:GetText())
		autoloot.stay_time = tonumber(stay_time:GetText())
		autoloot.icon_size = tonumber(icon_size_editbox:GetText())
		autoloot.font_size = tonumber(font_size_editbox:GetText())
end

function get_fade_times()
	lootwindow:Show()
	fade_in_time:SetText(tonumber(autoloot.fadein_time))
	fade_out_time:SetText(tonumber(autoloot.fadeout_time))
	stay_time:SetText(tonumber(autoloot.stay_time))
	icon_size_editbox:SetText(tonumber(autoloot.icon_size))
	font_size_editbox:SetText(tonumber(autoloot.font_size))
end



function save_display_settings()
	set_fade_times()
	lootwindow:Hide(); 
	check_minimap()
end

function autoloot_quality_helptooltip(owner)
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT");
	GameTooltip:AddLine(autoloot.cached_lang[50])
	GameTooltip:AddLine(autoloot.cached_lang[51])
	GameTooltip:AddLine(autoloot.cached_lang[54])
	GameTooltip:AddLine(autoloot.cached_lang[53])
	GameTooltip:AddLine(autoloot.cached_lang[52])
	GameTooltip:Show();
end

function show_tooltips(owner,reason)
	if reason == "farming_mode" then
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT");
	GameTooltip:AddLine(autoloot.cached_lang[50])
	GameTooltip:AddLine(autoloot.cached_lang[66])
	GameTooltip:Show();
	elseif reason == "min_price" then
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT");
	GameTooltip:AddLine(autoloot.cached_lang[50])
	GameTooltip:AddLine(autoloot.cached_lang[75])
	GameTooltip:Show();
	elseif reason == "invert" then
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT");
	GameTooltip:AddLine(autoloot.cached_lang[50])
	GameTooltip:AddLine(autoloot.cached_lang[87])
	GameTooltip:Show();
	end
end

function info_window_hide()
	info_frame_main:Hide()
	close_icon_help_frame:Hide()
	check_minimap()
end

function info_window_show()
	text_load_info_window()
	curse_link_editbox:SetText(curse_downloadlink)
	info_frame_main:Show()
	close_icon_help_frame:Show()
	main_frame_hide()
end

function get_money()
	my_money = GetMoney();
end

function get_money_after_loot()
	after_loot = GetMoney();
end

function money_calculate_new()
	if after_loot ~= nil and my_money ~= nil then
		increase = after_loot - my_money;
	else
		increase = autoloot.cached_lang[15]
	end
end


function set_to_default()
	if Confirm_editbox:GetText() == autoloot.cached_lang[63] then
		ok_delete_now:Show()	
	end
end

function set_vars_to_default()
			print(autoloot.cached_lang[61])
			autoloot.blacklist_loot = {nil}    
			autoloot.history_tmp = {nil}    
			autoloot.history_items = {nil}    
			autoloot.history_items_anzahl = {nil}    
			autoloot.history_items_quantity = {nil}    
			autoloot.history_blacklist_items= {nil}
			autoloot.lootwindow_ingame_location_table = {nil}
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
			autoloot.fadein_time = 1
			autoloot.fadeout_time = 2
			autoloot.stay_time = 4
			autoloot.icon_size = 32
			autoloot.font_size = 160
			autoloot.autoroll_job = false
			autoloot.min_item_price = -1 
			autoloot.min_item_price_job = false
			autoloot.blacklist_invert = false
			autoloot.blacklist_lootlog_invert = false
			autoloot.show_rolled_at_loot_display = false 
			lootwindow:SetPoint("CENTER", nil, "CENTER", 0, 0)
			get_location_loot_window()
			ReloadUI();
end

function set_item_min_price(min_preis)
	autoloot.min_item_price = min_preis
	print(autoloot.cached_lang[76]..autoloot.min_item_price..autoloot.cached_lang[77])
end

function autoroll_show()
	greed_icon:Show()
	pass_icon:Show()
	disentchant_icon:Show()
	autoroll_frame:Show()
	close_autoroll:Show()
	main_frame_hide()
	disable_icon:Show()
end

function autoroll_hide()
	greed_icon:Hide()
	pass_icon:Hide()
	disentchant_icon:Hide()
	autoroll_frame:Hide()
	close_autoroll:Hide()
	disable_icon:Hide()
	check_minimap()
end

function save_savedvariables()
	get_location_loot_window()
	autoloot_job = autoloot.autoloot_enabled
	autoloot_quality = autoloot.autoloot_quality_int
	blacklist_itemtable = autoloot.blacklist_loot
	blacklist_job = autoloot.blacklist_enabled
	history_job = autoloot.history_enabled
	minimap_pos = autoloot.minimap_position
	autorepair_job = autoloot.autorepair_enabled
	lootlog_blacklist_job = autoloot.blacklist_lootlog 
	lootlog_blacklist_items = autoloot.history_blacklist_items
	loot_raid = autoloot.disable_raid
	loot_group = autoloot.disable_group
	whisper_msg_toc = autoloot.whisper_msg
	whisper_trigger = autoloot.whisper_respond
	loot_display_toc = autoloot.loot_display_ingame
	loot_display_fadein = tonumber(autoloot.fadein_time)
	loot_display_fadeout = tonumber(autoloot.fadeout_time)
	loot_display_staytime = tonumber(autoloot.stay_time) 
	icon_size_toc = tonumber(autoloot.icon_size) 
	font_size_toc = tonumber(autoloot.font_size)
	loot_display_location = autoloot.lootwindow_ingame_location_table
	loot_by_gold = autoloot.min_item_price
	loot_by_gold_job = autoloot.min_item_price_job
	autoroll_job = autoloot.autoroll_job 
	autoroll_quality_blue = autoloot.autoroll_blue
	autoroll_quality_green = autoloot.autoroll_green
	show_rolled_at_loot_display_toc = autoloot.show_rolled_at_loot_display 
	invert_blacklist_toc = autoloot.blacklist_invert
	invert_blacklist_lootlog_toc = autoloot.blacklist_lootlog_invert
end

function print_autoroll_rolled_msg(item, quality)
	local roll_method = nil
	if autoloot.autoroll_blue == 0 or autoroll_quality_green == 0 then
		roll_method = autoloot.cached_lang[81]
	elseif autoloot.autoroll_blue == 2 or autoroll_quality_green == 2 then
		roll_method = autoloot.cached_lang[80]
	elseif autoloot.autoroll_blue == 3 or autoroll_quality_green == 3 then
		roll_method = autoloot.cached_lang[82]
	end
	print(autoloot.addon_name..autoloot.cached_lang[83]..roll_method..autoloot.cached_lang[84]..item)
end