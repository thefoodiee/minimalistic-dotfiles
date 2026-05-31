require('modules.animations')

require('modules.autostart')

require('modules.env')

require('modules.input')

require('modules.looknfeel')

require('modules.windowrules')

require('modules.workspaces')

require('modules.keybindings.system')

require('modules.keybindings.user-system')

require('modules.keybindings.user')

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60",
	position = "auto",
	scale = "1.0",
})

hl.monitor({
	output = "eDP-1",
	mode = "2880x1800@60",
	position = "auto",
	scale = "1.0",
  supports_hdr = 0,
  disabled = true
})

