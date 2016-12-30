local FlyPitch = LibStub("AceAddon-3.0"):GetAddon("FlyPitch");
local db;

local table_AnchorPoints = {
	"BOTTOM",
	"BOTTOMLEFT",
	"BOTTOMRIGHT",
	"CENTER",
	"LEFT",
	"RIGHT",
	"TOP",
	"TOPLEFT",
	"TOPRIGHT",
};

local table_Strata = {
	"BACKGROUND",
	"LOW",
	"MEDIUM",
	"HIGH",
	"DIALOG",
	"TOOLTIP",
};


local function ValidateOffset(value)
	val = tonumber(value);
	if val == nil then val = 0; end;
	if val < -5000 then val = 5000 elseif val > 5000 then val = 5000; end;
	return val;
end

-- Return the Options table
local options = nil;
local function GetOptions()
	if not options then
		options = {
			type = "group",
			name = "FlyPitch",
			handler = FlyPitch,
			childGroups = "tab",
			args = {
				visibility = {
					name = "Visibility",
					type = "group",
					order = 10,
					args = {
						flying = {
							type = "toggle",
							name = "Flying",
							desc = "Show the Pitch display while flying.",
							get = function() return db.visibility.flying end,
							set = function(info, value) 
								db.visibility.flying = value;
							end,
							order = 10,
						},
						swimming = {
							type = "toggle",
							name = "Swimming",
							desc = "Show the Pitch display while swimming.",
							get = function() return db.visibility.swimming end,
							set = function(info, value) 
								db.visibility.swimming = value;
							end,
							order = 20,
						},
						combat = {
							type = "toggle",
							name = "Combat",
							desc = "Show the Pitch display while in combat.",
							get = function() return db.visibility.combat end,
							set = function(info, value) 
								db.visibility.combat = value;
							end,
							order = 30,
						},
					},
				},
				position = {
					name = "Position",
					type = "group",
					order = 20,
					args = {
						offset = {
							type = "group",
							name = "Offset",
							inline = true,
							order = 10,									
							args = {
								x = {
									type = "input",
									name = "X Offset",
									width = "half",
									order = 10,
									get = function(info) return tostring(db.position.x) end,
									set = function(info, value)
										value = ValidateOffset(value)
										db.position.x = value
										FlyPitch:UpdatePosition()
									end,
								},
								y = {
									type = "input",
									name = "Y Offset",
									width = "half",
									order = 20,
									get = function(info) return tostring(db.position.y) end,
									set = function(info, value)
										value = ValidateOffset(value)
										db.position.y = value
										FlyPitch:UpdatePosition()
									end,
								},
							},
						},
						anchors = {
							type = "group",
							name = "Anchors",
							inline = true,
							order = 20,									
							args = {
								anchorto = {
									type = "select",
									name = "Anchor To",
									get = function(info) 
										for k,v in pairs(table_AnchorPoints) do
											if v == db.position.anchorto then return k end
										end
									end,
									set = function(info, value)
										db.position.anchorto = table_AnchorPoints[value]
										FlyPitch:UpdatePosition()
									end,
									style = "dropdown",
									width = nil,
									values = table_AnchorPoints,
									order = 10,
								},
								anchorfrom = {
									type = "select",
									name = "Anchor From",
									get = function(info) 
										for k,v in pairs(table_AnchorPoints) do
											if v == db.position.anchorfrom then return k end
										end
									end,
									set = function(info, value)
										db.position.anchorfrom = table_AnchorPoints[value]
										FlyPitch:UpdatePosition()
									end,
									style = "dropdown",
									width = nil,
									values = table_AnchorPoints,
									order = 20,
								},
								parent = {
									type = "input",
									name = "Parent",
									get = function(info) return db.position.parent end,
									set = function(info, value) db.position.parent = value; FlyPitch:UpdatePosition(); end,
									order = 30,
								},
							},
						},						
					},
				},
				framelevel = {
					name = "Strata",
					type = "group",
					order = 30,
					args = {
						framestrata = {
							type = "select",
							name = "Frame Strata",
							get = function(info) 
								for k_ts,v_ts in pairs(table_Strata) do
									if v_ts == db.framelevel.strata then return k_ts end
								end
							end,
							set = function(info, value)
								db.framelevel.strata = table_Strata[value]
								FlyPitch:UpdatePosition()
							end,
							style = "dropdown",
							width = nil,
							values = table_Strata,
							order = 10,
						},
						level = {
							type = "range",
							name = "Frame Level",
							min = 1, max = 50, step = 1,
							get = function(info) return db.framelevel.level end,
							set = function(info, value) 
								db.framelevel.level = value
								FlyPitch:UpdatePosition()
							end,
							order = 20,
						},
					},
				},
				size = {
					name = "Size",
					type = "group",
					order = 40,
					args = {
						height = {
							type = "input",
							name = "Height",
							order = 10,
							get = function(info) return tostring(db.size.height) end,
							set = function(info, value)
								value = ValidateOffset(value)
								db.size.height = value
								FlyPitch:UpdateSize()
								FlyPitch:UpdatePosition()
								FlyPitch:UpdatePitch()
							end,
						},
						scale = {
							type = "range",
							name = "Scale",
							order = 20,
							min = 0.1, max = 2, step = 0.05,
							isPercent = true,
							get = function(info) return db.size.scale end,
							set = function(info, value) 
								db.size.scale = value
								FlyPitch:UpdateSize()
								FlyPitch:UpdatePosition()
							end,
						},
					},
				},
				animation = {
					name = "Animation",
					type = "group",
					order = 50,
					args = {
						update = {
							type = "range",
							name = "Update Interval",
							desc = "Lowering this will improve animation smoothness, but increase CPU usage.",
							order = 10,
							min = 0.01, max = 0.2, step = 0.01,
							get = function(info) return db.animation.update end,
							set = function(info, value) 
								db.animation.update = value
							end,
						},
						fader = {
							type = "group",
							name = "Fader",
							inline = true,
							order = 20,
							args = {
								timeuntilfade = {
									type = "range",
									name = "Fade-Out Time",
									desc = "Time to wait until fading out the Pitch display.",
									order = 10,
									min = 0, max = 10, step = 0.25,
									get = function(info) return db.animation.fader.timeuntilfade end,
									set = function(info, value) 
										db.animation.fader.timeuntilfade = value
									end,
								},
								alpha = {
									type = "range",
									name = "Fade-Out Opacity",
									order = 20,
									min = 0, max = 1, step = 0.05,
									get = function(info) return db.animation.fader.alpha end,
									set = function(info, value) 
										db.animation.fader.alpha = value
									end,
								},
							},
						},
					},
				},
				elements = {
					name = "Elements",
					type = "group",
					order = 60,
					args = {
						Center = {
							type = "group",
							name = "Center",
							order = 10,
							args = {
								color = {
									type = "color",
									name = "Color",
									hasAlpha = true,
									get = function(info,r,g,b,a)
										return db.elements.Center.color.r, db.elements.Center.color.g, db.elements.Center.color.b, db.elements.Center.color.a
									end,
									set = function(info,r,g,b,a)
										db.elements.Center.color.r = r
										db.elements.Center.color.g = g
										db.elements.Center.color.b = b
										db.elements.Center.color.a = a
										FlyPitch:UpdateColors()
									end,
									order = 10,
								},
								size = {
									name = "Size",
									type = "group",
									inline = true,
									order = 20,
									args = {
										height = {
											type = "input",
											name = "Height",
											order = 10,
											get = function(info) return tostring(db.elements.Center.size.height) end,
											set = function(info, value)
												value = ValidateOffset(value)
												db.elements.Center.size.height = value
												FlyPitch:UpdateSize()
												FlyPitch:UpdatePosition()
											end,
										},
										width = {
											type = "input",
											name = "Height",
											order = 20,
											get = function(info) return tostring(db.elements.Center.size.width) end,
											set = function(info, value)
												value = ValidateOffset(value)
												db.elements.Center.size.width = value
												FlyPitch:UpdateSize()
												FlyPitch:UpdatePosition()
											end,
										},
									},
								},
							},
						},
						Mover = {
							type = "group",
							name = "Mover",
							order = 20,
							args = {
								color = {
									type = "color",
									name = "Color",
									hasAlpha = true,
									get = function(info,r,g,b,a)
										return db.elements.Mover.color.r, db.elements.Mover.color.g, db.elements.Mover.color.b, db.elements.Mover.color.a
									end,
									set = function(info,r,g,b,a)
										db.elements.Mover.color.r = r
										db.elements.Mover.color.g = g
										db.elements.Mover.color.b = b
										db.elements.Mover.color.a = a
										FlyPitch:UpdateColors()
									end,
									order = 10,
								},
								size = {
									name = "Size",
									type = "group",
									inline = true,
									order = 20,
									args = {
										height = {
											type = "input",
											name = "Height",
											order = 10,
											get = function(info) return tostring(db.elements.Mover.size.height) end,
											set = function(info, value)
												value = ValidateOffset(value)
												db.elements.Mover.size.height = value
												FlyPitch:UpdateSize()
												FlyPitch:UpdatePosition()
											end,
										},
										width = {
											type = "input",
											name = "Height",
											order = 20,
											get = function(info) return tostring(db.elements.Mover.size.width) end,
											set = function(info, value)
												value = ValidateOffset(value)
												db.elements.Mover.size.width = value
												FlyPitch:UpdateSize()
												FlyPitch:UpdatePosition()
											end,
										},
									},
								},
							},
						},
						LimitArrow = {
							type = "group",
							name = "Limit Arrow",
							order = 30,
							args = {
								color = {
									type = "color",
									name = "Color",
									hasAlpha = true,
									get = function(info,r,g,b,a)
										return db.elements.LimitArrow.color.r, db.elements.LimitArrow.color.g, db.elements.LimitArrow.color.b, db.elements.LimitArrow.color.a
									end,
									set = function(info,r,g,b,a)
										db.elements.LimitArrow.color.r = r
										db.elements.LimitArrow.color.g = g
										db.elements.LimitArrow.color.b = b
										db.elements.LimitArrow.color.a = a
										FlyPitch:UpdateColors()
									end,
									order = 10,
								},
								size = {
									name = "Size",
									type = "group",
									inline = true,
									order = 20,
									args = {
										height = {
											type = "input",
											name = "Height",
											order = 10,
											get = function(info) return tostring(db.elements.LimitArrow.size.height) end,
											set = function(info, value)
												value = ValidateOffset(value)
												db.elements.LimitArrow.size.height = value
												FlyPitch:UpdateSize()
												FlyPitch:UpdatePosition()
											end,
										},
										width = {
											type = "input",
											name = "Height",
											order = 20,
											get = function(info) return tostring(db.elements.LimitArrow.size.width) end,
											set = function(info, value)
												value = ValidateOffset(value)
												db.elements.LimitArrow.size.width = value
												FlyPitch:UpdateSize()
												FlyPitch:UpdatePosition()
											end,
										},
									},
								},
							},
						},
					},
				},
			},
		};				
	end
	
	return options
end

function FlyPitch:ChatCommand(input)
	InterfaceOptionsFrame_OpenToCategory(self.profilesFrame)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	InterfaceOptionsFrame:Raise()
end

function FlyPitch:ConfigRefresh()
	db = self.db.profile;
end

function FlyPitch:SetUpOptions()
	db = self.db.profile;

	LibStub("AceConfig-3.0"):RegisterOptionsTable("FlyPitch", GetOptions);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("FlyPitch-Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db));
	
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FlyPitch", "FlyPitch");
	self.profilesFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FlyPitch-Profiles", "Profiles", "FlyPitch");
	
	self:RegisterChatCommand("FlyPitch", "ChatCommand");
end