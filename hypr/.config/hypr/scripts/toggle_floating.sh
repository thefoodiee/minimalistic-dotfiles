#!/bin/bash

# Define your desired fixed floating size
FIXED_FLOAT_WIDTH=1500
FIXED_FLOAT_HEIGHT=900

# Get active window info in JSON format
WINDOW_INFO=$(hyprctl activewindow -j)

# Extract the floating status
# Requires 'jq' - install with 'sudo apt install jq' or 'sudo pacman -S jq'
IS_FLOATING=$(echo "$WINDOW_INFO" | jq -r '.floating')

if [ "$IS_FLOATING" = "true" ]; then
    # If the window is currently floating, toggle it back to tiled.
    # Hyprland's 'togglefloating' typically restores the size it had before it was made floating.
    hyprctl dispatch togglefloating
else
    # If the window is currently tiled, make it floating, resize, and center.
    hyprctl dispatch togglefloating
    hyprctl dispatch resizeactive exact "$FIXED_FLOAT_WIDTH" "$FIXED_FLOAT_HEIGHT"
    hyprctl dispatch centerwindow
fi