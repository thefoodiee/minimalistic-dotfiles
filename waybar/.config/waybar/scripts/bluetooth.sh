#!/bin/bash

# Get the address of the nm-connection-editor window
# Requires 'jq' - install with 'sudo apt install jq' or 'sudo pacman -S jq'
WINDOW_ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class == "blueman-manager") | .address')

if [ -n "$WINDOW_ADDRESS" ]; then
    # If the window exists, close it
    hyprctl dispatch killwindow "address:$WINDOW_ADDRESS"
else
    # If the window does not exist, open nm-connection-editor
    blueman-manager & disown
fi