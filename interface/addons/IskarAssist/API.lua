
local RA = RaidAssist
local _

if (_G.RaidAssistLoadDeny) then
	return
end

--[=[
	RA:GetPopupAttachAnchors()
	get the anchors for the 'menu_popup_show' function. making your popup frame attach on the menu.
	the 'menu_popup_show' return on its seconds parameter the menu frame.
	use: ANCHOR1, <menu_frame>, ANCHOR2, X, Y
--]=]
function RA:GetPopupAttachAnchors()
	local anchor_side = RA.db.profile.addon.anchor_side
	local anchor1, anchor2, x, y
	
	if (anchor_side == "left") then
		anchor1, anchor2, x, y = "left", "right", 4, 0
	elseif (anchor_side == "right") then
		anchor1, anchor2, x, y = "right", "left", -4, 0
	elseif (anchor_side == "top") then
		anchor1, anchor2, x, y = "topleft", "topright", 4, 0
	elseif (anchor_side == "bottom") then
		anchor1, anchor2, x, y = "bottomleft", "right", 4, 0
	end
	
	return anchor1, anchor2, x, y
end

--[=[
	RA:AnchorMyPopupFrame (plugin)
--]=]
function RA:AnchorMyPopupFrame (plugin)
	assert (type (plugin) == "table" and plugin.popup_frame, "AnchorMyPopupFrame expects a plugin object on parameter 1.")
	local ct_frame = GameCooltipFrame1
	local anchor1, anchor2, x, y = RA:GetPopupAttachAnchors()
	plugin.popup_frame:SetPoint (anchor1, ct_frame, anchor2, x, y)
	plugin.popup_frame:Show()
end

--[=[
	RA:InstallPlugin (name, frame_name, plugin_object, default_config)
	name: string, name of the plugin.
	frame_name: string, name for the plugin frames.
	plugin_object: table, with all the plugin functions.
	default_config: table, with key and values to store on db.
--]=]
function RA:InstallPlugin (name, frame_name, plugin_object, default_config)
	assert (type (name) == "string", "InstallPlugin expects a string on parameter 1.")
	assert (type (frame_name) == "string", "InstallPlugin expects a string on parameter 2.")
	assert (not RA.plugins [name], "Plugin name " ..name.." already in use.")
	assert (type (plugin_object) == "table", "InstallPlugin expects a table on parameter 3.")
	
	if (not RA.db) then
		RA.schedule_install [#RA.schedule_install+1] = {name, frame_name, plugin_object, default_config}
		return "scheduled"
	end
	
	RA.plugins [name] = plugin_object
	plugin_object.db_default = default_config or {}
	setmetatable (plugin_object, RA)

	RA:LoadPluginDB (name, true)

	if (plugin_object.db.menu_priority == nil) then
		plugin_object.db.menu_priority = 1
	end
	
	plugin_object.popup_frame = RA:CreatePopUpFrame (plugin_object, frame_name .. "PopupFrame")
	plugin_object.main_frame = RA:CreatePluginFrame (plugin_object, frame_name .. "MainFrame", name)

	if (plugin_object.OnInstall) then
		local err = geterrorhandler()
		xpcall (plugin_object.OnInstall, err, plugin_object)
	end
	
	return "successful"
end

--[=[
	RA:EnablePlugin (name)
	Turn on a plugin and calls OnEnable member if exists.
--]=]
function RA:EnablePlugin (name)
	assert (type (name) == "string", "DisablePlugin expects a string on parameter 1.")
	local plugin = RA.plugins [name]
	if (plugin) then
		plugin.db.enabled = true
		if (plugin.OnEnable) then
			pcall (plugin.OnEnable, plugin)
		end
	end
end

--[=[
	RA:DisablePlugin (name)
	Turn off a plugin and calls OnDisable member if exists.
--]=]
function RA:DisablePlugin (name)
	assert (type (name) == "string", "DisablePlugin expects a string on parameter 1.")
	local plugin = RA.plugins [name]
	if (plugin) then
		plugin.db.enabled = false
		if (plugin.OnDisable) then
			pcall (plugin.OnDisable, plugin)
		end
	end
end

--[=[
	RA:GetPluginList()
	return the plugin list.
--]=]
function RA:GetPluginList()
	return RA.plugins
end

--[=[
	RA:RegisterPluginComm (prefix, func)
	prefix (string) combination of two-four letters for identify the function which will receive the data.
	func (function) a function to be called when receive data with the prefix.
--]=]
function RA:RegisterPluginComm (prefix, func)
	assert (type (prefix) == "string", "RegisterPluginComm expects a string on parameter 1.")
	assert (type (func) == "function", "RegisterPluginComm expects a function on parameter 2.")
	RA.comm [prefix] = func
end

--[=[
	RA:UnregisterPluginComm (prefix)
	prefix (string) a previous registered prefix.
--]=]
function RA:UnregisterPluginComm (prefix, func)
	assert (type (prefix) == "string", "RegisterPluginComm expects a string on parameter 1.")
	RA.comm [prefix] = nil
end

--[=[
	RA:SendPluginCommMessage (prefix, channel, ...)
	
	Is a customized function to use when sending comm messages.
	SendCommMessage / CommReceived / RegisterComm can all be used directly from the plugin.
	
	prefix (string) receiving func identification.
	channel (string) which channel the comm is sent.
	callback (function) called after the message as fully sent.
	callback_param (any value), param to be added within callback.
	... all parameter to be send within the comm.
--]=]

function RA:SendPluginCommWhisperMessage (prefix, target, callback, callback_param, ...)
	RA:SendCommMessage (RA.comm_prefix, RA:Serialize (prefix, self.version or "", ...), "WHISPER", target, nil, callback, callback_param)
end

function RA:SendPluginCommMessage (prefix, channel, callback, callback_param, ...)
	assert (type (prefix) == "string", "SendPluginCommMessage expects a string on parameter 1.")
	if (callback) then
		assert (type (callback) == "function", "SendPluginCommMessage expects a function as callback (optional).")
	end
	if (channel == "RAID-NOINSTANCE") then
		if (IsInRaid (LE_PARTY_CATEGORY_HOME)) then
			RA:SendCommMessage (RA.comm_prefix, RA:Serialize (prefix, self.version or "", ...), "RAID", nil, nil, callback, callback_param)
		end
	elseif (channel == "RAID") then
		if (IsInRaid (LE_PARTY_CATEGORY_INSTANCE)) then
			RA:SendCommMessage (RA.comm_prefix, RA:Serialize (prefix, self.version or "", ...), "INSTANCE_CHAT", nil, nil, callback, callback_param)
		else
			RA:SendCommMessage (RA.comm_prefix, RA:Serialize (prefix, self.version or "", ...), "RAID", nil, nil, callback, callback_param)
		end
	elseif (channel == "PARTY-NOINSTANCE") then
		if (IsInGroup (LE_PARTY_CATEGORY_HOME)) then
			RA:SendCommMessage (RA.comm_prefix, RA:Serialize (prefix, self.version or "", ...), "PARTY", nil, nil, callback, callback_param)
		end
	elseif (channel == "PARTY") then
		if (IsInGroup (LE_PARTY_CATEGORY_INSTANCE)) then
			RA:SendCommMessage (RA.comm_prefix, RA:Serialize (prefix, self.version or "", ...), "INSTANCE_CHAT", nil, nil, callback, callback_param)
		else
			RA:SendCommMessage (RA.comm_prefix, RA:Serialize (prefix, self.version or "", ...), "PARTY", nil, nil, callback, callback_param)
		end
	else
		RA:SendCommMessage (RA.comm_prefix, RA:Serialize (prefix, self.version or "", ...), channel, nil, nil, callback, callback_param)
	end
end

--[=[
	RA:IsAddOnInstalled (addon_name)
	return if the user has a addon installed and if is enabled or not.
	addon_name (string) name of an addon.
--]=]
function RA:IsAddOnInstalled (addon_name)
	assert (type (addon_name) == "string", "IsAddOnInstalled expects a string on parameter 1.")
	local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo (addon_name)
	
	-- need to check ingame what the values is returning.
	print (name, loadable, reason)
end

--[=[
	RA:RegisterForCLEUEvent (event, func)
	register a sub event of combat log and calls a function when this event happens.
	event (string) name of the CLEU token, e.g. SPELL_DAMAGE, SPELL_INTERRUPT.
	func (function) it's called when the event is triggered.
--]=]
function RA:RegisterForCLEUEvent (event, func)
	RA.CLEU_read_events [event] = true
	if (not RA.CLEU_registered_events [event]) then
		RA.CLEU_registered_events [event] = {}
	end
	tinsert (RA.CLEU_registered_events [event], func)
end

--[=[
	RA:UnregisterForCLEUEvent (event, func)
	unregister a previous registered event of combat log.
	event (string) the event previous registered.
	func (function) the function previous registered.
--]=]
function RA:UnregisterForCLEUEvent (event, func)
	if (RA.CLEU_registered_events [event]) then
		for index, f in ipairs (RA.CLEU_registered_events [event]) do 
			if (f == func) then
				tremove (RA.CLEU_registered_events [event], index)
				break
			end
		end
		if (#RA.CLEU_registered_events [event] < 1) then
			RA.CLEU_read_events [event] = nil
		end
	end
end

--[=[
	RA:GetRepairStatus()
	return the durability amount from the player's equipment.
--]=]
function RA:GetRepairStatus()
	local percent, items = 0, 0
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local durability, maxdurability = GetInventoryItemDurability (i)
		if (durability and maxdurability) then
			local p = durability / maxdurability * 100
			percent = percent + p
			items = items + 1
		end
	end

	if (items == 0) then
		return 100
	end

	return percent / items
end

--[=[
	RA:GetSloppyEquipment()
	return two tables containing the slot id of items without enchats and gems.
--]=]
local can_enchant_slot = {
	[INVSLOT_NECK] = true,
	[INVSLOT_FINGER1] = true,
	[INVSLOT_FINGER2] = true,
	[INVSLOT_BACK] = true,
	[INVSLOT_MAINHAND] = true,
}
local stats_table = {}
function RA:GetSloppyEquipment()

	local no_enchant = {}
	local no_gem = {}

	for equip_id = 1, 17 do
		if (equip_id ~= 4) then --shirt slot
			local item = GetInventoryItemLink ("player", equip_id)
			if (item) then
				local _, _, enchant, gemID1, gemID2, gemID3, gemID4 = strsplit (":", item)
				
				if (can_enchant_slot [equip_id] and enchant == "0") then
					no_enchant [#no_enchant+1] = equip_id
				end
				
				stats_table.EMPTY_SOCKET_PRISMATIC = nil
				GetItemStats (item, stats_table)
				
				--all sockets on WoD are prismatic, we are save to make this
				if (stats_table.EMPTY_SOCKET_PRISMATIC) then
					--in WoD, no item has more than 1 slot
					if (gemID1 == "0") then
						no_gem [#no_gem+1] = equip_id
					end
				end
			end
		end
	end

	return no_enchant, no_gem
end

--[=[
	RA:GetTalents()
	return a table where the first index is the specialization ID and the other 7 indexes are the IDs for the chosen talents.
--]=]
function RA:GetTalents()
	local spec_slot = GetActiveSpecGroup()
	if (spec_slot) then
		local talent_info = {}
		local id, name, description, icon, background, role = GetSpecializationInfo (spec_slot)
		talent_info [#talent_info+1] = id
		
		for i = 1, 7 do
			for o = 1, 3 do
				local talentID, name, texture, selected, available = GetTalentInfo (i, o, spec_slot)
				if (selected) then
					talent_info [#talent_info+1] = talentID
					break
				end
			end
		end
		
		return talent_info
	end
	return {}
end

--[=[
	RA:GetGuildRanks (for_dropdown)
	return a table with ranks for the player guild or a formated table for use on dropdowns.
--]=]
function RA:GetGuildRanks (for_dropdown)
	if (for_dropdown) then
		local t = {}
		for i = 1, GuildControlGetNumRanks() do 
			tinsert (t, {value = i, label = GuildControlGetRankName (i), onclick = empty_func})
		end
		return t
	else
		local t = {}
		for i = 1, GuildControlGetNumRanks() do 
			t [i] = GuildControlGetRankName (i)
		end
		return t
	end
end

--[=[
	RA:IsInQueue()
	return is the player is in queue for bg, arena, dungeon, rf, premade.
--]=]
function RA:IsInQueue()
	for LFG_CATEGORY = 1, 5 do 
		if (GetLFGMode (LFG_CATEGORY)) then
			return true
		end
	end
end

--[=[
	Friendship functions:
	RA:IsBnetFriend (character_name): return if the character is your bnet friend.
	RA:IsFriend (character_name): return if the character is in your friend list.
	RA:IsGuildFriend (character_name): return if the character is in the same guild as the player.
--]=]

function RA:IsBnetFriend (who)
	who = RA:RemoveRealName (who)
	local bnet_friends_amt = BNGetNumFriends()
	for i = 1, bnet_friends_amt do 
		local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, broadcastTime, canSoR = BNGetFriendInfo (i)
		if (isOnline and client == BNET_CLIENT_WOW and who == toonName) then
			return true
		end
	end
end

function RA:IsFriend (who)
	local friends_amt = GetNumFriends()
	for i = 1, friends_amt do
		local toonName = GetFriendInfo (i)
		if (who == toonName) then
			return true
		end
	end
end


function RA:IsGuildFriend (who)
	if (IsInGuild()) then
		return UnitIsInMyGuild (who) or UnitIsInMyGuild (who:gsub ("%-.*", ""))
	end
end

--[=[
	RA:RegisterForEnterRaidGroup (func)
	RA:RegisterForLeaveRaidGroup (func)
	Calls 'func' when the player enters or left a raid group.
	
	RA:UnregisterForEnterRaidGroup (func)
	RA:UnregisterForLeaveRaidGroup (func)
	Remove a previous regitered function.
--]=]

function RA:RegisterForEnterRaidGroup (func)
	tinsert (RA.player_enter_raid, func)
end

function RA:RegisterForLeaveRaidGroup (func)
	tinsert (RA.player_leave_raid, func)
end

function RA:RegisterForEnterPartyGroup (func)
	tinsert (RA.player_enter_party, func)
end

function RA:RegisterForLeavePartyGroup (func)
	tinsert (RA.player_leave_party, func)
end

function RA:UnregisterForEnterRaidGroup (func)
	for i = #RA.player_enter_raid, 1, -1 do
		if (RA.player_enter_raid [i] == func) then
			tremove (RA.player_enter_raid, i)
		end
	end
end

function RA:UnregisterForLeavePartyGroup (func)
	for i = #RA.player_leave_party, 1, -1 do
		if (RA.player_leave_party [i] == func) then
			tremove (RA.player_leave_party, i)
		end
	end
end

function RA:UnregisterForEnterPartyGroup (func)
	for i = #RA.player_enter_party, 1, -1 do
		if (RA.player_enter_party [i] == func) then
			tremove (RA.player_enter_party, i)
		end
	end
end

function RA:UnregisterForLeaveRaidGroup (func)
	for i = #RA.player_leave_raid, 1, -1 do
		if (RA.player_leave_raid [i] == func) then
			tremove (RA.player_leave_raid, i)
		end
	end
end

--[=[
	GetPlayerWithRealmName()
	return the player name with its realm name.
--]=]

function RA:GetPlayerNameWithRealm()
	return UnitName ("player") .. "-" .. GetRealmName()
end

--[=[
	GetEncounterName (encounter_id)
	return the encounter name from a encounter id.
--]=]
function RA:GetEncounterName (encounterid)
	for _, instance_id in ipairs (RA.LootList.InstanceIds) do
		EJ_SelectInstance (instance_id)
		local name, description, encounterID, rootSectionID, link = EJ_GetEncounterInfo (encounterid)
		if (name) then
			return name
		end
	end
	return ""
end

--[=[
	GetCurrentRaidEncounterList()
	return a table with encounter names from the current raid.
--]=]

local raid_list = {
	[1448] = {669, {1778, 1785, 1787, 1798, 1786, 1783, 1788, 1794, 1777, 1800, 1784, 1795, 1799}}, --mapid / EJ_id / encounter ids (hellfire citadel)
	[1520] = {768, {1853, 1876, 1873, 1841, 1854, 1877, 1864}}, --mapid / EJ_id / encounter ids (emerald nightmare)
	[1648] = {861, {1958, 1962, 2008}}, --mapid / EJ_id / encounter ids (trials of valor)
	[1530] = {786, {1849, 1865, 1867, 1871, 1862, 1842, 1886, 1863, 1872, 1866}}, --mapid / EJ_id / encounter ids (nighthold)
}



local empty_table = {}
function RA:GetCurrentRaidEncounterList (mapid)
	local zoneName, zoneType, _, _, _, _, _, zoneMapID = GetInstanceInfo()
	if (mapid) then
		zoneMapID = mapid
	end
	local EJ_id, true_encounter_ids = unpack (raid_list [zoneMapID] or empty_table)
	if (EJ_id) then
		EJ_SelectInstance (EJ_id)
		local bosses = {}
		for i = 1, 99 do
			local boss_name = EJ_GetEncounterInfoByIndex (i, EJ_id)
			if (boss_name) then
				tinsert (bosses, {boss_name, true_encounter_ids [i]})
			else
				break
			end
		end
		return bosses
	else
		return {}
	end
end

--[=[
	UnitHasAssist (unit)
	return is a unit has assist on the raid
--]=]
function RA:UnitHasAssist (unit)
	return IsInRaid() and (UnitIsGroupAssistant (unit) or UnitIsGroupLeader (unit))
end

--[=[
	UnitIsRaidLeader (unit)
	return is a unit is the leader of the raid
--]=]
function RA:UnitIsRaidLeader (unit)
	if (type (unit) == "string") then
		return UnitIsGroupLeader (unit) or UnitIsGroupLeader (unit:gsub ("%-.*", ""))
	end
end

--[=[
	GetRaidLeader()
	return the raid leader name and raidunitid
--]=]
function RA:GetRaidLeader()
	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			local name, rank = GetRaidRosterInfo (i)
			if (rank == 2) then
				return name, "raid" .. i
			end
		end
	end
	return false
end

--[=[
	PercentColor()
	return green <-> red color based on the value passed
--]=]
function RA:PercentColor (value, inverted)
	local r, g
	if (value < 50) then
		r = 255
	else
		r = floor ( 255 - (value * 2 - 100) * 255 / 100)
	end
	
	if (value > 50) then
		g = 255
	else
		g = floor ( (value * 2) * 255 / 100)
	end
	
	if (inverted) then
		return g/255, r/255, 0
	else
		return r/255, g/255, 0
	end
end
--[=[
	Hex()
	return a hex string for the number passed
--]=]
function RA:Hex (num)
	local hexstr = '0123456789abcdef'
	local s = ''
	while num > 0 do
		local mod = math.fmod (num, 16)
		s = string.sub (hexstr, mod+1, mod+1) .. s
		num = math.floor (num / 16)
	end
	if s == '' then s = '00' end
	if (string.len (s) == 1) then
		s = "0"..s
	end
	return s
end

--[=[
	GetBossSpellList (encounterid)
	return a table with spells id.
--]=]

local boss_spells = {
	--"Hellfire Assault"
	[1426] = {181155, 180417, 181968, 186737, 188884, 185806, 185021, 180945,185156,187655,187638,184065,186883,180080,190728,184243,190748,190739,181120,184394,184370},
		
	--Nythendra
	[1703] = {
		204506, --infested
		202978, --infested-breath
		204470, --volatile-rot
		203045, --infested-ground
		203646, --burst-of-corruption
	}, 
	--Elerethe Renferal
	[1744] = {
		214348, --vile-ambush
		218144, --violent-winds
		212709, --gathering-clouds
		222037, --raking-talons
		213124, --venomous-pool
		215306, --pain-lash
		213936, --dark-storm
		233434, --necrotic-venom
		210850, --twisting-shadows
		210228, --dripping-fangs
	}, 
	--Il'gynoth, Heart of Corruption
	[1738] = {
		209471, --nightmare-explosion
		209469, --touch-of-corruption
		210931, --nightmare-gaze
		215233, --nightmarish-fury
		208689, --ground-slam
		215836, --death-blossom
		210984, --eye-of-fate
		208929, --spew-corruption
		215128, --cursed-blood
		212886, --nightmare-corruption
		208697, --mind-flay
	}, 
	--Ursoc
	[1667] = {
		198109, --barreling-impact
		197969, --roaring-cacophony
		204859, --rend-flesh
		198099, --momentum
		197943, --overwhelm
		199237, --trampling-slam
	}, 
	--Dragons of Nightmare
	[1704] = {
		203102, --mark-of-ysondre
		203121, --mark-of-taerar
		203125, --mark-of-emeriss
		203124, --mark-of-lethon
		203028, --corrupted-breath
		203153, --nightmare-blast
		204122, --tail-lash
		205870, --gloom
		204044, --shadow-burst
		203690, --nightmare-bloom
		203771, --defiled-eruption
		203817, --corrupted-burst
		205300, --corruption
		205341, --seeping-fog
	}, 
	--Cenarius
	[1750] = {
		210342, --dread-thorns
		214529, --spear-of-nightmares
		211196, --rotten-breath
		210342, --dread-thorns
		211507, --nightmare-javelin
	}, 
	--Xavius
	[1726] = {
		206369, --corruption-meteor
		209158, --blackening-soul
		206651, --darkening-soul
		207830, --corrupting-nova
	}, 
	
	--odyn
	[1819] = {
		228915, --stormforged-spear
		230990,--unerring-blast
		228932,--stormforged-spear
		229255,--arcing-storm
		227712,--spear-of-light
		231016,--shatter
		228162,
		228030,--expel-light
		228012,--horn-of-valor
	}, 
	
	--guarm
	[1830] = {
		228344, --headlong-charge
		227642, --multi-headed
		232800, --dark-discharge
		232798, --salty-spittle
		232777, --fiery-phlegm
		227514, --flashing-fangs
		227902, --roaring-leap
		228228, --flame-lick
	}, 
	
	--helya
	[1829] = {
		228053, --tainted-explosion
		228127, --decay
		228054, --taint-of-the-sea
		228055, --fury-of-the-maw
		227930, --orb-of-corruption
		228566, --corrupted-breath
		228063, --orb-of-corrosion
		228514, --torrent
	}, 
	
	--Skorpyron
	[1706] = {
		204292, --crystalline fragments
		214718, --acidic fragments
		204275, --arcanoslash
		214662, --volatile fragments
		210074, --shockwave
		204483, --focused blast
		214654, --acidic fragments
		204744, --toxic chitin
		211659, --arcane tether
		204766, --energy surge
		211801, --volatile fragments
	}, 
	
	--Chronomatic Anomaly
	[1725] = {
		219823, --power overwhelming
		206612, --burst of time
		206607, --chronometric particles
		206608, --time release
		205707, --temporal orb
		212099, --temporal charge
		207228, --warp nightwell
		219808, --chronomate
		228335, --warp nightwell
		219808, --chronomate
	}, 
	
	--Trilliax
	[1731] = {
		206749, --mana rupture
		206641, --arcane slash
		206821, --cleansing rage
		206792, --toxic slice
		206488, --arcane seepage
		206798, --toxic slice
		207328, --cleansing destruction
		212103, --energy drain
	}, 
	
	--Spellblade Aluriel
	[1751] = {
		213624, --mark of frost
		212648, --mark of frost explosion
		213761, --burst of flame
		213166, --searing brand
		213328, --detonate arcane orb
		213520, --arcane orb
		213278, --burning ground
		233098, --blazing charge
		213807, --burst of ice
		230423, --whirling barrage
		213085, --frozen tempest
		230414, --fel stomp
		212736, --pool of frost
		213504, --arcane fog
		212494, --annihilated
	}, 
	--Tichondrius
	[1762] = {
		223021, --carrion plague
		216027, --nether zone
		216726, --ring of shadows
		213534, --echoes of the void
		206474, --seeker swarm
		216024, --volatile wound
		215988, --carrion nightmare
		216040, --burning soul
	}, 
	--Krosus
	[1713] = {
		225362, --slam
		205348, --orb of destruction
		206677, --searing brand
		206376, --burning pitch
		206352, --felburst
		205391, --fel beam
	}, 
	--High Botanist Tel'arn
	[1761] = {

	}, 
	--Star Augur Etraeus
	[1732] = {
		
	}, 
	--Grand Magistrix Elisande
	[1743] = {
		
	}, 
	--Gul'dan
	[1737] = {
		
	}, 
}

function RA:GetBossSpellList (ej_id)

	return boss_spells [ej_id]
end

--[=[
	GetBossIds (any id)
	return the encounter id from the journal and for the combatlog
--]=]
local encounter_journal = {
	--instance EJID --boss EJID
	[786] = {
		1706, 1725, 1731, 1751, 1762, 1713, 1761, 1732, 1743, 1737,
		[1706] = 1849, --Skorpyron
		[1725] = 1865, --Chronomatic Anomaly
		[1731] = 1867, --Trilliax
		[1751] = 1871, --Spellblade Aluriel
		[1762] = 1862, --Tichondrius
		[1713] = 1842, --Krosus
		[1761] = 1886, --High Botanist Tel'arn
		[1732] = 1863, --Star Augur Etraeus
		[1743] = 1872, --Grand Magistrix Elisande
		[1737] = 1866, --Gul'dan
	},
	
	[861] = {
		1819, 1830, 1829,
		[1819] = 1958, --Odyn	
		[1830] = 1962, --Guarm
		[1829] = 2008, --Helya
	},
	
	[768] = {
		1703, 1744, 1738, 1667, 1704, 1750, 1726,
		[1703] = 1853, --Nythendra
		[1744] = 1876, --Elerethe Renferal
		[1738] = 1873, --Il'gynoth, Heart of Corruption
		[1667] = 1841, --Ursoc
		[1704] = 1854, --Dragons of Nightmare
		[1750] = 1877, --Cenarius
		[1726] = 1864, --Xavius	
	},
}

local combat_log_ids = {
	--instance EJID --boss CLID

	[786] = {
		1849, 1865, 1867, 1871, 1862, 1842, 1886, 1863, 1872, 1866,
		[1849] = 1706, --Skorpyron
		[1865] = 1725, --Chronomatic Anomaly
		[1867] = 1731, --Trilliax
		[1871] = 1751, --Spellblade Aluriel
		[1862] = 1762, --Tichondrius
		[1842] = 1713, --Krosus
		[1886] = 1761, --High Botanist Tel'arn
		[1863] = 1732, --Star Augur Etraeus
		[1872] = 1743, --Grand Magistrix Elisande
		[1866] = 1737, --Gul'dan
	},

	[861] = {
		1958, 1962, 2008,
		[1958] = 1819, --Odyn
		[1962] = 1830, --Guarm
		[2008] = 1829, --Helya
	},
	
	[768] = {
		1853, 1876, 1873, 1841, 1854, 1877, 1864,
		[1853] = 1703, --Nythendra
		[1876] = 1744, --Elerethe Renferal
		[1873] = 1738, --Il'gynoth, Heart of Corruption
		[1841] = 1667, --Ursoc
		[1854] = 1704, --Dragons of Nightmare
		[1877] = 1750, --Cenarius
		[1864] = 1726, --Xavius
	},
}

function RA:GetRegisteredRaids()
	return encounter_journal
end

function RA:GetBossIds (raidID, bossid)
	local ejid = encounter_journal [raidID] and encounter_journal [raidID] [bossid] or bossid
	local combatlog = combat_log_ids [raidID] and combat_log_ids [raidID] [bossid] or bossid
	return ejid, combatlog
end

--[=[
	GetWeakAuras2Object()
	return the weakaura addon object if installed and enabled
--]=]

function RA:GetWeakAuras2Object()
	local WeakAuras_Object = _G.WeakAuras
	local WeakAuras_SavedVar = _G.WeakAurasSaved
	return WeakAuras_Object, WeakAuras_SavedVar
end

--/run _G.WeakAuras.Delete (_G.WeakAurasSaved.displays ["Rip Target"])

--[=[
	GetWeakAuraTable (auraName)
	return the aura table of a specific aura
--]=]

function RA:GetWeakAuraTable (auraName)
	local WeakAuras_Object, WeakAuras_SavedVar = RA:GetWeakAuras2Object()
	if (WeakAuras_SavedVar) then
		return WeakAuras_SavedVar.displays [auraName]
	end
end

--[=[
	GetAllWeakAurasIds()
	return a table with all weak auras ids (names)
--]=]

function RA:GetAllWeakAurasNames()
	local AllAuras = RA:GetAllWeakAuras()
	if (AllAuras) then
		local t = {}
		for auraName, auraTable in pairs (AllAuras) do
			t [#t+1] = auraName
		end
		return t
	end
end

--[=[
	GetAllWeakAuras()
	return a table with all weak auras
--]=]

function RA:GetAllWeakAuras()
	local WeakAuras_Object, WeakAuras_SavedVar = RA:GetWeakAuras2Object()
	return WeakAuras_SavedVar and WeakAuras_SavedVar.displays
end

--[=[
	InstallWeakAura (auraTable)
	install a weakaura into WeakAuras2 addon
--]=]

function RA:InstallWeakAura (auraTable)
	if (not auraTable.id) then
		return
	end
	local WeakAuras_Object, WeakAuras_SavedVar = RA:GetWeakAuras2Object()
	if (WeakAuras_Object) then
		if (not RA:GetWeakAuraTable (auraTable.id)) then
			WeakAuras.Add (auraTable)
			return 1
		else
			return 1
		end
	else
		return -1
	end
end


