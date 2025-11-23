#!/bin/bash

CONF="$HOME/.config/hypr/monitors.conf"
LAPTOP="eDP-1"

if grep -q "^monitor=$LAPTOP,disable" "$CONF"; then
    echo "Enabling $LAPTOP"
    sed -i "s/^monitor=$LAPTOP,disable/monitor=$LAPTOP,2880x1800@60.0,0x0,1.8/" "$CONF"
else
    echo "Disabling $LAPTOP"
    # append disable after enabling line
    echo "monitor=$LAPTOP,disable" >> "$CONF"
fi

# Reload config
hyprctl reload
