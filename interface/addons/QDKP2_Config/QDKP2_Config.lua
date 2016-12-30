--QDKP2_Config
--Manages the configuration of Quick DKP V2

--Addon definition
QDKP2_Config = LibStub("AceAddon-3.0"):NewAddon("QDKP2_Config", "AceConsole-3.0", "AceComm-3.0", "AceEvent-3.0", "AceSerializer-3.0", "AceTimer-3.0")
QDKP2_Config_DB={}

--Constants
QDKP2_Config.CommVersion='900'
QDKP2_Config.Localize = LibStub("AceLocale-3.0"):GetLocale("QDKP2_Config", true)
QDKP2_Config.Colors={
Enabled="|cff77ff77",
Disabled="|cffff7788",
Emphasis="|cffffc500",
}



------------------------------------------------------------- Main addon methods ----------------------------------------------------------------

function QDKP2_Config:OnEnable()
--Called by AceAddon when everything is up and running: Addon, UI, savedvars, environment, API etc.

	self:ApplyNameDesc()

	self.Defaults=QDKP2_Config:ReadGlobalOptions()		--this line can be removed when	QDKP will use the profile-based configure system 
	--self.Defaults=QDKP2_DefaultOptions --this is the line to use when QDKP will use the profile-based configure system. 
	
	--default settings for QDKP2_Config only
	self.Defaults.BRC_OverrideBroadcast=false
	self.Defaults.BRC_AutoSendTime=120
	self.Defaults.BRC_AutoSendEn=false	
	QDKP2_Config.CharDefaults={ActiveProfiles={},}

	--Loading libraries
	self.DB = LibStub("AceDB-3.0"):New(QDKP2_Config_DB, {profile = QDKP2_Config.Defaults, char = QDKP2_Config.CharDefaults},true)
	self.AceConfig=LibStub("AceConfig-3.0")
	self.AceConfigDialog=LibStub("AceConfigDialog-3.0")

	--Registering the configuration tables
	self.Tree.args["Profile"]=LibStub("AceDBOptions-3.0"):GetOptionsTable(QDKP2_Config.DB,true)		
	self.AceConfig:RegisterOptionsTable("QDKP_V2", QDKP2_Config.Tree,{})
	self.AceConfig:RegisterOptionsTable("QDKP_V2_Bliz", QDKP2_Config.BlizTree,{})
	self.AceConfigDialog:AddToBlizOptions("QDKP_V2_Bliz","Quick DKP V2")
	
	--Registering for Click event on QDKP minimap button (if exists) to open the configuration frame
	if QDKP2GUI_MiniBtn then 
		QDKP2GUI_MiniBtn:SetScript("OnMouseDown", function (self, button, down)
			if button=="RightButton" then
				QDKP2_Config:OpenDialog()
			end
		end)
	end

	--registering for events
	self:RegisterComm("QDKP2ConfPro")	
	self.DB.RegisterCallback(self,"OnProfileChanged", "ApplyProfile")
	self.DB.RegisterCallback(self,"OnProfileCopied", "ApplyProfile")
	self.DB.RegisterCallback(self,"OnProfileReset", "ApplyProfile")
	self.DB.RegisterCallback(self,"OnProfileShutdown","FreezeSubtables")
	self.DB.RegisterCallback(self,"OnDatabaseShutdown","FreezeSubtables")
	
	--hook to detect when QDKP_V2 reads database. I use this to detect guild changes. 
	local OrigReadDatabase=QDKP2_ReadDatabase
	function QDKP2_ReadDatabase(...)
		OrigReadDatabase(...)
		self:UpdateGuildProfile()
	end
	
	--Apply the profile given the current guild.
	self:UpdateGuildProfile()
	QDKP2_Config:ApplyProfile()
	
	--Launch autobroadcast.
	self:AutoBroadcast(true)
end


function QDKP2_Config:ApplyProfile()
--Called on profile change.

	QDKP2_Debug(1,"Config","Profile changed to "..self.DB:GetCurrentProfile()..". Applying settings.")
	self.DB.char.ActiveProfiles[QDKP2_Config:GetDefaultProfileName()]=self.DB:GetCurrentProfile()
	self.Profile=self.DB.profile

	--the following is used to clean old Boss_Instance voices when the addon mantainer updates the table
	for i,v in pairs(self.Profile.Boss_Instance) do if not v.name then self.Profile.Boss_Instance[i]=nil; end; end
	
	self.Profile.Boss_Names=self:DefrostSubtable(self.Profile.Boss_Names)
	self.Profile.BM_Keywords=self:DefrostSubtable(self.Profile.BM_Keywords)
	self.Profile.LOOT_Items=self:DefrostSubtable(self.Profile.LOOT_Items)
	
	self:UpdateItemTables()
	self:ApplyProfileToGlobal()	--this line can be removed when	QDKP will use the profile-based configure system 
	self:RefreshGUI()
end

function QDKP2_Config:UpdateGuildProfile()
	--called when QDKP indicates you have changed guild
	
	QDKP2_Debug(1,"Config","Detected guild change, updating active profile")
	local Profile=self:GetDefaultProfileName()
	local lastProfile=self.DB.char.ActiveProfiles[Profile]
	if lastProfile and Profile~="Default"	then Profile=lastProfile; end
	self.DB:SetProfile(Profile)
end

function QDKP2_Config:OpenDialog()
	self.AceConfigDialog:SetDefaultSize("QDKP_V2", 700, 600)
	self.AceConfigDialog:Open("QDKP_V2")
end

----------------------------------------------- Configuration syncronization functions -------------------------------------------

function QDKP2_Config:SendActiveProfile(name)
--Serializes the active profile and whispers it to name via the addon channel. If name is 'GUILD', broadcasts it to the whole guild
	if not name then return; end
	local distribution='WHISPER'
	local text=self:Serialize(self.DB:GetCurrentProfile(),self.Profile,QDKP2_Config.CommVersion)
	if name=='GUILD' then	distribution='GUILD'; end
	self:SendCommMessage("QDKP2ConfPro", text, distribution, name, "BULK", callbackFn, callbackArg)
end

function QDKP2_Config:OnCommReceived(prefix, message, distribution, sender)
--Deserializes the received configuration performing some checks on it. If the messagge is received by a whisper, prompts the player for confirmation before importing.
	if prefix=='QDKP2ConfPro' then
		if sender==UnitName("player") then return; end --do not want stuff from self.
		local success,ProfileName,Profile,Version=self:Deserialize(message)
		if not success then
			QDKP2_Debug(1,"Config","Received some data by "..sender.." that could not be deserialized. Network problems? Forged data? Error="..ProfileName)
			return
		end
		if not ProfileName or type(ProfileName)~='string' or
			 not Profile or type(Profile)~='table'	or
			 not Version or Version~=QDKP2_Config.CommVersion then
			QDKP2_Debug(2,"Config","Received some data by "..sender.." that didn't pass the compilance check. Outdated version?")
			return
		end
		if distribution=='GUILD' then
			if IsGuildLeader(sender) then self:ImportProfile(ProfileName,Profile)
			else
				QDKP2_Debug(1,"Config",sender.." is broadcasting a configuration profile on the guild channel but he's not the GM.")
			end
		elseif distribution=='WHISPER' then
			QDKP2_AskUser(string.format(QDKP2_Config.Localize.MESS_AllowImport,sender,ProfileName),QDKP2_Config.ImportProfile,self,ProfileName,Profile)
		end
	end
end

function QDKP2_Config:ImportProfile(BCT_ProfileName,BCT_Profile)
--import a received profile
	local oldProfile=self.DB:GetCurrentProfile()
	self.DB:SetProfile(BCT_ProfileName)
	for i,v in pairs(BCT_Profile) do self.Profile[i]=v; end --import keys from received profile
	for i,v in pairs(self.Profile) do 
		if not BCT_Profile[i] then self.Profile[i]=nil; end --delete every key that does not exist on received profile
	end
	if self.Profile.BCT_OverrideBroadcast then self.DB:SetProfile(oldProfile); end
	self.Profile.BCT_ProfileName = BCT_ProfileName	
end

function QDKP2_Config:AutoBroadcast(first)
	local sec=math.ceil((self.Profile.BRC_AutoSendTime or 120)*60)
	if first then sec=30; end
	self:ScheduleTimer('AutoBroadcast', sec)
	if self.Profile.BRC_AutoSendEn and IsGuildLeader(UnitName("player")) and not first then
		self:SendActiveProfile('GUILD')
	end
end



-------------------------------------- Database helper function ----------------------------------------------------
--AceDB has an odd behaviour with tables: it does not overwrite defaults if the value is nil. Let's say you have a default
--table with {"a","b","c", "d"}. Now we delete the item 2. What you have now is {"a","c","d"}. Now, we reload the UI.
--You now expect the table to be the same, but you get{"a","c","d","d"}. The first three values are just fines (the ones 
--before reload that was in the already in the table), but the 4th item that whould be nil is still there.
--To overcome this problem without touching Quick DKP code I "freeze" subtables right before the profile is closed by
--serialize them and storing the string representation. When the profile is loaded, if those are string i defrost (deserialize)
--them.

local function FreezeSubtable(subtable)
	if not QDKP2_Config.Profile then return; end
	if QDKP2_Config:Serialize(QDKP2_Config.Profile[subtable])~=QDKP2_Config:Serialize(QDKP2_Config.Defaults[subtable]) then
		QDKP2_Config.Profile[subtable]=QDKP2_Config:Serialize(QDKP2_Config.Profile[subtable])
	end
end

function QDKP2_Config:FreezeSubtables()
	FreezeSubtable('Boss_Names')
	FreezeSubtable('BM_Keywords')
	FreezeSubtable('LOOT_Items')
end

function QDKP2_Config:DefrostSubtable(subtable)
	if type(subtable)~='string' then return subtable; end
	local ok,t=self:Deserialize(subtable)
	if ok then return t
	else return {}
	end
end

-------------------------------------- Helpers for functions in the config tree ---------------------------------- 

function QDKP2_Config:GetVar(info,...)
--standard getter for config voices. Idexes the actual profile with the voice name.
	local varname = info[#info] 
	local v=self.Profile[varname]
	if info.option.pattern and info.option.pattern== '^-?%d+$' then v=tostring(v); end --convert from number if is a number entry
	return v
end

function QDKP2_Config:SetVar(info,value,...)
--standard setter for config voices.
	local varname = info[#info]
	if info.option.pattern and info.option.pattern== '^-?%d+$' then value=tonumber(value); end --convert to number if is a number entry
	self.Profile[varname]=value
	self:ApplyVarToGlobal(varname) --this line can be removed when QDKP will be modified to use a profile-based setting system
end

function QDKP2_Config:GetGM()
--returns the name of the guild master
	for i=1,GetNumGuildMembers(true) do
		if IsGuildLeader(GetGuildRosterInfo(i)) then return GetGuildRosterInfo(i); end
	end
end

function QDKP2_Config:GetDefaultProfileName()
--returns a standard name for the profile in the form "Server-GuildName"
	local GuildName=GetGuildInfo("player")
	if GuildName then
		return string.format("%s-%s",GetRealmName(),GuildName)
	else
		return "Default"
	end
end

function QDKP2_Config:RefreshGUI()
	if QDKP2_RefreshAll then QDKP2_RefreshAll(); end
end

function QDKP2_Config:GetBreak(order)
	local v={
		type = 'description',
		name = ' ',
		fontSize = 'medium',
		order = order,
	}
	return v
end



--The following functions are used to get a table of default settings from the DefaultOptions.lua and the Options.ini file in the QDKP_V2 addon.
--This is to make QDKP2_Config flawlessy compatible with QDKP2 as it is now.
--It would be wiser to change QDKP_V2 and QDKP2_GUI global-based configuration to a modern system based on Profiles. The process will be 
--really invasive though, as the options are quite much and are spreaded all over the addons file.	


function QDKP2_Config:UpdateItemTables()
--Used to extract the tables used in the options.ini file from the LOOT_Items I use in the config addon.
--On Quick DKP upgrade to setting profile, the aforementioned tables should be unified in the LOOT_Items table in this way:
--[[
QDKP2_ChargeLoots[i].item => profile.LOOT_Items.name[i].name
QDKP2_ChargeLoots[i].DKP => profile.LOOT_Items[i].price
QDKP2_LogLoots[i].level => profile.LOOT_Items[i].level-2 (level-2 will be any value between -1 and 3: -1 and 0 must be skipped.
QDKP2_NotLogLoots[i] => profile.LOOT_Items[i].level==1 (the first returns a string, the seconds returns true if the item at index i must not be logged)
--]]
  
	local Item={}
	local Log={}
	local NoLog={}
	
	for i,v in pairs(QDKP2_Config.Profile.LOOT_Items) do
		local name=v.name
		if v.price then table.insert(Item, {item=name, DKP=v.price}); end
		if v.log and v.log>=3 then table.insert(Log, {item=name, level=v.log-2})
		elseif v.log==1 then table.insert(NoLog, name)
		end
	end
	
	QDKP2_Config.Profile.LOOT_ItemPrices=Item
	QDKP2_Config.Profile.LOOT_LootsLog=Log
	QDKP2_Config.Profile.LOOT_LootsNoLog=NoLog
	QDKP2_Config:ApplyVarToGlobal('LOOT_ItemPrices')
	QDKP2_Config:ApplyVarToGlobal('LOOT_LootsLog')
	QDKP2_Config:ApplyVarToGlobal('LOOT_LootsNoLog')
end
	

function QDKP2_Config:ReadGlobalOptions()
	QDKP2_Config_Temp={}
	for i,v in pairs(self.TransTable) do
		RunScript("QDKP2_Config_Temp."..i.."="..v)
	end
	
	local items={}
	for i,v in pairs(QDKP2_ChargeLoots) do
		table.insert(items,{name=v.item,price=v.DKP})
	end
	for i,v in pairs(QDKP2_LogLoots) do
		table.insert(items,{name=v.item,level=v.level+2})
	end
	for i,v in pairs(QDKP2_NotLogLoots) do
		table.insert(items, {name=v, level=1})
	end
	QDKP2_Config_Temp.LOOT_Items=items
	
	return QDKP2_Config_Temp
end

function QDKP2_Config:ApplyVarToGlobal(varname)
	assert(self.TransTable[varname],varname.." is not present in TransTable")
	RunScript(self.TransTable[varname].."=QDKP2_Config.Profile."..varname)
end

function QDKP2_Config:ApplyProfileToGlobal()
	for i,v in pairs(self.TransTable) do
		RunScript(v.."=QDKP2_Config.Profile."..i)
	end
end
