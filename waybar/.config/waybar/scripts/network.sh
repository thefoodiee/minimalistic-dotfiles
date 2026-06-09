#!/bin/bash

# Name of the Kitty window class or title to detect
WINDOW_CLASS="kitty"
WINDOW_TITLE="wifitui"

# Check if a Kitty window running nmtui already exists
WINDOW_ADDRESS=$(hyprctl clients -j | jq -r \
    ".[] | select(.class == \"$WINDOW_CLASS\" and .title == \"$WINDOW_TITLE\") | .address")
  
if [ -n "$WINDOW_ADDRESS" ]; then
    # Close the window if found
    hyprctl dispatch 'hl.dsp.window.close({window = "address:'"$WINDOW_ADDRESS"'"})'
else
    # Launch Kitty running nmtui
    # kitty --title "$WINDOW_TITLE" wifitui & disown
    hyprctl dispatch 'hl.dsp.exec_cmd("[workspace special:wifitui; float; move 1330 44; size 580 460] kitty --class kitty-scratch -e wifitui")'
fi
