#!/bin/bash

# Name of the Kitty window class or title to detect
WINDOW_CLASS="kitty"
WINDOW_TITLE="wifitui"

# Check if a Kitty window running nmtui already exists
WINDOW_ADDRESS=$(hyprctl clients -j | jq -r \
    ".[] | select(.class == \"$WINDOW_CLASS\" and .title == \"$WINDOW_TITLE\") | .address")
  
if [ -n "$WINDOW_ADDRESS" ]; then
    # Close the window if found
    hyprctl dispatch killwindow "address:$WINDOW_ADDRESS"
else
    # Launch Kitty running nmtui
    kitty --title "$WINDOW_TITLE" wifitui & disown
fi
