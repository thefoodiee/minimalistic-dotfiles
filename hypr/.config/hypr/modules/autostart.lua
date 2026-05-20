-----------------
--- AUTOSTART ---
-----------------
hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("hyprctl setcursor Win10OS-cursors 30")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg")
	hl.exec_cmd("clipse -listen")
	hl.exec_cmd("udiskie")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("$HOME/.config/hypr/scripts/wallpaper_loop.sh")
	hl.exec_cmd("$HOME/.config/hypr/scripts/power.sh")
	hl.exec_cmd("wl-clip-persist --clipboard regular")
end)

