local FlyPitch = LibStub("AceAddon-3.0"):NewAddon("FlyPitch", "AceConsole-3.0", "AceEvent-3.0");
local media = LibStub("LibSharedMedia-3.0");
local db;

local defaults = {
	profile = {
		visibility = {
			flying = true,
			swimming = true,
			combat = false,			
		},
		position = {
			parent = "UIParent",
			anchorto = "CENTER",
			anchorfrom = "CENTER",
			x = 0,
			y = -38,
		},
		framelevel = {
			strata = "MEDIUM",
			level = 2,
		},
		size = {
			height = 250,
			scale = 1,
		},
		animation = {
			update = 0.03,
			fader = {
				timeuntilfade = 0.5,
				alpha = 0,
			},
		},
		elements = {
			Center = {
				color = {r = 1, g = 1, b = 1, a = 1},
				size = {height = 32, width = 32},
			},
			Mover = {
				color = {r = 1, g = 1, b = 1, a = 1},
				size = {height = 32, width = 128},
			},
			LimitArrow = {
				color = {r = 1, g = 1, b = 1, a = 1},
				size = {height = 64, width = 64},
			},
		},
	},
};

local PitchTextures = {
	ArrowSmall = "Interface\\AddOns\\FlyPitch\\Media\\Pitch_Gauge_Arrow_Small",
	ArrowSmallR = "Interface\\AddOns\\FlyPitch\\Media\\Pitch_Gauge_Arrow_Small_R",
	ArrowLarge = "Interface\\AddOns\\FlyPitch\\Media\\Pitch_Gauge_Arrow_Large",
	ArrowLargeR = "Interface\\AddOns\\FlyPitch\\Media\\Pitch_Gauge_Arrow_Large_R",
	Mover = "Interface\\AddOns\\FlyPitch\\Media\\Pitch_Mover",
	MoverR = "Interface\\AddOns\\FlyPitch\\Media\\Pitch_Mover_R",
	Center = "Interface\\AddOns\\FlyPitch\\Media\\Pitch_Gauge_Center",
	MoverCenter = "Interface\\AddOns\\FlyPitch\\Media\\Pitch-Mover-Center",
};

local PitchFrame = nil;
local PitchVisible = false;
local PitchFaded = false;

local PitchDirection = 0;	-- 0 = Center, 1 = Up, -1 = Down
local CurPitch = 0;
local ElapsedSinceChange = 0;

local PitchLimit = 88;	-- Maximum flight pitch in Degrees (88 is WoW's default)
local PitchCenterPoint = 3;	-- When to change the Pitch display to Center style


---- PITCH UPDATE
-- Timer
local PitchTimer = CreateFrame("FRAME")
local PitchTimer_Int = 0.5;
PitchTimer:SetScript("OnUpdate", function(self, elapsed)
	PitchTimer_Int = PitchTimer_Int - elapsed;
	ElapsedSinceChange = ElapsedSinceChange + elapsed;
	if (PitchTimer_Int <= 0) then
		if ( ((db.visibility.flying and IsFlying()) or (db.visibility.swimming and IsSwimming() and not UnitOnTaxi("player"))) and (db.visibility.combat or not UnitAffectingCombat("player")) ) then
			-- Show Pitch display, update pitch and increase update rate
			if not PitchVisible then
				ElapsedSinceChange = 0;
				FlyPitch:UpdateShown(true);
			end
			FlyPitch:UpdatePitch();
			PitchTimer_Int = db.animation.update;
		else
			-- Hide Pitch display and decrease update rate
			if PitchVisible then
				FlyPitch:UpdateShown(false);
			end
			PitchTimer_Int = 0.5;
			ElapsedSinceChange = 0;
		end		
	end
end);

-- Update Pitch display to current pitch
function FlyPitch:UpdatePitch()
	local OldPitch = CurPitch;
	CurPitch = GetUnitPitch("player") * 360 / (2 * math.pi);
	
	-- Limit Pitch to normal max limits (incase people activate Barrel Rolls on their flyers)
	if CurPitch > PitchLimit then CurPitch = PitchLimit end
	if CurPitch < -PitchLimit then CurPitch = -PitchLimit end
	
	-- Fader
	if OldPitch ~= CurPitch then
		ElapsedSinceChange = 0;
		if PitchFaded then FlyPitch:Fade(true); end
	else
		if ElapsedSinceChange > db.animation.fader.timeuntilfade and not PitchFaded then
			FlyPitch:Fade(false);
		end
	end	
	
	-- Move Mover
	local yPos = CurPitch * ((db.size.height / 2) / PitchLimit);
	PitchFrame.Mover.frame:SetPoint("CENTER", PitchFrame.Main, "CENTER", 0, yPos);
	
	-- Update textures if changing between Up/Down/Center 
	if ((CurPitch < PitchCenterPoint and CurPitch > -PitchCenterPoint) and (PitchDirection ~= 0)) then
		-- Center
		PitchFrame.Center.bg:SetTexture(PitchTextures.Center);
		PitchFrame.Mover.bg:SetTexture(PitchTextures.MoverCenter);
		PitchFrame.LimitArrow.frame:Hide();
		
		PitchDirection = 0;
	elseif ((CurPitch >= PitchCenterPoint) and (PitchDirection ~= 1)) then
		-- Up
		PitchFrame.Center.bg:SetTexture(PitchTextures.ArrowSmallR);
		PitchFrame.Mover.bg:SetTexture(PitchTextures.MoverR);
		PitchFrame.LimitArrow.bg:SetTexture(PitchTextures.ArrowLargeR);
		PitchFrame.LimitArrow.frame:SetPoint("CENTER", PitchFrame.Main, "CENTER", 0, (db.size.height / 2) + 4);
		PitchFrame.LimitArrow.frame:Show();
		
		PitchDirection = 1;
	elseif ((CurPitch <= -PitchCenterPoint) and (PitchDirection ~= -1)) then
		-- Down
		PitchFrame.Center.bg:SetTexture(PitchTextures.ArrowSmall);
		PitchFrame.Mover.bg:SetTexture(PitchTextures.Mover);
		PitchFrame.LimitArrow.bg:SetTexture(PitchTextures.ArrowLarge);
		PitchFrame.LimitArrow.frame:SetPoint("CENTER", PitchFrame.Main, "CENTER", 0, -(db.size.height / 2) - 4);
		PitchFrame.LimitArrow.frame:Show();
		
		PitchDirection = -1;
	end
	
end


---- VISIBILITY
-- Fade In/Out the Pitch display
function FlyPitch:Fade(val)
	if val then
		UIFrameFadeIn(PitchFrame.Main, 0, 1, 1);
		PitchFaded = false;
	else
		UIFrameFadeOut(PitchFrame.Main, 0.5, 1, db.animation.fader.alpha);
		PitchFaded = true;
	end
end

-- Show/Hide the Pitch display
function FlyPitch:UpdateShown(shown)
	if shown then
		PitchFrame.Main:Show();
		PitchVisible = true;
	else
		PitchFrame.Main:Hide();
		PitchVisible = false;
	end
end


---- FRAME PROPERTIES
-- Set Colors
function FlyPitch:UpdateColors()
	for i, v in pairs(db.elements) do
	  local class, classFileName = UnitClass("player")
		local color = RAID_CLASS_COLORS[classFileName]
		PitchFrame[i].bg:SetVertexColor(db.elements[i].color.r, db.elements[i].color.g, db.elements[i].color.b, db.elements[i].color.a);
	end
end

-- Set Size
function FlyPitch:UpdateSize()
	-- Main
	PitchFrame.Main:SetHeight(db.size.height);
	PitchFrame.Main:SetWidth(128);
	PitchFrame.Main:SetScale(db.size.scale);
	
	-- Elements
	for i, v in pairs(db.elements) do
		PitchFrame[i].frame:SetHeight(db.elements[i].size.height);
		PitchFrame[i].frame:SetWidth(db.elements[i].size.width);
	end
end

-- Set Position
function FlyPitch:UpdatePosition()
	local Parent = _G[db.position.parent] or UIParent;
	
	-- Main
	PitchFrame.Main:SetParent(Parent);
	PitchFrame.Main:ClearAllPoints();
	PitchFrame.Main:SetPoint(db.position.anchorfrom, Parent, db.position.anchorto, db.position.x, db.position.y);
	PitchFrame.Main:SetFrameStrata(db.framelevel.strata);
	PitchFrame.Main:SetFrameLevel(db.framelevel.level);
	
	-- Elements
	for i, v in pairs(db.elements) do
		PitchFrame[i].frame:SetFrameStrata(db.framelevel.strata);
		PitchFrame[i].frame:SetFrameLevel(db.framelevel.level + 1);
	end
	
	-- Make Mover one step higher
	PitchFrame.Mover.frame:SetFrameLevel(db.framelevel.level + 2);
	
	-- Update LimitArrow position in-case they're changing sizes in config
	if PitchDirection == 1 then
		-- Up
		PitchFrame.LimitArrow.frame:SetPoint("CENTER", PitchFrame.Main, "CENTER", 0, (db.size.height / 2) + 4);
	elseif PitchDirection == -1 then
		-- Down
		PitchFrame.LimitArrow.frame:SetPoint("CENTER", PitchFrame.Main, "CENTER", 0, -(db.size.height / 2) - 4);
	end
end


---- EVENTS
function FlyPitch:PLAYER_ENTERING_WORLD()
	FlyPitch:UpdatePosition();
end


---- FRAME CREATION
local function CreateArtFrame(parent)
	local NewArtFrame = {frame = nil, bg = nil};
	NewArtFrame.frame = CreateFrame("Frame", nil, parent);
	NewArtFrame.bg = NewArtFrame.frame:CreateTexture(nil, "ARTWORK");
	return NewArtFrame;
end

local function CreateFrames()
	if not PitchFrame then
		PitchFrame = {
			Main = nil,
			Mover = nil,
			Center = nil,
			LimitArrow = nil,
		};
		
		-- Main
		PitchFrame.Main = CreateFrame("Frame", "FlyPitch_Frame", UIParent);
		PitchFrame.Main:Hide();
		
		-- Elements
		for i, v in pairs(db.elements) do
			PitchFrame[i] = CreateArtFrame(PitchFrame.Main);
			
			PitchFrame[i].frame:SetParent(PitchFrame.Main);
			PitchFrame[i].frame:ClearAllPoints();
			PitchFrame[i].frame:SetPoint("CENTER", PitchFrame.Main, "CENTER", 0, 0);
			
			PitchFrame[i].bg:SetAllPoints(PitchFrame[i].frame);
		end
		
		PitchFrame.LimitArrow.bg:SetTexture(ArrowLarge);
	end
end


---- INIT
function FlyPitch:ProfChange()
	db = self.db.profile;
	FlyPitch:ConfigRefresh();
	FlyPitch:Refresh();
end

function FlyPitch:Refresh()
	FlyPitch:UpdateSize();
	FlyPitch:UpdatePosition();	
	FlyPitch:UpdateColors();
end

function FlyPitch:PLAYER_LOGIN()
	FlyPitch:Refresh();
	PitchTimer:Show();
end

function FlyPitch:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("FlyPitchDB", defaults, "Default");
		
	self.db.RegisterCallback(self, "OnProfileChanged", "ProfChange");
	self.db.RegisterCallback(self, "OnProfileCopied", "ProfChange");
	self.db.RegisterCallback(self, "OnProfileReset", "ProfChange");
	
	FlyPitch:SetUpOptions();
	
	db = self.db.profile;
	
	CreateFrames();
	
	self:RegisterEvent("PLAYER_LOGIN");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end