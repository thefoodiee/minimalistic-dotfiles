#!/bin/bash

# Name of the Kitty window class or title to detect
WINDOW_CLASS="kitty"
WINDOW_TITLE="bluetuith"

# Check if a Kitty window running nmtui already exists
WINDOW_ADDRESS=$(hyprctl clients -j | jq -r \
    ".[] | select(.class == \"$WINDOW_CLASS\" and .title == \"$WINDOW_TITLE\") | .address")
  
if [ -n "$WINDOW_ADDRESS" ]; then
    # Close the window if found
    # hyprctl dispatch killwindow "address:$WINDOW_ADDRESS"
    hyprctl dispatch 'hl.dsp.window.close({window = "address:'"$WINDOW_ADDRESS"'"})'
else
    # Launch Kitty running bluetuith
    # kitty --title "$WINDOW_TITLE" bluetuith & disown
    hyprctl dispatch 'hl.dsp.exec_cmd("[workspace special:bluetuith; float; move 1330 44; size 580 460] kitty --class kitty-scratch -e bluetuith")'
fi
