#!/usr/bin/env bash

CONFIG="$HOME/.config/hypr/monitors.lua"

MODE="$1"

case "$MODE" in
1)
    cp $HOME/.config/hypr/monitors/laptop_only.lua $HOME/.config/hypr/monitors.lua
    notify-send "Displays" "Laptop only mode enabled"
    ;;

2)
    cp $HOME/.config/hypr/monitors/hdmi_only.lua $HOME/.config/hypr/monitors.lua
    notify-send "Displays" "HDMI only mode enabled"
    ;;

3)
    cp $HOME/.config/hypr/monitors/laptop_left.lua $HOME/.config/hypr/monitors.lua
    notify-send "Displays" "Laptop left mode enabled"
    ;;

4)
    cp $HOME/.config/hypr/monitors/laptop_right.lua $HOME/.config/hypr/monitors.lua
    notify-send "Displays" "Laptop right mode enabled"
    ;;
*)
    echo "Usage: $0 {1|2|3|4}"
    echo "  1 = Laptop screen only"
    echo "  2 = External monitor only"
    echo "  3 = Laptop Left"
    echo "  4 = Laptop Right"
    exit 1
    ;;
esac

pkill -x waybar && waybar
