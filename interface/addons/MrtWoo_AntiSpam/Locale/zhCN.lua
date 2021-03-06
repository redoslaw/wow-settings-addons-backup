local L = LibStub("AceLocale-3.0"):NewLocale("MrtWoo_AntiSpam", "zhCN", false)

if not L then return end

L["Add"] = "添加" -- Needs review
L["Add to blacklist on 24h"] = "添加到黑名单24小时"
L["After receiving the message is scanned for spam and it is assigned a rating, usually a normal message is not spam has a rating of 0-75 ... If the message rating exceeds a given threshold of the lock, then the message will be seen as spam and all messages from this user will be freezing."] = "在收到聊天信息后，插件会为信息评分，通常来说正常的非垃圾信息分数为0~75之间。如果信息评分超过封锁临界，此信息将被视为垃圾信息，并且此发布者的所有信息将被冻结。"
L["After receiving the messages are scanned for spam and given a rating, usually a normal message is not spam has a rating of 0-75 ... If the message rating exceeds a predetermined threshold, then the message will be treated as suspicious and will be hidden."] = "在收到聊天信息后，插件会为信息评分，通常来说正常的非垃圾信息分数在0~75之间。如果信息评分超过预设临界，信息将被疑为垃圾信息进行隐藏"
L["Allow update local copy database?"] = "允许更新本地数据库？"
L["Allow update without confirmation?"] = "更新不需确认" -- Needs review
L["Anti-Flud"] = "重复发言过滤" -- Needs review
L["AntiSpam"] = "垃圾信息过滤" -- Needs review
L["Auto replay"] = "自动回复" -- Needs review
L["Block for..."] = "屏蔽原因"
L["Block Interval:"] = "屏蔽时长：" -- Needs review
L["BlockList Editor"] = "过滤列表编辑器" -- Needs review
L["Channels"] = "频道" -- Needs review
L["Check the channels?"] = "检查各种频道？"
L["Check the emote?"] = "检查表情？" -- Needs review
L["Check the say?"] = "检查普通说话？"
L["Check the whisper?"] = "检查悄悄话？"
L["Check the yell?"] = "检查呼喊？"
L["Database"] = "数据库" -- Needs review
L["Debug"] = "调试" -- Needs review
L["Delete"] = "删除" -- Needs review
L["Do not display messages when blocking spam"] = "拦截垃圾信息时不显示提示"
L["Do you really want to block |3-1(%s) on %s?"] = "你真的想要屏蔽|3-1(%s) 于 %s"
L["Emote"] = "表情" -- Needs review
L["Enable Anti-flud filters"] = "启用重复发言过滤器" -- Needs review
L["Enable Level filter"] = "启用等级过滤" -- Needs review
L["Extra rating posts if the author is not a reliable level"] = "如果信息发送者的等级不可信，则增加额外的评分值"
L["Friends"] = "好友" -- Needs review
L["Garbage collection interval (sec)"] = "内存回收时间间隔(秒)"
L["Guild"] = "公会" -- Needs review
L["How often is allowed to send the same message?"] = "重复内容发言间隔" -- Needs review
L["If enabled, allows to update a local database of keywords."] = "如启用，将允许更新本地关键词数据库。" -- Needs review
L["If enabled, messages from players whose level is not included in the range will not be displayed"] = "如启用，将屏蔽等级范围外的玩家的发言信息。" -- Needs review
L["If enabled, the addon adds user to the blacklist on 24 hours"] = "如启用，将会添加玩家到黑名单24个小时"
L["If enabled, the addon use report queue"] = "如启用，插件将使用举报队列" -- Needs review
L["If enabled, the addon will automatically send reports of spam"] = "如启用，插件自动举报垃圾信息" -- Needs review
L["If enabled, you can update a local database of keywords, without confirmation."] = "如启用，更新本地关键词数据库不需确认。"
L["It makes sense to enable in the search errors (displays additional information during the addon)"] = "启用此项可以方便除错(显示插件运作的额外信息)"
L["It often happens that the scan only messages are not enough ... so sometimes you need to check the level of character, his nickname ..."] = "只检查聊天信息常常是不够的，有时你还得检查角色等级和昵称"
L["LevelFilter"] = "等级过滤" -- Needs review
L["Lifetime of information about the status of the last check posts in the cache (sec)"] = "最后检查的聊天信息的状态详情在缓存中存放多少(秒)"
L["Maximum level"] = "最高等级" -- Needs review
L["Maximum rating of the message after which it will be blocked"] = "超过此分值将屏蔽消息"
L["Maximum rating of the message after which it will be hidden"] = "超过此分值将隐藏消息"
L["Max is not a reliable player level"] = "低于此等级的玩家不可信"
L["Message from the player %s hidden for a reason: suspicion of spam! Post rating: %i"] = "来自于玩家 %s 的信息被隐藏，原因: 可能是垃圾信息！信息评分: %i"
L["Messages from the player %s locked, reason: Spam! Post rating: %i"] = "来自玩家 %s 的信息被屏蔽，原因：垃圾信息！信息评分：%i"
L["Minimum level"] = "最低等级" -- Needs review
L["MrtWoo: Has been upgraded default database of keywords, update a local database?\\nDB Info: new=%i, you=%i"] = "MrtWoo: 已更新了默认的关键词数据库，升级本地数据库吗？\\n数据库信息: 新的=%i, 你的=%i"
L["New"] = "新关键词" -- Needs review
L["New player"] = "新玩家" -- Needs review
L["Normalize messages"] = "格式化信息"
L["Party"] = "队伍" -- Needs review
L["Pattern:"] = "关键词：" -- Needs review
L["Patterns Editor"] = "关键词编辑器" -- Needs review
L["Perform additional checks?"] = "执行额外检查？"
L["Player name:"] = "玩家名称：" -- Needs review
L["Quiet mode"] = "安静模式" -- Needs review
L["Raid"] = "团队" -- Needs review
L["Rate:"] = "评分："
L["Rating posts required for the additional checks"] = "为信息评分时需要额外检查"
L["Reason:"] = "原因：" -- Needs review
L["Save"] = "保存" -- Needs review
L["Say"] = "说" -- Needs review
L["%s days"] = "%s 天" -- Needs review
L["Send reports of spam"] = "垃圾信息举报" -- Needs review
L["%s hours"] = "%s 小时" -- Needs review
L["Show BlockList Editor"] = "显示过滤列表编辑器" -- Needs review
L["Show Patterns Editor"] = "显示关键词编辑器" -- Needs review
L["%s min"] = "%s 分钟" -- Needs review
L["Sorry, but I do not want to receive messages from low-level players..."] = "对不起，我不想收到低等级玩家的信息。" -- Needs review
L["Spammers usually do not get the level higher than 15 ..."] = "垃圾信息发送者的一般不会超过15级"
L["Specify additional rating messages, it will be added to the rating message that was received after checking the contents ... if the total rating reports exceed the threshold of the lock, then the message will be seen as spam and all messages from this user will be freezing"] = "指定额外分值，在接收消息检查内容并评分后将加上此分值，如果总分值超过封锁界限，信息将被视为垃圾信息，此发送者的所有信息将被冻结"
L["Test without special characters, spaces, etc."] = "进行检测时忽略特殊字符、空格等"
L["The larger this value, the less will appear the same message"] = "数值越大，重复信息越少"
L["The lifetime of messages in the cache after the inspection (s)"] = "已检查的信息在缓存中存放多久"
L["This parameter affects how the message will be stored in the queue if there are problems with displaying messages, try increasing the value of this parameter"] = "此参数影响到消息在队列中的存放方式，如消息显示出现问题，尝试增大这个数值"
L["This value affects how often will occur repeatedly tested for spam, flooding"] = "此数值影响到垃圾信息/重复信息的检查频率"
L["This value affects how often will occur trying to remove unnecessary data from memory"] = "此数值影响到从内存中清除无用数据的频率"
L["This value must be less than the rating of the lock, or additional tests will not meet"] = "此数值必须小于屏蔽评分，否则额外检测无效"
L["User blocked manually"] = "手动屏蔽玩家"
L["Use report queue"] = "使用举报队列" -- Needs review
L["What types of messages to check?"] = "检测哪些聊天信息"
L["Whisper"] = "悄悄话" -- Needs review
L["White list"] = "白名单" -- Needs review
L["Yell"] = "大喊" -- Needs review
