------------------------
--- SYSTEM SHORTCUTS ---
------------------------

local mainMod = "SUPER"
local left = "h"
local right = "l"
local up = "k"
local down = "j"

-----------------
--- WORKSPACES ---
-----------------

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

---------------
--- WINDOWS ---
---------------

-- resize windows
hl.bind(mainMod .. " + apostrophe", hl.dsp.window.resize({x = 50, y = 0, relative = true}))
hl.bind(mainMod .. " + semicolon", hl.dsp.window.resize({x = -50, y = 0, relative = true}))
hl.bind(mainMod .. " + bracketLeft", hl.dsp.window.resize({x = 0, y = -50, relative = true}))
hl.bind(mainMod .. " + slash", hl.dsp.window.resize({x = 0, y = 50, relative = true}))

-- move windows in workspace
hl.bind(mainMod .. " + SHIFT + " .. left, hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + " .. right, hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + " .. up, hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + " .. down, hl.dsp.window.move({ direction = "down" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + " .. left, hl.dsp.focus({direction = "left"}))
hl.bind(mainMod .. " + " .. right, hl.dsp.focus({direction = "right"}))
hl.bind(mainMod .. " + " .. up, hl.dsp.focus({direction = "up"}))
hl.bind(mainMod .. " + " .. down, hl.dsp.focus({direction = "down"}))

-- fullscreen
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({mode = "fullscreen", action = "toggle"}))

-- toggle layout
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit")) -- dwindle only

-- quit app
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-------------------------
--- UTILITY SHORTCUTS ---
-------------------------

-- media shortcuts
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
