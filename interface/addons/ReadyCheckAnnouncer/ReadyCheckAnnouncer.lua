--
-- ReadyCheckAnnoucer by Mikk 
--
-- 1. Announces "Not Ready" and "AFK" people to the raid/party
-- 2. Displays a small timer bar at the bottom of the chat frame so you know how long is left of the check
-- 3. Installs an "/rc" alias for "/readycheck"
-- 4. Is smart about offline people in g3+ (10man) and g6+ (25man)
--


local _G = _G
local strsub,strmatch = string.sub, string.match
local type,pairs,ipairs,table,next = type,pairs,ipairs,table,next
local wipe,unpack = wipe,unpack
local tinsert = table.insert
local format = string.format
local print = print
local GetRaidRosterInfo, UnitName, UnitIsConnected, GetNumGroupMembers = GetRaidRosterInfo, UnitName, UnitIsConnected, GetNumGroupMembers

-- GLOBALS: SELECTED_CHAT_FRAME, DEFAULT_CHAT_FRAME
-- GLOBALS: IsRaidLeader, IsRaidOfficer, SendAddonMessage, SendChatMessage
-- GLOBALS: IsInRaid IsInGroup LE_PARTY_CATEGORY_INSTANCE
-- GLOBALS: GetInstanceInfo UnitIsGroupLeader UnitIsGroupAssistant

--[[ TESTING CODE
myRoster={
	-- name, rank, subgroup, ..., online
	{"LeaderName", 2, 1, 80, "Druid", "DRUID", "Icecrown Citadel", true},
	{"AssistantName", 1, 1, 80, "Druid", "DRUID", "Icecrown Citadel", true},

	{"Raider13", 0, 1, 80, "Druid", "DRUID", "Icecrown Citadel", true},
	{"Raider14", 0, 1, 80, "Druid", "DRUID", "Icecrown Citadel", true},
	{"Raider15", 0, 1, 80, "Druid", "DRUID", "Icecrown Citadel", true},

	{"Raider21", 0, 2, 80, "Druid", "DRUID", "Icecrown Citadel", true},
	{"Raider22", 0, 2, 80, "Druid", "DRUID", "Icecrown Citadel", true},
	{"Raider23", 0, 2, 80, "Druid", "DRUID", "Icecrown Citadel", true},
	{"Raider24", 0, 2, 80, "Druid", "DRUID", "Icecrown Citadel", true},
	{"Raider25", 0, 2, 80, "Druid", "DRUID", "Icecrown Citadel", true},
}
function GetRaidRosterInfo(i)
	if myRoster[i] then
		return unpack(myRoster[i])
	end
end
function GetNumRaidMembers()
	return #myRoster
end
--]]


local addon = _G.ReadyCheckAnnouncer or CreateFrame("Frame", "ReadyCheckAnnouncer")

local enabled = true

addon:SetScript("OnEvent", function(self,event,...)	return self[event](self,event,...)  end)

addon.timer = addon.timer or CreateFrame("StatusBar", "$parentTimer", UIParent)
addon.timer.tx = addon.timer.tx or addon.timer:CreateTexture()



local function Say(str)
	if #str>255 then
		str = strsub(str,1,255)  -- to avoid raid of 39 saying "no" and kicking off the RL :>  (though conceivably he had it coming? =))
	end
	SendChatMessage(str, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
end


local willAnnounce

local announcers = {}
local rcInitiator

local ready = {}	-- Name = true/"afk"/"offline"

addon:RegisterEvent("READY_CHECK")
function addon:READY_CHECK(event,source,duration,...)
	--DBG print("READY_CHECK: "..event..","..source..","..duration)
	source = gsub(source, " *%-.*", "")  -- strip "-ServerName" from initiator
	duration = duration + 1	 -- because it sometimes arrives as "29" and sometimes as "30"
	local timer = addon.timer
	timer:ClearAllPoints();
	timer:SetPoint("TOPLEFT", SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME, "BOTTOMLEFT", 3, -3);
	timer:SetPoint("BOTTOMRIGHT", SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME, "BOTTOMLEFT", 100, -6);

	timer.tx:SetAllPoints(timer);
	timer.tx:SetTexture(0.7, 0.7, 0, 0.8);
	timer:SetStatusBarTexture(timer.tx);

	timer:SetMinMaxValues(0,duration);
	timer:Show();
	timer:SetValue(duration);
	timer:Show();

	timer:SetScript("OnUpdate", function(self,elapsed)
		-- Update the timerbar
		local n=self:GetValue() - elapsed
		self:SetValue(n)
		-- In case we do not see a _FINISHED (happens sometimes for officers, thanks blizz), we fake one after n+3 seconds
		if n<=-3 then
			addon:READY_CHECK_FINISHED()
		end
	end)

	addon:RegisterEvent("READY_CHECK_CONFIRM")
	addon:RegisterEvent("READY_CHECK_FINISHED")

	willAnnounce = source==UnitName("player")
	wipe(announcers)

	if not (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
		return
	end

	wipe(ready)

	if IsInRaid() then
		-- We're in a raid!
		SendAddonMessage("READYCHECKANN", "CanAnn", IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "RAID")

		addon:RegisterEvent("CHAT_MSG_ADDON")

		for i=1,_G.MAX_RAID_MEMBERS do
			local name,rank = GetRaidRosterInfo(i)
			if name and rank>0 then
				-- prepare a list of people that we will trust to claim to announce (raid officers)
				announcers[name] = false	-- false="has not (yet) said that they run ReadyCheckAnnouncer"
			end
		end
	end

	-- The initiator of the readycheck is always ready
	rcInitiator = source
	ready[source] = true
end

if RegisterAddonMessagePrefix then
	RegisterAddonMessagePrefix("READYCHECKANN")
end

function addon:CHAT_MSG_ADDON(event,prefix,message,distribution,sender)
	if prefix=="READYCHECKANN" and (distribution=="RAID" or distribution=="PARTY") then
		--DBG print("READYCHECKANN",sender,distribution,message)
		if announcers[sender]==nil then
			return	-- you're not a raid officer, go away. (OR the leader declared that they WILL announce)
		elseif strmatch(message, "^CanAnn") then
			--DBG print("  sender="..tostring(sender).."  rcInitiator="..tostring(rcInitiator))
			if sender==rcInitiator then
				wipe(announcers)
			else
				announcers[sender] = true
			end
		end
	end
end





local group={}	-- { ["RaiderName"]=groupNum, ... }

local function checkResponded()
	-- Now we find out if everyone has responded. One would think that the Blizzard API would fire READY_CHECK_FINISHED unerringly, but for raid assistants, it does NOT if people are offline.
	--DBG print("checkResponded()...")

	local allResponded = true
	local allResponded10 = true
	local allResponded25 = true
	if IsInRaid() then
		-- We're in a raid!
		wipe(group)
		for i=1,_G.MAX_RAID_MEMBERS do
			local name,realm = UnitName("raid"..i)		-- This returns e.g. "Mikk", "Bloodhoof"
			if name then
				local fullname, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML =
					GetRaidRosterInfo(i)	-- This returns e.g. "Mikk-Bloodhoof"
				group[name] = subgroup

				if not online then
					ready[name]= "offline"
				end
				if ready[name]==nil then		-- remember, false=clicked "not ready"
					ready[name]="afk"
				end
				if type(ready[name])=="string" then
					allResponded=false
					if subgroup<=2 then
						allResponded10=false
					end
					if subgroup<=5 then
						allResponded25=false
					end
				end
			end
		end
		
		local instanceName, instanceType, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, mapID, instanceGroupSize = GetInstanceInfo()
		if instanceGroupSize>25 then
			-- 40man raid? bigger than 25 anyway
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		  -- game-built group
		else
			--DBG print("  all",allResponded,"all25",allResponded25,"all10",allResponded10,"numraid",GetNumRaidMembers())
			if not allResponded and allResponded25 and GetNumGroupMembers()>=19 and GetNumGroupMembers()<35 then
				--DBG print("25 check ---")
				for name,status in pairs(ready) do
					if type(status)=="string" and (group[name] or 99)>5 then
						ready[name]="standby"
					end
				end
				allResponded=true
			end
			if not allResponded and allResponded10 and GetNumGroupMembers()>5 and GetNumGroupMembers()<19 then
				--DBG print("10 check ---")
				for name,status in pairs(ready) do
					--DBG print("",name,ready[name],group[name])
					if type(status)=="string" and (group[name] or 99)>2 then
						--DBG print("-> setting to standby!")
						ready[name]="standby"
					end
				end
				allResponded=true
			end
		end
	else
		-- We're in a party!
		for i=1,_G.MAX_PARTY_MEMBERS do
			local name = UnitName("party"..i)
			if name then
				if not UnitIsConnected("party"..i) then
					ready[name] = "offline"
				end
				if ready[name]==nil then
					ready[name]="afk"
				end
				if ready[name]=="afk" then
					allResponded=false
				end
			end
		end
	end

	return allResponded
end


local function doAnnounce()
	--DBG print("doAnnounce()...")
	addon:UnregisterEvent("CHAT_MSG_ADDON")
	addon:UnregisterEvent("READY_CHECK_CONFIRM")
	addon:UnregisterEvent("READY_CHECK_FINISHED")

	addon.timer:Hide();

	if not enabled then
		return
	end

	if not willAnnounce and next(announcers) then
		-- Find out who announces by simply picking the 1st alpha-sorted playername
		--DBG print("  resolving announcer...")
		local winner
		for name,canannounce in pairs(announcers) do
			if canannounce then
				if (not winner) or (name<winner) then
					winner=name
				end
			end
		end
		--DBG print("winner=",winner)
		if winner==UnitName("player") then
			willAnnounce = true
		end
	end

	if not willAnnounce then
		--DBG print("  will not announce.")
		return	-- no further work
	end

	--DBG print("  announcing!")

	local notReady={}
	local afk={}
	local standby={}

	for name,status in pairs(ready) do
		if status==true then
			-- woop
		elseif status==false then
			tinsert(notReady, name)
		elseif status=="standby" then
			tinsert(standby, name)
		else
			tinsert(afk, name)
		end
	end

	if not next(notReady) and not next(afk) then
		-- everyone we care about is ready!
		if next(standby) then
			Say(_G.READY_CHECK..": ".._G.READY_CHECK_ALL_READY.."  (Standby: "..table.concat(standby, ", ")..")")
		else
			Say(_G.READY_CHECK..": ".._G.READY_CHECK_ALL_READY)
		end
	else
		-- we have afkers/notreadyers! report them!
		if next(notReady) then
			Say(_G.READY_CHECK..": "..format(_G.RAID_MEMBER_NOT_READY, table.concat(notReady, ", ")))
		end
		if next(afk) then
			Say(_G.READY_CHECK..": "..format(_G.RAID_MEMBERS_AFK, table.concat(afk, ", ")))
		end

		-- (and people in standby that haven't hit Yes)
		if next(standby) then
			Say(_G.READY_CHECK..": "..format("Standby: %s", table.concat(standby, ", ")))
		end
	end



end


function addon:SetStatus(name,status)
	ready[name] = status	-- true or false here

	if checkResponded() then
		doAnnounce()
	end
end


function addon:READY_CHECK_CONFIRM(event,unit,status)
	--DBG print(event,unit,UnitName(unit),status)
	local name = UnitName(unit)
	if name then
		addon:SetStatus(name, status)
	end
end


function addon:READY_CHECK_FINISHED()
	--DBG print("READY_CHECK_FINISHED")
	checkResponded()
	doAnnounce()
end



_G.SLASH_READYCHECKANNOUNCER1 = "/rc";

SlashCmdList["READYCHECKANNOUNCER"] = function(arg,...)
	if arg=="off" then
		enabled = false
		print("ReadyCheckAnnouncer: disabled announces for the rest of this session")
		return
	elseif arg=="on" then
		enabled = true
		print("ReadyCheckAnnouncer: enabled announces")
		return
	elseif arg~="" then
		print(
[[ReadyCheckAnnouncer: Usage:
/rc off - disable announces for rest of session
/rc on  - (default)
/rc     - run readycheck]])
		return
	end
	_G.SlashCmdList["READYCHECK"](arg,...)
end

