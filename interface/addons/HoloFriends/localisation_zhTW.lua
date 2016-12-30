--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file defines the Chinese Traditional localisation data

]]

if( GetLocale() == "zhTW" ) then

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGDATEFORMAT = [=[提示資訊的日期格式：
(%%Y=年, %%m=月, %%d=日, %%H=時 {24制}, %%I=小時 {12制}, %%M=分, %%p=上午或下午, %%A=周幾)]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONASKMERGEFRIENDGROUPS = [=[對於|cffffd200%s|r的所有好友：
您願意以此來替換陣營好友名單中的群組分配？]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONASKMERGEIGNOREGROUPS = [=[對於|cffffd200%s|r的所有忽略：
您願意以此來替換陣營忽略名單中的群組分配？]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONMERGEFRIENDWARNING = [=[您即將合併
|cffffd200%s|r
中全部好友至陣營好友名單

|cffffd200警告|r
獨立的好友名單將被刪除！
此步驟不可還原！
取決於不同的選項，此步驟可能導致資料丟失！
好友名單資料將僅僅本地化地保存在你硬碟中

|cffffd200建議|r
備份您的HoloFriends好友名單(例如保存到USB隨身碟):
{WoW資料夾}/WTF/Account/{您的帳號}/SavedVariables/HoloFriends.lua

|cffffd200您已經做好備份了嗎？|r]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONMERGEIGNOREWARNING = [=[您即將合併
|cffffd200%s|r
中全部忽略至陣營忽略名單

|cffffd200警告|r
獨立的忽略名單將被刪除！
此步驟不可還原！
取決於不同的選項，此步驟可能導致資料丟失！
忽略名單資料將僅僅本地化地保存在你硬碟中

|cffffd200建議|r
備份您的HoloFriends忽略名單(例如保存到USB隨身碟):
{WoW資料夾}/WTF/Account/{您的帳號}/SavedVariables/HoloFriends.lua

|cffffd200您已經做好備份了嗎？|r]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONPRIORITYFRIENDWARNING = [=[|cffffd200警告|r
使用陣營好友名單將使其優先於內建好友名單

以其他插件對您已經使用陣營好友名單的角色做好友名單的修改，如添加或移除好友，都會被Holofriends還原
未加載HoloFriends時所添加或移除的好友亦將在下次HoloFriends啟用時還原]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONPRIORITYIGNOREWARNING = [=[|cffffd200警告|r
使用陣營忽略名單將使其優先於內建忽略名單

以其他插件對您已經使用陣營忽略名單的角色做忽略名單的修改，如添加或移除胡略，都會被Holofriends還原
未加載HoloFriends時所添加或移除的忽略亦將在下次HoloFriends啟用時還原]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFRIENDSLISTCHANGED = "錯誤：所選的角色並非RealID好友，好友名單在對話期間有了改變。";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGGETREALIDNAMEBTAG = [=[所有RealID好友資料都只存在記憶體中，要使用進階功能，Holofriends需要將RealID名稱保存起來作為該好友的獨特名稱。

請將顯示出的名稱，一字不漏的輸入在框中，並在最後面加一個半型空白（因國外伺服器是將名和姓分開的，中間自動加空格，而台灣伺服器只使用了名，所以最後面多了一個空白）
%s]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGINVITEALLOFGROUP = "您確定要邀請這 %s 個好友，來自於 %s 的上線玩家？";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGREALIDNAMEEXIST = "錯誤：輸入的RealID名稱已經存在於Holofriends名單中，未做任何更動。";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGREALIDNAMEWRONG = "錯誤：輸入的名稱並不相符合，可能是打錯了或忘了加空白，未做任何更動。";

-- ####################################################################

HOLOFRIENDS_FAQ000TITLE = "HoloFriends 問與答"; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ011QUESTION = "這個插件可以顯示好友上次登入的時間嗎？這個是非常有用的功能。";
HOLOFRIENDS_FAQ012ANSWER = "HoloFriends只能顯示在線上好友最後的在線時間。就我所知，只有同公會的成員才能得知其最後登入時間。";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ021QUESTION = "有人知道勾選那個小框會有什麼效果嗎？";
HOLOFRIENDS_FAQ022ANSWER = [=[加載Holofriends後，在好友名單的名字前會出現個小框(參見"顯示所有好友"截圖)。 此框勾選時，這個好友會被保存到遊戲內建好友名單中去。 勾消的話，則由Holofriends保存。
內建名單中的好友在線資訊由游戲更新，並且能觀察到目前狀態。但它有最大數量的限制(100個)。
Holofriends中的好友狀態將不被遊戲本身監測，需要使用"/who"指令來達成。 但這個更新會比較緩慢，因為系統限制了兩次/who查詢的間隔時間。]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ031QUESTION = "更新說明中的\"對於超過內建100個好友的項目，進行單鍵的資訊更新\"，這是講啥？";
HOLOFRIENDS_FAQ032ANSWER = [=[對僅在Holo名單中的好友使用的是緩慢的/who查詢，無法由插件自行查詢。 所以這類好友的狀態需要您手動點擊好友名單右上角的"/who查詢"按鈕來更新。
"注意"：因每兩次查詢之間有強制間隔，所以當"/who查詢"開始後，手動輸入的/who查詢將不起作用。]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ041QUESTION = "在某些右鍵的菜單中，\"設定專注目標\"不起作用。";
HOLOFRIENDS_FAQ042ANSWER = [=[我不得不關閉它, 否則您將會收到錯誤提示資訊"已被Blizzard UI有效動作封鎖"。
在新版Holofriends程式中增加了一個用於關閉修改右鍵選單的選項，從而使"設定焦點目標"起作用。
"設定焦點目標"似乎在WOW中被訂定為受保護的功能，我無法理解為何它不僅僅是於戰鬥中受到保護，如同"團隊視窗"。
若遊戲的保護機制起作用，使得焦點目標功能不起作用了，那就把修改右鍵選單的功能關閉。]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ051QUESTION = "當我在團隊中進入戰鬥的時候，為什麼打開團隊清單介面是空白的？";
HOLOFRIENDS_FAQ052ANSWER = [=[這同樣也是遊戲的一個保護機制，當有未經授權的插件試圖更改這個視窗的時候，系統就將其關閉。
團隊列表是好友列表的一部分，同時好友列表也是它的一部分。因為好友列表被插件改動過了，
但HoloFriends未經過Blizzard簽署，所以會導致在團隊中戰鬥時列表為空。]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ061QUESTION = "有沒有方法可以同步其他分身的好友和群組呢？";
HOLOFRIENDS_FAQ062ANSWER = [=[可以的。
您可以選擇讓所有或特定角色使用陣營好友名單，這些角色都會自動共用同樣的好友和同樣的群組，內建好友名單也會被同步。
您也可以手動選擇群組來共享至其他分身。

無論是陣營好友名單的使用或是手動共享群組都是在HoloFriends設定中的共享分頁裡頭來完成。共享分頁位於"遊戲選項→介面→插件→HoloFriends→共享好友名單"。

要啟用角色的陣營好友名單功能，從下拉選單中選擇該角色，接著點擊下半段的"增加"按鈕，記得不要點選列表中的任何項目。

要手動共享/更新群組給其他分身，先從下拉選單中選擇來源角色。接著在左半部的視窗中勾選要共享的群組，然後在右半部的視窗中選擇目標角色，最後點選位於兩個視窗右下方的更新/增加。增加只會添加目標角色所沒有的好友，而更新則是完整的把好友同步至目標角色。
HoloFriends設定中，有個選項可以標記那些目標角色有而來圓角色沒有的好友。好友會被移動至其他選擇的群組，但不會從群組中移除，您要自行手動移除。]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ071QUESTION = "感謝你的簡介，那要如何讓群組和裡面的好友自動同步，而不需要手動選擇群組來共享呢？";
HOLOFRIENDS_FAQ072ANSWER = [=[陣營好友名單就是您想要的功能，您可以透過上個回答第三段的敘述來開啟。

陣營好友名單就是一份統一的好友名單，不再有任何副本或分身用的名單。所以不需要共享來共享去的。所有對陣營好友名單的更動都對有使用的角色有效，而內建好友名單在登入時，會由插件負責使用陣營好友名單的資料同步至魔獸伺服器端的內建好友名單。
但是使用陣營好友名單有一個限制：HoloFriends需要對內建好友名單的優先存取權，因此其他好友名單相關的插件將無法和開啟HoloFriends陣營好友名單的角色同時使用。]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ081QUESTION = "我很好奇有沒有可能讓我在一個角色上移除好友的時候，也把這個移除的動作共享至其他角色。也就是說，如果我從X角色上刪除某好友，那開啟其他角色的時候某好友是否也被刪除？";
HOLOFRIENDS_FAQ082ANSWER = [=[如果您使用了陣營好友名單，那麼遊戲內建名單的資料會在登入時以陣營好友名單的資料去做同步。換句話說，只要兩個角色都有開啟陣營好友名單的功能，在移除好友的時候，登入另一角色時，插件就會自動幫您移除同個好友。

如果你使用的是一般的模式，每個角色都有獨立的好友名單，則要在共享好友名單分頁中共享至其他分身。而被刪除的好友會以刪除線的格式出現，由您手動刪除(為了支援其他好友名單插件的運作)]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ091QUESTION = "有沒有辦法可以自動共享整個名單或同時共享多個好友嗎？除非我看漏了什麼，我都只能一個一個點來共享。";
HOLOFRIENDS_FAQ092ANSWER = "您可以直接點擊群組名稱，就會勾選整個群組。勾選後群組會縮小，但仍然是勾選著的。";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ101QUESTION = "如果使用HoloFriends，我其他的好友列表插件就不能正常的使用。這是HoloFriends的相容性問題嗎？";
HOLOFRIENDS_FAQ102ANSWER = [=[是/否
如果每個角色都使用獨立好友名單的話，HoloFriends應該會和其他插件相容。

而陣營好友名單的功能則不與一些好友名單插件相容。 主要是其他插件的添加或移除動作會被忽略，因為陣營好友名單需要比內建好友名單更優先的權限。換句話說，如果在沒有載入HoloFriends的情況下修改內建好友名單，下一次載入HoloFriends時就會以插件所記錄的資料來覆蓋您做的變更。因此，對於在多台電腦遊玩或是無法每次都載入HoloFriends的玩家而言，並不適合使用陣營好友名單這個功能。]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ111QUESTION = "前一陣子我使用了HoloFriends的陣營好友名單功能，但有好些日子沒有開著它玩了。如果我現在加載Holofriends的話，他會還原我在這期間內對好友名單做的更動嗎？";
HOLOFRIENDS_FAQ112ANSWER = "如果超過30天未使用陣營好友名單的功能，HoloFriends會在載入時詢問您是否要讀取並覆蓋掉所有更動，或是直接使用內建好友名單。陣營好友名單仍然存在，您也可以前往設定中的共享分頁來存取。";

-- ####################################################################

HOLOFRIENDS_LISTFEATURES0TITLE = "功能";

HOLOFRIENDS_LISTFEATURES11 = "讓同個陣營的分身共享同一個好友或忽略名單";
HOLOFRIENDS_LISTFEATURES12 = "讓您透過群組的方式分類好友";
HOLOFRIENDS_LISTFEATURES13 = "管理超過100個好友和50個忽略";
HOLOFRIENDS_LISTFEATURES14 = "對超過好友名單上限(100)的好友，一鍵更新其資訊";
HOLOFRIENDS_LISTFEATURES15 = "對超過忽略名單上限(50)的忽略，進行悄悄話、組隊、入會、決鬥的忽略";
HOLOFRIENDS_LISTFEATURES16 = "內建好友或忽略名單中有人消失時，顯示提示訊息";

HOLOFRIENDS_LISTFEATURES21 = "為您好友和黑名單添加長註記(多達500半型/250全型文字)";
HOLOFRIENDS_LISTFEATURES22 = "Holo註記的前48個字母保存到內建好友註記中";
HOLOFRIENDS_LISTFEATURES23 = "監測游戲內建好友名單的註記(即支援其他插件)";
HOLOFRIENDS_LISTFEATURES24 = "可選互換游戲內建好友註記和Holo註記的位置";
HOLOFRIENDS_LISTFEATURES25 = "可在好友名稱後顯示地區、等級或註記"; -- Needs review
HOLOFRIENDS_LISTFEATURES26 = "移上好友時，顯示的提示視窗會提供額外資訊";

HOLOFRIENDS_LISTFEATURES31 = "可選擇僅顯示在線好友";
HOLOFRIENDS_LISTFEATURES32 = "可選擇僅顯示好友名單中有在線好友的群組";
HOLOFRIENDS_LISTFEATURES33 = "可讓線上好友保持在離線好友上方";
HOLOFRIENDS_LISTFEATURES34 = "可選擇為好友顯示職業圖示";
HOLOFRIENDS_LISTFEATURES35 = "可選用職業顏色來顯示好友名字";
HOLOFRIENDS_LISTFEATURES36 = "保存好友最後所見在線資訊";
HOLOFRIENDS_LISTFEATURES37 = "可保存並給予自己分身註記";
HOLOFRIENDS_LISTFEATURES38 = "顯示在線和離線的好友數量"; -- Needs review

HOLOFRIENDS_LISTFEATURES41 = "由右鍵選單添加玩家到好友或忽略名單(無需打開好友窗口)"; -- Needs review
HOLOFRIENDS_LISTFEATURES42 = "由右鍵選單執行/who查詢"; -- Needs review
HOLOFRIENDS_LISTFEATURES43 = "右鍵選單可設為黑色不透明背景";
HOLOFRIENDS_LISTFEATURES44 = "可選擇不要修該右鍵選單(來允許設定焦點)"; -- Needs review

HOLOFRIENDS_LISTFEATURES51 = "共享您的好友和忽略，包括角色上的註記";
HOLOFRIENDS_LISTFEATURES52 = "共享好友和忽略給其他分身";
HOLOFRIENDS_LISTFEATURES53 = "共享時可選則合併Holo註記的方式";
HOLOFRIENDS_LISTFEATURES54 = "共享並更新整個群組";
HOLOFRIENDS_LISTFEATURES55 = "更新群組時 在目標好友名單中可以標記不存在的好友";
HOLOFRIENDS_LISTFEATURES56 = "合併你某些或所有角色的好友名單為統一的陣營好友名單";
HOLOFRIENDS_LISTFEATURES57 = "允許從陣營好友名單中分離你的角色";

HOLOFRIENDS_LISTFEATURES61 = "HoloFriends介面選項中的FAQ";
HOLOFRIENDS_LISTFEATURES62 = "可以在登入時，於對話框顯示在線好友清單";

-- ####################################################################

HOLOFRIENDS_HOMEPAGEACTUAL = [=[這是Holofriends的一次大升級, 加入一些新功能, 改善的窗口操作, 以及很早就宣布的: 可選的陣營好友名單!
這是為你在同一個服務器上某些或所有角色準備的統一的好友名單.再也不用復制來復制去.

因為譯者原因, 此版本進對zhCN, zhTW, esMX做了部分本地化.

我必須為sailorami14和Opaque提供的兩個程序錯誤發布一個補丁.
也包括一個方案, 解決與插件BadBoy_Levels有關的問題(由JLBurnett04提供并和funkydude討論).
同時, Aladdinn為我們對Holofriends做了完整的翻譯(znTW). 非常感謝.]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGEADDRESS = [=[外掛程式原始發佈網站:
http://wow.curseforge.com/projects/holo-friends-continued/
你可以在這裡找到更新及BUG回報:
http://wow.curseforge.com/projects/holo-friends-continued/tickets/]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGEAIM = "本外掛程式幫助你更好的管理你的好友/忽視名單."; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGELOCALIZATION = [=[本地語系化
Andymon - 德語 (deDE)
zwlong9069 - 簡體中文 (zhCN)
Aladdinn, zwlong9069 - 繁體中文 (zhTW)
marturo77 - Latin American Spanish (esMX)]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGEREMARKSTITLE = "備注";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGESEARCH = [=[你想本地化HoloFriend嗎？
作者正尋求更多的翻譯者參與
登陸http://wow.curseforge.com/註冊併發站內短信至Andymon即可加入翻譯組，完全頁面化方便你輕鬆的翻譯.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGETITLE = "HoloFriends (continued) v0.462";

-- ####################################################################

HOLOFRIENDS_INITADDONLOADED = "HoloFriends v%.3f 已載入! 繁體中文化:溺死的魚, 煙霞繞山, 狼宇";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_INITINVALIDLISTVERSION = "你的Holofriends資料為較新版本的Holofriends所寫入，為了防止數據錯誤，沒有任何操作會被儲存或是載入！";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_INITLOADFACTIONSFRIENDSLIST = [=[|cffffd200警告:|r 此角色的陣營好友名單已長時間未載入
可能您在未加載Holofriends的情況下進行游戲, 而現在此角色想載入游戲內建好友名單
若繼續載入Holofriends的話，將會撤銷所有對內建好友名單的改變
確定要繼續載入陣營好友名單嗎？]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_INITLOADFACTIONSIGNORELIST = [=[|cffffd200警告:|r 此角色的陣營忽略名單已長時間未載入
可能您在未加載Holofriends的情況下進行游戲, 而現在此角色想載入游戲內建忽略名單
若繼續載入Holofriends的話，將會撤銷所有對內建忽略名單的改變
確定要繼續載入陣營忽略名單嗎？]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_INITSHOWONLINEATLOGIN = "在線好友列表：";

-- ####################################################################

HOLOFRIENDS_WINDOWMAINADDCOMMENT = "修改Holo註記";
HOLOFRIENDS_WINDOWMAINADDGROUP = "新增群組";
HOLOFRIENDS_WINDOWMAINBUTTONSCAN = "查詢(/who)";
HOLOFRIENDS_WINDOWMAINBUTTONSTOP = "停止查詢";
HOLOFRIENDS_WINDOWMAINIGNOREONLINE = "在線忽略人數：";
HOLOFRIENDS_WINDOWMAINNUMBERONLINE = "在線好友人數：";
HOLOFRIENDS_WINDOWMAINREMOVEGROUP = "刪除群組";
HOLOFRIENDS_WINDOWMAINRENAMEGROUP = "重新命名群組";
HOLOFRIENDS_WINDOWMAINSHOWOFFLINE = "顯示離線好友";
HOLOFRIENDS_WINDOWMAINWHOREQUEST = "顯示玩家資訊";

-- ####################################################################

HOLOFRIENDS_MSGDELETECHARDIALOG = "您確定要刪除|cffffd200%s|r所有的資料嗎？";
HOLOFRIENDS_MSGDELETECHARDONE = "已刪除%s的資料";
HOLOFRIENDS_MSGDELETECHARNOTFOUND = "未找到 %s ，請確認玩家名稱";

HOLOFRIENDS_MSGFACTIONMERGEDONE = "已合併 %s 到陣營好友名單";
HOLOFRIENDS_MSGFACTIONNOMERGE = "終止: 未合併到陣營好友名單";

HOLOFRIENDS_MSGFRIENDLIMITALERT = "您只能同時對%d個好友線上監控！";
HOLOFRIENDS_MSGFRIENDMISSINGONLINE = "你的好友 %s 從內建好友名單中消失.";
HOLOFRIENDS_MSGFRIENDONLINEDISABLED = "關閉對 %s 的線上監控.";
HOLOFRIENDS_MSGFRIENDONLINEENABLED = "開啟對 %s 的線上監控";

HOLOFRIENDS_MSGIGNOREDUEL = "已拒絕決鬥， %s 在您的Holo忽略名單中";
HOLOFRIENDS_MSGIGNOREINVITEGUILD = "已拒絕公會邀請， %s 在您的Holo忽略名單中";
HOLOFRIENDS_MSGIGNORELIMITALERT = "僅能監控%d個忽略人物！";
HOLOFRIENDS_MSGIGNOREMISSINGONLINE = "您忽略的 %s 已從內建忽略名單中消失";
HOLOFRIENDS_MSGIGNOREONLINEDISABLED = "關閉了對已忽略的 %s 之線上監控";
HOLOFRIENDS_MSGIGNOREONLINEENABLED = "開啟了對已忽略的 %s 之線上監控";
HOLOFRIENDS_MSGIGNOREPARTY = "已拒絕組隊邀請， %s 在您的Holo忽略名單中";
HOLOFRIENDS_MSGIGNORESIGNGUILD = "已拒絕創會簽名， %s 在您的Holo忽略名單中";

HOLOFRIENDS_MSGSCANDONE = "查詢其他好友完成";
HOLOFRIENDS_MSGSCANSTART = "即將查詢%d個好友，約於%f秒後完成。查詢期間 /who 的指令將不可用。";
HOLOFRIENDS_MSGSCANSTOP = "停止查詢";

-- ####################################################################

HOLOFRIENDS_OPTIONS0LISTENTRY = "HoloFriends";
HOLOFRIENDS_OPTIONS0NEEDACCEPT = "您必須先勾選項目，複製好友名單的動作才會起作用！";
HOLOFRIENDS_OPTIONS0NEEDRELOAD = "需要重新載入才能生效！";
HOLOFRIENDS_OPTIONS0NOTFACTION = "此選項無法對使用陣營好友名單的角色生效。";
HOLOFRIENDS_OPTIONS0REALID = "BNet好友固定是以內建註記為主";
HOLOFRIENDS_OPTIONS0RELATEABOVE = "此選項只在不合併註記時才會生效";
HOLOFRIENDS_OPTIONS0RELATEBEFORE = "此選項只在合併註記時才會生效";
HOLOFRIENDS_OPTIONS0WINDOWTITLE = "HoloFriends設定";

HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRST = "替換角色名稱和RID名稱之位置";
HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRSTTT = "勾選的話，RID的真實名稱會顯示於角色名稱的後方";
HOLOFRIENDS_OPTIONS1BNSHOWCHARNAME = "於RealID後方顯示角色ID";
HOLOFRIENDS_OPTIONS1BNSHOWCHARNAMETT = "勾選的話，以陣營顏色顯示的真實名稱後方將會額外顯示他開啟的角色名稱";
HOLOFRIENDS_OPTIONS1GROUPSSHOWONLINE = "於群組名稱後方顯示線上人數";
HOLOFRIENDS_OPTIONS1GROUPSSHOWONLINETT = "勾選的話，在自訂群組名稱後方的括號內會顯示群組中有上線之人數";
HOLOFRIENDS_OPTIONS1SECTIONFLW = "好友名單視窗";
HOLOFRIENDS_OPTIONS1SETDATEFORMAT = "改變預設的日期和時間格式";
HOLOFRIENDS_OPTIONS1SETDATEFORMATTT = "勾選的話，會出現一個視窗讓您修改好友名單中，其最後上線的時間之格式";
HOLOFRIENDS_OPTIONS1SHOWCLASSCOLOR = "按職業著色";
HOLOFRIENDS_OPTIONS1SHOWCLASSCOLORTT = "勾選的話，會將好友名單中的角色名稱以職業顏色顯示";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONS = "顯示職業圖示";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONSTT = "勾選的話，好友名單中的名稱前方會出現職業圖示";
HOLOFRIENDS_OPTIONS1SHOWGROUPS = "簡潔好友名單模式下，仍然顯示空群組";
HOLOFRIENDS_OPTIONS1SHOWGROUPSTT = "勾選的話，群組名稱都會顯示，否則在簡潔模式下(好友名單視窗中|cffffd200顯示離線好友|r 未勾選)僅顯示其中有好友在線的群組";
HOLOFRIENDS_OPTIONS1SHOWLEVEL = "在名單中顯示角色等級";
HOLOFRIENDS_OPTIONS1SHOWLEVELTT = "勾選的話，好友名單中的好友名稱後方會顯示角色的等級";
HOLOFRIENDS_OPTIONS1SORTONLINE = "線上好友置頂";
HOLOFRIENDS_OPTIONS1SORTONLINETT = "勾選的話，會於群組中將線上好友顯示在離線好友之上方";

HOLOFRIENDS_OPTIONS2MERGENOTES = "合併Holo註記和內建註記";
HOLOFRIENDS_OPTIONS2MERGENOTESTT = "勾選的話，將由下面的選項決定如何將遊戲內建的好友註記和Holo註記合併";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFF = "內建註記為主";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFFTT = "勾選的話，修改內建註記會覆蓋Holo註記。勾消時Holo註記會覆蓋內建註記。HoloFriends可以同時編輯這兩者。";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYON = "內建註記顯示在前，Holo註記顯示在後";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYONTT = "勾選的話，顯示方式為內建註記+Holo註記。勾消時顯示為Holo註記+內建註記。(內建註記有48個字的上限)";
HOLOFRIENDS_OPTIONS2SECTIONNOTES = "內建註記的處理方式";

HOLOFRIENDS_OPTIONS3MARKREMOVE = "在目標角色的名單中標記原先不存在的人物";
HOLOFRIENDS_OPTIONS3MARKREMOVETT = "勾選的話，在共享群組給其他角色時，會在該角色的名單中標示該角色原先沒有的人物，方便您做處理(刪除、移動、等等...)";
HOLOFRIENDS_OPTIONS3MERGECOMMENTS = "共享名單時，一併複製Holo註記";
HOLOFRIENDS_OPTIONS3MERGECOMMENTSTT = "勾選的話，向其他角色複製名單時，Holo註記將添加到現有Holo註記後";
HOLOFRIENDS_OPTIONS3SECTIONSHARE = "共享視窗";

HOLOFRIENDS_OPTIONS4MENUMODF = "修改各類角色框架的右鍵選單(悄悄話、查詢、等等...)";
HOLOFRIENDS_OPTIONS4MENUMODP = "修改小隊框架的右鍵選單";
HOLOFRIENDS_OPTIONS4MENUMODR = "修改團隊框架的右鍵選單";
HOLOFRIENDS_OPTIONS4MENUMODT = "修改目標框架的右鍵選單";
HOLOFRIENDS_OPTIONS4MENUMODTT = "勾選的話，將會在該框架的右鍵選單中增加添加好友、忽略、/WHO查詢。";
HOLOFRIENDS_OPTIONS4MENUNOTAINT = "以避免編程污染的方式來修改右鍵選單";
HOLOFRIENDS_OPTIONS4MENUNOTAINTTT = "勾選的話，會將動作直接添加至右鍵選單。這可以保存原本的選單並避免編程污染。勾消的話，則以預設方式修改右鍵選單。|cffffd200但會導致右鍵選單中設置為焦點或坦克的動作失效|r";
HOLOFRIENDS_OPTIONS4SECTIONMENU = "修改右鍵選單";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBG = "為所有的右鍵選單添加不透明背景";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBGTT = "勾選的話，會給所有的右鍵選單添加黑色的不透明背景";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBG = "只為HoloFriends的右鍵選單添加不透明背景";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBGTT = "勾選的話，會只給HoloFriends中的右鍵選單添加黑色的不透明背景";

HOLOFRIENDS_OPTIONS5SECTIONSTART = "登入時之功能";
HOLOFRIENDS_OPTIONS5SHOWONLINEATLOGIN = "登入時顯示線上好友";
HOLOFRIENDS_OPTIONS5SHOWONLINEATLOGINTT = "勾選的話，進入遊戲時會在對話框列出目前在線之所有好友";

HOLOFRIENDS_OPTIONS6MSGIGNOREDWHISPER = "Holo忽略名單中的人密語時，回應一則訊息";
HOLOFRIENDS_OPTIONS6MSGIGNOREDWHISPERTT = "勾選的話，將自動對處於Holo忽略名單中而又對您悄悄話的玩家發送一則訊息，表明對方已被您忽略。勾消時則會安靜地忽略那些密語。";
HOLOFRIENDS_OPTIONS6SECTIONIGNORE = "對於忽略之玩家";

HOLOFRIENDS_OPTIONS7ADDFRIENTTT = "添加目標至好友名單中，若無目標則提供輸入框";
HOLOFRIENDS_OPTIONS7INVITETT = "邀請選取之好友至隊伍中";
HOLOFRIENDS_OPTIONS7REMOVEFRIENDTT = "將選取之玩家從好友名單中移除";
HOLOFRIENDS_OPTIONS7SECTIONFLBUTTONS = "顯示於好友名單之按鈕";
HOLOFRIENDS_OPTIONS7WHISPERTT = "對選取之好友發送密語";
HOLOFRIENDS_OPTIONS7WHOTT = "在對話框顯示選取之好友的額外資訊";

HOLOFRIENDS_OPTIONS87ADDCOMMENTTT = "對選取之好友添加註記";
HOLOFRIENDS_OPTIONS87ADDGROUPTT = "新增群組至名單中";
HOLOFRIENDS_OPTIONS87REMOVEGROUPTT = "移除選取之群組";
HOLOFRIENDS_OPTIONS87RENAMEGROUPTT = "更改選取群組之名稱";

HOLOFRIENDS_OPTIONS8ADDIGNORETT = "添加目標至忽略名單中，若無目標則提供輸入框";
HOLOFRIENDS_OPTIONS8REMOVEIGNORETT = "將選取之玩家從忽略名單中移除";
HOLOFRIENDS_OPTIONS8SECTIONILBUTTONS = "顯示於忽略名單之按鈕";

-- ####################################################################

HOLOFRIENDS_SHAREFRIENDSWINDOWTITLE = "共享好友名單";
HOLOFRIENDS_SHAREIGNOREWINDOWTITLE = "共享忽略名單";
HOLOFRIENDS_SHAREWINDOWBUTTONSEPARATE = "分離";
HOLOFRIENDS_SHAREWINDOWDELETENOTE = "|r|CFF990000注意:|r請使用 |cffffd200/holofriends delete {角色名稱} [at {伺服器}]|r 這個指令來清除不再存在之人物";
HOLOFRIENDS_SHAREWINDOWFACTIONNOTEADD = "選擇某個角色來加入陣營好友名單";
HOLOFRIENDS_SHAREWINDOWFACTIONNOTEPULLDOWN = "在下拉式選單：";
HOLOFRIENDS_SHAREWINDOWFACTIONNOTESEPARATE = "或是選擇你的陣營後，選擇自己角色名單中某|cff999999(角色)|r，就能從陣營好友名單中分離出來";
HOLOFRIENDS_SHAREWINDOWFACTIONTITLE = "陣營好友名單";
HOLOFRIENDS_SHAREWINDOWNOTE = "名單共享將會在點擊“更新”或“增加”後完成";
HOLOFRIENDS_SHAREWINDOWSOURCE = "選擇好友:";
HOLOFRIENDS_SHAREWINDOWTARGET = "選擇要共享至哪個角色：";

-- ####################################################################

HOLOFRIENDS_TOOLTIPBROADCAST = "BNet公告訊息：";
HOLOFRIENDS_TOOLTIPDATEFORMAT = "%Y/%m/%d %A %H:%M";
HOLOFRIENDS_TOOLTIPDISABLEDMENUENTRYHINT = "為使此選單功能生效，您必須在HoloFriends選項中關閉HoloFriends修改右鍵選單之功能";
HOLOFRIENDS_TOOLTIPDISABLEDMENUENTRYTITLE = "HoloFriends插件";
HOLOFRIENDS_TOOLTIPLASTSEEN = "|r|CFF99FFCC最後在線時間|r";
HOLOFRIENDS_TOOLTIPNEVERSEEN = "|r|CFF99FFCC最後在線時間：|r |r|cFF00FF00未知|r";
HOLOFRIENDS_TOOLTIPSHAREBUTTON = "將此名單共享給其他角色";
HOLOFRIENDS_TOOLTIPTURNINFOTEXT = "切換顯示地區或註記";
HOLOFRIENDS_TOOLTIPTURNINFOTITLE = "切換資訊";
HOLOFRIENDS_TOOLTIPUNKNOWN = "？";

end
