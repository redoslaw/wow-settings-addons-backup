-- GLOBALS
KQ_whisperMessage = ""
KQ_whisperSender = ""
KQ_whisperClass = 0
KQ_applicants = {}
KQ_applicants[0] = {}	
KQ_isKeyQueueShown = false

-- Locals
local isUIMAINHidden = true
local isFirstRun = true
local applicantFrame = {}
local applicantFrameTexture = {}
local KQUpdateTimer = 0
-- UI ALL
	-- UIMAIN
local UIMAIN = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
UIMAIN:Hide()
UIMAIN:SetSize(340, 380)
UIMAIN:SetPoint("CENTER", UIParent, "CENTER");
UIMAIN:SetMovable(true)
UIMAIN:EnableMouse(true)
UIMAIN:RegisterForDrag("LeftButton")
UIMAIN:SetScript("OnDragStart", UIMAIN.StartMoving)
UIMAIN:SetScript("OnDragStop", UIMAIN.StopMovingOrSizing)
UIMAIN:SetClampedToScreen(true)

--[[	-- Settings button
local topBarButton = CreateFrame("Button", nil, UIMAIN)
topBarButton:SetPoint("TOPLEFT", UIMAIN, "TOPLEFT", 5, -2)
topBarButton:SetSize(15, 15)

		-- Settings button texture
local topBarButtonTex = topBarButton:CreateTexture()
topBarButtonTex:SetTexture("Interface\\AddOns\\KeyQueue_Dev\\img\\HelpIcon-CharacterStuck")
topBarButtonTex:SetTexCoord(0, 0.8, 0, 0.8)
topBarButtonTex:SetAllPoints()	
topBarButton:SetNormalTexture(topBarButtonTex) ]]--

	-- Top bar string
local topBarString = UIMAIN:CreateFontString(nil, "ARTWORK", "GameFontNormal")
topBarString:SetText("KeyQueue - /kq")
topBarString:SetPoint("TOP", UIMAIN, "TOP", 0, -5)




-- UI TAB ONE (Applicant page)

	-- Applicant frame
local UIFrameOne = CreateFrame("Frame", nil, UIMAIN);

	-- Instruction text
local infoText = UIFrameOne:CreateFontString(nil, "ARTWORK", "GameFontNormal")
infoText:SetPoint("TOPLEFT", UIMAIN, "TOPLEFT", 15, -38)
infoText:SetText("List updates on whispers")
infoText:SetTextColor(0.5, 0.5, 0.5, 0.5)

	-- Clear applicants button
local clearListButton = CreateFrame("Button", nil, UIFrameOne, "UIPanelButtonTemplate")
clearListButton:SetSize(75,25) 
clearListButton:SetPoint("TOPRIGHT", UIMAIN, "TOPRIGHT", -15, -32)
clearListButton:SetText("Clear list")

		-- Clear applicants button text
local clearListButtonText = clearListButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
clearListButtonText:SetPoint("RIGHT", clearListButton, "LEFT", 0, 0)
clearListButtonText:SetText("")

	-- Applicant frame's frame header
local applicantHeader = CreateFrame("Frame", nil, UIFrameOne)
applicantHeader:SetSize(290,20)
applicantHeader:SetPoint("TOPLEFT", UIMAIN, "TOPLEFT", 15, -65)
local textureFrameHeader = applicantHeader:CreateTexture("ARTWORK")
textureFrameHeader:SetColorTexture(0.5, 0.5, 0.5, 0.2)
textureFrameHeader:SetAllPoints(applicantHeader)

		-- Applicant frame's frame header text (WHISPERS)
local checkString = UIFrameOne:CreateFontString("$parrentqueuecheck", "ARTWORK", "GameFontNormal")
checkString:SetPoint("CENTER", applicantHeader, "CENTER", -5, 0)



		-- Applicant slider
KQ_applicantSlider = CreateFrame("Slider", nil, UIFrameOne)
KQ_applicantSlider:SetPoint("TOPLEFT", applicantHeader, "TOPRIGHT", 5 ,5)
KQ_applicantSlider:SetHeight(310)
KQ_applicantSlider:SetWidth(17)
KQ_applicantSlider:SetOrientation("VERTICAL") 
KQ_applicantSlider:SetValue(0)
KQ_applicantSlider:SetMinMaxValues(0,1)
KQ_applicantSlider:SetBackdrop({
	bgFile = "Interface\\Buttons\\UI-SliderBar-Background", 
  edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
  tile = true, tileSize = 8, edgeSize = 8, 
  insets = { left = 3, right = 3, top = 6, bottom = 6 }})
KQ_applicantSlider:SetObeyStepOnDrag(true)
KQ_applicantSlider:SetValueStep(1)
KQ_applicantSlider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")

		-- Individual applicant frames
		
for index = 1, 9 do
	applicantFrame[index] = CreateFrame("Frame", nil, UIFrameOne, "ApplicantTemplate")
	if index == 1 then
		applicantFrame[index]:SetPoint("TOP", applicantHeader, "BOTTOM", 0, 0)
	else
		applicantFrame[index]:SetPoint("TOP", applicantFrame[index-1], "BOTTOM", 0, -2)
	end
	applicantFrameTexture[index] = applicantFrame[index]:CreateTexture("ARTWORK")
	applicantFrameTexture[index]:SetColorTexture(58/100, 48/100, 68/100, 0.1)
	applicantFrameTexture[index]:SetAllPoints(applicantFrame[index])
	
end

local function KQ_setClassTexture(applicantNumber, classNumber)

	classNumber = tonumber(classNumber)
	
	if classNumber == 0 then
		--applicantFrameTexture[applicantNumber].TextStringName:SetTextColor(0,0,0,1)
	elseif classNumber == 1 then
		-- Warrior
		applicantFrame[applicantNumber].TextStringName:SetTextColor(0.78, 0.61, 0.43, 1)
	elseif classNumber == 2 then
		-- Paladin
		applicantFrame[applicantNumber].TextStringName:SetTextColor(0.96, 0.55, 0.73, 1)
	elseif classNumber == 3 then
		-- Hunter
		applicantFrame[applicantNumber].TextStringName:SetTextColor(0.67, 0.83, 0.45, 1)
	elseif classNumber == 4 then
		-- Rogue
		applicantFrame[applicantNumber].TextStringName:SetTextColor(1.00, 0.96, 0.41, 1)
	elseif classNumber == 5 then
		-- Priest
		applicantFrame[applicantNumber].TextStringName:SetTextColor(1.00, 1.00, 1.00, 1)
	elseif classNumber == 6 then
		-- Death Knight
		applicantFrame[applicantNumber].TextStringName:SetTextColor(0.77, 0.12, 0.23, 1)
	elseif classNumber == 7 then
		-- Shaman
		applicantFrame[applicantNumber].TextStringName:SetTextColor(0.00, 0.44, 0.87, 1)
	elseif classNumber == 8 then
		-- Mage
		applicantFrame[applicantNumber].TextStringName:SetTextColor(0.41, 0.80, 0.94, 1)
	elseif classNumber == 9 then
		-- Warlock
		applicantFrame[applicantNumber].TextStringName:SetTextColor(0.58, 0.51, 0.79, 1)
	elseif classNumber == 10 then
		-- Monk 
		applicantFrame[applicantNumber].TextStringName:SetTextColor(0.00, 1.00, 0.59, 1)
	elseif classNumber == 11 then
		-- Druid
		applicantFrame[applicantNumber].TextStringName:SetTextColor(1.00, 0.49, 0.04, 1)
	elseif classNumber == 12 then
		-- Demon Hunter
		applicantFrame[applicantNumber].TextStringName:SetTextColor(0.64, 0.19, 0.79, 1)
	else 
		print("Something went wrong")
	end
	
	--applicantFrameTexture[applicantNumber]:SetAllPoints(applicantFrame[applicantNumber])

end




-- LOGIC FUNCTIONS LOCAL
	-- Update applicants
function KQ_UpdateApplicants(startApplicant)
	local name = "ApplicantTemplateFontString"
	sliderMax = #KQ_applicants
	checkString:SetText(tostring(sliderMax).. " keystones")
	if sliderMax < 10 then
		KQ_applicantSlider:SetMinMaxValues(0,0)
	else
		KQ_applicantSlider:SetMinMaxValues(0, sliderMax-9)
	end
	if KQ_settings[1] == true then
		UIMAIN:SetHeight(470)
		KQ_applicantSlider:SetHeight(400)
	else 
		UIMAIN:SetHeight(380)
		KQ_applicantSlider:SetHeight(310)
	end
	for i=1,9 do
		if KQ_applicants[startApplicant + i] ~= nil then 
			applicantFrame[i]:Show()
			local instance = KQ_applicants[startApplicant + (i)][0] -- INSTANCE
			local keyLevel = KQ_applicants[startApplicant + (i)][1] -- KEY LEVEL
			if KQ_applicants[startApplicant + (i)][2] == true then
				applicantFrame[i].TextStringKey:SetTextColor(0.5,0.5,0.5,1)
				applicantFrame[i].TextStringDungeon:SetTextColor(0.5,0.5,0.5,1)
				applicantFrame[i].TextStringKey:SetText("+" .. keyLevel)
				applicantFrame[i].TextStringDungeon:SetText(instance .. " (d)")
			else
				applicantFrame[i].TextStringKey:SetTextColor(1,0.82,0,1)
				applicantFrame[i].TextStringDungeon:SetTextColor(1,0.82,0,1)
				applicantFrame[i].TextStringKey:SetText("+" .. keyLevel)
				applicantFrame[i].TextStringDungeon:SetText(instance)
			end
			--applicantFrame[i].TextStringKey:SetText("+" .. keyLevel)
			--applicantFrame[i].TextStringDungeon:SetText(instance)
			local calculateTime = GetTime()
			calculateTime = (calculateTime - KQ_applicants[startApplicant + i][6])/60
			calculateTime = math.floor(calculateTime)
			if math.floor(calculateTime/60) >= 1 then
				calculateTime = math.floor(calculateTime/60)
				applicantFrame[i].TextStringTime:SetText(calculateTime .. "h")
			elseif calculateTime >= 1 then
				applicantFrame[i].TextStringTime:SetText(calculateTime .. "m")
			else
				applicantFrame[i].TextStringTime:SetText("1>" .. "m")
			end
			if KQ_applicants[startApplicant + i][7] == 0 then
				applicantFrame[i].InviteButton:Enable()
				applicantFrame[i].InviteButton:SetText("Invite")
			else
				applicantFrame[i].InviteButton:Disable()
				applicantFrame[i].InviteButton:SetText("Invited")
			end
			if KQ_applicants[startApplicant + i][5] == 0 then
				applicantFrame[i].TextStringilvl:SetText("")
			else 
				applicantFrame[i].TextStringilvl:SetText(tostring(KQ_applicants[startApplicant+i][5]))
			end
			applicantFrame[i].InviteButton:SetScript("OnClick", function(self)
				applicantFrame[i].InviteButton:Disable()
				applicantFrame[i].InviteButton:SetText("Invited")
				InviteUnit(KQ_applicants[startApplicant + i][3])
				print("Inviting: ", KQ_applicants[startApplicant + i][3])
				local fadeOut = applicantFrame[i]:CreateAnimationGroup()
				local fade = fadeOut:CreateAnimation("Alpha")
				fade:SetFromAlpha(1)
				fade:SetToAlpha(-1)
				fade:SetDuration(1)
				fadeOut:SetScript("OnFinished", function()
					table.remove(KQ_applicants, startApplicant + i)
					KQ_UpdateApplicants(KQ_applicantSlider:GetValue())
				end)
				fadeOut:Play()
			end)
			--KQ_setClassTexture(i, KQ_applicants[startApplicant + i][4])
			
			-- If Show applicant names is checked
			if KQ_settings[1] == true then
				applicantFrame[i].TextStringName:Show()
				applicantFrame[i].TextStringName:SetText(KQ_applicants[startApplicant+i][3])
				applicantFrame[i]:SetHeight(40)
			else
				applicantFrame[i].TextStringName:Hide()
				applicantFrame[i]:SetHeight(30)
			end
		else 
			applicantFrame[i]:Hide()
		end
	end
end

local function addApplicant(dungeon, key, loot, name, class, ilvl)
	for x = 1, #KQ_applicants do
		if KQ_applicants[x][3] == name then
			return
		end
	end
	local whisperTime = GetTime()
	dungeon = C_ChallengeMode.GetMapInfo(dungeon)
	number = #KQ_applicants + 1 
	KQ_applicants[number] = {}
	KQ_applicants[number][0] = dungeon
	KQ_applicants[number][1] = key
	KQ_applicants[number][2] = loot
	KQ_applicants[number][3] = name
	KQ_applicants[number][4] = class
	KQ_applicants[number][5] = ilvl
	KQ_applicants[number][6] = whisperTime 
	KQ_applicants[number][7] = 0 -- QUICKFIX FOR THE IF STATEMENT IN THE UPDATE APPLICANTS
	
	KQ_UpdateApplicants(KQ_applicantSlider:GetValue())
end

local function converClassToNumber(class)
	class = class:lower()
	class = gsub(class, " ", "")
	classNum = 0
	if class == "warrior" then
		classNum = 1
	end
	if class == "paladin" then
		classNum = 2
	end
	if class == "hunter" then
		classNum = 3
	end
	if class == "rogue" then
		classNum = 4
	end
	if class == "priest" then
		classNum = 5
	end
	if class == "deatknight" then
		classNum = 6
	end
	if class == "shaman" then
		classNum = 7
	end
	if class == "mage" then
		classNum = 8
	end
	if class == "warlock" then
		classNum = 9
	end
	if class == "monk" then
		classNum = 10
	end
	if class == "druid" then
		classNum = 11
	end
	if class == "demonhunter" then
		classNum = 12
	end
	return classNum
end



local function handleWhisper()
	originalLinkSubstring = strsub(KQ_whisperMessage, 11, strfind(KQ_whisperMessage, '|h') - 1)
	parts = { strsplit(':', originalLinkSubstring) }
	local length = #parts
	if tonumber(parts[2]) == 138019 then
		dungeonID = tonumber(parts[15])
		keystoneLevel = tonumber(parts[16])
		local affixes = parts[12]
		local key_depleted_mask = 4194304
		local depleted = (bit.band(affixes, key_depleted_mask) ~= key_depleted_mask)
		print(depleted)
		addApplicant(dungeonID, keystoneLevel, depleted, KQ_whisperSender, 0, 0)
		
	end
end

local function handleWhisperBN()
	originalLinkSubstring = strsub(KQ_whisperMessage, 11, strfind(KQ_whisperMessage, '|h') - 1)
	parts = { strsplit(':', originalLinkSubstring) }
	
	local length = #parts
	
	
	if tonumber(parts[1]) == 8019 then
		dungeonID = tonumber(parts[14])
		keystoneLevel = tonumber(parts[15])
		--KQ_HideSystemMSG = true
		--SendWho(KQ_whisperSender)
		--name, guild, level, race, class, zone, classFileName, sex = GetWhoInfo(1)
		local affixes = parts[12]
		local key_depleted_mask = 4194304
		local depleted = (bit.band(affixes, key_depleted_mask) ~= key_depleted_mask)
		addApplicant(dungeonID, keystoneLevel, depleted, KQ_whisperSender, KQ_whisperClass, 0)
	end
end

local function eventHandler(self, event, prefix, msg, channel, sender, presenceID)
	KQ_whisperClass = 0
	if event == 'CHAT_MSG_ADDON' and prefix == 'KeystoneHelper' then
		-- Another user's keystone info (which we may or may not have asked for, but print either way)
		prefix = 'keynameclass:'
		if strsub(msg, 1, strlen(prefix)) == prefix then
			_, dungeonID, keystoneLevel, lootEligible, name, class, ilvl = strsplit(':', msg)	
			addApplicant(dungeonID, keystoneLevel, lootEligible, name, class, ilvl)
		end
	end
	if event == 'CHAT_MSG_WHISPER' then
		KQ_whisperSender = msg
		KQ_whisperMessage = prefix
		--originalLinkSubstring = strsub(msg, 11, strfind(msg, '|h') - 1)
		if pcall(handleWhisper) then
			--print("Success")
		else
			--print("Failure")
		end
	end
	if event == 'CHAT_MSG_BN_WHISPER'  then
		KQ_whisperSender = msg
		KQ_whisperMessage = prefix
		
		local _, numFreinds = BNGetNumFriends()
				
		for index = 1, numFreinds do
			local name = select(2, BNGetFriendInfo(index))
			if KQ_whisperSender == name then
				local bnetIDGameAccount, client = select(6, BNGetFriendInfo(index))
				client = select(7, BNGetFriendInfo(index))
				if client == "WoW" then
					local _, characterName, _, realmName, _, faction, _, class = BNGetGameAccountInfo(bnetIDGameAccount)
					local factionGroup, factionName = UnitFactionGroup("player")
					if faction == factionGroup then
						KQ_whisperClass = converClassToNumber(class)
						KQ_whisperSender = characterName.."-"..realmName
						if pcall(handleWhisperBN) then
							--print("Success")
						else
							--print("Failure")
						end
					end
				end
			end
		end
	end
	if event == "ADDON_LOADED" then
		KQ_UpdateApplicants(0)
		if KQ_isKeyQueueShown == true then
			UIMAIN:Show()
		else
			UIMAIN:Hide()
		end
	end
end


-- LOGIC BEHAVIOUR
UIMAIN:SetScript("OnUpdate", function(self, elapsed)
	KQUpdateTimer = KQUpdateTimer + elapsed
	if KQUpdateTimer >= 60 then
		KQUpdateTimer = 0
		KQ_UpdateApplicants(KQ_applicantSlider:GetValue())
	end
end)

--[[	-- Settings clicked
topBarButton:SetScript("OnClick", function(self)
KQ_showSettings()
end) ]]--

KQ_applicantSlider:SetScript("OnValueChanged", function(self, value)
	KQ_UpdateApplicants(value)
end)

UIMAIN:SetScript("OnMouseWheel", function(self, delta)
	local current = KQ_applicantSlider:GetValue()
	
	if delta < 0 and current < #KQ_applicants-9 then
		KQ_applicantSlider:SetValue(current+1)
	elseif delta > 0 and current >= 1 then
		KQ_applicantSlider:SetValue(current - 1)
	end
end)

UIMAIN:SetScript("OnShow", function(self)
	KQ_applicantSlider:SetValue(0)
	isUIMAINHidden = false
	KQ_isKeyQueueShown = true
end)

UIMAIN:SetScript("OnHide", function(self)
	isUIMAINHidden = true
	KQ_isKeyQueueShown = false
end)

clearListButton:SetScript("OnClick", function(self)
	KQ_applicants = {}
	KQ_applicants[0] = {}
	KQ_UpdateApplicants(0)
end)

UIMAIN:RegisterEvent('CHAT_MSG_ADDON')
UIMAIN:RegisterEvent('CHAT_MSG_WHISPER')
UIMAIN:RegisterEvent('CHAT_MSG_BN_WHISPER')
UIMAIN:SetScript('OnEvent', eventHandler)
RegisterAddonMessagePrefix('KeystoneHelper')
UIMAIN:RegisterEvent('CHAT_MSG_SYSTEM')
UIMAIN:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
UIMAIN:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out

-- SLASH COMMANDS
SLASH_KEYSTONEHELPER1, SLASH_KEYSTONEHELPER2 = "/keyqueue", "/kq";
function SlashCmdList.KEYSTONEHELPER(msg)
	if msg == "clear" then
		KQ_applicants = {}
		KQ_applicants[0] = {}
		KQ_UpdateApplicants(0)
		return
	end
	if isUIMAINHidden then
		isUIMAINHidden = false
		UIMAIN:Show()
	else 
		isUIMAINHidden = true 
		UIMAIN:Hide()
	end
end

-- INITILIZATION
print("/kq - to open KeyQueue") -- Print to user

-- TEST FUNCTIONS
function printApplicants()
	for x=1, #KQ_applicants do
		print(KQ_applicants[x][3])
	end
end
