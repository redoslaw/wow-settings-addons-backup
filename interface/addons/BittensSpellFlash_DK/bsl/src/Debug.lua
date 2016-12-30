local g = BittensGlobalTables
local c = g.GetTable("BittensSpellFlashLibrary")
local u = g.GetTable("BittensUtilities")
if u.SkipOrUpgrade(c, "Debug", tonumber("20150310040701") or time()) then
   return
end

local date = date
local format = string.format
local strlen = string.len
local tconcat = table.concat
local tinsert = table.insert
local tostringall = tostringall
local unpack = unpack

local function strconcat(...)
   return tconcat({tostringall(unpack(...))}, " ")
end

---------------------------------------------------------- Debug Reporting
c.DebugRing = {
   max = 250,
   Push = function(self, ...)
      tinsert(self, 1, {date("%Y-%m-%d %H:%M:%S"), ...})
      self[self.max + 1] = nil
   end,
}

-- this is super inefficient, but I literally don't care, because it is called
-- when the user is reporting a bug, and never otherwise!
local function generateReportText()
   local report = ""

   local function add(fmt, ...)
      report = format("%s%s\n", report, format(fmt, ...))
   end

   add("Player: %s - %d %s%s",
       UnitPVPName("player"),
       UnitLevel("player"),
       string.lower(select(2, UnitClass("player"))),
       IsPlayerNeutral() and "(neutral)" or ""
   )

   add("WoW: %s(%s) %s %s", GetBuildInfo())

   add("\nWhat is your suggestion, or problem?:\n")

   local position = strlen(report)

   add("\n")
   add(string.rep("-", 72))
   local count = #c.DebugRing
   if count <= 0 then
      add("There are no BSF log messages this session")
   else
      add("Last %d log messages:", count)
      for i=1, count do
         add("%s", strconcat(c.DebugRing[i]))
      end
   end

   return report, position
end


---------------------------------------------------------- GUI element
local helpText = [[
If you have a suggestion to improve Bitten's SpellFlash, or you found a problem with your rotation, that is great!  We love getting tickets to help improve the addons.

One thing that is a huge help in implementing your suggestions or fixing your bugs is the text below: it means that we can understand what is going on much more quickly.

Please add more text here, or when you are submitting the ticket, but please do include everything that was already there!  You should be able to select it all with Control-A, and copy it with Control-C, on all platforms.  Then, when you are done, go to the URL below and create a new ticket with all this text:
]] -- '


local ticketURL = "http://wow.curseforge.com/addons/bitten-common/create-ticket/"

local window = nil
local report = nil

local function createWindow()
   local width = math.min(math.floor(UIParent:GetWidth() / 2), 600)
   local height = math.floor((width / 1.618) * 1.5)

   window = CreateFrame("Frame", "BSFFrame", UIParent)
   window:Hide()
   tinsert(UISpecialFrames, "BSFFrame")

   window:SetFrameStrata("FULLSCREEN_DIALOG")
   window:SetWidth(width)
   window:SetHeight(height)
   window:SetPoint("CENTER")
   window:SetMovable(true)
   window:EnableMouse(true)
   window:RegisterForDrag("LeftButton")
   window:SetScript("OnDragStart", window.StartMoving)
   window:SetScript("OnDragStop", window.StopMovingOrSizing)
   window:SetScript("OnShow", function() PlaySound("igQuestLogOpen") end)
   window:SetScript("OnHide", function() PlaySound("igQuestLogClose") end)

   local titlebg = window:CreateTexture(nil, "BORDER")
   titlebg:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Title-Background")
   titlebg:SetPoint("TOPLEFT", 9, -6)
   titlebg:SetPoint("BOTTOMRIGHT", window, "TOPRIGHT", -28, -24)

   local dialogbg = window:CreateTexture(nil, "BACKGROUND")
   dialogbg:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-CharacterTab-L1")
   dialogbg:SetPoint("TOPLEFT", 8, -12)
   dialogbg:SetPoint("BOTTOMRIGHT", -6, 8)
   dialogbg:SetTexCoord(0.255, 1, 0.29, 1)

   local topleft = window:CreateTexture(nil, "BORDER")
   topleft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
   topleft:SetWidth(64)
   topleft:SetHeight(64)
   topleft:SetPoint("TOPLEFT")
   topleft:SetTexCoord(0.501953125, 0.625, 0, 1)

   local topright = window:CreateTexture(nil, "BORDER")
   topright:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
   topright:SetWidth(64)
   topright:SetHeight(64)
   topright:SetPoint("TOPRIGHT")
   topright:SetTexCoord(0.625, 0.75, 0, 1)

   local top = window:CreateTexture(nil, "BORDER")
   top:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
   top:SetHeight(64)
   top:SetPoint("TOPLEFT", topleft, "TOPRIGHT")
   top:SetPoint("TOPRIGHT", topright, "TOPLEFT")
   top:SetTexCoord(0.25, 0.369140625, 0, 1)

   local bottomleft = window:CreateTexture(nil, "BORDER")
   bottomleft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
   bottomleft:SetWidth(64)
   bottomleft:SetHeight(64)
   bottomleft:SetPoint("BOTTOMLEFT")
   bottomleft:SetTexCoord(0.751953125, 0.875, 0, 1)

   local bottomright = window:CreateTexture(nil, "BORDER")
   bottomright:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
   bottomright:SetWidth(64)
   bottomright:SetHeight(64)
   bottomright:SetPoint("BOTTOMRIGHT")
   bottomright:SetTexCoord(0.875, 1, 0, 1)

   local bottom = window:CreateTexture(nil, "BORDER")
   bottom:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
   bottom:SetHeight(64)
   bottom:SetPoint("BOTTOMLEFT", bottomleft, "BOTTOMRIGHT")
   bottom:SetPoint("BOTTOMRIGHT", bottomright, "BOTTOMLEFT")
   bottom:SetTexCoord(0.376953125, 0.498046875, 0, 1)

   local left = window:CreateTexture(nil, "BORDER")
   left:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
   left:SetWidth(64)
   left:SetPoint("TOPLEFT", topleft, "BOTTOMLEFT")
   left:SetPoint("BOTTOMLEFT", bottomleft, "TOPLEFT")
   left:SetTexCoord(0.001953125, 0.125, 0, 1)

   local right = window:CreateTexture(nil, "BORDER")
   right:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
   right:SetWidth(64)
   right:SetPoint("TOPRIGHT", topright, "BOTTOMRIGHT")
   right:SetPoint("BOTTOMRIGHT", bottomright, "TOPRIGHT")
   right:SetTexCoord(0.1171875, 0.2421875, 0, 1)

   local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
   close:SetPoint("TOPRIGHT", 2, 1)
   close:SetScript("OnClick", function() window:Hide() end)

   local title = CreateFrame("Button", nil, window)
   title:SetNormalFontObject("GameFontNormalLeft")
   title:SetHighlightFontObject("GameFontHighlightLeft")
   title:SetPoint("TOPLEFT", titlebg, 6, -4)
   title:SetPoint("BOTTOMRIGHT", titlebg, -6, 4)
   title:SetText("Bitten's SpellFlash: suggest improvements or report bugs")
   title:SetScript("OnHide", function() window:StopMovingOrSizing() end)
   title:SetScript("OnMouseUp", function() window:StopMovingOrSizing() end)
   title:SetScript("OnMouseDown", function() window:StartMoving() end)
   -- local quickTips = "|cff44ff44Double-click|r to filter bug reports. After you are done with the search results, return to the full sack by selecting a tab at the bottom. |cff44ff44Left-click|r and drag to move the window. |cff44ff44Right-click|r to close the sack and open the interface options for BSF."
   -- title:SetScript("OnEnter", function(self)
   --                           GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", -8, 8)
   --                           GameTooltip:AddLine("Quick tips")
   --                           GameTooltip:AddLine(quickTips, 1, 1, 1, 1)
   --                           GameTooltip:Show()
   -- end)
   -- title:SetScript("OnLeave", function(self)
   --                           if GameTooltip:IsOwned(self) then
   --                              GameTooltip:Hide()
   --                           end
   -- end)

   local help = window:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   help:SetJustifyH("LEFT")
   help:SetJustifyV("TOP")
   help:SetWordWrap(true)
   help:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -title:GetHeight())
   help:SetWidth(window:GetWidth() - 22)
   help:SetText(helpText)

   local urlEdit = CreateFrame("EditBox", "BSFURLText", window, "InputBoxTemplate")
   urlEdit:SetAutoFocus(false)
   urlEdit:SetMultiLine(true)   -- automatic height calculation
   urlEdit:SetTextColor(1, 1, 1)
   urlEdit:SetMaxLetters(0)
   urlEdit:EnableMouse(true)
   urlEdit:SetPoint("TOPLEFT", help, "BOTTOMLEFT", 0, 0)
   urlEdit:SetWidth(help:GetWidth())
   urlEdit:SetScript("OnShow", function() urlEdit:SetText(ticketURL) end)
   urlEdit:SetScript("OnEditFocusGained", urlEdit.HighlightText)
   urlEdit:SetScript("OnEscapePressed", urlEdit.ClearFocus)

   local scroll = CreateFrame("ScrollFrame", "BSFScroll",
                              window, "InputScrollFrameTemplate")
   scroll:SetPoint("TOPLEFT", urlEdit, "BOTTOMLEFT", 0, -8)
   scroll:SetPoint("BOTTOMRIGHT", window, -12, 16)

   scroll.CharCount:Hide()

   report = scroll.EditBox
   report:SetTextColor(1, 1, 1)
   report:SetMaxLetters(0)
   report:EnableMouse(true)
   report:SetScript("OnEscapePressed", report.ClearFocus)
   report:SetWidth(help:GetWidth())
end

function c.ShowDebugReport()
   if not window then
      createWindow()
   end

   local text, cursor = generateReportText()
   report:SetText(text)
   report:SetCursorPosition(cursor)
   window:Show()
   report:SetFocus()
end
