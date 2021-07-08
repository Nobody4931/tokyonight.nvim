local tn_black      = "#32344a"
local tn_red        = "#f7768e"
local tn_green      = "#9ece6a"
local tn_yellow     = "#e0af68"
local tn_blue       = "#7aa2f7"
local tn_magenta    = "#ad8ee6"
local tn_cyan       = "#449dab"
local tn_white      = "#9699a8"

local tn_bblack     = "#444b6a"
local tn_bred       = "#ff7a93"
local tn_bgreen     = "#b9f27c"
local tn_byellow    = "#ff9e64"
local tn_bblue      = "#7da6ff"
local tn_bmagenta   = "#bb9af7"
local tn_bcyan      = "#0db9d7"
local tn_bwhite     = "#acb0d0"

local tn_swhite     = "#ffffff"
local tn_sgray1     = "#151515"
local tn_sgray2     = "#262626"
local tn_sgray3     = "#4f5b66"
local tn_sgray4     = "#666666"

local sec_b = { bg = tn_sgray2, fg = tn_swhite }
local sec_c = { bg = tn_sgray1, fg = tn_sgray3 }

return {
	normal = {
		a = { bg = tn_magenta, fg = tn_swhite },
		b = sec_b,
		c = sec_c
	},

	insert = {
		a = { bg = tn_blue, fg = tn_swhite },
		b = sec_b,
		c = sec_c
	},

	visual = {
		a = { bg = tn_green, fg = tn_swhite },
		b = sec_b,
		c = sec_c
	},

	replace = {
		a = { bg = tn_red, fg = tn_swhite },
		b = sec_b,
		c = sec_c
	},

	command = {
		a = { bg = tn_magenta, fg = tn_swhite },
		b = sec_b,
		c = sec_c
	},

	inactive = {
		a = { bg = tn_sgray2, fg = tn_sgray4 },
		b = sec_b,
		c = sec_c
	}
}
