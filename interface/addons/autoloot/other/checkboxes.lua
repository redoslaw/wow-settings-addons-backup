local autoloot = select(2,...)

function autoloot_checkbox()
	if autoloot_checkbutton:GetChecked() == true then
		autoloot.autoloot_enabled = true
		print(autoloot.addon_name.."Autoloot"..autoloot.cached_lang[2]);
		quality_all:Show()
		quality_white:Show()
		quality_green:Show()
		quality_blue:Show()
		Main_Frame_raritaet:Show()
		
		Main_Frame_raritaet_alles:Show()
		Main_Frame_raritaet_grau:Show()
		Main_Frame_raritaet_gruen:Show()
		Main_Frame_raritaet_blau:Show()
		
		Main_Frame_Blacklist_Status:SetPoint("CENTER", "Main_Frame", "CENTER", -280, 50);
		blacklist_checkbutton:SetPoint("CENTER", "Main_Frame", "CENTER", -215, 50);
		
		set_points_menue()
		
	elseif autoloot_checkbutton:GetChecked() ~= true then
	
	    autoloot.autoloot_enabled = false
		print(autoloot.addon_name.."Autoloot"..autoloot.cached_lang[1]);
		quality_all:Hide()
		quality_white:Hide()
		quality_green:Hide()
		quality_blue:Hide()
		Main_Frame_raritaet:Hide()
		
		Main_Frame_raritaet_alles:Hide()
		Main_Frame_raritaet_grau:Hide()
		Main_Frame_raritaet_gruen:Hide()
		Main_Frame_raritaet_blau:Hide()
		
		Main_Frame_Blacklist_Status:SetPoint("CENTER", "Main_Frame", "CENTER", -280, 170);
		blacklist_checkbutton:SetPoint("CENTER", "Main_Frame", "CENTER", -215, 170);
		
		set_points_menue()
	end
end

function checkbox_autoloot_job_set()

	if autoloot.autoloot_enabled == true then
		autoloot_checkbutton:SetChecked(true);
		
		quality_all:Show()
		quality_white:Show()
		quality_green:Show()
		quality_blue:Show()
		Main_Frame_raritaet:Show()
		
		Main_Frame_raritaet_alles:Show()
		Main_Frame_raritaet_grau:Show()
		Main_Frame_raritaet_gruen:Show()
		Main_Frame_raritaet_blau:Show()
		
		Main_Frame_Blacklist_Status:SetPoint("CENTER", "Main_Frame", "CENTER", -280, 50);
		blacklist_checkbutton:SetPoint("CENTER", "Main_Frame", "CENTER", -215, 50);
		
		set_points_menue()

		
	
		
	elseif autoloot.autoloot_enabled == false then
	
		autoloot_checkbutton:SetChecked(false);
		quality_all:Hide()
		quality_white:Hide()
		quality_green:Hide()
		quality_blue:Hide()
		Main_Frame_raritaet:Hide()
		
		Main_Frame_raritaet_alles:Hide()
		Main_Frame_raritaet_grau:Hide()
		Main_Frame_raritaet_gruen:Hide()
		Main_Frame_raritaet_blau:Hide()
		
		Main_Frame_Blacklist_Status:SetPoint("CENTER", "Main_Frame", "CENTER", -280, 170);
		blacklist_checkbutton:SetPoint("CENTER", "Main_Frame", "CENTER", -215, 170);
		
		set_points_menue()
		
	
	end
end

function checkbox_autoloot_quality_set()

	if autoloot.autoloot_quality_int == -1 then
		quality_all:SetChecked(true);
		quality_white:SetChecked(false);
		quality_green:SetChecked(false);
		quality_blue:SetChecked(false);
	elseif autoloot.autoloot_quality_int == 0 then
		quality_all:SetChecked(false);
		quality_white:SetChecked(true);
		quality_green:SetChecked(false);
		quality_blue:SetChecked(false);
	elseif autoloot.autoloot_quality_int == 1 then
		quality_all:SetChecked(false);
		quality_white:SetChecked(false);
		quality_green:SetChecked(true);
		quality_blue:SetChecked(false);
	elseif autoloot.autoloot_quality_int == 2 then
		quality_all:SetChecked(false);
		quality_white:SetChecked(false);
		quality_green:SetChecked(false);
		quality_blue:SetChecked(true);
	end
end

function blacklist_checkbox()
	if blacklist_checkbutton:GetChecked() == true then
		autoloot.blacklist_enabled = true
	print(autoloot.addon_name.."Blacklist"..autoloot.cached_lang[2]);
		
		
	elseif blacklist_checkbutton:GetChecked() ~= true then
	    autoloot.blacklist_enabled = false
	print(autoloot.addon_name.."Blacklist"..autoloot.cached_lang[1]);
end
end

function Set_quality_all()
	autoloot.autoloot_quality_string = "all"
	convert_quality_to_int()
	print(autoloot.addon_name..autoloot.cached_lang[36]..autoloot.cached_lang[3]);
end

function Set_quality_green() 
	autoloot.autoloot_quality_string = "green"
	convert_quality_to_int()
	print(autoloot.addon_name..autoloot.cached_lang[36]..autoloot.cached_lang[5]);
end


function Set_quality_blue() 
	autoloot.autoloot_quality_string = "blue"
	convert_quality_to_int()
	print(autoloot.addon_name..autoloot.cached_lang[36]..autoloot.cached_lang[6]);
end

function Set_quality_white() 
	autoloot.autoloot_quality_string = "white"
	convert_quality_to_int()
	print(autoloot.addon_name..autoloot.cached_lang[36]..autoloot.cached_lang[4]);
end


function checkbox_blacklist_job_set()

	if autoloot.blacklist_enabled == true then
		blacklist_checkbutton:SetChecked(true);

	
	elseif autoloot.blacklist_enabled ~= true then
		blacklist_checkbutton:SetChecked(false);
	
	
end
end

-------------------------------------------------------------------------------------------
function lootlog_checkbox()
	if lootlog_checkbutton:GetChecked() == true then
		autoloot.history_enabled = true
	print(autoloot.addon_name..autoloot.cached_lang[47]..autoloot.cached_lang[2]);

	elseif lootlog_checkbutton:GetChecked() ~= true then
	   autoloot.history_enabled = false
	print(autoloot.addon_name..autoloot.cached_lang[47]..autoloot.cached_lang[1]);

end
end

function checkbox_lootlog_job_set()

	if autoloot.history_enabled == true then
		lootlog_checkbutton:SetChecked(true);

	elseif autoloot.history_enabled ~= true then
		lootlog_checkbutton:SetChecked(false);

end
end

-----------------------------------------------------------------------------------------
function lootlog_blacklist_checkbox()

	if lootlog_blacklist_checkbutton:GetChecked() == true then
		 autoloot.blacklist_lootlog = true
	 print(autoloot.addon_name..autoloot.cached_lang[12])

	elseif lootlog_blacklist_checkbutton:GetChecked() ~= true then
	     autoloot.blacklist_lootlog = false
	  print(autoloot.addon_name..autoloot.cached_lang[13])

end
end

function checkbox_lootlog_blacklist_job_set()

	if autoloot.blacklist_lootlog == true then
		lootlog_blacklist_checkbutton:SetChecked(true);

	elseif autoloot.blacklist_lootlog  ~= false then
		lootlog_blacklist_checkbutton:SetChecked(false);

end
end
------------------------------------------------------------------------------------------
function disable_raid()
	if disableautolootforraids:GetChecked() == true then
		autoloot.disable_raid = true
	 print(autoloot.addon_name..autoloot.cached_lang[29]..autoloot.cached_lang[2])
	elseif disableautolootforraids:GetChecked() ~= true then
	     autoloot.disable_raid = false
	  print(autoloot.addon_name..autoloot.cached_lang[29]..autoloot.cached_lang[1])
end
end

function disable_raid_job_set()

	if autoloot.disable_raid == true then
		disableautolootforraids:SetChecked(true);
	elseif autoloot.disable_raid == false then
		disableautolootforraids:SetChecked(false);
end
end

------------------------------------------------------------------------------------------
function whisper_engine()
	if Whisperrespond:GetChecked() == true then
		 autoloot.whisper_respond = true
	 print(autoloot.addon_name..autoloot.cached_lang[30]..autoloot.cached_lang[2])
	 whispermsg_editbox:Show()
	elseif Whisperrespond:GetChecked() ~= true then
	     autoloot.whisper_respond = false
	  print(autoloot.addon_name..autoloot.cached_lang[30]..autoloot.cached_lang[1])
	  whispermsg_editbox:Hide()
end
end

function whisper_engine_job_set()

	if autoloot.whisper_respond == true then
		Whisperrespond:SetChecked(true);
		whispermsg_editbox:Show()
	elseif autoloot.whisper_respond ~= true then
		Whisperrespond:SetChecked(false);
		whispermsg_editbox:Hide()
end
end

-----------------------------------------------------------------------------------------

function disable_group()
	if disableautolootforgroup:GetChecked() ==  true then
		 autoloot.disable_group = true
			print(autoloot.addon_name..autoloot.cached_lang[35]..autoloot.cached_lang[2])
	elseif disableautolootforgroup:GetChecked() ~= true then
	    autoloot.disable_group = false
	  print(autoloot.addon_name..autoloot.cached_lang[35]..autoloot.cached_lang[1])
end
end

function disable_group_job_set()

	if autoloot.disable_group == true then
		disableautolootforgroup:SetChecked(true);
	elseif autoloot.disable_group == false then
		disableautolootforgroup:SetChecked(false);
end
end

--------------------------------------------------------------------------------------

function loot_display_func()
	if loot_display:GetChecked() == true then
		autoloot.loot_display_ingame = true 
	 print(autoloot.addon_name..autoloot.cached_lang[37]..autoloot.cached_lang[2])
	elseif loot_display:GetChecked() ~= true then
	     autoloot.loot_display_ingame = false
	  print(autoloot.addon_name..autoloot.cached_lang[37]..autoloot.cached_lang[1])
end
end

function loot_display_job_set()

	if autoloot.loot_display_ingame == true then
		loot_display:SetChecked(true);
	elseif autoloot.loot_display_ingame == false then
		loot_display:SetChecked(false);
end
end


--------------------------------------------------------------------------------------

function min_gold_func()
	if gold_checkbox_job:GetChecked() == true then
		autoloot.min_item_price_job = true
		 print(autoloot.addon_name..autoloot.cached_lang[67]..autoloot.cached_lang[2])
		 min_gold_editbox:Show()
	elseif gold_checkbox_job:GetChecked() ~= true then
	     autoloot.min_item_price_job = false
	  print(autoloot.addon_name..autoloot.cached_lang[67]..autoloot.cached_lang[1])
	  min_gold_editbox:Hide()
end
end

function min_item_price_job_set()

	if autoloot.min_item_price_job == true then
		gold_checkbox_job:SetChecked(true);
		min_gold_editbox:Show()
	elseif autoloot.min_item_price_job == false then
		gold_checkbox_job:SetChecked(true);
		min_gold_editbox:Hide()
end
end

--------------------------------------------------------------------------------------

function roll_job_func()
	if autoroll_checkbox_job:GetChecked() == true then
		autoloot.autoroll_job = true 
		print(autoloot.addon_name..autoloot.cached_lang[71]..autoloot.cached_lang[2])
	elseif autoroll_checkbox_job:GetChecked() ~= true then
	    autoloot.autoroll_job = false
		print(autoloot.addon_name..autoloot.cached_lang[71]..autoloot.cached_lang[1])
end
end

function roll_job_set()

	if autoloot.autoroll_job == true then
		autoroll_checkbox_job:SetChecked(true);
	elseif autoloot.autoroll_job == false then
		autoroll_checkbox_job:SetChecked(false);
	end
end
--------------------------------------------------------------------------------------
function set_autoroll_quality(row, number)
	if row == 1 and number == 1 then
		row_one_cb_one:SetChecked(true)
		row_two_cb_one:SetChecked(false)
		row_three_cb_one:SetChecked(false)
		autoroll_green_job:SetChecked(true)
		autoloot.autoroll_green = 2
		print(autoloot.addon_name..autoloot.cached_lang[68])
	elseif row == 1 and number == 2 then
		row_one_cb_two:SetChecked(true)
		row_two_cb_two:SetChecked(false)
		row_three_cb_two:SetChecked(false)
		autoroll_blue_job:SetChecked(true)
		autoloot.autoroll_blue = 2
		print(autoloot.addon_name..autoloot.cached_lang[68])
	elseif row == 2 and number == 1 then
		row_two_cb_one:SetChecked(true)
		row_one_cb_one:SetChecked(false)
		row_three_cb_one:SetChecked(false)
		autoroll_green_job:SetChecked(true)
		autoloot.autoroll_green = 0
		print(autoloot.addon_name..autoloot.cached_lang[69])
	elseif row == 2 and number == 2 then
		row_two_cb_two:SetChecked(true)
		row_one_cb_two:SetChecked(false)
		row_three_cb_two:SetChecked(false)
		autoroll_blue_job:SetChecked(true)
		autoloot.autoroll_blue = 0
		print(autoloot.addon_name..autoloot.cached_lang[69])
	elseif row == 3 and number == 1 then
		row_three_cb_one:SetChecked(true)
		row_two_cb_one:SetChecked(false)
		row_one_cb_one:SetChecked(false)
		autoroll_green_job:SetChecked(true)
		autoloot.autoroll_green = 3
		print(autoloot.addon_name..autoloot.cached_lang[70])
	elseif row == 3 and number == 2 then
		row_three_cb_two:SetChecked(true)
		row_two_cb_two:SetChecked(false)
		row_one_cb_two:SetChecked(false)
		autoroll_blue_job:SetChecked(true)
		autoloot.autoroll_blue = 3
		print(autoloot.addon_name..autoloot.cached_lang[70])
	elseif row == -1 and number == 1 then
		row_three_cb_one:SetChecked(false)
		row_two_cb_one:SetChecked(false)
		row_one_cb_one:SetChecked(false)
		autoroll_green_job:SetChecked(false)
		autoloot.autoroll_green = 1337
		print(autoloot.addon_name..autoloot.cached_lang[78])
	elseif row == -1 and number == 2 then
		row_three_cb_two:SetChecked(false)
		row_two_cb_two:SetChecked(false)
		row_one_cb_two:SetChecked(false)
		autoroll_blue_job:SetChecked(false)
		autoloot.autoroll_blue = 1337
		print(autoloot.addon_name..autoloot.cached_lang[79])
	end
end

function set_autoroll_green_cb()
	if autoloot.autoroll_green == 0 then
		row_two_cb_one:SetChecked(true)
		row_three_cb_one:SetChecked(false)
		row_one_cb_one:SetChecked(false)
		autoroll_green_job:SetChecked(true)
	elseif autoloot.autoroll_green == 2 then
		row_one_cb_one:SetChecked(true)
		row_two_cb_one:SetChecked(false)
		row_three_cb_one:SetChecked(false)
		autoroll_green_job:SetChecked(true)
	elseif autoloot.autoroll_green == 3 then
		row_three_cb_one:SetChecked(true)
		row_two_cb_one:SetChecked(false)
		row_one_cb_one:SetChecked(false)
		autoroll_green_job:SetChecked(true)
	end
end

function set_autoroll_blue_cb()
	if autoloot.autoroll_blue == 0 then
		row_two_cb_two:SetChecked(true)
		row_three_cb_two:SetChecked(false)
		row_one_cb_two:SetChecked(false)
		autoroll_blue_job:SetChecked(true)
	elseif autoloot.autoroll_blue == 2 then
		row_one_cb_two:SetChecked(true)
		row_two_cb_two:SetChecked(false)
		row_three_cb_two:SetChecked(false)
		autoroll_blue_job:SetChecked(true)
	elseif autoloot.autoroll_blue == 3 then
		row_three_cb_two:SetChecked(true)
		row_two_cb_two:SetChecked(false)
		row_one_cb_two:SetChecked(false)
		autoroll_blue_job:SetChecked(true)
	end
end

---------------------------------------------------------------------

function invert_blacklist_job_func()
	if invert_normal_blacklist:GetChecked() == true then
		autoloot.blacklist_invert = true 
		print(autoloot.addon_name.."Blacklist "..autoloot.cached_lang[86]..autoloot.cached_lang[2])
	elseif invert_normal_blacklist:GetChecked() ~= true then
	    autoloot.blacklist_invert = false
		print(autoloot.addon_name.."Blacklist "..autoloot.cached_lang[86]..autoloot.cached_lang[1])
end
end

function invert_blacklist_job_set()

	if autoloot.blacklist_invert == true then
		invert_normal_blacklist:SetChecked(true);
	elseif autoloot.blacklist_invert ~= true then
		invert_normal_blacklist:SetChecked(false);
	end
end

----------------------------------------------------------------------

function invert_lootlog_blacklist_job_func()
	if invert_lootlog_blacklist:GetChecked() == true then
		autoloot.blacklist_lootlog_invert = true 
		print(autoloot.addon_name.."Lootlog - Blacklist "..autoloot.cached_lang[86]..autoloot.cached_lang[2])
	elseif invert_lootlog_blacklist:GetChecked() ~= true then
	    autoloot.blacklist_lootlog_invert = false
		print(autoloot.addon_name.."Lootlog - Blacklist "..autoloot.cached_lang[86]..autoloot.cached_lang[1])
end
end

function invert_lootlog_blacklist_job_set()

	if autoloot.blacklist_lootlog_invert == true then
		invert_lootlog_blacklist:SetChecked(true);
	elseif autoloot.blacklist_lootlog_invert ~= true then
		invert_lootlog_blacklist:SetChecked(false);
	end
end

---------------------------------------------------------------------

function show_rolled_loot_display_job_func()
	if show_roll_in_loot_display_cb:GetChecked() == true then
		autoloot.show_rolled_at_loot_display = true 
		print(autoloot.addon_name.."Show Rolls at Loot-Display"..autoloot.cached_lang[2])
	elseif show_roll_in_loot_display_cb:GetChecked() ~= true then
	    autoloot.show_rolled_at_loot_display = false
		print(autoloot.addon_name.."Show Rolls at Loot-Display"..autoloot.cached_lang[1])
end
end

function show_rolled_loot_display_job_set()

	if autoloot.show_rolled_at_loot_display == true then
		show_roll_in_loot_display_cb:SetChecked(true);
	elseif autoloot.show_rolled_at_loot_display ~= true then
		show_roll_in_loot_display_cb:SetChecked(false);
	end
end