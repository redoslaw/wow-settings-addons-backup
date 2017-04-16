
FI_SVPC_CONFIG = {
	["show"] = true,
	["Currency"] = {
		["show"] = true,
		["scale"] = 1,
		["alpha"] = 1,
		["tracking"] = true,
	},
	["version"] = 2.38,
	["scale"] = 1,
	["move"] = true,
	["alpha"] = 1,
	["style"] = "default",
}
FI_SVPC_STYLE = {
	["anchor"] = {
		["pad"] = 2,
		["text"] = {
			["flags"] = "OUTLINE",
			["font"] = "Fonts/ARIALN.TTF",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
			},
			["alpha"] = 1,
			["size"] = 13,
		},
		["background"] = {
			["color"] = {
			},
			["texture"] = "Interface/BUTTONS/UI-QuickSlot",
			["alpha"] = 0.75,
			["size"] = {
				56, -- [1]
				56, -- [2]
			},
		},
		["border"] = {
			["offset"] = 2,
			["tile"] = true,
			["color"] = {
			},
			["texture"] = "",
			["alpha"] = 1,
			["size"] = 6,
		},
		["size"] = {
			34, -- [1]
			34, -- [2]
		},
	},
	["button"] = {
		["number"] = {
			["flags"] = "OUTLINE",
			["font"] = "Fonts/ARIALN.TTF",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
			},
			["alpha"] = 1,
			["size"] = 14,
		},
		["glow"] = {
			["color"] = {
				0.3, -- [1]
				0.3, -- [2]
				0.3, -- [3]
			},
			["alpha"] = 0.9,
		},
		["pad"] = 5,
		["background"] = {
			["color"] = {
			},
			["texture"] = "Interface/BUTTONS/UI-EmptySlot.blp",
			["alpha"] = 0.75,
			["size"] = {
				66, -- [1]
				66, -- [2]
			},
		},
		["text"] = {
			["flags"] = "OUTLINE",
			["font"] = "Fonts/FRIZQT__.TTF",
			["color"] = {
				0.5, -- [1]
				0.5, -- [2]
				0.5, -- [3]
			},
			["alpha"] = 0.75,
			["size"] = 14,
		},
		["border"] = {
			["offset"] = 2,
			["tile"] = true,
			["texture"] = "",
			["alpha"] = 0.9,
			["size"] = 6,
		},
		["size"] = {
			37, -- [1]
			37, -- [2]
		},
	},
}
FI_SVPC_DATA = {
	["Sessions"] = {
		{
			["id"] = 1,
			["stop"] = 1492269326,
			["start"] = 1492264495,
		}, -- [1]
		{
			["id"] = 2,
			["stop"] = 1492281053,
			["start"] = 1492269771,
		}, -- [2]
		{
			["id"] = 3,
			["stop"] = 1492355804,
			["start"] = 1492304263,
		}, -- [3]
		{
			["id"] = 4,
			["stop"] = 1492358774,
			["start"] = 1492358723,
		}, -- [4]
		{
			["id"] = 5,
			["stop"] = 1492359259,
			["start"] = 1492359213,
		}, -- [5]
		{
			["id"] = 6,
			["stop"] = 1492367950,
			["start"] = 1492362958,
		}, -- [6]
		{
			["id"] = 7,
			["stop"] = 0,
			["start"] = 1492370630,
		}, -- [7]
	},
	["Currencies"] = {
		{
			["count"] = 8228,
			["success"] = true,
			["objective"] = 0,
			["id"] = 1,
			["lastcount"] = 8228,
			["icon"] = "Interface\\Icons\\inv_garrison_resource",
			["name"] = "Garrison Resources",
		}, -- [1]
		{
			["count"] = 0,
			["success"] = true,
			["objective"] = 0,
			["id"] = 2,
			["lastcount"] = 0,
			["icon"] = "",
			["name"] = "",
		}, -- [2]
		{
			["count"] = 0,
			["success"] = true,
			["objective"] = 0,
			["id"] = 3,
			["lastcount"] = 0,
			["icon"] = "",
			["name"] = "",
		}, -- [3]
	},
	["Groups"] = {
		{
			["show"] = true,
			["grow"] = "U",
			["move"] = false,
			["id"] = 1,
			["scale"] = 1,
			["pad"] = 5,
			["alpha"] = 1,
			["size"] = 7,
		}, -- [1]
	},
	["Buttons"] = {
		{
			["objective"] = 0,
			["success"] = false,
			["count"] = 1079,
			["group"] = 1,
			["lastcount"] = 0,
			["id"] = 1,
			["item"] = 123918,
			["bank"] = false,
		}, -- [1]
		{
			["success"] = false,
			["objective"] = 0,
			["count"] = 410,
			["id"] = 2,
			["group"] = 1,
			["lastcount"] = 0,
			["item"] = 123919,
			["bank"] = false,
		}, -- [2]
		{
			["success"] = false,
			["objective"] = 0,
			["count"] = 0,
			["id"] = 3,
			["group"] = 1,
			["lastcount"] = 0,
			["item"] = 124105,
			["bank"] = false,
		}, -- [3]
		{
			["objective"] = 608,
			["success"] = false,
			["count"] = 0,
			["group"] = 1,
			["lastcount"] = 0,
			["id"] = 4,
			["item"] = 124102,
			["bank"] = true,
		}, -- [4]
		{
			["item"] = 128304,
			["count"] = 0,
			["objective"] = 0,
			["lastcount"] = 0,
			["id"] = 5,
			["group"] = 1,
			["success"] = false,
			["bank"] = false,
		}, -- [5]
		{
			["success"] = false,
			["item"] = 124104,
			["objective"] = 830,
			["group"] = 1,
			["lastcount"] = 0,
			["id"] = 6,
			["count"] = 0,
			["bank"] = false,
		}, -- [6]
		{
			["objective"] = 0,
			["success"] = false,
			["count"] = 112,
			["group"] = 1,
			["lastcount"] = 0,
			["id"] = 7,
			["item"] = 124124,
			["bank"] = false,
		}, -- [7]
		{
			["objective"] = 0,
			["success"] = false,
			["count"] = 0,
			["group"] = 1,
			["lastcount"] = 0,
			["id"] = 8,
			["item"] = false,
			["bank"] = false,
		}, -- [8]
		{
			["objective"] = 0,
			["success"] = false,
			["count"] = 0,
			["group"] = 1,
			["lastcount"] = 0,
			["id"] = 9,
			["item"] = false,
			["bank"] = false,
		}, -- [9]
		{
			["objective"] = 0,
			["success"] = false,
			["count"] = 0,
			["group"] = 1,
			["lastcount"] = 0,
			["id"] = 10,
			["item"] = false,
			["bank"] = false,
		}, -- [10]
		{
			["objective"] = 0,
			["success"] = false,
			["count"] = 0,
			["group"] = 1,
			["lastcount"] = 0,
			["id"] = 11,
			["item"] = false,
			["bank"] = false,
		}, -- [11]
		{
			["objective"] = 0,
			["success"] = false,
			["count"] = 0,
			["group"] = 1,
			["lastcount"] = 0,
			["id"] = 12,
			["item"] = false,
			["bank"] = false,
		}, -- [12]
	},
}
FI_SVPC_CACHE = {
	["Currencies"] = {
		{
			["name"] = "Garrison Resources",
			["count"] = 8228,
			["objective"] = 0,
			["id"] = 1,
			["lastcount"] = 8228,
			["icon"] = "Interface\\Icons\\inv_garrison_resource",
			["success"] = true,
		}, -- [1]
		{
			["name"] = "",
			["count"] = 0,
			["objective"] = 0,
			["id"] = 2,
			["lastcount"] = 0,
			["icon"] = "",
			["success"] = true,
		}, -- [2]
		{
			["name"] = "",
			["count"] = 0,
			["objective"] = 0,
			["id"] = 3,
			["lastcount"] = 0,
			["icon"] = "",
			["success"] = true,
		}, -- [3]
	},
}
