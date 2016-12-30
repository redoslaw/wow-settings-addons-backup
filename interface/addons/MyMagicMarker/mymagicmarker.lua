local ADDON, private = ...
local _G = _G

local function RaidTargetIcon(n)
    if _G.type(n)=='number' and (n>=1 and n<=8) then 
        return 'Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_'.._G.tostring(n)
    else
        return ''
    end
end

------------------------------------------------------------------

local STAR      = 1
local CIRCLE    = 2
local DIAMOND   = 3
local TRIANGLE  = 4
local MOON      = 5
local SQUARE    = 6
local CROSS     = 7
local SKULL     = 8
local NONE      = 0

--g_tblMobs = {}
local tblGuids = {}

local NEW_TARGET = 'new target'
------------------------------------------------------------------

local nameToDelete  -- This will be set by the button before this function is called
local function DeleteSection ()
    local idx = g_tblMobs[nameToDelete].idx
    g_tblMobs[nameToDelete] = nil
    
    -- Adjust our tables
    for k,v in _G.pairs(g_tblMobs) do
        if v.idx > idx then
            v.idx = v.idx - 1
        end
    end
    
    frmMagicMarker:Load()
    --frmMagicMarker:AdjustHeight()
end

StaticPopupDialogs["MAGICMARKER_CONFIRMDELETE"] = {
    --text = "Are you sure you want to delete this creature's marks?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function()
        DeleteSection()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

------------------------------------------------------------------

function AnyoneIsInCombat ()
    if _G.GetNumGroupMembers()==0 then
        return _G.UnitAffectingCombat('player')
    end
    
    local groupType
    if _G.IsInRaid() then
        groupType = 'raid'
    else
        groupType = 'party'
        if _G.UnitAffectingCombat('player') then
            return true
        end
    end
    
    for i=1,_G.GetNumGroupMembers() do
        if _G.UnitAffectingCombat(groupType.._G.tostring(i)) then
            return true
        end            
    end
    return false
end

------------------------------------------------------------------
                
local function isEmpty (tbl)
    for k,v in _G.pairs(tbl) do
        return false
    end
    return true
end

local function modulu (n,m)
    while n > m do
        n = n-m
    end
    return n
end

------------------------------------------------------------------

local function NeedToMark (strunit, name)
    return (g_tblMobs[name].friend and g_tblMobs[name].enemy)
        or (g_tblMobs[name].friend and _G.UnitIsFriend(strunit, 'player'))
        or (g_tblMobs[name].enemy and _G.UnitIsEnemy(strunit, 'player'))
end

local function HandleUnit (strunit)
    -- Checks if strunit needs to be marked, and, if so, marks it.
    if frmMagicMarker.disabled then return end
    
    local guid = _G.UnitGUID (strunit)
    local name = _G.UnitName (strunit)
    if _G.UnitIsDead(strunit) or name==nil then
        return
    end
    
    name = name:lower()
    if g_tblMobs[name] and NeedToMark(strunit, name) then
        if tblGuids[name]==nil then
            tblGuids[name] = {}
            tblGuids[name]['count'] = 0
        else
            if tblGuids[name][guid]==nil then
                tblGuids[name][guid] = 1
                tblGuids[name]['count'] = tblGuids[name]['count'] +1
                _G.SetRaidTarget (strunit, g_tblMobs[name].marks[modulu(tblGuids[name]['count'], #g_tblMobs[name].marks)])
            end
        end
    end
end

------------------------------------------------------------------
--  Actual functionality

local groupType = 'raid'
local timer = 0
local combatStarted = false
local lastTime = 0
local curTime
local THROTTLE = 0.5

local frm = CreateFrame ("Frame", nil, UIParent)
frm:RegisterEvent ("PLAYER_REGEN_ENABLED")
frm:RegisterEvent ("PLAYER_REGEN_DISABLED")
frm:RegisterEvent ("PLAYER_ENTERING_WORLD")
frm:RegisterEvent ("UPDATE_MOUSEOVER_UNIT")
frm:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
frm:SetScript ("OnEvent", function  (self, event, timeStamp, log_event,_,_, srcName,_, _, dstGuid)
    if event=='PLAYER_REGEN_ENABLED' then               -- Player exits combat
        --tblGuids = {}
    elseif event=='PLAYER_REGEN_DISABLED' then          -- Player enters combat
        combatStarted = true
        if _G.IsInRaid() then
            groupType = 'raid'
        else
            groupType = 'party'
        end
    elseif event=='PLAYER_ENTERING_WORLD' then
        if g_tblMobs==nil then
            g_tblMobs = {}
        end
        -- can insert fake tblMobs values here
        
        frmMagicMarker:Load ()
    elseif event=='UPDATE_MOUSEOVER_UNIT' then
        HandleUnit ('mouseover')
    elseif event=='COMBAT_LOG_EVENT_UNFILTERED' then
        --local everyoneIsDead = false
        curTime = _G.GetTime()
        if curTime - lastTime < THROTTLE then
            return 
        end
        lastTime = curTime
        
        for i=1,_G.GetNumGroupMembers() do
            local name,_,_,_,_,_,_,online = _G.GetRaidRosterInfo(i)
            if name and online then                
                HandleUnit (groupType.._G.tostring(i)..'target')
            end
            
        end
        
    end
end)

frm:SetScript ("OnUpdate", function  (self, elapsed)
    if --[[isEmpty(tblGuids) or]] combatStarted==false then return end
    
    timer = timer + elapsed
    --ChatFrame3:AddMessage(timer, 1.0,1.0,1.0)
    if timer > 5 then
        timer = 0
        if _G.AnyoneIsInCombat()==false then
            tblGuids = {}
            combatStarted = false
        end
    end
end)

------------------------------------------------------------------
--  And now the horrible GUI code :D

local WIDTH, HEIGHT = 451, 43
local HEIGHT_EX = 89

local WIDTH_MARK, HEIGHT_MARK = 32, 32
local MARK_COUNT = 8

local function CreateMarkTargetFrame (parent)
    local f = CreateFrame ("Frame", nil, parent)
    f:SetSize (WIDTH, HEIGHT)
    f:SetBackdrop ({
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        edgeSize = 12,
    })
    
    -- Glow effect
    local texGlow = f:CreateTexture ("Texture")
    f.texGlow = texGlow
    texGlow:SetPoint ("TOPLEFT", f, "TOPLEFT", 5, -5)
    texGlow:SetPoint ("BOTTOMRIGHT", f, "BOTTOMRIGHT", -5, 5)
    --texGlow:SetTexture ('Interface\\BUTTONS\\GRADBLUE')
    texGlow:SetTexture ('Interface\\AddOns\\'..ADDON..'\\white')

    -- Textbox
    f.frmtxt = CreateFrame ("Frame", nil, f)
    f.frmtxt:SetPoint ("TOPLEFT", f, "TOPLEFT", 15, -12)
    f.frmtxt:SetPoint ("BOTTOMRIGHT", f, "TOPLEFT", 271, -34)
    f.frmtxt:SetBackdrop ({
        bgFile = 'Interface\\Addons\\'..ADDON..'\\black',
        edgeFile = 'Interface\\DialogFrame\\UI-DialogBox-Gold-Border',
        edgeSize = 16,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    })    
    f.txt = CreateFrame ("EditBox", nil, f)
    f.txt:SetAllPoints (f.frmtxt)
    f.txt:SetTextColor (1.0,1.0,1.0,1.0)
    f.txt:SetFont ('Fonts\\ARIALN.TTF', 14, "")
    f.txt:SetTextInsets (7, 7, 2, 2)
    f.txt:SetFont ("Fonts\\FRIZQT__.TTF", 12)
    f.txt:SetAutoFocus (false)
    
    f.txt:SetScript ("OnEnterPressed", function(self)
        local newName = self:GetText():lower()
        
        if newName==self.oldText or (not self:HasFocus()) then return end
        
        if g_tblMobs[newName]~=nil then
            print (newName..' already exists!')
            return
        end
        
        g_tblMobs[newName] = g_tblMobs[self.oldText]
        g_tblMobs[self.oldText] = nil
        self:ClearFocus ()
        
        -- Update everything that still thinks of the old name
        self:SetText (newName)
        self:GetParent().name = newName
        frmMagicMarker_curMark:Pick (newName, frmMagicMarker_curMark.idx)
    end)
    f.txt:SetScript ("OnEscapePressed", function(self)
        self:ClearFocus ()
        self:SetText (self.oldText)
    end)
    
    -- On/off
    --[[local btnOnOff = CreateFrame ("Button", nil, f, "UIPanelButtonTemplate")
    f.btnOnOff = btnOnOff
    btnOnOff:SetSize (48,22)
    btnOnOff:SetPoint ("TOPLEFT", f, "TOPLEFT", 288, -10)
    btnOnOff:SetNormalTexture ('Interface\\AddOns\\'..ADDON..'\\onoff')
    btnOnOff:SetPushedTexture ('Interface\\AddOns\\'..ADDON..'\\onoff_pushed')
    btnOnOff:SetScript ("OnClick", function (self,...)
        local name = self:GetParent().name
        g_tblMobs[name].isOn = not g_tblMobs[name].isOn
        self:GetParent():Load (name)
    end)
    btnOnOff.tooltipText = 'On / Off']]

    -- Friend
    local btnFriend = CreateFrame ("Button", nil, f, "UIPanelButtonTemplate")
    f.btnFriend = btnFriend
    btnFriend:SetSize (58,22)
    btnFriend:SetPoint ("TOPLEFT", f, "TOPLEFT", 288, -10)
    btnFriend:SetText ('Friend')
    btnFriend:SetScript ("OnClick", function (self,...)
        local name = self:GetParent().name
        g_tblMobs[name].friend = not g_tblMobs[name].friend
        self:GetParent():Load (name)
    end)
    btnFriend.tooltipText = 'Mark friendly targets'
    
    -- Enemy
    local btnEnemy = CreateFrame ("Button", nil, f, "UIPanelButtonTemplate")
    f.btnEnemy = btnEnemy
    btnEnemy:SetSize (58,22)
    btnEnemy:SetPoint ("TOPLEFT", f, "TOPLEFT", 348, -10)
    btnEnemy:SetText ('Enemy')
    btnEnemy:SetScript ("OnClick", function (self,...)
        local name = self:GetParent().name
        g_tblMobs[name].enemy = not g_tblMobs[name].enemy
        self:GetParent():Load (name)
    end)
    btnEnemy.tooltipText = 'Mark hostile targets'
    
    -- Delete button
    local btnDelete = CreateFrame ("Button", nil, f, "UIPanelButtonTemplate")
    f.btnDelete = btnDelete
    btnDelete:SetSize (27,22)
    btnDelete:SetPoint ("TOPLEFT", f, "TOPLEFT", 411, -10)
    btnDelete:SetText ('x')
    btnDelete:SetScript ("OnClick", function (self, ...)
        nameToDelete = self:GetParent().name
        StaticPopupDialogs["MAGICMARKER_CONFIRMDELETE"]['text'] = "Are you sure you want to delete "..nameToDelete.."?"
        StaticPopup_Show ("MAGICMARKER_CONFIRMDELETE")
    end)
    btnDelete.tooltipText = 'Delete'
    
    -- Marks frame
    f.fm = CreateFrame ("Frame", nil, f)
    f.fm:SetSize (MARK_COUNT * WIDTH_MARK, HEIGHT_MARK)
    f.fm:SetPoint ("BOTTOMLEFT", f, "BOTTOMLEFT", 15, 15)
    f.fm:SetBackdrop ({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",  
        --edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        --edgeSize = 8,
    })

    f.fm.marks = {}
    for i=1,MARK_COUNT do
        local tmp = CreateFrame ("Frame", nil, f.fm)
        tmp:SetSize (WIDTH_MARK, HEIGHT_MARK)
        tmp:SetPoint ("LEFT", f.fm, "LEFT", (i-1)*WIDTH_MARK, 0)
        tmp.idx = i
        
        tmp.tex = tmp:CreateTexture ("Texture")
        tmp.tex:SetAllPoints (tmp)
        
        tmp:SetScript ("OnMouseDown", function (self, button, ...)
            self:GetParent():GetParent():PickMark (self.idx)
        end)
        
        table.insert (f.fm.marks, tmp)
    end
    
    f.fm:Hide()
    
    -- Functions!
    function f:Load (name)
        -- The parameter is a key from g_tblMobs
        self.txt:SetText (name)
        self.name = name
        self.idx = g_tblMobs[name].idx
        
        for i=1,MARK_COUNT do
            --print (i)
            self.fm.marks[i].tex:SetTexture (RaidTargetIcon(g_tblMobs[name].marks[i]))
        end
        
        if (g_tblMobs[name].friend or g_tblMobs[name].enemy) and (not frmMagicMarker.disabled) then
            self.texGlow:SetVertexColor (0.3,0.5,1,0.25)
        else
            self.texGlow:SetVertexColor (1,1,1,0)
        end
        
        if g_tblMobs[name].friend then
            self.btnFriend:GetFontString():SetTextColor (1,1,0.5)
        else
            self.btnFriend:GetFontString():SetTextColor (0,0,0)
        end
        
        if g_tblMobs[name].enemy then
            self.btnEnemy:GetFontString():SetTextColor (1,1,0.5)
        else
            self.btnEnemy:GetFontString():SetTextColor (0,0,0)
        end
    end
    
    function f:Expand ()
        self:SetHeight (HEIGHT_EX)
        self.fm:Show()
        self.isExpanded = true
        if #g_tblMobs[self.name].marks < MARK_COUNT-1 then
            self:PickMark (#g_tblMobs[self.name].marks+1)
        else
            self:PickMark (MARK_COUNT)
        end
    end
    function f:Collapse ()
        self:SetHeight (HEIGHT)
        self.fm:Hide()
        self.isExpanded = false
        frmMagicMarker_curMark:Unpick()
    end
    f:Collapse ()
    
    f:SetScript ("OnMouseDown", function (self, button,...)
        frmMagicMarker:OpenSection (self.name)
    end)
    
    f.txt:SetScript ("OnMouseDown", function (self, button,...)
        frmMagicMarker:OpenSection (self:GetParent().name)
        self.oldText = self:GetText()
    end)
    f.txt:SetScript ("OnMouseUp", function (self, button,...)
        if self:GetText():match (NEW_TARGET) then
            self:HighlightText()
        end
    end)
    
    function f:PickMark (idx)
        if idx > #g_tblMobs[self.name].marks+1 then
            idx = #g_tblMobs[self.name].marks+1
        end
        frmMagicMarker_curMark:Pick (self.name, idx)
    end
    
    return f
end

------------------------------------------------------------------
--  Create the interface

do
    -- Main container frame, mostly for the background and edge
    local CONTAINER_HEIGHT = 520
    local SLIDER_WIDTH = 19
    local CONTAINER_WIDTH = WIDTH+SLIDER_WIDTH
    local edge = 12
    
    -- The big scrollframe
    local f = CreateFrame ("ScrollFrame", 'frmMagicMarker', UIParent)
    f:SetSize (CONTAINER_WIDTH, CONTAINER_HEIGHT)
    f:SetPoint ("CENTER", UIParent, "CENTER", -100, 0)
    f:EnableMouseWheel (true)
    function f:scroll (delta)
        local val = self:GetVerticalScroll() - delta*20
        if val < 0 then
            val = 0
        elseif val > (self.cont:GetHeight() - CONTAINER_HEIGHT) then
            val = self.cont:GetHeight() - CONTAINER_HEIGHT
        end
        self:SetVerticalScroll (val)
    end
    f:SetScript("OnMouseWheel", f.scroll)
    f:SetScript ("OnVerticalScroll", function(self, offset)
        self.scrl:SetValue (offset)
    end)
        
    -- The contents frame - this is the child frame
    local CONTENTS_HEIGHT = HEIGHT*5
    local cont = CreateFrame ("Frame", nil, f)
    cont:SetSize (WIDTH, CONTENTS_HEIGHT)
    cont.sections = {}
    f:SetScrollChild (cont)
    f.cont = cont
    
    -- The scroll bar
    f.scrl = CreateFrame ("Slider", nil, f)
    local s = f.scrl
    s:SetSize (SLIDER_WIDTH,0)
    s:SetPoint ("TOPRIGHT", f, "TOPRIGHT")
    s:SetPoint ("BOTTOMRIGHT", f, "BOTTOMRIGHT")
    s:SetOrientation ("VERTICAL")
    s:SetBackdrop ({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",  
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        edgeSize = 2,
    })
    s:SetThumbTexture ("Interface\\Addons\\"..ADDON.."\\thumb")
    s:SetMinMaxValues (0, max(0,cont:GetHeight()-f:GetHeight()))
    s:Enable ()
    s:SetValue (0)
    s:SetScript ("OnValueChanged", function (self, value)
        self:GetParent():SetVerticalScroll (value)
    end)
    
    -- Background and frame
    local bg = CreateFrame ("Frame", nil, f)
    bg:SetSize (CONTAINER_WIDTH+edge, CONTAINER_HEIGHT+edge)
    bg:SetPoint ("CENTER", f, "CENTER")
    bg:SetBackdrop ({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",  
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        edgeSize = edge+4,
    })
    bg:SetFrameStrata ("BACKGROUND")
    bg:Lower()
    f.bg = bg
    
    -- Title bar
    local title = CreateFrame ("Frame", nil, f)
    title:SetSize (CONTAINER_WIDTH+edge, 30)
    title:SetPoint ("BOTTOM", f, "TOP")
    title:SetBackdrop ({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",  
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        edgeSize = edge+4,
    })
    f.title = title
    
    f.title.lbl = f.title:CreateFontString (nil, "BACKGROUND", "GameFontNormal")
    f.title.lbl:SetSize (CONTAINER_WIDTH+edge, 22)
    f.title.lbl:SetPoint ("TOP", f.title, "TOP", 0, -4)
    f.title.lbl:SetFont ('Fonts\\ARIALN.TTF', 15, "OUTLINE")
    f.title.lbl:SetText ('MagicMarker')
    
    -- X button
    f.title.btnx = CreateFrame ("Button", nil, f.title, "UIPanelCloseButton")
    f.title.btnx:SetPoint("RIGHT",f.title,"RIGHT")
    f.title.btnx:SetSize(30,30)
    f.title.btnx:SetScript ("OnClick", function (self,...)
        frmMagicMarker:Hide ()
    end)
    
    -- Enable/ disable all
    local btnOnOff = CreateFrame ("Button", nil, f.title, "UIPanelButtonTemplate")
    f.title.btnOnOff = btnOnOff
    btnOnOff:SetSize (42,18)
    btnOnOff:SetPoint ("LEFT", f.title, "LEFT", 4, 0)
    btnOnOff:SetNormalTexture ('Interface\\AddOns\\'..ADDON..'\\onoff')
    btnOnOff:SetPushedTexture ('Interface\\AddOns\\'..ADDON..'\\onoff_pushed')
    btnOnOff.tooltipText = 'Enable/ disable all'
    function f:EnableAll ()
        self.disabled = false
        for k,v in pairs (self.cont.sections) do
            v.btnFriend:Enable()
            v.btnEnemy:Enable()
            v:Load(v.name)
        end
    end
    function f:DisableAll ()
        self.disabled = true
        for k,v in pairs (self.cont.sections) do
            v.btnFriend:Disable()
            v.btnEnemy:Disable()
            v:Load(v.name)
        end
    end
    f:EnableAll()
    btnOnOff:SetScript ("OnClick", function (self,...)
        if frmMagicMarker.disabled then
            frmMagicMarker:EnableAll()
        else
            frmMagicMarker:DisableAll()
        end
    end)
    
    -- New
    local btnNew = CreateFrame ("Button", nil, f, "UIPanelButtonTemplate")
    btnNew:SetSize (CONTAINER_WIDTH+edge, 28)
    btnNew:SetPoint ("TOP", f, "BOTTOM", 0, -2)
    btnNew:SetText ("New")
    f.btnNew = btnNew
    
    btnNew:SetScript ("OnClick", function (self,...)
        local idx = #frmMagicMarker.cont.sections+1
        local name_idx = idx
        local name = NEW_TARGET..' '..tostring(name_idx)
        while g_tblMobs[name]~=nil do
            name_idx = name_idx+1
            name = NEW_TARGET..' '..tostring(name_idx)
        end
        
        g_tblMobs[name] = {
            marks = {},
            isOn = true,
            idx = idx,
            friend = false,
            enemy = true,
        }

        frmMagicMarker:Load()
        
        -- Also scroll to the end and open the new section
        local _,maxval = frmMagicMarker.scrl:GetMinMaxValues()
        frmMagicMarker.scrl:SetValue (maxval)
        frmMagicMarker:OpenSection (name)
    end)
    
    -- Moving!
    f:SetMovable (true)
    f:SetUserPlaced (true)
    f.title:SetScript ("OnMouseDown", function (self, button,...)
        if button=='LeftButton' then
            frmMagicMarker:StartMoving ()
        end
    end)
    f.title:SetScript ("OnMouseUp", function (self, button,...)
        frmMagicMarker:StopMovingOrSizing()
    end)

    
    -- Functions!
    function f:AdjustHeight ()
        for i,v in ipairs(self.cont.sections) do
            if i==1 then
                self.cont.sections[i]:SetPoint ("TOPLEFT", self.cont, "TOPLEFT")
                self.cont.sections[i]:SetPoint ("TOPRIGHT", self.cont, "TOPRIGHT")        
            else
                self.cont.sections[i]:SetPoint ("TOPLEFT", self.cont.sections[i-1], "BOTTOMLEFT")
                self.cont.sections[i]:SetPoint ("TOPRIGHT", self.cont.sections[i-1], "BOTTOMRIGHT")        
            end
        end
        self.cont:SetHeight (HEIGHT * #self.cont.sections + (HEIGHT_EX - HEIGHT))
        local val = max(0,cont:GetHeight()-self:GetHeight())
        self.scrl:SetMinMaxValues (0, val)
    end
    
    function f:Load ()
        -- Reset!
        for k,v in pairs(self.cont.sections) do
            v:Hide()
            v = nil
        end
        self.cont.sections = {}
        
        for k,v in pairs(g_tblMobs) do
            --print(k,v)
            local tmp = CreateMarkTargetFrame(self.cont)
            tmp:Load (k)
            
            self.cont.sections[tmp.idx] = tmp
        end
        
        if self.cont.sections[1] then
            self:OpenSection (self.cont.sections[1].name)
        end
        self:AdjustHeight ()
    end
    
    function f:OpenSection (name)
        local section
        for i,v in ipairs(self.cont.sections) do
            if v.name==name then
                section = v
                section:Expand ()
            else
                v:Collapse ()
            end
        end
        section:Expand ()
        frmMagicMarker_markMenu:SetPoint ("TOPLEFT", section, "TOPLEFT", 292, -41)
        frmMagicMarker_markMenu:SetParent (section)
    end
    
    function f:GetSectionByName (name)
        for i,v in ipairs(self.cont.sections) do
            if v.name==name then
                return v
            end
        end
    end
    
    f:Hide()
end

------------------------------------------------------------------
--  Mark picking

do
    local cur = CreateFrame ("Frame", 'frmMagicMarker_curMark', UIParent)
    cur:SetSize (WIDTH_MARK+4, HEIGHT_MARK+4)
    cur:SetBackdrop ({
        bgFile = "Interface\\BUTTONS\\UI-Quickslot-Depress",
    })
    cur:SetFrameStrata ("DIALOG")
    
    function cur:Pick (name,idx)
        self.name = name
        self.idx = idx
        self:SetPoint ("CENTER", frmMagicMarker:GetSectionByName(name).fm.marks[idx], "CENTER", 0, -2)
        self:SetParent (frmMagicMarker:GetSectionByName(name))
        self:Show()
    end
    
    function cur:Unpick ()
        self.name = nil
        self.idx = nil
        self:Hide()
    end    

    ----------
    
    local f = CreateFrame ("Frame", 'frmMagicMarker_markMenu', frmMagicMarker.cont)
    local W, H = 20,19
    f:SetSize (W*6, H*2)
    f:Raise()
    --f:SetPoint ("LEFT", UIParent, "LEFT")
    
    local function SetMark (name, idx, newval)
        -- First thing first, if the textbox is in focus then we better save the changes
        local txtbox = frmMagicMarker:GetSectionByName(frmMagicMarker_curMark.name).txt
        txtbox:GetScript("OnEnterPressed")(txtbox)
        name = frmMagicMarker_curMark.name  -- The last line may well change this value
        
        g_tblMobs[name].marks[idx] = newval
        
        -- If this was removing a mark - move all the next marks to a lower index
        if newval==nil then
            for i=idx+1,MARK_COUNT do
                g_tblMobs[name].marks[i-1] = g_tblMobs[name].marks[i]
                g_tblMobs[name].marks[i] = nil
            end
        end
        
        -- Move the picker to the next position
        if newval~=nil and idx < MARK_COUNT then
            frmMagicMarker_curMark:Pick (name, idx+1)
        end
        
        -- If you click None and have picked the position after the last mark, delete the last mark
        if newval==nil and idx==#g_tblMobs[name].marks+1 and idx~=1 then
            g_tblMobs[name].marks[idx-1] = nil
            frmMagicMarker_curMark:Pick (name, idx-1)
        end
        
        -- Reload!
        frmMagicMarker:GetSectionByName(name):Load (name)
    end
    
    f.btns = {}
    for i=1,MARK_COUNT do
        local tmp = CreateFrame ("Button", nil, f)
        tmp:SetSize (16,16)
        tmp:SetNormalTexture (RaidTargetIcon(i))    
        tmp.idx = i
        
        local x = ((i-1)%4) * (W+4)
        local y = floor((i-1)/4) * H
        tmp:SetPoint ("TOPLEFT", f, "TOPLEFT", x, -y)
        
        tmp:SetScript ("OnClick", function (self,...)
            SetMark (frmMagicMarker_curMark.name, frmMagicMarker_curMark.idx, self.idx)
        end)
        
        f.btns[i] = tmp
    end
    
    f.btnNone = CreateFrame ("Button", nil, f)
    f.btnNone:SetSize (32, 32)
    f.btnNone:SetPoint ("TOPLEFT", f, "TOPLEFT", 4*(W+4), 0)
    f.btnNone:SetNormalTexture ('Interface\\BUTTONS\\UI-GroupLoot-Pass-Up')
    f.btnNone:SetScript ("OnClick", function (self,...)
        SetMark (frmMagicMarker_curMark.name, frmMagicMarker_curMark.idx, nil)
    end)
    
end


-- Slash commands
SLASH_MMM1 = "/mmm"
SlashCmdList["MMM"] = function (txt)
    if txt=='reset' then
        tblGuids = {}
        print ('Marks reset')
    else
        frmMagicMarker:Show()
    end
end





--[[g_tblMobs = {
    ['greater cave bat'] = {
        marks = {MOON, STAR, SQUARE},
        isOn = true,
        idx = 1,
    },
    ['farraki wastewalker'] = {
        marks = {SKULL, CROSS, CIRCLE},
        isOn = true,
        idx = 2,
    },
    ['gurubashi venom priest'] = {
        marks = {SKULL, CROSS, CIRCLE},
        isOn = true,
        idx = 3,
    },
    ['venomous effusion'] = {
        marks = {MOON, TRIANGLE, SQUARE},
        isOn = true,
        idx = 4,
    },
    ['drakkari frozen warlord'] = {
        marks = {SKULL, CROSS, CIRCLE},
        isOn = true,
        idx = 5,
    },
    ['amani warbear'] = {
        marks = {SKULL, CROSS, CIRCLE},
        isOn = true,
        idx = 6,
    },
    ["amani'shi beast shaman"] = {
        marks = {SKULL, CROSS, CIRCLE},
        isOn = true,
        idx = 7,
    },
    ['zandalari dinomancer'] = {
        marks = {DIAMOND},
        isOn = true,
        idx = 8,
    },
    ['blessed loa spirit'] = {
        marks = {SKULL},
        isOn = true,
        idx = 9,
    },
    ['shadowed loa spirit'] = {
        marks = {SKULL},
        isOn = true,
        idx = 10,
    },
    ['wild mature swine'] = {
        marks = {CROSS, SKULL},
        isOn = true,
        idx = 11,
    },
    ['Test'] = {
        marks = {CROSS},
        isOn = false,
        idx = 12,
    },
}]]