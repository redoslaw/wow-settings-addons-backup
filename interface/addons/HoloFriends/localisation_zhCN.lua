--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file defines the Chinese localisation data

]]

if( GetLocale() == "zhCN" ) then

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGDATEFORMAT = [=[提示中日期的格式：
(%%Y=年, %%m=月, %%d=日/月, %%H=时 {24小时制}, %%I=时 {12小时制}, %%M=分, %%p=am/pm, %%A=星期几)]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONASKMERGEFRIENDGROUPS = [=[对于好友列表|cffffd200%s|r中的全部好友：
你准备以此覆盖同阵营好友列表中的组分配？
对话]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONASKMERGEIGNOREGROUPS = [=[黑名单 |cffffd200%s|r中的全部成员：
你准备以此覆盖同阵营黑名单中的组分配？]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONMERGEFRIENDWARNING = [=[你可以合并全部好友
|cffffd200%s|r
到同阵营好友列表。

|cffffd200警告|r
单独的好友列表将被删除！
执行后将不可回档！
取决于选项，可能遗失数据！
好友列表的数据仅在你硬盘上做本地存档。
|cffffd200建议|r
给你的HoloFriends好友列表文件做个备份吧(比如备份到U盘)：
{WoW dir}/WTF/Account/{Your ACC}/SavedVariables/HoloFriends.lua

|cffffd200有备份吗?|r
对话]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONPRIORITYFRIENDWARNING = [=[|cffffd200警告|r
同阵营好友列表会优先于游戏内建好友列表。
其他插件对你角色的好友列表(已使用同阵营好友列表)进行添加或移除，将被HoloFriends撤消。
]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFRIENDSLISTCHANGED = "错误：选择的好友列表非实名制好友。对话过程中好友列表将变更。"; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGGETREALIDNAMEBTAG = [=[全部实名制好友的数据将在后台调整。为使用扩展功能，HoloFriends需要以明文输入实名制好友的名称并以之作为该好友的唯一标志。

请输入准确的名称：
%s]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGINVITEALLOFGROUP = "你真打算邀请组%s中全部%s在线好友？"; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGREALIDNAMEEXIST = "错误：输入的实名制名称已经在HoloFriends列表中存在。没有变化。"; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGREALIDNAMEWRONG = "错误：无效输入。可能你打错字母。没有变化。"; -- Needs review

-- ####################################################################

HOLOFRIENDS_FAQ011QUESTION = "这个插件可以显示好友上次登陆的时间吗?这个是非常有用的功能.";
HOLOFRIENDS_FAQ012ANSWER = "HoloFriends 显示的是你上次看到好友在线的时间,和工会列表中的最后登陆时间是不同的.";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ021QUESTION = "有人知道勾上那个小选项会有什么效果吗?";
HOLOFRIENDS_FAQ022ANSWER = [=[当你装上插件以后,在好友列表的名字前会有个小选项 (参见"显示所有好友"截图). 当这个选项被勾上的时候,这个好友就会被保存为游戏自带好友列表. 反之,则是插件保存的.
游戏自带的好友列表会随着你每次上线而更新,但是它有最大数量的限制(100个).
那么没有被勾上的好友 (仅仅被插件列表保存) 将不会被游戏本身所识别. HoloFriends插件将会在上线的时候使用/who命令来更新好友状态. 但是这个更新会比较缓慢,因为系统限制了两次/who查询的间隔时间.]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ031QUESTION = "更新说明中的\"更新不在系统列表中的好友,需要手动点击\"不是很明白."; -- Needs review
HOLOFRIENDS_FAQ032ANSWER = [=[因为那些好友列表中没有被勾上的名单使用的是/who查询,这个查询是比较慢的, 所以这个列表上状态的更新需要手动的通过点击"/who查询"来更新. 这个按钮位于好友列表的右上角.
注意: 因为每两次查询之间是有间隔的,所以当/who查询开始后,手动输入的/who查询将不起作用.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ041QUESTION = "在 某些右键的菜单中,\"设置焦点\"不起作用."; -- Needs review
HOLOFRIENDS_FAQ042ANSWER = [=[我不得不屏蔽了他,否则你将会收到很多错误提示信息 "该功能被暴雪屏蔽".
因此,在新版的插件中增加了一个选项用于关闭增强右键菜单,从而使"设置焦点"起作用.
至于为什么会有这个冲突存在我也不清楚.
可能是游戏的保护机制在起作用吧,如果你发现设置焦点不起作用了,那就把增强右键菜单关闭.]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ051QUESTION = "当我在RAID战斗中的时候,为什么打开团队列表界面是空白的?."; -- Needs review
HOLOFRIENDS_FAQ052ANSWER = [=[这同样也是游戏的一个保护机制,当有未经授权的插件试图更改这个窗口的时候,系统就将其关闭.
团队列表是好友列表的一部分, 同时好友列表也是它的一部分. 因为好友列表被插件改动过了. 但是未经过暴雪授权,所以会导致RAID战斗中列表为空.]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ061QUESTION = "有办法在各角色间保持组及其成员同步吗？"; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ071QUESTION = "多谢介绍。这会保持组及其成员同步吗？还是每次在组中添加成员或/和建立新组别我都必须按此步骤再来一遍？更乐意看到有选项能保持数据同步而不是描述中的“更新”步骤。"; -- Needs review
HOLOFRIENDS_FAQ072ANSWER = [=[HoloFriends同阵营好友列表的特点正是你希望的。细节请看如上描述。
。
同阵营好友列表是单独好友列表，在某服务器上一个阵营中若干角色间共有而不必分享。好友列表的每次变更会遍及对全部角色，其他角色的WOW服务器端在线好友列表将在登录后同步。
但制约同阵营好友列表的是：HoloFriends拥有更高的优先权而非WOW内建。这意味着，扮演使用了同阵营好友列表的角色时，其他同类插件将不会和HoloFriends同时生效。]=]; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ091QUESTION = "有办法自动同步好友列表，或在手动同步时选择全部名称吗？是错过什么以至我在同步时，只能一个个的点击每个名称。"; -- Needs review
HOLOFRIENDS_FAQ092ANSWER = "可以通过勾选分组来分享整个组别。勾选后，该分组折叠，而保持勾选框被勾选。"; -- Needs review
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ101QUESTION = "使用HoloFriends时，同期其他好友列表插件未如预期般运行。是HoloFriends的兼容性问题吗？"; -- Needs review

-- ####################################################################

HOLOFRIENDS_LISTFEATURES0TITLE = "特点";

-- ####################################################################

HOLOFRIENDS_HOMEPAGEADDRESS = [=[插件原始发布站点:
http://wow.curseforge.com/projects/holo-friends-continued/
你可以在这里找到更新及BUG回报:
http://wow.curseforge.com/projects/holo-friends-continued/tickets/]=];
HOLOFRIENDS_HOMEPAGEAIM = "本插件帮助你更好的管理你的好友/屏蔽名单."; -- Needs review
HOLOFRIENDS_HOMEPAGELOCALIZATION = [=[本地化
Andymon - 德语 (deDE)
zwlong9069 - 简体中文 (zhCN)
zwlong9069 - 繁体中文 (zhTW)]=]; -- Needs review
HOLOFRIENDS_HOMEPAGEREMARKSTITLE = "链接";
HOLOFRIENDS_HOMEPAGESEARCH = [=[你想让HoloFriend以你自己的语种显示吗？
作者正寻求更多的翻译者参与
登陆http://wow.curseforge.com/注册并发站内短信至Andymon即可加入翻译组，完全页面化方便你轻松的翻译.]=]; -- Needs review
HOLOFRIENDS_HOMEPAGETITLE = "HoloFriends (continued) v0.435"; -- Needs review

-- ####################################################################

HOLOFRIENDS_INITADDONLOADED = "Holo的好友插件 v%.3f 已载入! 简体中文汉化:溺死的鱼"; -- Needs review
HOLOFRIENDS_INITINVALIDLISTVERSION = "您的HoloFriends插件数据会被新版本的HoloFriends(%s)覆盖 - 为了防止您的数据被破坏，不会进行任何储存或者载入操作!";

-- ####################################################################

HOLOFRIENDS_WINDOWMAINADDCOMMENT = "添加注释";
HOLOFRIENDS_WINDOWMAINADDGROUP = "新增好友分组";
HOLOFRIENDS_WINDOWMAINBUTTONSCAN = "查询玩家";
HOLOFRIENDS_WINDOWMAINBUTTONSTOP = "停止查询";
HOLOFRIENDS_WINDOWMAINNUMBERONLINE = "好友在线人数:";
HOLOFRIENDS_WINDOWMAINREMOVEGROUP = "删除好友分组";
HOLOFRIENDS_WINDOWMAINRENAMEGROUP = "重命名好友分组";
HOLOFRIENDS_WINDOWMAINSHOWOFFLINE = "显示离线好友";
HOLOFRIENDS_WINDOWMAINWHOREQUEST = "显示玩家信息";

-- ####################################################################

HOLOFRIENDS_MSGDELETECHARDIALOG = "您确定要删除所有的|cffffd200%s|r的资料吗?";
HOLOFRIENDS_MSGDELETECHARDONE = "%s的资料已被删除";
HOLOFRIENDS_MSGDELETECHARNOTFOUND = "%s 未找到，请确认玩家名称是否正确";

HOLOFRIENDS_MSGFRIENDLIMITALERT = "您最多只能同时关注%d个好友!!";
HOLOFRIENDS_MSGFRIENDONLINEDISABLED = "关闭对 %s 的关注"; -- Needs review
HOLOFRIENDS_MSGFRIENDONLINEENABLED = "开启对 %s 的关注"; -- Needs review

HOLOFRIENDS_MSGSCANDONE = "扫描其他好友完成";
HOLOFRIENDS_MSGSCANSTART = "查询%d个好友，这大约会在%f秒后完成。在查询的期间内 /who 的指令将不会有任何的作用。";
HOLOFRIENDS_MSGSCANSTOP = "停止扫描";

-- ####################################################################

HOLOFRIENDS_OPTIONS0LISTENTRY = "Holo插件设置"; -- Needs review
HOLOFRIENDS_OPTIONS0NEEDACCEPT = "此选项被选中后，角色复制窗口才会起作用!"; -- Needs review
HOLOFRIENDS_OPTIONS0NEEDRELOAD = "需重新载入才能生效!"; -- Needs review
HOLOFRIENDS_OPTIONS0NOTFACTION = "对使用同阵营好友列表的角色，此选项不可用！"; -- Needs review
HOLOFRIENDS_OPTIONS0REALID = "此选项对实名制好友保持打开！"; -- Needs review
HOLOFRIENDS_OPTIONS0RELATEABOVE = "以上各选项未设定或激活时，仅使用本选项！"; -- Needs review
HOLOFRIENDS_OPTIONS0RELATEBEFORE = "之前各选项被设定或激活时，仅使用本选项！"; -- Needs review
HOLOFRIENDS_OPTIONS0WINDOWTITLE = "Holo插件设置"; -- Needs review

HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRST = "改变角色名称或者实名的排序"; -- Needs review
HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRSTTT = "如勾选，实名好友的真实名称会在角色名称后显示。"; -- Needs review
HOLOFRIENDS_OPTIONS1BNSHOWCHARNAME = "在战网实名后显示角色名称"; -- Needs review
HOLOFRIENDS_OPTIONS1BNSHOWCHARNAMETT = "如勾选，角色名称将在以阵营颜色显示的实名制好友后显示。"; -- Needs review
HOLOFRIENDS_OPTIONS1GROUPSSHOWONLINE = "在分组名称后显示在线好友人数"; -- Needs review
HOLOFRIENDS_OPTIONS1GROUPSSHOWONLINETT = "如勾选，在线好友的实时人数将在分组名称后的括弧中显示。"; -- Needs review
HOLOFRIENDS_OPTIONS1SECTIONFLW = "好友列表窗口"; -- Needs review
HOLOFRIENDS_OPTIONS1SHOWCLASSCOLOR = "按职业染色"; -- Needs review
HOLOFRIENDS_OPTIONS1SHOWCLASSCOLORTT = "选中后,将按职业为好友列表中的好友名字染色";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONS = "显示职业图标";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONSTT = "选中后,在好友名单前将显示职业图标";

HOLOFRIENDS_OPTIONS2MERGENOTES = "合并好友注释";
HOLOFRIENDS_OPTIONS2MERGENOTESTT = "选中后,将会把游戏自带的好友注释合并到Holo插件注释中";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFF = "游戏内注释优先显示";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFFTT = "选中后,更改游戏内注释会覆盖Holo插件注释,除非Holo注释更改时撤销了游戏内注释的改动.Holo插件可同时编辑这两者";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYON = "游戏内注释显示在前,Holo注释在后";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYONTT = "选中后,默认显示为游戏内注释在前,Holo注释在后.否则则是反过来显示(游戏内注释最高为48个字符)";

HOLOFRIENDS_OPTIONS3MERGECOMMENTS = "复制好友列表的时候，同时复制注释";
HOLOFRIENDS_OPTIONS3MERGECOMMENTSTT = "选中后，复制好友列表时将一起复制注释";

HOLOFRIENDS_OPTIONS4MENUMODP = "修改小队框架的下拉菜单"; -- Needs review
HOLOFRIENDS_OPTIONS4MENUMODR = "修改团队框架的下拉菜单"; -- Needs review
HOLOFRIENDS_OPTIONS4MENUMODT = "修改目标框架的下拉菜单"; -- Needs review
HOLOFRIENDS_OPTIONS4MENUMODTT = "选中后,将会在角色,小队和团队下拉菜单中增加\"添加好友,添加屏蔽,WHO查询. |cffffd200同时会导致无法右键点击设置焦点目标.|r";
HOLOFRIENDS_OPTIONS4MENUNOTAINT = "不破坏菜单结构来添加条目"; -- Needs review
HOLOFRIENDS_OPTIONS4SECTIONMENU = "下拉菜单修改"; -- Needs review
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBG = "为所有的下拉菜单增加背景";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBGTT = "选中后,会给所有的下拉菜单增加黑色的背景";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBG = "为Holo插件下拉菜单增加背景";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBGTT = "选中后,会只给Holo插件增加黑色的背景";

HOLOFRIENDS_OPTIONS5SECTIONSTART = "启动项修改"; -- Needs review
HOLOFRIENDS_OPTIONS5SHOWONLINEATLOGIN = "登录时显示在线好友"; -- Needs review
HOLOFRIENDS_OPTIONS5SHOWONLINEATLOGINTT = "如勾选，登录时，会在聊天框显示全部活跃的在线好友人数"; -- Needs review

HOLOFRIENDS_OPTIONS6MSGIGNOREDWHISPER = "向离线的黑名单的私聊发送便签。"; -- Needs review

-- ####################################################################

HOLOFRIENDS_SHAREFRIENDSWINDOWTITLE = "好友列表复制";
HOLOFRIENDS_SHAREWINDOWDELETENOTE = "|r|CFF990000注意:|r用 |cffffd200/holofriends delete {name} [at {realm}]|r 来清除不存在\\n的人物";
HOLOFRIENDS_SHAREWINDOWNOTE = "角色更新将会在点击“添加”和“更新”后完成";
HOLOFRIENDS_SHAREWINDOWSOURCE = "选择好友";
HOLOFRIENDS_SHAREWINDOWTARGET = "选择要复制到的角色";

-- ####################################################################

HOLOFRIENDS_TOOLTIPDATEFORMAT = "%Y年%m月%d日%A %H:%M分";
HOLOFRIENDS_TOOLTIPLASTSEEN = "|r|CFF99FFCC最后在线时间|r";
HOLOFRIENDS_TOOLTIPNEVERSEEN = "|r|CFF99FFCC最后在线时间:|r |r|cFF00FF00未知|r";
HOLOFRIENDS_TOOLTIPSHAREBUTTON = "为您的其他角色共享目前的好友列表"; -- Needs review
HOLOFRIENDS_TOOLTIPUNKNOWN = "未知";

end
