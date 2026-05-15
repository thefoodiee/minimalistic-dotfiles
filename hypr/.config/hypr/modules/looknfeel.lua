---------------------
--- LOOK AND FEEL ---
---------------------
local colors = require("colors")
hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 1,

		border_size = 1,

		col = {
			active_border = colors.primary,
			inactive_border = colors.primary_container,
		},

		resize_on_border = false,

		allow_tearing = false,

		layout = "dwindle",
	},
})

hl.config({
	decoration = {
		rounding = 0,

		active_opacity = 1.0,
		inactive_opacity = 0.9,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			size = 12,
			passes = 3,
			new_optimizations = true,
			vibrancy = 0,
		},
	},
})

hl.config({
	dwindle = {
		preserve_split = true,
		force_split = 2,
	},
})

hl.config({
	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = true,
	},

	debug = {
		vfr = true,
	},

  xwayland = {
    force_zero_scaling = true
  }
})
