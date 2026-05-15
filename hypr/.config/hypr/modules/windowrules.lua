------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------
local opacityApps = {
  "kitty",
  "spotify",
  "org.kde.dolphin",
}

for _, class in ipairs(opacityApps) do
  hl.window_rule({
    match = {
      class = class,
    },
    opacity = "0.9 0.9 1.0",
  })
end

local floatingApps = {
  "org.pulseaudio.pavucontrol",
  "blueman-manager",
}

for _, class in ipairs(floatingApps) do
  hl.window_rule({
    match = {
      class = class,
    },
    float = true,
    size = { 800, 500 },
    center = true,
  })
end

local floatKitty = {
  "wifitui",
  "clipse",
  "bluetuith"
}

for _, title in ipairs(floatKitty) do
  hl.window_rule({
    match = {
      class = "kitty",
      title = title
    },
    float = true,
    size = { 800, 500 },
    center = true
  })
end

hl.window_rule({
  match = {
    class = "wallpaper-picker",
    title = "wallpaper-picker"
  },
  float = true,
  size = { 800, 500 },
  center = true
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})
