
REAGENTBANKER_STRINGS = {

	AUTODEPOSIT = "Automatically deposit reagents when bank window opens";
	REAGENT_TAB_DEFAULT = "Open to reagent tab by default";

	ALT = "ALT";
	CTRL = "CTRL";
	SHIFT = "SHIFT";
	KEY = "%s key";

	DEPOSIT_MODIFIERKEY_LABEL_DONOT = "Do Not Deposit Key";
	DEPOSIT_MODIFIERKEY_LABEL_DO = "Immediate Deposit Key";
	DEPOSIT_MODIFIERKEY_TOOLTIP_KEY_DONOT = "Hold the \"%s\" key while opening the bank in order to NOT deposit reagents.|n|nUncheck the above option to reverse this behavior.";
	DEPOSIT_MODIFIERKEY_TOOLTIP_KEY_DO = "Hold the \"%s\" key while opening the bank in order to immediately deposit reagents.|n|nCheck the above option to reverse this behavior.";

	TAB_MODIFIERKEY_LABEL_DONOT = "Do Not Open to Reagent Tab Key";
	TAB_MODIFIERKEY_LABEL_DO = "Open to Reagent Tab Key";
	TAB_MODIFIERKEY_TOOLTIP_KEY_DONOT = "Hold the \"%s\" key while opening the bank in order to NOT open to the reagent tab.|n|nUncheck the above option to reverse this behavior.";
	TAB_MODIFIERKEY_TOOLTIP_KEY_DO = "Hold the \"%s\" key while opening the bank in order to open to the reagent tab.|n|nCheck the above option to reverse this behavior.";

	MODIFIERKEY_NONE = "None";
	MODIFIERKEY_NONE_TOOLTIP = "Do not apply a key.";

	DEPOSIT_IGNORED_LABEL = "Deposit Reagents From Bags Ignored by Cleanup (Sorting)";
	DEPOSIT_IGNORED_AUTO = "When there is an automatic deposit";
	DEPOSIT_IGNORED_AUTO_TIP = "Normally, bags flagged as Ignored for WoW's \"Clean Up Bags\" feature are also ignored by the \"Deposit All Reagents\" feature.|n|nCheck this to bypass that restriction when Reagent Banker automatically deposits reagents.";
	DEPOSIT_IGNORED_BUTTON = "When the \"Deposit All Reagents\" button is pressed";
	DEPOSIT_IGNORED_BUTTON_TIP = "Normally, bags flagged as Ignored for WoW's \"Clean Up Bags\" feature are also ignored by the \"Deposit All Reagents\" feature.|n|nCheck this to bypass that restriction when the deposit button on the reagent bank window is pressed.";

	CHATLOG_SHOW_DEPOSITED = "Output deposited items to the chat log";

	-- "Deposited: [Huge Emerald]x5, [Black Diamond], [Gold Bar]x7"
	CHATLOG_DEPOSITED = "Deposited: %s";
	CHATLOG_DEPOSITED_COUNT = "%sx%d";
	CHATLOG_DEPOSITED_SEP = ",";

}

local L, locale = REAGENTBANKER_STRINGS, GetLocale()

if (locale == "deDE") then  -- German
--@localization(locale="deDE", format="lua_additive_table", handle-subnamespaces="none")@

elseif (locale == "frFR") then  -- French
--@localization(locale="frFR", format="lua_additive_table", handle-subnamespaces="none")@

elseif (locale == "zhTW") then  -- Traditional Chinese
--@localization(locale="zhTW", format="lua_additive_table", handle-subnamespaces="none")@

elseif (locale == "zhCN") then  -- Simplified Chinese
--@localization(locale="zhCN", format="lua_additive_table", handle-subnamespaces="none")@

elseif (locale == "ruRU") then  -- Russian
--@localization(locale="ruRU", format="lua_additive_table", handle-subnamespaces="none")@

elseif (locale == "koKR") then  -- Korean
--@localization(locale="koKR", format="lua_additive_table", handle-subnamespaces="none")@

elseif (locale == "esES" or locale == "esMX") then  -- Spanish
--@localization(locale="esES", format="lua_additive_table", handle-subnamespaces="none")@

	if (locale == "esMX") then  -- Spanish (Mexican)
--@localization(locale="esMX", format="lua_additive_table", handle-subnamespaces="none")@
	end

elseif (locale == "ptBR") then  -- Brazilian Portuguese
--@localization(locale="ptBR", format="lua_additive_table", handle-subnamespaces="none")@

elseif (locale == "itIT") then  -- Italian
--@localization(locale="itIT", format="lua_additive_table", handle-subnamespaces="none")@

end
