#!/bin/bash

STATE_FILE="$HOME/.cache/hyprsunset_state"

# Default state
if [ ! -f "$STATE_FILE" ]; then
    echo "identity" > "$STATE_FILE"
fi

STATE=$(<"$STATE_FILE")

if [ "$STATE" = "identity" ]; then
    echo false
else
    echo true
fi
