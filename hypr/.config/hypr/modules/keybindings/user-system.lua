-------------------------------------
--- USER DEFINED SYSTEM SHORTCUTS ---
-------------------------------------

local mainMod = "SUPER"
local left = "h"
local right = "l"
local up = "k"
local down = "j"

local screenshot = 'hyprshot -m region -o "' .. os.getenv("HOME") .. '/Pictures/Screenshots"'

-- audio
-- hl.bind("F12", hl.dsp.exec_cmd("swayosd-client  --player spotify --playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("swayosd-client  --player spotify --playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("swayosd-client  --player spotify --playerctl next"))
hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd("[workspace special:kitty-sinkswitch; float; move 1430 44; size 480 160] kitty --class kitty-scratch -e ~/.config/hypr/scripts/sinkswitch.sh -exclude 46"))


-- wifi and bluetooth
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("$HOME/.config/waybar/scripts/network.sh"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("$HOME/.config/waybar/scripts/bluetooth.sh"))

-- window
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- wallpaper
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("$HOME/.local/bin/wallselect"))

-- system
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("ALT + F4", hl.dsp.exec_cmd("pkill wlogout || wlogout"))
hl.bind("switch:[Lid Switch]", hl.dsp.exec_cmd("hyprlock"))

-- clipse
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("kitty --class clipse -e 'clipse'"))


-- screenshot
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot))
hl.bind("Print", hl.dsp.exec_cmd(screenshot))

-- hyprpicker
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("hyprpicker -a"))

-- custom rofi menus
hl.bind(mainMod .. " + Period", hl.dsp.exec_cmd("pkill rofi || $HOME/.config/rofi/launchers/type-1/launcher-emoji.sh"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("$HOME/.config/rofi/launchers/type-1/launcher.sh"))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), {repeating = true})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), {repeating = true})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), {repeating = true})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute_toggle"), {repeating = true})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness +2"), {repeating = true})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -2"), {repeating = true})

-- debug
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("pkill -x waybar || waybar"))
