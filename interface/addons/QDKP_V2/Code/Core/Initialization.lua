-- Copyright 2012 Akhaan & Honesty Hyj (www.quickdkp.com)
-- This file is a part of QDKP_V2 (see about.txt in the Addon's root folder)

--             ## CORE FUNCTIONS ##
--               Initializators
--
-- Here I have all the functions called when QDKP starts, Including Costants and variables initializators.
--
-- API Documentation:
-- QDKP2_InitData(Guild): Reset only unsaved data if called without arguments. Reset <Guild>'s data if provided, and resets all if <Guild> is "*_ALL_*". Guild is moreline "Realm-Guild"
-- QDKP2_ReadDatabase(GuildName): Reads the database of the given guild, and assign it to the globals. calls QDKP2_ReadDatabase if needed.
-- QDKP2_OnLoad(): Called as the UI and QDKP are fully loaded (including saved variables). WoW API should be 100% up.
-- QDKP2_ResetPlayer(name): Resets all data regarding <name>. Used when i find corrupted data.



-------------------------------INIT DATA-------------------------



QDKP2_Data={}
QDKP2backup={}
QDKP2suppressWhispers={}

--Kluge added to fix partially implemented profiling
--temporarily store these arrays that are getting wiped out in qdkpv2_config
tLogLoot={}
tNotLogLoot={}
tChargeLoot={}

function QDKP2_InitData(GuildName, NoClearLocal)
  if GuildName=="*_ALL_*" or not QDKP2_Data then
    QDKP2_Debug(1,"Init","Clearing ALL the data storing")
    QDKP2_Data={StoreVers=QDKP2_DBREQ}
  elseif GuildName then
    QDKP2_Debug(2,"Init","Initializating database for guild "..tostring(GuildName))
    QDKP2_Data[GuildName] = {}
    QDKP2_Data[GuildName].LAST_OPEN=time()
  end
  if not NoClearLocal then
    QDKP2_Debug(3,"Init","Clearing all UnSaved variables")
    QDKP2name        = {}
    QDKP2rank        = {}
    QDKP2rankIndex   = {}
    QDKP2class       = {}
    QDKP2online      = {}
    QDKP2sessionCode = nil
    QDKP2currentSessions={}
    QDKP2_BossDeath = {}
    QDKP2_SuppressWhisper={}
  end
end



function QDKP2_ReadDatabase(GuildName)

  if not GuildName and QDKP2_GUILD_NAME then
    GuildName=GetRealmName().."-"..QDKP2_GUILD_NAME
  end

  local GuildData
  if not GuildName then
    GuildData={}
  else
    if not QDKP2_Data[GuildName] then QDKP2_InitData(GuildName,true); end
    QDKP2_Debug(2,"Init","Reading Guild Data for guild "..tostring(GuildName))
    GuildData=QDKP2_Data[GuildName]
    GuildData.LAST_OPEN=time()
  end

  GuildData.log         = GuildData.log or {}
  GuildData.log["0"]    = GuildData.log["0"] or {}

  GuildData.logEntries  = GuildData.logEntries or {}
  GuildData.logEntries.BackMod = GuildData.logEntries.BackMod or {}
  GuildData.logEntries.Deleted = GuildData.logEntries.Deleted or {}

  GuildData.raid        = GuildData.raid or {}
  GuildData.raidOffline = GuildData.raidOffline or {}
  GuildData.standby     = GuildData.standby or {}
  GuildData.raidRemoved = GuildData.raidRemoved or {}

  GuildData.TimerBase   = GuildData.TimerBase or {}

  GuildData.note        = GuildData.note or {}

  GuildData.stored      = GuildData.stored or {}

  GuildData.externals   = GuildData.externals or {}

  GuildData.sync        = GuildData.sync or {}

  GuildData.ironMan     = GuildData.ironMan or {}

  GuildData.Alts        = GuildData.Alts or {}
  GuildData.AltsRestore = GuildData.AltsRestore or {}

  GuildData.SID          = GuildData.SID or {}
  GuildData.SID.INDEX    = GuildData.SID.INDEX or 1
  GuildData.SID.DELETED=GuildData.SID.DELETED or {}
  GuildData.ModifiedPlayers=GuildData.ModifiedPlayers or {}

  GuildData.GUI         = GuildData.GUI or {}
  GuildData.GUI.DKP_RaidBonus = GuildData.GUI.DKP_RaidBonus or QDKP2GUI_Default_RaidBonus
  GuildData.GUI.DKP_Timer = GuildData.GUI.DKP_Timer or QDKP2GUI_Default_TimerBonus
  GuildData.GUI.DKP_IM = GuildData.GUI.DKP_IM or QDKP2GUI_Default_IMBonus
  GuildData.GUI.DKP_QuickModify = GuildData.GUI.DKP_QuickModify or QDKP2GUI_Default_QuickMod
  GuildData.GUI.ShowOutGuild = GuildData.GUI.ShowOutGuild or QDKP2GUI_Default_ShowOutGuild
  GuildData.GUI.CustomPlayerRosterList=GuildData.GUI.CustomPlayerRosterList or QDKP2GUI_Default_CustomPlayerRosterList

  GuildData.Crypt		    = GuildData.Crypt or {}

  GuildData.BidM        = GuildData.BidM or {}

	if GuildData.AutoBossEarn == nil then GuildData.AutoBossEarn=true; end --enabled by default
	--if GuildData.DetectBids == nil then GuildData.DetectBids=true; end --enabled by default
	if GuildData.FixedPrices == nil then GuildData.FixedPrices=true; end --enabled by default

	QDKP2_GuildData = GuildData --I should only retrive and set stuff indexing this variable.

  QDKP2log = GuildData.log
  QDKP2log["0"]=QDKP2log["0"]

  QDKP2logEntries_BackMod=GuildData.logEntries.BackMod
  QDKP2logEntries_Deleted=GuildData.logEntries.Deleted

  QDKP2raid = GuildData.raid
  QDKP2raidOffline = GuildData.raidOffline
  QDKP2standby = GuildData.standby
  QDKP2raidRemoved = GuildData.raidRemoved

  QDKP2timerBase = GuildData.TimerBase

  QDKP2note = GuildData.note

  QDKP2stored = GuildData.stored

  QDKP2externals = GuildData.externals

  QDKP2sync = GuildData.sync

  QDKP2ironMan = GuildData.ironMan

  QDKP2alts = GuildData.Alts
  QDKP2altsRestore = GuildData.AltsRestore

  QDKP2_SID = GuildData.SID
  QDKP2_ModifiedPlayers = GuildData.ModifiedPlayers

  QDKP2GUI_Vars=GuildData.GUI

  QDKP2_Crypt = GuildData.Crypt

  QDKP2_BidM = GuildData.BidM

  QDKP2_StoreVers=QDKP2_Data.StoreVers or 0

  QDKP2_DataLoaded=GuildName

  QDKP2_InitData()

end

-- Called as WoW enters the world.
function QDKP2_Init()
 QDKP2_Debug(2,"Core","Initializing the Addon")

  --Load libraries
  QDKP2libs={}
  QDKP2libs.AceConsole=LibStub:GetLibrary("AceConsole-3.0")
  QDKP2libs.Events=LibStub:GetLibrary("CallbackHandler-1.0")
  QDKP2libs.Deformat=AceLibrary:GetInstance("Deformat-2.0")
	QDKP2libs.RSA=LibStub:GetLibrary("LibRSA-1.0")
 pcall(function() QDKP2libs.BossBabble=LibStub:GetLibrary("LibBabble-Boss-3.0"); end)
  pcall(function() QDKP2libs.ClassBabble=LibStub:GetLibrary("LibBabble-Class-3.0"); end)
  pcall(function() QDKP2libs.ZoneBabble=LibStub:GetLibrary("LibBabble-Zone-3.0"); end)
  pcall(function() QDKP2libs.InventoryBabble=LibStub:GetLibrary("LibBabble-Inventory-3.0"); end)
  QDKP2libs.Timer=LibStub:GetLibrary("AceTimer-3.0")
  QDKP2libs.CheckTimer=LibStub:GetLibrary("AceTimer-3.0")
  local TesteDiCazzo={}  --Variable's name says all (in italian). This is what I think about CallbackHandler developers.
  QDKP2_Events= QDKP2libs.Events:New(TesteDiCazzo)
  QDKP2_Events["RegisterCallback"]=TesteDiCazzo["RegisterCallback"]
  QDKP2_Events["UnregisterCallback"]=TesteDiCazzo["UnregisterCallback"]
  QDKP2_Events["UnregisterAllCallbacks"]=TesteDiCazzo["UnregisterAllCallbacks"]
  pcall(function() QDKP2bossEnglish=QDKP2libs.BossBabble:GetReverseLookupTable(); end)
  pcall(function() QDKP2classEnglish=QDKP2libs.ClassBabble:GetReverseLookupTable(); end)
  pcall(function() QDKP2zoneEnglish=QDKP2libs.ZoneBabble:GetReverseLookupTable(); end)
  pcall(function() QDKP2inventoryEnglish=QDKP2libs.InventoryBabble:GetReverseLookupTable(); end)
  if not QDKP2bossEnglish or not QDKP2classEnglish then
    QDKP2_Debug(1,"Core","LibBabble-3 doesn't manage your client's locale ("..GetLocale()..").")
  end
  QDKP2bossEnglish=QDKP2bossEnglish or {}
  QDKP2classEnglish=QDKP2classEnglish or {}
  --Feb 10 2017 fix localization for new classes by un-using deprecated libbabble
  local QDKP2classTemp={}
  
  FillLocalizedClassList(QDKP2classTemp)
  for i,v in pairs (QDKP2classTemp) do
    QDKP2classEnglish[v] = i
	--DEFAULT_CHAT_FRAME:AddMessage("Initialization i "..i.." v "..v)
  end
  --Now for the female class names
  FillLocalizedClassList(QDKP2classTemp, true)
  for i,v in pairs (QDKP2classTemp) do
    QDKP2classEnglish[v] = i
	--DEFAULT_CHAT_FRAME:AddMessage("Initialization i "..i.." v "..v)
  end
  
  --End of addition 
  
  QDKP2zoneEnglish=QDKP2zoneEnglish or {}
  QDKP2inventoryEnglish=QDKP2inventoryEnglish or {}

	--Fix setting for exceptions
	if QDKP2_GIVEOFFLINE then
		QDKP2_AWARD_OFFLINE_RAIDAWARD=QDKP2_GIVEOFFLINE
		QDKP2_AWARD_OFFLINE_ZEROSUM=QDKP2_GIVEOFFLINE
		QDKP2_AWARD_OFFLINE_TIMER=QDKP2_GIVEOFFLINE
		QDKP2_AWARD_OFFLINE_IRONMAN=QDKP2_GIVEOFFLINE
	end

	if QDKP2_GIVEOUTZONE then
	QDKP2_AWARD_ZONE_RAIDAWARD=QDKP2_GIVEOUTZONE
	QDKP2_AWARD_ZONE_ZEROSUM=QDKP2_GIVEOUTZONE
	QDKP2_AWARD_ZONE_TIMER=QDKP2_GIVEOUTZONE
	QDKP2_AWARD_ZONE_IRONMAN=QDKP2_GIVEOUTZONE
	end

	if QDKP2_UNDKPABLE_IRONMAN then
		QDKP2_AWARD_RANK_RAIDAWARD = QDKP2_UNDKPABLE_RAIDBOSS
		QDKP2_AWARD_RANK_ZEROSUM = QDKP2_UNDKPABLE_ZEROSUM
		QDKP2_AWARD_RANK_TIMER = QDKP2_UNDKPABLE_TIME
		QDKP2_AWARD_RANK_IRONMAN = QDKP2_UNDKPABLE_IRONMAN
	end

  --Register events
  --QDKP2:RegisterEvent("ADDON_LOADED")
  QDKP2:RegisterEvent("GROUP_ROSTER_UPDATE")
  QDKP2:RegisterEvent("PLAYER_ENTERING_WORLD")
  QDKP2:SetScript("OnEvent", QDKP2_OnEvent)

  --Clear all data
  QDKP2_InitData("*_ALL_*")

  --QDKP2_SetLetters()
  QDKP2_SetSlashCommands()
  
  --First part of Kluge
  tLogLoot=QDKP2_LogLoots
  tNotLogLoot=QDKP2_NotLogLoots
  tChargeLoot=QDKP2_ChargeLoots

  QDKP2_Events:Fire("INIT")

  QDKP2_Debug(2,"Core","Addon initialized")
end


--called as PLAYER_ENTERING_WORLD is called.
function QDKP2_OnLoad()
  --Second part of Kluge
  QDKP2_LogLoots = tLogLoot
  QDKP2_NotLogLoots = tNotLogLoot
  QDKP2_ChargeLoots = tChargeLoot
  --DEFAULT_CHAT_FRAME:AddMessage("QDKP notlog size = "..#QDKP2_NotLogLoots)

  --clears the recorded debug list, if any.
  --to record a debug list, write "/script QDKP2_Debug_List={}" in the console.  -- fails badly
  QDKP2_Debug_List=nil
  QDKP2_Debug(2,"Core","Starting the addon")

  -- Gets player and guild details
  --QDKP2_PLAYER_NAME_31 = string.sub(UnitName("player"),1,31)
  local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
  QDKP2_GUILD_NAME = guildName
  local QDKP2_playerName
  QDKP2_PLAYER_NAME, QDKP2_playerRealm = UnitFullName("player")

  if QDKP2_Data and QDKP2_DBREQ>(QDKP2_Data.StoreVers or 0) then
    QDKP2_InitData("*_ALL_*")
    QDKP2_Msg(QDKP2_LOC_ClearDB)
  end

  if QDKP2_ODS_ENABLE then
    QDKP2_OriginalChatMsgHandler=ChatFrame_MessageEventHandler   --hook the MessageEvent to hide On-Demand whispers
    ChatFrame_MessageEventHandler = QDKP2_ChatMsgHandler
  end

  QDKP2_ReadDatabase()

  --cleans the database. Delete guild entries that have not been opened for more than 90 days.
  for k,v in pairs(QDKP2_Data) do
    if type(v) == 'table' then
      if not v.LAST_OPEN then v.LAST_OPEN=time(); end
      if time() - v.LAST_OPEN > 7776000 then --these are 90 days in seconds
        QDKP2_Debug(1,"Core",k.." has not been opened for more than 90 days. Removing it from database.")
        QDKP2_Data[k]=nil                    --brutal delete. work for the garbage collector.
      end
    end
  end

  QDKP2_TimeDelta=QDKP2_GuessTimeZone()

  QDKP2_BossBonusSet(QDKP2_GuildData.AutoBossEarn)
  QDKP2_DetectBidSet(QDKP2_GuildData.DetectBids)
  QDKP2_FixedPricesSet(QDKP2_GuildData.FixedPrices)

--I use these timers to refresh guild data (on regular basis)
  QDKP2_GuildRefTimerObj=QDKP2libs.Timer:ScheduleRepeatingTimer(QDKP2_TimeToRefresh, 30)

  --if i was managing a session but i'm not in the raid anymore, close the session.
  if QDKP2_IsManagingSession() and (not QDKP2_IsRaidPresent() or not QDKP2_OfficerMode()) then
    QDKP2_StopSession(true)
  end

  if QDKP2_IronManIsOn() and not QDKP2_IsManagingSession() then
    QDKP2_IronManWipe()
  end

  --registering the boss kill listeners for DBM and BigWigs  --For 6.0 no longer need either
  --if DBM then
  --  QDKP2_Debug(3,"Core","DBM found, registering callback to detect boss death")
  --  DBM:RegisterCallback("kill", QDKP2_DBMBossKill)
  --elseif not BigWigsLoader then
    --QDKP2_Msg("Couldn't find Deadly Boss Mod nor BigWigs. If nobody has them in the raid, you won't be able to detect boss kills.","WARNING")
 -- end
  
  --Login Message
  	QDKP2_Msg("Thank you for using Quick DKP v2. Please use Curse.com to report bugs or suggestions")

  --registering the bos

  if QDKP2_isTimerOn() and QDKP2_IsManagingSession() and (time() - QDKP2timerBase.TIMER) < 3600 then
  -- if i had timer and have been offline for less than an hour
    QDKP2_TimerOn(true)          --resume
  elseif QDKP2_isTimerOn() then
    QDKP2_TimerOff()
  end

  --hooks
  QDKP2_BidM_OrigLootFrameHook=LootFrame_Update
  LootFrame_Update=QDKP2_BidM_LootFrameHook

  if QDKP2_BETA then
    local mess = QDKP2_LOC_BetaWarning
    QDKP2_NotifyUser(mess,function() return; end)
  end

  QDKP2_Data.StoreVers=QDKP2_DBREQ

  local LoadedMsg=QDKP2_LOC_Loaded
  if QDKP2_BETA then
    LoadedMsg=string.gsub(LoadedMsg,"$BETA","BETA")
  else
    LoadedMsg=string.gsub(LoadedMsg,"$BETA","")
  end

	QDKP2_ACTIVE=true
	QDKP2_RefreshGuild()
	QDKP2_RefreshGuild()
	QDPK2_ReadGuildInfo=true
	GuildRoster()

  QDKP2:RegisterEvent("GROUP_ROSTER_UPDATE")
  --QDKP2:RegisterEvent("PARTY_MEMBERS_CHANGED")  --Included in above with 5.0
  QDKP2:RegisterEvent("GUILD_ROSTER_UPDATE")      --Added for 5.0
  --QDKP2:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")  --removed in 6.0
  QDKP2:RegisterEvent("CHAT_MSG_LOOT")
  QDKP2:RegisterEvent("CHAT_MSG_RAID")
  QDKP2:RegisterEvent("CHAT_MSG_RAID_WARNING")
  QDKP2:RegisterEvent("CHAT_MSG_RAID_LEADER")
  QDKP2:RegisterEvent("CHAT_MSG_WHISPER")
  QDKP2:RegisterEvent("CHAT_MSG_ADDON")
  QDKP2:RegisterEvent("CHAT_MSG_SYSTEM")
  QDKP2:RegisterEvent("CHAT_MSG_PARTY")
  QDKP2:RegisterEvent("ENCOUNTER_END")  -- In 6.0
  QDKP2_Events:Fire("LOAD")

  QDKP2_VERSION = QDKP2_VERSION..GetAddOnMetadata("QDKP_V2", "VERSION");
  LoadedMsg=string.gsub(LoadedMsg,"$VERSION",QDKP2_VERSION)
  QDKP2_Msg(LoadedMsg);
  QDKP2_Debug(2,"Core","Addon started")
end

-- This deletes all local data and call guild's download. It's called when i find
-- an error in player's values.
function QDKP2_ResetPlayer(name)
  QDKP2_Msg(name.."'s local data seems to be corrupted. Sorry, I have to reset it.", "ERROR" )

  for i=1,#QDKP2raid do
    local checkName=QDKP2raid[i]
    if checkName == name then table.remove(QDKP2raid,i); break; end
  end

  for i=1,#QDKP2name do
    local checkName=QDKP2name[i]
    if checkName == name then table.remove(QDKP2name,i); break; end
  end

  QDKP2rank[name]        = nil
  QDKP2rankIndex[name]   = nil
  QDKP2class[name]       = nil
  QDKP2online[name]      = nil

  QDKP2note[name] = nil

  QDKP2stored[name] = nil

  QDKP2alts[name]       = nil
  QDKP2altsRestore[name]= nil

  QDKP2standby[name] = nil

  QDKP2_RefreshGuild()
  GuildRoster()

  QDKP2_Msg(name.." has been rinitialized successfully")
end

