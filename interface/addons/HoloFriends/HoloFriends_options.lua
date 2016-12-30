--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

local index, i;
local HF_Options_Loaded = false;
local HF_FrameBaseName = "HoloFriends_OptionsFrameScrollChild_ID";
local HF_nButtons = 4;
local HI_nButtons = 4;

local HF_PriorList = { "ButtonFLWhisper", "ButtonFLInvite", "ButtonFLAddFriend", "ButtonFLAddComment" };
local HI_PriorList = { "ButtonILAddIgnore", "ButtonILAddComment", "ButtonILRmIgnore", "ButtonILAddGroup" };

-- define all the names of the options (this are the identifiers, don't change)
local HF_OptionNames = {};
i=1;   HF_OptionNames[i] = "ShowClassIcons";
i=i+1; HF_OptionNames[i] = "ShowClassColor";
i=i+1; HF_OptionNames[i] = "ShowLevel";
i=i+1; HF_OptionNames[i] = "BNShowCharName";
i=i+1; HF_OptionNames[i] = "BNCharNameFirst";
i=i+1; HF_OptionNames[i] = "ShowGroups";
i=i+1; HF_OptionNames[i] = "GroupsShowOnline";
i=i+1; HF_OptionNames[i] = "SortOnline";
i=i+1; HF_OptionNames[i] = "SetDateFormat";
i=i+1; HF_OptionNames[i] = "DisableWho";

i=i+1; HF_OptionNames[i] = "MergeNotes";
i=i+1; HF_OptionNames[i] = "NotesPriorityOn";
i=i+1; HF_OptionNames[i] = "NotesPriorityOff";

i=i+1; HF_OptionNames[i] = "MergeComments";
i=i+1; HF_OptionNames[i] = "MarkRemove";

i=i+1; HF_OptionNames[i] = "MenuNoTaint";
i=i+1; HF_OptionNames[i] = "MenuModT";
i=i+1; HF_OptionNames[i] = "MenuModP";
i=i+1; HF_OptionNames[i] = "MenuModR";
i=i+1; HF_OptionNames[i] = "MenuModF";
i=i+1; HF_OptionNames[i] = "ShowDropdownBG";
i=i+1; HF_OptionNames[i] = "ShowDropdownAllBG";

i=i+1; HF_OptionNames[i] = "ShowOnlineAtLogin";

i=i+1; HF_OptionNames[i] = "MsgIgnoredWhisper";

i=i+1; HF_OptionNames[i] = "ButtonFLWhisper";
i=i+1; HF_OptionNames[i] = "ButtonFLInvite";
i=i+1; HF_OptionNames[i] = "ButtonFLAddComment";
i=i+1; HF_OptionNames[i] = "ButtonFLAddFriend";
i=i+1; HF_OptionNames[i] = "ButtonFLAddGroup";
i=i+1; HF_OptionNames[i] = "ButtonFLRenGroup";
i=i+1; HF_OptionNames[i] = "ButtonFLRmFriend";
i=i+1; HF_OptionNames[i] = "ButtonFLRmGroup";
i=i+1; HF_OptionNames[i] = "ButtonFLWho";

i=i+1; HF_OptionNames[i] = "ButtonILAddComment";
i=i+1; HF_OptionNames[i] = "ButtonILAddIgnore";
i=i+1; HF_OptionNames[i] = "ButtonILAddGroup";
i=i+1; HF_OptionNames[i] = "ButtonILRenGroup";
i=i+1; HF_OptionNames[i] = "ButtonILRmIgnore";
i=i+1; HF_OptionNames[i] = "ButtonILRmGroup";

-- assign option IDs to the option names to allow a reference by names
local HF_OptionNameIDs = {};
for index = 1, table.getn(HF_OptionNames) do
	HF_OptionNameIDs[HF_OptionNames[index]] = index;
end

-- define the defaults for all options
local HF_DefaultOptions = {};
i=1;   HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = false;

i=i+1; HF_DefaultOptions[i] = true; -- trigger for the next two options
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = false;

i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;

i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = false;

i=i+1; HF_DefaultOptions[i] = false;

i=i+1; HF_DefaultOptions[i] = true;

i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = false;

i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = false;
i=i+1; HF_DefaultOptions[i] = true;
i=i+1; HF_DefaultOptions[i] = true;

-- temporary options for the options pannel
local HF_TempOptions = {};
for index = 1, table.getn(HF_DefaultOptions) do
	HF_TempOptions[index] = HF_DefaultOptions[index];
end
HoloFriends_TempTTDateFormat = HOLOFRIENDS_TOOLTIPDATEFORMAT;

-- copy the option strings to the strings array (numbered by the IDs)
local HF_OptionStrings = {};
i=1;   HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1SECTIONFLW;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1SHOWCLASSICONS;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1SHOWCLASSCOLOR;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1SHOWLEVEL;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1BNSHOWCHARNAME;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRST;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1SHOWGROUPS;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1GROUPSSHOWONLINE;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1SORTONLINE;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1SETDATEFORMAT;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS1DISABLEWHO;

i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS2SECTIONNOTES;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS2MERGENOTES.."\n|cffffd200("..HOLOFRIENDS_OPTIONS0NOTFACTION..")|r";
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS2NOTESPRIORITYON.."\n|cffffd200("..HOLOFRIENDS_OPTIONS0RELATEBEFORE..")|r";
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFF.."\n|cffffd200("..HOLOFRIENDS_OPTIONS0RELATEABOVE..")\n("..HOLOFRIENDS_OPTIONS0REALID..")|r";

i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS3SECTIONSHARE;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS3MERGECOMMENTS.."\n|cffffd200("..HOLOFRIENDS_OPTIONS0NEEDACCEPT..")|r";
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS3MARKREMOVE;

i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS4SECTIONMENU;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS4MENUNOTAINT.."\n|cffffd200("..HOLOFRIENDS_OPTIONS0NEEDRELOAD..")|r";
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS4MENUMODT.."\n|cffffd200("..HOLOFRIENDS_OPTIONS0NEEDRELOAD..")|r";
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS4MENUMODP.."\n|cffffd200("..HOLOFRIENDS_OPTIONS0NEEDRELOAD..")|r";
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS4MENUMODR.."\n|cffffd200("..HOLOFRIENDS_OPTIONS0NEEDRELOAD..")|r";
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS4MENUMODF.."\n|cffffd200("..HOLOFRIENDS_OPTIONS0NEEDRELOAD..")|r";
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBG;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBG;

i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS5SECTIONSTART;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS5SHOWONLINEATLOGIN;

i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS6SECTIONIGNORE;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS6MSGIGNOREDWHISPER;

i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS7SECTIONFLBUTTONS;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS0BUTTONORDER;
i=i+1; HF_OptionStrings[i] = WHISPER;
i=i+1; HF_OptionStrings[i] = INVITE;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_WINDOWMAINADDCOMMENT;
i=i+1; HF_OptionStrings[i] = ADD_FRIEND;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_WINDOWMAINADDGROUP;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_WINDOWMAINRENAMEGROUP;
i=i+1; HF_OptionStrings[i] = REMOVE_FRIEND;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_WINDOWMAINREMOVEGROUP;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_WINDOWMAINWHOREQUEST;

i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS8SECTIONILBUTTONS;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_OPTIONS0BUTTONORDER;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_WINDOWMAINADDCOMMENT;
i=i+1; HF_OptionStrings[i] = IGNORE_PLAYER;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_WINDOWMAINADDGROUP;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_WINDOWMAINRENAMEGROUP;
i=i+1; HF_OptionStrings[i] = STOP_IGNORE;
i=i+1; HF_OptionStrings[i] = HOLOFRIENDS_WINDOWMAINREMOVEGROUP;

-- the number of option strings
HoloFriendsOptions_nOptionStrings = table.getn(HF_OptionStrings);

-- copy the option tooltip strings to the strings array (numbered by the IDs)
local HF_ToolTipStrings = {};
i=1;   HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1SHOWCLASSICONSTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1SHOWCLASSCOLORTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1SHOWLEVELTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1BNSHOWCHARNAMETT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRSTTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1SHOWGROUPSTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1GROUPSSHOWONLINETT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1SORTONLINETT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1SETDATEFORMATTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS1DISABLEWHOTT;
i=i+1; HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS2MERGENOTESTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS2NOTESPRIORITYONTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFFTT;
i=i+1; HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS3MERGECOMMENTSTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS3MARKREMOVETT;
i=i+1; HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS4MENUNOTAINTTT
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS4MENUMODTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS4MENUMODTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS4MENUMODTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS4MENUMODTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBGTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBGTT;
i=i+1; HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS5SHOWONLINEATLOGINTT;
i=i+1; HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS6MSGIGNOREDWHISPERTT;
i=i+1; HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS7WHISPERTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS7INVITETT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS87ADDCOMMENTTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS7ADDFRIENTTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS87ADDGROUPTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS87RENAMEGROUPTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS7REMOVEFRIENDTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS87REMOVEGROUPTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS7WHOTT;
i=i+1; HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = "";
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS87ADDCOMMENTTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS8ADDIGNORETT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS87ADDGROUPTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS87RENAMEGROUPTT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS8REMOVEIGNORETT;
i=i+1; HF_ToolTipStrings[i] = HOLOFRIENDS_OPTIONS87REMOVEGROUPTT;

-- relate all the IDs to the options
-- assign string IDs to the option names to allow a reference by names
HoloFriends_OptionStringIDs = {};
-- reference string IDs to option IDs
local HF_OptionIDs = {};
local idx = 0;
for index = 1, table.getn(HF_ToolTipStrings) do
	if ( HF_ToolTipStrings[index] ~= "" ) then
		idx = idx + 1;
		HF_OptionIDs[index] = idx;
		HoloFriends_OptionStringIDs[HF_OptionNames[idx]] = index;
	else
		HF_OptionIDs[index] = 0;
	end
end

local HF_FAQStrings = {};
-- FAQ
idx=1;     HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ011QUESTION.."|r\n"..HOLOFRIENDS_FAQ012ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ021QUESTION.."|r\n"..HOLOFRIENDS_FAQ022ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ031QUESTION.."|r\n"..HOLOFRIENDS_FAQ032ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ041QUESTION.."|r\n"..HOLOFRIENDS_FAQ042ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ051QUESTION.."|r\n"..HOLOFRIENDS_FAQ052ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ061QUESTION.."|r\n"..HOLOFRIENDS_FAQ062ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ071QUESTION.."|r\n"..HOLOFRIENDS_FAQ072ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ081QUESTION.."|r\n"..HOLOFRIENDS_FAQ082ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ091QUESTION.."|r\n"..HOLOFRIENDS_FAQ092ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ101QUESTION.."|r\n"..HOLOFRIENDS_FAQ102ANSWER;
idx=idx+1; HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_FAQ111QUESTION.."|r\n"..HOLOFRIENDS_FAQ112ANSWER;

-- feature list upended to the FAQ
idx=idx+1;
HF_FAQStrings[idx] = "|cffffd200"..HOLOFRIENDS_LISTFEATURES0TITLE.."|r";
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES11;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES12;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES13;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES14;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES15;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES16;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES17;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES18;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES19.." (|cffff0000"..NEW.."|r)";
idx=idx+1;
HF_FAQStrings[idx] = "- "..HOLOFRIENDS_LISTFEATURES21;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES22;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES23;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES24;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES25.." (|cffff0000"..NEW.."|r)";
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES26;
idx=idx+1;
HF_FAQStrings[idx] = "- "..HOLOFRIENDS_LISTFEATURES31;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES32;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES33;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES34;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES35;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES36;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES37;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES38;
idx=idx+1;
HF_FAQStrings[idx] = "- "..HOLOFRIENDS_LISTFEATURES41;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES42;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES43;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES44.." (|cffff0000"..NEW.."|r)";
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES45.." (|cffff0000"..NEW.."|r)";
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES46.." (|cffff0000"..NEW.."|r)";
idx=idx+1;
HF_FAQStrings[idx] = "- "..HOLOFRIENDS_LISTFEATURES51;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES52;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES53;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES54;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES55;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES56;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES57;
idx=idx+1;
HF_FAQStrings[idx] = "- "..HOLOFRIENDS_LISTFEATURES61;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES62;
HF_FAQStrings[idx] = HF_FAQStrings[idx].."\n- "..HOLOFRIENDS_LISTFEATURES63;

-- the number of FAQ strings
HoloFriendsOptions_nFAQStrings = table.getn(HF_FAQStrings);


local HF_FAQ_self = nil;
local HF_Opt_self = nil;
-- add the FAQ frame to the interface options panel of WoW
function HoloFriendsFAQ_OnLoad(self)
	self.name = HELP_LABEL;
	self.parent = HOLOFRIENDS_OPTIONS0LISTENTRY;
	-- add the category after all variables are loaded and the options category is added
	HF_FAQ_self = self;
--	InterfaceOptions_AddCategory(self);
end


-- executed during load of every text field in the FAQ frame
-- set the text blocks of the FAQ and make them visible
function HoloFriendsFAQ_Text_OnLoad(self)
	local tname = self:GetName().."_Text";
	local text = HF_FAQStrings[self:GetID()];
	getglobal(tname):SetText(text);
end


-- executet by HoloFriends_OnLoad
function HoloFriendsOptions_VariablesLoaded()
	local index;

	-- initialize our SavedVariable
	if ( not HOLOFRIENDS_OPTIONS ) then HOLOFRIENDS_OPTIONS = {}; end

	-- initialize special options
	if ( HOLOFRIENDS_OPTIONS.ShowOffFriends == nil ) then HOLOFRIENDS_OPTIONS.ShowOffFriends = true; end
	if ( not HOLOFRIENDS_OPTIONS.SearchFL ) then HOLOFRIENDS_OPTIONS.SearchFL = ""; end
	if ( not HOLOFRIENDS_OPTIONS.SearchIL ) then HOLOFRIENDS_OPTIONS.SearchIL = ""; end

	-- add the categories in the right order to the interface panel
	InterfaceOptions_AddCategory(HF_Opt_self);
	InterfaceOptions_AddCategory(HF_FAQ_self);

	-- load each option, set default if not there
	for index = 1, table.getn(HF_TempOptions) do
		if ( HOLOFRIENDS_OPTIONS[HF_OptionNames[index]] == nil ) then
			HOLOFRIENDS_OPTIONS[HF_OptionNames[index]] = HF_DefaultOptions[index];
		else
			HF_TempOptions[index] = HOLOFRIENDS_OPTIONS[HF_OptionNames[index]];
		end
	end

	-- initialize the date format
	if ( not HOLOFRIENDS_OPTIONS.TTDateFormat ) then
		HOLOFRIENDS_OPTIONS.TTDateFormat = HOLOFRIENDS_TOOLTIPDATEFORMAT;
	end
	if ( not HOLOFRIENDS_OPTIONS.SetDateFormat ) then
		HOLOFRIENDS_OPTIONS.TTDateFormat = HOLOFRIENDS_TOOLTIPDATEFORMAT;
	end
	HoloFriends_TempTTDateFormat = HOLOFRIENDS_OPTIONS.TTDateFormat;

	-- count the selected FL and IL buttons
	HF_nButtons = 0;
	HI_nButtons = 0;
	for index = 1, table.getn(HF_OptionNames) do
		local fname = (strsub(HF_OptionNames[index],1,8) == "ButtonFL");
		local iname = (strsub(HF_OptionNames[index],1,8) == "ButtonIL");
		local option = (HF_TempOptions[index]);
		if (fname and option ) then HF_nButtons = HF_nButtons + 1; end
		if (iname and option ) then HI_nButtons = HI_nButtons + 1; end
	end

	-- record that we have been loaded
	HF_Options_Loaded = true;

	-- apply the options
	HoloFriendsOptions_Apply();
end


-- add the options frame to the interface options panel of WoW
function HoloFriendsOptions_OnLoad(self)
	self.name = HOLOFRIENDS_OPTIONS0LISTENTRY;
	self.okay = function (self) HoloFriendsOptions_Okay(); end;
	self.cancel = function (self) HoloFriendsOptions_Cancel(); end;
	self.default = function (self) HoloFriendsOptions_SetAllToDefault(); end;
	-- add the category after all variables are loaded as the first category
	HF_Opt_self = self;
--	InterfaceOptions_AddCategory(self);
end


-- executed during load of every text field in the options frame
-- set the text string of the chapters or options and make one of both visible
function HoloFriendsOptions_Text_OnLoad(self)
	local ID = self:GetID();
	local Fname = self:GetName();
	local Fcname = Fname.."_Chapter";
	local Fhname = Fname.."_Comment";
	local Ftname = Fname.."_Text";
	local Fbname = Fname.."_Button";
	local isChapter = ( HF_ToolTipStrings[ID] == "" );
	local text = HF_OptionStrings[ID];
	if ( isChapter ) then
		if ( string.sub(text, 1, 1) == "(" ) then
			getglobal(Fcname):Hide();
			getglobal(Fhname):SetText(text);
		else
			getglobal(Fcname):SetText(text);
			getglobal(Fhname):Hide();
		end
		getglobal(Ftname):Hide();
		getglobal(Fbname):Hide();
	else
		getglobal(Fcname):Hide();
		getglobal(Fhname):Hide();
		getglobal(Ftname):SetText(text);
	end
end


-- enable/disable FL or IL buttons if less/equal than 4 buttons are selected
local function HOF_ChangeFLorILbuttons()
	local index;
	for index = 1, table.getn(HF_OptionNames) do
		local fname = (strsub(HF_OptionNames[index],1,8) == "ButtonFL");
		local iname = (strsub(HF_OptionNames[index],1,8) == "ButtonIL");
		local option = (HF_TempOptions[index]);
		local f4 = (HF_nButtons == 4);
		local i4 = (HI_nButtons == 4);
		local idx = HoloFriends_OptionStringIDs[HF_OptionNames[index]];
		if ( fname or iname ) then
			if ( ( (fname and f4) or (iname and i4) ) and not option ) then
				getglobal(HF_FrameBaseName..idx.."_Button"):Disable();
				getglobal(HF_FrameBaseName..idx.."_Text"):SetTextColor(0.4,0.4,0.4);
			else
				getglobal(HF_FrameBaseName..idx.."_Button"):Enable();
				getglobal(HF_FrameBaseName..idx.."_Text"):SetTextColor(1.0,1.0,1.0);
			end
		end
	end
end

-- executed if the options window is shown
function HoloFriendsOptions_OnShow()
	-- make sure that our profile has been loaded
	if ( not HF_Options_Loaded ) then
		return;
	end

	local button;
	local index;
	for index = 1, table.getn(HF_OptionIDs) do
		if ( HF_OptionIDs[index] > 0 ) then
			button = getglobal(HF_FrameBaseName..index.."_Button");
			button:SetChecked((HF_TempOptions[HF_OptionIDs[index]]));
		end
	end

	-- enable/disable buttons for merging of in-game notes and HoloFriends comments
	local NotFaction = HoloFriendsFuncs_IsCharDataAvailable(HOLOFRIENDS_LIST, UnitName("player"));
	if ( HF_TempOptions[HF_OptionNameIDs["MergeNotes"]] and NotFaction ) then
		index = HoloFriends_OptionStringIDs["MergeNotes"];
		getglobal(HF_FrameBaseName..index.."_Button"):Enable();
		getglobal(HF_FrameBaseName..index.."_Text"):SetTextColor(1.0,1.0,1.0);
		index = HoloFriends_OptionStringIDs["NotesPriorityOn"];
		getglobal(HF_FrameBaseName..index.."_Button"):Enable();
		getglobal(HF_FrameBaseName..index.."_Text"):SetTextColor(1.0,1.0,1.0);
		index = HoloFriends_OptionStringIDs["NotesPriorityOff"];
		getglobal(HF_FrameBaseName..index.."_Button"):Disable();
		getglobal(HF_FrameBaseName..index.."_Text"):SetTextColor(0.4,0.4,0.4);
	else
		if ( NotFaction ) then
			index = HoloFriends_OptionStringIDs["MergeNotes"];
			getglobal(HF_FrameBaseName..index.."_Button"):Enable();
			getglobal(HF_FrameBaseName..index.."_Text"):SetTextColor(1.0,1.0,1.0);
		else
			index = HoloFriends_OptionStringIDs["MergeNotes"];
			getglobal(HF_FrameBaseName..index.."_Button"):Disable();
			getglobal(HF_FrameBaseName..index.."_Text"):SetTextColor(0.4,0.4,0.4);
		end
		index = HoloFriends_OptionStringIDs["NotesPriorityOn"];
		getglobal(HF_FrameBaseName..index.."_Button"):Disable();
		getglobal(HF_FrameBaseName..index.."_Text"):SetTextColor(0.4,0.4,0.4);
		index = HoloFriends_OptionStringIDs["NotesPriorityOff"];
		getglobal(HF_FrameBaseName..index.."_Button"):Enable();
		getglobal(HF_FrameBaseName..index.."_Text"):SetTextColor(1.0,1.0,1.0);
	end

	-- include the date format in the button text
	local text = HOLOFRIENDS_OPTIONS1SETDATEFORMAT.." ("..HoloFriends_TempTTDateFormat..")";
	index = HoloFriends_OptionStringIDs["SetDateFormat"];
	getglobal(HF_FrameBaseName..index.."_Text"):SetText(text);
	-- >>> This ID is also set at StaticPopupDialogs["HOLOOPTIONS_DATEFORMAT"]

	-- enable/disable FL or IL buttons if less/equal than 4 buttons are selected
	HOF_ChangeFLorILbuttons();
end


-- executed from every option if the options window is changed to reset the text width and height
function HoloFriendsOptions_Button_OnUpdate(self)
	local chapter = ( HF_ToolTipStrings[self:GetID()] == "" );
	local text, comment;
	if ( chapter ) then
		text = getglobal(self:GetName().."_Chapter");
		if ( not text:GetText() ) then
			text = getglobal(self:GetName().."_Comment");
			chapter = false;
			comment = true;
		end
	else
		text = getglobal(self:GetName().."_Text");
	end
	text:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth()-65);
	local height = text:GetHeight();
	if ( math.max(20,height) == 20 ) then height = 20; end
	if ( chapter ) then height = height + 10; end
	if ( comment ) then height = height + 5; end
	self:SetHeight(height + 5);
end


-- executed if the mouse enter the check button to show the tooltip
function HoloFriendsOptions_Button_OnEnter(self)
	local text = HF_ToolTipStrings[self:GetParent():GetID()];
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
	GameTooltip:SetText(text, 1.0, 1.0, 1.0, 1.0, 1);
end


-- modify pending options if a check button is clicked
function HoloFriendsOptions_Button_OnClick(self)
	local index = HF_OptionIDs[self:GetParent():GetID()];
	if ( index ) then
		local idx;
		local fname = (strsub(HF_OptionNames[index],1,8) == "ButtonFL");
		local iname = (strsub(HF_OptionNames[index],1,8) == "ButtonIL");
		if(self:GetChecked()) then
			PlaySound("igMainMenuOptionCheckBoxOn");
			HF_TempOptions[index] = true;
			-- request a new date format
			if ( index == HF_OptionNameIDs["SetDateFormat"] ) then
				StaticPopup_Show("HOLOOPTIONS_DATEFORMAT");
			end
			-- disable/enable the corresponding options for the merging of notes and comments
			if ( index == HF_OptionNameIDs["MergeNotes"] ) then
				idx = HoloFriends_OptionStringIDs["NotesPriorityOn"];
				getglobal(HF_FrameBaseName..idx.."_Button"):Enable();
				getglobal(HF_FrameBaseName..idx.."_Text"):SetTextColor(1.0,1.0,1.0);
				idx = HoloFriends_OptionStringIDs["NotesPriorityOff"];
				getglobal(HF_FrameBaseName..idx.."_Button"):Disable();
				getglobal(HF_FrameBaseName..idx.."_Text"):SetTextColor(0.4,0.4,0.4);
			end
			-- change count of FL or IL buttons
			if ( fname ) then HF_nButtons = HF_nButtons + 1; HF_TempOptions[index] = HF_nButtons; end
			if ( iname ) then HI_nButtons = HI_nButtons + 1; HF_TempOptions[index] = HI_nButtons; end
		else
			HF_TempOptions[index] = false;
			-- reset the date format to the default
			if ( index == HF_OptionNameIDs["SetDateFormat"] ) then
				HoloFriends_TempTTDateFormat = HOLOFRIENDS_TOOLTIPDATEFORMAT;
				local text = HOLOFRIENDS_OPTIONS1SETDATEFORMAT.." ("..HoloFriends_TempTTDateFormat..")";
				idx = HoloFriends_OptionStringIDs["SetDateFormat"];
				getglobal(HF_FrameBaseName..idx.."_Text"):SetText(text);
			end
			-- disable/enable the corresponding options for the merging of notes and comments
			if ( index == HF_OptionNameIDs["MergeNotes"] ) then
				idx = HoloFriends_OptionStringIDs["NotesPriorityOn"];
				getglobal(HF_FrameBaseName..idx.."_Button"):Disable();
				getglobal(HF_FrameBaseName..idx.."_Text"):SetTextColor(0.4,0.4,0.4);
				idx = HoloFriends_OptionStringIDs["NotesPriorityOff"];
				getglobal(HF_FrameBaseName..idx.."_Button"):Enable();
				getglobal(HF_FrameBaseName..idx.."_Text"):SetTextColor(1.0,1.0,1.0);
			end
			-- change count of FL or IL buttons
			if ( fname ) then HF_nButtons = HF_nButtons - 1; end
			if ( iname ) then HI_nButtons = HI_nButtons - 1; end
		end
		-- enable/disable FL or IL buttons if less/equal than 4 buttons are selected
		if ( fname or iname ) then
			HOF_ChangeFLorILbuttons();
		end
	end
end


-- if 1 or 3 buttons are selected for the FL and IL window, fill up to 2 or 4 buttons
local function HOF_FillTo2or4Buttons()
	if ( (HF_nButtons == 1) or (HF_nButtons == 3) ) then
		local index = 0;
		while (index < 4) do
			index = index + 1;
			local idx = HF_OptionNameIDs[HF_PriorList[index]];
			if ( not HF_TempOptions[idx] ) then
				HF_nButtons = HF_nButtons + 1;
				HF_TempOptions[idx] = HF_nButtons;
				index = 4;
			end
		end
	end

	if ( (HI_nButtons == 1) or (HI_nButtons == 3) ) then
		local index = 0;
		while (index < 4) do
			index = index + 1;
			local idx = HF_OptionNameIDs[HI_PriorList[index]];
			if ( not HF_TempOptions[idx] ) then
				HI_nButtons = HI_nButtons + 1;
				HF_TempOptions[idx] = HI_nButtons;
				index = 4;
			end
		end
	end
end


-- executed if Okay-Button is pressed
function HoloFriendsOptions_Okay()
	-- make sure that our profile has been loaded
	if ( not HF_Options_Loaded ) then
		return;
	end

	HOF_FillTo2or4Buttons();

	for index = 1, table.getn(HF_TempOptions) do
		HOLOFRIENDS_OPTIONS[HF_OptionNames[index]] = HF_TempOptions[index];
	end
	HOLOFRIENDS_OPTIONS.TTDateFormat = HoloFriends_TempTTDateFormat;

	HoloFriendsOptions_Apply();
end


-- executed if Cancel-Button is pressed
function HoloFriendsOptions_Cancel()
	-- make sure that our profile has been loaded
	if ( not HF_Options_Loaded ) then
		return;
	end

	for index = 1, table.getn(HF_TempOptions) do
		HF_TempOptions[index] = HOLOFRIENDS_OPTIONS[HF_OptionNames[index]];
	end
	HoloFriends_TempTTDateFormat = HOLOFRIENDS_OPTIONS.TTDateFormat;
end


-- reset all options to defaults (Reset-Button pressed)
function HoloFriendsOptions_SetAllToDefault()
	-- make sure that our profile has been loaded
	if ( not HF_Options_Loaded ) then
		return;
	end

	-- set our profile to defaults
	for index = 1, table.getn(HF_TempOptions) do
		HF_TempOptions[index] = HF_DefaultOptions[index];
	end
	HoloFriends_TempTTDateFormat = HOLOFRIENDS_TOOLTIPDATEFORMAT;

	HoloFriendsOptions_OnShow()
end


-- apply the options
function HoloFriendsOptions_Apply()
	-- make sure that our profile has been loaded
	if ( not HF_Options_Loaded ) then
		return;
	end

	-- disable the /Who-scan button if option is set
	if ( HOLOFRIENDS_OPTIONS.DisableWho ) then
		HoloFriendsFrame_ScanExtrasButton:Disable();
	else
		HoloFriendsFrame_ScanExtrasButton:Enable();
	end

	local NotFaction = HoloFriendsFuncs_IsCharDataAvailable(HOLOFRIENDS_LIST, UnitName("player"));
	if ( HOLOFRIENDS_OPTIONS.MergeNotes and NotFaction ) then
		HOLOFRIENDS_OPTIONS.NotesPriority = HOLOFRIENDS_OPTIONS.NotesPriorityOn;
	else
		HOLOFRIENDS_OPTIONS.NotesPriority = HOLOFRIENDS_OPTIONS.NotesPriorityOff;
	end

	HoloFriends_chat("HoloFriends_List_Update from HoloFriendsOptions_Apply", HF_DEBUG_OUTPUT);
	HoloFriends_List_Update();

	if ( HoloIgnoreFrame:IsVisible() ) then
		HoloFriends_chat("HoloIgnore_List_Update from HoloFriendsOptions_Apply", HF_DEBUG_OUTPUT);
		HoloIgnore_EventFlags.ListUpdateStartTime = HoloFriends_ListUpdateRefTime;
		HoloIgnore_List_Update();
	end
end
