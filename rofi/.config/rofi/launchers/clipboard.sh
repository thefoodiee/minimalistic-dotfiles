#!/usr/bin/env bash
#  ┓ ┏┓┳┳┳┓┏┓┓┏┏┓┳┓
#  ┃ ┣┫┃┃┃┃┃ ┣┫┣ ┣┫
#  ┗┛┛┗┗┛┛┗┗┛┛┗┗┛┛┗
#                  


# Style-dir
style_dir="$HOME/.config/rofi/applets"

# Style-theme
style_theme='clipboard'

cliphist_script="$HOME/.config/rofi/scripts/clipboard"
# Run
# pkill rofi || true && rofi -show drun -theme ${style_dir}/${style_theme}.rasi
# pkill rofi || true && rofi -modi clipboard:$HOME/.config/rofi/scripts/clipboard.sh -show clipboard -show-icons -theme ${style_dir}/${style_theme}.rasi
# pkill rofi || true && cliphist list | rofi -dmenu -theme ${style_dir}/${style_theme}.rasi -display-columns 2 | cliphist decode | tee >(wl-copy) | (sleep 0.1 && xargs -0 wtype)

pkill rofi || true && rofi -modi "clipboard:${cliphist_script}" -show clipboard -show-icons -theme ${style_dir}/${style_theme}.rasi
