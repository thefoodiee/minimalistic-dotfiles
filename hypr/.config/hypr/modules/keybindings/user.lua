----------------------
--- USER SHORTCUTS ---
----------------------

local mainMod = "SUPER"

local terminal = "kitty -1"
local fileManager = "dolphin"
local browser = "brave --enable-features=TouchpadOverscrollHistoryNavigation"
local task_manager = "gnome-system-monitor"
local code = "alacritty"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(task_manager))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(code))
