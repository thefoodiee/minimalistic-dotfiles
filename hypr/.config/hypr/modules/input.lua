--------------
--- INPUT ---
--------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:escape",
		kb_rules = "",
    numlock_by_default = true,

		follow_mouse = 1,

		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.3,
			drag_lock = 2,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.gesture({
	fingers = 4,
	direction = "up",
	action = function()
		hl.exec_cmd("swayosd-client --output-volume raise")
	end,
})

hl.gesture({
	fingers = 4,
	direction = "down",
	action = function()
		hl.exec_cmd("swayosd-client --output-volume lower")
	end,
})

hl.gesture({
	fingers = 4,
	direction = "left",
	action = function()
		hl.exec_cmd("swayosd-client  --player spotify --playerctl previous")
	end,
})

hl.gesture({
	fingers = 4,
	direction = "right",
	action = function()
		hl.exec_cmd("swayosd-client --player spotify --playerctl next")
	end,
})
