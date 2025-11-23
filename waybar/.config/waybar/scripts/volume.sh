#!/bin/bash

# The correct class name for pavucontrol on your system
WINDOW_ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class == "org.pulseaudio.pavucontrol") | .address')

if [ -n "$WINDOW_ADDRESS" ]; then
    hyprctl dispatch killwindow "address:$WINDOW_ADDRESS"
else
    pavucontrol & disown
fi