
local L = LibStub("AceLocale-3.0"):NewLocale("QDKP2_Config", "enUS", true, true)

if L then

--Generic strings
L.QDKP2="Quick DKP V2"
L.Instance10 = "Normal"
L.Instance10H = "Heroic"
L.Instance25 = "Mythic"
L.Instance25H = "LFRFlex"
L.Roster = "Roster"
L.Log = "Log"
L.Success="Success!"
L.Confirm="Please confirm"

--GUI tree
L.GUI=	"GUI Options"
L.GUI_ClassBased = "Class based colors"
L.GUI_ClassBased_d = "Use class based colors in the roster"
L.GUI_DefaultColor = "Default Member"
L.GUI_DefaultColor_d = "Default color for normal guild members"
L.GUI_ModifiedColor = "Modified Player"
L.GUI_ModifiedColor_d = "Color for members with unuploaded modifications"
L.GUI_StandbyColor = "Standby Raiders"
L.GUI_StandbyColor_d = "Color for raid members in standby list"
L.GUI_AltColor = "Alternatives"
L.GUI_AltColor_d = "Color for defined alts"
L.GUI_ExtColor = "Externals"
L.GUI_ExtColor_d = "Color for defined externals"
L.GUI_NoGuildColor = "Outsiders"
L.GUI_NoGuildColor_d = "Color for players out of guild and not set as externals"
L.GUI_NoClassColor = "Unknown Class"
L.GUI_NoClassColor_d = "Default color for players of unknown class"

L.ODS="On-Demand System"
L.ODS_Enable = "Enable"
L.ODS_Enable_d = "Enables/Disables the OnDemand system"
L.KWHeaders = "Keywords"
L.ODS_EnDKP = 'Enable "?dkp"'
L.ODS_EnDKP_d = "Enables the keyword used to ask for DKP amounts"
L.ODS_EnREPORT = 'Enable "?report"'
L.ODS_EnREPORT_d = "Enables the keyword used to ask for log reports"
L.ODS_EnPRICE = 'Enable "?price"'
L.ODS_EnPRICE_d = "Enables the keyword used to ask for items DKP cost"
L.ODS_EnBOSS = 'Enable "?boss"'
L.ODS_EnBOSS_d = "Enables the keyword used to ask for bosses DKP award"
L.ODS_EnCLASS = 'Enable "?class"'
L.ODS_EnCLASS_d = "Enables the keyword used to ask for class DKP topten"
L.ODS_EnRANK = 'Enable "?rank"'
L.ODS_EnRANK_d = "Enables the keyword used to ask for rank DKP topten"
L.OptionHeaders = "Options"
L.ODS_ViewWhisp = "View Whispers"
L.ODS_ViewWhisp_d = "Shows the triggering whispers sent by the guildmembers"
L.ODS_ReqAll = "Request others data"
L.ODS_ReqAll_d = "Lets the players ask for data regarding other guild members"
L.ODS_LetExt = "External requests"
L.ODS_LetExt_d = "Lets players external to the guild ask for DKP data. Defined externals are assumed to be in guild"
L.ODS_TopTenLen = "TopTen Length"
L.ODS_TopTenLen_d = "The maximum amount of players showed by the class and rank DKP top-ten"
L.ODS_PriceLen = "Max Prices Results"
L.ODS_PriceLen_d = "The maximum amount of results a player can get when asking for item prices"
L.ODS_BossLen = "Max BossAward Results"
L.ODS_BossLen_d = "The maximum amount of results a player can get when asking for boss awards"
L.ODS_PricesKWLen = "Prices KW Minimum Length"
L.ODS_PricesKWLen_d = "The minimum keyword length a player can use when asking for item prices"
L.ODS_BossKWLen = "BossAward KW Minimum Length"
L.ODS_BossKWLen_d = "The minimum keyword length a player can use when asking for boss awards"

L.BidManager="Bid Manager"
L.BidOptions="General bidding settings"
L.AnnouceHeader = "Announcement Options"
L.BM_AnnounceStart = "Annouce Start"
L.BM_AnnounceStart_d = "Announce the start of a bid in the given channel"
L.BM_AnnounceWinner = "Announce Winners"
L.BM_AnnounceWinner_d = "Announce the winner of a bid in the given channel"
L.BM_AnnounceCancel = "Announce Cancels"
L.BM_AnnounceCancel_d = "Announce the cancellation of a bid in the given channel"
L.BM_AnnounceStartChannel = "Start Channel"
L.BM_AnnounceWinnerChannel = "Winner Channel"
L.BM_AnnounceCancelChannel = "Cancel Channel"
L.BM_AnnounceChannel_d = 'The channel where to route the announcement. "Group" translates either to "Raid", "Praty" or "Battleground" depending in which one you are'
L.BM_Countdown = "Enable Countdown"
L.BM_Countdown_d = "Enables a countdown when you set a winner. If a bet is received during the countdown, the countdown is cancelled"
L.BM_CountdownChannel = "Countdown Channel"
L.BM_CountdownLen = "Countdown length"
L.BM_AnnounceStartText = "Start text"
L.BM_AnnounceStartText_d = "The text used when announcing a bid start. $ITEM is replaced with the bet item, or the text entered as reason."
L.BM_AnnounceWinnerDKPText = "Winner (DKP) text"
L.BM_AnnounceWinnerDKPText_d = "The text used when announcing a bid winner with DKP involved. $ITEM is replaced with the item being bet, or the text entered as reason. $NAME is replaced with the winner's name"
L.BM_AnnounceWinnerText = "Winner text"
L.BM_AnnounceWinnerText_d = "The text used when announcing a bid winner without DKP involved. $ITEM is replaced with the won item, or the text entered as reason. $NAME is replaced with the winner's name"
L.BM_AnnounceCancelText = "Cancel text"
L.BM_AnnounceCancelText_d = "The text used when announcing the cancellation of a bet. $ITEM is replaced with the item that was on bid"
L.BiddingOptionHeader = "Bidding Options"
L.BM_AllowMultiple = "Allow rebid"
L.BM_AllowMultiple_d = "If disabled, each player can place only one bet during a bidding. This does not apply to /rolls, as those are always one-shot only."
L.BM_AllowLesser = "Accept lower bets"
L.BM_AllowLesser_d = "Accepts bets that have a lower value than a previous placed one, thus enabling players to lower their bet as the bidding goes"
L.BM_OverBid = "Allow overbidding"
L.BM_OverBid_d = "Lets guild members bid more DKP than they have"
L.BM_TestBets = "Cancel invalid bets"
L.BM_TestBets_d = "This will check every placed bets everytime a new bet is received. If any of the old bets becomes invalid, it is cancelled and the bidder is notified (if set so)"
L.BM_OutGuild = "Allow out-of-guild"
L.BM_OutGuild_d = "If enabled, players from outside the guild will be able to bet. DKP bidding is disabled anyway, as they don't have DKP. Defined externals are assumed to be in guild"
L.BM_AutoRoll = "Auto Roll"
L.BM_AutoRoll_d = "If set, QDKP will do an internal (hidden) roll if someone places a bet where a /roll is needed but wasn't made before placing the bet. If disabled, QDKP will reject the bet asking to /roll first"
L.BM_MinBid = "Minimum bet"
L.BM_MinBid_d="The minimum value a bet must reach to be accepted"
L.BM_MaxBid = "Maximum bet"
L.BM_MaxBid_d="The maximum value a bet can reach to be accepted"
L.MiscHeader="Miscellaneous Options"
L.BM_CatchRolls="Catch /roll"
L.BM_CatchRolls_d="Detects /rolls and acquires them during a bidding."
L.BM_HideWhisp="Hide whispered bets"
L.BM_HideWhisp_d="Hides the bets made via whispers from the chat window"
L.BM_GetWhispers="Bets from whispers"
L.BM_GetWhispers_d="Accepts bets received by whispers"
L.BM_GetGroup="Bets from Raid chat"
L.BM_GetGroup_d="Accepts bets received by raid/party/BG chat"
L.BM_GiveToWinner="Give won item to winner"
L.BM_GiveToWinner_d='Once a winner is announced with an item as bet object, QDKP will try to give that item to the winner.\nFor this feature to work you must make sure that:\n-The raid looting method is set at "Master Looter"\n-The officer managing the bidding is set as Master Looter\n-The looting window is open and the item is still there\nThe winner is elegible to loot the won item'
L.BM_AckBets="Ack accepted bets"
L.BM_AckBets_d="Acknowledge accepted bets to the player that placed it"
L.BM_AckReject="Notify rejected bets"
L.BM_AckReject_d="Notify rejected bets with the reason of the reject"
L.BM_AckRejectChannel="Rejects channel"
L.BM_AckBetsChannel="Acknowledge channel"
L.BM_AckChannel_d='The channel where to route the notification. "Bid" means the channel where the bet was acquired. "Whisper" will send a private wisper to the given player.'
L.BM_ConfirmWinner="Confirm Winner"
L.BM_ConfirmWinner_d="Ask for confirmation before processing a winner"
L.BM_LogBets = "Log bets"
L.BM_LogBets_d = "If set, QDKP will log every placed bet in the player's log"
L.BM_RoundValue = "Round value"
L.BM_RoundValue_d = 'Rounds the "Value" field to the nearest integer. The DKP amounts related to the bidding are rounded regardless of this setting'
L.BidKeywords='Keyword editor'
L.BM_KW_Keyword='Triggering words'
L.BM_KW_Keyword_d='Enter here the word that will trigger this keyword. Multiple words can be entered separated by a comma'
L.BM_KW_Value='Value field'
L.BM_KW_Value_d='Enter an expression for the bet value. If omitted, any number in the triggering message will be used as value'
L.BM_KW_DKP='DKP field'
L.BM_KW_DKP_d='Enter an expression for the DKP amount to charge the winner for, if different from the bid value'
L.BM_KW_Min='Min value'
L.BM_KW_Min_d='Enter an expression for the minimum value the bet must reach to be accepted, if different from the global minimum bet specified in the general bidding settings'
L.BM_KW_Max='Max value'
L.BM_KW_Max_d='Enter an expression for the maximum value the bet can reach, if different from the global maximum bet specified in the general bidding settings'
L.BM_KW_Eligible='Eligibility'
L.BM_KW_Eligible_d='If needed, enter here an expression to test for eligibility. If it returns false or nil the bet will be rejected. If the field is left empty all bets matching this keyword will be assumed eligible'
L.BM_KW_Test="Test Keyword"
L.BM_KW_Test_d="Tests the current keyword. The test is performed in a ideal condition, so a succesful test doesn't mean the keyword won't fail under any condition, expecially for complex keywords. If the test fails, however, the keyword has definitely something wrong"
L.BM_KW_Del='Delete Keyword'
L.DefaultKWProfile='Preset systems'
L.DefaultKWProfile_d=
'Quick DKP comes preloaded with a set of template bidding rules to help you setup your looting system.\
Just choose the one that is most close to your own bidding system and then tweak the keywords to meet your needs.\
Please note that choosing a preset will clear all existing keywords, including custom ones. If you need to try things out, you should probably activate a temporary profile.'
L.DefaultKWProfile_c="Applying a preset bidding system will overwrite all your current keywords. There's no undo, if you what to save them you should activate a different setting profile.\nDo you still want to apply the preset bidding system?"

L.Awarding="Awarding"
L.BA="Raid Award"
L.ByInstance="Boss award by instance"
L.InstHelpText='Here you can enter a default DKP amount to give every time a boss is slain in a given instance for every difficulty'
L.ByName="Boss award by name"
L.AddNewBoss="Add new Boss"
L.TIM="Hourly bonus"
L.AW_TIM_Period="Time to tick"
L.AW_TIM_Period_d="The time between ticks, in minutes. Must be a multiple of 6"
L.AW_TIM_ShowAward="Show Awards"
L.AW_TIM_ShowAward_d="Shows a message whenever someone gets the hourly bonus"
L.AW_TIM_RaidLogTicks="Log Ticks"
L.AW_TIM_RaidLogTicks_d="Logs every timer tick in the raid log"
L.IM='Iron Man bonus'
L.AW_IM_PercReq="Required attendance"
L.AW_IM_PercReq_d="Required percentage of raid time the players need to attend in order to be awarded by the IronMan bonus"
L.AW_IM_InWhenStarts="In at start"
L.AW_IM_InWhenStarts_d="If enabled, players will need to be in raid and online as the starter IronMan mark is placed to be awarded by the IronMan bonus"
L.AW_IM_InWhenEnds="In at end"
L.AW_IM_InWhenEnds_d="If enabled, players will need to be in raid and online as IronMan is closed to be awarded by the IronMan bonus"
L.ZS="ZeroSum award"
L.AW_ZS_UseAsCharge="Use ZS"
L.AW_ZS_UseAsCharge_d="Sets ZS as default payment method instead of the plain DKP loss."
L.AW_ZS_GiveZS2Payer="Give ZS to payer"
L.AW_ZS_GiveZS2Payer_d="If set, the paying character will be included in the ZS share, thus getting back some of the DKP he gave"
L.AW_CtlHeader = "Award exceptions"
L.AW_OfflineCtl = "Offline"
L.AW_ZoneCtl = "Out of zone"
L.AW_RankCtl = "Rank"
L.AW_AltCtl = "Alts"
L.AW_StandbyCtl = "Standby raider"
L.AW_ExternalCtl = "Guild external"
L.AW_OfflineCtl_d = "Select the award percentage to give to players that are offline the moment the award is given. Set to 0% to give no award, 100% to give the full award or any custom percentage to give a fraction of it."
L.AW_ZoneCtl_d = "Select the award percentage to give to players that are in a different zone from the Raid Leader (read: not in the raid instance) the moment the award is given. Set to 0% to give no award, 100% to give the full award or any custom percentage to give a fraction of it."
L.AW_RankCtl_d = "Select the award percentage to characters whose rank is in the Special Rank list in the Misc tab. Set to 0% to give no award, 100% to give the full award or any custom percentage to give a fraction of it."
L.AW_AltCtl_d = "Select the award percentage to give to characters that are defined alts. Set to 0% to give no award, 100% to give the full award or any custom percentage to give a fraction of it."
L.AW_StandbyCtl_d = "Select the award percentage to give to characters that have been manually added to Quick DKP raid roster as standby raiders. Set to 0% to give no award, 100% to give the full award or any custom percentage to give a fraction of it."
L.AW_ExternalCtl_d = "Select the award percentage to give to characters that are defined guild externals. Set to 0% to give no award, 100% to give the full award or any custom percentage to give a fraction of it."
L.AW_Boss_CustomAmount = "Custom Amount"
L.AW_Boss_RemoveBoss = "Cancel boss entry"
L.AW_Boss_SelectBoss10 = "10 players amount"
L.AW_Boss_SelectBoss25 = "25 players amount"
L.AW_Boss_SelectBoss_d = 'Sets the award for the kill of this boss. You can set to leave the default amount defined in the "by instance" section, you can set to not give any award at all or you can enter a custom amount.'
L.AW_Boss_Name = "Boss name"
L.AW_Boss_Name_d = "Please enter the boss name. The name must be the exact boss name OR the name given by your boss mod"
L.AW_Boss_UseTarget="Set name as target"

L.Misc="Misc"
L.MISC_MaxNetDKP="Max Net DKP"
L.MISC_MinNetDKP="Min Net DKP"
L.AW_SpecialRanks="Special Ranks"
L.MISC_HidRanks="Hidden Ranks"
L.MISC_MinLevel="Minimum Level"
L.MISC_UploadOn_Raid="On Raid Award"
L.MISC_UploadOn_Tick="On Timer Tick"
L.MISC_UploadOn_Hourly="On Hourly Award"
L.MISC_UploadOn_IronMan="On IronMan"
L.MISC_UploadOn_Payment="On Payment"
L.MISC_UploadOn_Modif="On Modification"
L.MISC_UploadOn_ZS="On ZeroSum"
L.MISC_PromptWinDetect="Prompt for Winner det."
L.MISC_DetectWinTrig="Triggers for Winner det."
L.LOG_MaxRaid="Max Raid log voices"
L.LOG_MaxPlayer="Max Player log voices"
L.LOG_MaxSession="Max sessions"
L.MISC_Inf_WentNeg="Inform going negative"
L.MISC_Inf_IsNeg="Inform when negative"
L.MISC_Inf_NewMember="Show new guild members"
L.MISC_Inf_NoInGuild="Show external in raid"
L.MISC_Report_Header="Report header"
L.MISC_Report_Tail="Report tail"
L.MISC_Export_Header="Export header"
L.MISC_NotifyText="Notification text"
L.MISC_NotifyText3rd="Notification text (3rd)"
L.MISC_TimeInHours="Time in hours"
L.MISC_TimeInDOW="Time in DOW"
L.MISC_TimeZoneCtl="Timezone det. override"

L.MISC_MaxNetDKP_d='Maximum net DKP amount a player can have. Any further gains will be discarded.\nThis control range depends upon the settings in the "Guild Notes" section.'
L.MISC_MinNetDKP_d='Minimum net DKP amount a player can have. Any further losses will be discarded.\nThis control range depends upon the settings in the "Guild Notes" section.'
L.AW_SpecialRanks_d='Ranks selected here will fall under the "Rank" limitation in the "Awarding" tabs.\nYou can toggle a rank simply by selecting it in the list. Selected ranks are the green ones.'
L.MISC_HidRanks_d="Ranks selected here will be removed from Quick DKP guild roster.\nYou can toggle a rank simply by selecting it in the list. Selected ranks are the green ones."
L.MISC_MinLevel_d="Players which level is lesser than the one set here will be removed from Quick DKP roster"

L.MISCUploadHeader="Automatic upload"
L.MISC_UploadOn_Raid_d="Triggers a DKP upload whenever a Raid Award is given, like the Boss Bonus"
L.MISC_UploadOn_Tick_d="Triggers a DKP upload on every timer tick"
L.MISC_UploadOn_Hourly_d="Triggers a DKP upload every time someone gets the hourly bonus."
L.MISC_UploadOn_IronMan_d="Triggers a DKP upload whenever the IronMan bonus is given out"
L.MISC_UploadOn_Payment_d="Triggers a DKP upload on loot payments. This includes the bid manager"
L.MISC_UploadOn_Modif_d="Triggers a DKP upload every time a player DKP are changed for whatever reason"
L.MISC_UploadOn_ZS_d="Triggers a DKP upload whenever a ZeroSum payment is performed"
L.MISC_PromptWinDetect_d="Pops up a window asking to activate the Winner Detection feature every time a boss is slain.\nIf you're using the bid manager you won't need this"
L.MISC_DetectWinTrig_d="List of words that will trigger the Winner Detection.\nIf you're using the bid manager you won't need this."
L.MISCLogHeader="Logging"
L.LOG_MaxRaid_d="Max log entries Quick DKP can store in the raid log for each session"
L.LOG_MaxPlayer_d="Max log entries Quick DKP can store in each player log for each session"
L.LOG_MaxSession_d="Max number of sessions Quick DKP keeps at any time.\nThis setting has a great impact on Quick DKP memory use."
L.MISCInfHeader="Warnings"
L.MISC_Inf_WentNeg_d="Warn if a player net DKP amount becomes negative"
L.MISC_Inf_IsNeg_d="Warn if a player net DKP amount is negative every time a DKP modification is performed. Can be very spammy."
L.MISC_Inf_NewMember_d="When Quick DKP detects new guild members, show their name in the chat box"
L.MISC_Inf_NoInGuild_d="If enabled, Quick DKP will warn about every player in raid that is not in guild."
L.MISCTextHeader="Headers and messages"
L.MISC_Report_Header_d="Header for every log report. Valid variables are $NAME for the reported player name and $TYPE for the type of the report"
L.MISC_Report_Tail_d="Message to append to the end of every log report"
L.MISC_Export_Header_d="Header for the TXT and HTML exprts"
L.MISC_NotifyText_d="Notification message sent when the subject of the notification is the receipt of the message, too"
L.MISC_NotifyText3rd_d="Notification message sent when the subject of the notification is differend from the messagge receipt"
L.MISC_TimeInHours_d="Max time from now, in hours, for a date to be printed with time only, like HH:MM:SS"
L.MISC_TimeInDOW_d="Max time from now, in days, for a date to be printed with Day of Week instead of the full date"
L.MISC_TimeZoneCtl_d="Quick DKP tries to guess your time zone calculating the difference between your local time and the server time. You can override this by setting here the timezone delta, in hours."


L.Announce = "Announcement"
L.AN_AnAwards = "Announce Awards"
L.AN_AnAwards_d ="Enable the announcement of raid awards. This includes boss awards."
L.AN_AnIM = "Announce IronMan"
L.AN_AnIM_d ="Enable the announcement of IronMan bonus award."
L.AN_AnPlChange = "Announce Player Changes"
L.AN_AnPlChange_d ="Enable the announcement of player based DKP change, like loot payment and custom DKP modifications"
L.AN_AnNegative = "Announce Negative"
L.AN_AnNegative_d ="Enable an announcement whenever the net DKP amount of a player goes negative"
L.AN_AnTimerTick = "Announce Timer Tick"
L.AN_AnTimerTick_d ="Enable the announcement of timer ticks"
L.AN_AnChannel = "Announcement channel"
L.PushHeader = "notification"
L.AN_PushChanges = "Notify Modifications"
L.AN_PushChanges_d ="Lets QDKP notify every DKP modification whispering the relative player"
L.AN_PushFailAw = "Notify Lost RaidAwards"
L.AN_PushFailAw_d ="Notifies a raid member if he's not eligible for a raid award for any reason. This includes boss awards"
L.AN_PushFailHo = "Notify Lost Hourly Bonus"
L.AN_PushFailHo_d ="Notifies a raid member if he's not eligible for the hourly bonus"
L.AN_PushFailIM = "Notify Lost IronMan"
L.AN_PushFailIM_d ="Notifies a raid member if he loses the Iron Man bonus"
L.AN_PushModText = "Text for DKP Change"
L.AN_PushModReasText = "Text for DKP Change with reason"
L.AN_PushRevText = " Text when reverting changes"

L.BrcDesc1="The Guild Master may use this feature to send his active profile to one or all of the guildmembers. He can set QDKP to automatically broadcast his profile every given minutes."
L.BrcDesc2=
"Regular guiidmembers' Quick DKP addon will automatically set the config profile to the one sent by the Guild Master. DKP Officers can avoid this by setting an option in this tab, so they can have a custom profile. The profile sent by the GM will be received and imported anyway, but the addon wont switch automatically to it. Please mind that this override can lead to different configuration in basilar settings like the boss awards amount or in the bid manager. If you disable the automatic profile, you're on your own.\
Only the Guild Master can set the automatic broadcast of the addon configuration, DKP officers can only send their active profile to the Guild Master, on permission. This is intended to be a way for them to take care of the DKP rules for the GM, but still giving him control over what is being broadcast to the guild.\n"
L.BRC_AutoSendEn = "Automatic broadcast"
L.BRC_ActiveProf = "Active profile: %q"
L.BRC_GuildProf = "Guild (broadcast) profile: %q"
L.BRC_SendGM='Send config to GM'
L.BRC_SendGM_d='Sends the active profile to the Guild Master. He will be asked for confirmation to import your settings, and they will be stored in the same profile name you are using.'
L.BRC_SendToAll = 'Send to Guild now'
L.BRC_SendToAll_d = 'Broadcasts the current configuration profile to every online guild member with QDKP active now.'
L.BRC_SendToName='Send to'
L.BRC_SendToName_d = "Sends the active profile to the given guild member. Can't be used if the automatic broadcast is active"
L.BRC_AutoSendTime = 'Time between broadcasts'
L.BRC_AutoSendTime_d = 'Time interval, in minutes, between broadcasts of the current setting profile.'
L.BRC_OverrideBroadcast = 'Override broadcast'
L.BRC_OverrideBroadcast_d = "If set, the settings broadcasts by the Guild Master will be imported but they WON'T be set as active profile. Enable this if you want to run QDKP with a different ruleset than the one used by your guild"

L.GuildNotes="Guild Notes"
L.ChangeNotesDesc1="Quick DKP can store DKP amounts either in the guild's pubblic OR officer notes\n"
L.ChangeNotesDesc2="PLEASE CARE!"
L.FOR_OfficerOrPublic = "Store DKP in"
L.FOR_OfficerOrPublic_d= 'Sets Quick DKP to use the public or officer notes to store DKP amounts'
L.FOR_OfficerOrPublic_c="You are about to switch DKP storing. Please make sure you are following the described steps to prevent DKP losses"
L.Formatting="Formatting"
L.FOR_TotalOrSpent="Store lifetime"
L.FOR_TotalOrSpent_d="To work properly, Quick DKP must know the lifetime amount of DKP earned and spent for each character. To accomply this, either the earned or the spent amounts must be stored in the notes along with the net DKP amount. This lets you control wich one you want to use."
L.FOR_CompactNote="Compact labels"
L.FOR_CompactNote_d='Tells Quick DKP to use "N", "T" and "H" instead of "Net", "Tot" and "Hrs" as labels when storing DKP amounts in the public/officer notes. This frees space in the notes for bigger numbers and therefore should be used if any amount in the notes of every character is getting close to the soft DKP caps of +1.000.000 or -100.000 DKP. Enabling this setting lets you store numbers 100 times as big.'
L.FOR_StoreHours="Store hours"
L.FOR_StoreHours_d="Stores the cumulative raiding time with the net and the total DKP amount, so officers can track the attendance of guild members. Disabling this won't prevent the hourly bonus to work but will hide the Hours table from the guild/raid roster. One could be disable these either to simplify the notes layout or to free notes space for bigger DKP amounts."
L.FOR_ImportAlts="Read alts"
L.FOR_ImportAlts_d="If enabled, Alts will be imported from guild notes"
L.ChangeNotesDesc3=
'By changing this the DKP amounts will be reset. To safely accomplish the switch of storing system without risk of losing DKP on the road you MUST follow exactly these steps:\
1-Make a backup\
2-Change this setting\
3-Push "Revert" in Quick DKP main window. Check in the roster that all the DKP amounts are 0\
4-Restore the backup you did earlier\
5-Upload changes and wait for confirmation that all DKP in sync\
6-If you are the Guild Master, broadcast your settings to the guild. If you arent, send your settings to the GM and ask him to broadcast them to the guild immediately.\
If you have any dkp officer in your guild, you should really do this only when all of them are online and not editing DKP.'


L.Looting="Looting"
L.LOOTOptions='Loot options'
L.LOOTQualTresh="Quality thresholds"
L.LOOT_Qual_RaidLog="Log in Raid"
L.LOOT_Qual_RaidLog_d="Minimum quality for a looted item to appear in the Raid Log"
L.LOOT_Qual_PlayerLog="Log in Player"
L.LOOT_Qual_PlayerLog_d="Minimum quality for a looted item to appear in the looter Player Log"
L.LOOT_Qual_ChargeKey='Keybind memory'
L.LOOT_Qual_ChargeKey_d='Minimum quality for a looted item to be set in the "Pay loot" keybind function. Pressing that keybind will let you charge the looter.'
L.LOOT_Qual_ChargeChat="Chat memory"
L.LOOT_Qual_ChargeChat_d='Minimum quality for a looted item to be set in the "Charge chat" function. This function is used by the Winner Detection feature or the "\dkp charge chat" command'
L.LOOT_Qual_ReasonHist="Reason history"
L.LOOT_Qual_ReasonHist_d="Minimum quality for a looted item to be added to the history of the Reason field in the toolbox. You can cycle that history with the up and down key while the cursor is in said field"
L.LOOT_Qual_PopupTB="Popup Toolbox"
L.LOOT_Qual_PopupTB_d='Minimum quality for a looted item to automatically open the toolbox whenever a raider loots it. Works only if the option "Toolbox on loot" is enabled.'
L.LOOTSettingsHeader="Settings"
L.LOOT_OpenToolbox='Toolbox on loot'
L.LOOT_OpenToolbox_d="If enabled, Quick DKP will open the toolbox whenever anyone loots an item even if no price is defined"
L.LOOT_LogBadge="Log badges"
L.LOOT_LogBadge_d="Enables Quick DKP to log money-class items to be logged when looted"
L.LOOT_LogDisench="Log shards"
L.LOOT_LogDisench_d="Enables Quick DKP to log enchant materials got when disenchanting items"
L.LOOTToLog="Items to log"
L.LOOT_Item_Add="Add Item"
L.LOOT_Item_Name = "Item Name"
L.LOOT_Item_Name_d="Enter the item name. You can shift+click an item to make it appear here"
L.LOOT_Item_SelectP="Fixed price"
L.LOOT_Item_SelectP_d='Sets the DKP price for looting the this item. You can set to leave the default amount defined in the "by instance" section, you can disable the fixed price or you can enter a custom amount.'
L.LOOT_Item_CustomP=""
L.LOOT_Item_NotifyLoot="Loot logging and warning"
L.LOOT_Item_NotifyLoot_d="You can set Quick DKP to report looting of this item in various ways. You can force the logging indipendently from the item rarity, it can show a message in the chat box or display a warning dialog\nYou can use this also to prevent logging of items that are logged when looted by default"
L.LOOT_Item_Cancel="Remove Item"
L.LOOTPriceInst="Prices by Instance"
L.LOOTPriceItem="Prices by Item"

--Messages

L.MESS_AllowImport=
"%s wants to send a setting profile\
for Quick DKP.\
name: %q\
If this in unexpected don't click yes.\
Do you want to import his settings?"


end
