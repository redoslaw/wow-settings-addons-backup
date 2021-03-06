﻿local L = LibStub("AceLocale-3.0"):NewLocale("MrtWoo_AntiSpam", "ruRU", false)

if not L then return end

L["Add"] = "Добавить"
L["Add to blacklist on 24h"] = "Помещать спамера в черный список на 24 часа"
L["After receiving the message is scanned for spam and it is assigned a rating, usually a normal message is not spam has a rating of 0-75 ... If the message rating exceeds a given threshold of the lock, then the message will be seen as spam and all messages from this user will be freezing."] = "После получения сообщение проверяется на спам и ему присваивается рейтинг, как правило, нормальное сообщение, не являющееся спамом, имеет рейтинг 0-75. Если рейтинг сообщения превышает заданный порог, то сообщение будет расценено как спам, а все сообщения от этого пользователя будут заблокированы."
L["After receiving the messages are scanned for spam and given a rating, usually a normal message is not spam has a rating of 0-75 ... If the message rating exceeds a predetermined threshold, then the message will be treated as suspicious and will be hidden."] = "После получения сообщение проверяется на спам и ему присваивается рейтинг, как правило, нормальное сообщение, не являющееся спамом, имеет рейтинг 0-75. Если рейтинг сообщения превышает заданный порог, то сообщение будет расценено, как подозрительное, и скрыто."
L["Allow update local copy database?"] = "Обновлять локальную базу ключевых слов"
L["Allow update without confirmation?"] = "Обновлять без подтверждения"
L["Anti-Flud"] = "АнтиФлуд"
L["AntiSpam"] = "АнтиСпам"
L["Auto replay"] = "Авто ответ"
L["Block for..."] = "Заблокировать на"
L["Block Interval:"] = "Срок блокировки:"
L["BlockList Editor"] = "Редактор черного списка"
L["Channels"] = "Каналы"
L["Check the channels?"] = "Проверять каналы?"
L["Check the emote?"] = "Проверять эмоции?"
L["Check the say?"] = "Проверять речь?"
L["Check the whisper?"] = "Проверять шепот?"
L["Check the yell?"] = "Проверять крик?"
L["Database"] = "База данных"
L["Debug"] = "Отладка"
L["Delete"] = "Удалить"
L["Do not display messages when blocking spam"] = "Не отображать сообщения о блокировке спама"
L["Do you really want to block |3-1(%s) on %s?"] = "Вы действительно хотите заблокировать |3-1(%s) на %s?"
L["Emote"] = "Эмоции"
L["Enable Anti-flud filters"] = "Включить фильтры АнтиФлуда?"
L["Enable Level filter"] = "Включить фильтр уровней"
L["Extra rating posts if the author is not a reliable level"] = "Добавочный рейтинг сообщения, если уровень его автора ненадежен"
L["Friends"] = "Друзья"
L["Garbage collection interval (sec)"] = "Интервал сборки мусора (в секундах)"
L["Guild"] = "Гильдия"
L["How often is allowed to send the same message?"] = "Время между показом одинаковых сообщений (в секундах)"
L["If enabled, allows to update a local database of keywords."] = "Если включено, то аддон будет искать изменения в стандартной базе ключевых слов после обновления."
L["If enabled, messages from players whose level is not included in the range will not be displayed"] = "Если включен, то не будут показаны сообщения от игроков, уровень которых не попадает в диапазон"
L["If enabled, the addon adds user to the blacklist on 24 hours"] = "Если включено, то сообщения от спамеров будут блокироваться на 24 часа"
L["If enabled, the addon use report queue"] = "Если включено, модификация будет использовать очередь для отправки отчетов о спаме. Имеет смысл включить в игровых мирах с низкой интенсивностью сообщений"
L["If enabled, the addon will automatically send reports of spam"] = "Если включено, то отчеты о спаме будут отправляться автоматически"
L["If enabled, you can update a local database of keywords, without confirmation."] = "Если включено, то база будет обновляться без запроса подтверждения."
L["It makes sense to enable in the search errors (displays additional information during the addon)"] = "Имеет смысл влючать при поиске ошибок (выводит дополнительную информацию во время работы модификации)"
L["It often happens that the scan only messages are not enough ... so sometimes you need to check the level of character, his nickname ..."] = "Зачастую оказывается, что проверки самого сообщения недостаточно, поэтому необходимо дополнительно проверить уровень и имя персонажа"
L["LevelFilter"] = "Фильтр уровней"
L["Lifetime of information about the status of the last check posts in the cache (sec)"] = "Время жизни информации о статусе последней проверки сообщения пользователя в кэше (в секундах)"
L["Maximum level"] = "Максимальный уровень"
L["Maximum rating of the message after which it will be blocked"] = "Максимальный рейтинг сообщения, при достижении которого оно будет заблокировано"
L["Maximum rating of the message after which it will be hidden"] = "Максимальный рейтинг сообщения, после которого оно будет скрыто"
L["Max is not a reliable player level"] = "Максимальный ненадежный уровень игрока"
L["Message from the player %s hidden for a reason: suspicion of spam! Post rating: %i"] = "Сообщение от игрока \"%s\" скрыто по причине: подозрение на спам! Рейтинг сообщения: %i"
L["Messages from the player %s locked, reason: Spam! Post rating: %i"] = "Сообщения от игрока \"%s\" заблокированы, причина: спам! Рейтинг сообщения: %i"
L["Minimum level"] = "Минимальный уровень"
L["MrtWoo: Has been upgraded default database of keywords, update a local database?\\nDB Info: new=%i, you=%i"] = "MrtWoo: Была обновлена стандартная база ключевых слов, обновить локальную базу?\\nВерсии базы: новая=%i, ваша=%i"
L["New"] = "Новый шаблон"
L["New player"] = "Новая запись"
L["Normalize messages"] = "Нормализовать сообщения"
L["Party"] = "Группа"
L["Pattern:"] = "Шаблон:"
L["Patterns Editor"] = "Редактор шаблонов"
L["Perform additional checks?"] = "Выполнять дополнительные проверки"
L["Player name:"] = "Имя игрока:"
L["Quiet mode"] = "Тихий режим"
L["Raid"] = "Рейд"
L["Rate:"] = "Рейтинг:"
L["Rating posts required for the additional checks"] = "Рейтинг сообщения, инициирующий проведение дополнительных проверок"
L["Reason:"] = "Причина:"
L["Save"] = "Сохранить"
L["Say"] = "Речь"
L["%s days"] = "%s дней"
L["Send reports of spam"] = "Отправлять отчеты о спаме"
L["%s hours"] = "%s час."
L["Show BlockList Editor"] = "Показать редактор черного списка"
L["Show Patterns Editor"] = "Показать редактор шаблонов"
L["%s min"] = "%s мин."
L["Sorry, but I do not want to receive messages from low-level players..."] = "Извините, но я не хочу получать сообщения от игроков низкого уровня."
L["Spammers usually do not get the level higher than 15 ..."] = "Обычно спамеры не качают персонажей выше 15 уровня."
L["Specify additional rating messages, it will be added to the rating message that was received after checking the contents ... if the total rating reports exceed the threshold of the lock, then the message will be seen as spam and all messages from this user will be freezing"] = "Укажите добавочный рейтинг сообщения, он будет добавлен к рейтингу сообщения, который был получен после проверки содержания. Если суммарный рейтинг сообщения превысит порог блокировки, то сообщение будет расценено как спам и все сообщения от данного пользователя будут заблокированы"
L["Test without special characters, spaces, etc."] = "Сравнивать сообщения без учета специальных символов, пробелов и тому подобных"
L["The larger this value, the less will appear the same message"] = "Чем больше значение этого параметра, тем реже будут появляться одинаковые сообщения"
L["The lifetime of messages in the cache after the inspection (s)"] = "Время жизни сообщения в кэше после проверки (в секундах)"
L["This parameter affects how the message will be stored in the queue if there are problems with displaying messages, try increasing the value of this parameter"] = "Этот параметр влияет на количество сообщений в очереди. Если есть проблемы с выводом сообщений, попробуйте увеличить значение параметра"
L["This value affects how often will occur repeatedly tested for spam, flooding"] = "Значение данного параметра влияет на то, как часто будут происходить повторные проверки на спам и флуд"
L["This value affects how often will occur trying to remove unnecessary data from memory"] = "Значение данного параметра влияет на то, как часто будут производиться попытки удалить из памяти ненужные данные"
L["This value must be less than the rating of the lock, or additional tests will not meet"] = "Значение данного параметра должно быть меньше значения рейтинга блокировки, иначе дополнительные проверки проводиться не будут"
L["User blocked manually"] = "Игрок заблокирован вручную"
L["Use report queue"] = "Использовать очередь отчетов"
L["What types of messages to check?"] = "Какие типы сообщений проверять?"
L["Whisper"] = "Шепот"
L["White list"] = "Белый список"
L["Yell"] = "Крик"
